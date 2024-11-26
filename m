Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F83D1D63E8
	for <patches@lists.linux.dev>; Tue, 26 Nov 2024 18:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646148; cv=fail; b=WjvsoWG9yz85V/C/im422LI/UHDXtc45vC8NEOXJgQ+750TcramAW+IJDqyf6Si2bg5cu3yUE9RwHIifV9xwhFQSsS6DHgF0TwnQhTMr/0Y2PE+kAIF77kBY4tp+fjh1ccccJsmU5U7fVtlVhOzADptsvCTBei5tn/v01mTBvrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646148; c=relaxed/simple;
	bh=ceUCGblUt3uZdyngiDZytEBv18JllSyOVQXFilh+tAA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pIvi0BV3i7QdkXq+SockI9mWXcgpk8DIVgh3vpq8atCYLnJ4PdSPiDqEJj6nIR6Sy/+FZFV+StupzE8yhefnzVeK5LD1hl05m/dMk9iQ0iz+h7BdH808oAl0q7Io1gtC+zm0z2LmZXN5WIvzcszoDyQaychYP3fZusbuGcSYTA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bDHltqe5; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bDHltqe5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732646147; x=1764182147;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ceUCGblUt3uZdyngiDZytEBv18JllSyOVQXFilh+tAA=;
  b=bDHltqe5gMRLJu6YO1Ztl0dI3osFu1w/a1DKsRhPIktTjxdBJXXWaOnI
   HvW6cGeFWp0YC8D8hlKxUNESK0j3Z8wo8UjclJzpUHlnedkkiI01Qbaxh
   A/FSwO+BwyzsjPGzVmVAgRilkADznXSonCrZuHr0EmG+P1uALXIIZI/Rx
   VtgLWl7/qLacZZV3D1td2kD0IdGVeL6fD3tyW/0cTxkzpMFzjDWzCVg1I
   DdfqqN4nFFTdK+i+gbcQ8eu7r7reinXZirD9fUXrTS+Q4vgn2dIAiUqMw
   K3PVTYosrfMTT5gkbtIhLxMj7vjxk7Mk58YRWQhtXToSR3GeXCuLrjCPF
   A==;
X-CSE-ConnectionGUID: 2j27de/lQRyfSukCkR+iHw==
X-CSE-MsgGUID: 1/JAj15zQdeIUgPOHRIrvA==
X-IronPort-AV: E=McAfee;i="6700,10204,11268"; a="32971545"
X-IronPort-AV: E=Sophos;i="6.12,186,1728975600"; 
   d="scan'208";a="32971545"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 10:35:47 -0800
X-CSE-ConnectionGUID: EIJTqVZaQyOfwsdS5Xqcmw==
X-CSE-MsgGUID: L1uqxb1PQl+DsWLPO2roUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,186,1728975600"; 
   d="scan'208";a="96129250"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Nov 2024 10:35:46 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 26 Nov 2024 10:35:45 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 26 Nov 2024 10:35:45 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 26 Nov 2024 10:35:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V59x6Fb/aoONpBRvh+uaDrfpgKOKtkOuIXrocJLbPiJmkkzpFCNtmgtGheWGRw0ienVEB+ALsMvMxgEWJ6YCEWjrsrC47iT9Mqw36D1AUO7LAZ+Ke//jyLtXRiSk/NfAvZgEVfO28z6+f2jcY3FteYfef/hx45KqDTwkTWcxSaLlROojCpfBMr+Z7vsEjPc3KbCXNWmSSM1u+xhA3XGGJ3g/vGnxZ9AWK3adhuVHIFrnTkHLC+11dwLRErEA7J6GWHHMCw+i0+2b7UpbYj5OWXcOOEX3ikoqwT/JXJpUU97AnlhkXdZPSYPCsGwSXjEXI5+0UIKZXN/KgKmskljgKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/6tkvl4TFHkWboIF7AJT0ubRH+vsZgdg7X2elaOU/lA=;
 b=NELex+F22gytJyQK7sOApnfG//rAsC3CYKS2ofG50VYocway+FRokTuvfBS7fBUlxyM+i8rs9JaeHmVw0gVRu2fAu2EUPd8UN96ry+8vJESXps7/iku1VenkaL4XeyB6f1UiI6UA7qWBlnrNOBcqabZVviC9rSfnXjpbnxDJq+pG3m+P8ikcF97hyjfjNBTi7uGDkKcjBNPXEK/KtpLCUij9a+vCkny/VC/wEP7y8jiVp3iiy4d+ZjXLmoumD7SeuQkqlha618vOleJ45IDHIZtxAjOBJ2rjmlddeNeiIOJfzW5ER3FNtNJkEnk92gsIcOCR4+lQlJEn7UvRGVIIJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by LV8PR11MB8536.namprd11.prod.outlook.com (2603:10b6:408:1ec::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Tue, 26 Nov
 2024 18:35:43 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8182.018; Tue, 26 Nov 2024
 18:35:43 +0000
Message-ID: <55fc7e8d-1056-4713-ab62-4b518d551de5@intel.com>
Date: Tue, 26 Nov 2024 10:35:40 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 4/8] x86/resctrl: Compute memory bandwidth for all
 supported events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241122235832.27498-1-tony.luck@intel.com>
 <20241122235832.27498-5-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20241122235832.27498-5-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:303:b6::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|LV8PR11MB8536:EE_
X-MS-Office365-Filtering-Correlation-Id: a813bc84-d105-442b-0117-08dd0e492248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T1BxREVtWDZZMGZtc2JMakNSRG5zdll1MDN6czlyM3Z3ZVR1VE5WbWdHdjRz?=
 =?utf-8?B?RE1FZTZUL1FSSFUwZ2d2bUVKaDVRZ0V2ajJxZ3dLc2ZVNzV4MDZvZS9sVm5q?=
 =?utf-8?B?SjlpZkxNZGFPSXREZVUyR2RlYXZyeDZsSUprd2l2b1Nncm1GaEhGb2E2YUhB?=
 =?utf-8?B?MHErZUdEMnlWL1FxODJBSWwzYStNNXpRTGkxWlNiZW42UEFaM0tOQjR1OUl3?=
 =?utf-8?B?Y3l2ZzRSdERaUzh1YWwxTkZvVDc2ZllyeFZWUzlpZFpidTd2dERyUHk0eUZG?=
 =?utf-8?B?N3piSUdyaFB1U3RhcVY2V0dXcGkxNGlaQms0aWNOa0ZDOVpXeWI2OUEvN2Zk?=
 =?utf-8?B?dzBvdjhNSGpXNjl5TlFJS1JJM1JoMytYS3lOSk9mN1dBT09UNStWNjhUVWpp?=
 =?utf-8?B?Y3dsVHRPL0RUU2JNTjIvWjljZW5jVHluQ21mbyt3NGxWR3hzVmsvekV6ekxQ?=
 =?utf-8?B?a3pGSS8vTTNiZ1dYQlZlcjFjOWFBWVlzdHFXV1dDL1Y5UUxIU1Z0R25sQlZR?=
 =?utf-8?B?Qm5CTk5sbHlQK3cxTWJ2ckNPcjlVeVJaQjQ4UUM3dHRYcFlMM2V2Rm9VVlVI?=
 =?utf-8?B?V0VjMmNPVHJZRVRBRjhKeUJpbTBoYkp4aU9oM0pJbFVNbzJJY0N4QklqMkcx?=
 =?utf-8?B?VmhtRlZkRWhXNjNacllLRGVIa1NvMnJNYWQ5S1JZTlN6dTdDUjBLR2FzeVk1?=
 =?utf-8?B?UEVJK29CdEpUTnJWNmllVFhJNms0ZzhsMFVKN2hRd0ZjWVJkN1BzTDdVUXNE?=
 =?utf-8?B?d1JUNncyYVJ6cXVrRUFBY0dDbGdrdmRsYTdBY3d0cDNaUTJlWExVaXlUWkUx?=
 =?utf-8?B?Qi95Qmh2bU40L256K2VyN3RNMkJmQ2w1TW9JR2JCbUU0SFo0MGZyelRJV0RZ?=
 =?utf-8?B?Vmk4dmxFMXBud2pLVmZ6VDRoNHI5K1dkU2FzZ1dZSzdWcHBMcmdxYjBMUWlq?=
 =?utf-8?B?a1VPZGs1ZVhCbFZ2c2lzelNVM0ZINHlnSkxIWUgzcStYVnB5S1FZTy9IWTND?=
 =?utf-8?B?blZaY0g5M1ZpR25EcHYzRFdUSWxuVFRCSzhCTUo0c0ZPWk1keGFLbllLbUM5?=
 =?utf-8?B?ckxGM1QzNFRsdVh6UHZTanExSDJmaXBRRDFGUG5jdktVUVpMZCtSSUx3QUhk?=
 =?utf-8?B?azdvNFAxZVByS3JHZ0tmcXJsQmJRRXFiRHFQaVNOaFZST044cHIzSjQ0UW1l?=
 =?utf-8?B?cWQ1LzBwZHY2SzZQYkc2ZEZZZklEL1kzeDFtYVBjZ0lJVFRqcjlFMG9nMGtq?=
 =?utf-8?B?UXlJSzlrTTMxbjRYMG9Xd1Zvay9qREt3eWtKaDBRaW5HVnNYc1ZXbExDRDdE?=
 =?utf-8?B?V242d0poMzRYaXRMN3REMDBXM1MzSi9BRU9nalkzeWdoYjUycUwzbWxpS05K?=
 =?utf-8?B?S2htOHlES0t5eEVCNEVZL0dtUjV5N0J6UHFmSVRsVXNGZ1VhYTdGdFJ4NlMr?=
 =?utf-8?B?b3lnQUFHWHdWMGMwTVcwR29CVXNVblg3YWRvaVc1a2RscWJwWW1FNVFBM01y?=
 =?utf-8?B?TmNNUGV2bi9nS3VYUWVqSFRFNk85cDB2UCtScVRGdWRBNzRwOWRIa05tQm9G?=
 =?utf-8?B?WlJGMnptYS9kUTVLUm5VMno5WjZrc2hGUzdxMzZHMTl0YjdTSFNML3owTWVr?=
 =?utf-8?B?ZGRtNm1sM2ZYV0ZpelcwMlJsaWtlVC93NkRyOEdPTjBZU0VFN1QyUU5lNzNS?=
 =?utf-8?B?eUF5Y1RwRXRzNFQxYndDUmRudlVpZWxGMFN1Vm9uclh6aXZWVCttQ1MyQnBn?=
 =?utf-8?B?ZFo5WmJPZzlFcndiV096TUNNS29HNllOR2srQ3FnNHgya3NaUEFyS2xIMHR1?=
 =?utf-8?B?V2F4QytCbVkwQjZyQU13Zz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzY0MEhqa2laaE1OMGtrMHNybm5CK280dk1tZWNBdE9TaWt5d3hKZitCdzNx?=
 =?utf-8?B?dFRtWmZTcFRCbHVuTGRLWFVVNnhRdGJBSnRGYmF2djZnQU44Y2JGVjIrNTJ0?=
 =?utf-8?B?WHhkcEQxNmxUNFBjSlVWaXRYWlZRelB6a0UxYXEwY0FKUkYyZ2VKenBLTDlm?=
 =?utf-8?B?VE5YcDA0eXdsWHpPajdJTTlmRWVDY1dEeWEvMkxmNW1vaHpkWWE3RFB1cXBY?=
 =?utf-8?B?UmpzMmxLc2hqRnBrN2JYTEJtU0JTb1FZZWN4di9kNFJTMWZkT25kWVVOYXVs?=
 =?utf-8?B?TEpjVW1hTGM2WFFRaVBPRmZZcmtOQldSakw5M0NqQTRCRG1KK01xWUhSbmhk?=
 =?utf-8?B?bHdzM0lvS0VGWDh3b3dsdWVkOFdpVE04akhZUmQrdkxBbEpwNUhmM1BudG5H?=
 =?utf-8?B?aHRaZjB0MXFERGJuTERTaDVCK29XV1ZudGlRRkptVGRScjBodDhjV2ZVdG13?=
 =?utf-8?B?OVMrT2ZhZzZ4Ky84bWZqemd6SUo2Ymhlc3hYV1NhUzMzZnhJMi94RnJFMjJV?=
 =?utf-8?B?SXpUUkJDTWRPcGFqNTVBODIzaExkK1hRR2tqZ0JSQkZha3FUSnNMSDZFY1Z6?=
 =?utf-8?B?UmxlU04zYWtzTC8ra09MYTByVjM5bDloVDRZWWV2QVg2UUlyTGdZbGI4N1BE?=
 =?utf-8?B?NHJadHBaVUhkOEY4VmM4YVM3bUltRlJYOVpCeWI1cUt0cWpNenJCc0M3N1FX?=
 =?utf-8?B?ZzhtdDMxVHE4eDFMZ0tRYS90OER4bHpCd2QwQ2ZXRkNtakZwUm5sc29VTFZY?=
 =?utf-8?B?MVk4S29nbEV1Z1dHbnBTV3RsaFJWQzZzZmNaU05SbUxnYUFRL081Ni81WjJy?=
 =?utf-8?B?eGFKYVNIUGhKcGhUOC8vOVhSNHd0YW5zTkdXbG00UDlJUllkaDNURDFZWTM5?=
 =?utf-8?B?SFhDRTlsL3BINVB0ODVMQW9zK1NtK0FETWs0eU9Bd3JaUUtuNElQM1phbkJ0?=
 =?utf-8?B?d3I0dHVmeXU4WmF6eGNFZ2dwbUlFM3ZCQTlwRUtPSnNQMGw4N3BQbWg1ZTl5?=
 =?utf-8?B?UVdUUTBhVlgrSVZvdEtKNzd6d3FUZ0NiRENQeTVyeUVLVGM1b0ZNdENHZ3dT?=
 =?utf-8?B?WG1lTTJKWEttV2pMMDM2bjB5b3FpTlYxMnNDdnczSkxiRGc1dThhQ093MEdu?=
 =?utf-8?B?dUo0UklBaEcxMzVNQzdkZU5uWmlxK2R2cmltYlA3RUZZYnMxajBZNVNjTGlQ?=
 =?utf-8?B?OHM5OTRPR3RCQnJRaXRicklWZFcrVHVDS1VDNDBWc0ZBTTUrSGIyc0UvOERG?=
 =?utf-8?B?UUQ3ZzlGL2phTnBTVEUxRmhvQzJoZXp0cmdVL25JVi9WNlk0MjRES1lSYzNw?=
 =?utf-8?B?K01ESTNwQW1EVXNvMzdiNkszaXJYWStzc1lwZDBjR0Q0and0TFhJb1FCZkFY?=
 =?utf-8?B?bEdCcFE4VnVEZzZwVEdzcDA3WXNpSmFKSnZ2aGNEVzJ3ZTkyNlowaUJWK2lO?=
 =?utf-8?B?SGdHamkvS3B5ZnEzWlNJVk5EWVMzbFF3VEkrRVFzT2sxdU15b1hUNWlhUjhh?=
 =?utf-8?B?RCtHZ0hscEcrOTVRSzRNSm82bWRFdkJaeXFTYVN4NHVrRXBWKzdOUU5JcE1X?=
 =?utf-8?B?TjFVUWg1cUhzZHlhSDRsY3c1cjdJUzZKemk3V3dSdlFRRHhnWjJzMGFZVWF5?=
 =?utf-8?B?bHZzMnAyS0paZWJCK3VpT3Z6ajdJOEQwN2thYW4xeFBLWGUzSG5DTEhxd3ZW?=
 =?utf-8?B?NUlzeTlwdUREQ0ltVTFZQmxLbm55aVhoa2g0N3N4U1BTQlk5WE1nVVg3ZDU0?=
 =?utf-8?B?TVArbEhweC9vZ3JZUU5lVGdRS3NTNzh6QVBma09tNnN3aTk2NDhtZGZORktR?=
 =?utf-8?B?anBWYlI1ak5sSUswMXNYR3NNVXBDd0JQTkJOM1hXUHJuODBBVnpPWUN3b0Fx?=
 =?utf-8?B?bjFibFRTek8rOEJmc0RsQlNETTBUb0NVSDV6NERrWk14TGFFcXR3NnQ5VWVn?=
 =?utf-8?B?N2REcmRQUXE0b2F1YnZ2WDUwMTM0ZVFBeTlSUEhQVXM5bE55RDBibXF3aHkx?=
 =?utf-8?B?bkZCN3hwSEI2c0g3R0NRYVNVWng1bmsraXVvS0t4RXVTUHZEVWtzRmFjTlEy?=
 =?utf-8?B?c205Nk9JanBrZ3BKaTlVWXdFVG5XYlNlV0kzM2RGNmZWV3kvSVdBdHlJNGRx?=
 =?utf-8?B?SFluK1oxb3lTM1FqNTFsK1pkd0hlK2cwemtCelhxUkNTeDF0azlMMkRheWR0?=
 =?utf-8?B?S2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a813bc84-d105-442b-0117-08dd0e492248
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2024 18:35:42.8683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8VW564p+ewZgsOnPeCWhtxW4gw5hQXUJEyFrtqXBOOl+z2aJajBn4AM444VialF0deRR5XBepkDieJFBvPlvsalZIVtNaaZ6UYmJYu8Z4XQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8536
X-OriginatorOrg: intel.com

Hi Tony,

On 11/22/24 3:58 PM, Tony Luck wrote:
> Switching between local and total memory bandwidth events as the input
> to the mba_sc feedback loop would be cumbersome and take effect slowly
> in the current implementation as the bandwidth is only known after two
> consecutive readings of the same event.
> 
> Compute the bandwidth for all supported events. This doesn't add
> significant overhead and will make changing which event is used
> simple.
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
