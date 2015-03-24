﻿//-----------------------------------------------------------------------
// <copyright file="DynamicsStorefront.cs" company="Sitecore Corporation">
//     Copyright (c) Sitecore Corporation 1999-2015
// </copyright>
// <summary>Defines the DynamicsStorefront class.</summary>
//-----------------------------------------------------------------------
// Copyright 2015 Sitecore Corporation A/S
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file 
// except in compliance with the License. You may obtain a copy of the License at
//       http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under the 
// License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
// either express or implied. See the License for the specific language governing permissions 
// and limitations under the License.
// -------------------------------------------------------------------------------------------

namespace Sitecore.Reference.Storefront.Models.SitecoreItemModels
{
    using Sitecore.Data.Items;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;

    /// <summary>
    /// Defines the DynamicsStorefront class.
    /// </summary>
    public class DynamicsStorefront : CommerceStorefront
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="DynamicsStorefront"/> class.
        /// </summary>
        public DynamicsStorefront()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="DynamicsStorefront"/> class.
        /// </summary>
        /// <param name="item">The item.</param>
        public DynamicsStorefront(Item item)
            : base(item)
        {
        }

        /// <summary>
        /// Gets a value indicating whether [use ax checkout].
        /// </summary>
        /// <value>
        ///   <c>true</c> if [use ax checkout]; otherwise, <c>false</c>.
        /// </value>
        public bool UseAXCheckout
        {
            get
            {
                return MainUtil.GetBool(this.InnerItem[DynamicsStorefrontConstants.KnownFieldNames.UseAXCheckoutControl], false);
            }
        }
    }
}