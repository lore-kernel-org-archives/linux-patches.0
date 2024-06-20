Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7361380055
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718918924; cv=fail; b=Exn5NJH4t9ysBt6OHPzGIwsClkCJmRJBUR3zZYeDAaxkpTPZSsJH1EMyuC3rMtVsf/fFLGDt+129CRnDtnQbkSWTlZlx8BZGyBUw/EaOfDWCtA1B3gIUoVKjsReyXVF8xXTUY+UP4VdIC62DiUIBGjxGCSZ+Wz8Oytfy8jkgEH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718918924; c=relaxed/simple;
	bh=5yjVyPZhFwNIc8G2Sh2FUp55Lg3ovv+yLT1QW4GLYqE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mcyMYQ230j3rDRX5gxZT2wSBz45eeOjvpHy68sceQuJxSxUN2p3eUrZJ4Yh8Qb+QA+7dBElzMiU/bHr2+L/Zw2x6lP/bKV5/cj4geFahZzz94C4zmBeTEhyQdX3IsjkSQkwwVci2gEsvdWFRTftmHmRVDt4+apNncOW0PKAxsSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SqIIbLqs; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SqIIbLqs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718918922; x=1750454922;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5yjVyPZhFwNIc8G2Sh2FUp55Lg3ovv+yLT1QW4GLYqE=;
  b=SqIIbLqsV73GgGnumVEmliwdpiFML2DaSO7y6AW7RZYTe9CPe8Mb4q+E
   dWVXwTnuzbUcsERwBJUDWnMYAoaQNmsK0JdnoRo4ydFO4qzBueOsHkDnC
   QTb3211cOZ6n32I8DbXbxpJi1v2+T1yxssdvCoguTyUq4a1NNMs0LPclQ
   LQ72lc3NNeS3aNEo6qGgVL5d/H16Vi+iR4CHEuiHZ+VkUweNnzPVSnxnZ
   24bFt1ouZVLDIWFjbRLaizsK8VYpESwbxZcf+rZ4FX5gBdRXpKgH1pgpj
   UjVVurwsIjg32PlIEEjfDUnj6vCOKara2n8rgrh8JCgYQTBGYfgjBbVrQ
   w==;
X-CSE-ConnectionGUID: Rt0C/tlPTeKJ7tD30WEIpg==
X-CSE-MsgGUID: bzuq4GWTRW6Fzxzqza7Bgg==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="16073626"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="16073626"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:28:39 -0700
X-CSE-ConnectionGUID: DNVpKarRTw2ErNK/Ui62uA==
X-CSE-MsgGUID: el8wAZFwSmiHvbcaDUEEdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="46898947"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:28:39 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:28:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:28:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:28:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:28:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHulW3MiqIIOMdrhw7ChvLDtofm5wBblIRuhrDA0XQXFrvaUtS3gattGFxS8zBAxIiP+iGGQCJRsYpN8chvLC6Zrb7sKyktFXYXt8UQH4NGKMuIlAEFwMpK71ic1NvakRu9ZzMlrEMfojRj2KSPx+9ZWOMquKVokDPcw11PI8cEFoImLZg1n3sfHKQ3X32G//saNF5edhCqdLaEHLLn+JzM9kWUsNDtftxrd9IZKjAZSvrpbCCzb3EUh+bFZ0m9ApR3uEkWPR+3vYa3HYGH5vy1BIY1BJs4QjejjKeZ7M/nGsSNrdEFuWAURqmCJbQssuH5tA9Kf6YExRyFBCpk77A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9C3BRF3kDIkXBfMEOK+nI30CAgK4AbzN4jOXdb/Zl4=;
 b=epTDSZkHUp/i6cy8VBGG1E4daYA8XKSSNuLRKMfzbMKHiarqu/6jcFDrbnxKzMK+Gm+oNpsi3f66UTAV1kJezsWhd+gK/Mhdtgfnna7CiLP98ko9R0vRWXB1GW/yVjCwsQEcqq9tA1H9MOTqIKvYE7pi7DuOZYwtBR1L0g6gpmD4sutJswDZg9nO1TMtil7xYDf7I9gj7cBxr5Gw460TKo+MBglbTD8jM7u56H0vV7a+ITF6GMi3GxYNnelog2pS159BcslKspZ74k/OL0I0nyBRo2KOQPxK6g1mBpWgrGSJBy1cZ1rFibDTI4ro2PEAEx9/FtClIZe4y5jWZiscCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA2PR11MB4937.namprd11.prod.outlook.com (2603:10b6:806:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Thu, 20 Jun
 2024 21:28:31 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:28:31 +0000
Message-ID: <cb4e0dc2-aa32-464d-9c3e-d74413479926@intel.com>
Date: Thu, 20 Jun 2024 14:28:28 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 11/18] x86/resctrl: Allocate a new field in union
 mon_data_bits
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-12-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240610183528.349198-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0022.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA2PR11MB4937:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f4d5219-7dec-43e7-9be2-08dc916feebe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|1800799021|366013;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Tm02bjR3QmdHSEZGMjVUSWtWanVLd1B0STVUcWhnS3libDMxRmNvU3BDRW1X?=
 =?utf-8?B?RlBYOUlMQTBYeDFLL3J5TDNESW5zS1NzUUdTdFAxNW5TVUw1UHpvbThPNGxj?=
 =?utf-8?B?WlY3ZDZRenZtUVpsWmhyZ3Q5ZXlMSnpHUFhLWlZDUUw1aXFZb1VIYzl1dWtP?=
 =?utf-8?B?emdyeDBmR25xWnc5c3JRVjd3ZmhZZmo2OHpEaGJPODV6M1ZzcmJPY2dBYWR1?=
 =?utf-8?B?T0tZYWd0d2FNeC9INGNEalFKY0x3dTlWTVhLSVpZajJQck9aMTNhZ0RWTXNT?=
 =?utf-8?B?dWI0ekpCSFlBUmJRY3lUeXBYU3pwZG9ZaE4vYjhtMTMwcTVaa0JBU1lXNVBn?=
 =?utf-8?B?NldDNWt2MHBlRjgvbFUwblhTNjZVR1EwZVZFY0p3bEdmeDZ2N254TVZmRGpV?=
 =?utf-8?B?Sjltb0p0SUprNnRhcTdQdTV5Mmd2aHhYRWRrblFHZlNzV3FqRmdvRVFmSTl3?=
 =?utf-8?B?dy9EMEN5emZqTkFPVy9tMld4SnRSYjljdDNoTVhCVWNaWmNjVW50MHltNEdo?=
 =?utf-8?B?d1hvbkFGdUpFZU9obDlBb3JPSU5IclNNUGJPT3ZpdEEvZjdOallNK0lTRXNX?=
 =?utf-8?B?MENhdDdRdi9vNzRkVGlMbVlZd3lPRjErOHpqZytuNmFLbkFJVmFKSUw5TXds?=
 =?utf-8?B?ZGp2TVdHcVd0R01NaEd2TmV4dzE5WDlWamZyVldBUVpxWXJoRWUxNHQ2VTFy?=
 =?utf-8?B?SFdOckJ5dDE2MjNjNERUMnlVVExVbVl4YmtXVzIybkpqQ0FTNmVLSmtVR0lE?=
 =?utf-8?B?UEdiU202ckJhMmJSVTBST1ZacGJBb1U1bnFad2FtMHljSXdaSFR3T2l6R1F5?=
 =?utf-8?B?VlZLYWVaYWJBUXpaYjN0WnV0NStaWDF5ZG5UQWc4QmpFbGRKWmIxcUJhYURK?=
 =?utf-8?B?cHdxRmRqY1BFRFM1bkZISmVqb2puSDhyelVDVkJQZFRLSFhMc2t5OGFWdE94?=
 =?utf-8?B?MHZ1Yi9TeThlNW95ZmM0ckxpSFVQbTRPYUEySXNRa0MyVzJWMXYvNTJHZGFl?=
 =?utf-8?B?T3ZYNDNqN0VndlR0Z0lnVGpvblFmajk3bFFwbjNSQmUxT3NDOFFwMWFGWWVM?=
 =?utf-8?B?RUZhRzFUZitDaEM3MTEyaGdEalJyaHd4a2FRS3lRMnJDYzlpelVrVU4xRTh1?=
 =?utf-8?B?T0pvM3p4OFA2VUtkV3M3UnhkRnc0OFZrSjVjODdUSWVHaTJhaWtFWU1UdEIv?=
 =?utf-8?B?YzhTZk9iQnN1MGxXYkl3VTJGT0FBMXVYZ09TclRwQTYwdytTdkVWQm9hT2lW?=
 =?utf-8?B?M29meTVuaWJNUXVmbWlGQ051YzgwbTJFRU5EUWFFK1hKbVE0UkJjV00zbEtG?=
 =?utf-8?B?MEsvR0dhV3RHUVY0OEJaczZLVkpxODBWU2FjODF6Y0JzTk1QejhPSlBXa1U5?=
 =?utf-8?B?cUpTUExGZ1VaT2w3RUxGYW5tZWptaFU0NWY4U29ZUlRYcG5oVUZSK1A0ZXFJ?=
 =?utf-8?B?eWhqNTgwTTJ5QVVYckk1Y1d4WHRUUERyc1c5TkpmUStIU0pBMjQ5OWFNVVFF?=
 =?utf-8?B?SzhWOWtXWVFma0dVYkY0SU04a2oxNnB5UW5wVUVwNjNoV2pERk5IQ3YzQUxw?=
 =?utf-8?B?WXA3VERDblBPaS84K01VMFJGbzZlYlROclZYTjJRQlAvMnBzVnZ0NEI1blFz?=
 =?utf-8?B?bXRXWW1Hdmx0d0dhR0hiMkw1T0NjTHc1YmQvOVlTamJaYzJYZkliQVN2VlM4?=
 =?utf-8?B?RTFFYnM3bnNucEtCVDVobU95L0Q4N2lNNzF5VWlJSnVTRDdFZXhuNDNoKzlO?=
 =?utf-8?Q?eSDzJK1BuvZ166tmIjQfe1IVIu/o8su4lSJnoPY?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHZGU0dpTXRNM3U2WkhLZTFMOTBsMUJmaTArN1ZxUkxJUUlGU0RCQXc3MVMy?=
 =?utf-8?B?TkFpVWcvV2EyOUpuckgzdWIyTFVoaXEwYVUxc1RMQlZ1MjJhRDNxMlFrN3BJ?=
 =?utf-8?B?VzBjbllKdXJUTDFFZGpQckZxT2NNYjVIZHZGS0JRc2pYS3JwKzd0Um9OVmJ0?=
 =?utf-8?B?d2hkdDI5TXlJMUhwMmM4ZTdCY2lzclhOWjdGQ2s5STJML1BDSmpmVHhuQVB4?=
 =?utf-8?B?ZVNrNXU2N3dpYm11T2pRT2xacGpyWFBUSXZDbmNLTUtYMzF1RnAyR3JwdHZ4?=
 =?utf-8?B?V0Nhb29YMnZudGkvVzF5eG5vTVV1anlOaEM5T3h4ZG1IR3RteTNYcHQxc1px?=
 =?utf-8?B?enA4SXpWWjhyKzZjQ2d4ZXZKaGRBZ0dlZXhCc3drUVZ1N0hhajdpVElnK053?=
 =?utf-8?B?SGlFcStuNHlBRW9hTGZwYm9UYzZqY2VKazJocGpwU2hQd1ZKSGJXN1NSOXpu?=
 =?utf-8?B?V1dORTJRYjRqQy9iblU1OHVIT2ZMVjR4b2dkQXJwK3lhU3FxM1JxcDl3YUM4?=
 =?utf-8?B?RXZ2QWhZVjlsMm5BakM1M0MrejZLUFN0QTBYaTh4ZnRrZDhIa2tkdkdFdzFZ?=
 =?utf-8?B?Z1g4cnRLeW9EWGFoOXVVeEFCVXB3ZXhJN2pJNVk3Y2RnQ3JoOVltNXN3am5R?=
 =?utf-8?B?eDYxNUdGckVTZm83TU1JdERRaEtTVkJkWmtTVjlMNUFhb0NCaHdtUUk5MkdE?=
 =?utf-8?B?ZVFQVWhRU1NGVmRNNVkyaVFzV0JTL0hQc2RBTUdmRW95R1Bva0tBLzUrcHY0?=
 =?utf-8?B?NUlTK0F6N2lvblNyOUdpREZBY0IzbENzZk1pTk9saGtIZEQ1eUI4WXNrTkQ2?=
 =?utf-8?B?M0t3bGR3YlpIVHBLblNtMFI3Tm0yYWJTd2ZjKzNhTFlHY25OeE84MU12WStE?=
 =?utf-8?B?dGdNTCtHVUlqSTZlZngvM2dpVFd1dTF1U3VmS0RHblhoUFl0bUszN3BuejBP?=
 =?utf-8?B?ZnZOT09JcUQ2aldDV20wb0Rram1BWUxhRU1NWkU1SXAvMUc4M212RzJCeDhL?=
 =?utf-8?B?bXhUOEMvWExsOUFyRkdHbUIzQVRkdFlNbHJXejFrQkZGeTYza2NiOERIYkEw?=
 =?utf-8?B?cVVDRzZBRUIvTjBQM0E0MTlaeEtIRkZLYmozWVFaZzQrT0xGcGsrVk9iY3A3?=
 =?utf-8?B?dk5Uc3RqT3A5bjFWYmpaaVpMNHJNT0IxdzFIUzM2TTFPTklWOURRaVVnNTd3?=
 =?utf-8?B?em9IaGl5aUFnSjhPQ0lSRGFFS2JESFpCV2dpSlhkZTlmc1lQNStrMEFDMWEx?=
 =?utf-8?B?VW5iSlJvWHlzVVRkSXA1TTc0dDU5V0tIWTdDbWJNRGhWUnF1V3pJRmFJNnlh?=
 =?utf-8?B?K0w1QS83L2dZVzdoNjhKVFFTaW9QYnBxTHJZemUraVpPNDRYdmh2cE56Mml2?=
 =?utf-8?B?MUtZYVdwMERDQjBrT0NISEpqcXNGTWhWcS8wUWJFZ0RpeHVub2JPZnhFdzUw?=
 =?utf-8?B?T1YyWnd0b254d29tQ2VLVzl4WW9IUzhOZzEwakFuWmE4dXF0ZE11dmwrazNo?=
 =?utf-8?B?VFN1SnhDUEVqcFNyWTB3dmcrdU9TU2lVeldLOVh2b0xxbm92cVZFditaQm9R?=
 =?utf-8?B?R3p4eTh3VDIvMlkwNjAxOWsyYk56K3NhUUNSYW12WU90NmtlVUFSWGp6bkU3?=
 =?utf-8?B?QitHY1hkK0I1NkNSNFFxdTNtWTV6LytqeHZjV01NM1cxODkyL3ZMOFJpZnQw?=
 =?utf-8?B?NUFhOVFibk9PczlkMFNhMjNUck9iS0NPSDFTeHZoQS9JQVVvblFLTE9yQks0?=
 =?utf-8?B?MURlcHJlRk1kaWJhQ1N0UDJQOVdSMGt4N29lV3h2VHNFcEdwRy9uYU5Fb2NB?=
 =?utf-8?B?bTJpT0dQWWhqVFV3VjR0cUNoOW1HT3dQcUNwTEptNWROWWRjMy9jYmcxOXlF?=
 =?utf-8?B?Vjg4SUV4VFNtVzVWQTZyajljbks3MEVDdElUc3dySms1TDE2Qms0Q3JSWVlu?=
 =?utf-8?B?VEhkMGc1ZnN3ZG1qZCsyTW1UWDZKQ2NQM3dKUFR5NkNiWTM2YzJnVmFTem5C?=
 =?utf-8?B?bndVM3RHVGplU3VJRE1uK283UTlDM3gvTzhXdWlrZit3bnAzWUowRkpqTitB?=
 =?utf-8?B?T0tSQXpHd3REM0VDU2JVTWQ0WG1iU1JvTHovYmZYaXkwRzM0cStLd3dlcE95?=
 =?utf-8?B?T0ttUEVyZEl6UTBLKzJYNUMrY0ZhM3Z1OTFCOXBhaThzcUNZNHhCUHJ1eXNo?=
 =?utf-8?B?UEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f4d5219-7dec-43e7-9be2-08dc916feebe
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:28:31.3898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZvadOaEr4A4M58A1h8VPyPBuqGz9sHgQKPH7evyT661pfFIdTrZ1n0fkV25wOvYX1G943b0H8vuRCdZpGCBGbW1b7etibzt1BhYKeiZWpHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4937
X-OriginatorOrg: intel.com

Hi Tony,

(looks like we are stuck with "allocate")

On 6/10/24 11:35 AM, Tony Luck wrote:
> When Sub-NUMA Cluster (SNC) mode is enabled the legacy monitor reporting
> files must report the sum of the data from all of the SNC nodes that
> share the L3 cache that is referenced by the monitor file.
> 
> Resctrl squeezes all the attributes of these files into 32-bits so they
> can be stored in the "priv" field of struct kernfs_node.
> 
> Currently only three monitor events are defined by enum resctrl_event_id
> so reducing it from 8-bits to 7-bits still provides more than enough
> space to represent all the known event types. But note that this choice
> was arbitrary. The "rid" field is also far wider than needed for the
> current number of resource id types.  This structure is purely internal
> to resctrl, no ABI issues with modifying it. Subsequent changes may
> rearrange the allocation of bits between each of the fields as needed.
> 
> Give the bit to a new "sum" field that indicates that reading this file
> must sum across SNC nodes. This bit also indicates that the domid field
> is the id of an L3 cache (instead of a domain id) to find which domains
> must be summed.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/internal.h | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index d29c7b58c151..77da29ced7eb 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -133,14 +133,20 @@ struct mon_evt {
>    *                     as kernfs private data
>    * @rid:               Resource id associated with the event file
>    * @evtid:             Event id associated with the event file
> - * @domid:             The domain to which the event file belongs
> + * @sum:               Set when event must be summed across multiple
> + *                     domains.
> + * @domid:             When @sum is zero this is the domain to which
> + *                     the event file belongs. When @sum is one this
> + *                     is the id of the L3 cache that all domains to be
> + *                     summed share.
>    * @u:                 Name of the bit fields struct
>    */

It is not obvious to me how to best maintain consistency with existing
kerneldoc. Perhaps just let @sum not end in period? No strong opinion here.

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
