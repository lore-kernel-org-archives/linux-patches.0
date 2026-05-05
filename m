Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70EE3B7765
	for <patches@lists.linux.dev>; Tue,  5 May 2026 04:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777955990; cv=fail; b=MY1VYlPoqn+kDTr9pgkxLCWOpoiairiNyV6xlvpxJAzTbkcbQBaQ8/w4mj8Oz3uHHu0hvGVWOOAhumVZFug9d7jGNt6Vw6jcSrlDaB6l64SWMIeTkLGLBalzyZPc8/jI7aZ8hffD2YTdk3AmDsy8TEPbLF+d/1hLEmsp8TSSFeE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777955990; c=relaxed/simple;
	bh=vSsYczF3l5m5bWrnwKQwQilIuQPTQjFoxLc/U8fFCRQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VcPxOM1Y6olEl70K9WhwP8qTHeF58uXgJwbAM+fi9KAjYCSpPuuwmTVARBjN8bn0wlzyhiB3sFXchRR3Uc5Mv93o768+PVwhbw1jvIY29FksZUVQLURpeQgoEXQ2soOLGyFjTSbDPtons/DcAfWhQ5AKX4nm2g9NrXXIPk4S3QE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JyAQMz5j; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JyAQMz5j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777955987; x=1809491987;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vSsYczF3l5m5bWrnwKQwQilIuQPTQjFoxLc/U8fFCRQ=;
  b=JyAQMz5jvrVFL24JfAai2UpXof0Qev0QqK8QGE+4n+ophQ8vWtWr7Cj4
   BIuhvngzoAr1cll/EOCSLjxm5m5+F72i1XM0nG2QLzsqnMdyPZOwhstLQ
   +FZS9baCHTaUk04R/S3b68c2upISGVkUzfTwwcHpK4S+6OwdBHZJfBE0D
   KsddmNPXMti9NOgL7qG8tp68cG6RJavJ64KcfSPn9KLS4sWWu1K6vjOim
   epbNXEpjyNN8UVDf8FEVGs+x7BMYbsOS1VxjCQx/VUUPHIMru8NXhRsSH
   WhPizrVzQcY/nOCBm56AvHEhX3b8IxzrhQ+GReNBySnWb5VoVbQ1oCiH+
   Q==;
X-CSE-ConnectionGUID: 5Vf0oCu9RC+YHG+2kahkLg==
X-CSE-MsgGUID: 853pt+emSVaytsGg6WYxkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="77975681"
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="77975681"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 21:39:47 -0700
X-CSE-ConnectionGUID: X+IKi+dHRKaFEjFEZT80bQ==
X-CSE-MsgGUID: mhsBaHE/SiawApdAZvqC+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="234688826"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 21:39:47 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 21:39:46 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 4 May 2026 21:39:46 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.8) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 21:39:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vezakl4LXKoVnrmzasx+LeUKSIwOpAfaPKtASc9dlECalnCuGI9a9mx/WIzeLzSTPTLsINvTRuhVo1g0ehC4/lExXYsin8S/IvKYggjEwvep86AakNpTWW8QhCpVaVRQbTB+bEekBdIm1kJBiJCtwJOfYf7E0HXzYeRo7/bnnox/FaCUysdKEJjexEfncyfbPjEc9WSHUJrJ3ydCNZqIojzhdOrANZmMLUn1a2RCx1rWKjnLxwpy5QtAieK5NVh6Okwo0TxD+ikfif1XuRQH/5pyk4rlq04KWj/eslzczO1Xy0WhH8Th6oiaMWio4X6KZNUgh7vyURwHsr3Xf9XShQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZuhQCe2fEEkblrPzSQ1rgXl/693qX47OMifwObQjdsI=;
 b=aE7TzMbYc1J6jazXRGkgA76EWLTlUZrNeG3o8dYLInwEkzO32qBI2dYOAd/FFw6jyc8ch8NuFPzF2V40j9wajBGQtbtUUtCXYGu14Edykdn1hVrwNCfdSeLD+hradCsNo4w+bKCGYOEhCqc7I009rkY305JH1TRKAENumLWunqvffwhO4/2C3H82C+2aI8ezkmkfpuK1ovEFeICxRw3dW9Up77AOuivy5uY3pZV8SeRjn4sB/32nS3ilPd3TBXG9We8DZ28Uk6vOYFNma7XUAaiwwWIbCsyFTgH9n53h1xIBIWaP3p6234BQKh9ry2SqR4yAHFB3zL8pUqM7sAy3fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by LV3PR11MB8507.namprd11.prod.outlook.com (2603:10b6:408:1b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 04:39:42 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 04:39:42 +0000
Message-ID: <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
Date: Mon, 4 May 2026 21:39:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
 <afkizhrSwJkiLD3j@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <afkizhrSwJkiLD3j@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0022.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|LV3PR11MB8507:EE_
X-MS-Office365-Filtering-Correlation-Id: e889436a-1a49-4679-bcf1-08deaa605332
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: DoM1qqlQjU3yinT/Q7Q7AhXBsb8RklloAON3ghCY2V4EUY/LRf3Sa3TIo8GssT6PHOyX8Ls6/zitfPCpKPOrlh4tTEInGvoJvliY+twLOI5zy2f5QgpbNwWqNZSbzaLequ6isT21Ft/dJIeSFBWbtdNMuBlq8zlenvAwC2wYORUBh1NG3phnYkgGcv1UafZrNqrJPJnLcv0mtXuIH1jp3Bo6o4CjZ8uoiMsXVpDPwE7kxTe4jk1+owrbgeNdXIY2qkdxqGMvyaaR+eO5XpTlf781x1RDooq84n2Qeg2KqhV5+xfZAYAAW3FUOFiZ7A2ElQb0CnXR2AFgJrJhO3ZmmxTWvagk94qnu/KVOV1EUq1Es+EmPUnbJKfu25JPOdrRiXz33kgoOX0JR6FyjhXnnPyICX480160NoS4DOE2wy6qSCWvVYFF2Ff7IABGaO9D4tqTnVojLfoTjwY1ANgiYgzgXa7uQ+reQZithg+t6Mi59cXRjSoCa3gAyVDWk5vsPaRytzFIFUMShWSBQRYkMGZ3jektLkQA5SP58B46Ox529DVKAkBbs+9i/fDFHJRu3Sau4qS/LugTqCl+mGZLwb4fHtobovdZNicgKW5PlGPIp/kQ9Vi84UTIB5D33cdnCkmiQCHz+oFDmUWEBY/goA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHlYbmhEMmJtLy9FMzBtL08vKzBWSHRPT2FrSjhmbm1FdEZBMFUxREF0TVVW?=
 =?utf-8?B?RkJFd0JCRlRzUHE5Q3dkd0RTaS9obmZxYUlXc1RrNFRva0o1aUw5akpMZytJ?=
 =?utf-8?B?Zy9XWFc1c0oyN0gvOStMdjhyYjdHUnVKei9kSU5FMVZRSGl2eVVod092cHFU?=
 =?utf-8?B?YStialBqcU80RXllanQxOUpVcGYxNmFJTlVoclFCTzNKVDNQR21xUjBPeE1i?=
 =?utf-8?B?NEU1SU1aTUNUMTJUUUlsMitkS0tJSGtOM3lXNEdDTW1IY0Zwcjg5K1prY2Y2?=
 =?utf-8?B?RzcyQ2sveVV1MTF1UG9RdG00TVFkdWZoQ00yWWZndzJUNHdpVlRCZXZRYW9D?=
 =?utf-8?B?ZHdTOWlCTGNJalQ1NFVKRU5UaDRMekRLbmJTVk91VUlhdkNxREVqUGxrS3hX?=
 =?utf-8?B?QzRVM0llZWFSampQT3FodEZqTmhURkdnZ05RRVloMFEzSGN3SW5NZWpVZHF0?=
 =?utf-8?B?b3VZb1RNOUgwYW5mWDVuR0JTalNpMDQwV1A5RXdNamZGVjJCTmxldnU0TUVn?=
 =?utf-8?B?WEFOSVNoTlIrMXlqcVZwS2ZrYVEyeXN2aFdrbVEyZjlwZUVtYitxNklNWThH?=
 =?utf-8?B?aGlWMkZwNm5DbWFpNzBqdk1VUUNvR2gzNm5DcElxUEFXakxUMmlVdEFhaHZH?=
 =?utf-8?B?RnJjWVJ5T0gvS3l6K0FxejYzTWNmTzZRczIydEZIeEdvZ1ZpbWQzSXduZU9P?=
 =?utf-8?B?Wmhmd1RGTzQyRFl2cmowYjkyYUhneVR6d0NwN1Q2OHF5Wjlzc1BwNEFVN3NF?=
 =?utf-8?B?K0FmaUJOLzB4blp1RUh4NFp3Z0h3ZHU3bmlrdExCVUFTaHNmcGZDR1k3ek1a?=
 =?utf-8?B?ZnlIdXFhcDk1V0pxNyt6MzVwUWZPMWRkWTFIQXpvS1JiVzhPQ0g5Q2RpR24z?=
 =?utf-8?B?RUoxMFRDNTA4UFFTZWpIWVVjejd4bGc2UkJzbm04U0p0bklwQVc4TFdBTUpr?=
 =?utf-8?B?SWlZWE9ROWU2TlpPbEE2SWlST1FFRTErZmNxckZtK2xIWWZVTmw5bUY2bmJk?=
 =?utf-8?B?SnB6R0hGY0g3ZGxGbU9OYXQ3dW9WUTBJdUxNTW5pYkZtZWVqSlRBOWNCMzBT?=
 =?utf-8?B?NkI4SWJ6V2pCSTk5bC9JK2d4azkxbUhrYkpMcFJHNjE2WjFIMW5iYUJmK2Mz?=
 =?utf-8?B?dFgzSzI0ZFNOWGw5bmV6eDhkYmFtL2tqUTk1UFMwMmNuTmJWdUk2RjBDUzBu?=
 =?utf-8?B?WHo3cG12TXBpVGdxM2pYOHpaMkczMnhmQ3NCZVdFM01VZjR1V0p6QkNiRXVh?=
 =?utf-8?B?YVJ2OEE2NUsxNldKTDFlQWJCdUFTeFBVZTBTSVVWT2dEMC9URVZLb3NHMzFp?=
 =?utf-8?B?SlR2d0JiTXZBQTFuS3NLdng3TWE0WXpOWDFuTTVpWUE3QkVLZGNFdFNld1pl?=
 =?utf-8?B?MXJXZ2Yxa3NPc2F6WjNjMnRpdGovYWxleE4wU21PMGJzRnFlSHN3cmYrOWw1?=
 =?utf-8?B?bUsxSFlDS2ZaWWIrRjdVU0RuTXFpdkJsU2dEczZBcFkyTGdGWjlIUlRaSHRY?=
 =?utf-8?B?NkRrT3lVVFBQOGRFNjdWWFVMdE91TmErck1HUHhadkhMZkNQcm9EV2s5ZmlG?=
 =?utf-8?B?SkkvM2N3dlo4elR5YlBBcGpnZVFZUmgyWk9helQ1SzZCSUMyMW9FRkdpSWIv?=
 =?utf-8?B?MTdDb1hmTFoxd0ZjOUhmZGgrdUpGd2RTekpuMTJFWHN1LzJrSXdrK1RyRCtL?=
 =?utf-8?B?WE9INWx4N0VlUDVKOTNHZFpqaVkzd21oN1o5WjgzUEt4VllJTnpMc2MzZ2JO?=
 =?utf-8?B?OGZXdUwxMEYzcEZxWi9HTHRVQmhGSmtka01aNGlGZ2RITnQ0OWNybTRHZ21Z?=
 =?utf-8?B?enJxc2hESDVyb3JuQjZrdk9hT25LeVE1K2ExQnlMaUZrRk0vOXdpM2ZWZ3Bm?=
 =?utf-8?B?V3JCZWhWNTd3akx0cGwyUjFJeVJTNEY1NDZCU21xZFJaSUFwa3pXcGozQWl0?=
 =?utf-8?B?M21nSUtPUTBPVVo1M3ZMeGNMNi9PVTJ3bGRiYThmYXZROFFIU1FyUGpXUDY4?=
 =?utf-8?B?M0JvQVZib2cvTEdqVDVqNVRkVzNmT3pWRVVpRFZQb0dWRzJZSERqR1NLYWhn?=
 =?utf-8?B?SXRWYTB3Y3lxdEtTSE02YnM5S2pnNUIzQ2c3Um9YbUsrcFIxemJDQklkTzM1?=
 =?utf-8?B?NldOaHFRL0ZWUlFtSDVhNElYVmZIdzl2ajBzMFdPeUJ3TThWeE51RWtBMVd4?=
 =?utf-8?B?dzNoVkVzeXpjKy96aG1GOVRyL2NSTHVweDBnL0hKbDBpSHJpZzJaVGlQMUVu?=
 =?utf-8?B?R0NrbzdDUnpWNHZvRVc2SUtSVXlCNUh2YW9qRUh2bm1mQWVjYXlZZ2x4cTI1?=
 =?utf-8?B?Tmd4UFViWEErTXJvSzFEaSttNEsvSmFiODJoeGhsVG4yYW02UmNlSUhzZURU?=
 =?utf-8?Q?Mpl35rxnYnGQVJ60=3D?=
X-Exchange-RoutingPolicyChecked: NGGuPDc1ugyqvJsbBUe5jXg1rqFf7bx2Z+qMW0z8Xf70YHBEO+VhNuUF0WO8P5iNHK1qoWd94Mmehi02eZlQglounlsbtAFsW7fAB7xgkPdZi5jaZI0JgZN2b9qtgcC5T/O5H0KYjrJBLWUYHFWnXiv6Nsc1aHQ91cBseBel4sYh1CZoqw1Jv4XAgjPENN9loabGK1h9iafXVY4SJ2Z2Q1qCdQmcUrw1NYcIuv4Pm2d+a8H2u4UNZNXDd+LbJHAB/Pg4KJmtvJ4mXXspYAV4z2Lk4SdD9X1XlkIYVHzZU/mWENJXNM5OdC2swCVsTlkNZK0UHbCjpQLkGNGir3TqHA==
X-MS-Exchange-CrossTenant-Network-Message-Id: e889436a-1a49-4679-bcf1-08deaa605332
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 04:39:42.4063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qPih5WZKQF+5eL28/6qM37rnvvO98eohfk+FbnHPrpcJ9AqiU/IIkptMOg2fdfKcxDaMyt/ghScrd5KEmin1Qrs6kpxBO0aSjcYxI9QnCTg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8507
X-OriginatorOrg: intel.com

Hi Tony,

On 5/4/26 3:50 PM, Luck, Tony wrote:
> On Mon, May 04, 2026 at 08:11:48AM -0700, Reinette Chatre wrote:
>> On 5/1/26 2:36 PM, Tony Luck wrote:

>>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>>> index 9fd901c78dc6..e68eec83306e 100644
>>> --- a/fs/resctrl/monitor.c
>>> +++ b/fs/resctrl/monitor.c
>>> @@ -794,11 +794,14 @@ void cqm_handle_limbo(struct work_struct *work)
>>>  	unsigned long delay = msecs_to_jiffies(CQM_LIMBOCHECK_INTERVAL);
>>>  	struct rdt_l3_mon_domain *d;
>>>  
>>> -	cpus_read_lock();
>>>  	mutex_lock(&rdtgroup_mutex);
>>>  
>>>  	d = container_of(work, struct rdt_l3_mon_domain, cqm_limbo.work);
>>
>> Since work always runs on a CPU belonging to the domain, could it be simpler to use
>> get_mon_domain_from_cpu() using the CPU running the work to obtain the domain here
>> instead of the work contained in the domain struct? 
> 
> Is this true? When a CPU is taken offline Linux picks another CPU to run

These are workers supporting monitoring and they read RMIDs from where they are 
running. They do not need to IPI a CPU in another domain to read the monitoring data
of interest. Are you seeing this behave differently?

Theoretically resctrl could have workers run anywhere if the events being handled
don't care which CPU the monitoring data is read from, but the current workers
do not behave this way.

> any unexpired queued work. No guarantee that new CPU is in the same
> domain. I think a robust solution is going to need a check that the

There are a couple of places where the work is scheduled. I understand the
particular scenario you refer to to be the work done by resctrl_offline_cpu().
Specifically,

	resctrl_offline_cpu(unsigned int cpu /* CPU being offlined */)
	{
		struct rdt_resource *l3 = resctrl_arch_get_resource(RDT_RESOURCE_L3);
		struct rdt_l3_mon_domain *d;
		...
		
		d = get_mon_domain_from_cpu(cpu, l3); /* d is domain to which CPU being offlined belongs */
		if (d) {
			if (/* overflow handler currently running on CPU being offlined */) {
				cancel_delayed_work(&d->mbm_over);
				mbm_setup_overflow_handler(d /* domain to pick new CPU from */, 0, cpu /* CPU to exclude */);
			}
			if (/* limbo handler currently running on CPU being offlined */) {
				cancel_delayed_work(&d->cqm_limbo);
				cqm_setup_limbo_handler(d /* domain to pick new CPU from */, 0, cpu /* CPU to exclude */);
			}
		}
	}

From above I see that the new CPU being picked for the work *is* guaranteed to be in the
same domain as the CPU being offlined. What am I missing?

> delayed work handlers are on the right domain. It looks like existing
> code doesn't handle this well.

The work is also scheduled from resctrl_online_mon_domain() and then re-scheduled from
the workers themselves, cqm_handle_limbo() and mbm_handle_overflow(). In all cases the
workers stay in their respective domains.

Could you please elaborate how you find that the existing code does not handle this well?
>> This seems to more closely match the pattern used in rdtgroup_mondata_show() that
>> stores the domain ID in its state instead of a pointer to the domain and then uses
>> resctrl_find_domain() to find domain.
>>
>>>  
>>> +	/*  If this domain is being deleted this work no longer needs to run. */
>>> +	if (d->offlining)
>>> +		goto out_unlock;
>>> +
> 
> Claude seemed quite confident about removal of cpus_read_lock() in these
> functions. Sashiko is confident that this has opened up several new race
> conditions:

Domains are stored in a RCU list so if cpus_read_lock() is not possible they can also be
accessed from a RCU read-side critical section for which x86 do not have an example at
this time. This would look something like:
	rcu_read_lock();
	list_for_each_entry_rcu() {
	}
	rcu_read_lock();

The definition of domain_list_lock within arch/x86/kernel/cpu/resctrl/core.c has a nice
writeup created by James about the locking requirements.

I do not think cpus_read_lock() should be removed. Especially not since my suggestion is
to actually traverse the domain list using get_mon_domain_from_cpu() that will complain
loudly if the CPU hotplug lock is not held.

> 
> https://sashiko.dev/#/patchset/20260501213611.25600-1-tony.luck%40intel.com
> 
> Maybe we need to add a reference count to the rdt_l3_mon_domain
> structure and delay freeing it until the last user is gone?

I still think that using get_mon_domain_from_cpu() in the workers could work here.
Here is the idea more specifically for the MBM overflow handler:

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 88f1fa0b9d8d..7186d6d02d6e 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -856,7 +856,9 @@ void mbm_handle_overflow(struct work_struct *work)
 		goto out_unlock;
 
 	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
+	d = get_mon_domain_from_cpu(smp_processor_id(), r);
+	if (!d)
+		goto out_unlock;
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		mbm_update(r, d, prgrp);

update_mba_bw() is run from mbm_handle_overflow() and uses this same pattern
to get the MBA control domain which I find to support that the context is safe.

Reinette
