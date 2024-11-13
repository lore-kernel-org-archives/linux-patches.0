Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A70191466
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 23:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731542344; cv=fail; b=mwLQzjoFr6tnyWKVMXAhGf7B4luTsHQlT1uDFts9WznwQbS0nTF5Q0hgRyrCfos+5MonQtPmN4FWx86SDZ1ZJks+QVmUT340S0cbmoqXEwGyDN4HxTLaTnP2xnxxMC18F4xTLkUAENvgHapfVxRdPIsh5ZrA5riMX+/Tb3xbGw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731542344; c=relaxed/simple;
	bh=I6ysFqZkrfJSWUD2AMVneDLNO6clOkfMlNMQhQCHTTM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ulUncn7XyGHUCpmFIt5iCWuhc6W38pzrR/lcbHsGZ3Z9SdiYMPOURVJnXPdG1ZRyE4UW1ZcHrxxQuPbdoadmHrhjN5BETrjL2YRckw5m1ZO4V67juObTwH/vlfV7NoFEjAb6OGLPZzZvBIf+qhhLhUfeE1hUhGlqRqYEQ/IIl8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C+HqV2Z7; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C+HqV2Z7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731542341; x=1763078341;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I6ysFqZkrfJSWUD2AMVneDLNO6clOkfMlNMQhQCHTTM=;
  b=C+HqV2Z7rqjY4oQmXvDDtStIiJ4TmkluejP7rSt1g9yxw3oLiMMPgQ5c
   hSrJLeXabGu4uoevc0Vs28ePiPZ5lgoEH0DoQe6Kglpd4qGKZXxdB//8V
   LN6d/Sn6GDav9Npz4UerfDffhQCsBOAiQlH2SAQWDwlzuaxQvCL/S4SVr
   PQKoefbjL9p6MbC+YqZIYalZzldV1p1lSjQ+j9N9f8VuQtns4NR0xm3d8
   d+7de9vtLfA6U+5zcpqmXlScPLFyDhDdzQetjL9ZFtoNQUssl3eftpqhN
   slMpp2VwDFtVFbXDd1yfC2n9S1tAMLo2/uk0/AvINK/p8rQyq6+ka6D20
   w==;
X-CSE-ConnectionGUID: RYWU/6hjTCq/m1EjWfdOtQ==
X-CSE-MsgGUID: I9MlSns9RTGvo9CPGUgBaA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31436208"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31436208"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 15:59:01 -0800
X-CSE-ConnectionGUID: +KGWyvitQBKI5mNFL/QbGw==
X-CSE-MsgGUID: ko8KrH9vSgSauiJmLgsaBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="92968363"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 15:59:01 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 15:59:00 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 15:59:00 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 15:58:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fewU3+uxkgfBYGrThd49iKleUG34tmClEiN0mCLNDmifsNPXmc5KnYL0HuU3Fqq7hiP1TZjlHcnbPBEGuBysH4mpKAmq1j16vSYl2oqJpGJtxtDZdISHXabpWCWE6T5lglS3QCGq9l0LR+4i9wO/EDOA7WAXbvDGdY3Iv4dBPAdgw643F0NPyAUbGNaqdqCp1W1GYhXJBiCdMUDLhUXbvB9giubYlw/boFohq0gPnzs87etPpGNq4kKEYXuBFmRiqKF4Bq/Iz//g+hWE3S984t6PeSOqopAqUparD6YyJwOgf0qIrX7Kbhh28PwTdu2EzXZE3HFtbKL8ZNu4Fu5i/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zlgkupWU/I1G4BSm/cI7uCJ54Qlidx/sg0wehTd1pcQ=;
 b=LpPXD84djSjRiLy72qEgPfv3pEe+SqZkNWVYcYTDPmZHbAvP5VM0VWB+IGyKd81qYLJe84ROStsjfXtXlSKnxDBvWSuzTwVbOxg7vi6E55adu2pVtUdcoR/c8ANKSbM8ZMuLeLC+r3P09zX1E0WqTeaCxMSMAAwcs74GxN+Og5/LraI5Pvor6qMZQIHbMdAYAjZCRV4OOX8xpXOvWDXIkKH6WIpKgNFX9JtnFBFs3svoaJ3pijO69YR6HRWdu3xJOIPdOVujaYE0DRUPnOGZLgW/JMSdW23n9kVX1VWDaKr1llHnI4bYRQLomDX2nyi543ThPDEMN7b56GjdVxQ7cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB6269.namprd11.prod.outlook.com (2603:10b6:8:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 23:58:57 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 23:58:56 +0000
Message-ID: <2aba3cf3-3b3a-4349-a914-a68fab727214@intel.com>
Date: Wed, 13 Nov 2024 15:58:54 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/7] x86/resctrl: Refactor mbm_update()
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	<x86@kernel.org>, James Morse <james.morse@arm.com>, Jamie Iles
	<quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>, Randy Dunlap
	<rdunlap@infradead.org>, "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-4-tony.luck@intel.com>
 <f4845fee-3f91-4e78-a186-a7bdc58f7873@intel.com>
 <ZzUvA2XE01U25A38@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZzUvA2XE01U25A38@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0326.namprd04.prod.outlook.com
 (2603:10b6:303:82::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB6269:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d3e648d-4063-4240-8929-08dd043f229f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?djI2Qmg4VGJ4cDIzTGdwc1M1ek1mUzhHSVFjbG1YSnBET3ovT1pZQzhtaS9E?=
 =?utf-8?B?SEZJdzdxK0pOOUFETWwxRjREbmFKQi9tOUJKMTgwUjErdzJOSG83THB0TFlT?=
 =?utf-8?B?TFd1bHIwbHNDM3ZQdWp2ZkJsTkNycktzaTB2aDBUazhtUnRqdWVFRnh1bWJI?=
 =?utf-8?B?akdvNURTY1IraWw0c29iOUcxQ0M3RytlSzEvaVVzck5RTVdXbHREZzhwMjQr?=
 =?utf-8?B?YUF4SjlIWlZIcHpFQWFVL3pVWWxMeGcrOFpSc1FWOWVENFBNQk5aRSs2V25O?=
 =?utf-8?B?aFhFTEE4bWp0K2cxdG5xNFMvQlpaa1pQdnZKblNKaWplREF3ZHQyQjErSVdr?=
 =?utf-8?B?RUR3bVZHbzV4cGxkb29JRGZNOFBxUjZqbCt3WG5aVHEwVDNHQ1BrTFE3S0M4?=
 =?utf-8?B?UnQ1K3hSYnNkdXoyZWNVYTBWVW1CVUlWSE1YWmEwcTlVbjhZREg1c2MrSTlB?=
 =?utf-8?B?anliMWRFZ1NzUU1aRUFoaFBrbzJBTXV2L2o4QUxtUTY2OGhCNjlMVEtkeHN5?=
 =?utf-8?B?NzJXQ1g1d2dlSmswR2g3T1pVclBaZVNQbU5mTGgwVGxaZUxrWEE4dUZTbXlF?=
 =?utf-8?B?a2hRcUJYRStMVTlOaG1kTC9ZcklBdmFscWRaeHk1aUx0c0lTTVhQTjhiMkpK?=
 =?utf-8?B?L0RSRTZtcXNVd1oyclBhdUt4TGpBUWovTDZWb2xzOG8rUEx0S1oyUDBTNk5o?=
 =?utf-8?B?dkFOcVVOZExHc1U5MW9PdTlmQm9wUGgzeHRVTDllYzE5SlZ2RFBqSS9FUGEy?=
 =?utf-8?B?anUwSUh5TVhVY05WYjNmRmpxVjZGL0c3dHdtV3NUR1V5SjhLVWtUWjVmVktS?=
 =?utf-8?B?Ulcyck04MVFvb3o5OUYwWS9MRlZNM3ppeHpRblptaWtxYzJSbWtpSm1wMWxN?=
 =?utf-8?B?NVZuTjNTZ0RwbW85Wnp6eS9EeUhuYkdZK3lzMHlYUnltOG1IR1VHRHVHZFk3?=
 =?utf-8?B?MUJVUC9PZkVFUkVwNzlvL1hXbjRzaWpsMTZOeDFUcWlMa09pRUo1cGEyWlNa?=
 =?utf-8?B?Uzd4V3ZpRkdKSmc3bG1IQ0hBNHhkY3VOTm9aeVlDVi9wai9XK2tuYkI5M0wz?=
 =?utf-8?B?akRHc2l0eUdNdEo1VU11ejU1M2FRRVQyTnp1WExvamRBMVJYdXM5aXFvbDZi?=
 =?utf-8?B?NmIxaURWbzV6cHg5ZmVXODFpV05FYlZSQ1hpUjF6OGh3bUtyWWV4MU92bXQr?=
 =?utf-8?B?ZC9MZkt3UnNrNCt2Q2I5VjE3NklJRGkvZThIMGQ4SElsNG9hVlJTOEtSZTJG?=
 =?utf-8?B?WkVxZ2M2cEdJOTdLN050Z1Y1emJUVWFlMmk4R3JtTFQ1Y0VJTDNpaXBhZUd5?=
 =?utf-8?B?Q0xjbElXMnI1Z3hKMTBrcXR0Y2h5STltZGl2RHlzVG15VEdTTzR6YkNKY3RU?=
 =?utf-8?B?WmhTZi9ZTStEemY0MmRwOXhqQTl5N2l6Ym82aUNvdmN1T3ZUVm50SXhxQWlr?=
 =?utf-8?B?dkFlYmJOS3Y4cUtINks1U0QvMWVaNmFtL0YyZUp6MnY0bHVtNWRrelNxQUY3?=
 =?utf-8?B?L21XUTMvbzRabGJSdFdZR0hhUThpNkp0ZGR5UTJIaGxla0Qrbk5kMWJTTFUy?=
 =?utf-8?B?Y2VDNmdpOStKK0twaXlXSmlRZHBPZ0JCWjVEYS9vTGFXcVIrbHovRHpKaERo?=
 =?utf-8?B?NWtXV092SjFpRksrRU9sWDllZ1RRWkxnYnFqUDZrMWJheVI1Q2x4Uis2NEg5?=
 =?utf-8?B?SUtUNTM2b005U1NlNW9UZlRRS0l2RVl3dVpuK3pycHVMUi9ldWl5TnR5cTBw?=
 =?utf-8?Q?kzNV+Y7THcRvbDL2iE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmZ1RXpBeG1WM2Nwd0dMOW1xVDNLU2l2R3BYd2ZNelUxV01uRFZoaDVLYUhh?=
 =?utf-8?B?QURQb0JIUmhwSVdKcUtpVjVZTEN5UjJGN1FBdW1RRWxnUHBrRWRMVUhCUmlB?=
 =?utf-8?B?Vm1lN3pWNEh4RkpiWGVGUU9SQlcrczlvbGlzN1BtVUZlajM1UU4vY1lrcDV4?=
 =?utf-8?B?RGdyY2l3QlJZVjVLNXB5STZ3ZzhXaThWYVBWa2FyZWFmVzJvUWR2Yk1NYjVJ?=
 =?utf-8?B?SFFYZlZGSjlBS0lIb0hXdnVRTXNwQzNpTEpVbGl6SG91ZUwyT3pPVEo1Vnpt?=
 =?utf-8?B?cVR3a3RVTUkwWmJQT3FVRVhXZUxSUmNtaU1qazZjT3BEMkdwT3k4NGdxb013?=
 =?utf-8?B?VnE5QlZmZllTRjR3bW03QzNOZWJUL0J6R0hZbWMwNUlrdkI0LzQ0MUZEUlM2?=
 =?utf-8?B?U1BLTUVBcm1jOEpPdENWRldEUHQrejV1TlY5bGNtR3RjVEQrbkpJdkNRZHYr?=
 =?utf-8?B?U3ljcFVHbHR4cmdoUHloMVJNVFNYUnNsRUtUdUhtZEptT2hndHhQTC9BWlM2?=
 =?utf-8?B?NEg1ZEtSSDlxTjJycUQrV2VIS0VtZVBKSGFGSmx3KzhtRTBCMWpKT3J5d3hS?=
 =?utf-8?B?TE52UXFUQUdaZkpjTDBtWURadzVZeVhrQ3hVOUloTFg4YlBRRlJ6aHkvaHRl?=
 =?utf-8?B?YXQ5LzlNQkRUUWJEMElBMjNzQVIyRGkrNnE0TGtMVnhOZ1dhVkVlK2tucTlp?=
 =?utf-8?B?dHJ5dzJmTlB5YXRQM3hqQ3ZTUURRN05BeEhRM0xMZE5pMmZLVCtQbjJGTHhO?=
 =?utf-8?B?bEt6cmpqWGJsOUQ2dmxhWTN3KysvOVlHRlhaamsvOVJDSVc2TlZKQXZqSEtm?=
 =?utf-8?B?N09OK0pYTGY2amVKTncrZGdqdEpNMUpyRW9GTi9tTjBVMkIrSDNQK2xxc2ps?=
 =?utf-8?B?d1FhT1liRElYWGgyeVhXMTlIUU9XWlUwL3RoYWZRaG5BU2JvWUtaRzZoNlJL?=
 =?utf-8?B?YXplaXVWdUpLWFNhT2E4SmNzTHVvYnl1MFZhSFVpT2RmNE1va2l0QVg1KzJ2?=
 =?utf-8?B?cEE2ZjlFOENhMnNvZWo1OTV6SUNWTWthM2YvRWRudlJTNWQyazRTdWhUNko5?=
 =?utf-8?B?VUJBUnQ1M0dvQU0zazRIa2l1Um9WMlpDSm0xdGZLTytsT1U2M3JIT0dBSnpO?=
 =?utf-8?B?Z3h6ODk3RkJQc09RNkxsS2RRc1FISzliby81MTZDZE0vL3NiZDFwRkhiN1cw?=
 =?utf-8?B?M0FFcnJ2R1lZKzRGVW0ybEM0ZnZDZXdTYnRnZHRlMXBDQ29KaGd5ZGFQU3BT?=
 =?utf-8?B?VHlXTE9TQS9PNC8weU8vSnJ1WnpYOGxSVkR6V2lIbVJBb3ZKYmxjWHA1Y2NR?=
 =?utf-8?B?bDAvb2hjTjcrQldlcTV2YXFhMkRjVTZDNkJsMnVEaVZGS2ZMTG94N29CZkcx?=
 =?utf-8?B?NllUemZKTitsRU1INjBBa3ppZHN5bnVYT21KbUQvWWRCcDM5ZGw3Z2pJZkla?=
 =?utf-8?B?djVTMWVJYnZVM28zWWVDa1hwL2g4YlRrSDRDWkNtLytQY2RsS1BwTk0zaE1t?=
 =?utf-8?B?SFJFbnF6VldIL0dGTlJvMDBCQk54cGF2dm1iTjJ1WHJ3MnZKSUFVV3dmTW5r?=
 =?utf-8?B?VnU0bGxPREJCZTFEMmRoSjBCZmlSMXViUEdMMDNaTDlONTc0dWIvZnA4akxl?=
 =?utf-8?B?RlJVQ2tDZGpxc1QvMTJ4VVhVbG5jcDk3bWFURHFhNjZnMmE2cGlZcjExckE5?=
 =?utf-8?B?WXpQOEZSaWhqNjhyQjY5OHR1ZWttai9kQ2IzLzRDbXJ6Z1NLb2FMMGF6dkJy?=
 =?utf-8?B?MUZ0NUtJNGVmR0lkb3ZHay9HV3R3Y2ZubFJnc0l0OUxTS2NVRTd2RDd6OGty?=
 =?utf-8?B?bklrcWdoWUViTm8rbFVuQmhxdWlxeDI2NFRJZVp2T1QvRHhWVGxSbEI1SXFu?=
 =?utf-8?B?Q3psRDByVGJxdFBZMytabk93SXUydHhNVWtxUXVrYzUyUndQQTBZRmVpSjA0?=
 =?utf-8?B?NFBBM1ZCN2FBRE5GTXg4QU0zOE40MG5uK0pJSDBGTFBRMlBJd1VtRXNRdmVL?=
 =?utf-8?B?c0p0a0NQK25ZQmVZTXU2MmR5eVhockQzbGQyTFNxQlUzUGNzNEp5aDA5RWZI?=
 =?utf-8?B?U0R4SFRHOEYyZVBoWDN2bVlJWUd5MzM4OUNVUjdSRmdONTJPbzl3T093TER4?=
 =?utf-8?B?bGhVVWlsK2lZNWp3elJvZW51bVlmK0FLMzNJKzBlUDlFNjVqQitheFBYM0pr?=
 =?utf-8?B?MXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d3e648d-4063-4240-8929-08dd043f229f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 23:58:56.8099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wkMhCZg0t7eGpFxZVNSFnnye4P8IAsGkSYL3RNz+lU6pOtaRYu2JqyMbI4Ax8Mazl+wuETbsEUp1qLdkWgRE6cz35qw/7UjMlPsA3DPPdDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6269
X-OriginatorOrg: intel.com

Hi Tony,

On 11/13/24 2:58 PM, Tony Luck wrote:
> On Wed, Nov 13, 2024 at 02:25:53PM -0800, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 10/29/24 10:28 AM, Tony Luck wrote:
>>> Computing memory bandwidth for all enabled events resulted in
>>> identical code blocks for total and local bandwidth in mbm_update().
>>>
>>> Refactor with a helper function to eliminate code duplication.
>>>
>>> No functional change.
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>>  arch/x86/kernel/cpu/resctrl/monitor.c | 69 ++++++++++-----------------
>>>  1 file changed, 24 insertions(+), 45 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
>>> index 3ef339e405c2..1b6cb3bbc008 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
>>> @@ -829,62 +829,41 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
>>>  	resctrl_arch_update_one(r_mba, dom_mba, closid, CDP_NONE, new_msr_val);
>>>  }
>>>  
>>> -static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
>>> -		       u32 closid, u32 rmid)
>>> +static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *d,
>>> +				 u32 closid, u32 rmid, enum resctrl_event_id evtid)
>>>  {
>>>  	struct rmid_read rr = {0};
>>>  
>>>  	rr.r = r;
>>>  	rr.d = d;
>>> +	rr.evtid = evtid;
>>> +	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
>>> +	if (IS_ERR(rr.arch_mon_ctx)) {
>>> +		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
>>> +				    PTR_ERR(rr.arch_mon_ctx));
>>> +		return;
>>> +	}
>>> +
>>> +	__mon_event_count(closid, rmid, &rr);
>>> +
>>> +	if (is_mba_sc(NULL))
>>> +		mbm_bw_count(closid, rmid, &rr);
>>> +
>>
>> As I am staring at this more there seems to be an existing issue here ... note how
>> __mon_event_count()'s return value is not checked before mbm_bw_count() is called.
>> This means that mbm_bw_count() may run with rr.val of 0 that results in wraparound
>> inside it resulting in some unexpected bandwidth numbers. Since a counter read can fail
>> with a "Unavailable"/"Error" from hardware it is not deterministic how frequently this
>> issue can be encountered.
>>
>> Skipping mbm_bw_count() if rr.val is 0 is one option ... that would keep the bandwidth
>> measurement static at whatever was the last successful read and thus not cause dramatic
>> changes by the software controller ... setting bandwidth to 0 if rr.val is 0 is another
>> option to reflect that bandwidth data is unavailable, but then the software controller should
>> perhaps get signal to not make adjustments? I expect there are better options? What do
>> you think?
> 
> Skipping mbm_bw_count() is also undesirable. If some later
> __mon_event_count() does succeed the bandwidth will be computed
> based on the last and current values as if they were one second
> apart, when actually some longer interval elapsed.

Indeed.

> 
> I don't think this is a big issue for current Intel CPU RDT
> implementations because I don't think they will return the
> bit 62 unavailable value in the IA32_QM_CTR MSR. I'll ask
> around to check.

Thank you very much for confirming this. 

> 
> But it does mean that implementing the "summary bandwidth"
> file discussed in the other e-mail thread[1] may be more
> complex on systems that can return that a counter is
> unavailable. We'd have to keep track that two succesful
> counter reads occured, with a measure of the interval
> between them before reporting a value in the summary file.

Looking at expanding the scope of mbm_bw_count() beyond software
controller as well as beyond Intel to support [1] is indeed why I
am looking at this code more.

Reinette

