Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA003AEB2C
	for <patches@lists.linux.dev>; Thu,  9 Jul 2026 21:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783631585; cv=fail; b=mBd2peag7n19/sLgg4kFosc4wytx8kMTZEBmog59LzFVlgc4oqnIM60TjtLJ/E760LfEPKVqcfdOAyv2pRqau/XIJEi7dXDBv+qo8pQEiFyHa0ZwtibqR+oGAEBvkFwfEPMZk6Kqil5ZHTLYC8vpGgxSFGxtLlX92YrqpeMBp2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783631585; c=relaxed/simple;
	bh=YElTU+EVD9hbbOB/NXMJ21ypAvR9+mJ42d2slwke/ec=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YpsbO/RFIeQInSKl4LCqTvIY5LWcpBEQ2Ea5iyePJF7qQSvP76ZbNkoLbTPafw0nxA4sukZjc0gojyoRBss7OC5T2Otqx1y/32nbRK0dxsGeeSb6grzAxqtVP/PJ6VOgkm2P7vjCih7sthcoW7H/7bR3EctVDQY12FI40Ik0JTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MynsSGy9; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MynsSGy9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783631584; x=1815167584;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YElTU+EVD9hbbOB/NXMJ21ypAvR9+mJ42d2slwke/ec=;
  b=MynsSGy9VmFt17BQAtOtOWKM1wfrVglfFZ2nRvlrAXRz0fkvz8r39/cT
   l+hEVXVHMrXk132n+gllwyfDYqwQ2TaSt71Py83YGHIRf/1G7y0dapvNZ
   7ASTYppalhgXssdBSJhRxubdiLnZ0pHKiAtm2DU7r2hf8hV4CDipThnn0
   72ssLry+UMUBsCCQD39hEJF2PriWGuQDNVTq67oyCQUEYKGrKhB2mE561
   i9LUOSdM7v27PXcwRZ+i5EOmOh76N/GmH4TSEVUqmylgSNpd9PE5HWOqa
   9XSgbhyoz7VC0WM2k6txdpJ0Bu52MayLvoblhMKwMG4T87bBKU/UgoLkq
   w==;
X-CSE-ConnectionGUID: R7YID5foSVyk70dUpgVS3g==
X-CSE-MsgGUID: i+4Jbx7ASgGr/HLcvhZM0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="94680415"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="94680415"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 14:13:04 -0700
X-CSE-ConnectionGUID: byITU+nrRdimJTvAibK6Ig==
X-CSE-MsgGUID: K59mefeGTbecytiz3xA2LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="284793446"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 14:13:03 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 9 Jul 2026 14:13:02 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Thu, 9 Jul 2026 14:13:02 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.0) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 9 Jul 2026 14:13:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oxxWpWi1qjSATjCYVxhylpwPPZ0oYkb005eQY1sdCG3xmagW6oc6S5oeZk6V2R42vNCxfYvUewlCW7icjuGG3sQ+aXg/brN37u2F/H8QdOsi7BAFMuN3NX4u+P/omJ9pmbLK5QX3KcmjDi2Cl+/xkpVaInfcXoI57xx6ja6PjZZ4GfM2toWwXW8D+fh34k4SfWTUZ5v5zo0GQAVzbgF4Xm+gKkO8dAl5WEXgSrH62/CibY9Bdxey+3KtA7JS5AnayDHpX7N1J2K0ELGLcRIvC0zoZggJBaXHJMrNX1MlDyon4v6PUOncY0KN/+NjsR2iZgeSqqQdwp0TlIUe6bkbcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8e84SPbYgl3jGJJN0zk76mly6OwkbhTUoXmNuCs6C8=;
 b=koMVWtVc9p/kdYlevh4h1oaxsiOdyW0sQj88msHwIyN3CRAYX/zzO3vtRDdkGDcCGmUkAupjcL0o4kpCpUXX0FGdZb1w0TnHWkVbIkSTcBojFvoPhFuBeN3sxljvBTLls6MlQgm8wO6MrYysInaS8ZSKtjTcxB2mfqZDrqYIRJU68YuX0OLDrG/dbxHw/0PUBySsg++jCt0mNerScjZ7qjcjHR9F5qaAUTtpWe+ZXu1Yz8VX64kZpBM4/jjLv6vuIKPx1amJf9nGfjA+6rCpUiEKCQICq6t7l9BL20BM0Hk5rpjc1Sj0bwt7Wutbxj0mVeq2VXI7LFOByKeLtC4xug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH0PR11MB4968.namprd11.prod.outlook.com (2603:10b6:510:39::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.13; Thu, 9 Jul
 2026 21:13:00 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 21:13:00 +0000
Date: Thu, 9 Jul 2026 14:12:58 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 01/12] platform/x86/intel/{pmt,vsec}: Prevent unbind
 via sysfs
Message-ID: <alAO2icyy4TKDH-g@agluck-desk3>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-2-tony.luck@intel.com>
 <e2a74402-791f-493e-9824-a5e4aec61b87@intel.com>
 <ak_dQX9j-hmtm7W6@agluck-desk3>
 <8c627385-b6d4-469d-bf99-b1cdf606bccc@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8c627385-b6d4-469d-bf99-b1cdf606bccc@intel.com>
X-ClientProxiedBy: BY5PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::34) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH0PR11MB4968:EE_
X-MS-Office365-Filtering-Correlation-Id: d1f810d0-2ba3-4107-97ad-08deddfedb07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|56012099006|18002099003|4143699003|22082099003|6133799003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info: qvDsz/wF9kTZmJHDDaiYhENstdF0DZ+jTRp5jBe0xhJ16nR8l5RmUPOkobOMFvoYVwnpWWEqxHhwSVMBndTjxvpoK0INDf1nlp3v8zf78myHqW1BYfjsd2xXOY9JGub4CkTbN66IUC7YpgkZsRYr5FlWj+jGHqa4dH6jdyIgnlliYTGaDiQghEo0RnCHOeUunQKi9Q53EIPc5JXVpaq1SSRK5enVUuEI6rFm3elwkHrQhdTg4vtfvTg44y5ZnnVIp7Qv67LqP67RbmuWQXCKB/IJwYV9sa3urDOEO6f5UdfC0k2Hb779PeFXSpbAJCDV/nXz3cFOBa3La1pfW4D24KyBpnby3vwTUl6Zxvx5a2YR1NrVuCNUyWEdH4ZsMhOc/WgYMbCNG8JD73Qc7cOR0yBMNMqKjz8lL6DTFiYFEEkvaD5P6KULJIp8ljX5KoWol2r2lI0Eok0fjhGnPdHvpyxyqxLU739291X9kDQKxcdqGQHBrWJBRDMtpJry6NGRwba3eLIECiHiSMq9nxOPi52Yj9iYjMRjA1g3OuG6WzDc15tlrZpak7Foaq8snZ2Us6kERb7/TP4AHdg5Ry4Jav3HgBMUHaIF8vw1FwQuMAGHO5oQSVI9KRKW7/DiXN9o6KTSLFxAhskHSSAeQa5FBFcAeb+ahuXWSA5TNKGIay4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(56012099006)(18002099003)(4143699003)(22082099003)(6133799003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TaN7yu2bzUT+aXZ/NoJzedC1E5oCHQILfmCk6PQy0SohVkN6sjxpGkH6Ud6q?=
 =?us-ascii?Q?WgnuyOosqSRAOeTpcrajOxxrIBy33wQGt77/YO2J+3o4z6/ACNypM7/6NPTH?=
 =?us-ascii?Q?tVhE0GV5iM05gvswbwWrf4brlaGrwcfloaBbDT7pMkHGMRsqPNorr33tFYWq?=
 =?us-ascii?Q?R7MJr8xwx2bQ3KqcWJe0H05jKMRe1PwVtlbZk0sFFLRe27HSIkchLu23nM8U?=
 =?us-ascii?Q?PqlLofNmZk1395eGwdYmfMvCQbD1gRNiu1U0APoEFRZIA6WzDXb6k+fzPKxW?=
 =?us-ascii?Q?L32MeHgz+e9i/uMH1PL3gva8zhPu7ZQtU8b0gU/i0vcOZFCxXik025H+LhOg?=
 =?us-ascii?Q?fzir3Hy/jDShF/Kw8hFtGUUiKsYfSYY/jxrFA9WexYPY73ZCn7xIo380lZna?=
 =?us-ascii?Q?DwGnjc5lVDlvfS/d5L+F3+yGIYa6lgqip8F94E8okzxG7/VWtYdkRvzCYfKx?=
 =?us-ascii?Q?K9Y8t8+hWu9tNwlVJvNDPbJkX7tIaOxFfTWHUrXQPfPIuaqpP46SwMbYEqsN?=
 =?us-ascii?Q?g7avrLzgprFArk/tN0I08WSWCSm1akYqYqtE0k6zqWlHwSigO2+HozLyObEy?=
 =?us-ascii?Q?PykACzYtjvOycKqNZ1rQcOezz8t9envOORDcmSisctulcx3CgnwTSAe3Lhu4?=
 =?us-ascii?Q?pqEORIlv6qeOlfGieAhWDImo+JHGUciBgeQ4nv+dYVCFzPcNwTn24/SHLW0K?=
 =?us-ascii?Q?+yAAI7ESB3fJ5n50Mf9bBBzvI/LVRgVN9eujLHxewgw9GNMDE356kC4vYS3W?=
 =?us-ascii?Q?0rHY74+NBk0rSzbOtXelkjzBWG/zbLSEo4RwXQjjkBBu+Lw3z3YvTlaRK7Ab?=
 =?us-ascii?Q?bA2N9BewvUwinlqrIiwlVh+ZULolQNwazezVfSeBE4L17luKztLr/Erx9smt?=
 =?us-ascii?Q?dJmlfd6f7lyHfskj/QL0tsZE0V1OXjOzNn2Faf3hG99VIvo+WuWivxzEXdtg?=
 =?us-ascii?Q?raIo14Ry7ts7q2Ra83BOoIk2gwkQwDMduxfiC9um/5xAtgFsv3fr2ST9Qn4d?=
 =?us-ascii?Q?k2Amg36IGTY2OtRF87wRGmDVv360TlVkmaeZzMBpoftl8oWxpsjR82ojaboH?=
 =?us-ascii?Q?rqE9EetSo34TrNnFVYIxk4WEt8t5A1eHCu2GY3MUm6ccjyYf80RrH1FFGbb4?=
 =?us-ascii?Q?CCGt16aEvakarJZwS8D6+m59eWhnrLojHzsGLvUpquc23WtuUZcIC8SwDxXA?=
 =?us-ascii?Q?fkaDLnoSiIhxVUwLejWp/LAxznQ13HHe0H+evSgU08dT1WQ1ILg4p/ePXhv3?=
 =?us-ascii?Q?p5PusHiJSh7UwNlmsF6Du5AIJUNTygtC5oAX4Xx1jaqcuK/ggQ+tMAGkGgxm?=
 =?us-ascii?Q?W3CW01cFkG4s59Dr5BFrKvrYUkhYyW2VcxmOplvpqyJ3tFKJbjjTNkSaEIf+?=
 =?us-ascii?Q?LByTgUvPguH00WpIszS/tLOghbM6qxdBkdqywBKmQgrkx8fdgh4xvnc1ObPO?=
 =?us-ascii?Q?iEPsY+z6dFbLRw+HKBNeXoMPWQ4Mr9yWmj2SWAiqiaORCPxPm6jAsj6GyxJr?=
 =?us-ascii?Q?sLPIKBOqCZuDk7iWp2b5jCbZc7TBDU345f+NOxq2+i/u8qonS7RFZ6r9z6H1?=
 =?us-ascii?Q?s8uMMMzIS52QxsFvDLVnlUVvDEYqcG4xd7jHidiMEuObzeQ94B/Xx2GdL+Re?=
 =?us-ascii?Q?+CTG2J8ObNwKPg96m1ZbfKmuKd6ToDqZrWrqgTLdgtHHlKZdNRgR4DeFD3OK?=
 =?us-ascii?Q?8gxubwetr5NYNKHKM73ZA/SvbTthzFlctalys1za6i4aNhPWaj5JUxKFm+vQ?=
 =?us-ascii?Q?07+dRJeBkw=3D=3D?=
X-Exchange-RoutingPolicyChecked: YvKaVVNwE3Qhf6SZdMUgz9oQB0fJc/I7IkrDbvOYcBccyUydS0yTUPbk2ioSa1mx9cXe/mtDuxVAS9wjeu9PSC43H91n7Sazy+q005X7BZxk3iHX2VBVTzb2TJHiUYnxivok5uLxqgWora0YDj330I0Zb5fM/DcoBdr6WheEhRTnmId2E6PolNJ09K2snHAcz7LIWfBN1q+ztnLyXcyw1wqdXGqhP7AMckj8OoGqHPK2NF+YVZoheP9JzPRvaNlGJOxZsEzr8PNfTrKQEM/4Np4vUHT2SLuX52Cii1KL6OfyCEg4wuSJdTcoZ8oteOHq15/r04kxPR/3bmM9Wfj9gw==
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f810d0-2ba3-4107-97ad-08deddfedb07
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 21:13:00.1060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ohc8ekOdSVaSGBoNzXbYmO2go/5PburtAEB+lTdUI9VPMj/R+uyjwsgROzOHSspnQMdT+iNwhmlql9sZ6phVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4968
X-OriginatorOrg: intel.com

On Thu, Jul 09, 2026 at 01:48:12PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/9/26 10:41 AM, Luck, Tony wrote:
> > On Wed, Jul 08, 2026 at 03:45:03PM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> On 7/1/26 2:35 PM, Tony Luck wrote:
> >>> The resctrl AET code uses intel_pmt_get_regions_by_feature() (exported by the
> >>> pmt_telemetry module) to obtain pmt_feature_group instances that are populated
> >>> using data from the pmt_discovery module. The returned telemetry_region::addr
> >>> values are MMIO mappings created in the telemetry driver's probe path,
> >>> and resctrl reads from them while a mount is active.
> >>>
> >>> However, a user can unbind the intel_pmt driver or its parent intel_vsec
> >>> from their devices via sysfs "unbind" attributes. Unbinding either of these
> >>> drivers would tear down the MMIO mappings, leaving resctrl with stale pointers
> >>> and causing a fault on the next access.
> >>>
> >>> It is safe for the discovery driver to be unbound. It does all its work at
> >>> initial probe time and saves a copy of the features and RMID count.
> >>>
> >>> Set device_driver::suppress_bind_attrs in each driver so that the "bind"
> >>> and "unbind" sysfs attributes are not exposed and the user cannot detach
> >>> the driver from its devices while resctrl (or any other in-kernel consumer)
> >>> may be using the resources.
> >>
> >> Unbinding via sysfs does not seem to be the only way in which resources that
> >> resctrl depend on could disappear.  The "/sys/bus/pci/devices/.../remove"
> >> interface looks to be another way? I am not aware of a way to prevent this since
> >> this represents how devices could just be yanked from a system. I wonder if
> >> resctrl should instead protect itself against telemetry resources disappearing
> >> after mount with another helper that telemetry driver can call when the device
> >> is being removed or the module is being unloaded. When telemetry driver informs AET
> >> that resources are going away after resctrl is mounted then resctrl/AET can return
> >> EIO on event read attempts? resctrl could possibly recover when the device/module
> >> re-appears but if that is complicated then user space could just be forced to remount
> >> resctrl.
> >>
> >> With this there is no need to prevent unbind here since it creates a false
> >> guarantee to resctrl.
> > 
> > This sounds like a complexity road that I'd prefer not to travel. The AET
> > enumeration is handled with a contract between resctrl and the pmt_telemetry
> > module. But the mapping of MMIO space is handled by the parent intel_vsec
> > driver. So to get notifications of impending unmap of MMIO space the intel_vsec
> > would somehow need to be aware that pmt_telemetry had handed out some pointers.
> > 
> > The "remove" interface might push this trail up additional levels (to the
> > PCIe bus driver level?).
> > 
> > All this complexity to avoid crashing when system operators poke at sysfs
> > files without understanding dependencies.
> > 
> > I propose a simpler solution. Just have the AET code defensively read from
> > the MMIO registers with a new function that turns any page fault due to the
> > MMIO space being unmapped into an error return.
> 
> A simpler solution would be ideal. It is not clear to me that there would be
> a page fault though. I looked around at what other drivers do and it seems that
> readq() may return all 1s in this scenario? Consider for example, how
> IXGBE_FAILED_READ_REG, PCI_ERROR_RESPONSE (note the comments above its definition),
> and PCI_POSSIBLE_ERROR are used. Some drivers just straight compare against -1 like
> the "if (readl(dev->bar + NVME_REG_CSTS) == -1)" in nvme_pci_enable().
> There is also this related snippet in Documentation/PCI/pci.rst: "Most x86 platforms
> will allow MMIO reads to master abort (a.k.a. "Soft Fail") and return garbage
> (e.g. ~0)." Handling ~0 may be even simpler?

The return of all 1s happens in the case that the underlying h/w has gone,
so the PCIe request to read the data is aborted. That's not what happens
here. When Linux uses ioremap() to set up a virtual address to access an
MMIO range the virtual address is allocated from the same virtual space
that vmalloc() uses. When that range is iounmap()'d the page tables are
invalidated. So any subsequent access gets a page fault (confirmed by my test).

But ... I ran my patch past an AI review and it pointed out the flaw.  The old
virtual address may be reallocated by a subsequent ioremap() or vmalloc()
call, at which point AET would begin accessing whatever memory/device was
now mapped to the virtual address.

> 
> Reinette

-Tony
