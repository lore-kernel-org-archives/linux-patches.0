Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EC3184
	for <patches@lists.linux.dev>; Sat,  2 Aug 2025 00:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754093222; cv=fail; b=D7HEprCYeAMJqgrm2r44ofoxlQj2eBooPMrGpGB+JZdbuOREY3qRqUM7pImYk6Fdgw/GwAtRlnqh/4qRwL0AE/DkDruPHyxHFy8wxch31+AEWjY7cyjsS7zh8SM8BN0MxDcCT3RdjJZUgx8G7JbpkhQDuxbnEIJP8atalTPktXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754093222; c=relaxed/simple;
	bh=Vx8PbXCAV89mdAJhwHWXBlNYhqIdxU2uP2OksZont54=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aP/UYYr0mrZpgSGOEmU/ncI1oCuIE8qFY+HjgFqVO433orY48AJxXlDiE2JqCL+XbqsBejbWdGwHxoBAYzEz/eZYPRpLCO0rJJcSJQ1Om6iK37MbwNUbKherxYIU2FS/JoMt/UuUYlgeWXun5BEAzrGAkZLoqI3UuDq2xnpnQi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gJ/6atWG; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gJ/6atWG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754093221; x=1785629221;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Vx8PbXCAV89mdAJhwHWXBlNYhqIdxU2uP2OksZont54=;
  b=gJ/6atWGsESjD3v2XtcBp5JNLsfQJBCLzR4iYMAk/iOU+6VN7/hUXF3W
   JM3YMqsrQATundZj5mzJeMzbGafjGfVHVam9nK6oChj9FHcLGeiOfJBIc
   V/niGGiJOp12LdZxVM0EZabLO5Na3LZmFRC6VM58qpq4akv8PtJ0Efrid
   FGTYsi3zcu010fXLY+tsb8zTHxGtf+TZg2m/pBILUr0XoHwZ/mInjfvpq
   T0a9UMeHUGH/djESD1guprVBu2Q/bZAyAiiws6Xi1GVbnkVpzv0Ky8yOk
   GSx3OA/tQserXXhZhgdeTzVl7D7EcH5uggfV3QYMxsSjkH80n89RbjRKo
   w==;
X-CSE-ConnectionGUID: O9meXgJES/KlS71LAOZYyw==
X-CSE-MsgGUID: 8ymj3vRXTPm2WVB3Kcg7Xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="67140964"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="67140964"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 17:07:00 -0700
X-CSE-ConnectionGUID: BRdtSDxbRfSI58WWb+7/rA==
X-CSE-MsgGUID: nubIyFftS0WOJqqkXao40g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="162972240"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 17:06:59 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 1 Aug 2025 17:06:59 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 1 Aug 2025 17:06:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.76) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 1 Aug 2025 17:06:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t6RJTYAyOoyCPHm418C9xZXGK1o8B6uNunrSUXKSrRmjTKjqnHdfiCGbUvZ57TG3IbLceS+5BjeDzDNzNPoismgNT33lDWs993nbLXELjlJp/nl+hzac92YKicwJ6uHUxQQDKPYLWEBTK2A4mmBJM14EJiprpsKn0MDmfuOpvOQ3r9QWK1aO9zqbQ72hixPG9R3ckLlkzHWA+poo/qPQ1xwqE67PE2RCR70qs/s1o/0KOX6lh4ikUWzmRUM9wjVeMAUYMz5MSN46ZrlXUa/ZtiXb3qzim07bHScxG1kUUYdhvcx+IEuZoXdqVYpftnSXaVcVrnM2wwyJgVX8KVp4Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+hXg48+rlw2ikBfxe2psOHGA6hdQS7G+Ny6/4S11JQ=;
 b=HqCA/1LTqa/DmU8xR+AKZQl2zpYSRaMjv2XzZbh7GBz/oXu2opKPaqbd22IAVT+bcemfGMuU6+y/mxWg1qgo03A2qzcS690YASWJ+zxemUzXt3IphIVhLK74NEklcaAJReEk0b6Cm3DhtxBwPpK4DMyQsO7oC5oxH6sQtEttc6xg2RiiXSBSMggyf3yk7vqdOs4pktYu/uQDdBVwvaZElkUqeAoUaypHQNHrC+U/ro6HF2RALmdbc8o+gnQrIMn/3B9Vq0qUqEcJ2wGwT0rvBPCq87Ce6vpkh/GmQJPQ3ZLXaP8A8PhqNVAXVqrG6fOrL0Y2pRyRIe3nGolHXbNARg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB3315.namprd11.prod.outlook.com (2603:10b6:208:6c::33)
 by BL1PR11MB5979.namprd11.prod.outlook.com (2603:10b6:208:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.14; Sat, 2 Aug
 2025 00:06:49 +0000
Received: from BL0PR11MB3315.namprd11.prod.outlook.com
 ([fe80::9c18:1e19:b200:3848]) by BL0PR11MB3315.namprd11.prod.outlook.com
 ([fe80::9c18:1e19:b200:3848%3]) with mapi id 15.20.8989.011; Sat, 2 Aug 2025
 00:06:49 +0000
Message-ID: <810fa3f0-8cca-451b-8bbd-b9bbabfe0b4b@intel.com>
Date: Fri, 1 Aug 2025 17:06:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/cpu: Add CPU model numbers for Novalake
To: Tony Luck <tony.luck@intel.com>, <x86@kernel.org>, Dave Hansen
	<dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250801160028.4799-1-tony.luck@intel.com>
Content-Language: en-US
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20250801160028.4799-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0224.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::19) To BL0PR11MB3315.namprd11.prod.outlook.com
 (2603:10b6:208:6c::33)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB3315:EE_|BL1PR11MB5979:EE_
X-MS-Office365-Filtering-Correlation-Id: 66d07db3-c305-4399-a43c-08ddd1587a0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QXBhWEZwejQySFVTTlRwMjQxSjdQdEdINWZGN0dDZ2dVQ20zRDJMeUpVdDNy?=
 =?utf-8?B?YklYOUR4MUxVVWM4cWY4VFZ6SyttNDQ1a3lMbGtxVzlHMlF1OFgvODVyOThu?=
 =?utf-8?B?WDBWL1RnRWRGUWh2NkNjOVRLMXZvWmRNeCszNjVNZUxpM25YcjlQd0d0WS9P?=
 =?utf-8?B?MDJWQzd0bVBPMU03YVM2WGZBMEd1UWRoa2ZYU3pYeTFMUHgzb09FR1lBSTA2?=
 =?utf-8?B?b1FBQ292QXRJQmwxelhIU2dYaURyQytXREdQYWRJYkpJN3pyN1Nzb1ZsR1NB?=
 =?utf-8?B?L1lmY0hlZWdQS09xdy94UXVjcUlrVjA4aC9Fb0JYcFZkc3BFOTVwUTd4SEpt?=
 =?utf-8?B?aFFCbEtNSVdpTlp3ak5JUFo5MFJjajNpRzJtYnJxOHgxNkVkdlZFZkg4UUJE?=
 =?utf-8?B?TkRvNGk1YXdaRXVqR0tXSnFwRThPbUdlNjhYVk1Nb2N0ZnRGei9GbnRldUdL?=
 =?utf-8?B?eVJGaW9HVkE5ZHVyZEN4a2JIdmFmT0VkdERUeVRxUW1lUnFPVDY2ckNSNFBE?=
 =?utf-8?B?K2E4TG83TDFYQUpOaS9qU2VuYWU5TXAya0pta3dyS3ZyYTJCYTQwRU5ESHNy?=
 =?utf-8?B?UmZxOEFSUVZHTHJqOUk4MnNPUkp0Vkk1Tng2VTEwRkRuTTFiS3k0S3lSTFlC?=
 =?utf-8?B?MXBNcnJsRUY2ODNCUmgyQUxZK1ZUZGJsSHBIbVYvUGRvbC9ERWJjSG4xQ0xD?=
 =?utf-8?B?MDMzR2RzU0dBWEVkV2pkRTBvdGh5U1FjNWhlV2l1ajNtemI3WU5uVGRUcGE4?=
 =?utf-8?B?blZuRVp2WXlkdDlXZWZJQjhodWJXcFhFbXJKb3ZrU1ZWR2UyZlZuSDJEbE5t?=
 =?utf-8?B?K20wWTgwQ3p4dzhTVktTOXZJVkdGVDJoK1FLS2JDRHVVYkVrVFZoZ01LRjlT?=
 =?utf-8?B?Q1ZXWk1uUWUxaWw5cGU0cEJiNm5rMVAyT3I1TDdJSHFCV0YwUnZDOUlPVjRO?=
 =?utf-8?B?aGlQTFV6NHI1S01jWjVQWE1nT1BWOVlrT3MrQXdsSGNCbzZQbVVubk5iV000?=
 =?utf-8?B?RC9JU1QwbDVNK2xtcDFlVUszdWZ5V3MvK2RiZzRTMlFGbld2ZEw2bVRpc3Fj?=
 =?utf-8?B?TmhDTlpuT1hFRlZwY0FVdWRzTjhmeWRhWENYS0VQMFM2b1g0MzM5Ky80Q0RF?=
 =?utf-8?B?WHpISXA0QUFhM21TeGxadk4rbE9MdThIS3JiZEZNZmFEbmlXald2dEhhbDdY?=
 =?utf-8?B?QlZ5b0d6QXBKVEF4QXppNzUySjNPV1psT0d2Y0RvMnByT2pCVDhlUGkrd0cy?=
 =?utf-8?B?cHBPeFlQV1hvK05XNUFRMCtsd3NXd2Vzd0FQbi92L1RHbE1SdHFYblh0dkVG?=
 =?utf-8?B?eTFrZXpyWG9aL3pneTZqVjZjN3JQcjFhdjZvUzR0UDlvM0F0MHppVTloY3JH?=
 =?utf-8?B?NTJ6KzF1V3NqTis0Mk5RQjFGcFpRYjFNWndoZHJIRDVaVENsMGFTenRpRUd6?=
 =?utf-8?B?UXQ2TGg4Umo3MkYwOFdJUEJUVFNPVTlHUDllUEZyRHJybnRMM2xQVUFIT0ZP?=
 =?utf-8?B?T0N6RUZoLzVqc2V2L3hTUCtvRUU5UTVCakhEUUxPYU9yUm5sdGJaMHU2RWRy?=
 =?utf-8?B?bDRPQmE3NW9IcmcwRjVwSm1uT2J3MXhmeVRNRWNaNWlTZ25kdUdNU216NWYx?=
 =?utf-8?B?N2NFT1FGM0NEcGMwSGhET3UvTFhxUnJPQzI0M2FTT1JhL0dWWksvV1NabElH?=
 =?utf-8?B?eEZHMTNkUGJ4cUJkV1RDVVhMK1JsdytoejFIZWt0S0hZc2hHb0w1Ny90d211?=
 =?utf-8?B?Y2I0b1QvNDRjUisvTjRXNzJGMHFpSDFGUG9WK084bWFXUUxWbDlTNU1CMU1z?=
 =?utf-8?B?b0doVHdFTzIvV2JSaDFvU2g0RGltU2pqRitTRGUxTXk1Q1RaY3dUNUxoQTlH?=
 =?utf-8?B?NjlWc1d0TkZVOTRKQmxrNmpYVGhBZmtEeWpmM0NabmhHVkxrVWpiaDBTSnA3?=
 =?utf-8?Q?TykbHTrewX4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3315.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWV1Z21DZVVJM0lEbStkSE5kUWk4NWxMamdwSjE4M29HUkNUVWkvV2dhb2ZL?=
 =?utf-8?B?WE5pNUJPMlcxN2tZWjdjZ1VXK3hObzJkQjExeWdsNGx5MXJ1UjlKZWRpdi9r?=
 =?utf-8?B?R1UyV0NXRGw1NURZNjM4MEk3RjFXcDRHWFJldzVJRERoeHhFVVZKczBRQVJ5?=
 =?utf-8?B?Q0ZhNXV3aDI0eVluVEQxN3B1RzVqTVdNOTVYU1JBaWJuOWd4bUdCelYvZ3Fa?=
 =?utf-8?B?cGdDUUpzYXlEcVdTdU9OS2JJZ3JqUGIzZENuNDN0Rm9udjFnT1NDTXh5S1J0?=
 =?utf-8?B?L2l4SmJFdS9kcDJRVVQ4OEtwVVZCWitWOWxiT0c1VmVDZ3dhUk5RaWlmVWxx?=
 =?utf-8?B?bmlRMTJTVjlUTFpEaEVSQ3pWcU5qUFVraVBySUdyZU9hWDdnckFpblk3Q2VS?=
 =?utf-8?B?bU9pUjlBd0hHUXNLbTdqYlIyK21PU1FaRkFqcWlJQXpWVER2Vk9UWTRRclRS?=
 =?utf-8?B?M200SEJEcmFwdkZFTHJtZVFhZUhFQmF2N2svM0tqMmRTWVBoc3VNR2ZPb1BQ?=
 =?utf-8?B?MGQ3NFNIY2dMeWFabzlZUFhTdEJqb2dIYld5aTU3WFlvQXRwczVTL2dUQjFU?=
 =?utf-8?B?TzVYbjhXcjhGNEZDN3hYL2NzRTBRVU9sWnZsckZqdU5pKzJNSzNCTFFCR3NK?=
 =?utf-8?B?UG1DYVFqUklOQVE3cHUyNi95b3VzMFA4ZXk4SEdxR2JlakNGYTBVWFZqcXNt?=
 =?utf-8?B?U0t5K2hjYW9scloxQTNselVtaGRuZExJd2YvV29QbGRiYm5iS3g5eXRrUUJG?=
 =?utf-8?B?V2NTUjlhVDR0dWRQbFVDbmxEQ3oveWY5dWw5b1BoelFBWmoxYjAxVHdxVlI0?=
 =?utf-8?B?YWplWERSRUt0bVFQNEExekF1YTJqZ2Vwc2dRWUx3WUlIUXM1V3FFSHgyN2pa?=
 =?utf-8?B?NVJieGpVR2V5SjRBVDVHZ1VMVVhSdm9hRFJqODhGTk5LNzYrK1dDOWlIR2Js?=
 =?utf-8?B?Y3plTnFOeldTckpaWnl1bWhVUWsrS2ZCRTZOdDVsRFdRU3VXMVpXQnVnUlZh?=
 =?utf-8?B?QlJ4dlZJQ21ESXJpcW9DZTRFbUlDT21zeEo4ayt5bmFPcXl6c3pEeTFZd3Av?=
 =?utf-8?B?Zmo4c2EwaituR2RKeVczVngzZUxwdS95SnoxZWUvVE5HUFplV2tFWWQzM3RH?=
 =?utf-8?B?Mzd2VmtlT3U2NXV2WmVWUmNsMFhpTDJOUmdaMTlvSU9NN0FoQ0N4Y21ySDJw?=
 =?utf-8?B?ZmxqaXVJcmg5YjJ1b3J6N2lJdkxwbTNCQy9aaUdHVjJNY3BOMDVpUXJFL2J1?=
 =?utf-8?B?REZQM3NHOThTY3hURm84c0JqNDhJRXJxL3lLN1pPNld2Z2RBaXUxemR5NG1q?=
 =?utf-8?B?UVF5OTJIU0swWlVvSy9ER05OdU4wNVJLVUNJbkpLdkxYa284Uzc4QlI5aWJj?=
 =?utf-8?B?SStXYWp2bWhaZU5DTWk4VVRhUlRzWlZrQ0Y4TkhsUnBjWjZ0SS9RbW5mMnMx?=
 =?utf-8?B?TE00bC9NTngwLzJqMncyMFBkTnc1bFRSTnBRR2piSGlBVHhLSHlVeU5sSXlK?=
 =?utf-8?B?WlUrdWh0RjgvSDZERXBVbVE1ZHJqMWVORTVZUEJwQXlVdWlGWXRaaGMxbTR3?=
 =?utf-8?B?UUc4cklHUUE3RFROeUx5RGU3YUxubGN4MEdoWDZZdjgyY0ZmdE4vZmVPaklZ?=
 =?utf-8?B?UGkyUHNrd3RBUExISkczUk9YL292bzB1OEFBaFV2K05jN1lxWXIwSVMrUzJH?=
 =?utf-8?B?S2FLVE5XYWgydmt5ZWtEWUF1OGZEQ3ArQnFLZDAyMUg5aFBvR0tIN3NsRXRY?=
 =?utf-8?B?cGJZNzd4UTNabytmeXd0MDBvVm9JSUVlV29zcW5tVmgxcndJVk1DRVM1SDRv?=
 =?utf-8?B?NFgxNktxK0dKMmFNWlYvNFI5TTc4ek1ueUJocFVXdkdDYitNQmNCYnlGL3Bl?=
 =?utf-8?B?WmoyQStEcnNiRXkrcCtzaXpmUkxLaWdMcmFHM0ZBZlZPZnZrSThaOTR5bG1T?=
 =?utf-8?B?aFJwZS9zU1YwSE5lTmFoK3JYT0FaTjNqbDExdVR3RHd3NkttZXB5OXdYa0NB?=
 =?utf-8?B?YkdmOWlVMEhEeThWcTQ4VmkvNVJhRDNQSDk0MS9Yb205NUpSWERVQlA1UmpE?=
 =?utf-8?B?RExnRlNpaDd4YmRDNFpRbnY0WjVTWTFmOE43L2YzQnRzcVdJSXMvL0RMMzlF?=
 =?utf-8?Q?rLG9lEkrn6FNS9DA+ZO7A4qTi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 66d07db3-c305-4399-a43c-08ddd1587a0f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3315.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2025 00:06:49.5155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 44/OoJL2hYaamOJBkLl8rDk6rnN/2A0efl+3Z6a2uZPMv0yu0EpiMBoxwqWsUUeGVbcEJvEr5UyL3Nw1Mr0dng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5979
X-OriginatorOrg: intel.com

On 8/1/2025 9:00 AM, Tony Luck wrote:

> diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
> index 5367dcbf5b30..e345dbdf933e 100644
> --- a/arch/x86/include/asm/intel-family.h
> +++ b/arch/x86/include/asm/intel-family.h
> @@ -152,6 +152,9 @@
>  
>  #define INTEL_WILDCATLAKE_L		IFM(6, 0xD5)
>  
> +#define INTEL_NOVALAKE			IFM(18, 0x01)
> +#define INTEL_NOVALAKE_L		IFM(18, 0x03)
> +

Are we planning to add models from newer families closer to their
predecessors? I like the idea of continuing to group them by type. But,
it would inconvenience folks who are trying to find a name based on a
Family-model number. (I guess that would be a minority.)

Diamond rapids (Family 19) was added at the bottom of the file. Should
that be moved closer to its type?

Also, the /* Family 6 */ comment at the top is now misleading.

Dave had briefly suggested ordering the file based on Family, but I am
not sure if he still feels that way.

https://lore.kernel.org/lkml/40538b12-5929-4f05-b65e-8b807057abd5@intel.com/

>  /* "Small Core" Processors (Atom/E-Core) */
>  
>  #define INTEL_ATOM_BONNELL		IFM(6, 0x1C) /* Diamondville, Pineview */

