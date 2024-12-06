Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC2018D65A;
	Fri,  6 Dec 2024 07:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733469564; cv=fail; b=TJj2rGTz5lzHlBiSGUDRmjgGsmVV9Q2xErCU35oFbVD86ESP3chn3zrmZZt/rpnh+MBChQqAxY/hszcHydoPFgJpZdnYHZpITf02AVUZPNmxdeRxBZAp2lLof6XOc0lDiW/5KlN7mLF5tQRczB/IRklIDp1uVP7Ha/Ba+PRhHN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733469564; c=relaxed/simple;
	bh=8oo+6/pXVpqiohZtykOJzqv4TqyoOzyBn7+MTYD7Jvg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RYFO4i7VNd3CAz5e0vKObR1s+pjA6r5XgeYlA4GiLcLn2atiOk6PGRxjmjmWxQG9m5NuojstuTSReNcnZTFY5OhqMqLhrt1QDusGDD5QHx40L/8wm8Vzn86gLPZOQkLuuHuHI/Ae0Qq3sbv6xXPsbpvVUD1Lg0SzH8dCNlVvJA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I7hPMNvv; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I7hPMNvv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733469562; x=1765005562;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8oo+6/pXVpqiohZtykOJzqv4TqyoOzyBn7+MTYD7Jvg=;
  b=I7hPMNvvmznPEyax9B0ckx82GGG5wmmVh7jELQt57EJLHVgHy26wgz79
   1KEQI4v+pTm11Ac+3w/WlrLgcaf0bJQJR4k1E2mBUz1eF6KrJqbddWaq9
   GOWE0MH7hXhS6ssnVObFMx636ZJQjAU4/mFeGvikG2Ml1Xlh/M89P6rbk
   HYNKGOhmU+ZrW5dTFGmXi2T5ccuVn7f78Y6pcgl4BRiHSsv1gyeho+rUU
   aKNX79nG1uje8WORwVBptjyuqXK0rj4RUtgWQOlIprMCzYM1Rw1PHQ0uU
   314/KbB6CzLTgBexWHxq9oQ/dIfRXTl8fredVNRexez0q9Y8B9+lT6YfB
   g==;
X-CSE-ConnectionGUID: PLSzVTWWQEinw6T4mDJ61Q==
X-CSE-MsgGUID: /snXPC26QL+j+DknysnWdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="37747092"
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="37747092"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 23:19:14 -0800
X-CSE-ConnectionGUID: Ss37xNzgRAK0ZflY8J97aw==
X-CSE-MsgGUID: FPsepQGMQi+AlDTgfsF7CA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="125235342"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2024 23:19:14 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Dec 2024 23:19:13 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Dec 2024 23:19:13 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Dec 2024 23:19:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TetOgZMJWocCxCEqujN0BCpkWSaHEKvrpR0AIQJ9ik2dp4KUh8fXdqeMrIPXbMf2EMoBKs7qFxfy01wsXv8h2ELGHarJaC8JAun6dazqH9rfIyCVGsBDNaQnDEtXOGjQHgtN4c4TzkoTLfA577MVEVNE+PBwk1U3DUikmszT/2kdzlky3nhrtowd+YrNuEyDnSI1vJwY/W3BTsPS4lTTzMi4epXtLrlt3XBfFFXbOdI4uXvNMerUaGW+L6fvrfLLV26iTibAFDr73XJ+kh03uGPt3qaWiNvQ2r74+nlan8bO7zfvaa7WGfd/J0E3JX8wekjZtrZCnoGsmOY4kcAMuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mAY/1QpTfo7HgELGmhRvqhi0gE74sKuvtsf4XAkurM=;
 b=rGqI3cBKt1k2Fy+JbAL6FtmSLS8J4XQtbuiAhPM9RdE5GfuN/UEfieHk0vY7d6iZgG9Xk4Gci+qA8U023qXXCg9LxCp+zTELz7bLAIoQfNANdpfD3bNqhO/5/mgK36GaHIVLvgbPOuirKBCCsAUWJrHh3NEQAs7oy/+Rt5rEC5dLIQSGiw6+lKcUB8S10Bq49dAgwlkFpdAnb2eH29Xsk0+QiROZQogp5DBQIxUm5Qs3XEAXH/UalxU0xGj0XE0CPDBe84Mn9BFSp+r4vuYHI8VpIOMB5TlyT7IHFbQ49zAXaxryko//noBC/ZQnqXt69MNwy0qJrFbb36A0ngz8zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB5767.namprd11.prod.outlook.com (2603:10b6:510:13a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Fri, 6 Dec
 2024 07:19:11 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 07:19:11 +0000
Message-ID: <d0f1371c-f5fa-45f4-8a69-128f41706f13@intel.com>
Date: Fri, 6 Dec 2024 15:24:14 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu/vt-d: Remove domain_alloc_paging()
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, Will Deacon
	<will@kernel.org>
CC: <patches@lists.linux.dev>
References: <0-v1-b101d00c5ee5+17645-vtd_paging_flags_jgg@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <0-v1-b101d00c5ee5+17645-vtd_paging_flags_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0017.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::19) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH7PR11MB5767:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ee72077-4ea6-49f0-a212-08dd15c647db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NGUvZTdmeVduMUlGeTRkR21DREh3N2E5MXNmSTg3S0FWSjZCc0J2SVFEdHJp?=
 =?utf-8?B?TWp4UHI5QXdpNXdxK3QzRWlnQ3AzdVgvd0wyM2hJYllkaGMramVhNGg4OGNG?=
 =?utf-8?B?ZzBnUmVBUnIvS2dCaWFXc3E2NzNtTTBKRmpIQ1NqMG53Ynp2ekpwYmhJdzRW?=
 =?utf-8?B?a0FvQStBTEpTRWEwNHplZEVxajJLMUdOcWpJNC9TSEc4K3pjRUxBZlVrTlVi?=
 =?utf-8?B?NDhKNnFOazB6S3ZoYW41OTJ1SnNoV3U1Wms5eXdSR20rcnBYK2E5dExYTmIy?=
 =?utf-8?B?c2VGVnYzM0pMb2dUYlQ0UGYrTGR2M1pVS2RSb3dPemR1THhuSk9JNzNTaUVB?=
 =?utf-8?B?S1grQTFUaDBGVDJpMUl6VEprMW5jZEoxY2hWd3Z6UWdnQ3c2VEQvNXRtT3Fw?=
 =?utf-8?B?czR4VjlPY2xwZkZpbmFiZHIxamdTWDR1OUpUSm9qZm0zVzB4UWwvQlc2YkFG?=
 =?utf-8?B?b2Nja0tzelhEU1lNS05Fa3g0MnRCaW5WMjRxb0JwNEM4L1BKdW5vRENRUmFI?=
 =?utf-8?B?djB1b09sbUNZN2wxamlJQjU2c1V5RnJQZ243a3FzcDdjakNZNGxVWkZvZ0pR?=
 =?utf-8?B?OUZ4dHhaWEhYdU9adHVBV2VjQkk5V3A5dlZoM3c5Z295MnBQeGRMTUViWkZU?=
 =?utf-8?B?Z3RScjZFYnBUazFhL1BzR0tPVGNhVC8rR2d2ZzFBSkQ0S3NkZFlwcGdQbjd3?=
 =?utf-8?B?OHBDWnp0c0hvMWQ5QW15akFOLytjOGpKamdVdWVjQkFHUTh2alB4RWRNQ3lG?=
 =?utf-8?B?K1JpWVFub2lsN1lqWDd0N1FCSGJjNVZVTWF2V285UGQxMU52MUh2RGQ5cjBB?=
 =?utf-8?B?b2I1YmJ2dTJINHhaZmpyWVlibXNjZWNYb3EwRjE1ZFh2bTZKV2pOVDNCcUYy?=
 =?utf-8?B?cEY5UHYzRjZtZ0ZlbWNSbE9Gc0hldCtSeVpoUFlORVhwZWJiSis4Vzc0Y2Y0?=
 =?utf-8?B?UXJzY2VGY3QwV09iR1hRcFArMWJHbXlUbHF1OTBEUEhINitPRldIR1JNS0Vy?=
 =?utf-8?B?ejVWTWlkdFVEc1NxS09QTUZDVVNQL00wN296THluUkNqbDdlSC90S2VjMzlB?=
 =?utf-8?B?TzZXaFcrNTJKK24vbjZxOVo2aUN0Nk1KekpzRlo3RW5QcmVodGVIZDNSOFlX?=
 =?utf-8?B?cmJ6TU1lbnMxWWdwR0dmSXNudWR6VThFRWJlMGZOUVRLZzg2UFpIRHhIR3FU?=
 =?utf-8?B?Q2dpNjBoME9IT0MvVTI0ZVM3aEJSNjBZV1I4V2lyam5aamdpRzhhcmY3TTRV?=
 =?utf-8?B?ejczMm9KOXlob2ZTRStiaFY5NE5pOWpoWkxHMEthNk9EaHRkRWo5MmdDdEN1?=
 =?utf-8?B?N0xsM2p1TWhGMEdjLzBoWFB2cmd4bHMzVHpGTmRVWjZRSU1WZFVhYm13N3ZC?=
 =?utf-8?B?bElnY2F3SG1FZ2p3cGFrQ0NjdmtENktaaW56KzV6VDdpOWp1ZWhEZnVOTnpR?=
 =?utf-8?B?YnpYYjJ4QTdVcm4rNlN0Qjh6dEpUdlRKYWtwa1h3TTRENlNxWjgwZ3hnZU9E?=
 =?utf-8?B?VEkwSTZhbFlQTnM1UU9RbGJFRGs1YUhBcWg5UVJ4VEFvd0VLV3VrNHRDU0pp?=
 =?utf-8?B?MWkyZ1VUa25KL3NIZnBhMXJ4RDVKaVNPQmJ5UDFrdHRBYkcreFp2MDRCQUth?=
 =?utf-8?B?anRWemFocnNSNTRxcXhSZnlPVWI0dWZEdjJHZTN0amJRem5FZDFFSzZ3NjEr?=
 =?utf-8?B?R240ckhYNHdDLzVqQW1QdktRM2hYMVlUSnljMGoxYVpJKzUvTE1Id2pLRzd1?=
 =?utf-8?B?UStiZHgvSituM0YvcWdrd1E2dVlCbTY0QlN2cnVhelFGTll3SmJIZTVTdng3?=
 =?utf-8?B?c3JUcmNYSFpqTlZ4VUhSZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkpUOVlMd0xnVjVRdnRnZHV4THZIWGpHL2VmOVhhRC9xOEVaWkR0VEp4ZWl6?=
 =?utf-8?B?RTFqWmlHZHNKc0RhM2V0aW1STUtJamNSVm5ybElmbUNTZk9HL0g3dDNUMXVz?=
 =?utf-8?B?RHNRYlhuN05sZStkeUJIUEwvcWJkRmZteUFIeHBjeTVNS0NJV2N6cXF1MTh3?=
 =?utf-8?B?RVg5aEpyeDY4TitXQXdBUVJkVW0wcnNGV204NnhwVHlLcEdJM0xhU1BYQ2hH?=
 =?utf-8?B?dmQ2REFhTjhPL01TUVVGZlh5bllmK2lSTFlmMnhDdzh6dnJuMHpidndXM1c4?=
 =?utf-8?B?bjZHNVk4UkJqL2dYWXhnb094OXpZK1AwU2thdFh2MWhxQStoL2NnSU15blFo?=
 =?utf-8?B?bG53QmtKajBvSFRtWVZJUklDQTBNZXByY2ZUZHBNaUZhalRiQysxMm5JTVBr?=
 =?utf-8?B?aHNlUzVlcDNKR0J3ZHBBQW04dTRaeFlWM3gyN0ROKzhOU2FnSVVHaHc5NGtZ?=
 =?utf-8?B?ZjVEZVN1OWpwUkJweGJ2WEpTWEJOVllqNldEOTh5TXlCRFMwVWt5d0pQc0VM?=
 =?utf-8?B?TnZYZFYrcjdvdmZ0M0V1UFg0cWVyTE5hbDdGUWw0b1kvV1FVOE1uSmZkUGt2?=
 =?utf-8?B?Mzc5WmlFbWZncEhxRlBrdDZpWEVxZzRsdWo2SEd6cFR5MDNnU2dnenRUMnpi?=
 =?utf-8?B?ZVZGa2xIS2xXNHQza0dFOE0zVWNkTmZrWlNBU3FMUG94U00zallXOElycVhF?=
 =?utf-8?B?ZzZObGhtYlZvak9jWHlub1BSWWR1aDRDV0duV0pIRWN4UUlYc0JFNFBBM2Yw?=
 =?utf-8?B?U29ZS1ZXaURsU1NGZlFkSVpodjVLNUhVYzMxejE2WmNaZnphWTBMQzZvMnNu?=
 =?utf-8?B?QUdQOTFxdTRUY1Z4OU9VS3BwaWVkd2U3L2Q5SnFiZUNpZ3J1dkw1cXkvK2FF?=
 =?utf-8?B?ZmdXQWhIUVNDWjBuZkY3Qk1WYVpNeGhET2U1clRxK3ltUEtLck1DMnFJTGk5?=
 =?utf-8?B?VzlQRzZGRXdJZkNrL1dJV1htRnZDNFhXMjMydnFEUndvMXI2R3lKS3NML0Y0?=
 =?utf-8?B?VFNSK2JCVG5IcEZRbnBoc3NiVUI4QklRQlNaOFJYU2g5S3hjMitMUk1KcHlz?=
 =?utf-8?B?RE8wMHg2NllZdXBQcDFEM2RldEtIVFBwT2JTRWZsMEtRY0NReHF3VzFRbkhp?=
 =?utf-8?B?cW5OcCtxNXF1dFNzcUloTmVuRU16NkFSbENROTQ3NlMxUFl1dUdKZnBvWEVG?=
 =?utf-8?B?QUY0M3N3N3EyNTJpUkd4RFlCSUlsUTk4QmF5cGtSN0ovdXpqWWFqQVA3by8w?=
 =?utf-8?B?SVFUN2l5WWxvQ2FsOUxtTkdPeGd0SlJUbFNKTkkzU2FpdmtSbUU1Uko0OGpl?=
 =?utf-8?B?Y3Y0bEs1T2kvR0pLaks0alRaZ2lzK093eXZUc21zWEJ5MFZoNHhFenkyV1NC?=
 =?utf-8?B?NzRYNEtPSXJYL21OdktMaWM0NTlDcENPMlIwTENBbU1rYTd5S0ltODRhM3FR?=
 =?utf-8?B?RUZaNlRuaVZrazlOc3hUWnZVUGVsanFBdkZCRVhNdXU2T3ljWEZRQTcybVlu?=
 =?utf-8?B?SHNIV3h4ZVRNRzh3NENsTitubHUrRzlZOVYwNytpR3JRb21WSU1tbGIxSkxv?=
 =?utf-8?B?QnFTWEM0YnFIMFh5Z1MrS201aVBNb2dIRitGUWlCRGlIdlJ6QUhxTzZUaWVH?=
 =?utf-8?B?enJtNzZOL3JMcGZLRmQvcGF3MVJ4eEZNMUV3YlF0dFRFTE16MUExYUJvYUJ3?=
 =?utf-8?B?SkZuZWhGc1J4TTVGcDdPNFlVZ3pBcnRwT0NMMHpCM0g2eEpzQjNISStNb0R6?=
 =?utf-8?B?eEM0YnBZRzIvZDlLbXNWU1BkazBOM2NFR0dTOU9NcFZwUzZ3a3NUNzZEend3?=
 =?utf-8?B?VC9yb1FpamJYL1BORzJjVk5tY0VNVVBwa3N3N2JoblROdkhQMEYwR2RxalEy?=
 =?utf-8?B?TDBVdWJKK2o0M09LeTlqakpLeVdEa0JlRVdZVkFKUkJ3eHpGdWJWcnEwT2Mw?=
 =?utf-8?B?N25ubDFYbTZmRTI1aU9iOVhXUnNMSlBKM3E5U3A5UjJhUjRaZk1qM2dtODJs?=
 =?utf-8?B?V2ZZR3AzbTZaM3orMm4vVkQ1SVpsK2RXekxJUFlOK2h6SVZhTkYwa3ZkcTJ3?=
 =?utf-8?B?c3RXWFhXQzViUDk2YzdnbFZCc0xBMkc1SGxtR3d1ZTY3ajFsR3JxWWQ4Ymxl?=
 =?utf-8?Q?BS+/FB/+N7m3zY6Mi3Ah5izSL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ee72077-4ea6-49f0-a212-08dd15c647db
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 07:19:11.2743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uC+JT40nh0K2lDZQbpmChqoAbmJcaKXCq0SGm3YKERx/2G46vPcEY9wPCI7LZFsZ0ilg3vWCYabBxTb+3LxKLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5767
X-OriginatorOrg: intel.com

On 2024/12/5 04:14, Jason Gunthorpe wrote:
> This is duplicated by intel_iommu_domain_alloc_paging_flags(), just remove
> it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/intel/iommu.c | 16 ----------------
>   1 file changed, 16 deletions(-)

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 7d0acb74d5a543..88e4e867012cba 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4443,21 +4443,6 @@ static struct iommu_domain identity_domain = {
>   	},
>   };
>   
> -static struct iommu_domain *intel_iommu_domain_alloc_paging(struct device *dev)
> -{
> -	struct device_domain_info *info = dev_iommu_priv_get(dev);
> -	struct intel_iommu *iommu = info->iommu;
> -	struct dmar_domain *dmar_domain;
> -	bool first_stage;
> -
> -	first_stage = first_level_by_default(iommu);
> -	dmar_domain = paging_domain_alloc(dev, first_stage);
> -	if (IS_ERR(dmar_domain))
> -		return ERR_CAST(dmar_domain);
> -
> -	return &dmar_domain->domain;
> -}
> -
>   const struct iommu_ops intel_iommu_ops = {
>   	.blocked_domain		= &blocking_domain,
>   	.release_domain		= &blocking_domain,
> @@ -4466,7 +4451,6 @@ const struct iommu_ops intel_iommu_ops = {
>   	.hw_info		= intel_iommu_hw_info,
>   	.domain_alloc_paging_flags = intel_iommu_domain_alloc_paging_flags,
>   	.domain_alloc_sva	= intel_svm_domain_alloc,
> -	.domain_alloc_paging	= intel_iommu_domain_alloc_paging,
>   	.domain_alloc_nested	= intel_iommu_domain_alloc_nested,
>   	.probe_device		= intel_iommu_probe_device,
>   	.release_device		= intel_iommu_release_device,
> 
> base-commit: f6ba64bc6669cb5152a31a474734308dcccb3ed8

-- 
Regards,
Yi Liu
