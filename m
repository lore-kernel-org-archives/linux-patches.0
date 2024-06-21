Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970C53C0D
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 01:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718935025; cv=fail; b=IxObrh3LLwoppXnfZVYKEwb553hVng++Mqipu6dYdJGWDMifLeNA1d5Bpwn4BJzJPz+Cd9ZdPVY4G/z64w6lkdxVqCJQdB5ma04Mhc/IlEhbud3Kbra7Dz8oo/9qZRY2tcDqiLTB8BQ0WorQCtO7DKNZHLbxIGIZgMbYqAymDzQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718935025; c=relaxed/simple;
	bh=MOxh7Ddy+mGHymgNF6iidHaf+IFyiWRx4rEMm8Jb/iY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jyVuBHkE3cyAGkz+40ehXV02QD8w9gddxWR7zjXtmsYWwoaOq5by/qe3dnX+khZ+dEgxUXlY7fdvWcLzlvEBCtnye3R7ZEdbeqpP1U08VHe478fW9MX1F3g2icEYYDcWDb01jQmnaeS3CQidzQrfvp6SFNUytf0TpqnmBGk45I4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GmzjUHR8; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GmzjUHR8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718935023; x=1750471023;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MOxh7Ddy+mGHymgNF6iidHaf+IFyiWRx4rEMm8Jb/iY=;
  b=GmzjUHR8HdDhqkE1bNxCkYTVKLedEvMOd7x/KcH9CUkfEyDFsfF/JPBQ
   yDSspnabECT+tc4poyi+ayRk8wMgTkQWiMerzctIVws5/XOgZVEF1X9f7
   4+WxeX8l1TRmeZ3Vip7CCxz6bWXb0fIvN1i3XoYjuTzGP5BSig+3ngC8p
   Iv+bmVeBJS9x8N5YCS/iywSwq/ZpDRm+fwCBDinCXb/7huongJdzimv4E
   5jIYQlO2VUqGchjbg9Q8QfTtJS6EksBStLkY9A0aNbkpOfaPi7aUT9ViI
   xcEy+iHgUYpn+9FjBISs/tt40fCw8JmZqlj3nU2uf/KFULEPV6LzDqV3G
   g==;
X-CSE-ConnectionGUID: XWoo1Y2cQ9yzLXwYCRN4vA==
X-CSE-MsgGUID: 6oHceUnsRP2ZPq/8A2JALQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="26583626"
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="26583626"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 18:57:03 -0700
X-CSE-ConnectionGUID: Cqq6so5OROSm3SFnkafP8Q==
X-CSE-MsgGUID: umX/DPDBRLW/10t/ZYnt4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="43134672"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 18:57:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 18:57:02 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 18:57:02 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 18:57:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mS/x9ynGu6zjTqMp/5gX6xh7KcCZNZE4w5f8GJWllTDU79zCEtJJAdZfH2S6tJwV9BuGAUzd1ytU6z+WqilnsdrcI9Ol/IGjBdY06lWfeSih9cGg8Webzs9X9Uvuk7fTopKLRAFENT8mG9c4vInE2goOxhj610ASzIEDUG8p/g0kTawNyh1HHZRik4iBl472JtgX0MuoBbPyMI46d4u2XpsisqUzJVs/nnVsAYzgCpvuZkkIhOpvf+km4rHYmSAZPD6LsoMOO1eKZkicWE+t7JsQcBMQMIS3WTyIS0dAU1f1SD4q0zoMkn+DgMkzUWoZrwYusmtQfoEyOiiskHjjwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPi/SDcY/yRIbeu0iNEMMByr/mZh4S+v+wx27yMnXOY=;
 b=XDixya+50UbHUtsFShnjc6T7dAgJa1COXVqf0nxM5YatKokZMT5xqp2IUntNRGnoR9gUKZdNf3s+H1sTPfTgpUKcKu7fCcchwLFqZoNOI4s79P/l+/evr5cLloPOMt+yVC1d/YEXrx0KDUpvwycPhoJlOMCt9SUBGV9Ypfe90MHiKb/7T23TbucPBAemayvfeIs434VInPRDOC1tUg///atXw5yNPmesy/SMgduQfTvMBpB5DpWWcVYnrxbbV5kZkLeOd5QUQt5gG9ZZfHjNV2DCtbh2bxvlj6DYX4mWdqvExLHqZAq6uOJdkwUOMzsB6vSRT3f+2KeqkjdpYbXSqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5165.namprd11.prod.outlook.com (2603:10b6:a03:2ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Fri, 21 Jun
 2024 01:57:00 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Fri, 21 Jun 2024
 01:57:00 +0000
Message-ID: <74ed79c1-b024-4b22-9858-14c1e5284a20@intel.com>
Date: Thu, 20 Jun 2024 18:56:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 07/18] x86/resctrl: Block use of mba_MBps mount option
 on Sub-NUMA Cluster (SNC) systems
To: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-8-tony.luck@intel.com>
 <649913a3-0694-48b6-b4fc-0ec6e5e85bbc@intel.com>
 <SJ1PR11MB608342C2230D448CF27EAC26FCC82@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <SJ1PR11MB608342C2230D448CF27EAC26FCC82@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:303:8f::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5165:EE_
X-MS-Office365-Filtering-Correlation-Id: 34e0334a-12d9-437c-f45c-08dc9195703d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|1800799021|366013|921017;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?elExOGc3bkEreW9CODNGT2lyWFVJRGpQcmRrQWd2a25XL3l4ZDZ1OVk4TCtT?=
 =?utf-8?B?MVVJTHZLMEVwRjhKblBPL0JKTFlXd2xScytTUmlKaFBCK1E2QWFwOG40aTUz?=
 =?utf-8?B?U29iZmFsbkFOQWpxQUYwMjZ6R2tYRFBFVENBRDJ1SVUyKzFYMlpBM1ZjenpR?=
 =?utf-8?B?cHQ2dlhEbTAvYUdtektnQ3d3OWFTbmYvQ0dZVkRkY0lpTjBhUnpuSnk0MEZ2?=
 =?utf-8?B?SEltdThjeGxxK0E2UXVOS2U5RWs0VEtkdW96SXpxbFlqVFZLTVJnRU5uQ3N0?=
 =?utf-8?B?TlhlVWl5UnlQdUVnZXpXWGtsR1FnRmRQT1B4WDhnTDhoSWRaeGZjaTJnekR2?=
 =?utf-8?B?ZllpT091NE9MaVRYbys5NU1XKzBwNHdIK0pwc1h6MGxCc0paL2k4aGNuSWhB?=
 =?utf-8?B?NDh1SGVNcVpPNFp1RlJTN3RMNUZTNUpQSjFzS1ZsQjRiakRhRU5FYVM4TS9I?=
 =?utf-8?B?aUVQeGZnUXdxMnFIbnVKMDIva3NERWxUVHFUU1BiQXpjUWVpcEVzUklMR3hz?=
 =?utf-8?B?aGxHS1BEV3ZIeGxwb3BDSitPQmhudmhqRmdHUG1wUkFlNzl6T3RRMHlxblBQ?=
 =?utf-8?B?d0s2eURYNlRaNGFaQXRUSUNpMjQ2RFJRVUR5MlYyM29pVkRHdUdLU3hmQU5T?=
 =?utf-8?B?ODV2RmJPWnVQTExiczVFMHZZYkh3c01EMDVyemhkaG1La0RzbnE1emhTT3hm?=
 =?utf-8?B?QW5RR0xBZExOYVphUmkyK2p6eEM3ZDhzMlk4Mkg1dUlBL0RSdHJxTUlCRW5i?=
 =?utf-8?B?d2hLbGFQaWlFOXRWSG5yTWpKV05QY1EwZkZHREVXYmhmcjZCdllheXpZMFRy?=
 =?utf-8?B?VEtaemo5WE5zV2VWSjFHdWxNMUdOc0VwdnBuRkpaaEtiRzhocmNLNGtkV2JJ?=
 =?utf-8?B?QWIxUXlkZXhSOVgxY0FnQ0V5VFVzd0cvYzdzU3ZJaFNteGRiTitBTzNSZFVI?=
 =?utf-8?B?anZXV0hHa20xTnIyNkp1YVhuSUFUbzl2S05OK2hUUzdPOVdBSm1FS2I5T0dS?=
 =?utf-8?B?ZFp2Y3hodFVNMy9PZmE5aHV3TDUrRUpXYXNZVE1EdytxZ3hTdkdZaW5lYzln?=
 =?utf-8?B?cklOOXhpWW9PZW9nMFRjS0MzVU9BdDlidUFTS0cwc2RBM1pkYW5ybXZYSE9V?=
 =?utf-8?B?bTRQakFVWWIrQjlYa3dOZlI4dWNlN0ZJT2NLbmhEM3pXQ2FTK01SNVJzdzFX?=
 =?utf-8?B?WWxuTDhkcVk3dmlaTmVkV0xsM20reFQ1aXdyY2F4YTJycG1WSXUzb0I3dk1O?=
 =?utf-8?B?SnBrT2RnYmhXRVBud2N2c0toTy8vRTEwaU5WYnFLY09QeFhYdC9XRUI0UjFy?=
 =?utf-8?B?aVZjOUdBZklFeUNubkdLMlV1ZmgrS1g3V0RNYVNvMjhYcG1Vb0Q5Q2Y2bXV1?=
 =?utf-8?B?SjkrUEFISEpCUFJGZkRwdW96QmcwUXBaMGlRc0lnL244K2JKM1ZmU0xSOWJ5?=
 =?utf-8?B?cEF6NVo3d25JWGtBZVRVNmVvajFNRzIraHVNWkl6ZWF2YW1PS3dBRXh0S3dj?=
 =?utf-8?B?U2JmNGRpYnJ1VHBMczQ1NUhCa0pQSFFidDlqSUhmNk9PajNNT2pZY3lzMUZp?=
 =?utf-8?B?MUg0VFFmanVZS3BuRm00dS93dHBXTEl4b3g2RWVrSVVYenBvc0VNTlJYbmhB?=
 =?utf-8?B?YlVUR2lGSmlzZmVoalRST1ZtMVExR1lSaDk3U2JvUXA0VElkTTltRk9wSVQx?=
 =?utf-8?B?V2U1QWdHNkszVVZSS1I3U2dEWkhFK0VnMmVMQmhRVEdHUXVmbkR0VW11RWhS?=
 =?utf-8?B?NnR3VnNJTHYrU2oyc1Bxdk9zOS9LcXpIRVdzK1hOUS9XajMyU3FGWWRmTmx4?=
 =?utf-8?Q?hBWs2W2E8nOxJFPatcXUauMdhkOLIRRWcvotw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzRrYzJ3RlhnMDNlV3lyYit0WS8zR0ZDTm5sbXVjdG5QZjJISjBKRkkwOFBP?=
 =?utf-8?B?UHZMbXFjeUttb3FacHI0c1pNL1k3Wm9hbDN3WU5zaWZ2YXdPbHl6YlNFOTZs?=
 =?utf-8?B?SzVleEo0SFNaNU51bjJuUUUvK29TWEFsU0FyU0xaRGFqMkV6MFNjNVhwMkRm?=
 =?utf-8?B?bklEWnl5YkNuMXF3Mkx0cVVjZ3NkSXpXNWVvSTFmWi9HZ3k0VGJNSFNmUHZG?=
 =?utf-8?B?RzhKODhmZ293RzBSWlVabm1nU0JibWd2NW15UkhtTFlGL01HY29YcERra0Vw?=
 =?utf-8?B?d3RTUEpwSWIyVXNGZVg2b2tlTGVnT1V0VzF0ZlJlL3lia2FnZmppRDFEL0s3?=
 =?utf-8?B?RTFWWCtyMnRkNWt5MVkrY0puZ1hrU3FCS2ZjamVBeGdjc3lUaDNBMjlnOVJS?=
 =?utf-8?B?YVk3ZnlhTDN6YmY4eHVjSjVvSEtlY2QwK2xhWFZMRUNaMk9CSUc0K2dsVk5R?=
 =?utf-8?B?ZG5WdHM4dXUxSmlDUzc4TGRIWHpaYTVwVWZDdnRFVEJGK0t2anBCa3hYWU5o?=
 =?utf-8?B?MllQUEVKUm1WWm1jazduMFBPY2NhZy9HVWRUUkx4L0NFWityczdJd25XUHJn?=
 =?utf-8?B?TVJjUndnU1JDL1FndWw1WkpWa1ZnUnFMSlZJN0hDOTlja1Btc210YWs0Nis0?=
 =?utf-8?B?UkpSU2dFV0ZWR1lBZzc1QjR4NmdqdHJFeWFDQ1p1SmxFN3I4OGwvOVZkQU0r?=
 =?utf-8?B?azg1MFphRlY1V1Q4bnFFRGs5NVFxUUZqc0xNa3owT21sWWFiajFXd3BpZEI2?=
 =?utf-8?B?U3hXMkZUcklXVEh3UlR4VVN1bC9SbE5SODZQdkF4V2hOK1lPMDV4OVpwZmRK?=
 =?utf-8?B?ZGVZL2NLQlNyM0hRSVA4Ry9MVUR5eXQvSU5CZWgxb2dVb1NFcXNPTDdpeUpI?=
 =?utf-8?B?SENWRXpkU25aOTd0VXNRbERGTEsrdS9MWUJ4Mi9iWnowM0xsb05jVHZjY1hK?=
 =?utf-8?B?bWVzVkZUcmIrcXdQZnJFOWtDcGo1UVBjK3d4U3BTQWVyNkFkQ0FrWmVnMTNz?=
 =?utf-8?B?WHZHSTBVanAwSUNoRXhaVGN6OE9ZcmFsV29HVjlIeHRNM2VaS2hWdkpaa3FK?=
 =?utf-8?B?bWtUVFJlRGVtZUhhSkpKTUxqdFRaelc3WS9XVEI4WG9wL0dvQldXYyttZXhj?=
 =?utf-8?B?SFhIZDFPdmFDWTgyOGU2OTYrNHUzdjcyNjlmS000bTRLTXVWc3M3RjJBVVJ2?=
 =?utf-8?B?MEcybThrM0FGdEI5WmVnWENwb0tHb3owQTF0MzdBNHVndWE0ZlZoSWR1WUdi?=
 =?utf-8?B?MkFhSXdXUDJ1SG5ac3B0bllqcXIvdXVGR0JHR3NaeHdrcDZPY2IzeXhvOFdZ?=
 =?utf-8?B?ck1YZ0tGQnlBdHJQYzNqelhiQm5zdm44NkxFbEsrb2l0WjI2NHNSVWdnaVlR?=
 =?utf-8?B?K1JkemQxSFJaeW1qTVFhQUVOLzVnNXlxeWxJbFdCWkNIeXdQZ09DY1o5S00r?=
 =?utf-8?B?N1QzbXhLaDJqaXRscm1TTlRSQk40WTNPUVFQNDQ4S1lCQlhnRU9IM2V3TkQ4?=
 =?utf-8?B?dW1ZNGdQUHZuc2pHd0diZnFzR29GT2pHSStER0dVdmViYVpCNHZkbll3U1Vu?=
 =?utf-8?B?NnVxSFlOSEk1V0sxK0RmV2ZsejhUVGUrV3pLZk4ranNVdGIvY2J2MHppSHhh?=
 =?utf-8?B?c0g5K2Y3NWZNL0JjcWcrWkI5YXpqZjVJUDZiVk8reFNaWWV4ZDdBLzdZTFVP?=
 =?utf-8?B?Y0FCcFhYQ3lVQlN6Rlh5aE1JQWlsaGRweHFOOGd1Vmtub09HaVdrMTVOVjBG?=
 =?utf-8?B?OXZyNHA5bUI4cGptVDJtRUNndXNoSk0yaVNlUS9wR1pzbndhMjNGdjBVRmc4?=
 =?utf-8?B?K29WOTQvMWhxanhXZTczYzF2Vi9iQjZ6bk00UE9XTWZSbFJOUDQ0dzY2dStq?=
 =?utf-8?B?akJqWUYrT09EeHRCWTVaL0o4Z1doOUtJb1pzU0FwVzM4cGdQWlhITEN1K29J?=
 =?utf-8?B?eEx6MWxrY3owYU1SYVc5K1RHWEFNMjBOcW5UYTN0aVIzNVBqRGRVMU9HQkZu?=
 =?utf-8?B?dVBiNDllOFB0bm5ZYkcyMmZQZU93Q3FvZ3A3UWkrRnkyaHdxWUdkTFkzc3dL?=
 =?utf-8?B?eEhFODI0VnNyeTdDUXFpS25tSnBhU1NFTEZRYnRDQUhtUXlFMmRBSmExQU42?=
 =?utf-8?B?TUhHaUNiejJFL3U0R2pTekZsVDgwR3M1VkpwZXhQbzAzLys5MlUyZVFuVWww?=
 =?utf-8?B?aUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e0334a-12d9-437c-f45c-08dc9195703d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 01:57:00.0043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3Xa1If7VraH2S/cB/Tge6uiEn4xBojTFrA7EcaLFG3eLhBhNM8x9TWNctpZDxmrubyfBgRZ1WM6oPXOyTdwWH8v8nZ+1St7lAs3nt2zBaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5165
X-OriginatorOrg: intel.com

Hi Tony,

On 6/20/24 3:07 PM, Luck, Tony wrote:
>>> When SNC is enabled there is a mismatch between the MBA control function
>>> which operates at L3 cache scope and the MBM monitor functions which
>>> measure memory bandwidth on each SNC node.
>>>
>>> Block use of the mba_MBps when scopes for MBA/MBM do not match.
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>>    arch/x86/kernel/cpu/resctrl/rdtgroup.c | 4 +++-
>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>>> index eb3bbfa96d5a..a0a43dbe011b 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>>> @@ -2339,10 +2339,12 @@ static void mba_sc_domain_destroy(struct rdt_resource *r,
>>>     */
>>>    static bool supports_mba_mbps(void)
>>>    {
>>> +   struct rdt_resource *rmbm = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>>>      struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
>>>
>>>      return (is_mbm_local_enabled() &&
>>> -           r->alloc_capable && is_mba_linear());
>>> +           r->alloc_capable && is_mba_linear() &&
>>> +           r->ctrl_scope == rmbm->mon_scope);
>>>    }
>>>
>>>    /*
>>
>> The function comments of supports_mba_mbps() needs an update to accompany
>> this new requirement.
> 
> Will add comment on extra requirement.
> 
>> I also think that the "mba_MBps" mount option is now complicated enough to
>> warrant a clear error to user space when using it fails. invalfc() is
>> available for this and enables user space to get detailed log message
>> from a read() on an fd created by fsopen().
>>
>> Perhaps something like (please check line length and feel free to improve
>> since as is it may quite cryptic):
>>        rdt_parse_param(...)
>>        {
>>
>>
>>        ...
>>        case Opt_mba_mbps:
>>                if (!supports_mba_mbps())
>>                        return invalfc(fc, "mba_MBps requires both MBM and (linear scale) MBA at L3 scope");
>>        ...
>>        }
> 
> Line length is indeed a problem (108 characters). Usual line split methods barely help as the moving the
> string to the next line and aligning with the "(" only saves 4 characters.
> 
> How about this (suggestions for a shorter variable name - line is 97 characters)
> 
> static char mba_mbps_invalid[] = "mba_MBps requires both MBM and (linear scale) MBA at L3 scope";
> 
> rdt_parse_param(...)
> {
> 	...
> 	case Opt_mba_mbps:
> 		if (!supports_mba_mbps())
> 			return invalfc(fc, mba_mbps_invalid);
> 	...
> }

On 6/20/24 3:12 PM, Luck, Tony wrote:
>> static char mba_mbps_invalid[] = "mba_MBps requires both MBM and (linear scale) MBA at L3 scope";
> 
> checkpatch recommends "static const char ..." pushing this over 100 chars :-(
> 

How about something like below that reaches 96:

	case Opt_mba_mbps:
		if (!supports_mba_mbps())
			return invalfc(fc,
				       "mba_MBps requires both MBM and linear MBA at L3 scope");


Reinette

