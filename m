Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E8A1FDD
	for <patches@lists.linux.dev>; Tue, 21 May 2024 15:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716304874; cv=fail; b=kNsC4wEwBWiSHIRxXAOySkcZUxHwLeWRvUt3KKXwT9FVpHaKDrPCv+iWOCqRqsBS+OT3sgc0wdP6nmypw8+KD/x1UDLy95ezoguuglHakbKtgwT4THjspvx81LHnSYigejgKdklsUZkPrw2zwcRNXVh/3wRSKaR1Kzrrurc8kxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716304874; c=relaxed/simple;
	bh=rxfpG8UetOgHa8RMTklDTO43cyYo40UTE7bmK2zkKGI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SgNBWkjVCQ/XWbW1qJ52clFks/vj1MwwZ3h69faDOmABC1ttSRFDQw7JfvxsK5a4gCeFAsi8qqSmVANnYCcAxhVX5tjbAmoM/vn7IL/I+5NcEv+lGW7RrNbcymzLzEsizsI+bFxaMu9hdpu1jmIdiIr1Cevma4kkA22CqgTpRD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bQyHED2p; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bQyHED2p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716304873; x=1747840873;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rxfpG8UetOgHa8RMTklDTO43cyYo40UTE7bmK2zkKGI=;
  b=bQyHED2pUJAiHv5BkHw6csXbiE4RxGPIxbYFsamYvRrPl12ny+BLwXMJ
   k70mF3nmOtNBoKBuh2D+jv/DRBQHpAwSBYJvEVEFupYChBXV5BcjjjdDM
   BdIpxlVTv4WlgQtzqzGkeHpVOphCGaLp78iq2m8O+zxyzBgsVOOIJhbmG
   tAbk4dA+1HxyosArPe5uHhF/JaCkiRNdHcLiuZY9hkzujaJmICCXu1T9p
   n3K2khiqq+g6dQ3JbtJLfWCTGgfuvhOfK6I/Lgpb+xhSth9vk0R6cK2K6
   44pjIdETVrqha2YVOo3Wm3nvhMftwIt7VOumDMK1xxM/Xhuc1gqp1vzy4
   A==;
X-CSE-ConnectionGUID: BW+TS9wnQ5Wid/JMIJraFw==
X-CSE-MsgGUID: oj0Gy8ZqROW2BLDfDICdcw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="15455677"
X-IronPort-AV: E=Sophos;i="6.08,178,1712646000"; 
   d="scan'208";a="15455677"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 08:21:12 -0700
X-CSE-ConnectionGUID: BtS97QKaRcSCrfyV33xMzw==
X-CSE-MsgGUID: x5EeEAGvR1iYAygimQKRpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,178,1712646000"; 
   d="scan'208";a="37731712"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 May 2024 08:21:11 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 08:21:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 21 May 2024 08:21:11 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 21 May 2024 08:21:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqyvGwdRHDX/N4y+TtqyiknzRLMtwKMRn7aVpNLjPpqGyYhVVXkP21lDxnCNMW9f2yDRZTQDmTYfhOUKJminxt96i20xTtye2liW+C71Y+6Py4V36YvCFpr3G7tyZCLHESlq5aZGkil1fQs8fW0E6/nJ5HMbSL/9ycSaWpYuBDwv/Bk7pd4sBLN4bO2+RkaYujoWLosWk5snd3VAR5YMJXel29hqCr8jphxLA5WUnw+i4X4XGn/+sF9Bbt6eYzXIqsHQiVkRLX1QsyGDhsEnB1Zk4NeiWGpiBzSUcHlV/N0ORocjrlT8m08PjtdPtl59oba/Pbgr1mstngSZ9bJGLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxfpG8UetOgHa8RMTklDTO43cyYo40UTE7bmK2zkKGI=;
 b=lIFIK6uZHzZ6T/5XFmJ4RT1E2Mr1an80SO2vHnPDt/bdHFTYG4w8ZGOLmF8F4bp2FCYbLplKBVn2EWApAcc43UPGQ3EEvUOMvVoce1Fyrh3CWxqnSIV6HfFxVwyqSBA1nBzu808j92t9mfeyB8CpZhF75w/8qKaaJNgUPQ85HLS403j4wG6kWoNC1NC3DMsLi1mwQELCd1QqUMORxGYLalJEYW+oGRM05UiGDW2PRXPmTlDmZfS5osAB869teAbWPqJCEkBr0lChsSY0BvIVm07mfy/9wM5c8oD6ZUlrEhtsATYfazntAZM+X6PsURRD3pXPH6Idw8u1TjuPTScHCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ1PR11MB6105.namprd11.prod.outlook.com (2603:10b6:a03:48c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Tue, 21 May
 2024 15:21:08 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.7587.028; Tue, 21 May 2024
 15:21:08 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, Uros Bizjak <ubizjak@gmail.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik
	<mjguzik@gmail.com>, Thomas Renninger <trenn@suse.de>, Andi Kleen
	<ak@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v6 00/49] New Intel CPUID families
Thread-Topic: [PATCH v6 00/49] New Intel CPUID families
Thread-Index: AQHaqweV7o/PE9LtGkmQPW8K+9sxMbGhXLyAgABxCyA=
Date: Tue, 21 May 2024 15:21:08 +0000
Message-ID: <SJ1PR11MB6083C60DA6D92C629C958B7FFCEA2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
 <20240521083221.GCZkxcFSautABFdQmg@fat_crate.local>
In-Reply-To: <20240521083221.GCZkxcFSautABFdQmg@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SJ1PR11MB6105:EE_
x-ms-office365-filtering-correlation-id: 1946a03b-8309-4917-2a07-08dc79a9a3c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|7416005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?b3lkdUFXMVE4QURwUHVwL0FYb0N3YVk3MEIwYU9US0pzelBzR09NK2NkZ3U1?=
 =?utf-8?B?MnVSRTNLQjcxTjlJVWRmR01iSENOV3BHZ1BTUElTN2FpN2VoRTVpalI3c0wy?=
 =?utf-8?B?Rm1aSmlLRHNXWWxXa1RrVEhqc0tLMGJvZUVVN1NTdHh5bUJlNStVUTYvQnlV?=
 =?utf-8?B?Q01VaGE2S2thWHVWSEg5S0M3S1dOempQc2w5YkI3M3ZnWWlmWmpieVNDSERi?=
 =?utf-8?B?UnJ5SnV1RStYdGRsMmtqQ0NZeDZ6YjJEcmhvdDhZZEVJRWtwazV6MXlzTzBQ?=
 =?utf-8?B?eXI1SjNHUGJhNnAyejJaUEFITHltMk9rbGVadnd3NlFOQlgrVzVtM05ZUVR6?=
 =?utf-8?B?Zm9Id1BKby9Pd1ovNG9pRFdpaUpxamxLZGtnVGc4OHdJVHJIUG5RUDdMQ2pH?=
 =?utf-8?B?OHFRVFBGM2tCTjcxL2kySGFpRFhyblZZSW5wcFhhZFdldlJjSGR3Lzk4VmhM?=
 =?utf-8?B?cmJXSStiNVNrRFJpQzh1WnViRk5Ya1lYcFJYcS9Mc3hGQzRkc0czYlVJdktC?=
 =?utf-8?B?Tlp5SWNHUUFXcFBSNlNlV1pIT3lBS3hLWUIvMnhVM2t6SXZ5Y1V2UDlXN2li?=
 =?utf-8?B?RExWRVhTU0ZQSlVybGF6bWlkeVZoelpwcGlUT05qZ1Mra25CL0xCblJ3MjEr?=
 =?utf-8?B?R2FXSkVKOUF4eGRmMkNBZTJMUnBIcnIwWVAxUVVBd3ZTalJnNGhWL3JBTEFo?=
 =?utf-8?B?SW14ZEpscEY3TFZhbWFCalJTUytGSVRrTGZBOWlqbVpUOE16b3RYTk1zMngz?=
 =?utf-8?B?cXBmcTVWcDdiL1JJVStqM2pRLzJ4V3dQQndUTzhJYm94N3dYaHRqc1l6UnJw?=
 =?utf-8?B?Z3VYQTFRUUhvUEZMZ0h0akVCMElPM1lzOGgyWjdCazNSdm90VC84VHJ4YXFy?=
 =?utf-8?B?YXFOU0c4cmRnVk1BaFBwUHYyYlc4VW83YXpVMmxhcllzbVRFMHRNMXBsdURk?=
 =?utf-8?B?YWlSeUtBN0Z4MFQraGZUMXlZdm5qZGMwYTJYTFB2UjBRMEdBUWxrMWt6akxz?=
 =?utf-8?B?Z3VTdjlIMFAwWjBOTjRBY0UwNkZTc2x1NGhrVzhIUElQNXRuaHY2ZkNteUdp?=
 =?utf-8?B?dU9USnJRTzEyOTBoanVwWGxZWmdKVHAreHhlMTM2cVJXZkl5bzNYZzY1K0VZ?=
 =?utf-8?B?N3VlWGNBZ1EzZ0JsTnltUnh6eWcxTHBFQTBHazdBWGozNU9vS3dVa2VPODlZ?=
 =?utf-8?B?dmhnLzE4VFBteE5RYmpLMmFHaUJEVkhZTWVZL3prL1NEY3F1WE1ybXNHclFS?=
 =?utf-8?B?akg4aUZITCtZdFUveTB5S29TZGtkUUJkdW9NYmdBY3VCOTNpVG5YeHZxTmFC?=
 =?utf-8?B?UlVRNWwwRlVUOFA5VnovWkhaVitxRitpbnpiL3RpMnpzS0dxTkxKT245cG1o?=
 =?utf-8?B?bVI2aktVZkdZdXpLbThIYUVvaEhGenorbksyTHFlQkJxMDkrTkhyRWFTcUty?=
 =?utf-8?B?Ti9FS09ETllvZjN4RG5SZk1kbS9WUXNYRjI4NStqVTJLLzlvL0lEUnJ3QXFZ?=
 =?utf-8?B?RnB5TVY3aUtVaVpsbXV4M2NYL0JSOEt0QXJhSWt6NzdBaU95SzEyWURlNlF5?=
 =?utf-8?B?TWhhY3krUlhTN2x2VHdqejR2MnJ4c3ExYWErQWJLSXpacHpvdjdBdnBaaHpm?=
 =?utf-8?B?bHNIYnN6VmdnbGdDMEhpZE5Fd0duTHQ4bXo5dzNKY0FTSC9VVDNKc3h2UXVQ?=
 =?utf-8?B?NG1XTWpPNU1YYmE5RTRlWmJNd2doSGJrd3RpczBjWkZXZENTRGgwbXJZZkVO?=
 =?utf-8?B?cGhOYnNNNmRmSy9PMzROcElWV2JPeVZ1dkNXMHMzSFcyL3p5YnRjSEUxdjUx?=
 =?utf-8?B?WWFWUStjWGV3ZE5jemxNZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SnhNbStlU1dFS2FZNUFnNG9SVFgzNHpNM21uSHAvNFh5TXV6ZHJ2bHVYWVRT?=
 =?utf-8?B?NjNkMDJuTjlnRDdYbnA2R0JTcXQ0cVdvZ3NVMXFxOXA5M25pbE9ob3lGS1ly?=
 =?utf-8?B?elBZQW81Y3hjdVY0aEZieVZJZFJLNWY2bUtzUFhqdFBNUEFkY2pNQmpRSlBn?=
 =?utf-8?B?U2hUeGN6Yk1nVkg3a3pZT0RpU3QwbnN6emt2eVZadWY5SGRZYWpmWkY5UkZ0?=
 =?utf-8?B?d1R6ZFJhdW5rWmhJUHRwNzRZeU5YNDlxd3hON0FTb2xKSlpXZkV6aXl3QUMw?=
 =?utf-8?B?c0Y4c1VGS2l5MHhBYnBoTXlDclhXV3o1NStlSGdQZkdtYlVEWjVITUZPV29j?=
 =?utf-8?B?elJncXk4SXpJZmxFaW9tOFhwMXR5NS94UzE5enBwdDdHcWlGb0lxNFhSVUsw?=
 =?utf-8?B?RDZmT05semJwQkFHVFlWdUxyeFg2WjlRTUFZdXBYU3dhS2Y2VEo1SGJVeHI5?=
 =?utf-8?B?NiswNlZOTDBjWUdTR2x4MjYrb2kvT2R6RlkyRENwaVFkRDRiTG1MTStFSHBo?=
 =?utf-8?B?akFWQndCUXd1UmpmS25tSWhlMXBkSXUwbWxLOEN2UktqMVVBVVBXd0V2ekV2?=
 =?utf-8?B?QURTM3JNTUpEVVpNVnFLQkZwTHdzRm5HY3o3MlFQUXNEamhyMG85b3ZDTzRh?=
 =?utf-8?B?R3ZTdURJMTFlOHZHT2tQWXJvQzFZb0R6RlozT0F6Y2llcFZUZFYwYkltVnhN?=
 =?utf-8?B?VXlRVGd6emJNZCtJTDV3QnBHa1JyWUJvT0g0dm1MSjR6Nnl0c2lnanBPcWhN?=
 =?utf-8?B?SWdXcFNBSGc1Q3Zha2haUkpCYWNQWGMvYUphUWxraHVBekc2bnJzNVc3NmdW?=
 =?utf-8?B?dWpVUGlYaHhtNFA0YVJFUG15TXBUM290TTVNbVFpMFhIeFptS2NqRXNOQVZS?=
 =?utf-8?B?Z3dGaUYzN2xmVDFiWFc3RGY1Ky9YVngvVEVIYlpQbEJySW1QQlBSVVh1QVFO?=
 =?utf-8?B?eTJ5K2w3SlR3d2o3aXRqSUt5T3BHNVlJMG5NYlY2TXlDKzhVLzBaU0pISXZn?=
 =?utf-8?B?SDgwMnNKeU8wOWtPWE9tamNEcVR0N0hTR3Y0V1RzMFB0a2ljRHg1L3l6SHRj?=
 =?utf-8?B?NFpBRnNnRTEyc05hR0tzVjNVQVlNc0pUd21Oa3lFRkJid0RPcVJ0UXJlN1RL?=
 =?utf-8?B?R0dDMGRHUW9iYXB4S1h1STA5d2k1L0svemZSWTRjQWtrditpQzhrMnhYUjJ1?=
 =?utf-8?B?SXN5TExvQTRMcXJ4MGl2bUxIc1ptQlZTcXJsNEk5QURJYTNKVzdDMXFqOVZV?=
 =?utf-8?B?RUgvdExmb1pYaXpVTEUycXAvSTJSL3JibFZUZFE3YzBMbnNBUWNqUUVNR0ox?=
 =?utf-8?B?VTVPV3hiYlZZcU5adlR1OStWV2g0eXo4THlNWFNyaFNLaEg2Z0FzSE9sa0Q0?=
 =?utf-8?B?S29IaHl6MG9PdU1pQkVTc2tCWlVTUHYwSVM2OXhiWjc5OUdkVWI1WmhLV0RB?=
 =?utf-8?B?K1dxUXFDWEsyR0FNb2d4cVVjVDd2dVhhb2xBTGJkZXhzMjk5RjNUbWlCV2Ux?=
 =?utf-8?B?V2VhYzJaOTdjWURrSDBaQm9vOE1NNHlpWFc3NnY5WmxWcm9qSm43a0NabFhC?=
 =?utf-8?B?Tzl6U2dON01CdDZvZmdDZktMdGlUUXJOZzhIYTRTc2ZnWENuZFMvUHNsUHBV?=
 =?utf-8?B?TGNMOW9OMGdGRmVXaE1FenAxay9TRnJ5OWpKMGdKTEtKYVg1YS9kWEpGbVMv?=
 =?utf-8?B?S1MrZnRYZEo1NXk1aEdsV05ENkVPbUhxYzBtcWJrcXRITElSWGJaRlFkMFU1?=
 =?utf-8?B?TGVUc20yd2w3bDZNd0RLRHhUS3dHQXl4YzF6QmZROVpLK0NEZXhEQnNDNmFn?=
 =?utf-8?B?TUJRVDRhQUkzVStrbkxsWTNXZjBpZHZpbDlCTHJvVnRlL2FZUEQrLzZGU3Nz?=
 =?utf-8?B?bW04NjZ6VS8zUWwyRWQ5WmRiZlMyMnprQWcrR3FKaDUzRGFpWFRYeXZHWTBE?=
 =?utf-8?B?M1pJVjdNNmlybVJwbFdKMTV6QnhPSk5peUZ6OXl6aVlMVnJtU3hSVDRYQUow?=
 =?utf-8?B?NUJ1TytuVWlPM3RnRHF4ZmczeFRrVjErVmdHTmR5K0NITCtQMlpHQVYyM0dj?=
 =?utf-8?B?RGVTQlFPZ3RLQnFFR3djdkVJcE9yQXlBSmkwUHYzOEFtdURiNkhZcHVBbU8r?=
 =?utf-8?Q?SmE9SEdyEiA4Zf7xBUZgPvedJ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1946a03b-8309-4917-2a07-08dc79a9a3c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2024 15:21:08.3600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NkviHU4G8XkGL2KJfDP0JupCKzhgTzTxRkpPifXd5jxle6Fpsp16yQPhTC51AImDqG75pJFpD9KQ7or7ZJ3ElQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6105
X-OriginatorOrg: intel.com

Pj4gLSBQbGVhc2UgY29uc2lkZXIgcGF0Y2hlcyAwMDAxICYgMDAwMiBhcyB1cmdlbnQgdG8gZml4
IGEgcmVncmVzc2lvbi4NCj4+DQo+PiAxIGFuZCAyPw0KPg0KPiBPbmx5IDIgSSB0aGluay4uLg0K
DQpQYXRjaCAyIGZpeGVzIHRoZSBleGlzdGluZyByZWdyZXNzaW9uLiBCdXQgaWYgeW91IGFwcGx5
IGp1c3QgdGhhdCBwYXRjaCBpdA0Kd2lsbCBjcmVhdGUgYSBuZXcgcmVncmVzc2lvbi4gUGF0Y2gg
MSBmaXhlcyB0aGUgcGxhY2Ugd2hlcmUgc29tZW9uZQ0KaXNuJ3QgdXNpbmcgdGhlIFg4Nl9NQVRD
SCBtYWNyb3MuIEp1c3Qgb3BlbiBjb2Rpbmc6DQoNCiAgIHsgLnZlbmRvciA9IFg4Nl9WRU5ET1Jf
SU5URUwsIC5mYW1pbHkgPSA2LCAubW9kZWwgPSBJTlRFTF9GQU02X1NLWUxBS0VfWCB9LA0KDQpz
byB0aGV5IGRvbid0IHNldCAuZmxhZ3MgIFBhdGNoIDIgY2hhbmdlcyB4ODZfbWF0Y2hfY3B1KCkg
dG8ganVzdCB1c2UgZmxhZ3MgYXMgdGhlDQplbmQgbWFya2VyIGZvciB0aGUgYXJyYXk6DQoNCiAg
ICBmb3IgKG0gPSBtYXRjaDsgbS0+ZmxhZ3MgJiBYODZfQ1BVX0lEX0ZMQUdfRU5UUllfVkFMSUQ7
IG0rKykgew0KDQotVG9ueQ0K
