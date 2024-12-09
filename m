Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CA6223C77
	for <patches@lists.linux.dev>; Mon,  9 Dec 2024 23:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733787619; cv=fail; b=NuiLwZ0/r4Vt6ksoIf/VF+/suoHT3yvKCes7z5nwtYNaF9TFlI1d5824CRH4S9BWj61iaaWQKj35yspp1AklfOuLNe1VoYwLne268HTFOkRMsYwM+udm+hDgwc3du8Y6nijHLjnv4NjoQ5x2pL7WtxHcsMaGk7UDl0zpehQCpjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733787619; c=relaxed/simple;
	bh=cmFQBtg2k8B/VWkdKU/bhWimd2PivG2levevwv29Nm4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oGdZIHbiFso3Hiy5/qbydTZyXTGmJve/hYY37UVqbaTEE4w9OwPWjLSyjL5jr/g4Gz3PQnKq29Utw772X7fAt13qoP6+zDRZT4nmRf4ILO3URKtQBLDZbsoHTi/eftWsB61ijpNE6NAo/IkJWRXH0cBNVPDLSXjsBbIDhwxUb4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TVlS7PRV; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TVlS7PRV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733787618; x=1765323618;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cmFQBtg2k8B/VWkdKU/bhWimd2PivG2levevwv29Nm4=;
  b=TVlS7PRVFPue9Dj2B2osWygBppW0/JyJRMhBb0mwNKX6hEmY3X7XzgPQ
   A15ogyVOlN21xoW8B8BnhxkqI/tyWozC0NqMIsyVUY+jW539ZJaj35p1S
   3Jf1k7hrjnmv3uCq51bnd8cmdi7s5GhzecOD0jwFpdlcMN/VDE9NZrwB9
   qlY1A4FFTGT3adnp0EzGWeagfEp7AAqX8frMRQRp0H79uadaCJEhXxQbC
   aUZSb8Luzr2vHNFA0A1M8RiFmjycDiang9GFMtCYws8tpuYW0hWt9pK1p
   j19YI0g2DmY5E869GAlkPgxlxCRmmz3ODRpmKpVcz4CT8f/fVfEVV17t2
   g==;
X-CSE-ConnectionGUID: 9BGbQ+W3Rgy131CtMLqJsQ==
X-CSE-MsgGUID: ux/CwiEvRgu5OIPNABJNvA==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="51523867"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="51523867"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 15:40:17 -0800
X-CSE-ConnectionGUID: 0CUEo3VnQNC+trkb9XkiPQ==
X-CSE-MsgGUID: BxGtd8+DSr+sXAKicCuVEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="126116080"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Dec 2024 15:40:17 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Dec 2024 15:40:16 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Dec 2024 15:40:16 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Dec 2024 15:40:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K9UWSI0N0BURn3xlgIc3OS9AQ82mWN+Qf2qZKaSWwKKkrhJN7/S8v9bj3nn+KI41T8eCiDEQ2cFSQQgSxa2FtXtKoxLPi6sEuSwzyPA/olQ0FYyem/z6ca1QEocDQFURJowEbTRkVteoCtShDXVf/wLoy09EpKGNSqaqbJbYoCjIiqNM33vJRFJjsSfPQ6zQeLNUGU6OHwj9GG7+FKG1yepNNXbJFhwzlR0hiKVkCgwCNEYodrNibf4LvARP/A1a7V9gsDflsfNMBfjBPXWCWvdNDNC6RgB4WOdX0pKgrfj8BlrEr3O+rsXC9GDkEGxY4ZDuyD0fIq7+sJgTzCo5+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pJO3UZvkARUznjcvAgbf/UGTBXfPurxWF4B7ha3yGEY=;
 b=Fz2GIIDsT9as3Dk3PJk5JdP1tA5f1RKjblBZSkgC3z5D4iIaA5V9HmefCm0+X/p327vq79TEmfNjiIMokiXiCFojGIH8Ju5FuiSnjcy+HAFbUNjWTZSD5exkRImuwHae0tvun5KJArOeZcjnGZmsIgo0PB+IAdkIzhWI6+AYhhZZaFNXMJrTKNR8z+yOz7vC0NIjzO67LXq3j3pX/hWpmKSXfymFB7zt+vDEF6jpDoUg1kAhLPei1dpYLqH8qP1zGzzXQLtXNJ5kPBvZRnMdR/4LgSZfNlo7ox7rU0QQDkTmg6iF++HeDfAYAXMtzLGcdbCgRI0YFo+FZOUL8TVALA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA2PR11MB5196.namprd11.prod.outlook.com (2603:10b6:806:119::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 23:40:14 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8230.016; Mon, 9 Dec 2024
 23:40:14 +0000
Message-ID: <678cef69-78ef-4951-bd31-10abe646e6d8@intel.com>
Date: Mon, 9 Dec 2024 15:40:12 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 2/8] x86/resctrl: Prepare for per-CTRL_MON group
 mba_MBps control
To: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, Peter Newman
	<peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org"
	<x86@kernel.org>, James Morse <james.morse@arm.com>, Jamie Iles
	<quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>, Randy Dunlap
	<rdunlap@infradead.org>, "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20241206163148.83828-1-tony.luck@intel.com>
 <20241206163148.83828-3-tony.luck@intel.com>
 <20241209204519.GAZ1dW3-NjcL4Sewaf@fat_crate.local>
 <SJ1PR11MB6083BA367F2CDFC92D87FDA1FC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <20241209222047.GKZ1dtPxIu5_Hxs1fp@fat_crate.local>
 <SJ1PR11MB60830B8ED36CCA7E304D9E97FC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <SJ1PR11MB60830B8ED36CCA7E304D9E97FC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0020.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA2PR11MB5196:EE_
X-MS-Office365-Filtering-Correlation-Id: 35bc7205-4a57-4997-9f40-08dd18aad440
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V1RQSWF1MDQwTVlmbGN0TTlLWEYrU0JLZytNbVdZV2hST3NaQnp2eWN4Y1FY?=
 =?utf-8?B?TzUyeFpoUERxVjlDZEtuRnJGcHhQb1k1Qmpyc2lnUFBkeTNRUHVPS3M4OG9Y?=
 =?utf-8?B?MkI1K0ZrNXBHa1ovaXRTWnAyZFYzeHYzTjA3NnE4cEsxSnlRU0N3OVR4amNF?=
 =?utf-8?B?RlY3NURQVjRJVHFmRHdqTDBJS2JnKy8yZTB6ZmtyNjBYeTBLYy9NR1hJbVc1?=
 =?utf-8?B?emZmdG9wUUhOb2xVNlE2SzBHcVhaaW5mWS9kUVFrZkFzclUzNCt2bFkrRVpj?=
 =?utf-8?B?TkhaM21jamk3bmMxZCtDL0E5eTVobTJ2SlVQWnRYT2pVYWRrQ0VjZStpVGxL?=
 =?utf-8?B?a1ExSVdGZ0VveHkyRlpjUUxUOVVvSk4zQTd5eklrZWtwbTFQWGFDNUJ3TnpL?=
 =?utf-8?B?NFdweE52Y09HZmMyS0RoYVZFNEZCMWJabjMvTWZIdk5jUnpYYnYyMFl1OUh1?=
 =?utf-8?B?N2hVQkZ6VXVnbXZyZ2xjL1h5Qllsc2xaUjRnWXNtZFFxSXhDZkZTUHFNNnlH?=
 =?utf-8?B?eXAzSGhkTnBCd3o1akR1cnJ2K215endFelVVNTd4UWx5anVuWE56STFSbi9z?=
 =?utf-8?B?VzlTQ0NKTmNsUmpnSWFRcUFQRVFzY2JraDE3UzV4MUM3Sjc3UHNXQU0rTmpz?=
 =?utf-8?B?REpobDJHaldKampJWWtReGwzb3h1UFhMTTZlZGFaS3JwdEVvQjFibkNDa0Rx?=
 =?utf-8?B?N2svTnZXclM2aHBaQU8zYXZmSzdCQkEveUF6ekVNNk1iOEhwdUVscFlGYjVI?=
 =?utf-8?B?NThBVkxwVXdoRE9leEt0K0JlUzJIYWZySmljVjQ1V2pac2lidU1GTXRxQTNN?=
 =?utf-8?B?T2hNNEl6SFoxWWNlV0hEQnd0cXQ0V09WRTFLbmwzSHhaK1hMam9aQzNEb2g1?=
 =?utf-8?B?cE9YWWVGaS9HbDgzTTZCK3VlTG5OclBNL1NTMnR5Rm9vL3NQQjBwclg3OFFi?=
 =?utf-8?B?RmdjKzkwUUMrZUY2T0lTbjN6L0Fwc3lHTVlGVVBFanNUQ1pwTEtqbVppS0F4?=
 =?utf-8?B?Q2d3OVJYeVJhMDR6Q3VIMnVjOFZSM2JnQ0duaEQxNWZROEpJdVdxdFdNQmRR?=
 =?utf-8?B?WnFkWkplQ3RZK1l5OExYSnp3Q1ZlQm1pTzh4N0o5ZmZRL2hzRjBsdW83VThV?=
 =?utf-8?B?ZjlCSjlEWVVIOXJQY3psbXlDbWZXWDBLUEdaRzNrTkFBWUVXaDZiN2hyalVX?=
 =?utf-8?B?MVVETTlpVVF5ZXJOWVpBcWJwNjE0Y3JQSlNPdTJMOGFzbTRCdFhWRHBWYThD?=
 =?utf-8?B?L0FDbWh0bFpvTjlaVXZQTFNuT25tMkFHR0RSQThhNWI0ZW44MXBKb2NNSVJt?=
 =?utf-8?B?Vkl0bGZFOW4xeG5RbFNuN0FyNC9wYU1IM0N3Y2Z0WlFkeFJNMWF4anNLQXdJ?=
 =?utf-8?B?bnpESm9zWGZwdHFpd0h0SEFDUVZ2VWVPaGtmK3I4Ni9IZys1SmRMVjBFM1Ba?=
 =?utf-8?B?cjYrTk5MZ3doTzVFbHZmbGZtOUxqSjlwR2JVOGZvbVB0dGM2cEYyWFpRNnJM?=
 =?utf-8?B?OVBrenVFblR1WHplTWdhSGRhRnFlR1c5OTY0Yk9ZWFRhblpEK3o5bm5Ec21P?=
 =?utf-8?B?UUo0K2RnbDZKNU1TcVl0YXJZbjlyck5KVHFrWUFuam50MzJXSzBFK3Bqa29H?=
 =?utf-8?B?TFZvK0w4U05zZSt2aGoyV0dEK1UvK2pjNk91Y05mSHRMY3NUWklGNy90MFZ4?=
 =?utf-8?B?Y0ZZU2t2TkRpL1VlU0FDaUJqVXg2bytTTW1JUDBROFVLY0JVNVNIb1BVZEIx?=
 =?utf-8?B?Y0NNeDhoUkRSRHNSZ01CakhSTStSWWRRNE9nSy96RVA1V2JuUG1YZWpBVjNR?=
 =?utf-8?Q?ixeg0gQcOR1Evom3A/f5gHYWH2i/XORkuidxU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V00rWXk2L2ZaS3JhSmxLT3crRWpLanR4R1hscFhCaFBPdTQ2S1pWSWluWFZ3?=
 =?utf-8?B?KzU4R2hYSVJsYXZ3bzAwdmhwcFQ1Z1o0U0tXTk8wZy9aNFpjMHRuQUs0Znk5?=
 =?utf-8?B?ZHVScHRwRTgwU015SHNsM2YvbkY2eWJ2ekRHcnpGcjR4UENrL3VteFVZTUVt?=
 =?utf-8?B?cGJJQm93Q2lqRElJUmNMdjkwZGhXNmllNmxHZFVpakVBOTduUmdSOWJqNTZK?=
 =?utf-8?B?TE9ZQWt6c0FFWHE4eGFLS1FBeGN0UlVWNjg4ZWRtenBCMlFiNVMwNEFEN0hK?=
 =?utf-8?B?WGJpaUZUTURRM0hzOStpR1JySDNNMFZSL1NXZnpHSTF0eHBMaHh4QzQwZDdS?=
 =?utf-8?B?U1NBRy9vUWt6RDRrRkZBbjFMU3k1MkVENzFwb1VyWWZEd0l1aFM0dGdTTkdO?=
 =?utf-8?B?R3NyTnpCeFV3N1B6YlFzRnE4WkF3dit3WUttMHExdU5QTEpKZUpPMHk4VkVw?=
 =?utf-8?B?SHAwOEQ4djRnOTVIMkNONFYwN3ZYL2thbDMzMnlDK3ovalFNMkRNR01yWXpS?=
 =?utf-8?B?cit5MEE5ZWFHWUpseTdwQ2NmMUJKWVZWYnN3T2FDYzRxTGhvQzMyOTNSNFBu?=
 =?utf-8?B?c0xxVnlFQjlQT2FvSEpkS3pOTFVvLzQ3alB1Q3JvaDFuN3Y1RFh5cmVoWVNH?=
 =?utf-8?B?TzU2QUtIeXBYMkV2aWF4ZEI2V3Q3WmtjL09VTEx6Yk1zSnVMMXpRY1lVZHNl?=
 =?utf-8?B?WHBRdHpHbmcwamp4MGRRS3UrRFlaZ3NnQjN2OEhrL0VmRDBnNVBzTkhZbmtm?=
 =?utf-8?B?alI2Sk45UUpLemZSS012ZHlCaEtXVTlHd1A0MmtyTVRrbHI1ZWxYUzUyNE1U?=
 =?utf-8?B?M0QrdHFJMUp3N3pZeldaWTNTd2RHdnJvQzh1RGdXRHBrWVRCTUdKazJrV0xG?=
 =?utf-8?B?d0V2VWRiQjEyOEYyQlV5cktkWWg5enBhM1VvZGwrbXhIcHk5cEtCMXpSdlpm?=
 =?utf-8?B?SStUOE15L0E3QTBIdXFSK3FXZ1pqQVR6VjZabUhZTS93L0h1QkYrUDRWN3Js?=
 =?utf-8?B?RUpjL3h4NzRCckJ0dDlLNmdaalZMblZqekk1VW5VNEs4aEZXeWNMNjlGTmdH?=
 =?utf-8?B?d0Z1VFFvUkUzdEQ1dVRlaEZBby9XWkZJZUF2dmxud01IYjkvUXRqSXRydlR0?=
 =?utf-8?B?YWlJVkM3RmNTL01lMTJSMHQwRENrazR1YXppa1V0RzVwVWV1WUxqVUZqSVo0?=
 =?utf-8?B?T2toeERkM01zaTNsemNTN1FGUTd1eUJLUzBTRGQxRVBLOEZIeGJRMXVPSEhl?=
 =?utf-8?B?aFNDSlRqT0FqQmRTbG9yc3RIbkZ6Q2xOOEFRYVdyOFlESEJkYlVHMUJCYzJi?=
 =?utf-8?B?TXdNc3llL1JWTnhpWlVRbFBNNDFQeDRCVFFMVTJnWDBuZDMwczlJSFd3T2hp?=
 =?utf-8?B?MUJsY0VzdVc2QysxYmZhWmJabjdwa0NTd3F0WEExVTBzVDVJeElMQXlzN21t?=
 =?utf-8?B?V21xQ0QzUit3TDhjdFdVZ1k0cFdoZm9xM1NHZExwZXJCVGpPcDhzR2JKNWU1?=
 =?utf-8?B?bEpCMFFyVDFpcEorMjJmRHpySXVIOGkwM0NaVjFzc01IMlllaWpwTWlBKzds?=
 =?utf-8?B?ek9rbkZYa2hUa2Z5Y1RPOHYyM2FmR0xJMmtxSDhuSFFadXRkQ3hxeWM2Z0tU?=
 =?utf-8?B?L0IxbVZWcUNlbnVsQS9PZjZsajNwVjRzMFNZa29GMU5Lam95T2VmdnlpZ0h2?=
 =?utf-8?B?T29WNVEra3Q1d3hGMGlWWjJ5SXlqK01ZbzlVamxyNmgyMFpuSnlDZVp2QmV3?=
 =?utf-8?B?SkQ1c2c5Vitta0lDZTh2WG5yY1JzK0h0cVZpU3JQU1g0NjRObit1RmQ0U3Ba?=
 =?utf-8?B?OXJOVnQ2NDI2OFlSeDBuQy9PdHZNbWhYMmRwNnJpVW4reDl1K21ZdG9pNTBD?=
 =?utf-8?B?VW9WVDdVb3c2WDJHUzRLT1dDc1VLMUQraGJqb0EybVVoSXVKeVUwc3VieWJZ?=
 =?utf-8?B?MGYyaVIvdVowamhDT3QvOU1KTUJ3RUhETy8rMFhYaDZhbTRFbzlSUzRxcFpV?=
 =?utf-8?B?b2lUeE1kK0Y1cWJ3WC9LSis1ZU8rSGJ5eURsTkJvL2xVbGdzWHRPbzZkS1lk?=
 =?utf-8?B?RUNhQ1V0UU1wcEZvazhQZUIvemVuKzA2QVZKOTkyL0FzaCtPRmdvMlNKOWRC?=
 =?utf-8?B?dEZGVG44THZHOWJKRDNjbVFsZ3B3eVhwV1pCWjU5RW9CS2p4bHgvLzhJbVVp?=
 =?utf-8?B?aGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35bc7205-4a57-4997-9f40-08dd18aad440
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 23:40:14.2239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3q/HTChGmyOEhI0RYqAheA53Um1dHC542hoiiU94CxeYR5mUKD5/j5t8d7hQn0gdVBf8PZBQW2vlRYcwSyc3wV5WcO1To30K5qes4yqHnro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5196
X-OriginatorOrg: intel.com

Hi Tony,

On 12/9/24 2:35 PM, Luck, Tony wrote:
>>> mba_mbps_default_event isn't architecture specific. The mba_MBps
>>> feedback code could be implemented on any architecture that supports
>>> both measurement and control of memory bandwidth.
>>
>> Yes, and it should be moved to that header then, right?
>>
>> But not earlier.
> 
> If you feel strongly about it then go ahead and cut the line from <linux/rectrl.h>
> and paste it into <asm/resctrl.h>

I am not sure about this ... I expect the code needing this initially will
form part of the filesystem code so it may be more intuitive to have it
be located in arch/x86/kernel/cpu/resctrl/internal.h as Boris suggested.
As part of the arch/fs split it may then move to fs/resctrl/internal.h

mba_mbps_default_event may even stay internal to the fs/resctrl code with an
arch helper created later to initialize it. This is because I think
the initialization of mba_mbps_default_event may move out of
get_rdt_mon_resources() into resctrl_mon_resource_init() that is being
created as part of the MPAM work [1]. An example of current fs initialization
done in arch code that is moved to it can be found in [2].

Reinette

[1] https://lore.kernel.org/all/20241004180347.19985-17-james.morse@arm.com/
[2] https://lore.kernel.org/all/20241004180347.19985-20-james.morse@arm.com/
