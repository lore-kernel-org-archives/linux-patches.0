Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE6B2E8B66
	for <patches@lists.linux.dev>; Thu, 30 Oct 2025 16:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761841112; cv=fail; b=FSCfBM8DAoaLaW6LfvQMPkeFZ1kNUQwIcp0/rn0gl0aSY7BDTKfiD9Wq2yaFptgzSxmA0LVpMH4DNi582A/h7NCG9BavWgJY+mBPSFsK/zPmLxzezMDIz3BKjpbS/2WYblFcIJkBEmRhBtsOF9nPMlqaFm64IqHdEgcrWRpySVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761841112; c=relaxed/simple;
	bh=Kxgd1h9hQFVxRauXW19h7EIxufCopCCMXoh0rKAGCL8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q7eptHr8/6o8xJEsFnqOg/S2RQNclwjA4qOY2gygeroGkpN5uG0/DPWWjFjtz9b/gTf8MbloV6WLKgaJv8AFGB43dnNRj+o3wuiJY0kwHu6IOj7Hxw0oKZf8pj7FclQMo4vKGamEeffi6pP2CDrVM3Iv/fAcJ94ZcCsrNiICKYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K/NTrqAw; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K/NTrqAw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761841111; x=1793377111;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Kxgd1h9hQFVxRauXW19h7EIxufCopCCMXoh0rKAGCL8=;
  b=K/NTrqAw5VY/jeFPAQ6uuU3My7hO7V1Cb983zW3Dg0qTlZzCIqR/AHVP
   mJ5td807yvoFufVwM3ugIdj2VuMgXmxxxtQjusDAYa2ahWYZE+TCOrkrf
   CzWyStcEZwdI+qscA4sY3BYTBfLliLKp0I7e/DOMVqyGeTbQKUWW1yQnR
   LKbdWXoawJQl06OZZ7mL6HwCi22jrlvt84Pk9PFb1i9gHSNQRDzGtoNdu
   T3tPwtQSv65LzmWyulGm/YApyMTdeK16ZgOMd7wYnmZH9I0BFbYwQGGhi
   NvueQuc3z3/bqVW2bbX8KdoNUrLv4mZpxxCxHY+k37VOLorao3uQW/deR
   Q==;
X-CSE-ConnectionGUID: fIbBI5UZSwi5c6/j1A2/7g==
X-CSE-MsgGUID: 84FygA5eTf+oCjDPh2/kCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="63688971"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="63688971"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 09:18:30 -0700
X-CSE-ConnectionGUID: PdgLFw95RpKqwib1Wqy2sQ==
X-CSE-MsgGUID: WYjskcvbQoWZZreycjooKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="185687055"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 09:18:30 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 09:18:29 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 30 Oct 2025 09:18:29 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.49) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 09:18:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cbm3VvbT3N4Cqul14nHSDEj3DJ8u2HoHH5/JoLzptBBX+PeQ+d6IaWuR0LeXxWcFIRowmj3kliPxoXmuL/HznHSd8eRaFN0DsUWOsnqkXXr3TV9F1gp8D876Ubsxb2GhF//AlX7w5WCbjXeT6DzDzihz7oK6/zrFV8cs7/l12QYeHc71BWM66pfSH4iiLZO5F+I5D/NSswoK5+wVz8d2fhPxAGZfw2Mblg8Vxm0LMQfnP+SULqYM59OCu3EYyQQmmOkEix+uB908be/SxEZN1uCJy1jnLfwb8vzhYF30OmnbUs5wSZqo7EqOvFeiqegranqgKPzbrms0tRdD8cRSGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9BA7makkwAkTCSqRXbgnKTYoJzV9OBHwNqtK71jkuXk=;
 b=udpgPaeK9krT601paarNO8CBZpij0Kq0NcKklGCTVEBeMfkkFk5CwQaxkitib4DUlu3VVSDO+UicfpQm7FtA+dxucydyjElkl+iDilYWHsDXv0jeFFkz3BTtkMbrmvXo8336Sdb5EqpkbR8+59n81eFReBqA9+XJGbht824PJiN9h/VuPl+Q5EVUBlQj8uOF6NaOwtuEZ1HIYpWdC0r4erUjX/KDHBJVuQbspsvOZHc4mnTATddVBGLiivX+4iWd/8qrBXUn5pRPksZsqKSZvA8X3Pyu8xl0SLx+p3e6IOtk1IhhC9oLGrP+DaNNCGnO0/8UT2YZyog0onqbgpCHTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 CH3PR11MB8702.namprd11.prod.outlook.com (2603:10b6:610:1cb::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.14; Thu, 30 Oct 2025 16:18:24 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce%5]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 16:18:23 +0000
Message-ID: <4c59a9c8-fd85-490a-858a-15c24f79eaea@intel.com>
Date: Fri, 31 Oct 2025 00:18:13 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 11/32] x86,fs/resctrl: Handle events that can be read
 from any CPU
To: "Luck, Tony" <tony.luck@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, Reinette Chatre <reinette.chatre@intel.com>,
	"James Morse" <james.morse@arm.com>, Fenghua Yu <fenghuay@nvidia.com>, Dave
 Martin <Dave.Martin@arm.com>, Peter Newman <peternewman@google.com>, Babu
 Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-12-tony.luck@intel.com>
 <83f2ae55-46e1-480b-a218-7be679542908@intel.com>
 <aQOKJX13sIWhDVJ4@agluck-desk3>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <aQOKJX13sIWhDVJ4@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KU2P306CA0027.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3b::13) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|CH3PR11MB8702:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bf148ff-9863-4a58-772d-08de17cff307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VGNvWjJHOURJblYzWStDVTZ4bWE4KzdoSkM5U25Pd05NUDZiTEpsR1NIOHho?=
 =?utf-8?B?US9ZN2MzV0JYQlkxd3k0ZUNSaUtNVWxreC9zUWNWN0FhdERDUW55OE1OWVg3?=
 =?utf-8?B?U0wxUDRka0ZpTE1jWnRsOW5kckNyb1VYV1ZkWEcvaDd4RFJ0N1F1ZXVXMjhV?=
 =?utf-8?B?bENFWHlmY2IyQUw3anpFekhLdXg1UVV0QVRCT3ZKd2tkZlJ4RUl0dFkzN2Jm?=
 =?utf-8?B?NWJ0SDZuSkpRMzFYZFJxd1o0SkUrc3A1d0JwNFdPTG5rRWdCN240UE9obWxx?=
 =?utf-8?B?bk5zblQyOEhJRXlZeDNXelVJcEtmZmR5T1AvM3lGYUpHN0ZMN28zMVcvSlVI?=
 =?utf-8?B?b1J3Sjh2eXZIQlJVWExuVTJic0hsZTEyYmNYekdTQ0FxaThSMlkzc0p5V2oy?=
 =?utf-8?B?NzNqZ0ptdjZOMU92ZkdocUZjdC9KYlkvTU1yTTVRbjFOREpMSUhEdmZUTHBF?=
 =?utf-8?B?R1pnOWFkZFBsLzFma0ltZGlKdjFPRUxTdDlRVGVUYnlucDZaZ0N3RDc2czJi?=
 =?utf-8?B?TUhzZGNVTXlQSmgrV0h3WExlU2c3ZXJ3WTQzd0x4T2g1VWUvL01ycjRmbEYw?=
 =?utf-8?B?NUNJcGtrN1RPeU4zUkQ3NlF0Q21mclJtb0VkSS9nZ2FjNkpnckkwT1YxVnlp?=
 =?utf-8?B?UVJianFrak5xZDBqd3kzVitqdCtSL3ZiYWlmNmtsVkMyTkJLK1NTMkYzMU5p?=
 =?utf-8?B?OE1teVlPWGw1SHQ1dks5Qk1hWmpTdXVvVTB1VzRnMFc1T2w1aXcxRFJoemhv?=
 =?utf-8?B?Um15YVFaRlVXUEg4S1hyZnZSRFpUVmJUODN3REQ4WGU5V3JKWnFKaktoVlRU?=
 =?utf-8?B?TSt0MU9NOEpwRyt3azcxZU1YWDVOK1hFZFZibVBsZmpKWjd2c3hYQThNTW9h?=
 =?utf-8?B?bmUraTA3YWcwc3NBODAyM2p2cks2OFZ4T2NFSitXUWN5bDdKVHM5WHdtVHVj?=
 =?utf-8?B?WVlqRFdQQ09UZWxtTlMvL3R2dlF1YnZVaHF2emhGVHJ0R1JaclFVOUVYQ3pT?=
 =?utf-8?B?MGJ4dCt0Z2M3VTcxdTQ0UENpUTZYcXRJbUgvVXR0VzJMWXcwUlRjdXpwQnZw?=
 =?utf-8?B?TmZLaHBiVFJCR055d3R5UXpuN2JpSU1uakdOYlRlOVhZb2kxOXkyZXh6eGpz?=
 =?utf-8?B?MUJBZjlscGEyRlVZajhBOWxUWHd1NWNoR1dGazZmVUp4aUdHUmd3QmFYVlBX?=
 =?utf-8?B?dHA2MEJoKytJelhoL05KOHI4SUpua3NPZmZZb2JJUjRTU09VMTU2bUxicVFi?=
 =?utf-8?B?SDBVaVFBcGVpVWhnM0xEV2JiRVV1QmNlTzQ0aWIwemtYb2pHUXM2RVl3TDVV?=
 =?utf-8?B?MjQwSkVRSFlpVlc0a2xaV05XWEZpN2lPb1d0M3BxQUxlam5Ydy9zaXZCTm1Y?=
 =?utf-8?B?dnhUblNyZG1UWVpOUkk1VmZZeGl3S0diUUNQQWJqbFlNL041SCszNGs4Y0hR?=
 =?utf-8?B?Tys0RFM4ZlE1Zk5pSXJqT09YT1ZOeTBBNlNsVVNGV3hUMnloWE1Ea0JZcVFR?=
 =?utf-8?B?dFBDcTZudk1lRXRYVTJYb01obzVoZTNRU21jZ25SN2l5T0dldzJGVzV6Q2hW?=
 =?utf-8?B?UGlnZUFHN2xnZVVUcEU0TjI2N3ZzT2Z1TWlNL1FoYkg0YTNiVDJZS01XVGQv?=
 =?utf-8?B?ZHVPWmhSMWx6YitENUlGeDNLcW1CcTIxUzlwdTVwa1N0NThObWtHSVUwamxR?=
 =?utf-8?B?MzFHZWczbVBmMWQ3T2I1bmk3VGlIR2I5a2dycFd5eVJSMzd3Z3pEb2M1NC9h?=
 =?utf-8?B?SzRGbjBJMVJoSE10TzNpUzBMNzFDTWdRMnlLa055a1ZaMUtFM3o4amI5QmEx?=
 =?utf-8?B?clNYVFI3Nm11cTdOeGlEamVtN0VWWFVHY0l2N2FjdlozU2FsbFBFbmlKS0Rt?=
 =?utf-8?B?YXpnYWJSYjMzcUNYWWxsOTAzVldlTEVpQWVvR3VkVjR4dHJ6eGFKb3NGcGIw?=
 =?utf-8?Q?+8e1aHQ/z7JMqZ4FJnGA3yP+16QTYuDo?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGN6a1paVi9NKzJ0anVvaE13WHY1ZjU1ZWlhQzg2MG8yS2crc0cxTnorTXBW?=
 =?utf-8?B?WkRxU3dSY0ljMmVLVXVrbHd3NXQ2WUlkRjJGUGZlVDJTTk1JSlNIbTlCenFU?=
 =?utf-8?B?em1jVGNtRjYzZFdKczR2ZUxjbm5KWk5RelJaVDJMQXZiOEJLU0ZOZE5lNGV0?=
 =?utf-8?B?US94bXRSVWlRb0tYNzRLSFkvcmMzOG1YTzZRNUVWMVhXM1A5OUpLbzEwa25p?=
 =?utf-8?B?c2xPb1lHUWkwME16aHlXSGZPVDZxTnp4UXZrcGxVSWZUbzhwZUJuelBXbDZw?=
 =?utf-8?B?KzZGZlM2ZkMzcEhBWi9oOEo4Z3F0STlVZ0Y5Qys0dDVDNGxPMWxTdkErQ2pi?=
 =?utf-8?B?Z0FhTGk2V3hQeUJkU3lwZlkySklSNm4rRnhrWTJuNCtJd25qMTVqZXV1NDVo?=
 =?utf-8?B?NTFzT1NkZS8vb0J0Si9DdEJHK2h6R0FFdC9xcU9vbThJdDJyNHJHNzZsY0Jk?=
 =?utf-8?B?TkhxTk5yV1E4QVJZYjYrTG41di9jRUhGWUU0WlAwN0VkaEw1TXdHVHFkRmc2?=
 =?utf-8?B?WDU0MFF5Rmo3b1dyUkgxb1dnWFk3YzkyaWxJbnBDRDE2YWNTTjc0bmh3VTJS?=
 =?utf-8?B?VzBIaTNYcjI3ZUlZckxxa3hYZWNJbnNFWHpNdVBxdXZDQWlGSkJLZGE4WGdZ?=
 =?utf-8?B?WW56UGVMSHV2SENmbXlNL3BNV09Jd0hGMktMMFEyQzRxTkh5Nk9QUllJTkVI?=
 =?utf-8?B?SXdoRFBNZFFuMjJrc0tqYUtpVnIrK1FGL1ZRK21NNUVOd3lXNFNHNTljNS9U?=
 =?utf-8?B?V2luNEV1b1FiQ21JZ2R1MGoxdndOSDlCVEE2U0pPbFFaWUdGYUszajhzaUJD?=
 =?utf-8?B?dXlFLy9ZL2t6Ulc0UEZ4MzVZdEc2M0NqN0Z1N0RKQXZWRlJWQnFuemhVUnNY?=
 =?utf-8?B?M0d4cDFmenBaaFkrcE9PRlBNQzF0dU81YUtOV05BYVRVUVBwSzlwTTdBMlNp?=
 =?utf-8?B?Q2ZkVGI4TTNEUHkyZGl3aUE3SlU4aUZvMi9TcnM3R2FKa2VYaTQ4VEpMNkZZ?=
 =?utf-8?B?Y1g2K00vTURQZFdXc3JSbHpubVpjRXkyTkdGUFVvdVVmTUVMRldXZ0VQYVpn?=
 =?utf-8?B?dURSQ3o1UEVrRmlBUU5TNjBPczJ1TFdNcWFRem13Z3o1R3pNNExPdStaYUhJ?=
 =?utf-8?B?SWlQUWR1MldtOEw0a0RLZkMzekRIUzlpUWJ4WUI1QVE4SCtwalZFa25idnNt?=
 =?utf-8?B?R0tGRWIxTkpET0VUaVJyanN2QnJPakNqSm5reUVGSDRxNmFXaW1OODRjYjUw?=
 =?utf-8?B?YzVkUUV4UFRUanl1Tjk1OFpHNnpNNmMwNnhjNVVVV045WGsyVzYxdU91QmR3?=
 =?utf-8?B?YlpKMFhEaDd1WmMxeUtoeGdoR0pFQWpuR2JReHNscTY4OTEzWkpyb3FGTG42?=
 =?utf-8?B?K2I3ZHo3STZzcTFadGlaN0FJWXR2S1FaS0JGUm9BRkZCOHdTZnZmeVFOM0dp?=
 =?utf-8?B?WmNZV2JwYmk5UmtZQnFPdnAybDNnaFNKNFpMUmdQd2ZWOEVTUGdwdlF4UVd3?=
 =?utf-8?B?b0VvL2VVUDZ5WmdtdUs3UTgrSFlrVUwyZEtoejQvTHFDTVZOZHFEUWExa0ND?=
 =?utf-8?B?d1F2eWpTekhKU3ZCak5yeWdJN0N6MllLejZJWmZKRmcvZnlpcG1uWGlCd2g1?=
 =?utf-8?B?SE0yU2FxampVNnREVFdKSWo5YWp2UUxGQmtMc29RdWhkbkl5RUd0VzFJMmJi?=
 =?utf-8?B?VWgwYzBuNWJCZktHRnRRLzZWVUhmZ3J6RmhydXJzZTZhT0hVSFhIbVdpTE9S?=
 =?utf-8?B?dmJuSzM3dk9ZMXlHa08ydlZWZysrMzlzeTZIdk9maGRhZ0Y1TEdWNDBhYzgy?=
 =?utf-8?B?UlZaMEJkV2VEQXVSeGc1UnhTZFl4MTJKd0V3YnN2QUgzQkRDdktLL2JvVTBy?=
 =?utf-8?B?eSt0ZFhLbk5pL2t2RUM2Q1RuTDRWOUZjUVp5dENlMm9GRWYxWW9JRnVUZTFQ?=
 =?utf-8?B?cktrbUg1cTJaWEk1V2VuYXNsb0VBcXVVeURkSHh6d3RrQ1Z6Mk5VcFpqYjBa?=
 =?utf-8?B?anhscERaNEowR1REWmdtaCs0aDdoMHNMRndkcFNPaCtzOXI3bk1ya3pPWjJV?=
 =?utf-8?B?blhWdVEzcWt0SVhWNnVCRmtnVW5DMVB5SzF5UWtuTFM5RzNETk0wbDhzUjlD?=
 =?utf-8?Q?KN701L4zRkQjIuOpds2VcaIVM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bf148ff-9863-4a58-772d-08de17cff307
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 16:18:23.7782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i5b0Obv/2XKqNsBmC7bDglpkvIYvxb3CoIp+0UvskEPTeIo8En0mWrY3JHt2O0hPTv/y++Ldie4Z3DKI+JtDvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8702
X-OriginatorOrg: intel.com

On 10/30/2025 11:54 PM, Luck, Tony wrote:
> On Thu, Oct 30, 2025 at 02:14:27PM +0800, Chen, Yu C wrote:
>> Hi Tony,
>>
>> On 10/30/2025 12:20 AM, Tony Luck wrote:
>>> resctrl assumes that monitor events can only be read from a CPU in the
>>> cpumask_t set of each domain.  This is true for x86 events accessed
>>> with an MSR interface, but may not be true for other access methods such
>>> as MMIO.
>>>
>>> Introduce and use flag mon_evt::any_cpu, settable by architecture, that
>>> indicates there are no restrictions on which CPU can read that event.
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>
>> [snip]
>>
>>> -void resctrl_enable_mon_event(enum resctrl_event_id eventid)
>>> +void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu)
>>>    {
>>>    	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
>>>    		return;
>>> @@ -984,6 +984,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id eventid)
>>>    		return;
>>>    	}
>>> +	mon_event_all[eventid].any_cpu = any_cpu;
>>>    	mon_event_all[eventid].enabled = true;
>>>    }
>>
>> It seems that cpu_on_correct_domain() was dropped, due to
>> the refactor of __mon_event_count() in patch 0006 means it is no
>> longer needed.  But we still invoke smp_processor_id() in preemptible
>> context in __l3_mon_event_count() before further checkings, which would
>> cause a warning.
>> [ 4266.361951] BUG: using smp_processor_id() in preemptible [00000000] code:
>> grep/1603
>> [ 4266.363231] caller is __l3_mon_event_count+0x30/0x2a0
>> [ 4266.364250] Call Trace:
>> [ 4266.364262]  <TASK>
>> [ 4266.364273]  dump_stack_lvl+0x53/0x70
>> [ 4266.364289]  check_preemption_disabled+0xca/0xe0
>> [ 4266.364303]  __l3_mon_event_count+0x30/0x2a0
>> [ 4266.364320]  mon_event_count+0x22/0x90
>> [ 4266.364334]  rdtgroup_mondata_show+0x108/0x390
>> [ 4266.364353]  seq_read_iter+0x10d/0x450
>> [ 4266.364368]  vfs_read+0x215/0x330
>> [ 4266.364386]  ksys_read+0x6b/0xe0
>> [ 4266.364401]  do_syscall_64+0x57/0xd70
> 
> I didn't notice this in my testing. Is this in your region aware
> tree? If you are still using RDT_RESOURCE_L3 then I can see how
> you got this call trace.
> 

Yes, it was tested on the region aware tree.

> Maybe you need to dig cpu_on_correct_domain() back up and apply
> it to __l3_mon_event_count()?
> 

Got it, will do.

Thanks,
Chenyu
