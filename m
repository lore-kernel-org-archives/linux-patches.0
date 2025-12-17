Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4FE2C1594;
	Wed, 17 Dec 2025 09:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765962671; cv=fail; b=g1sAaipPR4Se4zVMyDitOx2JRZvOAl+EZgVYg2gVB6cODopaXggv+pTxuvMUDRshALSFUbZoS+f3GOWI4eZdWCbAEuzrS3DiF4gM9qAUdurCMY7DIluYLlZIeoO68sR/QVj+JSh2emmHVr/552iXoRfGGUIN1KsCrs+fgk0Zqwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765962671; c=relaxed/simple;
	bh=4vYtx2gAZvUOUf8nDKrpf1+Sue8WbDG3LbBvqainl+k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qhS27eb4t6yATqLuRSBaS694IXzzr11EVIvXf4AyyvEKkbsFyffeD91MmmO7G+FR+PHbTxMKxqdM0nFPzF5Sefiujo6iFhOU42vayAM83ADS5m+WZUsLmj83uyFlqwn7qakE5kwObzgp28ZoyKSKvkhlBqsEr2kl7vtuMmHvYr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=li56B9BL; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="li56B9BL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765962670; x=1797498670;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4vYtx2gAZvUOUf8nDKrpf1+Sue8WbDG3LbBvqainl+k=;
  b=li56B9BL8ThTTVc2nssFzHKXROkTk3KpnpRehJEweANe0jGBZFWeyqow
   DW7VFA9Q1nMrD1C3k2s4QmSSgVQL0VEJcA716x5f4VuETO+xQ8H16VaQ6
   I/QrkUv5fq4YIi60LVLlsKZYmTleVlSlo2fmM5UY/TZcDQ3ZVXJs0Muud
   mzBPPoQtZ11vgAjN1AZsPu5oQS9JVlWnk72t/QFR9OmQCB+DnEuxB0ok9
   4ldAU2738sU2au7Nq+MSMvztSE/mr9IVSy9Z97HTAgT6cXWQOsqIIW/bV
   UlOnf44Eexe0g/hdnBxlv4j9hFF2PKQExtINGPmeiUFDA86ADe7WPmrjB
   w==;
X-CSE-ConnectionGUID: qLDHVv3kQIin+jShrjPVwA==
X-CSE-MsgGUID: AuCkYerGTmuVobY6hjFOrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="67966947"
X-IronPort-AV: E=Sophos;i="6.21,155,1763452800"; 
   d="scan'208";a="67966947"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 01:11:09 -0800
X-CSE-ConnectionGUID: +BIXXcIWTGygZlkh+UBFXw==
X-CSE-MsgGUID: WX8QdQKGQAWY2H4inYpdkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,155,1763452800"; 
   d="scan'208";a="202753612"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 01:11:08 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 01:11:07 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 17 Dec 2025 01:11:07 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.16) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 01:11:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e3/u+PBNohn2ZMmWpkGxUNkxRGaU76di0x0HUqR3/8KjSUH8atnrjViuYdZobKkDheHH/kkL/zJFuUCJ55w0v2wJNJL5Pe2+W9Ff1Odv2NWqTc1PyNAgTJPQBSrnpLHpcdQYZ6yqnJShQNCoK9Pa69u1Bd+ugpaAF+udY+XgzYWGVXUHS7N9zP0aJcHhubwGWQHS6p2/Ypr/28heXQZ1lkKsc/rvDlY4eF2rOy5/DmBGgfDhhLju64H5SzQONJ6Y/FIisO+ok0oqq4Q57yYvGXtaeAMgnxfCEmgOss/YwPxUPmHOsEqDA+vj8VeEmDw8VjFCO/F4narfpqW27H/YQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ucqkPU6ssSkFTRnRYS+fpgeYu86Vhqs+F4guiZzSQNs=;
 b=t0AqOyL4HiAdDFM21M2RQMQ6yH03pqtEjf25JGqjAXsvlTv8dmhhYcyocftUBXLk75eNG9dpe0inPiN5EL2+XWxRBwvfgDCPq2AFsklFX7cGLEeDXwzv8hYVEANj5No12ADSO+8EZql3QKzOz3dOvjbwEj4f9Kaq85WrS9XKvhBm51TftUIRuRNnwi7yDhRW8tQ6Fa0swSG32EocUfYEUjBWhItWms1e4uFemBEl/Bv1aicitE8urpES2g2L4cBKTx5Mdqx9mVg7/LEOSuszb4RokUgyNNcBomxtXRSR4Rg+FmRzW0GUskEBnSuPX9sRoaUn7w489/EQvgPTKOyOBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV8PR11MB8509.namprd11.prod.outlook.com (2603:10b6:408:1e6::15)
 by IA4PR11MB8944.namprd11.prod.outlook.com (2603:10b6:208:563::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 09:11:00 +0000
Received: from LV8PR11MB8509.namprd11.prod.outlook.com
 ([fe80::2e98:2a3a:ea82:c1bb]) by LV8PR11MB8509.namprd11.prod.outlook.com
 ([fe80::2e98:2a3a:ea82:c1bb%3]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 09:11:00 +0000
Message-ID: <0693bba1-4ed6-4243-94ac-da85e8f51846@intel.com>
Date: Wed, 17 Dec 2025 17:17:46 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommufd: Check for overflow in IOMMU_TEST_OP_ADD_RESERVED
To: Jason Gunthorpe <jgg@nvidia.com>, <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: Eric Auger <eric.auger@redhat.com>, Matthew Rosato
	<mjrosato@linux.ibm.com>, <patches@lists.linux.dev>,
	<syzbot+57fdb0cf6a0c5d1f15a2@syzkaller.appspotmail.com>
References: <0-v1-cd99f6049ba5+51-iommufd_syz_add_resv_jgg@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <0-v1-cd99f6049ba5+51-iommufd_syz_add_resv_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0159.apcprd04.prod.outlook.com (2603:1096:4::21)
 To LV8PR11MB8509.namprd11.prod.outlook.com (2603:10b6:408:1e6::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR11MB8509:EE_|IA4PR11MB8944:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ccb272d-65bc-49ae-81d3-08de3d4c31de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|42112799006|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V3VhVHZIRUtqN1RlQW1CU2ExVWxSVkN0akF5Y2FOd3J3VXNNSloxSTRLQ244?=
 =?utf-8?B?UERPaXRkT1lJbWF6TXZPcHpFSkRjVUp6Zjd4Njl2MWJiWmZkVzIyWEtkYWQ0?=
 =?utf-8?B?Z0E2T2pUQWxXOTdmTWZWLzRyT25jOUY4YXRzdWQ5TzhSbk9yZjlFSXFqL2VE?=
 =?utf-8?B?b3FTOWRkV3llbm1WUkJITitaendnZ0s1eUxMQVZFZUFKTkJpV3JDck5sRTlL?=
 =?utf-8?B?RmQ5VWJUeldDMkQvTUErWk9sZ1dWazlhTkR4UFdNZ2laL0xIWUwyNmNiVTho?=
 =?utf-8?B?VzRrVGlpS0wydS9vdFRoSUkybXlxeFdOWHR5aEg5UlFOWjZnZUwvMDFLS1Ew?=
 =?utf-8?B?cFpiU1FGVk1sR2dsdXZoUjVUWTc3Q3lPQW9VeFZidGlGUk9nVkhRMk10TWxq?=
 =?utf-8?B?VFJ4bnlsNldIckRlUWRScGZ5RlIzemhEMGM3T0dGQU8xZGg0UytkY3FmRGZC?=
 =?utf-8?B?aUpCS1V6QkJVN3dReVArSFhKNm9YRFpnNGRmbG5RSWdLUkt0eUI4bW55cTkv?=
 =?utf-8?B?Y2VQYXFXNmpXYkE5LzMrZjB6cHhaZW1ob0V1OTNDRGNnQUM1Mjd6a04zOUs5?=
 =?utf-8?B?cldxdXAzZGZmN0ZhUWYzcDFPRGZubHVDQUZ0bzdpU1grM2Y5TlpvelJDWUxE?=
 =?utf-8?B?K1RIRlJwdlRHMzRJZElFSTE0aWwxcEhFVWNVbTRxclNhNFRmbVdrVU4xTVZm?=
 =?utf-8?B?dUl1SG5DNTdZRkoyWDJjM3AyRlhXc2lERmFReENxS1VwakJBZ1FWRjFudzBh?=
 =?utf-8?B?VXZjOGV1Q2swOWw1NjJLMnVBNWdVMlQ1WGxjQ2FsN2lPeW1xcHFVRVQySGZV?=
 =?utf-8?B?Z25DRk5TTER2cEJFZjYwS2RXUUJ1ZG82NSs4VGpKSUI2WGh0bWtPcGdFdEtC?=
 =?utf-8?B?TjJvekxSdm4rT0NBM0o4VHRKbkNmeWxPajA3Rms5NDV5WUNsWi9aTEVLZDFJ?=
 =?utf-8?B?RzhBbHp2bkJBMGNEd05SMExjS2s4d0FpaVVkTjQwdjFLeFVKVGdzOWNBNm9Z?=
 =?utf-8?B?dWp3eHp0WW1hOEM1YjJ6cDF2amdBbjV4M09aQlVWYmpCMjBuckdTRWNvZldS?=
 =?utf-8?B?YlBqcTlvNXRicG1OT21TR3RkREFoeUgzSnBkWlBuNXJBTSswcm1DMUw2T0dm?=
 =?utf-8?B?Ym9tQ0p4aC9mQ0tISm13ZCtWanFyWTVQYlVVTFJQaXAwd3dTR2VvZHV1b3FR?=
 =?utf-8?B?eUZaVlBuSkZJbFRCb1pjK0NGMlMxSE40eGg3VHhuWHhwcmxkbGlBUFBkV2JE?=
 =?utf-8?B?TGtBZ2l4MmZrR3pqQkZyQU9qQnh2dmpQVzZhSXdlWkVNVTZiblVuMFpxcTl4?=
 =?utf-8?B?THduTUZjUU8vYnJSa3c0MGVlNmsvVlZybGtzZ3NNSktvNE1rdnVQRXFGaVAw?=
 =?utf-8?B?ejJPRkVFNjI3M0ZZSFdreUNVakQ2Mzk5UERkRC9hQnVyZ014TldIS0hMWXhM?=
 =?utf-8?B?cTgwbGp5K1BzOEVpWWVXeUZsbmJGUUJQVHVLOWppRWsxRjRnV25jaS8zY3dG?=
 =?utf-8?B?ekZiYklzZTg1cUhlQ3drcXBUU0pzdEw2dUNTdGg1MmQ0N0VWcXJIUU0zU0Rq?=
 =?utf-8?B?YmduUFNkNzI0M0hkVlM1SDVab0ZPdlMzVlJvOGsydUQrMm01M2QvcFdDckJl?=
 =?utf-8?B?V0JlYTZTYWRTaCtaS2JTckpoRndKdkJ6NG1qUGRFMkZrVDVSbkR5OUp4L3c5?=
 =?utf-8?B?cXJ0OFFka1JuNzRWS0gvUFRwNjJ0b3c4U3RHWmR3dFN2eFREZTN1NmpGSUxm?=
 =?utf-8?B?WWxFa2owZndCbjN1NndRODNHR0s4bzc5d3FNQisyK2VUTWlZaVNMOUYwUGR5?=
 =?utf-8?B?VzkyamZwNEwyUG1uekJGK3dCQWI1NGk2ZEgyaVVDdGhmS01veUtmK1UzRWw1?=
 =?utf-8?B?NlBBRTN1UFhVZVhmU0RmYzFOQ1RsS2tMYW5FbG9VTnIvbjRFNWFDaTRWc0R6?=
 =?utf-8?B?bWdZUDBra1pnbGR0bFBQbHRjeGpKUXBHTTQzVkFKV2phaDZGQ2dUb0ovZnp3?=
 =?utf-8?B?VCtzeDJ5NTVnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR11MB8509.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(42112799006)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUduTmZBVkJaZHVwcjdhWk53R3lmOW05QnF2UzJ3V0lLV0x2OVhnSUxtb3FV?=
 =?utf-8?B?NGFPR3lKVFgvMzlNeEwvUFYyWm4wWDZVM0pLSVNUUEhqZ2lzN2hKNnZaOTRy?=
 =?utf-8?B?TCt4QmNIbGtlWllUdG1XMUQ5SnRjcEw2NzVueXkreFBhb29qdE1JZ0hGTkEr?=
 =?utf-8?B?aktkTU1ocTBLZXMrcFJhblVablNkam1LbGNtSGRIcklONzJzSEdTZDlkK05i?=
 =?utf-8?B?V3k0TmlJYkhHell1T2xlMDJaTmtzWTUxMmx4QzArV1dEZko2eXRMMUJzNHll?=
 =?utf-8?B?RDgveXdsY2JBdVZoUkJaaFRzMjFiKzBsanliUlFsbFVYbEZRU2p3YnpHaDFK?=
 =?utf-8?B?UmQ3RnBZLzkyU0JKclgvS1BzQ0I2SDRpeVB2L0ROMXBkQmFYcktSVUZIdFFa?=
 =?utf-8?B?alI2OVQxOVlkRE5Pa3JqTzNVdDhqTlBSbXBVOElzc1lWMGlVQzE2cVNFaWhs?=
 =?utf-8?B?Nk9jdmFseGlTUFhTYlA4TWw0SGhSUXYxR1pIMEpGczlVc09YWFVKUVJrbHVJ?=
 =?utf-8?B?d0h5citoYTg4cUFUNmtQQStUYkczV2YvUmZOV0tBSkhyTDd1ZVBxaSsyRW1Z?=
 =?utf-8?B?VFpZRjZxLzhmY2tIOTJjVUhsTndzZEtXZ2g4czdIRVlZdUJ5R2dubEdkMW51?=
 =?utf-8?B?UktKMncvQ1AxakIzUEw5ZU1OVzRldjJSTzRueUdZM2ovS1ZJZlRiWGs3WlJR?=
 =?utf-8?B?YzFDaFVMRlRRTWZmSDIyb0JraG45akJmTzFRUGtZNCtyNnVHQXU4a2I0QnEv?=
 =?utf-8?B?YTVUeXFxeUprN1hEYk94Qmx3dXZvMUo0L1g4YmZENStDL0dlVDNmQ1pHc01F?=
 =?utf-8?B?OHMzOFVBQ0RzRG05SVg3R0ZtUFVVa0JFZTFYZCt3c09VRE9XcDY2cjdyYVRK?=
 =?utf-8?B?VlRUUW9jYWI1OUEvK2tucUNCOElYYzJuVUJvRU5MM3p1c0xuRzFLNm1GQTNN?=
 =?utf-8?B?ODZKSWtwa3lvdFluVXVsdmtwT29DSUk1ZUFIbmpUbHJVR0EyUi9lYjhFaEdM?=
 =?utf-8?B?TmU5LzNtT2dBTEJVTXBoMGd2a3V3QUlNbWFiN09Ob0RaL3Fod09QRldkMGZY?=
 =?utf-8?B?d1hqRmlTUlpFTmNRWVBpUkp2TFFCem51T3hjd3k4eCt6RWdCZVJ4Qm5YM2JR?=
 =?utf-8?B?UHVoamZwRUhORlRWcERseGNmeFE4MXVmdkR1NkhrdFBSUDB5WE1hSDZZVXkx?=
 =?utf-8?B?L3Z1QmtYNVYwQXhqTDRUU1J6WGpYQ21zYzVNY29lSFFmbk9pam11UUV2aWdB?=
 =?utf-8?B?TVJYWUlONGV1ZkJqamJyYXlaMkVnMFRUd0FkOTRiRm54SnZNMzNqemNtSHVO?=
 =?utf-8?B?T0RMazU4dlBHMC9HUFpCUlc1ZExSNnRSTU53dFRxdzdYeVk4V2JsN0RKY1Uv?=
 =?utf-8?B?QkNCc3c1cVhwREw0b1M0aHA0ZXYybFl4cVZLM0RPL3Vnem5wRjA5YU04NmVP?=
 =?utf-8?B?Qkc3bllpa0RtWTVnMWlMVHBSMHM5Q1NSM0xVdDNFVi9ZNkdJMEtaRWFXOW1Q?=
 =?utf-8?B?SmV1bS80S0hLRG4xU1M0NVVPcWVWbDFlNUZNM0Z3WUc1ZnlmdmhsZk9MYmJ3?=
 =?utf-8?B?a1Q3MGxIaDlobDBqMi9GelA1eGtib3B1aXFhS1R3K0FybVBzUlU4Rmp4b0Zs?=
 =?utf-8?B?Mkk5RisvYW8wSEpJRVJQMjVKL1RreGZ6REZJbVpQeGpMY0JGc0xKeDFUazgx?=
 =?utf-8?B?T0FSNzR5Rm03aEFzdSt6T01hMDh0TzY1RFB3WnVmR2wxc2ZMNzNmU3dZaWhE?=
 =?utf-8?B?cThuVnVMa3hXWjRCMTF2WmdtQk02djlzS05CckxoRjVtY2I0RStMRHF6T3dT?=
 =?utf-8?B?UUZWMWg0WG1RSHlzZFpOblFhL3V0YlFmZSs5Qm1BckJ3SWJ3dzlhaHlzQ2Ir?=
 =?utf-8?B?RW40N0FTdDdZSmh4VTcwb3F3VFBxMUx4SjVZNHM0ZTJOZU9jQnBmWHNZemho?=
 =?utf-8?B?Q1pLbGhxMVNTQk53VWh1R3ArSDduUUU1U0F4SG9wRnhZU2lRRUFTVnRZS01R?=
 =?utf-8?B?eGd5VDBNTDAzWjRmcVROc1V5K1c4WEpOY2tzbzN3S25aSmxvUnd5NHFpc09J?=
 =?utf-8?B?SkJuU2hONFJsMXVkekNvbnJxRVFMWVpUekFyNzR0RXFwd0VoclljQmphWW1i?=
 =?utf-8?Q?FK4GbkWKNErgwDBSLf5xA8f1B?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ccb272d-65bc-49ae-81d3-08de3d4c31de
X-MS-Exchange-CrossTenant-AuthSource: LV8PR11MB8509.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 09:11:00.0650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A/miXFqoyA4j/x0cNfG0dPLPte+P9ZB4tXKaZX+BJZApDIi72MMawAFnX3JdEhbjfY0AlBYkkDvX3u7u8goCwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8944
X-OriginatorOrg: intel.com

On 2025/12/17 01:13, Jason Gunthorpe wrote:
> syzkaller found it could overflow math in the test infrastructure and
> cause a WARN_ON by corrupting the reserved interval tree. This only
> effects test kernels with CONFIG_IOMMUFD_TEST.
> 
> Validate the user input length in the test ioctl.
> 
> Fixes: f4b20bb34c83 ("iommufd: Add kernel support for testing iommufd")
> Reported-by: syzbot+57fdb0cf6a0c5d1f15a2@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/69368129.a70a0220.38f243.008f.GAE@google.com
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommufd/selftest.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)

Tested-by: Yi Liu <yi.l.liu@intel.com>

a nit: is it necessary to add another overflow test case in selftest?

diff --git a/tools/testing/selftests/iommu/iommufd.c 
b/tools/testing/selftests/iommu/iommufd.c
index bb4d33dde3c8..4404889c8b7c 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -995,6 +995,12 @@ TEST_F(iommufd_ioas, reserved_overflow)
  		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ADD_RESERVED),
  			&test_cmd));
  	test_err_ioctl_ioas_map(ENOSPC, buffer, map_len, &iova);
+
+	test_cmd.add_reserved.start = 0x1000005;
+	test_cmd.add_reserved.length = 0xffffffffffefffff;
+	EXPECT_EQ(EOVERFLOW,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ADD_RESERVED),
+			&test_cmd));
  }

  TEST_F(iommufd_ioas, area_allowed)


> diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
> index 86446e1537949a..550ff36dec3a35 100644
> --- a/drivers/iommu/iommufd/selftest.c
> +++ b/drivers/iommu/iommufd/selftest.c
> @@ -1184,14 +1184,20 @@ static int iommufd_test_add_reserved(struct iommufd_ucmd *ucmd,
>   				     unsigned int mockpt_id,
>   				     unsigned long start, size_t length)
>   {
> +	unsigned long last;
>   	struct iommufd_ioas *ioas;
>   	int rc;
>   
> +	if (!length)
> +		return -EINVAL;
> +	if (check_add_overflow(start, length - 1, &last))
> +		return -EOVERFLOW;
> +
>   	ioas = iommufd_get_ioas(ucmd->ictx, mockpt_id);
>   	if (IS_ERR(ioas))
>   		return PTR_ERR(ioas);
>   	down_write(&ioas->iopt.iova_rwsem);
> -	rc = iopt_reserve_iova(&ioas->iopt, start, start + length - 1, NULL);
> +	rc = iopt_reserve_iova(&ioas->iopt, start, last, NULL);
>   	up_write(&ioas->iopt.iova_rwsem);
>   	iommufd_put_object(ucmd->ictx, &ioas->obj);
>   	return rc;
> 
> base-commit: b80fab281349f107a07e841eb412a86e2877ae88
