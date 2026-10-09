Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E44361651
	for <patches@lists.linux.dev>; Fri,  9 Oct 2026 05:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791522153; cv=fail; b=Xo4uUVbVtuO9cRyPn2Y5fbWSqgv1VnBSGnilH9Ih5x2x7lE1QMRrezg1vUAFthQzP8Y337yayUaSqM8GQBAH3YeJpY/ZmkYS6R+D7ZHx76v1LMglfoLtBT+UBoTUczpgu3m0PCUH7RJyjse4fxI5R3BJipi3QSO+iQ+zasUKyWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791522153; c=relaxed/simple;
	bh=x8UEU8F0twCy5yFzkZ6QsPKuxslThjLhcxpl1uVrhOY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JTn7gT4uOtN9cDvHOWS+j7b/ilTLG2m04YFHarhoH05sndVoB1K5GBsp0gBYTpwP4t72SZaL/pJa9E+RNF2RwJ5ilUAU9VFf7xXNTvnpwJ/L/rttzj/PAnXIwUmctvlW8vqOmym3zA03WDvAxB/Yk3X7AR4WHEAwrv55S4CPhFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OS9vnn7l; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OS9vnn7l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791522151; x=1823058151;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x8UEU8F0twCy5yFzkZ6QsPKuxslThjLhcxpl1uVrhOY=;
  b=OS9vnn7lZyj3d4w9o+Ovs0OMlCW5iO6wLrAGMJTsE3xfMijvKv68Mw77
   DZB8FKIpbl8E+FnqYJ6ug1+pRJD90KiNdfPuHLGVWbdzuoTCeKio5nBpR
   sahFFpkQjrQ/YVTfYhTjiSBt6ec2E0J8u284yal1iQd7qEqexurbQCF9U
   Tn0YMoLCRii6nUkJ1AHWbf2fzVsVesQ9s1OBTyqy50nguPS9j0j9YFDSi
   C9OpuFxlnKxcGi0OaV5lrQHiRCcswJJAfMdJn+9bYgyTBcfGVTbvnkP0h
   HNK0GPRGO2AMl8IAHwrU+dmF2LtN/qOifiEuIkIyeqznWQ85PbTVPap2t
   g==;
X-CSE-ConnectionGUID: H53yHZxrS06q9+hXLMrWPw==
X-CSE-MsgGUID: QkEAZu8uTZmzuLm/4xEE7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="220103"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="220103"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 22:02:30 -0700
X-CSE-ConnectionGUID: fNhkJXbtTvyTjb9yFqnqVQ==
X-CSE-MsgGUID: XLPpbOcjTUizTqumfhAmXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="212338"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 22:02:29 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 22:02:28 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 8 Oct 2026 22:02:28 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.0) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 22:02:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yk240CA8PMwbQ8dcwx+iUCwX4MllgciGH+k6nRUdkUJZJq6EVL1Hd+y0tFNwbySYL0Ycgeu6n8TWyTwYSS2r1SwxH4zqc1Zm0eNRS42wi/0HR+EtP3IbolH50ZoSq99W1oj7OpK0GkxRLfxRdyLlbCy0YXMfyo71fwt9GphrZIpvsk3m3XiG8NMleTuI1KCDG0y9PfB4Sx6vpi2M2CXyL4y2IQU4aE6KaMS5aMJqSKnlg4Shk1DesMcK8I2JlhQmU26Gwrsi4iH/VXmD38cxk+DsJNQDQ6toLP+W2I/8hqm8350c5tD07EnBW7cjNw63L79okG2yNmBD2C8tF+A7yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vligrFj/6RPOLM5BvqNdSTi4uD9tPavB43v2n+SRur0=;
 b=SRfWyXitBE8yGdbjV9K4ky6JjDw0dXz0eB5SNgqO3gbHS0l33prJ2sBjhr0cS6yDJEBRvLQVh8ex4uyrbp+EgKYrD/Uk8N/uI1I9YpZ8oY+woCDL8wvuO6cmWF/uCio6jwRfvYPguRs2hV07FuktCIKY5MC3RWQau5a7eVd0M5qq8XsR/mjN+R7wtDmWxIyE+lo3/0AvcmfDhQM2IBjjHqf6JAr0KPa5ziPIa326SQf1X2fNFXU60zMI+8lhY/Uk/hcGGJHfBznK932D515GE+7mTnYOZqLuuRm0mIgSh1pXuSiQlGxGO9rmdIbNo7gSp6tk4pqNRFA/5b/ixx23nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA0PR11MB8379.namprd11.prod.outlook.com (2603:10b6:208:488::20)
 by IA1PR11MB8224.namprd11.prod.outlook.com (2603:10b6:208:44f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Fri, 9 Oct
 2026 05:02:23 +0000
Received: from IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6]) by IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6%6]) with mapi id 15.21.0496.010; Fri, 9 Oct 2026
 05:02:23 +0000
Message-ID: <8658ff6f-60e3-4d28-9fce-649d6b69120e@intel.com>
Date: Thu, 8 Oct 2026 22:02:20 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Ensure default group reports tasks on
 monitor-only systems
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, Sashiko <sashiko-bot@kernel.org>
References: <20261008234311.17702-1-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20261008234311.17702-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0351.namprd03.prod.outlook.com
 (2603:10b6:303:dc::26) To IA0PR11MB8379.namprd11.prod.outlook.com
 (2603:10b6:208:488::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR11MB8379:EE_|IA1PR11MB8224:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dc2a8d5-07e2-4fbd-7ec3-08df25c28146
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|6133799003|22082099003|18002099003|3023799007|11063799006|10067099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info: /VL6QuMFhCKt1e/E4Qfa4hZZ7cWFv1IQDB3be+l7vKEi2PCtYeNWt7B/JClWJaKjklmJGLEuAVLo19FZhGjA3sgDUyAo/SWKfo2IMxhOckcqw6pHhI0NYHmnKFnYoWKa31vdxxagDzUbl0hu0Wuz2bUgRYSjtMMXXuEdCiI47HKLBaicxWpXIVMSAp3It4jkHH5yKPjlZnHBpUTI4z0YsMQvenbgBtb2NJDDgAMPRlLYvPdb5NM0v1H0WBn/Adv4CYEB4Dcod8LIyNci0SR0X1e3VuzyUgfsKtLryZ4spKdChtMKnI7cJtKWxdobMGuLz32SKSO/GORscEXYd6tm/t3JF73tb8ySG3KAIIqqZZ1qdKDRw+fP0W69eoEahXSlh3n6bGj39sMndoG4Kp/UfXA9/x595ddwgSPiAGt+X9y+eKJtZYWUXuGJjzdZR9ZdL48g+NTunas1ztgrxnvFXe4x83dvGUBFgDnUcQ7bQ+CeXf+s3QjNpF7HlpPFJeZyV9pOaPqPSWnMOg01AO7ITSG3BtwJrQ6XE5otqnYGNEJUNMmjEL8XHv2H7ZjLTWeTT4uFD6w5IjunvRcW+9EMUCpy2dUPNRK/av8lV44dgs0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB8379.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(6133799003)(22082099003)(18002099003)(3023799007)(11063799006)(10067099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVkvWXhUUTZqcFJVY2EwejVLU1IxWFZUbEMxL2FIMENVeGxFbGcxRnZtZG5D?=
 =?utf-8?B?em9Id1Z3bzFWUFhRbDZDclVKdmJNc0FyWVZLczFMejZDVExQcHl5S1VDV1RI?=
 =?utf-8?B?WlhKeXhPSklsYm44VHRsRzZ5V1lMQjdRTHpRekJPUnpSeDZQc3BMVXNnNWp0?=
 =?utf-8?B?RUM4VnBIZjhlNU05aGVvUU85TnI1NzgvTjE5ZkxxNit2YjlpM0dzVXljRHg5?=
 =?utf-8?B?WFJqS0ZQQ2RRSUFlNEtTaW9OeWhmWGJzOWJQZ29wSUJHdGtLK0lCbXVLcVB0?=
 =?utf-8?B?MHVobVpCR1Aza1N4NXUyeDk1YWFKYTNiYmtlTFo4UlFPZC9ydzZ0QWU1YTgv?=
 =?utf-8?B?K0VmWCtURU8rT0V2eTliWS92TEYwM3F3dHVBR2I4cTRudE9FKy95V0ExQkQr?=
 =?utf-8?B?YXorRjBBQnp3TGZKQnJONW5jVHBHQ21JZ2o4Q0crc1dqNXNTUXc4VUhRa0l3?=
 =?utf-8?B?U29JOUVrZGxZQXVydEVlTGxQWWExRE5qMklCVjRJNVdhc1lScW9NOXFaUVJ5?=
 =?utf-8?B?VlpPdjE4VVZQbFk1WXlzM3FKaEV2V3pnZ015NS9rOTlZdFRSWEdjRnBkOEV2?=
 =?utf-8?B?d1BKa29QMGlnNUZseVVNS2F0UmU3UTNCQ2wwWWtZZGdZNlVPYlpXeDRMY3JK?=
 =?utf-8?B?YVI5Y2huTFNPRTdJNW8yczJkejlyLzZJSE1PUEx1NVBjaklubEhROGpPQ1lD?=
 =?utf-8?B?bkt2MHlEVURzdHdKQW54eC9ya2l5WFozdklXaXc4Q2ZqWUNiR3JzWmpjUW1S?=
 =?utf-8?B?a1pJSUp6VlJBL0lYcDRkMzZWNFN0SmpIL001NSt6MGYzazVac09FYTBlUU8x?=
 =?utf-8?B?RGdhZmxvWHlTeGVxZy8vc0VkY3ZoZmk5R016aGU1ZnpXNml5aVo3MG5JUmtY?=
 =?utf-8?B?a2lIdkVOZTdaMm1zOE9UVk5MbUV2dG82VWFxaWFKbkFzS1Z3c2JLQ2xhdEQ1?=
 =?utf-8?B?d1JCQWlScXpHbjRpM3hiZ0lZQU4vdG1yZWFTOGNkQ3hrbnQ3YTgyM0R2YkJq?=
 =?utf-8?B?YVFaTFlVenlacE42NGtOck5IZUdYYUNpUGdGNVVQYi9lcks2VjZtSGtRcjZ0?=
 =?utf-8?B?TWFCYUhtdEpOMHMxYlpVeVFXaHBsbVBXOXQxc1huaHZzMktSRTNGMWNOQnNm?=
 =?utf-8?B?V0U1ZEVxeVlYZjZ3Ym5HOVZUQmsvdU5MNGFMZGN4L3FQeU43QWN0cENObVRt?=
 =?utf-8?B?ZzdsM2gzdzJPUDhhZ2hBZU50RkZTY0VkcVE4ejg3OVpHRnNaZXpabS9Oa2FE?=
 =?utf-8?B?L3NKVkZDd2E5MzhwQUViVmFEdEJCd083ME9zVytwcTVWNlNTUnBQQ2IxVzgr?=
 =?utf-8?B?YnZvdnkzMkM2bTdYQkQ2TW9lbDVFQ0ovakgwckx6dDh4R3VGTDQ0b21mdnp5?=
 =?utf-8?B?UFVyYVl5eFdZRlhOMC9sbXZwOEdvSkQ5MFVuYytJOTl4M3BuV1NUWFNrNHZM?=
 =?utf-8?B?MjEvQmZqSmpTVmZzc1FBZ3FPMkdBOGpRamZjQ0IzaHc4b3hZdkh5SlpvSDlT?=
 =?utf-8?B?d0dOWHVKK2ZBYzBFS2FJUUxvVGJjSGg2cmVxRjFPczBoOTV5SEZtWDNCOWdD?=
 =?utf-8?B?bkFaTzlHa3I1Y2R1UEhoMUtnckhNYW95bG9CSlhHYmZ4ejl5TnM4Q3Y1eVd6?=
 =?utf-8?B?T2F0SDFnVlhDWjVrNnhGQ2NiLzRweGd4OFJqVjBURnFSZWF4WDBkQ1ZJcGJl?=
 =?utf-8?B?b2tMWTJMamN1ZEk5QzMxTnVVc0ljdlg1UjFsempoN2g1V252K2JVOWhNNkZH?=
 =?utf-8?B?TTA5Yk1tTjByK1k0UU9MQzhTc1FlRno2Zno4cU9DWWt0QU5MOGJ6R3o0YmJq?=
 =?utf-8?B?eFZzcmRzb0p0YVpBYzhObS80OHMzT2VyT3djeW51MDJpcEwvTXRXSlkxVEFL?=
 =?utf-8?B?WHBqRFFnVlVXeXBSNW5yYVF1RW56eURsSW9GSUZzeU81N1o3KzEzeVBjaTNJ?=
 =?utf-8?B?MGlOSXd0czlEYlh0ek5QUjBxazRuR3NEemVBWkhEa0h5TnVxU2N2SlRIdlNJ?=
 =?utf-8?B?ZVBZNDF5WkY1dTQrZVVpSXUzdlhoYm5SZWs4SURFc0dKR050Z1YxanBialZG?=
 =?utf-8?B?ZW1wTjZMSDcwdTBSczNjWUp3VEJNQlV0dTdFaVAyek1aZmhhcU5vRXpmdUpF?=
 =?utf-8?B?amhqQlBuOEx6VnpsRC9BckpHa2d1bDdCa01MYmc2VkNYaHkzeEZveXJNalkr?=
 =?utf-8?B?QWl6Qldhais2S0F3S2ZNSmlOMnlFNVJhVnQvclF6VVJLajd5K29pUW5yUVN2?=
 =?utf-8?B?dG1ldDQrNWZFRlVhc1YxVDFzNFEzSzlRQ2k3aE1pK2pFbHZLNDhiZTB0N1Zp?=
 =?utf-8?B?T0ZaUVVCcjgwbEZYOWsvMDZHdXlFa3FqU0grUXFvcmR0emtDQVhLbnUvZmty?=
 =?utf-8?Q?eRWEWfNGg9zJYHyM=3D?=
X-Exchange-RoutingPolicyChecked: 4RMp8+Sh34m8DAMZfKE4K+sHjk7HaC/5reLH9PY1epbMCkz4G2+gV3uEUew3B66+qK5IumEvaf4fyBBaz4W5pv/Jfe0zl38rV998l6tPXnzOnODb9BXrAUJql1rjubDuin6Gr8EOLxNSmQ5vTqraRNbd59TeqVHFb0cU7od4+HGQ0PWWcfEj3YD5wmKfz2NrvAnAr52H8rAqV4+eJxmTZpdbd1kc55BFuuclppH0lFWibhTwWeBJGNtq0RV93Ff6wILk+OjqWc/leBDn/wmpWMxYNPQ7iiKr3Q14hVcDbWgTJjTcAhc6pBHYrvUMvIFL/Qh6y0ionUrT7r6GGISElw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dc2a8d5-07e2-4fbd-7ec3-08df25c28146
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB8379.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2026 05:02:23.3932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5tkRpEDFJgMj9OMDa/KBrQBqNgMcPB4k+u/9pHvVlEEGEA0z5YQBJEDqnIHwD2SECGPQXkohGriKr4YVbJMhCb4rrt1QBYl4fg0u1XR7wrM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8224
X-OriginatorOrg: intel.com

Hi Tony,

On 10/8/26 4:43 PM, Tony Luck wrote:
> resctrl can be mounted with monitoring support only, with no allocation
> support. In that configuration every task that has not been explicitly
> moved to a MON group remains in the default group, and CTRL_MON group
> membership is decided purely by comparing a task's CLOSID against the
> group's closid.
> 
> is_closid_match() also requires resctrl_arch_alloc_capable() to be true.
> On a monitor-only system that is never the case, so the check breaks the
> default group: it unconditionally returns false for all tasks, and
> is_rmid_match() also returns false because the default group has type
> RDTCTRL_GROUP rather than RDTMON_GROUP. Reading the root tasks file then
> shows no tasks at all, even though every unmoved task belongs there.
> 
> Drop the resctrl_arch_alloc_capable() test from is_closid_match(). A
> CTRL_MON group other than the default group can only be created when
> allocation is supported, so for those groups the test is redundant. But
> the default group always has closid == RESCTRL_RESERVED_CLOSID and is
> present even without allocation support, so the test is wrong for it:
> it is exactly the case this patch fixes.
> 
> Fixes: e6b2fac36fcc ("x86/resctrl: Use is_closid_match() in more places")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260831174421.13921-1-tony.luck%40intel.com?part=9
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Assisted-by: LLM

  [R18][R17] must-fix  Mount described as selecting the capability set
      "resctrl can be mounted with monitoring support only, with no
      allocation support." There is no mount option that does this;
      rdt_fs_parameters[] carries cdp, cdpl2, mba_MBps and debug only.
      The capability set is a property of the system, established
      during CPU detection. Use: "resctrl can be mounted on a system
      that supports monitoring but not allocation."

  [R14][R23] nit  Same term, two spellings in one clause
      "comparing a task's CLOSID against the group's closid" switches
      case mid-sentence. Pick one spelling.

  [R8][R23] should-fix  Problem statement transcribes the condition
      "is_closid_match() also requires resctrl_arch_alloc_capable() to
      be true" transcribes the condition the diff removes, in the code's
      own vocabulary down to "to be true". It conveys nothing beyond the
      hunk.
      "is_closid_match() additionally requires allocation support"
      states the same fact in the changelog's register and chains off
      the context sentence about CLOSID comparison. Let the solution
      paragraph be where resctrl_arch_alloc_capable() is first named —
      the problem is then stated semantically and the fix names the
      identifier it removes.

  [R23][RC5] nit  Vocabulary changes register between paragraphs
      Paragraph one uses the resctrl.rst terms "MON group" and
      "CTRL_MON group"; paragraph two switches to "type RDTCTRL_GROUP
      rather than RDTMON_GROUP". "because the default group is a
      CTRL_MON group, not a MON group" keeps one vocabulary and stays
      readable before the diff is opened.

  [R23] should-fix  "root tasks file" is not resctrl's vocabulary
      resctrl.rst calls the group the "default group" / "default
      resource group" and reserves "root" for the directory. The
      changelog already says "default group" in the context paragraph
      and again in the solution paragraph, so "root" in the problem
      paragraph is also inconsistent within the same text. Use "the
      default group's tasks file".

  [R12] nit  Self-reference in the closing clause
      "it is exactly the case this patch fixes" — maintainer-tip.rst asks
      changelogs to avoid "this patch". The sentence already lands
      without it; "and that is the breakage described above" works, or
      just stop at "so the test is wrong for it".

[R8][R23] should-fix  Reserved-closid detail is not part of the argument
      "the default group always has closid == RESCTRL_RESERVED_CLOSID
      and is present even without allocation support, so the test is
      wrong for it" — only the second clause supports the conclusion.

  [R13] nit  Antecedent of "it"
      "so the check breaks the default group: it unconditionally returns
      false for all tasks" — the nearest preceding noun is "the default
      group", not the check. Naming is_closid_match() again removes the
      wobble.

> ---
> 
> I fed your AI review to Claude and asked it to rewrite the changelog to
> address all the issues your AI raised. Here's the summary Claude

I suggest that you feed it Documentation/process/maintainer-tip.rst

...
> 
> Claude put the "Assisted-by:" tag after my sign-off. The tip maintainer
> documentation hasn't been updated to provide explicit guidance on where
> this should appear. Looking at upstream commits people have picked
> different spots, but immediately after the author sign-off seems common.

Previous submissions to resctrl that used AI were merged with the tag before the
Signed-off-by. For reference,
2d77f9768850 ("fs/resctrl: Prevent deadlock and use-after-free in info file handlers")
f5bcf539484d ("fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()")

As I understand it has become more important to also note what AI was used for. Using
AI to write the changelog for you could be perceived different from using AI to debug
the issue and writing the patch for you. Reference on this topic is:
https://docs.kernel.org/process/generated-content.html

Reinette
