Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C90388E63
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 22:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775602614; cv=fail; b=SHt3gEXDp78MrkMMKQ3DyX0KuAYcGVqfVzvpLjwli+e7imkj6yo0k4jhRIWS+He1HCakn9aPLqzSjdt6SFG4AiX2OrFj9KF4LW0b8SjM833Wr/uLbhQ6IrE5oLoCbwdIHAiNZk4pb+PS55nT4OniYeQmQfRSqbnzIc8Ifz4tvYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775602614; c=relaxed/simple;
	bh=sdwrZd5FbiUF3vSsMqfTy/99PCEq3rniHM5Bm9BHWJA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DOxxKaqwH+2i5LCJsWm/ZyWvvkrRhAFhEM8pwvgT5qAfLzj75TPoYlHYrleikqgoMFT3mZ8js4QlwetbQEHL2vkGzvIPWnlLBfwVL32Q+M8ZP6ejS9K6m1uRAeoVw00itleKiMOb5LWp+2r6LySqLZVQlnpBNQgTLzqae2RQi+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nQ9iVIai; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nQ9iVIai"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775602613; x=1807138613;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sdwrZd5FbiUF3vSsMqfTy/99PCEq3rniHM5Bm9BHWJA=;
  b=nQ9iVIaiCBC2A/cxZWekjA5TGulbK9V1TCSuSVAXztBPzhn7KVbeq56Q
   Z7KAZX0pzuHbapJ3/+ovSjTmWWqchepHeKADWE4776qX1bSaRfzZeuO/M
   ojjWBi+cdkUx//h13Vv079sAvo5N+cf6zbSRtsaAYPaRIoBv32BOKra5J
   XpufKTcztToH0/OEgYLbYx4szebcBsC/31It5/RP5FKQ1yu3aMgt4GeUV
   Y8hdJOFIgYPRSuTGzL648bGCCp1X9LiQELGKtolyMZR02t0M0yjn/fiA1
   Bg+MXgjthLpLQiOPKp1YBFOwS2+CEJW7PEIO4PVP2ANmFFVUiwT3uxgHo
   A==;
X-CSE-ConnectionGUID: gj0zL87RS/q8OIe0qV53zQ==
X-CSE-MsgGUID: WgQ0OBGWQd2ieKUdcQdAow==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="75615366"
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="75615366"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 15:56:52 -0700
X-CSE-ConnectionGUID: F6EN7y5hSYOYpdCdvRNCwA==
X-CSE-MsgGUID: au6ipEpXS4eyvRuvlGNfVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="227462518"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 15:56:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 15:56:51 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 7 Apr 2026 15:56:51 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.21) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 15:56:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AtlwxMRdD/n/Nc4JLYPHeCXeKW401lknAV36Y9l2kq37ZJ2AWeQAQ5pb7esFhZoYzl8ldymHpx2KBNsqJqEilNfWO75cf/FGy426TUrFc+PfQcguGXp18IDpXQg9I5xIWaT5O92f3X+w/pMxEhxOFM9witE6bPE70B6sETGJAjDkrCG3vJiTx0YtrcSRZCCUn+9+LqsBVQpwYf9Tx7KI6StUvCbXBNleXyo8it64Vsl2bcPX228mVUrMRdN/D4gMiSBOitSy1VKAksU9RsXF1+zB3YS7j8RINyUzwOl5fLJenGvuN4pP+Ux0nBvHCHtzlrm4hNHkRJPnPc3SI3JWrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GnCzn63Fhu69AQjcblMxXVBH3nBt8c/ffdGGstdMnVs=;
 b=YfNwYMAEpU2DRqlosbAe2nMinbf6ojhPxkpDIxKsyTez+azEIPt2OJPL3bmNWT7qxYqXI/ZMLI4ODadv1xdbbQBuAx3jsMoh1gstSbESVSqkgdvlYiciK/kOgLCK4VX6QLbsKoQLE8TFEtCYjC4/OmfoHdoXOWowkITWMdI2MAweSJ4GNqtqKElwJm7fEQzpcEPQMZIRQ/xnt+xSVsQcksrAfHxelkPfBrNb9RdoWvJhfhdw65+pwqNwh2J3TWP8OGmDQd/DIDgy/cK/Ym6RZC5l2NO+qiF099Y/rvrNsr5lK5nV7V33AxwQDzakB0gka4NuTEWNJWxM9T1dD6PecQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB8173.namprd11.prod.outlook.com (2603:10b6:208:44e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 7 Apr
 2026 22:56:49 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.017; Tue, 7 Apr 2026
 22:56:49 +0000
Message-ID: <6141d358-71c2-4aad-b7d9-b91c7433f4d5@intel.com>
Date: Tue, 7 Apr 2026 15:56:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/13] fs/resctrl: Avoid "may be used uninitialized"
 warning
To: Borislav Petkov <bp@alien8.de>
CC: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1775576382.git.reinette.chatre@intel.com>
 <56fa3b5937ec6fda4eec162393463d8dbfc1abe4.1775576382.git.reinette.chatre@intel.com>
 <20260407185543.GFadVTLy82sBzT3eej@fat_crate.local>
 <e89edbdb-b6a4-453f-99da-41991ad25712@intel.com>
 <20260407221908.GGadWC3BaUzStnu9Z5@fat_crate.local>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260407221908.GGadWC3BaUzStnu9Z5@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0127.namprd03.prod.outlook.com
 (2603:10b6:303:8c::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB8173:EE_
X-MS-Office365-Filtering-Correlation-Id: fcf37254-09ee-4154-e415-08de94f8f3a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: P7SMccDwXjJH9D+5rp0NGqam3g3ZDCCJEaLK4GgrupGwRshB2ip1K1ATDyBoadcxksDA+gO8fHiz4C2d39wuJE4O5iank+GHqpkRaWjQFOW/y5GCVfALtUV1DdYDtDIc7msD6vdDmYAx4lf3k2ezkkx50d6BTJ6GzPlgLZBJja0DzaNbOlclhPLVVSZVtsojvAoGuVAqsT4orjBc/o4KxPIimr7Rb+JgsoQ+/3Vh00cF0Pv8GqB+Wx9nlAKZlxWNpv6TKNG3l3sOC6Dw5N0+FXB30yPJDuPQdSsG7TQaiMvd2C6H4Uaq3r5JklJLbS/emNLEvTWJUYr3AqTleJki4TmqNnD8/ONiiWdTw7cmnFIgJTWuGn7qQuk3DbuJb6da2ku3IRNAFXzFRFYrv8FUjbDZXF+E3h1Pwaqp063F4bVOqSsVGP33xXTPEAA+253kF+okJonyaiAmEDmiqjep8xD/HtgiO4jDx1ELPxHFt4VYbWUOs/iWIp+4bjV6DuYV9TP+8AMVjy/u9MfR0lMcJogCeyQfjlqMIWoFF1J7lmgDJkLgtCxAeNO2y5Tt0vVbcGBznb19Lh9vBRJATpK2lJmXw1sScg40A5XPiggdSsk/uy6+umTM+Msyjrx+NBebCGtAZG0gmQHBf4xWpD7VpZ1Q1JNbD+WZ2o/mKj4WKSSUvzeqnLn9g+NKQPw8JdHLjSBC54FxVB748ibcBJBFZFvjKkJMX09Li/qKVKtaQoc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUh3Z1dmSzV4VGFoL2JRajdxUjdJLytCYzdjQjM4U0tSVjFWMkRJZ2M5ZnhF?=
 =?utf-8?B?WHptcXU5SnZxUTEwZE1ZMzJkakE5YjdPYVN0Y2NCYkl5TW5OVmdBTTVtNG92?=
 =?utf-8?B?TEVrY05PWklIdHNrUzJYUVdaR25YUWRJZGVqS2JzVUpHa2JpZWxBQzZXajJH?=
 =?utf-8?B?S3ZGVmhLdzlNMnRzWk1iVDBoTE1Ud0tCK2daWDBRZ0lnZHVQVm1kVGtsd01Y?=
 =?utf-8?B?SGxBVTZhT1dkYk5SRTdVK1hmRWY5Ym14TTh5a1ppMHVoU0gwN1YyUndTRkVH?=
 =?utf-8?B?R0hTb1Y2VGw2WWUyS3ArSE10UUoyZmhWZTdYS292eC81ZU54dHhqekdad2pH?=
 =?utf-8?B?cTBCMjUwV3NtWFpCTjRZY3B0TVRaNTlKMWpnbDJvQ3FSVEJMbVpHZGtMRkpi?=
 =?utf-8?B?c3F1S3VNQi9HV3ZkcjVEQlpnZ0Y3V0pZNGl0Mlg3STYvdm1rM3ZBTVRnWWpP?=
 =?utf-8?B?endLVlBKNFZUTWE2Qk53YzJPSkt4V2JNUVlQbS90K2kxSGZNalFZWU9NSnpZ?=
 =?utf-8?B?TlhJci9jbU1mdVd1ZVN3bFhWQkFuTi9SLzNVRlpFWVVjRXZxQ2ZXUU84emVX?=
 =?utf-8?B?QXcrNjJPYzF2RTMrdWl4bjRRNy95TmZhNVZ0QlJOVkpDSHZvVUdWd1R3ZnBq?=
 =?utf-8?B?RkthdXkwN1FyaEs2N0RhT2ZMQUlyZzloTkE3SUJXMVA4ajBXaVBSbUtmVTU0?=
 =?utf-8?B?VGlNMTVUOEZMSVJJSXljbE9kQjZyZ0pSTGJJZFRvbWY2TjU0ZWVBczRmQ2NK?=
 =?utf-8?B?TEM4ZitzVXNxUkxrT0ZLTDFZd2lCbDR0dmM4eEREK2JqRmRONlYwTVNYMmpP?=
 =?utf-8?B?NnZwemYybjhBTDZqWTdSL0ZIcm43eEk1WkQ5YVJ3Y0lVUStqa1luV3c1VFZ1?=
 =?utf-8?B?SlZSK045cytZVHpjTmUxVGNsRVlUeFc2YWpscGEreWNjUnJKb2VQMU8vL1g2?=
 =?utf-8?B?NEhjS0hXMzdiS0RJS3pNSlUzSmJJUFY4c1MrMUFLVzlUSlJwRUIvZHRud3hE?=
 =?utf-8?B?YXIyaDJpNkNyaHc4UFVxZ0tLRVpTNFpMRXE1bEltYTJZMDBMQjQ1bkhSUGJi?=
 =?utf-8?B?Tk9Hd2R1R0JndGY5ckd4enRjYkJzbm94Zzd2QVhDZC9mOGxsMFEvdDMxOTM3?=
 =?utf-8?B?Z05ZcXVVMFZrRk5qWk04WDA1d0NPNkQ4dURwalBLeVZwbldPNjF5NFc1TnVj?=
 =?utf-8?B?L3Rwd0tETkxoVUViYkE3SEFmWUpTaFVGQldQMjliVzBaL2pLMU5tODF5VmpM?=
 =?utf-8?B?MlFmVTdhNllzbjFVcDN3YWdpb2NBUmtiSk8xRlpWL0FXdUVPZUo5RlNKS00y?=
 =?utf-8?B?SVFQY2xyUThNNGhuSDZyZkMxZXZWN1ZqYk01MHM1Mkh1L0k1R0VQaWlxNDZk?=
 =?utf-8?B?b0c1NCtnZ05kM3k1VnlFc1BpSVJhV0xRd3VyYy9BaE43RncyemFZSUd5T3hz?=
 =?utf-8?B?QUY4Sy9SS3N1L283M0tXRW1DSFB3bVZGUGtNU3F3a2N6ZWtDOWZnRDdrZTNs?=
 =?utf-8?B?ejF5QmplNExJR0Rsd2owRmFEV3ZQZEoxZVBtV1dadFA4UE9JcHE3R0VJODd2?=
 =?utf-8?B?V3YwaW1ubkdpL3JCT3IxRTM5RVUrRXJFZ2xncXJlRjgrT0l5a0JzS2toVTFD?=
 =?utf-8?B?Z1F0Z2JoTUUvQmpQWm1sSENrSjJFNUhmbkR2cXJzSjM3Z09RTHZlWE00cllB?=
 =?utf-8?B?WGI4eVZEUjZrWlpxUjBOVjJONERSaUNKTXdaaEhMaU1uRjlkUWlyUlJBT3dU?=
 =?utf-8?B?Rkh4NDBqMGhjZ0w0L0hudklJTUFVOGEybVVEV21LUHpvaVNjS250Um1iS21i?=
 =?utf-8?B?bjZVY29BRjBDM0tVYTg3VTZVNVZyTVdvWEFqNEcxN2tGL2dxMlpxNXovaktm?=
 =?utf-8?B?N3JNVEZKS0dnazc5UTNzeDJCalk1eHQ1NDRYUFp2MXpzRkxBcFA3V0NxSUhr?=
 =?utf-8?B?SmhFWUJYUmtwUGp6Z0QvTnBRYlZubklFNEFTQ1NUNmYzbkJNR1VnVXJuSmN1?=
 =?utf-8?B?cjNEdmhvT1lRTUJTVVhnaHVMcUFvb0QwK0RNbXl6cWJ4YTg5QUFrUGxlVVVZ?=
 =?utf-8?B?TFBlOWk1S1cyZTh4MjM0TXFjYVc2NU0rM0xvdzBlcGE3VlRIYXVpNi9pbDRm?=
 =?utf-8?B?N05uekxyU2Qydng2OUZPZVBiTThjQU9TRGh3WHFKcmhUbEJGbVg5UnJnZkVw?=
 =?utf-8?B?K3VRSU8xV1FEejdZQ0tUUUdqUkt4YzZselMxMjNVdHQ2M3BXMFlmeVFCcVNX?=
 =?utf-8?B?Vm1ZbGI5RHRkYWdMSFE0TXpNZERvT2l4bzA1dXRHZzQ4V1NCay9EL1VVT1FN?=
 =?utf-8?B?aXViQTFPNWpxd0JwMGk1TVB4dVBwSHFKT3g5Z2RPNFR6NGhLRXUrUTdjN2tz?=
 =?utf-8?Q?JhFkZhcTgYGOS3Dc=3D?=
X-Exchange-RoutingPolicyChecked: lhHOmwcbGIWvAUu1UEFwIjnSD7h1xCr6Ezcp+NuGgoKHXCbIlcVDIXxxjRLqd5j8BNGkSTz3rDTp1YvgPGDTeiPVC6Pzu/rgXHCE7JsaHjFGJ4smqXQwqBpiRJj+aufvccjwpbMoue+tMODyA2KNvwt85qoFtOEsIOEg/0tHNLOIdtpaeqp6/duJlqALmz6v4Nn0MpF7V9ylI/C3KNlVWAEodXkzuE5+q0YECU4HbvurrCCr0S4526sOmPzhZCKN5GqL0diMHyPo1udNtA+v+QcaM2TE524RTfryd26iU7vfe+1KEi3X8SGSYhnBDvGuCkFA9yrT62DA6zFNGoiEOQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf37254-09ee-4154-e415-08de94f8f3a1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 22:56:49.5012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YPxn3DXP+EiVroHoYMWGUFhRFUegHXCDfHGOyVN8tv0kII5Bsq1UN2+CmUvqIssm7l1fIQZrypK5TZ1ygpW7Hx4Ps/oS4+Glt4QJMQCXn1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8173
X-OriginatorOrg: intel.com

Hi Boris,

On 4/7/26 3:19 PM, Borislav Petkov wrote:
> 
> In this particular case, I would care about the code not doing any unnecessary
> work if it can be helped. And the warning can take a hike... :-)

This is very convincing. 

> But I can apply the patch if you prefer.

I don't. I'm ok for this to be dropped.

Thank you very much.

Reinette
