Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4372E33F7
	for <patches@lists.linux.dev>; Thu, 22 May 2025 00:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747872912; cv=fail; b=oOUWJT6+Ztq2WDIEZD53ZwBsIDIX0tBEgn1uHZfiFKPcqGC6Q7OUpjqTx0fTUViQ9MEL6fbryK1oBYv2LDTTZm8cQr6W0zJdfqIpNmwN0NJqxsTxpMY/jrtdUcMQfLc5vk5feEPcTbS7lFXdvrz9p6+nDPr19dEk4LjYValWy/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747872912; c=relaxed/simple;
	bh=zMgbV4cxSVDhB58b3gH9MxF+kBxn2OqZG2EHCY6bbiE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nWpetiNCLJF3eBfRdKc8vOidDl5wPPfgGSbnl/4sxCRG7XzmH/hCsYEF7nLlSRhnMAUr+ihD904Ccjxp575KL84bBFTQ7OJVegSD5jDJoVipn3Wl0LEY58isE/DUNS6na4ODwDDtsol1Z3m+GgBOAQ83N+FMJx/Hplrva6xqyhA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bqclvh6r; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bqclvh6r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747872910; x=1779408910;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zMgbV4cxSVDhB58b3gH9MxF+kBxn2OqZG2EHCY6bbiE=;
  b=bqclvh6rTVl/HjDxhDN6NeIoZNK0rmf2776tknCDqpkRaE4HadTuO4u3
   yIcKGFrjIvzWT+KjTmwbXFiMHbmf5HFQFrIMwxqgyRDEvg+6QqbNtW4o/
   OrgxR0uF8D8YEXCDceOpUbnFLhPfvgImVWhQdOmI6aio9Ni641To0ca7w
   sEJW+woNrRovVPwRio5GRM21Vxa4qQ2aX1wn64FBpmFlWsYg176T7J4Sp
   fKwpdlXhfnNkySYdOsEDuDF+iHC0bo1b8IM3jvCSJjr7tSvM/EYhHhS3U
   TgO+tNsHuK6TVrgScQzWdBGA1B0qVpQhUSlpWOGInkghEMqNJMda7AaiR
   w==;
X-CSE-ConnectionGUID: Gsd61uLiRyaKfPCIJ2/6Fw==
X-CSE-MsgGUID: ylrgG/78T2uWltp5MGvhYQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="49979231"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="49979231"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 17:15:09 -0700
X-CSE-ConnectionGUID: Uyu852DeTJGb+Xy7ALwgHw==
X-CSE-MsgGUID: NiG0STYpR2+AlF71pORdnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="140846119"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 17:15:09 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 May 2025 17:15:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 21 May 2025 17:15:08 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 21 May 2025 17:15:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nEISrAos0y5g7OfwOH0Ore1lvzA0y96iBego04x2GdaqRenTIs1YIFFCPJH2C0lJSKvNjxyR/ngOIC1p55c+7sZSdIeHbxqiYCCxg8pKIw/QH7C2lG8qXjnNM52KDjt6HPBk+yy6psH1Wa7DtPxcENmX+4PnzEZq7qBko8B4CAJzSmkZqB3t93ZtbD2zlRZfw14h8ViBs+YWmJ9Cz/xRWG1/d7l4y8d6V8kt1EIxY9lB+MAfvHS9QK0QTGio9UXChOJH+Fjs4DcgC8XggLuuGauiDrexJ42FxvzqV4jLCeTZOUKAJPxXIhSTvUFl8/fcWrOulO+MC9JxBGnij+XuYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zMgbV4cxSVDhB58b3gH9MxF+kBxn2OqZG2EHCY6bbiE=;
 b=s1f/cvMt5VkAxg/UbDCCyBhdI2TOWcF00BaLdRwju4z3wyP54nP51JoLkZPCzrSecuftCXGE/yYzG8s5R4C89OJA16X2VsmPNVP6HHeX3Ferrq13E73gO6HPewfDn3TP+pAklQVsEn7heahzKNBSHETvngqYicpT7kutLqY+DEoipUZQTDTUuct4o27eyYJ3ly3zDzp9jyudJIO4bzLcFZNnAMRe5wYOrmeghbnhaZCXfD4XUDrR0JSGlbUn3r23Dnh9JqGgNhTRZIzExw5VV5KLsMyV+Ck+7quWdQ8vX2vqV+8c7aL4vEA3hgygRj+SQbaLzDTIvHVCw5TTB+nzwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA0PR11MB8380.namprd11.prod.outlook.com (2603:10b6:208:485::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Thu, 22 May
 2025 00:15:06 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.8722.031; Thu, 22 May 2025
 00:15:06 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>, Fenghua Yu
	<fenghuay@nvidia.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, "Chen, Yu C" <yu.c.chen@intel.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v5 10/29] x86/resctrl: Change generic domain functions to
 use struct rdt_domain_hdr
Thread-Topic: [PATCH v5 10/29] x86/resctrl: Change generic domain functions to
 use struct rdt_domain_hdr
Thread-Index: AQHbyqLUm+WaSwjAhkCjQ0MGks+nd7PdxDAAgAAC1aA=
Date: Thu, 22 May 2025 00:15:06 +0000
Message-ID: <SJ1PR11MB6083FBBCCA32EB8B94CCFDDEFC99A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-11-tony.luck@intel.com>
 <22c0f91c-7ee5-4bcf-8146-fd98795a073b@intel.com>
In-Reply-To: <22c0f91c-7ee5-4bcf-8146-fd98795a073b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|IA0PR11MB8380:EE_
x-ms-office365-filtering-correlation-id: 1ccbe3dd-5d94-4d1f-e85d-08dd98c5b4dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YVNTb3dBdWlqOEpldmI5L3JUV1lUN3pHYnd4Z2hKQjRxbGVud2NyUnc1SURv?=
 =?utf-8?B?Z21vNE5vQ04zUVR3c0FiWndzMWVrbjY2aVJ1Tk9yZWJEQ1YxSG1JemIrTm5J?=
 =?utf-8?B?d09UOEY5U3lPNWFBZzRNU29WUm5hV2ZMWHE5Z0xmTVdraHhmay9HZ0RSeGVi?=
 =?utf-8?B?Yzl0aUw0d25oVWd4QUMvUzFQRFhEQTVLOWRteExlQXdWWFRxUVhDMkJpRlZz?=
 =?utf-8?B?TUJrNDBqMGV2Mk8zd0dhSngxdFhjWk5xZFlhK0VnSHBnVnpGdURsaTFqbEFR?=
 =?utf-8?B?UmszN2Vla0dwQStyZ0VuV1p1NWpKWmdncVJudk9vcEdEWk82TTh0ZUszS1Nt?=
 =?utf-8?B?NnNVNGF5MThBbnVQb3h1dVk3enZqZXdvaHdGZlZLa3RNaG14RVhrUWc0TzQ3?=
 =?utf-8?B?NEt1MkthbEF5V1RrMzh2OG9Ic2ZMQ3Z5Q3NVWlVvSVNjZVJwYVBvVUFISWQ5?=
 =?utf-8?B?Mnp6QW1VdHE0cUFCMWNiRE9xdzBrRk1WbzhYem9PcHJteFVGRHVtUG1jV215?=
 =?utf-8?B?STVvVVRtSzN3R3E2djY5ZzV4S092bmhzOHlxbGJ4ei9kZHd0OCszdGhnVWZR?=
 =?utf-8?B?aml6RWZXc1lsQlZTQjUweThLNTdCN0lXN2gyL0NZS01IREloT0d3OU1SNDRY?=
 =?utf-8?B?Y3ovalBXRmFVUkFRWGgyNTUrMDFESWpIaXdBdlJwSDZlQXNFWEtRUlpVOHl4?=
 =?utf-8?B?R1czd1BrR3g3ZVkyVWVBakMycGlCdk9BR3Zib2RCVmZqc0xob1JjK3laY01C?=
 =?utf-8?B?d2QxNmpKcktZdFNYdEFZcDlqUXNVNVIvV3F6ODN4MjZvQnE2emVQTlp3WVpz?=
 =?utf-8?B?OEl5OW9YcmlDWVdxZmpoVERjSnExbmhqMSsvYnk2SjE0VW5vNG9GZTMrTlFH?=
 =?utf-8?B?dVgzQjRzdTQ5andXMVh6NTRjOEpGUVlsVWVpZVJqV0p6SkthM2dXN3ZpdnJO?=
 =?utf-8?B?aXphYmNaR0JvVHdxcDExOWJYNjR0NGFOemhVdDUzTk1wR0JNN0VFS2gxRjdL?=
 =?utf-8?B?S0w2M3R6d2x5S1FhMTRKa2I2T0hLNEthYXVZSmNCaXY4ajM3T0VDTjNHWlk5?=
 =?utf-8?B?dWNzUmxqQWtFcDZqK21HVkI5TVBLcE1FWEFHbG1DMWorUXBrMXZuaXhDb0Fl?=
 =?utf-8?B?K1YwMFZLY042a3k3VW1jSnVBaEhPeXFwbWhvb0daTDBaV1V3cGhvWmdNeW9m?=
 =?utf-8?B?UDJRMEFSWHM3VVdHSG4wbWc5ak5hOHEzeUFmQk0wZFp4L3NQSGlzOXpEZmpy?=
 =?utf-8?B?VHRjZmMzdzBTSy9NRGhMbVoxbFh4NEk5YU80bVhEM0x2ZWZLK3RILzRMZHpB?=
 =?utf-8?B?TnBrSnVPQWlnemhZaENMdTZiNUhWN2cxWktyMVJnb1Nyc2ZxMXBNQlBQVVU4?=
 =?utf-8?B?a21OUEtTVDhWek5OL2t2QUVhcUZsNkNEcDNOUUZvdHQ5SmdNYnB0dHEvdHFM?=
 =?utf-8?B?SWFNVWM5cnhYZVFINzErMnlTVEg4eThVODE0Q3Q4YTFvL0hiNk5UWGxDeS9q?=
 =?utf-8?B?QUhuL2wyZTF1eFlsR2NCaEdMRzAybXlkM2lxWitiZE1hS1FGUUNGTVoweFlS?=
 =?utf-8?B?UTBQQ1R1d2N2Ris3V0IxUGRZZmg4bDJoNWM4alp1bUpLVVhLdmh4M3FySmda?=
 =?utf-8?B?K202bFp4S0o0T09xb3NSYW5oUS9ZRERNalI0RDczdTBneisvTTNSNlg0cFdp?=
 =?utf-8?B?SnNuQzBmNUx5cDJPT3QvMG1NcVo3V05NQnYrTmswSmxycjVyYkU5VThCYThq?=
 =?utf-8?B?NGdSRFF0cm9oV2gySzlsVFBCN0M2emQyaHVBZ21yYVg2UGFvbVZWUFRPVVBO?=
 =?utf-8?B?R2dlOEVFblpSbzFuQmFlNW5naTRQU25XdVhKaUpmc2IzRFFOYjFtWElyYmNm?=
 =?utf-8?B?VFZaYTZtNnVyaFZyeGFxQ2ZnbWM2b1BMYVlEM1NoYkxKYVh6MnM0VkwvaWkr?=
 =?utf-8?B?U2dDdDB0bGpuQU1KMW5BV21MQXRycjhPd3N3U3dSOXM2VWVKclpPZ0NGWVVq?=
 =?utf-8?Q?ndnOQxhSJ6Bvef5jbamNivwzOshTDw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NjlWSmpqdExBWUVPcVNpd0ZFWnA5V1pkNk5oaUR3RTlSbkJzTVBjdmFKb1RU?=
 =?utf-8?B?TFg5NmFoSEJ1azJ5d20zV3RiVkJjWlNYNlQvNmN1dCtrTVRkRU91ZjRlcDZm?=
 =?utf-8?B?aEMxOTFTY0h6bmpBVFpBdXA1OFZZUWFETG95Ujc4NWFkb3hIM3p1THoyQ3pL?=
 =?utf-8?B?SGpibGlkN3RDVU1kZEdlZmJxRVd1cUZLajBDdkZhbStjQzV6NTVZLzE4b1Y5?=
 =?utf-8?B?bzEvQXFuMHM0QktudU0zRzhQc00vcGJyL1hJZEZFV3cyUjBLTVBmdi9ZV2J6?=
 =?utf-8?B?dFhNTkljNDdMUUg1RlBZY3FjamVGMWI5WTVwaFY3NllvVmVwcDlqTkRtc2J1?=
 =?utf-8?B?YlFWVXpVQUZSQ040UkZhajlDWmdMZVFBYVdjOVRnUTI5a1hHUThEaXMzdFFF?=
 =?utf-8?B?NjNLT3JySS9yT24yaVNGb2RicGxKVUtmc3FmNFYyb3c5L1lhdHVSY1N2clZR?=
 =?utf-8?B?akVsMHk5MkJhci9JUENaTnNsQ2c4cStmK3ZkamZZYlNvMEg1ZkRpdlJtbjZa?=
 =?utf-8?B?MEtyMnpzZE42ZHNtdFVNODNUZGRISFlrRytNV3ZHeml6Kzd5NG5QLzJyeFhn?=
 =?utf-8?B?Vk1tY1Q3M1NoeXJYWGVNK3ZGRDJjZEcvRzFwc3lTOGhuQlMyMi9TNDBqRGVk?=
 =?utf-8?B?amVLQUNRQlRCeTRUeis5Ym1CNWd3LzNsOGYrWG5yNHlDeUo1YnpEUDYvc2tI?=
 =?utf-8?B?YUZEbEJXdGVjZ2dCYmZzNmVOMEVIZ1lMSEpNTFBXS0VOUHVIQnRqL0U3ajYr?=
 =?utf-8?B?VGYwUTAwcVZNckQrenV3ODdrRmFLaWwxY01xWk9EekswckEzWEt4SUo3YXZn?=
 =?utf-8?B?clQ5MFhNM2VqN3J0eGtkZkZLVTY1M0Y3clZ0SitMSXNNM09aWTlidE94cXJQ?=
 =?utf-8?B?VE1kRVJFZVRvdUdMUzVMdzRzZEQ0R2FLdWVpQ1J5S0Z0UUVmU3ExdG8rV0oy?=
 =?utf-8?B?M3BJWkc1QXFmVFZaT1lPc09PMWhqTGYrSUY0Vm96c2RXejlJNEtDOUNVMWJQ?=
 =?utf-8?B?cDFaSnpTT1RsQWRJS3pnRzFwdW1WeFdpNjNNdWpZQUpwbkp4djFjUEJFcVJB?=
 =?utf-8?B?YktIc25NZWpaM3Z1K1JsK0FvbmhJcmFLRGNTdlVQYkhHYlU2TGk5UURtTTR6?=
 =?utf-8?B?TGc3M3hqOXp1eVdReTFBSVVSc1RuYTAvaTFSR3d1NHVsTjQxNGFBeUxtUWtS?=
 =?utf-8?B?dW5XWUdpV1ZEOExTWVAxUDZBeGJSM3NsQ0V5Y1R3Mkx6ZXBOb2ZLUjdOc1Mr?=
 =?utf-8?B?dkxSbjlYZlYzQVNhYkh4L0I0YXVSeDFPZ1VGSjhWWGhzQzV1L2Zqb0svdVVR?=
 =?utf-8?B?NEFFVVhmb2JWZ0dGWDdib2kwUi85TEFSL1FQcEJERk5Ca3BEWkNiWVJBZU10?=
 =?utf-8?B?VldUVTViMVRhS1ljanBRSmVxVEpaMVM5S0tZbURNYmJWdCtuUzRUT0prcVRV?=
 =?utf-8?B?dWxUcU1WUmd6QVg1MlV0QUJhMnU4cGt4R3p1ZnBZZCs3VGp6U2RNR0VOR2pO?=
 =?utf-8?B?K1JsRko1ejdOVTNEUmlJcnRHVFBkL2dIYmNMNWxzK2hiTGFQTE1mWjJKTEZW?=
 =?utf-8?B?Nlo4QnZCSkdLWnZSMS9HWHdjUzJpYVk2VWJRVjRlTDFxK1JRZ2FHdVN6STF3?=
 =?utf-8?B?Q2FCOHlEYjQzLzJURXJiTEZmYnVjaFl3aU9NcTlKYmJMS1g3clMxVWNuTGNL?=
 =?utf-8?B?My9mUzF4SjEvMzRYeC9xRlZ2VE9LRlBlNzlMRDRkRXJRV3lkVG5KSWMveDgw?=
 =?utf-8?B?eDJzMmdHclV2NlIvNW9FWi9OVlUvOHRJclo3NkdMZCtsSjdhZDl1eUJBako3?=
 =?utf-8?B?cm8xaEFIQzE3N3M4SEp6KzBUVGZsUnFrYTk5amVZdlUzenFwNFNKR0FqdmNj?=
 =?utf-8?B?bUQzNjJLZDBraExMbllvTGQvcWVVdjVXcVQrSFg0cXpBTFM3KzFEbUpMN1hy?=
 =?utf-8?B?dHhpRnBMWHprYzRZak5xZ2R0dVJNeVk1WlFNbXJsTGhob1ZmY2U2RS9Fa1pL?=
 =?utf-8?B?UjE0eWJUYk9Wb1dPZ0RuQmxCNnJWNml5Wlk4Y0RSK3pLZlZvdnJyQUxQaSsy?=
 =?utf-8?B?bDdyaTlMemZTNW1haHZ3YURMV3RZZmhEdzJ0cFIzTlhFSmQzbmtJQllQYWh0?=
 =?utf-8?Q?4KoiU4yaCo8xl5+zq/x6VZ5Qn?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ccbe3dd-5d94-4d1f-e85d-08dd98c5b4dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2025 00:15:06.6450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ob9hyEnxF/giKn1hMteCi+HHi0ueHCDiZVVfEp1EvctBkvl1m0RcGHTOmVgVQX2Aaie5hCoXza8dzXSdUbYrPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8380
X-OriginatorOrg: intel.com

PiA+IEBAIC01OTcsMjUgKzU5NSwyNCBAQCBzdGF0aWMgdm9pZCBkb21haW5fcmVtb3ZlX2NwdV9j
dHJsKGludCBjcHUsIHN0cnVjdCByZHRfcmVzb3VyY2UgKnIpDQo+ID4gICAgIGlmICghZG9tYWlu
X2hlYWRlcl9pc192YWxpZChoZHIsIFJFU0NUUkxfQ1RSTF9ET01BSU4sIHItPnJpZCkpDQo+ID4g
ICAgICAgICAgICAgcmV0dXJuOw0KPiA+DQo+ID4gKyAgIGNwdW1hc2tfY2xlYXJfY3B1KGNwdSwg
JmQtPmhkci5jcHVfbWFzayk7DQo+IExvb2tzIGxpa2UgdmFyaWFibGUgJ2QnIGlzIHVuaW5pdGlh
bGl6ZWQgd2hlbiB1c2VkIGhlcmUuIENhbiB5b3UgcGxlYXNlDQo+IGNoZWNrPw0KDQpHb29kIGNh
dGNoLiBJIG1pc3NlZCBzd2l0Y2hpbmcgdGhhdCB0bzoNCg0KCWNwdW1hc2tfY2xlYXJfY3B1KGNw
dSwgJmhkci0+Y3B1X21hc2spOw0KDQotVG9ueQ0K
