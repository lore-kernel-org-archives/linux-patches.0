Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D766F14005
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 16:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717778978; cv=fail; b=sjwMSQ3lMu6hmSRPPpTvRAKX0AAnQvm70SFnwwNZs0jcLLrI7FcSQaV7MI/I6rhyWP2CKWPdwzbzf7d2hNap0HoK6S2wVBB8Ua7gBeCSSzO5njuxpOj8vyelfIQssiU3QzB06fjLSjwbyQorntiFrOhgjTBRQShlFAIOXB9Fx5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717778978; c=relaxed/simple;
	bh=5eqaTUEV3/mPIVOF4mOGLGzoSWrfNqTeiy8fvtGSugc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=paqndsSDr1PKX+3D9WRCRS6JJfHlmdfgm8pyxrIhVtPOn708lI4oTazf+CPMiPuq3pGgu9gH0pIMFfvLyVkLT7d2wknD1VdQv7EJKq0tGakMWhMvC4CHnSPDVI3h4n6yvg4vFv+UnQ3USfUgsFvX1qvU8XJN7ROD08awfdp2Qr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CpU3WmQW; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CpU3WmQW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717778977; x=1749314977;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5eqaTUEV3/mPIVOF4mOGLGzoSWrfNqTeiy8fvtGSugc=;
  b=CpU3WmQWj4WUVMXWCBFpsB3rL8KuFQ6oHv1eFKxmWRCFBRRD4Noyn37/
   iC1zZ3R0mjgis3PBXOEUU41xv9i0mYYMxX/xC9M4GFwcS0SqTfKr+E0VE
   r0n4zC78fh+snsZsVgf5l6TsQz1EHcEeDpktoq5hkLYK2vXlIo7A7+K9N
   3FmXdELU/UGOKwu9nPldWMogHqvfH3k1bqiQRAYfcq+Mlq1AB0VIbN/VQ
   i1Cf2I7ciWDFaTJxqTu6HuPqnfgNIdyhzJ5P3nb/gRgaEHyXdRjQcGJpf
   MyIsy8+o95W/d9iGo6exTi6vjfILkiDbtWZEMkxZ3YN48NQSvI5wfpcH7
   w==;
X-CSE-ConnectionGUID: 3jgWywU3QO+ltvEmZKg84Q==
X-CSE-MsgGUID: pPD5j5rEQvWxc2GEkbIycg==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="17435951"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="17435951"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 09:49:37 -0700
X-CSE-ConnectionGUID: L3L5fUabRkCySY+/Q64VQw==
X-CSE-MsgGUID: 7sswOsgqSRm22A7t17Q+Kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="38501538"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jun 2024 09:49:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 09:49:36 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 09:49:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 7 Jun 2024 09:49:35 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 09:49:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hO5sYLvvjpQrbteZqzix97E8RkX3pkhKX1lye7a0jktfmqKSl5vF9UpK/Cr4ikMm9NrzCDJZpghc9hblNAz/XhArthw+nuYgMzXxbpkRlte1xw7iEzDicSWSXF1jkA6Uw/Q01Dmadelth2uWa28pbEKgcK6+PD4W/mLoXqqYb0bG7IY3H+K/uQ0Bb4Qb/cpz7GQs+9KBtxaq2P4E/RD8lAZGujsPmwyEDs4UImvEOnqzlc0WAUUe0rVwnY85H18lRg41idJxQ0n1Ac+4Of6Vb3ecpZaibrx9u3YqQUCH/aUXe4kRIWzBoiW09ayhddGQhA5O94Ndm6rFh3NfZXhWnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ECe/LISG2BwSePpsxqoIqtBBaL05rBONnMSxn3jjNRM=;
 b=NBIES6Ps0C6BQx8CTRQWP39g8+B3UKwuocNsmreYgTVhtKGzRvtag9AKL/qf6tWqcmJb77Q9onAyle++V2C8fP2TcpnsKvhAtkSQ/nw5Zy60qFGxc+vM5sZhmo71vhqfKgDkolhAU14rAtk74Xts+IRwtgcrW0Ewra119I8ODEeoTwwx8WuKySpBrMb21nsd6FT3SqW8OYdB5vnkbrTqAtQPejbfNshsmUdcCGA00QfFq+DAeR04tw7CsiXFP6cSTdv76r4CF+5mOgObLVfA5UqcUIWRx3Z2Lr1vx2JW8qhFwhE5IadT8E8TxxNwBxUCPEGGgg56DA8ExJLrh58JGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6146.namprd11.prod.outlook.com (2603:10b6:208:3ee::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Fri, 7 Jun
 2024 16:49:33 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Fri, 7 Jun 2024
 16:49:33 +0000
Message-ID: <03ab405b-d7e4-4c35-8a3f-546ffd590954@intel.com>
Date: Fri, 7 Jun 2024 09:49:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 16/20] x86/resctrl: Make resctrl_arch_rmid_read()
 handle sum over domains
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-17-tony.luck@intel.com>
 <9818c304-9056-4d79-acbe-2b35cb847ecd@intel.com>
 <Zl5OmVWFpBtA509j@agluck-desk3.sc.intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <Zl5OmVWFpBtA509j@agluck-desk3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0308.namprd04.prod.outlook.com
 (2603:10b6:303:82::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6146:EE_
X-MS-Office365-Filtering-Correlation-Id: 6813b900-73f8-44b1-798f-08dc8711ce7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cHdtb05YTHd1WVlDLytCeVh4R2ZPY0h5emRTY3JtemoybmZOY2hDQXVZS1NO?=
 =?utf-8?B?aUVwSnV1eDJGNXd4aXJPVFNmRklkL3pVMWRuNWRSMUR3b1hwTzNVdzJjS2w0?=
 =?utf-8?B?eTQyNWZIWUROdzVCMnA2WHNBMGJBZVkvUU5HaTQwaEV3WW1tYWxvakRNbHEw?=
 =?utf-8?B?cnFJZ0dnQzA4d0dvbzNuWWNleVROQTlUakl4RHQrREdnTGU0SGNEbWVaSG9m?=
 =?utf-8?B?am5mRXYxd1VTbFBva0U4S3RTdGp0RlFSTlVBK1hrampEdHo2TFNjR1pzSFAy?=
 =?utf-8?B?YkJpbWNzenZMT09hTTcvVVpWc0pCRzE0cU1lQ0p1c2ZZZDZsT3RzWlJIS3k2?=
 =?utf-8?B?N2ZmNml0RlhxZ1dFVHRGVXJqUTZGQXI1dWxDTVpjTnE2RTNnWjlUSkFFUmVV?=
 =?utf-8?B?R1NPeFNWMURlT3RZd2lrblg3TmR3UWlUdUd5dGVDUjdvanVOWlFIbmtRbURM?=
 =?utf-8?B?ZTBMQU9FMXhmMG5sSkdUbmlCMTRJc1pndExqRUFLcVpkUXl1OTNmVUp1eEtq?=
 =?utf-8?B?Q20va29xaUQ4SEJoUVZTM3dRY3NKbFpBVHliQ2dQNnhKa0MycDcvTGVuT01F?=
 =?utf-8?B?S0lHdVpEQm04MWpxY0JQdGJyMjJPK0RtVFI2R3dPTllhWWFnTTFoNCtBNnlt?=
 =?utf-8?B?eVBxenBqZjlTQWYrZ3lFS3BnMW9uZVVGeThrRkVWREpjZFVrMi9HcXY1S1FZ?=
 =?utf-8?B?S0RHczF5VjFzNVEyVzZZZ0xVQ215UTBKUXBhckc0SHVVRzJ0YlRCMmREWUQr?=
 =?utf-8?B?V3pkTHB6SlN4UjVZUHRmRG14Z3pHNk1Id2lYUHNEb09EZHRTU3FWK3dNVTlu?=
 =?utf-8?B?cGlHcm1SdWlHc0NiWjBFUHRheVFoVUdkS3QxQktobEpteHNwSmNYZGUxWU40?=
 =?utf-8?B?YUk0dnpoVkx6aDNDbHUxTW9Uam1aZGFBZlZtditDTDJOazRmV2VuOU81eUdv?=
 =?utf-8?B?SDNtOG90djErYTJoSkZxSHBNQjU1bm5EdUtwQ0txWkw0WE8vTjhUNDhneS9x?=
 =?utf-8?B?U0ZIRlpQVkUxR0tMcUFMTGVUSzltZEtEUElVVmxxQlJjL3U0UVA1c0dvNlV0?=
 =?utf-8?B?QlFpMUNRWnBHVjJxazZwL3I5TEdJR2dYTFZ1c2ZzSkxyaDNEM3pmR0N5MUVY?=
 =?utf-8?B?V3NXc1ZDZTZDdkx5VjRPNXZQbVVoVFpQYXhwY2VDYTQ2cEhteEJGc1c3RmF2?=
 =?utf-8?B?elpSbWZIMWxxUGpCKzZSUmg4OEpkdnExYkNWaDJJQ3dxTUJvM0hQM3h2R0hZ?=
 =?utf-8?B?aWN3eXp1ZEl6UHpRM0kzdHRXa2RVVXBYYS9XME04UTl0WjFtUHBlQkNwL25J?=
 =?utf-8?B?RG04OEx3eHBpaXMxLzh2aEJOT0FwbFZEL2c0Tk10VUpUbitQWGRFdEQrM3hJ?=
 =?utf-8?B?U1RvTTNpNGhXM3VrQjRDVkdrT1Uyem1EZTZUSG1pcDRqQUpGVFhxU00vdEtN?=
 =?utf-8?B?Q24yd0lWWVh5ckZRM2hLYTlDbDBLYUFSVDZHUG5BUkZnN25nL2FNc2FOVFVk?=
 =?utf-8?B?UTljZGZjeFRoQ041dkV0WTNqbUdPQytsOWgrODd1Vm11YTc2b3kyOWRCWVIx?=
 =?utf-8?B?d0N1VTV3a1pKdWkrMHQ1dVlYcnk3T3c0T09mZXVrOUhWZDQwYmlLRW95cGli?=
 =?utf-8?B?TUszWi9lclo2ZGxUSlJmYnprdmdiRlYwZXpmbnBFbzFGRUtuWGhmZUFZaEND?=
 =?utf-8?B?MzYzSGVaTEdFR1BpVmhmdTMyMmVaTzVTd2I3S2NFR1RqQzRpWldRZ0JIMlM1?=
 =?utf-8?Q?2RGOYtrfeebs5TK+Vmkij+2p1Yg9iXAFZgscK52?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0pDRTMwcDVzUFh4bGJnanJlSFZCMmFuaTVMSjNBelNRVVFRcDBoa3Y5VW5Q?=
 =?utf-8?B?VjI3d3dWMG14UnR0UlE2bjJwRFdFN3NMUmhHTjVTZFhnUDdWM3JxZGZhSVA2?=
 =?utf-8?B?WjdmQ0diZVR2SjlXL2pyS3JsMzZKSDJlL2gvQy9LMXNWb1VaLy9YM3poQ3dY?=
 =?utf-8?B?cWxEcHJwTHZFSVllU3czTmhIc0NDUHVUZWp5c0F2WXhJQTMvWnBZWmo0MmVr?=
 =?utf-8?B?MnNjRmFSRys4cjlyQ1VieEozZmpEQ3k3RUF6ZFBQaEpxczNMNGtaSlRtOGtU?=
 =?utf-8?B?SG1SVnlzUXFnWWQyTVdyU2Y0VU84WmM4bkVRc2ZRQlFEWVRoV0dqbFp1RGs3?=
 =?utf-8?B?U1Q3S2VndWpqQmlQZzZQcFFpQW9pbEZXbTU0em1GcGlEVmJ2UXhjWmpJZHRV?=
 =?utf-8?B?V2laTUUwWHdqUWZBdGo0SEVIVU9Qdk9ZcmlRc1J4d3ZXdmNvWEp0RTFRNFdT?=
 =?utf-8?B?OEVXQnJWdks2ZDNwVVE5eEwxdXVmSmJzUVRKUzBTUmFJeXhXK0tyZXdtTlVn?=
 =?utf-8?B?WHpDRjZPQUhlRFoxbmFiSGhaZ2JlMVphWUVidEVyQVR0U0t3K0NlNGhlQmwz?=
 =?utf-8?B?SDFjWkFOM3c1NnBoU3M2QnkyVG95YzZwNHl3dkJyL2xsazBQNHRWMHc4NUNJ?=
 =?utf-8?B?VFZxTFA5VmlkaitXZXlWclBkSW40all3M0dTaFVtZWE3M1BpSS9DUCtOSUlh?=
 =?utf-8?B?NXVOUTZxTFcvb3Jpa0w5SXFTNHVkZ0E3Z21NdTJqVnFqcllQNFJBM2t2dlZu?=
 =?utf-8?B?eW1YYld5OG1YM3ZHdUlmeWJvREJtOTUxS2lhUWVaMjZuVFdCbEltNTdMcDh0?=
 =?utf-8?B?ZTIzSUc1RURoZ01VdldlbTdTUWVnN1d2cXBJcitsYnEvV1BHRHYrQlRjT1pE?=
 =?utf-8?B?UFlwTXkxYjVJTUJiMThweGFCYjRuY3c2YUV1bmxNSFRlM3R2b3hsOUg3eHpm?=
 =?utf-8?B?V3RQdSs1c3c2N3J6ZWltVUJUajBvS3FhQzZXTlNseHpIS296bnU5UGQraCtJ?=
 =?utf-8?B?WTd5RjJrTHcremk4NXRlcEcrbHU4RUgzcU5Gd2FzLzN4NDJiK0ovVHZXQWZt?=
 =?utf-8?B?TmVwVXlhbnBCK3Awai9pNHNLQWpVaDMxcU5WUTdpVzFVVFlUU2FJQXpQcmta?=
 =?utf-8?B?YXNsNlBoaWhXK3VZM1RCTjBOdXd5aHF6RlZHaVZ1SDlwdGUrMDlwS05kN1Ns?=
 =?utf-8?B?TzR3OGNqa0tzZHkxdTQ5UGx4a2pUSnVkblJZR3hSdWhHZEtJVFRPOTlUeGFB?=
 =?utf-8?B?WEVKb2FjSkdud0MzdElJWkcwODNucmxhV29LVXlFaTJKK0ovVDZXaW9hSVkv?=
 =?utf-8?B?QVVvamNhcnZFazMzeTRacTdVYXR6eTZNWTVTZXFTWEhFVWpvcGZhZlNWaHg2?=
 =?utf-8?B?eGFYN2RrUlBGZnZ3a2NaRTFLSzdya0R2a2ZHQlltN2FaQ2JDZ3pzUlpySnhl?=
 =?utf-8?B?NDdWY0VYZGQ4K1RCdUU5WWxFdGQ4RGZpdW9iM2VCYncwZVJodUQ0VXBkMFVo?=
 =?utf-8?B?UXl5RnEzWjRJU043VG82QUhVc1VCdEc4TXdCdHFjWjRmc3hhZ1BSNVgyNDJD?=
 =?utf-8?B?UHpGd1VzRUpIRGhCQU9pTjI2aE5mRldLTEg4RWVKOE1BTWNZSnF0bXY2VlBw?=
 =?utf-8?B?b1JtZko0TjBvQmZvaVFnTElWMkk1ZEpFYWV6OGIyWVZTblQ2MHhQclVJRVFP?=
 =?utf-8?B?VkVyOTdoc3M3Z01HS2JBTjk0Mkc2d1htTkw4SVV6L3BDRjh0ckVPaldrcS9y?=
 =?utf-8?B?c1VLTVFTTzZsUnFVN0loR3BncFpyZFE0dzJTVFpPSnVURmNSNGFMMUR0K3E4?=
 =?utf-8?B?ZVYycW4yVlU4NVplOXRFaFlwdE9RZDRlaVV0ekpxN3N3SnM4dS93NVBrb0Ja?=
 =?utf-8?B?NEprdmtWNDdRZWN2RnBoeDZSKzBkSW1seS9zQnJLa1ZiZ2Y1aUZCdlpnVUF3?=
 =?utf-8?B?RXRSZHRhd2VjeWMvTEprL2Q2Y1lvOTZhYk9hNWwwTkpNYlBtT0RFeUluZ0Jh?=
 =?utf-8?B?RmU5ZW9SRmNIVzM3eWI3dHB4RXRJYXBTck9UMmd0djA5MFdJMDNnTFowN2hu?=
 =?utf-8?B?dzFrL0NKVFd5RXRNQ0JGWHNiVSt1SWpDTVNObE9EUStpZ293Y3R5dmNLdndK?=
 =?utf-8?B?Z2FSUXpaTkd4czhBQ3NBaWdkZG1nTHdaNldQV3JRQUxhMnFmcDdKNjVZZTQ1?=
 =?utf-8?B?K1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6813b900-73f8-44b1-798f-08dc8711ce7f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2024 16:49:32.9612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uNZ7NdjZRyK0G19sPMwhrN2+ehT2qZiT9fOHOVNsW4P53njARHgUeOJumC8PIEWKV1zwZ3sQAwTOH1dUVdir635oWL8L2PaUsqsfU0xskro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6146
X-OriginatorOrg: intel.com

Hi Tony,

On 6/3/24 4:15 PM, Tony Luck wrote:
> On Thu, May 30, 2024 at 01:24:57PM -0700, Reinette Chatre wrote:
>> On 5/28/24 3:20 PM, Tony Luck wrote:
...

>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
>>> +			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
>>> +			   u64 *val, bool sum, struct cacheinfo *ci, void *ignored)
>>
>> This is not architecture specific code.
> 
> Can you explain further? I've dropped the "sum" argument. As you pointed
> out elsewhere this can be inferred from "d == NULL".  But I do need the
> cacheinfo information in resctrl_arch_rmid_read() to:
> 1) determine which domains to sum (those that match ci->id).
> 2) sanity check code is executing on a CPU in ci->shared_cpu_map.
> 

"resctrl_arch_*" is the prefix of functions needed to be implemented
by every architecture. As I understand there is nothing architecture
specific about what this function does and every architecture's function
would thus end up looking identical. I expected the cacheinfo
information to be available from all architectures. If this is not
the case then it does not belong in struct rdt_mon_domain but should
instead be moved to struct rdt_hw_mon_domain ... but since cacheinfo
has already made its way into the filesystem code it is not clear
to me how you envision the arch/fs split.

Reinette

