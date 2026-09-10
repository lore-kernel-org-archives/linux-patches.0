Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE983A7F52
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 04:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789013396; cv=fail; b=QbNLPVM0RGsOemJiwlfNkWeY2LY5DRetO3ZrG30+pPxAb/mUCwUGxX/dZ+YYjg6SXIzP6SYxCUMhdpWBdubCa6tV5+bkPLNK4dBtnWLy5CFjrLvEqGQhPx0l1KlQVb1zibIeOi7Qo+QvQepmxUmHZ55JQooy5SuRood+0woMU60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789013396; c=relaxed/simple;
	bh=+xIemZagAotruCRc6ducWG3qKM0w9chkzRZ0zagKMNk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LWfRzy2RALSUucBkGd8BObbVQzWlOUoCvulrxr3X7AUB2hiL9WOF7KBtuYunFfr82RzEDdnQ/4f2ethLFpcvimyetTtMQIgqsz2Yo198FK263XZtBHl5DEiRssySYIVZWLrLyOyL1t2NaK+Vvgyqbd5lCCPOFGahoB3aVRFf0vA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CzQ1TVpI; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CzQ1TVpI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789013395; x=1820549395;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+xIemZagAotruCRc6ducWG3qKM0w9chkzRZ0zagKMNk=;
  b=CzQ1TVpIr5pqpSUwa+bgI1mNEDo2xwpueHLxFoZfBYfyBBVFp5piCbVf
   MhkxPyH+v8hSW14KSIxR9v0aWXKiQX1lax27wM+qBZ+RZag/RN0uQOdPz
   ta7NgWPkoN9+XQvLM3gFQ4tHuDE4KXLQaI4fCeONAsH6mjIxp9/5YPnGR
   I5KUXvDpTBbLE0wrhTMQ1Rz21h15oJb/ONC8pCnPnerXRsXpgwqub84c3
   M1yL9By7390V7C66yaKIpoVQ+15MxszOzEct+q3YrPL9Pli/DfO/TAp6K
   /srfXZ1zVwXziQNsJLhFzUGbOsDht72MI94DHCJ6+nYv70Uo+FFdk+qn+
   w==;
X-CSE-ConnectionGUID: N9WQQp0WQK+Ti2xF/iGVVQ==
X-CSE-MsgGUID: rZdIxzNRRHC0igjGFjR8kw==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="89665933"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="89665933"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:09:55 -0700
X-CSE-ConnectionGUID: pQ5QnkxQQymTwpK5LjID4g==
X-CSE-MsgGUID: t++4bje9QRS0ESYYVcIO0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="301417053"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:09:54 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:09:53 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 21:09:53 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.50) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:09:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n65Re4ML6XptGgW4r2PJgPE5GtJCH5DlRvFmZrFbi9d8B3v8NQOKuJ+3Vm/0IFQSvTygcnamMkWuS6dGFIRuFsRmSsQ+fCEXHKlj/zz3bma1ieURPTBW384v6GZOi1N+pcPl2K9dpqs8JKaJCbvpwDRF/n1iSEA5OcYpPmFgkkttOE0SjURXqFnkkeFRRqK4EgJimk5sRj6wzcvKIeoYx4nX3I8C9XQHXIKp84mBr5UB0H5OOmCT+kCibDoNc/dWL5Dc8aZIoqSJzDVm80rW6in7CAr79wASxhILxFZbtg+hM2JhgqsTNdJS0Mdkyhcgwri1egwkfLdS+fZ3xkaFoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xp/wFzg+kJhIipHVxeq39tg9M1IwKzrjNqKFb8KF05E=;
 b=sOfNhdylZrG/keBPO9a3qWQdhkWeLmXakqHPppXiu6umapfu1ocsrDWuo1sIypsaTgNjlGgXvEnzQaoP0LoRnwpkHIjCwKLBvCqeaG4yNxq5+9v+W/f5YGKa9aAjxPSDAwt5WvNLhH5mULdli5JZ0EaFdGUColESEp8FNfJRxm5rhRX9UqjfupOm8OMtYp8ejIS5XO17rXebNGq9Q6BkgwRk5EBG4pRS2nImsHy3eq7j2nHokA0Qk2Oj+fTaewjw6Q3RICzkYzkg+kzLDcs53rOnTPWxRYvoIa10YkT8MReoIobcuuklD9GISFAUJ9K6f06Be1dlDqL6QggXwB2Cww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DSWPR11MB9583.namprd11.prod.outlook.com (2603:10b6:8:36e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 04:09:44 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 04:09:44 +0000
Message-ID: <707d2f93-67c1-47be-8309-a07628827062@intel.com>
Date: Wed, 9 Sep 2026 21:09:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 21/23] x86/resctrl: Require 64-bit x86 for resctrl
 support
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-22-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260831174421.13921-22-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:303:6a::9) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DSWPR11MB9583:EE_
X-MS-Office365-Filtering-Correlation-Id: b460ff53-0fb1-43d6-c539-08df0ef15843
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|4143699003|10067099003|6133799003|22082099003|11063799006|56012099006|18002099003|921020;
X-Microsoft-Antispam-Message-Info: AXlodQUp8FW0SDoRZrdV23mXyU4VYcLT94S3iWqcLVYLWZ3pkSqDUmg8HjVlvWLhqquzhXtP1d0s5SiBYHq+q8zx/B4Iy/QDXwA2r5++KcEHvaZL4b8i7vXP7ebsd2M0r7K+QOAxq6OzKdK4/DkFhYtlrq6P6VfTFvT72VIoknCLzH80SEyggl2ykYIavuHUYnMjLjDt2iRKPRASRc0hqPmUOauo66nAJpJBAZshKO+GmZSuaupEsxgI16zv+egDOfjOQeHBmClatOkcLYoYvlhuCb6FkUg+QN76FRzIcfJaqhvuCsPtf4tGZBHshcMyFvSyOBmQ1yoK3dafsW2IVhQwSqXZNEcsEEg4s19t7WWjP718tc+48QsqPelJGHByO1x87G+PXKSJANp7/lCFHw+GYg5V283h9b5Pc/F87TICbMOT3lVYztaUwi9Mi2kMrFsu7T67UzdtPOqCB7tGMHpI7tnLiPtdg/9oX7pWr0iPoOEUwIjceVzvKWTt++W/Bb6RTlW7SqX7oYVnpfeg6W08xsb2e/GZXunZK6qFm42a/3QaaqHvSzy8In9dQwBsVN9pbHuff6Ma3fYPz0YcQ7nH3cz5C6+ZC2nYIkuZHf7MD2YM0DxMnG/qfSYS0GSXAqKP6+xy8Y33XOcxAIx6Ylqn7zWWvWSP0GYL2aOz40blmL3v/P926WpZ4M7HQJxjfgcRMzrNE0fS1CAOWLwh8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(4143699003)(10067099003)(6133799003)(22082099003)(11063799006)(56012099006)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmhSeEJVeFloVFdWWnRuTk45MmZVaVJ4aTBEMGI3NkRmM2ZTS0tNMGNIVEph?=
 =?utf-8?B?bWVhNHZEZDVmbWZPQXI3VEdQcDY5WVNjei9naHlST2JZQzREdTVja21WNzQ5?=
 =?utf-8?B?elJjWnRlbFY3d2I3cVc2RVZCNTFNbTJYSjVxdkp6eGFFZ0RaUDJCcmx0RWRE?=
 =?utf-8?B?WVcvMittSVNOb3Z0UitZWTdKV29rZXJ2OG1CYVg5SVdTbE5VUHJSTnFGRDdN?=
 =?utf-8?B?TG5UejNUZS80dlAwOHNXTzBxcHJWWXk1OVM4WXZxaG9yZ0VWNlJaOUJVQlpp?=
 =?utf-8?B?a3NlbUtidzRLa21PdEhvMU0wS0NHcFNOQzc3TWFrdFJiK05qZElEZjM0RGRG?=
 =?utf-8?B?SzhnSmJZSzM1V2trQmI0TVBsTmYvZ0lBa0VSRXdnQm1MQmpMUi9zRVN1Y01h?=
 =?utf-8?B?Zmg0c3Uva012dmR2NFVBMmdFZmo3UEREODFNQjgrZzh5bFI3eFlKL2xEaGZC?=
 =?utf-8?B?RFpUUGlXaUZzUnVwRFB1L0g4RDQyWTVoVHhSaFFHY2VjQlZIUmgxMjJSQVpp?=
 =?utf-8?B?UzVjbENSdHlhMDVScFBrT1FLUVVjRStvcE1USDhkNkdxcmVJQi94Z2ZsakU0?=
 =?utf-8?B?K09yaUdnLzVGaisxYnVCL1lOb0RGSXJNdVVMd3ZRdG9kakFZVDBPa1dpYldo?=
 =?utf-8?B?MDdkby9JUWdzdGFFVkp2T0R5WE83ZkVrckZkYzNXcXo1VHMvd1p2M1BrcG5l?=
 =?utf-8?B?dFcwdXVIM0orUG5iTWpjVGF6QzlqMm54d2d4ekpPeXJoUHdKVC9pYzNqQ2po?=
 =?utf-8?B?ZEV3UU9ON1IrdU9GMm5SUzhLNFpMZm5JL2JsdTl0ODcrZ3RQeDNwcFc4d2Vr?=
 =?utf-8?B?S3dkamcydnJvdjVLTnpmNzhLazFSV0NFNGpRbW9JY0k5RDdsN3FTVWRMQzMx?=
 =?utf-8?B?UW4zZm1ZOWJYWUozTUpCcTdNdWlWSFQ1bXRFWVIxQ3o3V0syUzVaSEVyRm1q?=
 =?utf-8?B?MGI5eDRSWWlWSVJqUU16ZVhQR252ajNEUHBSWlFUODJjckY3THRReUNLZFli?=
 =?utf-8?B?d3Y1UlVvaEJqaWM5NmVkZHR3eFNhRVlVREdwS3hGNExaSCtGVEh1d0gvZWdw?=
 =?utf-8?B?RkV1QXJJZ2Y1WXgySWMzMWZJbjhRejZRb2Z6a2UwbWZlTHNwZmR1bG1TNk5k?=
 =?utf-8?B?Y3JHL0gvR0FwU3BmTEJ6MUdyODRJdjJsUVVTSGdVblViSHA2anJsM1VCZDQv?=
 =?utf-8?B?TWdTcGozQ3RJNTNsWjVhSmdUQ2ZQWmY2K3YwN2dZaWNTc29HNXBIL09aVUJU?=
 =?utf-8?B?QnY5VlkyY0p2bVpvUnN3QU9GcVNHbElhbjhFSklXdXB4NzRKQ1FHMDJ3THk4?=
 =?utf-8?B?TG9UemZIeXlGSHVDYXpJRk1sY2pMc2wxYUR0c0crVFA3M2pLWjU0NEhxUFJL?=
 =?utf-8?B?QnRiOVQ2cGtwOHIwR3ZuMEVVMTJJUEQwTkNqdU5QVDlFSmRjL3I1QWM1V0RB?=
 =?utf-8?B?cVYzZ2VRRlRxeTdIeVBITTgrS0tSOHdId0drZ0c5VGNoNkZpb3M1YnJpYlYx?=
 =?utf-8?B?emtUcnZjTzRRUDdaMlQwQkpaZWkzblBEb21sai9LUVJHTzZSQi9UTDVqdW1G?=
 =?utf-8?B?a05jQkRMc0d4MlZ0dS9QeWRxUS9BaFJmV01Cdng4Wms5L1g2eVdOb0VxZ2Zi?=
 =?utf-8?B?Yndqc3phMGg0NHhoZFA5OEtlZFAyWEZBQ3dUcmJYS2RteHl4cTlIWDZKM0Vy?=
 =?utf-8?B?RWEreG1EVmViNEVWZkovQklHOXFJUi9zM3NQSCtoQ0hvMG01OWpPeGNEWVpF?=
 =?utf-8?B?VE9OcDlDR2JZK2hwc1NHZHpqUHFpZEJIaFRFZW0rUjg4UkFTb0NwN28yWWJY?=
 =?utf-8?B?QjBZS2Ryc1VHRU5EMjFCVzZiRTl0Y3JNWDZ5RUNLWU95cEFmSldwcE41TS9H?=
 =?utf-8?B?dHlqemxwM3lYTDNnTGVNOGhlclVpR3BsRm53a2FRVUJJSnMvSjc2eTNDQm41?=
 =?utf-8?B?clhvMDhVbUw0emZkUEgyaVJEcExCbDR0clFESUxrcVM5Y29QOHNROWJESVlo?=
 =?utf-8?B?WlR1Tis4NGVVb0xSWEZsSlgwYXVGSXc3aUFIdk9vQmdrZXR6dERvRWpqS0pw?=
 =?utf-8?B?RCs3Vzg3dWlERDViSWcyTzNEeEdrNi94Y3hjd3A1ZlFLemJORDk5dW8zUy9P?=
 =?utf-8?B?aWdCcS9rUUwvZlhFU09adCtOTXluVWlocEo2MW9oZ0tMbzZ1M2RVZ1J6NFpT?=
 =?utf-8?B?Y29GWGJXTFRkOU5WNUg1OW40enNndXc2WlcvRXVsMk5NaHBtYXZRNDVzYlRT?=
 =?utf-8?B?NUwzclM1T29yRjhpSHZTN2RuWXRxdDU0MWtqSDhVNkhJNUFGMnVEZklOWGhz?=
 =?utf-8?B?WTFCRld4VGZ5V0JxK3JMNFVNSVRrZG1pdWVYMjVBbGoxWVVVbU9lZTB5dEU1?=
 =?utf-8?Q?1WimJyNUu10CeiuM=3D?=
X-Exchange-RoutingPolicyChecked: G7tcDsFTAY3Di5C6toVON0f5Ls1uvte9/Ays1D6eatkUJR2dAEyieRgIJN5H/9vxN2MjTawLqNd7RTLm0G7WCmNJitFzlxakrGQ9gIyw6d3wvbvhuuJL4t1nbYKdfPfXDbbO5viJjmx1k1kuinjGYBwrfTZHRvjkNAGXyKbJk9/BF3ufDooXmDTXKocOg002AO9Zlkz9xXpio/Oj1T6VRs8WANtNooaTjWYxhmhLHkR/G0YslyIO795Gks+VCt31j4BcPwOU5Mkdg3g84U+bCgiudKcUQcY1ndibkWA0iUhtajQpoO4/MtX0vCyWKVkdfBAZXQHoOAZ/XphxwtyD4A==
X-MS-Exchange-CrossTenant-Network-Message-Id: b460ff53-0fb1-43d6-c539-08df0ef15843
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 04:09:44.1790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JnJX+XEYJyCTUgG94gLEK1XWhIG8RaXSXISygihmHEkHvJLnn6sZ1M423xBd8mHNlnvJB6ezjpk6xP0XFkjjuFus8PnScNewQbNjlE00J8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR11MB9583
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> Intel Application Energy Telemetry (AET) provides event counts in 64-bit
> registers in MMIO space. For accurate results these should be read with a
> single 64-bit load operation from the CPU.
> 
> In preparation for the removal of the separate CONFIG_X86_CPU_RESCTRL_INTEL_AET
> configuration option, move the X86_64 dependency to X86_CPU_RESCTRL.
> 
> This in inline with Dave Hansen's proposal[1] for an addition to Linux
> documentation that details the state of 32-bit x86 support.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Link: https://lore.kernel.org/all/c6ab0c24-8931-4f0d-9be6-23498ab4c38b@intel.com/ [1]

[1] -> "# [1]".
For reference, see "Link:" description in Documentation/process/maintainer-tip.rst

Reinette

