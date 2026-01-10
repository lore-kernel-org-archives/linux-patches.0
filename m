Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7402494FF
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 19:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768072427; cv=fail; b=SHubDLwkUgGuC/LjsEGl4A1yqUvoiuvPuxs4judIH7hEVToy4RZ4fyB1GF1YBbVoXQI4OOBIe9N2I0vIHlnu4LxpKNKVzMbIDvdWurpynHRYO1Br549Acak0YHpUkrDxnfm6QT24bQejSXAS+M9iqSgrGTnHh6/cjIXvSravxKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768072427; c=relaxed/simple;
	bh=9ZSecauDZAM9YkYfStvvFpqnEVVijQ5/av4VFdpg+O4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ecOYxnJz8qtyDdYhgcvV6G87uAOPzifx69x2aX9JuPkh6BmyYVKSkRO4CZNpEVB3JmyDfWplH+dRMeepgQXpKOFMKbb4TX1QKZzMuycoLh6abpli8owh1nTdUqJUZo77JFEXubAKvvpSqnP5aoIG6GNnuDyzC783qajTPn4Z7AQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jNKeKg8K; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jNKeKg8K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768072426; x=1799608426;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9ZSecauDZAM9YkYfStvvFpqnEVVijQ5/av4VFdpg+O4=;
  b=jNKeKg8KgFWubdgEUuf3/aIRyji5SAV744P9UX1J1mMSNEcQhdw+BRra
   yL3IrmIvzcw9//qJ2BIIGdZITCDJCSw4k8A1bE0KaV83cgXzeOVAYmvnu
   /y2Dws2H9VmYARFpH+F6P5SSCOw1BQAdnf8DgV2oiXzmYLYn2S8+m1/I6
   cT8Id6VcITZ6wb/hrJAgjTnx/pGHQPGZdmV6uhT5StOSzbL/rLeE0Qovw
   Yd3494soip5+z6csNRjnimBaSqi7r0JO+GszgYQIRl2vpGCh9sAOXeM05
   WYT/jWj8qUiaVvZKIq//wBPeC7UV/JvhmPFQTSEuH3djodZn4Hpgc6ztf
   w==;
X-CSE-ConnectionGUID: glO29ou8RvqBB1dxdxdBKw==
X-CSE-MsgGUID: FnF6Ik1zQD6iTYLItxMEcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11667"; a="69464250"
X-IronPort-AV: E=Sophos;i="6.21,217,1763452800"; 
   d="scan'208";a="69464250"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2026 11:13:45 -0800
X-CSE-ConnectionGUID: CmLcla/eR8mDEaaaMd4qhA==
X-CSE-MsgGUID: y80r6zrpSWWR6vyam+7K5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,217,1763452800"; 
   d="scan'208";a="207875686"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2026 11:13:45 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 10 Jan 2026 11:13:44 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sat, 10 Jan 2026 11:13:44 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.42) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 10 Jan 2026 11:13:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AkZQsc4fuFv7r1FbxCteWiBiIGEXgKa5exqC/MXTjI2zV4ojEDoBbnlQWU53rhvxATnHrSIoKl5bAAVL2iYBzMfTK2zPBfbApFZ5VCRm6vezoPA3PyFXZwQO6ccYKoO8AyN9EZXewcSYb+3Sf/z0vXOfZzCurUKDSRHxLGbti4vlH4ko59gmaNxpJEo2TPGRLVdzNZeQgmC4PQeLDeVWLaGcIgHb7NgzhZmyf336Q+Ols6x+37FEeRBPKUbK9gJyFvOT34nah7ZrzHYc5ao6+0AVw5tPgcrhoMUeBVS7QPp4Ts3o7M3bIzQYrbzpygpPtEG+JbuVbYxJwFIxJCXGeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4j1RPd7uMOraiFDphcyjKe53iVilQ/CAep7cpbmlWz8=;
 b=gy+UlUoCjKO/07R+MVZd0Iazc8eacmBycAZsqu5gVTTdnn2RMKR57jMLzSmQV3klAmQ7LCInKFwh4K4M+qS5bEAudl/9V9uwiNlypB76OtMRlyZWgb0MKPcbwsHWGy66mdL+2GwRcsz9Q2KknjYuhffwD+qKpCTs0YCM0Fzrt/nDIYfzQRmULCiDXWoLEWnmCs0zmMgFeRXToiu5A+iegviukc+1K2oJKIRr6Q7TZrJgn/RbzqYtfodKeuBB//LSq4dRdKbtRwC8GwBZHMcx9IRHT2Zd0PaYcSgNjjWdQlJMke9NmizAa6CCiBnEC+YKHMRybmYGwLUsMrmLfg+q7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB7578.namprd11.prod.outlook.com (2603:10b6:8:141::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.6; Sat, 10 Jan
 2026 19:13:41 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9499.005; Sat, 10 Jan 2026
 19:13:41 +0000
Date: Sat, 10 Jan 2026 11:13:40 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v17 30/32] fs/resctrl: Provide interface to create
 architecture specific debugfs area
Message-ID: <aWKk5BYP8BJjYhs6@agluck-desk3>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-31-tony.luck@intel.com>
 <20260110105758.GAaWIwtlX9o_oVXIM_@fat_crate.local>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260110105758.GAaWIwtlX9o_oVXIM_@fat_crate.local>
X-ClientProxiedBy: BYAPR11CA0042.namprd11.prod.outlook.com
 (2603:10b6:a03:80::19) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS0PR11MB7578:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a611264-c5a4-41d4-0d5a-08de507c5dea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?GchcDAmtM12I+TkzCrdIqQN3yLoc19sNzm4ujiX6X/iNNMM/xRfj5VBd4n+o?=
 =?us-ascii?Q?lRFluU3+4SFJliyo2O0nh0W382bAOdivgeJnTqC1p67Ee6EIkjwByMTLSK5P?=
 =?us-ascii?Q?PMh4Eo8gwSkjPD4NeZ1I9hyAUNowwLosffA+ZpYVycm8az/PCIpE1SNvAHLr?=
 =?us-ascii?Q?TYcsTQmFDbcVbMEUrDeV3s2CXkNLSB1YEI/ZfydMOLT6PrObkNYSExevxRPq?=
 =?us-ascii?Q?8veKuV3NEvgTZxMEO+53UBUU33Lo4t/Dp8DNnUd2DE/NSx/tzD6eBycQvOzn?=
 =?us-ascii?Q?TlLK314niwEdlqVYYj3PmpEWGeBMzYyTp0jUhumhOBmI+WS9LmoY55gUeuQy?=
 =?us-ascii?Q?tgGT3FyVgFxovBln5JXSM1AjuaVCXDeq0QWtbTnpCeBpW6XThnAbHDB4JFRX?=
 =?us-ascii?Q?uelU9rb0Oa3atZU+/dTNpTDhe9xtn+H2uFQJNMMDva4cRFrd0kOZpQjEnkZ5?=
 =?us-ascii?Q?20m1QaoVl35XrQwZCad9H3DtmvLAQpNoap+WEeSG2AxSdxf2Kyv1FG800tvH?=
 =?us-ascii?Q?G9mBMAXO9Q1n5WPxfvb2anWAwytzWzsQRhcK9puNHFlPKXJnnKV4Qw8oEYMD?=
 =?us-ascii?Q?TF9r5vZMJ9bvD/5SuwAvzlYBH5WQ3YrS6Bf5jFJAdWskcxG13iQwBsAiwBU8?=
 =?us-ascii?Q?5qUbUx1CiOyCULz8RKsI7JD4I3pK6zbGqnrYQ8/5UbeWbxAvMPT48Cq8ENgO?=
 =?us-ascii?Q?rMHRGGwZ4i/iaI7A2Btlom14vcu71hjZAHXMf0Me17/2+zPKmpjyRD2Q7Okx?=
 =?us-ascii?Q?MTGgjJerjlAeNoQ1RU+/UOdyPyxFIbw/qQJdEq78Dq2CMlo1QgPYYKf8ExPv?=
 =?us-ascii?Q?ddgtZloaXZ6OSjMm4Q8SdZfwvIQ4vlCvQ88jdXpO9TlZY+1Tzv45biSmTEVJ?=
 =?us-ascii?Q?dNYWodtMtjBrG430OKZz7/Z62PlwsxHnTjVjinfwyhA6I+4CdtgBaSImBxQv?=
 =?us-ascii?Q?00I6jabccTqoyQDc45YnFsrCRp+AmPusoh9+YclwNxo7hbGM5k7WqhVkvvGS?=
 =?us-ascii?Q?hcE5QoWP6wUnPhWYDD+b9Xu4yQ0poc7UZy1Rh9+YS4LoWUR0XNZ0k9oe+Kqb?=
 =?us-ascii?Q?gKDWoAp+8ffJ51CpedOMqSrycCPYgzZ11unOVfWUpG68zXUlli8ZYmDqWC/+?=
 =?us-ascii?Q?kEyD9qO3pTsZ1A69MHJFCRXd+hwaDG99mstoRwk7VVTnsM+lAQ/+DC11pK+j?=
 =?us-ascii?Q?rvZ9HbnPPxNnTCV+BNmwdWYUYoFcAXWTtMRbYgWujdznj62TTBG9+L9JyAno?=
 =?us-ascii?Q?QW1tRKX1Qcp8nDlibhDmM52BSTL3Ve7HDywTSJaZAOVEfKzforQQCzYBdlwE?=
 =?us-ascii?Q?EIjC7l7QYd6DHLQLIte0Ul1OjT7+wQYTFPF4XnEaAuj7tITca4QEACFcD5A1?=
 =?us-ascii?Q?kCJDOBSkYO4bW9w+JVQ1UM5AW/G3m6wDf81HdW1jAOFiw53+Cb0uX0oQwY9s?=
 =?us-ascii?Q?1YrNnDwB5DWel+NrWVzkX115l3eNwK3mqVGCvKBvUrdzsP8uygQSWw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nzTDq1WkiM9/AzAgXcR5CMQQY1UpHqLnqpxeNOab21HRVQmZwgk1hhizE4+K?=
 =?us-ascii?Q?3UBwBYTYVEEo8MzgHp5+KDSHmZiNiSe76sRaTx5r1q7W3JV6nf/cbqEmvNE0?=
 =?us-ascii?Q?broFF2QuFI31ae9y+nEnNKZejKwkl1hZY6KLgkdqryfUfKmH80ophqDCWpyG?=
 =?us-ascii?Q?3D6YDeLpafcIek/4L3fPT1s1yrsC1sgMlfBn+0JlSrk07botHC2aisCqEBz4?=
 =?us-ascii?Q?uWDf0QPN3TLvqoAJ5KzAvAUJ5bWN+OGqkCy/2Oa65Ng1pNSftoy1Vz+JswsA?=
 =?us-ascii?Q?NW219ZnhLeODT8y5VEYzhtqb6Dp1Z/aDP2gWaZBny83cLRd36OJ8Jm9OjDb2?=
 =?us-ascii?Q?bt8YSBsHFWuNw6ku43L//JP4LrSuYFBvAkyqAD1kuPWtWXjdBPPSKn9Mf/YL?=
 =?us-ascii?Q?APk7BKod+A/dZvqFVbBIMDaYY/tjTxiGksm7TNJ/TKlgx45OdEAxo+oZHqlM?=
 =?us-ascii?Q?B9pju8iSuNMpP0dmLo5JS4vckedkCGjQpKuixq33X9IXtWxcDnuyRssLmUKv?=
 =?us-ascii?Q?g3boLgRCPRi/qSUh99udyJ0Qv9aphj+1SkJ3ISZv7U4r5NXYux+HScHdjiQq?=
 =?us-ascii?Q?Z99s/fM/X6r1dT3b3QIDmBCC+sJLadnDla2wDSTkZpUtCxOD+BhIk9tkR0Kw?=
 =?us-ascii?Q?WCnNhmJn5BUWdXVuAMP7MDMGbh3hgqlQZ0A2uGYb8GcYET7jAhhLzpKLM50Q?=
 =?us-ascii?Q?RwNv9mKaV4EO+0p43j9zVZEVwN1RP8n8AdoQPAawTw3qRZWmp90eHMr3X3F7?=
 =?us-ascii?Q?rjDOkHe9FVeWC09H6hjkmku3WGDvaNqkpkA47mSwROizxCW88pwK6d3MQSKv?=
 =?us-ascii?Q?7RSNKnbgfGB6U5CcW0HjPa+EFOEM9XowWo6dY/oO2FDR7oFloE6BSXTjR0VC?=
 =?us-ascii?Q?Nv3VmZp2NnhhknzHM218CYWSLn2OjpiL3LSihPY9eec/yEp7L79G4McFYOXh?=
 =?us-ascii?Q?sLJdL2f1NTg6fJTFvSAfgyFASIF30xS5Et3YrYg4bktxMNv5sFxoA/ueCllE?=
 =?us-ascii?Q?tqFwMJ6uD0QqcwIF4Ky9GFMKyjIPk4rB3g5ST9pSuoPfhZ0wKp8+7SaCFFb/?=
 =?us-ascii?Q?S2Gx08kD6K1O3MnSgY32dhT3axGeFORKFA7wzY2gFiqA9Bc4oAuxEm470Fvp?=
 =?us-ascii?Q?48aYp8HMoQXuwtwjNKD/oKel6+u86+MXr4VSUfdvqfvD7NqjDQ/nCtpNntnI?=
 =?us-ascii?Q?Tay9nzMuMX4wmiCtzs7dt4gAHUbewTqzM90Vf+6DJ81m392yiccFqG3wRlBo?=
 =?us-ascii?Q?J+iM2r5OauEhnvMzjDpRPdB7O0dAUn4GqJhYr18U/XJ9KqxuTN6zu3v5kG5i?=
 =?us-ascii?Q?LLOnKULbL293REo05b1RF9W6T8ihqj7DPMFe/jNbado3eC1yZFt1AXPq5Mry?=
 =?us-ascii?Q?ydFHsJJBsr/jailL9aqPL2IrVMdVHXZzqUcMMviKPMN5N/1ieC/quhknOc7m?=
 =?us-ascii?Q?H31hty/LkCc850l4QZ1hfCFVBm0JAt/QHL9LPJn0Vv3iYMNBN0RzS5M7NyNu?=
 =?us-ascii?Q?mEEYtiYhV17dKk7N9px6gL8yjb0dw2xsFHmwmbsbDYVNC8ZrvVrIWszPEf1I?=
 =?us-ascii?Q?/62qFXZ5gG7D4dp7A+fUv0NsJ4RgkB+JjcZmbk4W1HvOjtIFLhk4kjsVsO23?=
 =?us-ascii?Q?oGfBKUccKWzFJ4N1+G6yvX1cNtz9jQ0Tvvt9uM9CgxjpTE16egJGvMbKJU4B?=
 =?us-ascii?Q?bIU/k/q8GClStpaIlfuyWblGtZg2idu2OlCugyB8UAQ6lnlCjF/SNwgv/t+W?=
 =?us-ascii?Q?GUFGML6lMw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a611264-c5a4-41d4-0d5a-08de507c5dea
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2026 19:13:41.7206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KS5Z+OU4ERgqSfZrYvEXxkk9LyeZicmXvBCFGZggVCmoI5HwMt2Q/fppZTvgJE96As4WhHGFOeRgUCq1bLCa2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7578
X-OriginatorOrg: intel.com

On Sat, Jan 10, 2026 at 11:57:58AM +0100, Borislav Petkov wrote:
> On Wed, Dec 17, 2025 at 09:21:17AM -0800, Tony Luck wrote:
> > All files below /sys/fs/resctrl are considered user ABI.
> > 
> > This leaves no place for architectures to provide additional interfaces.
> > 
> > Add resctrl_debugfs_mon_info_arch_mkdir() which creates a directory in
> > the debugfs file system for a monitoring resource. Naming follows the
> > layout of the main resctrl hierarchy:
> > 
> > 	/sys/kernel/debug/resctrl/info/{resource}_MON/{arch}
> > 
> > The {arch} last level directory name matches the output of the user level
> > "uname -m" command.
> > 
> > Architecture code may use this directory for debug information, or for minor
> > tuning of features. It must not be used for basic feature enabling as debugfs
> > may not be configured/mounted on production systems.
> 
> I, like you guys, thought that debugfs is "safe" in the sense, stuff there
> can't really be an ABI but just recently at LPC I got schooled about it and,
> basically, if anything in luserspace starts using debugfs, it will be
> considered an ABI.
> 
> And this thinking has been there for a looong time now:
> 
> https://lwn.net/Articles/309298/
> 
> So, before you put anything there, think again because you might end up
> supporting it just like an ABI.

Please drop patches 30, 31, and the debugfs hunk to Documentation from patch 32
while I look at options. The debugfs bits aren't needed for normal
operation, just for debugging if things don't appear to be working as
expected. No need to hold up inclusion waiting for a solution.

Telemetry based events tied to RMIDs are new in Clearwater Forest. I
have line of sight to a second platorm. But extrapolating from two
data points to decide on a stable ABI seems very risky.

Thanks

-Tony
