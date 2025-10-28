Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC923333439
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 17:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761671667; cv=fail; b=Iwvi2tI8u21V8tn5Cl54XBWnabuIApqqlYse+0bha7lPJ7gHo4wdDGXGiT7YfN67J5hPP1ddvc81ndmO673+Gs9jWj5Kh2j0GHhnX30tGtwhJIL3yVuriWMrzpQOReThVT3MBCUNXVt7o+907w2jWpjk05SGrJOve2IQXjneuSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761671667; c=relaxed/simple;
	bh=dlT1WLlD/6FSLyn1DWs6gONXUrefDpvUYGdkkRA1Q68=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RjW9tb0CkDvWZx19HArJ0ZZd02S75bcx1RD/bWHH1jSNs4fxvZ4ruIklWGfXa63Usc83e3Wi+lCIrOXWu4/cgo6CdYZmln0lMZOxRWY1c8zaNF6N8ebQd7knHPYcVMcgTloASFbeNf3YwNx/izmjYen0GEdAphXu4G15dmDv5OE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EKwscqtq; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EKwscqtq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761671666; x=1793207666;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dlT1WLlD/6FSLyn1DWs6gONXUrefDpvUYGdkkRA1Q68=;
  b=EKwscqtqRZQaZJQtjTIcAiWtFVapbY4NR4m2U+/ZTl5/jkVHJ1HLgUp6
   CfUhkGhzUO2NDD8gFmCQy4R2eijfTWZl2d8RNo2Magi2oJP+Lf/gDLWSY
   u4TVXfQ5dQUavxTsfOkjnjpvd9mW4RCl8PVz8REFt3ZJVfYBo0BKMJgIf
   7uqnBt/0mJ/RvVx0G4CukXnQFbHe9xR/7RKbFzZtnHYY84aOv15LVckAL
   WFvMikJTJXYpI45Is4ZJOtBG2w4GMrzSW9AC6vRD0jMK2sXVcIL0ZtRa+
   dq3gOaW6Vh75ROb/40I0JLlbwtbrMnEMKkVpIrYmKq0/kmKwjALip1ts+
   A==;
X-CSE-ConnectionGUID: BDmxu2HqQFGz8HjotYFhzw==
X-CSE-MsgGUID: YfGstD/PS02yYf+oxnjtPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63666727"
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="63666727"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 10:14:25 -0700
X-CSE-ConnectionGUID: k7EampYtTSy5pe5PmwQSJw==
X-CSE-MsgGUID: uNEeHvQZSSCg8V9e3bXWZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="185297954"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 10:14:24 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 10:14:23 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 28 Oct 2025 10:14:23 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.57) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 10:14:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JNWsOLzLU20h4QxvxtxYMLfEL9Azu6Dst7IuNUJdHzlA9saR8kHnCGjyyHBZ9hJT7Dc/e4+9DWbdqf5ohAMa9z877C42+WvVlRbVxHEiaP1onUnavyRvEvP2YFQ/0PEFN+0OWS5z/7VbJwml7ee42/551o32txrlwaTmXXNOVrfG/xY85BndTiPf5/+Bp21fkbjLfx61wqCVLaR7LloKKdCbTlPNPHy41fbqIWsQ9b3P6ssGpzZ4rqZw/tHZUP5GZciU2jKjfWKuBFE8KYnWiL8PZ7GAWlC9ZS6uJa82IFlZ4x8Uy9k3lvLr5UuSOZf9DYPAgc+TqvBVCkvwMTqkyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhB75iBk7zZsl+pKahZJ0lJJHjoMPxwDTIXiHeyvPnk=;
 b=yAX+oxhdwtWbJNwjuSmcX0lwEDpOks55P/vQJjgHCW+jfWJSZZhB7ox1PJ57J/GiHwOeKSCyJUz30jMsxmBH6jlY8K95CYu8LprHNXNXfJN5v/fx92YUlU0txexZLKRBYyZoZ+doPnOGon5qrkXAG6Wu37T5pczBYW1Z3m95cIdssfx4S2WqEttDa2FNy5ACK5PlNuY7iLv52LJGr8+1pAFSZ+ok/W9yTiywGzw3PMBv0Q7s3Z8UGG1oRM4xQUNgoYwB6cU4Y4Ox/ta6iPGl9zuqSq/lb43dZaSWVWRZCtMQMrX5A7V0aFu4XrJpjYYbVGWaWFBZvpcjm+FWppIi8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA2PR11MB4889.namprd11.prod.outlook.com (2603:10b6:806:110::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 28 Oct
 2025 17:14:21 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9253.017; Tue, 28 Oct 2025
 17:14:21 +0000
Date: Tue, 28 Oct 2025 10:14:19 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v12 20/31] fs/resctrl: Refactor mkdir_mondata_subdir()
Message-ID: <aQD560ppyTDob_Wd@agluck-desk3>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-21-tony.luck@intel.com>
 <4bcb8320-687f-4c43-b4b7-150d503b9890@intel.com>
 <aP_5eW_GHwXebeyq@agluck-desk3>
 <b4921b96-3f86-45d8-a353-471c8f20e2b1@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b4921b96-3f86-45d8-a353-471c8f20e2b1@intel.com>
X-ClientProxiedBy: BYAPR08CA0031.namprd08.prod.outlook.com
 (2603:10b6:a03:100::44) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SA2PR11MB4889:EE_
X-MS-Office365-Filtering-Correlation-Id: cabb188a-c0f4-4baa-a9fa-08de16456fa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6rkvbOmZ3qp/OH9VctITZngVaphgyKjVzCwIONIGl28bjmsZrWoPC2wNVEa5?=
 =?us-ascii?Q?5CBqoi0ZdEg/TBWy1MhtV1JOJBSD6crX88iO+BUC4S8F4tyvziOFyUuOC+v2?=
 =?us-ascii?Q?hsV+1kfrxu/AO1fQOTSIT2VtxGdDooHyQzbOWLmkfkpbk8j0o90on3E9fMdz?=
 =?us-ascii?Q?dxP0JEBNMzrC9qylDX1zVJIVgyQA1E8YsQ0PxHM5E0MNpXteld3PCaiDKkTY?=
 =?us-ascii?Q?Jj9aOWbcZeMpQyvohzJEueUsQY4wJDrmdgAplKlSzvlu9aaAVLKE3SqCkC/g?=
 =?us-ascii?Q?xsEX8lWUCWtAMu7U/6niypdj7tBkbdxb0YLIqFI3K2c5Lr+JRpxCidhQAVNt?=
 =?us-ascii?Q?C4LfymHZyr1WL6wQIKysewbZ4h74fC0b/h6cgStFVE2renoeM5VPBllbk6GA?=
 =?us-ascii?Q?whsNjhqfeqYhmgzqhJrrJek8nLnmMMhFcg97CFzH5grSS7wiLiOh7er5D7gF?=
 =?us-ascii?Q?5Me8hv0A4KoMOgI85CI7ij92iGQ+v9L1O0Xk/CxU+1NTwYGVP8r7fHuZKgGi?=
 =?us-ascii?Q?davfkflAOcpnMezt1EYtRmZCdh0Kn/Ajb2qE4x9QynA4izlyrUuNDgV5JHHS?=
 =?us-ascii?Q?Mn/0RbcF0ZWr9aYMN0UX0pLObifOzCoW5cl3+gpwonMhUG8jJvf85npZshdJ?=
 =?us-ascii?Q?tv/MGPYV5b5Cl+CO0tfcvrByy9VK5STlJIcimW15fKyB1EnhHGP77YAb7wVw?=
 =?us-ascii?Q?tTWeEj7ry8P/wUnBMKcKN/hhkgTJXQlpFTLLC0mfC0M7dI7kwTbOTv7lsNs7?=
 =?us-ascii?Q?cj4j88JsnksSuFQm3tAfsROG7ic+w5Tl+QJ1ANwQHK/9D4UtjIrefypC4qSm?=
 =?us-ascii?Q?ucqlF2VN208gfX8gGtc5qFTxSpQ3OKJr9UQW0EmufwSXrTnR6DDtzhvidx5L?=
 =?us-ascii?Q?/iryY6vnLkLQ8xWbqTgr3Ci+dUe0h3uJQ9MX4gI2YcUj+DKJaNqKr6bkCfob?=
 =?us-ascii?Q?IJVLILkW2E2t1jHeYOEH0HsjpaJpL7Q3FCSqUfXVB8I+wscxTBMgdIJCkyoa?=
 =?us-ascii?Q?Qq1JElKF1v4FE9lzg+iQWHAa+YWidOcMHREh1Ar+R4DvKC3B/3AlI3cJ3vO/?=
 =?us-ascii?Q?3Ig8dCa4BEEUMNm0l0JdwxxA0H3FBOFLmmQ0O5g8wrKgNONTcIGqeUJqkdir?=
 =?us-ascii?Q?LaBvYkqXIqf6phKtUkzfGC0Up2yBQggS5CposJr6CTlIwpk4UlPF9NWJKOPj?=
 =?us-ascii?Q?sTvt16ThS7ucHqSZfKvYn6okV15WYB5p5PfQVIOdN4I6p2dWKVsdoLcuJY5r?=
 =?us-ascii?Q?5ob305UJ246KwexBIPdiwYQlAC8pnHOcE2SQUDFzRS2uo1VGRGlx25yoD262?=
 =?us-ascii?Q?3+MbHD9F2qEiDGn3gpsi8xJdle70FNhQnMX7KIv9CmJME9PaAo2RwY14g8wX?=
 =?us-ascii?Q?L4tfP4LWjvtTI1Mh3Qpf2yQL9TNXqXtR8WoGKkUayxZeLxQPAwa4ljYTIyds?=
 =?us-ascii?Q?triRV2KWQXdhc/d6InW/xZCRrLRbS2OY?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MEYqzkfsNtCkdzF4vfLDMimC2whL+4KwfUAtbl23n1FO6pjgQ0nbDZPzHsCM?=
 =?us-ascii?Q?1CAOZmVARnFH0JlI95loxXKSoL9zE7tBp3UXCit6OS5keXUE6wUqEp6Lwr1U?=
 =?us-ascii?Q?yeaE19gvY1F94jW3A6coGqxNII6NXGz+xYqqB2eXZnq9FtjDLI6ih8eYjd8T?=
 =?us-ascii?Q?orQozQmvQeQFzkV4kQ37lulwPJjRazO7L2pqVL8pHOEqwgfGECJHR4NVvNFf?=
 =?us-ascii?Q?z2bmhSL+cIZa9bPDApVQXuBMoo6zNgrRiDT2qjf8HSP5WhyOgf1acgb/1bv2?=
 =?us-ascii?Q?LQCujwG8rnTv5/Uw8twJ6d3ItjVix/Qe/wPKct1qz/XJhAe72+PzMkFaduDl?=
 =?us-ascii?Q?/nmnrnVGr1nizZtLj60sRShRLe2LPZfwh25MxKemBqOI9wkHSm3Ga39Y3fU+?=
 =?us-ascii?Q?gNmmUTcmsYibbZW5rhmSHomld3dok1DvD7JjtYjUUURj5TDWFF2Ta5V3xxZi?=
 =?us-ascii?Q?fqCPnSbeB8QxnAmhN+LfdASoqNUm9EItqUgw/aSnn1ICEsqItFolbYZvYIrx?=
 =?us-ascii?Q?IPFvYjqqewX83jdJuohYTBo28USo53eWbcKr88td05CfB8a9AghFZpiXnUch?=
 =?us-ascii?Q?6q9utOwMTQoRKa5u5XWZ06LSBGZrL5PVRlNnGrxqFxAR6KCD7sbEydiNK/cA?=
 =?us-ascii?Q?dzeerDw7gHqRqwi2o4ZNFaH/ySXiYa+YCBQSnUvsh7wr5fX/Lzz1ue/7yfem?=
 =?us-ascii?Q?YTfsTzftKB3w5BuPtE9tYA25VJi7v+r/6dfHjYnSuz+v7aiSMafK9uc++soP?=
 =?us-ascii?Q?62d/UfBTTc937Z2AolFBIkJ5Dv4RCHze1fYPv+So0Jf2sTJMvbWY2l6DmNBe?=
 =?us-ascii?Q?gCAk7xgd1nxtc+U6fZZn2wWEExcbjwL4yIdg0iWY9x7uLyEVOwBp+AJCYxq7?=
 =?us-ascii?Q?wI1/+ozZaf3Wc6tB8ZmKRIQURzRO7+tVNe4UttQC5LhwLECU3hH4B1Zmxt/Y?=
 =?us-ascii?Q?pUOsdHe/EQwJ8t50m43kbMq7399MwRvQN/wLpvV+VUAL791QKwDYtpmUIl3n?=
 =?us-ascii?Q?M3IUoAcAUdaPSminyz8QvW7RnxufD7TsAzmjZ9XmKPn6929Pbb/pevhHeDO9?=
 =?us-ascii?Q?XfB3dtMsyjeESP7xkY8FvRTciIcjoioyv8YjcmEGn1KK0fGpHmsDZ7QwlaXH?=
 =?us-ascii?Q?zoBf7iRWjYYEC6h7bzapZhjC2qv5rtPzX/qAxGOtr8YFtWkk3/75RBf6s2Xv?=
 =?us-ascii?Q?OeNqgdyv+fHc/XXDRDnG9Gq8T9IxQMxmzUwYrldO7+gsr31oJHAkz+3zeujA?=
 =?us-ascii?Q?flUlsfyhfrUUDJ1wsIFDkbVX1kFalaU8/OelsRRhOEGXHPZZLow6CmCoRytV?=
 =?us-ascii?Q?nuk/65HITfCQ60wzcqGLjYBgIfvbbKAa9iCkoZ3SWvR7U9r1qkiuCHrxlWJy?=
 =?us-ascii?Q?zwceqCzJfRYwl66S4oPtaJKcfy0YN4/VZR/wRtDf3nntNLpPnK9CQpfrnhJP?=
 =?us-ascii?Q?LehwsXXXG5FVKO58tpIJkpqkWowORTGXbB2ciLe21ifp6/fi0os4SHzPja2+?=
 =?us-ascii?Q?FWeJnbaQOusRcfZkrgqxkcpMyyfMN5yUk0IxvKfEXeeRvMuJyU/JmwqMZ9a1?=
 =?us-ascii?Q?T4/DAkESiJfO4iqzTNSfQQPV8TtfNnFQ4RbCkPOp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cabb188a-c0f4-4baa-a9fa-08de16456fa8
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 17:14:21.6762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aqg2QNHwU1ljLVTUdj0RXBf49jQNTIzoDkFEcizwin740dHky4md4ZEFtWbL3eLppYSyjzX86psjCMuYDml2mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4889
X-OriginatorOrg: intel.com

On Tue, Oct 28, 2025 at 09:00:46AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 10/27/25 4:00 PM, Luck, Tony wrote:
> > On Thu, Oct 23, 2025 at 10:45:06AM -0700, Reinette Chatre wrote:
> >>> +	sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
> >>> +	ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
> >>
> >> Noting here that kn was created earlier with mode of parent_kn->mode. It thus looks to me like
> >> above can also be written as:
> >> 	ckn = kernfs_create_dir(kn, name, kn->mode, prgrp);
> >>
> >> The reason I mention this is that this patch adds a third copy of a very similar code snippet
> >> (kernfs_create_dir(), rdtgroup_kn_set_ugid(), mon_add_all_files()) that looks like a good
> >> candidate for a helper?
> > 
> > I looked at this. But the helper needs a lot of arguments to cover these
> > three cases. Something like:
> > 
> > static struct kernfs_node *make_and_fill_mondir(struct kernfs_node *parent_kn,
> > 						char *name, umode_t mode,
> 
> I aimed to preempt a response like this in the text you quoted that notes that
> a "mode" argument does not seem necessary. Are you hinting that mode is indeed
> required? If not, without "mode" there are six arguments which is just one more
> than mon_add_all_files() that will be called by it.
> What is the threshold for there being too many arguments? This series does not seem
> to have trouble pushing an arch API call resctrl_arch_rmid_read() to eight arguments
> while there is a concern with the number of arguments of this static call that has
> fewer?

Ok. you have me convinced. Since this helper will be the only caller
of mon_add_all_files(), would it be good to just add the extra args
needed to this function and have it create the directory and add the
files? It would need a new name to describe the added functions it
performs. Maybe mon_add_domain_dir()? But better suggestions welcomed.

-Tony
