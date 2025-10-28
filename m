Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB82F17A2E0
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 21:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761686364; cv=fail; b=DdfAE/AlmpG+sqKIkuwtZV3CaG9d3e0oHZpcqtR4Mar2zgxPavgOSXb11ExT/82KSaXC3wWVEJFPDzbUk9ZNMB5iRq71ER0f2CmRZnzHtKb/zOkj4uD30AOyIrDxgkJcE2Zp8iUd+ua4zBfKInsDnKRM3tHkg6tbGgFn70hTm9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761686364; c=relaxed/simple;
	bh=OGFAvrnqMR1rmVNw+1frG8Uu0oovBWBwTnAZieesTQQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AZ5+XsHEIGdgZ/TXXDaC59SZo5PmzqKmO74FZqHyoPjWODDOEwCnb6xmvm7v8G7yvJxAt/jjQIc1aYXb0bD3tzPzq2+BWvMXhOLwjD/+fZ3W511ZqdZXq8sH5oYll4j0SsDTSPcWyQeAI3/gTzOLghTf/Kr5h/4D1vAHVNK5T+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ihe7htab; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ihe7htab"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761686363; x=1793222363;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OGFAvrnqMR1rmVNw+1frG8Uu0oovBWBwTnAZieesTQQ=;
  b=Ihe7htaby1SLHk+soTCyFTz9pcGhVnFzm0GrYDBE+x9nabZo4/ke2hIf
   0uKBdfsfhDLBNIzowbtBygHVnE0knvNLnr2EB4C7zagWkTro3XO0tt8mw
   twr8DIaAVqhxXTvjwKCN0NqgKbnWarEenNXTT27OKLHw921+ywrfmxMbr
   VhGqkGyfZitwsPe7LcLWTnhN8A3nxM7lhx7U4BojJYHPuaDw9pPVWNTet
   N2lXJIjaPf3nqhYWdig4g0zirKtQeucbXpH9qYHmaKfwzQFDTyzcDibVv
   hEaK0UqCG+4f+VqTzLJydR/V1yjvsDMJX3zDGjk7UJmfhi784MU+QJnlf
   g==;
X-CSE-ConnectionGUID: 1hF/sP1lQCGJVF87igjC2w==
X-CSE-MsgGUID: W/5T2az9QXKwIudk6PuD3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63838304"
X-IronPort-AV: E=Sophos;i="6.19,262,1754982000"; 
   d="scan'208";a="63838304"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 14:19:22 -0700
X-CSE-ConnectionGUID: 7igzJ89qT8S6PVe0vB7Vdw==
X-CSE-MsgGUID: V+f5WKs9THySGzPACvH0OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,262,1754982000"; 
   d="scan'208";a="190600161"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 14:19:21 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 14:19:21 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 28 Oct 2025 14:19:21 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.54) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 14:19:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jnAh7IxEEf92lrMMIRu4DkhzQzOwmIpDd9DcQL+omNrqc2yFtn4pBK2AA7DRbT4jsYoMIAZmQuESWLLnoE+3OZe29ymQv5nkw6kRKgZQs30YriCBkuxrsm70O8/uhK5RKpCL0yNvvsRqv3SwkiMwo/uQkrp53ozX0N/MDTr/PSMV1IpNWJ+98Z3MhOaHkxKA87tIrJsaodfLVXTbKBAUoDHpD5LrEBp+sZ6yDRjSdsuMSGyvGvOEFamsFLEmglImbjFW6wb2SQyeoEEB9peFHjeUzLFX4iFKO4ZyVEC9aCOVDoaXzex1xbFRovNzz5AtfHEYt9yiWZ6QrunjbpgpRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OGFAvrnqMR1rmVNw+1frG8Uu0oovBWBwTnAZieesTQQ=;
 b=NN8GqA4ihu9qTW5X+/EDlTx1SokEP/ekA9yj+Wwb3qwtrbRNPZ5Jml3oG5Tg0I2bGDhP308fOMMVOqWKS1D9jFe2aVKYZp+tqYURHNwkZemZ1by1YuhZYM0S5jsdtf/w17cPnLg5jwjr99WaykwXBZAPMiTm/LeDbJLhbR1tiivoDPcHZgLaneaVMoXd1+Ght3cOgpIbI/q2UMMiZHDQBtEYR/Dzk95UoyfV80/CZBtNWPfzoC6ShE1xmZ4xqGmhkv/Bf+sHZRN0Movb1lgLRouoegZx8UDwQtud7kcfMvGpEuobTmWTdgSLmoWNHExBINSJWckd6Xv8GAa+lNk2qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA0PR11MB7157.namprd11.prod.outlook.com (2603:10b6:806:24b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Tue, 28 Oct
 2025 21:19:14 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9253.017; Tue, 28 Oct 2025
 21:19:14 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, Peter Zijlstra
	<peterz@infradead.org>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH] x86/cpu: Add/fix core comments for {Panther,Nova} Lake
Thread-Topic: [PATCH] x86/cpu: Add/fix core comments for {Panther,Nova} Lake
Thread-Index: AQHcSDB/7Zr4gzy5Q0aJd8yqw21a5LTX+eeAgAAV4RA=
Date: Tue, 28 Oct 2025 21:19:14 +0000
Message-ID: <SJ1PR11MB60831185836B9847D314A978FCFDA@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20251028172948.6721-1-tony.luck@intel.com>
 <704189df-908d-469a-b719-4d18ce0bcdf2@intel.com>
In-Reply-To: <704189df-908d-469a-b719-4d18ce0bcdf2@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SA0PR11MB7157:EE_
x-ms-office365-filtering-correlation-id: a2a5fc32-a76d-41fb-b8d5-08de1667a539
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Q1MxN0wwWGRCV2lycUtub1pleG1vbGdjdVhpSXFFWS9YbG5UOFM5bm5KTjdw?=
 =?utf-8?B?Ykp2K2dZL21SdUh5N1AxVWV4RWxXT21yYVdwTjVJV3FuVktxZzlPbXduYytn?=
 =?utf-8?B?TVRURXVZKzlzNk8rSVBSemIyZWg4OXU3YlNMSy8xVitZR1JsL3BMVVdTNGVM?=
 =?utf-8?B?dWlzb3VUTDVYeVVZVkJwUVVRR1h2S3dVSCtmYmc4UG9PZUQ2WFhDOUVSc0hK?=
 =?utf-8?B?UG40ejV0NGYvS3AyeDVQQ0ptNkczWDNqckJ1NEJUK2FDOFI4Z0RUUjE2eFdn?=
 =?utf-8?B?d1djVnlxOWZ5emFBMVBtSnZPZklFM1pqbDNGK2NPdHZMbmJybURkZnVtM3RX?=
 =?utf-8?B?V1pZQ29VR2hJYzEvMU1QaVZSY0ptdGNjTzRVYkp4bVk1Zm11LzJUMVgrMUdw?=
 =?utf-8?B?a0RMcHFxNUZWdFBVU0tIdDF3aGZQckFOaWJLSElzN0hqdVRSSlg2bmc5SlNa?=
 =?utf-8?B?OWJOMnJ0aCtvTW1xZjk0cmVqRldkYXRkOXBzRmozT0NKWXZZeTRPY1IraktX?=
 =?utf-8?B?bGQxc0dwc2xFMnE1WkdxT2tuNnZMcENHTlpyMngxZVVWazE3a1M0MkRCTlRF?=
 =?utf-8?B?UzhyQW9EMXBQZHo4YTFNMmY2bVhFTFZTMjk1WFlKUTRVZnJJbXNaeWtQaFhE?=
 =?utf-8?B?N2xSa1Z0bVhjaXFNZ0crb1doRkVUSzA4UUxJdHpPajd3UTlIeXpjZ0ZhVEYv?=
 =?utf-8?B?aCs5ZTVEL0J0Q2NYTlhReDRMd2R4KzJ0a3dHVVZWeEdYa2paTEZILy9uNWM3?=
 =?utf-8?B?RkFiMmg5RkRPeHRwLzEyMU5HbGpZQW5EMkJTNjZmT2ZFcFc1T2x0dlB6amR2?=
 =?utf-8?B?aEJOWWNQMTRFei91VVZHZ0wxNFZ2ZjM1MDhhVkxrcWtWT1BFOU9NK3BqaStH?=
 =?utf-8?B?QWxRMjZJQ3pNSnpHWGdrU2Z6YU5RTDBTejc3My9lYlBqSXpQbGlycjRCUVFx?=
 =?utf-8?B?SXVvRTNXNG5nZVFKUmZpK3hWem9JMXdJYXlVdG9NcG5XaHVUd0xMUVEwWTZL?=
 =?utf-8?B?dll4enIzSUpJY25oVGxLenJKbnZ1YWJCVUFuM0VSVVgybEpHMHB4RXJjd1Ez?=
 =?utf-8?B?RzNTN0xMd2V2dFBsT25Ma3F3YmRRbzJpb2k3OTJOVHFLb2pDSHR3SGEwUlpZ?=
 =?utf-8?B?Z1QyRnY3TFhxQlBUNm9zOEQ3Vm4wdUxhVm9MWmxDNjhKd1pZWWNQRm15OWFN?=
 =?utf-8?B?dS81T1N6b0YrS3kxQTJYTG1HVkZpOUF4OE1hNWpHNE5VYnBhbjNKTkZOM2Vr?=
 =?utf-8?B?ZWRZYUg1TmlhUWtjWEl4SldLNTF5c1YwdzVZNjA0cG45MGNzSW9tKzYzUUxF?=
 =?utf-8?B?MmZZYXBPbGF0QVVwbFliRkQydnJPMHFXWEEyMElObTI3a0lFd3RXYVVkUzc0?=
 =?utf-8?B?U2FJRUpuWGVYbWl1U1A5SWs4SmVKMC8zRlE5OXQvamJaMnNNSUpYelJEb1ZW?=
 =?utf-8?B?UFlGUExtU012eTZXRGovVGtSWXR3cWZ2UEZNbllpS0FpWVZvRURLRlZSaElS?=
 =?utf-8?B?SG42WnNPM3A5ZnJGZFYvOWNlSktDL2J1VjhuSGtyZEQvSjFyanI2Tk9Uc2dj?=
 =?utf-8?B?N1YzeHZ3blBmUk9VUGlQNFhoaVcxUkdzZHZrdW9PTmh1R3I1WkJMdlVrbloy?=
 =?utf-8?B?UEdMeUZySWk4RmRDMzBSRENpVXhUeVg0dUNBTm5DTDgycmQzemMwQmZleUY5?=
 =?utf-8?B?SExjSmRmR25HaTVGamk0Y1hDdXc1a0V6NVhWZXIvV1V4MlhtSDhjM1d5MExi?=
 =?utf-8?B?V3l2QjlrSGtycHlZR0xwWGNueEtLekljazhxY2lBckw4WGNSVnI0R3VhaFdl?=
 =?utf-8?B?dHNES0hRV1I1MUJqOERuYlBqSU8yazQ4anRxMmhyWk1VSnhMOExIYzVrUk5V?=
 =?utf-8?B?K0htdkhjbkxlUEI4WUtFOGZ5VmdYTjdMTE9nZ2NXaSswTnZXL0E0MnJqOEZV?=
 =?utf-8?B?NEVTaWtMUGI1c3RiUGZ5ZmVwTGtGck56eEZyZllNOWdxcUJnSkJiTnNHUDA5?=
 =?utf-8?B?RUlLMnJyNm5NQk9SUGdlblBKcHB2NkRRZWRqRFk0VXFLNGlNbVYzR2pwNmZ5?=
 =?utf-8?Q?Dm7xcE?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UU5pNW96YjVmYzlHcllDeGpWRmQ1bE1ERm5rVzlnVHpMOXQzK2lTYmhNQjQx?=
 =?utf-8?B?VXM0VWR0cDZacDIxUkpvRm1ZbjJOa0twek9kaWtXaVFXOTJoTnlrQjdqY1dT?=
 =?utf-8?B?ekR2RWlXdXBhd1N6SkpTa2hqN3RBN0JzcVJIbDhaVkwrWElaeDNWQUNkSHF5?=
 =?utf-8?B?NkpiVTVkYU9ZakVmL25UZzdhRkI2ZVJ2WGlSU2hUSUhqQkxJcExBUTZLcklX?=
 =?utf-8?B?Qk8xNGpjbjBjNlM4UWlxajYxdHlYdHRBRWwycC84NWNTdzRPeXI3Um1xRnRC?=
 =?utf-8?B?ZzhCQXlNUkJpQjRUclNvdjlTUkd3MDMzczFYN0JrL3NNaFhGRWwrRHdNcUxs?=
 =?utf-8?B?RGFPN09XUnBDYW55YjNPTll6K1hEMzA2ODEyM0ZpTE5YK1VQK2Nrd0l2L3hW?=
 =?utf-8?B?aFZNOXE2QnBSOVJQNFNCbU9yMmQ4R2RrMGpOazNHNGRUYnRic3pBTysyd1B4?=
 =?utf-8?B?ejZLaFczVGJIZ1F1RmtZOExzamg2c1FsL25kbUt6RDk1SGFpZ0FYSG8rbUlM?=
 =?utf-8?B?clhERFgraW9zYjhRL29nNGJBVll3cTdGOWxid0NKbXJMVjRJUU1lRzBQc3ZP?=
 =?utf-8?B?L2lucytTV2M2V1Z3Y1BZSEVlNUp0WksvY1VmSit0QmNuZjUxK1VxbllrZEdK?=
 =?utf-8?B?MElCRWJONWJtTG8rZmdPTEU0MENiS2dZN0pSR3lUUEQ1Qy9kKzFQOU9xeDBC?=
 =?utf-8?B?dnUvZWFvZTc1SFBUbkU1T2ExUGpJZGdzTktUL3ZGbTBOUlhFMHFEbjl3MDY4?=
 =?utf-8?B?aHRRbzFMN09RdDZveFMzWldQUEh5QU51ODA1d2Q1anR4ZWliV0lhVGZuTVVn?=
 =?utf-8?B?QWlld09zQnFNNVhRMDltQVRrbUhpRVR5b21waVFwQ01JbzVLNXlxVGdtRnRP?=
 =?utf-8?B?K012aXAzZVhvcG5PTVBlUEI3b1R3MUFZcllCc1NCbnl5aXNXU3k1cGE0WDdm?=
 =?utf-8?B?OUpkcnpLRWdFVWNMd1JCeFVySFY5MW1FOHZzQkExU0hXMFFRUU1rUHdxY1U5?=
 =?utf-8?B?OUJZTVQzazNqTzVkWG5FWGZjdlRZR1ZuZEdlczY4SHdKZjNQejh3R3M4RFZv?=
 =?utf-8?B?c0IxSWRoWGJ3YWl3a1RDZzFKWTV1WEp0U0d0UTJRdnBMNmp4YkxtbDRGcGRa?=
 =?utf-8?B?eVExUC9JaXBVUjF2THBreDE2eGNqcnI0a3V6aXZCaUdYT28rcVN6ZkZyYkVj?=
 =?utf-8?B?dEtFRkI4SGhZYkRrQld0aE9PazFmSDhVTmFxeDdtM2dnT1NBaGNGZkcvdW5k?=
 =?utf-8?B?QnlhL1FVSmcybXRpYlZJQjg3TEMyZnFRcG9oSGZJTGE1RnRyN0h1RWhvSWNK?=
 =?utf-8?B?SzhicXY1YjZyMUcxMEUvVmNzZkc2YS90dDR0WXlsOEptbEQwVml4bzhucVMr?=
 =?utf-8?B?YUVlTFdrK2g0S3hGK2lIdGZXQ1F1dnhDVmRod3ltVytOcElmYzRKNTBIUis4?=
 =?utf-8?B?ZU9iblZoUmRJekR2K1ArVVU3TGFCb3ZaMmV2T1MwUlFLd1h4dUhtUFo0OE1T?=
 =?utf-8?B?aS9xbnRJN1F4SmJDWDdzd3NzVDJVNUtZR0dVNHBEWnFqVGwzZGhEekFOMEtO?=
 =?utf-8?B?dmNuV3RwWk5tWGRIaHhJdUU2dEExcFpRZUZVb3dKOVFDS1c2WHRyNTBiMmk4?=
 =?utf-8?B?cUg5bHJFQzczL0ZwdzJ6enJDSWVrcTI4QTRlK2ZLbUNyTXlnaXY5MHJPaG9u?=
 =?utf-8?B?alJjeC95eEFNb2pUSzRVaTE4Q0J2TTJnL3BpdzZSb3pIK0ZOd0g4aU54UGRr?=
 =?utf-8?B?Vi9GRWdNR1dyOXdhOFNkc2tqZURRU0lHbDBEM3VRelF0VENUOTN0YjFaZkMx?=
 =?utf-8?B?MWdtckFYSWNpNWIzcEZobHQwaXRGT0trU1R5YlNpL2FNaDIrWmVyazQ2RzNW?=
 =?utf-8?B?VzhORndtblFxRmlqSDQ3aEczM1I1VVMraGxYSTlnZHVqQUVrU1M5UGp6Ym9K?=
 =?utf-8?B?cTA2MStXNlIxcVFKWDhsSkRtY3BBSHJmckhLdWxORXVMYm1FYjVqK1JYYkdO?=
 =?utf-8?B?T1VDejFLMmpXaDdRekw0cWFaTWdCeUpmN052NlJzOGRYWlNYSEIrQ1k4c2lV?=
 =?utf-8?B?N3Fzdk1CMmFmWGRSdmRoakIwUHVQcGtCa2RTUEF3d2R4YTdSbkk1elV2WlZs?=
 =?utf-8?Q?0ypopbR8CQhuue+fevVbwg1fs?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a5fc32-a76d-41fb-b8d5-08de1667a539
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2025 21:19:14.2366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IUsS0cbiCnSPip2aXSgsH0/UOEIny+bvXqxPG2ApDBco2ulg6P518t0/SykX2M1TiTHwprGiTlg5uevU0ydsaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB7157
X-OriginatorOrg: intel.com

T24gMTAvMjgvMjUgMTA6MjksIFRvbnkgTHVjayB3cm90ZToNCj4gPiAtI2RlZmluZSBJTlRFTF9O
T1ZBTEFLRSAgICAgICAgICAgICAgICAgICAgIElGTSgxOCwgMHgwMSkNCj4gPiAtI2RlZmluZSBJ
TlRFTF9OT1ZBTEFLRV9MICAgICAgICAgICBJRk0oMTgsIDB4MDMpDQo+ID4gKyNkZWZpbmUgSU5U
RUxfTk9WQUxBS0UgICAgICAgICAgICAgICAgICAgICBJRk0oMTgsIDB4MDEpIC8qIENveW90ZSBD
b3ZlIC8gQXJjdGljIFdvbGYgKi8NCj4gPiArI2RlZmluZSBJTlRFTF9OT1ZBTEFLRV9MICAgICAg
ICAgICBJRk0oMTgsIDB4MDMpIC8qIENveW90ZSBDb3ZlIC8gQXJjdGljIFdvbGYgKi8NCj4NCj4g
SXMgaXQgZXZlbiB3b3J0aCBrZWVwaW5nIHRoZSBjb3JlIG5hbWVzIGluIHRoZXJlPyBUaGlzIGlz
IGFuIGV4YW1wbGUNCj4gd2hlcmUgdGhleSdyZSBjYXVzaW5nIGNodXJuLiBJZiBub2JvZHkgY2Fy
ZXMsIG1heWJlIHdlIHNob3VsZCBqdXN0DQo+IHphcCB0aGVtLCBvciBhdCBsZWFzdCBzdG9wIHB1
dHRpbmcgdGhlbSBpbiB0aGVyZSBmb3IgbmV3IENQVXMuDQoNClBldGVyWiB0aG91Z2h0IHRoZSBj
b21tZW50cyB3ZXJlIHVzZWZ1bCB0byB0cmFjayBDUFUgbW9kZWwgc3BlY2lmaWMgcGxhY2VzDQoo
bGlrZSAicGVyZiIpIHdoZXJlIG11bHRpcGxlIEludGVsIENQVSBtb2RlbHMgY2FuIHNoYXJlIHRo
ZSBzYW1lIGNvZGUuDQoNCi1Ub255DQo=
