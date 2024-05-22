Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E277E146D44
	for <patches@lists.linux.dev>; Wed, 22 May 2024 21:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716412090; cv=fail; b=bDtUBCo/CcsHMuJ/5rDjLPe2qyg2U9/jc6e2nwiWxuRTXDcMQxg5b3AZ5TBtyatmuFx4ri4cabWN0Npbe+Qq/DMLhOLTIgAVz4+9Hc5dpch44sd9K1kni5gRiVmoKNqx7FjD5JXRJeHmfEJ6nkKMmm8P6m2/SaTlgfcok86Kme0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716412090; c=relaxed/simple;
	bh=idGFz/OJqo+LT2qdwq3P5lB1AOsXwnJ8ZOCiNUkNpzU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OMoAFqOqMMxW6QTPtTZ+Tx3JN2+3UQnjg4YOMZUyILWKVlw/Y3ERxVCgHi1VDvWcNQxTCGTvQfgzKBxxTbxs9jsfzRATTsDKbOu9a2E3mqf3OeDt/TwKLVcUzwOlUeFuN8wtU5KzXUWKMAr2t71J21p4yIqxhOvuW8BmCX9M90s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kUrSZGKE; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kUrSZGKE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716412088; x=1747948088;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=idGFz/OJqo+LT2qdwq3P5lB1AOsXwnJ8ZOCiNUkNpzU=;
  b=kUrSZGKEi0aXnA9+xCC2UhlQhzGWTBp2CkNxHZsX1kgFHWzx7c8NMJYy
   UpdlilnES/1jvUvK0nNSBVM0uAuOwH2GboUfYs2SxNdAJ8BGSp4vKtqpr
   iezytqEfbSHnJSOxKJMxQvqXO/ShZ8mirxUColpYXeyFNYl3qNykcsPG8
   /zuOw3h7PW0vFV/Dmfw8sIR+5UX2sCHAGBVuZVVRnfR3Ntzyf0ZXNmxp6
   y0dMsYxZ74i7NtstdAkDMHESNguqCRhvlYlv743u0ByxsIyDnc8Y7JX7y
   DOiIQ7as3TefoMwvhwWJpQZTSvaBsHJL43n82WIiP/xnHOKX8QiD7qEj4
   g==;
X-CSE-ConnectionGUID: 6WuIR36fQtC7ecOkuEzYvg==
X-CSE-MsgGUID: w1NuoULZRCKa4fhcTBmUIg==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12809538"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="12809538"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 14:08:07 -0700
X-CSE-ConnectionGUID: jQBOYDp/SvWWGt2NnVjCMA==
X-CSE-MsgGUID: 9Cqv4oN3Rk6KuHzNekW1jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33267952"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 14:08:07 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:08:06 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 14:08:06 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 14:08:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeW/RTWdyh5aFj+3u94DQWnazU+iDW2vqeuhlceWv4WMmretnYTDwF8eza72YJBO1VpcmnDpZHyJkINhi1cc2t2jt275+vARgc5iSOfIKCsVGA945iJxdnBx27Ix4+eGmNKCIp0+OGBZ+fzv6DEJHd+hH2MEkXL0dyyv47iUAXbwVbPZvm61jtckKW3CcrBXbSGBWeOQburXobnRX/4DnMBuVc4LCf9LvqkMbuzXmrdphVKe21OllaRVXBgVotf1u59YDjJFevjfEhQedk2sE6gfWKYC/D0Bba/kCASd4P56SeS3ge4El9VvCJ0gsrUEd5lrsjKyvYPUbNgUt9hvQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hIFi6bQwqvDgE+kRnk9JnlxMJixhppIyZpCPoXta9S4=;
 b=aPrGWKlO9Dga1qs8BdWcdJhMjCCqbmkIaDf0P7JSJIof3zhdT28CxraVMFJslxaAFDwjxxtT2sLdMCxhXe19nRgJLDgBRPT8yg2MVhh6/WL+OjRUvkY5VdkRmqSyvGmjm4Iml9pm+FRYQeDQ2k0oNpWXNfz2aSH5Bnwqfg+d7MI8le1oCWhjTB8eNUm0IgdGPnqxwpvgpToppupUEDjuoXqE18A7QeqV4i8a6+6uhJhQR8HD9vLp/0GN+T1vDX642QjcSPW1DHA9OqNye68RQ6ZX96wymilxfNrJkSY1lf8k5b2AxCNSi3zL9W5OWi0wRMPthQ2HJiziAeHybMN21A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM6PR11MB4753.namprd11.prod.outlook.com (2603:10b6:5:2ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Wed, 22 May
 2024 21:08:04 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 21:08:04 +0000
Message-ID: <beee3369-0075-462e-8449-88fee807463e@intel.com>
Date: Wed, 22 May 2024 14:08:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 06/17] x86/resctrl: Introduce snc_nodes_per_l3_cache
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-7-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240515222326.74166-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:303:2b::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM6PR11MB4753:EE_
X-MS-Office365-Filtering-Correlation-Id: 69b3154d-4f05-43a2-c77f-08dc7aa3454e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bk1aUkdTN1pvaTA5K21obGNmUHpwYXo2bUk0Qlp4VEZiOWVnK3hjVkZGaXh2?=
 =?utf-8?B?dGd0dFNNTEluZCtORHE2ZDF2RHJ1ZW1EWThrLzh0alZlV1ZGaEZickgxVmxm?=
 =?utf-8?B?RmhocVNtVkpaUG1lV01sNFpTbHRreHNqTWJKV01GQW9La2phTG95dFh5QWZm?=
 =?utf-8?B?Y3F6OHNoaVVTY2ZCK0ZDRmd3MEZLbDdTeEFJSmFkNU9vTisrQjk0VFNQbnBV?=
 =?utf-8?B?eWhsK2NNUStmY1crcTc2eVRuUDZCQTdXUk5lbkxlRnlQVzhHZjVVREdxN0xj?=
 =?utf-8?B?TXhyaERsYkdHWmIzOWhDZldJTmJuNDgxcjhRWFd3MXVLZm9aUkhCNEcxR241?=
 =?utf-8?B?NjBSMjdXVldhS0FHR0hOVWpFeXY4WHlZV0tTbHdmMUVvaGRxc0d5U0ZxOWQv?=
 =?utf-8?B?QlBHZ2plQWE2cTFSUS9vTi8rWjBJc2NqSE5YMUNIdi9iV0FiMUJkbFlLdnpC?=
 =?utf-8?B?NVJDK0pnTXUrUytoNkZkQklvaXdUSVI1YUdsdzhYL3JHU1YwZW1HdHFnbWdv?=
 =?utf-8?B?bmMrcEw3ZGR1WDM0SjFPcTBqTVExVXFaTnA0UlNWQ24rRm4yNHJsK0Zjb0J5?=
 =?utf-8?B?ZGpnZG1COEVQM0lXTm9MUDVINThXWTNUS2k3TWc1cVltR1VNUCtXYkdpZHlm?=
 =?utf-8?B?NW9POEFRUVpZZU05dlRxVWdOUG5TbzJwVnZidlU4TERUSm15T0M3RzFXdFBE?=
 =?utf-8?B?SllpQXA5YUhNbkpUVVgxR0VNWEI2NVB1a25OY2QzbzhWb0IzNldBQzJubkJY?=
 =?utf-8?B?VVdBYUZMKzZoR0l5YnhLbGxxZTlQUzNjOWVYNWRpU2JIeUZPaHNzdU9tK2Jq?=
 =?utf-8?B?elhCWStWTWh4NUVIWFZzd09qeis5MWFieVYrUTYvcjY4RWlkZTRsZUx5dEo1?=
 =?utf-8?B?M1JjWGpPczY2SmJNbEJxa0hsUmh0UUhPUFk5NFQyNnpjY0dtUjg1bXBaTVVE?=
 =?utf-8?B?R1NNNlhtRmpaZ3NXVlRpeEEwN3Q4NithSWdhWitSTlM1OTNKTW1qbklmM3VQ?=
 =?utf-8?B?UXp1VkIvcUY0YXB1NW5SM2JLaXhTWFh6TXZDcDZGbkJKRk1RMUFNRTdaS0FT?=
 =?utf-8?B?R0kyT1lBRTUwZ1p2TmRmM0cycWxqVjNYcVRtL2NEaHprSGJoSUpEYkxTM3lm?=
 =?utf-8?B?K21WTERvekZ0V0V1aVllVjhaNHQ5YWwveC8yYjVPdDJxRTBEQmpsaklqQk5C?=
 =?utf-8?B?bDRpclFuSkt4ZEZMUk1RaXUySUVwbERoc3lMYVRIdEJsM0VaYVBybGtVbWVN?=
 =?utf-8?B?VUZMbVliZ1JHSVNrclVNdU1nVHVwYmZrZU56aEtWR0NCMGpYSHhwNU5od3Ny?=
 =?utf-8?B?WVhXQmVjbjBkWTM5Qm53MmRpVmV0ZHFwYnpFVDFieTFTU240THJzaWVGTjI5?=
 =?utf-8?B?elJBTlFZckdIMDhkYXFEcDlOb0FrQjZKZkVBdVo1UDJLYWVidjJQdWd6b3py?=
 =?utf-8?B?YnVkME5oY1pMNjBPczRVSU1QdW0xbldPZVFhNkkzQnRCa2lJajRsYmxUNi9E?=
 =?utf-8?B?bW00Z3FIL1RtSjFNN2tOVExYbGUwcExaSWlpUDJjZWlsR0E1aWpEYmJsdkMx?=
 =?utf-8?B?Q2Z2ZVdQN1Bvd2RRREtrL0Zuc3UyczRrM0Uwc1lYbjRnYWtoMWl5M0VZUXJB?=
 =?utf-8?B?WmlpWTJkRGluRllqdTRpRk5JNjB4QXRLczBlUVptblVWczJacTNsbmNkTkl2?=
 =?utf-8?B?ancxVVY0VFRaMjJhaTlWbEJabEJNSk1LR3dvTXZRc1JkVmgwSmtrTlZBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWFwL2lvMHFyYUN4YnVCMHlZaTlEUVBSdGJBbFJkT2RJcFFqMHhhd3ZUT2Nn?=
 =?utf-8?B?N21aK01KSW1DTTVMaFFBUUJjZC9EV3RWWFZiN2NNRHJON1BNekdYMnVrSHlU?=
 =?utf-8?B?dHJ4OW1oMEU1MzNUNVhzTjhidmExVzRNc2hvMTdHYmR2eGw5blo5QVo5T3Vl?=
 =?utf-8?B?Q1pWOUNsVlQzeTVWWHVNUDVBSTZzQ1ZyL2hjWm9PeU0rSGpGckt2amI1SzJQ?=
 =?utf-8?B?dE1qd1ROeDNjdmFodVBVdGdZbXJ6NVpUOTBJOWt0WHJqc3lpV1BRZXNKcjBB?=
 =?utf-8?B?NHhtcS9LdExmNkNqemdZdkJCQmRJaGl1aS81WnBaVG5GemQ1cmxlWGpJWDlm?=
 =?utf-8?B?MmNocTRNaVFNblg1MExCQmhEL003YjF0QTFnZWFjUHgxS0wzWHdTd0dQWnF0?=
 =?utf-8?B?aXc2V2pMQXVSanNoNFdPamJvN1p1ZmdhOCtHTUl6eUZrQVdzZTB3VUJiTnA1?=
 =?utf-8?B?d1U4bTlLT0MxSWRLU0ZUZE1RZlZ3a29vYTVud0pBMWtpVnNQTE1MVUJPUlZ2?=
 =?utf-8?B?UGdvUHlQUlVuOVFPUlh3NGtybS83MU9wcDQ4QytIamVmSW1wUVl4bWdjTHhO?=
 =?utf-8?B?QkxTZkhTdFdROWxNUGlUKzZnMUNRcXFiajdDTnhkR25UcTNjd3o0aCtJaG93?=
 =?utf-8?B?Z3dpL3VhaHRBYmJZbGQwUWJCT0lkRkFFbzdvY0JaQUJJc2xMTlRzeFZyK25T?=
 =?utf-8?B?M0pvUHF3SHJhQlFKTjlnUEVET2lBRU1mbkZpUEtXeWJHUVZjVU9rUHZOY0xL?=
 =?utf-8?B?YXpRTVNPbEx2SVR2bUdrbUZNbGRId1BtcWZKVXR6bEh5c0dmOGg2VDhvNFNS?=
 =?utf-8?B?d1ArdDM3cVI0ZXNEMlRqbWZCTExvUWpKaXVQaXh2S1hzSHhVdndVcTFQLzRy?=
 =?utf-8?B?ZmR4cXc2RHFFUFNyYWNNbDRidmJQSlpPWUoyUUdqS2wwNjFRT0hWRE5rbTI4?=
 =?utf-8?B?c0FKWnNDWStIOHJUQ2hyQ1BOZzRIeDFKTjYrOEt6aUU3U05GSnMxaitzaTBS?=
 =?utf-8?B?Y25SRzlYdVFBQ0NoWkJ6Q2g4RGhqMzYvZkp6dm9kSGV1UGxVMVJSdjIzZWFH?=
 =?utf-8?B?QWlTUEZUaFFLaTdvVVNwcS9hTDRLYnN5VUdqRVIzcVdnY0lFL2MvbkhWYzhC?=
 =?utf-8?B?R2ZFU25XVTFjU3lCZlpqQ1lROGh1b0FScVc1N1ZsUVlFOGFCam5mM1dCQ3di?=
 =?utf-8?B?dnh2UjhZQWhuTVdkZ2NkeHBWaHNDYm11OEJ6UVFjR2haVlh4SjZDbTVWQnBV?=
 =?utf-8?B?bWw5dVA3Nit0V2dqM3Y1MGpoOHVyWnlqcU9VNTFTamtLUzJpQUtNelZickho?=
 =?utf-8?B?RUF0Q3d6bVhOQ1IvKzN6Qno0M2lVbmtTblhwdHBhRTRRNmNLUWVNYzVDY2dS?=
 =?utf-8?B?Ly9Dc0ZVOVJUME1vUDgrUUFLRE5aR1VDbXZVcyswclRqcjk3L1ZOWHEyT3FU?=
 =?utf-8?B?SlZBbEdkbENiMmRMQkd3UWhCYXRhbFRUbDQ5MDNjMTliaU02eVVJbnUxQ0Fh?=
 =?utf-8?B?M3h3Tkt4c1dUMUc3R2xIVUU1ZDdHUGdyYWRhS2hmSHFld3hnMi8raWF5T1Ro?=
 =?utf-8?B?dkMzZWt1Y2ZkZHF3eS9vMUlWQ3Rhbk5QRW1nSU1kYWFxY3MzdTlQa2xUaEVZ?=
 =?utf-8?B?eXhSejMvYkR1QzNYclpzUGtFTEI5Qkp2emtZSXdDV2g4SEVDb2Q1QkFIa1VC?=
 =?utf-8?B?djBEaSs1THBYcDExL0Z4ZHRrMG01eURVWUU0MVJ5RDN6NS9RVDlpNEdONlZ2?=
 =?utf-8?B?aEgrZXBQWnRGVDVEa3JCMzFKa0JpTGxNdGFkTFcyNjh2NzI5ZndEbDdvamlu?=
 =?utf-8?B?K0tGcUxXRzFkdUl4eHNpQWg4M1lKT2RGYkVVU2hJWWdySDJ3RlRHU2VCdWZ1?=
 =?utf-8?B?ZHBySEpkamJQVDVBU3doN0Y4RFRBZ3MvRkFmUmg0VUNrUnVrbmllcW0xSkdE?=
 =?utf-8?B?V1d5S29OS1V2a0UwRFFvYmtFWWxPaHRDQnVvSXk5b3UxRDRqUXp0SkZ1Q1I4?=
 =?utf-8?B?cXJ4eXNCTmNtUXp2aTJXdVRzbWpDNHJPRnFBNjdXVStpckR0aDdFa2Jzbjg4?=
 =?utf-8?B?VXFjQ2hIMVpxL0Jnai9Oaml4RWp6QS8vclRoSHVHOS9WZGlmN250VnpJcits?=
 =?utf-8?B?N3FRY1o3ZXN6QzVvSmQ0MFJBdjFMMUZqdzBRV2s1Z2FGSXhUcm1HcW53dHpx?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 69b3154d-4f05-43a2-c77f-08dc7aa3454e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 21:08:04.2596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TmfmRhpLZB1nJ0dUETJk40RDaT9KS0bvWU/xhchjrYBZgfydSWTh54qPohpFeP0PtOvXLw7eoOTUX+WCv+ZuHIK91nmevHkqpv0IdT5Z8DM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4753
X-OriginatorOrg: intel.com

Hi Tony,

On 5/15/2024 3:23 PM, Tony Luck wrote:
> Intel Sub-NUMA Cluster (SNC) is a feature that subdivides the CPU cores
> and memory controllers on a socket into two or more groups. These are
> presented to the operating system as NUMA nodes.
> 
> This may enable some workloads to have slightly lower latency to memory
> as the memory controller(s) in an SNC node are electrically closer to the
> CPU cores on that SNC node. This cost may be offset by lower bandwidth
> since the memory accesses for each core can only be interleaved between
> the memory controllers on the same SNC node.
> 
> Resctrl monitoring on an Intel system depends upon attaching RMIDs to tasks
> to track L3 cache occupancy and memory bandwidth. There is an MSR that
> controls how the RMIDs are shared between SNC nodes.
> 
> The default mode divides them numerically. E.g. when there are two SNC
> nodes on a socket the lower number half of the RMIDs are given to the
> first node, the remainder to the second node. This would be difficult
> to use with the Linux resctrl interface as specific RMID values assigned
> to resctrl groups are not visible to users.
> 
> The other mode divides the RMIDs and renumbers the ones on the second
> SNC node to start from zero.
> 
> Even with this renumbering SNC mode requires several changes in resctrl
> behavior for correct operation.
> 
> Add a global integer "snc_nodes_per_l3_cache" that shows how many
> SNC nodes share each L3 cache. When "snc_nodes_per_l3_cache" is "1",
> SNC mode is either not implemented, or not enabled.
> 
> Update all places to take appropriate action when SNC mode is enabled:
> 1) The number of logical RMIDs per L3 cache available for use is the
>    number of physical RMIDs divided by the number of SNC nodes.

Should it then perhaps be "number of logical RMIDs per SNC node"?
The way this feature is introduced makes it hard to understand how
RMIDs are used when SNC is enabled since the implementation appears
to distinguish between (a) RMIDs assigned to monitor group and written
to PQR register and (b) RMIDs for which the event counters are read.
The former ((a)) is used directly after the adjustment described in (1) but
the latter needs an adjustment that I did not notice being mentioned.

I think it will help to move the get_node_rmid() helper that is
introduced later here and explain why it is needed.

> 2) Likewise the "mon_scale" value must be divided by the number of SNC
>    nodes.
> 3) Disable the "-o mba_MBps" mount option in SNC mode
>    because the monitoring is being done per SNC node, while the
>    bandwidth allocation is still done at the L3 cache scope.
>    Trying to use this feedback loop might result in contradictory
>    changes to the throttling level coming from each of the SNC
>    node bandwidth measurements.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h | 2 ++
>  arch/x86/kernel/cpu/resctrl/core.c     | 6 ++++++
>  arch/x86/kernel/cpu/resctrl/monitor.c  | 4 ++--
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c | 3 ++-
>  4 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 135190e0711c..49440f194253 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -484,6 +484,8 @@ extern struct rdt_hw_resource rdt_resources_all[];
>  extern struct rdtgroup rdtgroup_default;
>  extern struct dentry *debugfs_resctrl;
>  
> +extern unsigned int snc_nodes_per_l3_cache;
> +
>  enum resctrl_res_level {
>  	RDT_RESOURCE_L3,
>  	RDT_RESOURCE_L2,
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 395bac851f6e..bfa9d3a429fd 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -331,6 +331,12 @@ static u32 delay_bw_map(unsigned long bw, struct rdt_resource *r)
>  	return r->default_ctrl;
>  }
>  
> +/*
> + * Number of SNC nodes that share each L3 cache.  Default is 1 for
> + * systems that do not support SNC, or have SNC disabled.
> + */
> +unsigned int snc_nodes_per_l3_cache = 1;
> +
>  static void mba_wrmsr_intel(struct msr_param *m)
>  {
>  	struct rdt_hw_ctrl_domain *hw_dom = resctrl_to_arch_ctrl_dom(m->dom);
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 89d7e6fcbaa1..0f66825a1ac9 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -1022,8 +1022,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>  	int ret;
>  
>  	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
> -	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale;
> -	r->num_rmid = boot_cpu_data.x86_cache_max_rmid + 1;
> +	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
> +	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
>  	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
>  
>  	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index cc31ede1a1e7..0923492a8bd0 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -2346,7 +2346,8 @@ static bool supports_mba_mbps(void)
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
>  
>  	return (is_mbm_local_enabled() &&
> -		r->alloc_capable && is_mba_linear());
> +		r->alloc_capable && is_mba_linear() &&
> +		snc_nodes_per_l3_cache == 1);
>  }
>  
>  /*

Since the software controller is a filesystem feature the above
now requires that snc_nodes_per_l3_cache becomes part of the resctrl
filesystem code and every architecture will need to set snc_nodes_per_l3_cache.
Every architecture will thus need to interpret what "SNC" means for them
using the term introduced here. That may be ok ... but the term "SNC"
will then surely not identify an Intel feature and Intel needs to be ok
that any architecture calls their "similar to SNC but not quite identical"
"SNC".

I assume now that as part of the fs/arch split there needs to be
a new helper that allows different architectures to set this
filesystem variable?

Reinette
