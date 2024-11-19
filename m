Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9785F1D12EA
	for <patches@lists.linux.dev>; Tue, 19 Nov 2024 17:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732037805; cv=fail; b=ViLQWcevlXUR0NYCo3kwp1LaM/aoffQMge2a25LfXsO1HhJBuPWr/giDzNTkl5oGBQ7TZJJ2Hn5UMQYDC+CdQa9AJ+JiSdXwFknMJ02xVUOnSpOQdRQ4rgxvrwqCDCVb+CPNadF5fYzvy7oh45BD1iugCt5gSe80+WHLSQqobsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732037805; c=relaxed/simple;
	bh=b1lBXw5zHzv0bfoHo72nUrUfhr8kuKivJ0dEFS1Qr8k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eLftneFuPYeu73wP+2DIsbiiIZU9GPD1om3AkhaXTlhrZsGMaCXDfTk+cdK9K55hB8kb+XDoVzRVMJTICmXui32J0sUq48aI4/8x8J3QPSHy5l7W+rJQEMqYNRjZjNSjrRctTO892R3zodDUNYFWR9Y6mMbG0jldQgBPQDj+EVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bKYh7nDq; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bKYh7nDq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732037803; x=1763573803;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b1lBXw5zHzv0bfoHo72nUrUfhr8kuKivJ0dEFS1Qr8k=;
  b=bKYh7nDqFg5jUhOQuSEHwizBXLkHByqW1sMPNku9V+Iwb9yyLqLAlYXV
   a0usAUjevvMKjpViSyIyfswVqgrw+xLqapNKzMb7HySOL/Wngn26vk0mQ
   W9498ddKabjFs+6+RsTA/RUugY9XDsIeBQpAFCLVSaDx+wVDiApu4/hAc
   IphA54Wcp4nb67AI2o6B20SQKDTeippjDIHFE6RuCUnovpXMe+4nTzKss
   ToUJ9jXLHfSUoFzL3LjJvVLgb/ngllMeAtUYHkVvJUFgn5Em3RHp3STM0
   jN1QdtC0AyUo3T6QWEBqULoXHoQZ3chV+3IglNQv3+B7nvG7iO7jW+H4V
   A==;
X-CSE-ConnectionGUID: 9hsiFx7kTRKCjXRRifB8DQ==
X-CSE-MsgGUID: l7A2EX6hQ+miRfVB9rh9sg==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="32304162"
X-IronPort-AV: E=Sophos;i="6.12,166,1728975600"; 
   d="scan'208";a="32304162"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 09:36:42 -0800
X-CSE-ConnectionGUID: clj6hqcvQXOEZjSt3wmNfA==
X-CSE-MsgGUID: PQvv17L3SFejXGKxobuF/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,166,1728975600"; 
   d="scan'208";a="120500971"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Nov 2024 09:36:42 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 19 Nov 2024 09:36:42 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 19 Nov 2024 09:36:42 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 19 Nov 2024 09:36:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k8xDglmziGN7E/JJL1ce85+z0PXyKUzpY85JbA2B4FoPU9j8qu1xSlu0QkvEzBL8gvtO8WobR/QM2MHW1umG9a3omKhTpGv0/vehd4GA38TW4VAhs9iKrmvMIgRmPUJ8qfR80H2YnAoKKyqUfDmMlgL7TJkiUnOLeWVrr/nFkPbKKWtZCEG2b4VtaOHHhMFXUHI9SY72KN5LZtq5iJzqVbfI9PBDCjhtAt7v2C+TCL3tvgqSkiy06x0l1sx3GVmaNBbSjOdGLEzklXGY5dv/2Ttrf4r/wuUNQVq21Rg+gOn9fHe9Z+fJXs770NMYQoIAdttY8htsyL5c9mr0thjodg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2oktoy8KJh9hHkKENsb2v0pqUdyj2MEafr3cioTNH0=;
 b=A9OOoOJ/u5NT3h32qfReeVygoM2BmpXNryOsau4TE3wE9JZlsJQgrbLhs1GVpb83yxf/9wUHemRgk1M0N67wLb+aa4DbdxCTctLfrwIVD18ubdHkRb3dBIWxL75MDFoskEQwiC40j7v8gkW3kPWKNmXNmgmFL67Cz7wbvk5dOuewCxNcUzNabFKJipVuCCFACimsVILl9pPuBMPKeT+/wbZzkoJNokccrM0W/EGHx5WSt8qAaMeOsH9YV6h5vD7W0VJI/bO1GH3mnYKJ9k1F7auWVKH0NnhNEuwgo4YgapWP0sX924NIDDW37fa/d9T/trE9gl+GoNcK9xMzTfjj/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by LV8PR11MB8724.namprd11.prod.outlook.com (2603:10b6:408:1fd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.21; Tue, 19 Nov
 2024 17:36:23 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8158.019; Tue, 19 Nov 2024
 17:36:23 +0000
Message-ID: <c6b173b3-1434-4406-9cac-428a65b8edf9@intel.com>
Date: Tue, 19 Nov 2024 09:36:20 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/9] x86/resctrl: Modify update_mba_bw() to use per
 ctrl_mon group event
To: "Luck, Tony" <tony.luck@intel.com>
CC: <babu.moger@amd.com>, Fenghua Yu <fenghua.yu@intel.com>, Peter Newman
	<peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>, <x86@kernel.org>,
	James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	"Randy Dunlap" <rdunlap@infradead.org>, "Shaopeng Tan (Fujitsu)"
	<tan.shaopeng@fujitsu.com>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <patches@lists.linux.dev>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-4-tony.luck@intel.com>
 <b4b31f4f-7f09-4ee3-9373-6ffe5ea859a6@amd.com>
 <ZzvVSamxTo9QSWBU@agluck-desk3>
 <e6b74022-5066-4cf5-aaee-5a70da9701e4@intel.com>
 <Zzvtj8n1_ukhnRWT@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <Zzvtj8n1_ukhnRWT@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0239.namprd04.prod.outlook.com
 (2603:10b6:303:87::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|LV8PR11MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: a583d76d-f769-49d4-8fca-08dd08c0afa2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ekJZSmtQWERxZWltbTdXaWk2YkJkWFczQWlNazFBejhrN3RnbVNCdlBKZ2pY?=
 =?utf-8?B?MmpMLzdXTDR6cE54L2Y4aS92ZERlVy80QmNISzVHcEoxaEx1cGtRaU9jd0g0?=
 =?utf-8?B?Nm1FMTRJaWVKaEJkQk5WcWtiSW5EKys0TExQeDNwbFBXVy8zY2huak11V1JQ?=
 =?utf-8?B?RTg1aUV1TmQ2djltZDRmNHM5dnNRME1CUlBBd1l3NjRMSElldWRXclNqYUVC?=
 =?utf-8?B?UithWFowdlMveXBQaEM4MzFEZk9YWElRMFBpR09yaUhRNkRhcWt4SXcrWEpV?=
 =?utf-8?B?S0dGSjhXZGUvVk1rVU5uQnUzcXZOZVY0eno1MVAvMUhqd0JIK3dTTGtJM0Qz?=
 =?utf-8?B?WGNlVkJGdlMzSkJtMk9HbW5CWjE4S3RKaXFLMWtPZXNya0F5TlF0aWQyazdl?=
 =?utf-8?B?aGJubEhJZmlYWlhyQXg2VURhNTN0d1U3aGtGUW5ENGk5Vnd6cUFORkF5M2Fq?=
 =?utf-8?B?Y0VhTkRlUjFqR0ZDRTdxQlNoV1hXSlpCRmNOS1Y5N1h4UzdrU1VhRDc2TGZj?=
 =?utf-8?B?RkJBWGQ2Z1ZPUkEvSEUvdnJoRHFyS3dic205WDJuY3BwSFVON0cvZ2FYYTNz?=
 =?utf-8?B?dzZ0cFpXcUh0MlRLVmNJTTdqUzAweVBSejRnWjQ4MU95TUZYc2JNOU8wMzU3?=
 =?utf-8?B?YWxqOXRsdmxjTGdMRG56dDhzenA1VFcrK0pScGgza1VrdFVNb1NjazFrQVds?=
 =?utf-8?B?bDB1RUU2Nm1oUVBzYlE3ZjZhK0NvS3RUUzlkRVRQMC9ubHQrSmk1UkpVVnIx?=
 =?utf-8?B?VVN4ZWk4Tlg1MTB5RDdRdXdPeFJRZnpnSTZGM20vMVMvdXgzUmZhNDVlMkFD?=
 =?utf-8?B?bE42WmJLYVo3YmtjbHZSQlBxbXk4R0wwT3E2ZzIxRVJJRWRzTkh4WjBKRkh1?=
 =?utf-8?B?U1RQVGZQSGtteXN2U3ZUZjJxY0M4dVg4Sll4V29JdGJtdVBYMVVmcFE5UFd6?=
 =?utf-8?B?OHpSdGlhTzM3THpaR29seDZJZVZmank1ZGhnSUhVdG5lVUFnVW1sQk5UNFhQ?=
 =?utf-8?B?RDlVT0hHdVorandBN0pxMGNVOWEybWZWNXZSSG1oY01NZ3c0dHdLWHV1M3dy?=
 =?utf-8?B?bVdnZW9YTWs1L1BacnNCTjhYaTNSdTBCOWRObFlEYTlnRVNPOVVDNjkvbG5M?=
 =?utf-8?B?eGF2elU1OUxhT1FWamUwU1lCdjZjUndEY0UzZlVVUCtHQ202QmhhUWEycVph?=
 =?utf-8?B?Rkc2dEthZ0V0aWExVUxZTTNucVQzSDBPRDAyUkNrK3lEVDBwaEliL2l1L3dm?=
 =?utf-8?B?V0pTZWtnbC9aTDNoNTdYY3RCa3p0UjZhRVdtU01acDgvVUNSMml4SUpXSkV0?=
 =?utf-8?B?T2JCZUJhbnR0a29nOFV5ZGJtaVBMQXZBY0pubk45Ym13eTRNY0M4WkZpL3VE?=
 =?utf-8?B?ak9RUVhPZWdwYmV0bms0WnpxMWhObmtwbzFsVnBnaEJYZC9NeHdyTE56cTFo?=
 =?utf-8?B?emNFQm1yMmpBTkk0bkdTc2xsQnI0UlhsQXNqQ2ZZSUN0Z1JQOEs5TjJyRWd3?=
 =?utf-8?B?ZVd3VlpsMzN5UmlOdWRMQzUzbVQxbjJxcjJ4SXd2QWNGelRERzA1cnF4ejE5?=
 =?utf-8?B?ZXpWdHVnelNya2dldnVPQzJKVVl5Y3JWNVhxK0VES0xnemJiTHpqcGJ4SXlO?=
 =?utf-8?B?WFZ4K1UydkhLSWRiZStVcVd2LzJzcUxUNXdrQVlYZk9CY25GOHF6Yyt6K1JK?=
 =?utf-8?B?M0c0MWFjOTM0ekhUT1NKRWxKeENJSHhxT2toVG1lMStBenhKd2x4WmwwcGVv?=
 =?utf-8?Q?GiMArN4EQlOfMYmGzI4rhd4744ZKBydpl0ZnrX0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dU1IMmNWbUNDdHhzWlFvTGZrWStBTDR1SkpjL25aQzRwQ1J3NkNDWEpQa0V5?=
 =?utf-8?B?ZTFiQWtzQnVaUmgyeDFPZVBpbHlEd0pvekd6QzhaWjJTSXhERVFBbm9vRDg0?=
 =?utf-8?B?eGZ6VUJKT3VLWFM2OTUzYVZmeWw5V1N5T0NLRkVDeGFYQjQ2bGVIaWduNUpv?=
 =?utf-8?B?UlNjcXNYVHh0dC9hZGFjNHgrOHNEeFAxTGJGTGN5aWpveG42YjRHeGRlMXZT?=
 =?utf-8?B?RkdIcEoyM1VuOXliTy9ma1Rrcks3Y1FQTVU3dERJVkpGNXpzREN4bFRjbldt?=
 =?utf-8?B?SDFzejduNTViTUxNZ2xyQm5KVEVnWjdhSjc5N2ZPeFZHQnBaMDVpNEhoNXNC?=
 =?utf-8?B?c2dqQVNkWEhicC95TUpnOWwzMWNIN3dhODhHSEZ0WUovVkdyaDJPd05RUU04?=
 =?utf-8?B?c2lYSU9zUWRNUGJHOVpHUEU4VFBGZDljVDlxUDZHMDZhL05IU0JLVHpCRURy?=
 =?utf-8?B?cy9jV0RNeFlHc2ZNQjhCSTY1THJJd0VBdDhYZFpFM3pxdldrd0RtZWMrQWJY?=
 =?utf-8?B?aFowRldaKyt4MFM2b2JTS1llY1NXdktJMDkzaTRNODZ3Y1ZJZ1NCRVRIdUlr?=
 =?utf-8?B?SVVNaGxiTnBEcmlLd2ZCUWZrS2hMVm1xY2Y0UzBlQndteVdyZkQzTXpBMkVZ?=
 =?utf-8?B?RjUrWVExSmhMcG5JRFQ0OHZLRVZHaG1naGtWWENUdVo4eTZlVnZDU2pOemRv?=
 =?utf-8?B?UmNyUWVIYnR2dncvaGdwVG5Bd2E5SmtLR2xXYTViMklnNFp0Y1lTZkdxbzk5?=
 =?utf-8?B?Y2ZnUW00MHMxMVlINEcvTGVuZStkRjJRajlTdm0rZ3p1cVdCT0pJM1g0SWVD?=
 =?utf-8?B?YzN5K2lEbyt4UW15dzFHbUc0RFlFajdVRUVqcmwzaDE1WEdlVzRScyswQmVJ?=
 =?utf-8?B?NksxTU52SWlqZnFFM0xnQU0rdGJta25QdW5MMGxCa0FqaTBocjhXMDMvbVVO?=
 =?utf-8?B?cithOXBtMllhakRPemh6dzB3WFA0OEV0SnovVmtNcjZVaVF2MTRGOHpKeHZI?=
 =?utf-8?B?ZDZ0WnhWVmlzWkNaVERLNlpjRGNjM2RSTEYwUkcxV053SHNoOURGRGVWUW9D?=
 =?utf-8?B?OGZkVHVaZUNoTW8vZE9HZEFqZ1d0UXh4cXliQjFaTU5ucXNoNmhBTForMHBP?=
 =?utf-8?B?cnJUdWdoYVljNC9NSUI5aVp6enlNU09YNXJ6cEhCeTlHWUJyUGE1N2lNeG53?=
 =?utf-8?B?MnVMTnlrL3FZbE5DbG5yS044VXR5STZXSXdGRDNxS3M5c3cramQvU0M3bUJM?=
 =?utf-8?B?cHJKdDhYNFFoTHZ4VHdKWmlCS1VIZVBiWnk5K1p3U1lVSVlKazhZM3R0MnJh?=
 =?utf-8?B?Sk5iSFNkemZKNkF3MU9HWFZhdHFSNjFGdnRiTDU0VWVkTWRGb21LdGo3ZXNH?=
 =?utf-8?B?OE45bnROZHoyVldaQ01BQjRPQjFnNk82SVBhRE0zWE8yR2F6RWtYRkRHdDV2?=
 =?utf-8?B?Z2ZUWXEvRFdpZ3JqSkFsaHRNRmpPUEJaY0o5MEQ5c2ZaYWNoVEVQRXlCK09B?=
 =?utf-8?B?dnlZdWV1ajhraGNyQ2JjRVFTeVpBRXlWZHN5K3VkWnZxWHJrdXY5RkF2L0k0?=
 =?utf-8?B?YjJld2NsMkVIZDdVSUFlK3dMVG9IZnVsRVhWWmdEQ0szRDlRcnFXOURsTGp5?=
 =?utf-8?B?SDJuc2tHWUJTdTQ3OTBZNG8zT21adjN1U3lWaTR1VDRDa3FURW9Zb2VWTmVF?=
 =?utf-8?B?K1BBMnJiTW43YTdna2FkTWV5ZHVWbnVON3B2V1pmVVJPNFRFNnJSNkRpQkxQ?=
 =?utf-8?B?QVh1cVBlcVg3UjVyYVBOWGhMKzhRaUFDYkowOVBXZnNCMzNsSnZhN2pDc0FQ?=
 =?utf-8?B?TEZ5MnRscmE3bTBoZG9LV0hTK0VTNWlEc0szaUZhcy9pQncvSlhsWEw3NEpo?=
 =?utf-8?B?NGNkUEY0emtYT01DSjNoNWFiVlIrMks2RUQ2WFNkZzVYZ0VtTndIWGxQQnhF?=
 =?utf-8?B?VmJReTZVb2F5a0I4RldTakI2am1UMEpTdFNMc0trYWRPekdMNGZpaFJQbXZ5?=
 =?utf-8?B?cEpZcTltb3IvS1VtZDJ3K1draVYxNkQ3TWU3THYrclhQUG9IQzlLeUxYdTdq?=
 =?utf-8?B?TkFuNnBPcUpRU1kya2RobW00TVZpRXVwL0RoTFF1cENUN0MrYlhHcWR0OXJO?=
 =?utf-8?B?aXZCaXM0V1NvaExqaHc0R0JUZy8xLzIrUkJUS0xYbkNIRGlHZEh5aEVLd05X?=
 =?utf-8?B?RVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a583d76d-f769-49d4-8fca-08dd08c0afa2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2024 17:36:23.1518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y38XvAr6pk8mAcTTdij7ZPHFs5U40oavD6gZJSTVXqSko8XVam8PUnZlgUnU7tpr+IyoVlbQqdrb1zZn9zXK9MgF78LIa9Ff4pXG+TGJzDc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8724
X-OriginatorOrg: intel.com

Hi Tony,

On 11/18/24 5:44 PM, Luck, Tony wrote:
> On Mon, Nov 18, 2024 at 04:51:38PM -0800, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 11/18/24 4:01 PM, Luck, Tony wrote:
>>> On Fri, Nov 15, 2024 at 10:21:01AM -0600, Moger, Babu wrote:
>>>> Hi Tony,
>>>
>>> Thanks for looking at this patch.
>>>
>>>>
>>>> On 11/13/2024 6:17 PM, Tony Luck wrote:
>>>>> Instead of hard-coding the memory bandwidth local event as the
>>>>> input to the mba_sc feedback look, use the event that the user
>>>>> configured for each ctrl_mon group.
>>>>>
>>>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>>>> ---
>>>>>   arch/x86/kernel/cpu/resctrl/monitor.c | 23 ++++++++++++++++++-----
>>>>>   1 file changed, 18 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
>>>>> index 7ef1a293cc13..2176e355e864 100644
>>>>> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
>>>>> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
>>>>> @@ -752,20 +752,31 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
>>>>>   	u32 closid, rmid, cur_msr_val, new_msr_val;
>>>>>   	struct mbm_state *pmbm_data, *cmbm_data;
>>>>>   	struct rdt_ctrl_domain *dom_mba;
>>>>> +	enum resctrl_event_id evt_id;
>>>>>   	struct rdt_resource *r_mba;
>>>>> -	u32 cur_bw, user_bw, idx;
>>>>>   	struct list_head *head;
>>>>>   	struct rdtgroup *entry;
>>>>> +	u32 cur_bw, user_bw;
>>>>> -	if (!is_mbm_local_enabled())
>>>>> +	if (!is_mbm_enabled())
>>>>>   		return;
>>>>>   	r_mba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
>>>>> +	evt_id = rgrp->mba_mbps_event;
>>>>> +
>>>>> +	if (WARN_ON_ONCE(!is_mbm_event(evt_id)))
>>>>> +		return;
>>>>
>>>> I feel this check is enough.
>>>>
>>>>> +	if (WARN_ON_ONCE(evt_id == QOS_L3_MBM_LOCAL_EVENT_ID && !is_mbm_local_enabled()))
>>>>> +		return;
>>>>> +	if (WARN_ON_ONCE(evt_id == QOS_L3_MBM_TOTAL_EVENT_ID && !is_mbm_total_enabled()))
>>>>> +		return;
>>>>
>>>> These two checks are not necessary.  You are already validating it while
>>>> initializing(in patch 7).
>>>
>>> I added this in response to a comment on v7 from Reinette that evt_id
>>> wasn't properly validated here - in conjuction with the change a few
>>> lines earlier that relaxed the check for is_mbm_local_enabled() to
>>> just is_mbm_enabled().
>>
>> right that patch had an issue ... the "initialize" code hardcoded support to be 
>> 	r->membw.mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
>> without any checking and then the handler used a relaxed check of
>> 	is_mbm_enabled()
>>
>> On a system that only supports total MBM the is_mbm_enabled() check will
>> pass while the event used will be local MBM.
> 
> In the v9 series I believe all the necessary checks are made outside
> of the update_mba_bw() function itself.
> 
>   update_mba_bw() is only called when is_mba_sc() returns true. Which
>   is the value of:
>   	rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl.membw.mba_sc
>   which can only be set if mbm is enabled.

At this point in series mba_sc can still only be enabled if local MBM
is enabled.

> 
>   So instead of changing the check from is_mbm_local_enabled() to
>   is_mbm_enabled() it could be deleted.

Perhaps ... at this point in series without guidance from changelogs I am forced
to dig through layers to deciper what patches aim to do, how they go about it, and
how complete solution is built using these individual cryptic pieces.

>   rgrp->mba_mbps_event can only be set to QOS_L3_MBM_LOCAL_EVENT_ID
>   until patch 7 when the user can select QOS_L3_MBM_TOTAL_EVENT_ID
>   or patch 8 when the initiialization code can pick TOTAL on systems
>   that don't support LOCAL.
> 
>   So all three of the WARN_ON_ONCE() calls are unnecessary.
> 
> Should I drop all these checks in v10?

I am still trying to decipher this code and will aim to address this.

Reinette
