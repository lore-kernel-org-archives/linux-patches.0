Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F641D049D
	for <patches@lists.linux.dev>; Tue, 26 Nov 2024 18:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646045; cv=fail; b=tQXF59a7LLGJ8cOodfIsGaQjdJvvVAT6GhicuAWVYObiqLWWEYnXLE0Tz3Uzq2+lER/2/F8O3sw3OK/RqYwdR6TqHPR3n/Yl9xY5K9mgonOA7+FDQ4JKMFOumAX8k++qYxMbXA3VKMcLf0gerkEh2+9CXYGSuN7GfIou4P6SvfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646045; c=relaxed/simple;
	bh=4Jo/qbcTGKbIk5+C2JygGt4pjLKoKuVH0z+rpZZlySg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=roOUSxBmZ9RJjcb+mc9XhOL1TxvL/7jTs0qUAkfQYq4Hi2nE3XQeotUXZGwlwLWOQwp4MXj0RHE8IAshbOmDlO8FMuZmLRGIr9jldPD2rXSc0U4EYVswahaC+V/VQCGUW4LWcBDJfatdctSFmcheuQg+PEmi7Xzdi7c1UACTY1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mTDfMo6J; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mTDfMo6J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732646044; x=1764182044;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4Jo/qbcTGKbIk5+C2JygGt4pjLKoKuVH0z+rpZZlySg=;
  b=mTDfMo6J5VIcyI4/m4An9Y+FocfjhuxOh0oOKdWv2UzbG8w4rjLaAFPz
   Dob8v43hApm6IOGLKslK3Ahleolvr/0w4ajlLyKO0MWqLnQ0P+W/zCCxM
   /a0cMWtspPhqSsCekiazgOhp2ZtACPdeSNuIdgGWnvRYQS8+zerMV8C2a
   jqy2DAX8QCgdtUpcVgzxo2wZmww20L22HISyXjwtp2ipdVdcZ404YxZEz
   AeLaFZ7u7IrGKcjccp/RWBgrWKsxMa9lyCJYK05MFqbMbVUhg8V+JYMIz
   99s3zu6m/Cm44EL/Drt3UNSO25VSCgj0HH+2Y45vX+dlX5r5eKRnKqnW4
   g==;
X-CSE-ConnectionGUID: MJfy3U5RSmu40y8iPNACrQ==
X-CSE-MsgGUID: eCZJHID4RpKxkZIER1KOqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11268"; a="32772678"
X-IronPort-AV: E=Sophos;i="6.12,186,1728975600"; 
   d="scan'208";a="32772678"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 10:34:02 -0800
X-CSE-ConnectionGUID: O3/4bJ1VRruqudyhK6qAjA==
X-CSE-MsgGUID: sE/p/d3lQx2MSFHW4MKJgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,186,1728975600"; 
   d="scan'208";a="91801709"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Nov 2024 10:34:02 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 26 Nov 2024 10:34:02 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 26 Nov 2024 10:34:02 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 26 Nov 2024 10:33:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AEpY/7QKPKjNewXuH9I37ufnyXM6apXGVpthbryEsJBLnXiutOi5T1BfM5i5jf1gR9OBFGeJsxBv1xh50Z+tLrNunPFcczQ9laqRUHdAB5wyCajktVFinBw61Npb/Upex6kFMkiHI84PGKxBTTkhZCUSNBnybM5CR+Y/xQurF0vwK63IQLRlq4FlDQfiqJn8695FQ9PkGDiwaehpU0bCPvMK4yPC6HBXNesA+GF1wLPOhBe8v4Dbzn4L35lW7f/Mi1TpI29xmt5jli2zCChe+TdWGI7pALJVeJ9Se5bv6sjZig0gZP3gPztvTEoGGDVkXQZBdLkYGr4iHXg3wP9rKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DilFfjSqW8IF+gQN1awH6NCo4LTUHR5nUSBS0hZq2wI=;
 b=nSCPrt8F1t0808kst2B3kRq4xJ2iLQccu+9/6bKFWg+MoaxBP8ao+MmI3hVfXBO06Kjmq2EjodFOO6Dspq0Hk/gDzfTeBmRzDixjjcLnTs3dEQa3KCIfjiGk3Fmg8LY98hjyhVwx920Ls/RPZTPyySU+c2+FTKaHUZI/lPyMCvB6jo23WFo1QMlQPESFIyrrbk3Wc/7c+7gFCpclVty/Dtd+AKePXjaUbSxT31MZ3dAWsM02YEzbk5K1itRpYesO5UmiLgk/bNmaaSrCVAQOe54ognVOubKAsxNUaVQoOp2q1zDkOyQ/mWy9q6GWCojZ+scJMRpGskqHOAo8RH439g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB5880.namprd11.prod.outlook.com (2603:10b6:510:143::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Tue, 26 Nov
 2024 18:33:23 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8182.018; Tue, 26 Nov 2024
 18:33:23 +0000
Message-ID: <b6258f96-9d8a-489e-a9e3-3dae9ecfe513@intel.com>
Date: Tue, 26 Nov 2024 10:33:18 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 3/8] x86/resctrl: Modify update_mba_bw() to use per
 CTRL_MON group event
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241122235832.27498-1-tony.luck@intel.com>
 <20241122235832.27498-4-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20241122235832.27498-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:303:16d::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB5880:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d167c14-fc0d-4d69-00c4-08dd0e48ceff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SjRXN3B2aVVuRmlNeVIvN2JkYTJxbHRRSTNPR3VibmdXcHhuM3ZqemkyNkFG?=
 =?utf-8?B?MFRZQjdTTG9PVk9jeUxDY1hVUzgxc1Z5aFdjMWlzbmRBQWl0Z3RscTBPRVda?=
 =?utf-8?B?YTlaemtocWlwdnZobUNISDJlWCtWRnRyK0k1dGVid2d2WnFjbk1TSmRLLzg3?=
 =?utf-8?B?d0pyOW1ic0hxZDRNak5ZWmc5dWJhcVlYeUdLRUQzWldUaFVjOXFoMXR3UHJO?=
 =?utf-8?B?aG1WaGZBMGxzcWE1QnpuT3d3UUpCZVZ0NnJRUTh3Z0RKUjFhVDNvY3B6dER3?=
 =?utf-8?B?czVWVm1aMGVkSGtIdlMvMnpvZTkxb3BUbTN3cExjS1BnWjBDNzc2emVhNnVu?=
 =?utf-8?B?dFFPTHl3NjNFZzQzVUMyYi9sT3lGYXIxTmlvWXlEZThNUUpXcVFDOEZUbUky?=
 =?utf-8?B?aWJxODZMMExwMWFodHVkRC9GVURiaWlCOEZnSWpGZWRXQkhDdmpkNTdFam5V?=
 =?utf-8?B?aXR4UWJpeFZoSDZ0T3hzMW1RZkVMOHEyOE9Jc3dESjFxWE4rTFdZWEdDeWg5?=
 =?utf-8?B?UW9obldsUzUwQWd3QzBFS3hzQlFxRlBjdnp5Qi9iWjAvZTVLeXZnY0tWT1hm?=
 =?utf-8?B?aU83RTM1SFI1bWN4SkJzcHZ4eUlBblBSTWtWZzdqU2FvVlNJL2szK2lwZWVN?=
 =?utf-8?B?SkN4S3FqRHNxYUNZUGVCemFZbnoxaHJ1S0VsRGxMMkY1SXBlRFdxUGVqckNk?=
 =?utf-8?B?cjlKSnp2M05pTjlQbVBhRmhDTWwwSHEwV1ArME9KQXNiSXgvSVpsalFMalpG?=
 =?utf-8?B?SnY1UnBZY0Fpbzg0RFRjMTNmcHJJcG8rSzBPYXFuNkZmUFpZb3QrLytoS2ZX?=
 =?utf-8?B?dUtnSWpqeEJJSHVsajIwc253UEZ2L0oyd2xXNFlEYno4WnNNK2pIeXlZRS8y?=
 =?utf-8?B?OTdBVXNIZjdKTlFZMU5YYnAwZFZ2dnNwSEY1SjI4dm90cCtzOTdZelFQSkdY?=
 =?utf-8?B?anl5a0JkcmI1ZzVja2QvM29idmMxVURrNU9RWUV1TWlZM2h5TENvWDE4YkU4?=
 =?utf-8?B?dkwyeEp1Y2hhZ09zRUxIaW1tMkFOZnJFTWxlVlhTN01MeTNNUlpzc29OSFNi?=
 =?utf-8?B?ZDJWNTl0N094K0JHVkIxQTVOekVFLzhzcXk5K0VBYTdmU3VJcTZ0aVhCKzFW?=
 =?utf-8?B?TjFiVEVQRHdsTFRObWxPazcxR2xWZmVucjVpamc0ZktBN3QvMFVKdXVsV0JU?=
 =?utf-8?B?UCtpWTBTbnhZQ0hKY2R6NVNpUkRCdkUxSnRaSkh5QkpEN3lCMzEydDVCR0kz?=
 =?utf-8?B?TklBaDRWaE96M1Q2Q2xWckJNSjB0ajBxRUdVQTh4Zjk4Y2dheW1vUWJCemNz?=
 =?utf-8?B?WG1SSTI0OGkrdVJUVm1TVGVFOVJNb2N6cWplREtOcGFlUGxwVmw3b2Y1eXJ2?=
 =?utf-8?B?eHUvZVd0eXppR2FXNVIyZGlSTklzOGxuSVpOOU9vZW9lOWhXclFMWGFNMTM2?=
 =?utf-8?B?Tk5nNkNWOE12aGNjSmxnZWFxUHpYL2tBYXViVDFyTDRzZEFBV2J1TEdmK0xm?=
 =?utf-8?B?UlJIaElUTEQvc0xTcm5iSzJYYTBLNjZVblhSWXZ0UU9CWVdNdkRIYmYrcDZ6?=
 =?utf-8?B?cENJV2NvSWFLbEtTTDNoN1FzRWdIa3N3aEFBRDF6ZDhtdFppdHd2bWJFcU0y?=
 =?utf-8?B?Y25STjNvMFhMUkV3YStWTWdXM1lYSGpjRndyTW1yaEhpb09OZkhPMXlyTzMx?=
 =?utf-8?B?NGlkTnpTOU5ueEpIUXN4OGVKS1ptNGtlL1o3b0JWSktSUk4wUENqa3RobWdI?=
 =?utf-8?B?Q0g0VTgzVlRBNEg2ZkVYemU4cElUWGwvSDNtSDJGSHZaU0RVNEJubjJtWXdF?=
 =?utf-8?B?a01KcHkxNkc5Q0NWNlcrUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVhNWGtQRVo1d0xKRmx1Z1hBcTJ5c2txa2F6S0NlSXV2c1ExSENtMmkxVDd3?=
 =?utf-8?B?NDVhMUhyM01CTGhTL0puTjdrSG9NaUNsREd0blcyUXRMd1plK3kzQ0Z3VXVB?=
 =?utf-8?B?WGN1ak1YeXEycWRHbVQ2K1M3MEhUeFpGVG5nREg4Q3YxekE4N3UzTXYxMzlK?=
 =?utf-8?B?Q1JOVTJoOEhxeE13c0JBM0JKQ1pSN3htNVdaTXJudVRrYVNiQng2Rzk3U3Zv?=
 =?utf-8?B?WUFqTGIzeGVvb2Z1bnpBS09NVDN6U2JJS1ZENUpuUnMvamRlUFk5ajRjZ3J6?=
 =?utf-8?B?Q2ptK0RnYnpzdklERTlqdng5OFc3Vit3OGFONWhhbWZJczNHY2lFUjQyeHM2?=
 =?utf-8?B?T1FWZnFQZ0hqY1o4b05kQ05Tc1A4QjhmMlB6OGptM3pnZDU3V2wyZ1FhK0xx?=
 =?utf-8?B?dVp2czhSREQvdGhmbzk1K01qZ2prVlRHTlBqYzFOREJ3cnNvOTFVSEJzM2Vi?=
 =?utf-8?B?OUpSZ2dYMmZSTWpvbmM0NXRsN0gxNUpXZExIM2h1UWIrNGdDOTFXQlFkSnE5?=
 =?utf-8?B?aVJEZGMrRWtFUytaZVNVajVHSFlsZnlGRFZneVVVbnNJM3dxQm5hN2d3Q21q?=
 =?utf-8?B?KzJTRnNNNVFFazNUNjBpMHp6bkVPSklWb3ltZEVxVWFRRjNqVTRSV0EzaHVz?=
 =?utf-8?B?a0NKOFF6eHByazVkSnZUZjRUZXk5TXpNN1pkaUZmcUIrc0kzYkhHMzA3VXMw?=
 =?utf-8?B?THdEWGN3Vyt6TmQvVWpNL016NlJ5WitQcDFlRWF3bnc1Q1VqcDdsQTlVdjdw?=
 =?utf-8?B?QWtDYVdJVUlLcjBEUFdROERJc1hsN2xQbXhiaDZ4b3BrK1ppTis1eG83L1Bv?=
 =?utf-8?B?bmRRTThXQmZaVHVrZklCUHFYNE9jQnFjRWRrOVFVL1RhakZNR1BaeDdMTm1V?=
 =?utf-8?B?dFhQU3VjSENFQmk2SEIrNWUxSDlRdDN2YmNrT1lEODNka3hCTE1yOUF5OFRx?=
 =?utf-8?B?YjlIQ1BVWjFUZDgxOVFQOHRlMk05M2NvNXZ5ZnVpUS9BdmdXbElkNzd4aE1W?=
 =?utf-8?B?RUNtV2prbEViZXE5SnhHSHIvbTAvTHFxekJEd0pHb20xTDJMK2RLdGY1T2pz?=
 =?utf-8?B?QzZidGxQbmk1V1pUZ2Z2c2hCbE5SbDFvWHlhVFpZUHVXVTRObnd3dVNyamZ6?=
 =?utf-8?B?RHl4YnlsKzJST2dmUW1tNFRKTXM3eHZLYkpzdjBaOGorbUIxYk9PY0xpRnlE?=
 =?utf-8?B?WXljV2lacmNxejZNMitQNE9Ydm1qbXVxRG93QnBEUTYwSVhvM3M2L05ZZUZu?=
 =?utf-8?B?R0hrL0VWYVdhZ2d0SVg0SFdpTWx5RVQ0YkZDeng3VWtLaFJDcVhiWTY0YU90?=
 =?utf-8?B?WGQ5Tkc3R1RwcFJDa3Z5dXpQVnY1TUJ5MjRPNDdmQVp3aTNUQW90RXo4Zmda?=
 =?utf-8?B?THRtaDRUOG1iYTR6bWI5YlphNVM1bjRoMnlpaHZJTTNUMXZqaVZjNXphQXUw?=
 =?utf-8?B?NzhrS1QxWVVrVGlDTFdnY0NkdExZT0pFdzdSQytCNmRpQU1tOGZ3MzdUcjMr?=
 =?utf-8?B?MnBYYzZ5Qytvb0wzQjZ6VXM1TmdRVDNNUTV0aFZDckRqcncwbTBualU4ZUNC?=
 =?utf-8?B?OW1hWEd6ek81WGMxdlpvU1dVR0RjazMrcHZheVZlNzA0LzdVTkI1VzA3N1VS?=
 =?utf-8?B?bXZqU0RCeGRWcVRkU2Exc0xFM0FGNEZWbmp5elVXWTdxUHkySStpZyswemYy?=
 =?utf-8?B?YVRNMktpSTBsRFZ0ZDkzbTUvOWZoWTBCbHMvNzBQc1J5M3NsSXFnbGVPQk9t?=
 =?utf-8?B?cTJFeURycTZPUVUrajB4Y2xYeUJaSk9kM1o3aHNxUTlOaWxIL2dSc24wbmRX?=
 =?utf-8?B?UGlzVUhld3BxaklUOWd5Y2FDeEJxNXN5dldOUlZ1VkFKRWEvRlhmanY5M3d3?=
 =?utf-8?B?SEpaUjU5eXR2Vmc5MHJaY0VxU3c4Y1ZwSUUxNy9uYnA2Y0gvd0xFSWhZQU5H?=
 =?utf-8?B?QW5FVyt5TnFWdDdzN3RZY0xCRmU3ZkNvanZCd3FOUDJCaFFHT05zSEFQZ1F2?=
 =?utf-8?B?WmRxcGh0OSsrb05rM1pHaTZka2NKazZhYjNlRkFiN0lKaWdPUWlFdVdMODJz?=
 =?utf-8?B?YmlYZEQzNUxuUDkxUEZPNnNzNkU3SkUzUmNFb2pGSGcrWUJlOThBSHU1SXdI?=
 =?utf-8?B?WktZejZabkVoNVV1eUNWb3ZsNEFFRlJaY0hPTnBFcUlnWXVBVXVTeDRoS3Jz?=
 =?utf-8?B?dWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d167c14-fc0d-4d69-00c4-08dd0e48ceff
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2024 18:33:23.1400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8A4ZNadfsBx/XqfFRihXyaQxZpfa9URj4WzPkm+pFF4AqetcGnZYw2lNOEOnfH580iU6tma2JyD+y1UA30gz+uXH30S39q63+pBBBF4h268=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5880
X-OriginatorOrg: intel.com

Hi Tony,

On 11/22/24 3:58 PM, Tony Luck wrote:
> Update_mba_bw() hard codes use of the memory bandwidth local event which

Update_mba_bw() -> update_mba_bw()

> prevents more flexible options from being deployed.
> 
> Change this function to use the event specified in the rdtgroup that is
> being processed.
> 
> Mount time checks for the "mba_MBps" option ensure that local memory
> bandwidth is enabled. So drop the redundant is_mbm_local_enabled() check.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

With typo fixed:
| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
