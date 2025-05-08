Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217EB14D29B
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719516; cv=fail; b=TsX/b9MCG/JWhxRQ5u+9eCHIAEfmSRaN8toWyB8DdLC7dYh/CJQTJ2O+6JPSVFxUkZgOP44Z9JJ+Gllk+TAONLHxIUfSeUzaoWIUYfk+kx1MUE4RO8dMcA37oyYGL0Gznku97KhGSQw3Oi1tabgPS7Ul0UyD1UtcSGxnAsINWkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719516; c=relaxed/simple;
	bh=W5i/TDRJQcp+tiD73Zu72vTvB/LnxlxuEjUZ/K5q/Vw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PFpRh5bPVKYfMiEXob6gj1vV8vj/Hne4pS76bIJzwywRaKJtzuWhnxQAzqYNaiU+UetDsZ5KGdLcJkijddMDpb3ONwBz9WGnQygSw66wIqYemPC56Lo3y0Y6O4/SqY1ttWOxPAo0x/bm+Vkze4h70JjlQKMeqE9o6y1sjKtJUnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TXcSUpi9; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TXcSUpi9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746719515; x=1778255515;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W5i/TDRJQcp+tiD73Zu72vTvB/LnxlxuEjUZ/K5q/Vw=;
  b=TXcSUpi9ymuM0deR4g6Et3DpXRYR6KIqyqo3mpfLtezIw5Qacojtin3U
   /HXecxZVJJxd9pCvF3IGrYt48D3YbVn0GovVh8h9jxaaIi/EcyiCX4QyQ
   2H+x9G4TIgUpoRtRRu5EwGXttEHnqmoNPMTricSyLN1H2ffb1z6AnjvqA
   cmwHKT9aNl+xyCu/iviULSFr5MU837NU8kl3GCsc5xhotWqtK2i7plE/Z
   MVIVdzLvPfp6mwbzFhxSpwmTKF+MPiu+5SAR3NeX07ct+tdBPcTiuG6W4
   ikj+zL69327YNXHlcRAVQ0IthxUCktFbYc44vYRwlOfUFFaxrlOOKk1Pq
   A==;
X-CSE-ConnectionGUID: 5ZLeXZzMQ4GLmjX0IdKjDA==
X-CSE-MsgGUID: t8/h0zPYRz+ef4XcgSQZFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48222330"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="48222330"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:51:10 -0700
X-CSE-ConnectionGUID: FvHXAFcwQVGBlH6NRICGng==
X-CSE-MsgGUID: 5SiqNQqsTLixk28x006Vqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141454311"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:51:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 08:51:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 08:51:10 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 08:51:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=paFpOIll/8tRHXXtmQxhlGeIaC+0U00YS1D2htKjecDhmaqb/ccuD0sWJla/wfp5W7lMaHnj4Zd4iHBGVBW6e/D+vGtBqf1IWk8BUJSv3bhtdfNPXs4mDqkR6cEQ0U5vgBSwrWiMCWFZWB7ZXuUhEeeTjvFnJzm6aEDjSfDPVUR2AOhxW4ZQVSkRilcQNteinhW7ft7j50Fr0nnNrVQSkHKp9JHMRjzcFMNh2IxdchfYX161EYIqY+rI1WJYWFDofE3TFEIiH0cxHe9zjAZ78u4uRa5xNErw/N63NxNy62iRVhOzVtfno9d5lLxREWeVxj1TLX9pk6d1WABQFY6Bqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rl5hM2eulKKfQ1Bl6KwGAESKfY1l1gLfAn5BNRC2M88=;
 b=rQ76cws1Ex+32+A4YYtgNgEO529XUN8rwz/QIkjAtYqy1AJkoydaZ3QwzN+YajmhWznOj4uh6e8Mmhdg2FwciZuG8csa6kJYz3cVKdnUPghUuUpGixqHX6iQ4rtZwjR2eLRSgIiMbp7e9FXoyZDNt8MWh+azbcfH0EZ89TOJxfuaiR9B3ZXQz9wp6I8/92LmP7JTBUZXxjgQiSBtth7+fFJUblIbePP6yjEiE9YaU/YfNGdhkBOeERSV88vo4AhtrS1Vx+PzlOTJf239hM5XdTyPrtZDrHbPt0dMZPXYWmxwERFB7+0ng8jm7fXKZ5up27fFyRFl4pZh+k97Wn5D5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BY1PR11MB7984.namprd11.prod.outlook.com (2603:10b6:a03:531::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Thu, 8 May
 2025 15:50:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 15:50:50 +0000
Message-ID: <4200a43b-1304-4d72-bd79-a7df1b513874@intel.com>
Date: Thu, 8 May 2025 08:50:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 15/31] x86/resctrl: Add and initialize rdt_resource for
 package scope core monitor
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-16-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250429003359.375508-16-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0083.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BY1PR11MB7984:EE_
X-MS-Office365-Filtering-Correlation-Id: 16d3cadf-95f7-497d-654d-08dd8e481b52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dkJva0FrQ0FUR3k0cGdkRkVjVWp1bGtUNUpCSjBpSm4zN29hT09ZYnk2ZDJI?=
 =?utf-8?B?UzlxdnJDQXNiZzE4R0dtaGloZUllVXNkbUdvOTNBcnJ2N1pKZW9GQUwzZzNX?=
 =?utf-8?B?bDQxNUFmemFFN2Q0aytvS2cvU05KaXY1Z3p5eXJRaHZRSncvbEZSOXFNUU9P?=
 =?utf-8?B?S1BmZDV0K0dDSjVvUExha3dIdXNkYUlranZkOHJ3SDdGYXRva0swekwyU0h2?=
 =?utf-8?B?TTNKSDVoYXBiZ3dEaGFTMXY5QnhCYzl3cnBwbWJnSzMxQ0RLTmpZWk5RTDdy?=
 =?utf-8?B?b3NaYVp6TlRoZ2hKYVk0b0RueVVLeU5yYmg4MEtDNHB3Y3FrSU1TMk1ZNGFW?=
 =?utf-8?B?ajF4VVJSWXhzWDdkY09uTnZwS0ljTktQUEZSdEtIVWpqTHcxS3l2YXY4cDcz?=
 =?utf-8?B?ZVdkS0lJNEMxR2trc0tMOVBpYmtpSTJEV2dtaUc3YWJHZ05QWVRjbUIyN0VD?=
 =?utf-8?B?TWJYWEVFaHdXak1ldDkrUTBNa0QrT20wOEJ1QWo4YU1KSGpQRjBnVU9SdXU0?=
 =?utf-8?B?NzUvQjBYU1QxNUpZbEphSk9IWHphcUpEVUROWjBJMzZiTHppZHdlODluaHM3?=
 =?utf-8?B?azVwYkpjRnRFQnJqeEVrK0paNitDajNRZzluRytrcFBKb0ZzbUhzWHZ6T0F3?=
 =?utf-8?B?djMrbW1mRGRaL0tySGRhYS9TVnBUSmxMeG96RStraWt5cnlrTWtFYUZIblFD?=
 =?utf-8?B?aW1yZEdJNHFYUEJEQWdIb3MrY0VMWERoUlZiY0RidVFGYzMvZHRpNDBoWjdj?=
 =?utf-8?B?WmM2emxoTjlsY3BmVFVGRmk1ZHZmazhHSkcycmNOUGdVeFF3ajl3cHRObGR0?=
 =?utf-8?B?T3BwSjYveStuVzlOUXZpUitDa1lUS05ES1c0RjdGazI0Sk9qa0FjRnIrREVw?=
 =?utf-8?B?V2FLT3dYbXFCMjJpSXZpV1dGNDdhYlB3M1lZRFZFb0syeUhJYWYwZHE3YkJP?=
 =?utf-8?B?U1VNK2wydmoyaldmRlozbWo3cGNuSHJYa2hiYTloMUFybTVxWFVrdVl4anJ2?=
 =?utf-8?B?TGlNaXVBSDZORXduLys5bmQ5QkFzZmY5VUpTTUxPdW9NcjZDbXdjdEJteTdp?=
 =?utf-8?B?ZVluTEVqdWFpVFNJNXhvSG4rcldEdUNYakVKVUltZE5IUE1COWVwcDN0T3RZ?=
 =?utf-8?B?eG1qVkhodmJLUDkrVGNwZHNMM2x2dzdlOGp2VTdmdkJzL0IrZEh3NkREUXJD?=
 =?utf-8?B?R1Zad1RaeGVNSXQxU2FWSEx3T3F2N0cvZ3piZTI1TEpUaUZPNzluVU8wZVBU?=
 =?utf-8?B?Skw0SlMrbjhEeStQdmxxeFU1WjE1RnZRTzNVMGpHOUhUeCtEZnc4d3ppdjlS?=
 =?utf-8?B?SG5vcE8zLzJEd3NkNFBtTnU2K251bThiZDJKVEpxY1oxTFA5UWVCd1FjTFpF?=
 =?utf-8?B?bS9tclo3YUt6SXNVM1lLbVF5Ym44eHVGY0preStUUHN1dzhIWTJIL1FCeFBC?=
 =?utf-8?B?REJ5MUs3dHI2ZHpyeWNlUWp3SDkxU3N1VGxNZGNhODdsTkprRXU2d2VvbUdU?=
 =?utf-8?B?V09mTGdzRjdqYThWSWpRbnhxYWRrcHNtaTExTHBIcE0rS2NqRkpOY2p2bTND?=
 =?utf-8?B?VTJBQitpS1NXbGJ0QnRuNlZlblQyTmdZNW5xVk1aVmVzYTh5RHZycjVLbG1z?=
 =?utf-8?B?YVIrUDRzSDM0U0IwczdkQkJpMjJMS3pRK0p4ZHNJdkFpaTNNaGRTVE5UL0pp?=
 =?utf-8?B?MkxoclZhb2hhS0J4NmlCcUc5ckR2TFM3aWp4WlBrVkJ4cnFMdEZqOFVjMkRu?=
 =?utf-8?B?ZG9BUU5SdS90MVAwSlBDeFRjTUhNWmhKdWlBR0ZHSVVUTzJnTVl6U1Y2Tmwv?=
 =?utf-8?B?Z2hOME9TcHR0ay9vdlhDd3FUWTgvSHJSN0FjOU9vV0RWRWFnNWZHMEh5SFk3?=
 =?utf-8?B?RzhpellhdEpjdXlQMm52VGZoK3UxSjlIZURVUXltRTgzbU81WG85Q0d1Slg5?=
 =?utf-8?B?TjBIdGJRRFA2emd0YVNwc2pBWlBCOHFRUEVNYVRDWk5WbVRQWGtJYVVUbWFG?=
 =?utf-8?B?bURPTVRpL1JBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THZFWi9NOGZ0L1l2K3dXVkg3OWs0UmlCamV5VWFVaTM4djBleEI5MmV2L0xY?=
 =?utf-8?B?cE83RGU4OEdDNVU1ZCtYOHpnemIwY29tdDhQVkk4LytMNTE0M29wWmE4dC9q?=
 =?utf-8?B?Zmtxa2Jrbk5rV2ZGWU9MN1FqTVlDbi9NYlIxY0ZNWUI5dmg1dGJsNklxZ2Va?=
 =?utf-8?B?Nm5uR3dzc3BuN2tSVVcvdERPeVdkZXVWczRYcEpiVlpuejJpUXlkamIrZ0Fx?=
 =?utf-8?B?UElZNS9UdUpRb0grYVFQRG1WWDRVWFJhTWs5VitWNVpiTFF4QXZxZFdqb0xG?=
 =?utf-8?B?c2h6b0tzUStHbVF3ZzVMWnBoYzNTck1aNEE3Z0hIV3RwYVZrZm1QZ1BtTDVt?=
 =?utf-8?B?WGJZUFpwU1hwbGtxMEw5dU5wV1lqU2RWcXBGajc5eklBdUFuRjdMMGprano0?=
 =?utf-8?B?U3pWRmZXSEUrRlFUMzVDQk9ybDVja2kvd0dJK2VzaUY3UlBSaDd4ZWJ1UUhs?=
 =?utf-8?B?NVFsOUZTb3BFUFEvdG92QjhwT080L00rOEFkR1hLbEJHUHRMSVNrT05QMkJL?=
 =?utf-8?B?OW1mRThmVlZ0aXIzZW1GQ2U5bU83QWNkRGM1cXhCMWNxNFZJZitNT0Z6TDQ5?=
 =?utf-8?B?dEh4bDlITkxvc2RyUUNHenBiTDJUbG5OVjBvb0JjNHZsZG1aY1N3b0VTbmZT?=
 =?utf-8?B?V3lxaGN0RVl5SHlWbTdwT05iYy9NcTlFUW9vR1FhbnZHdURFTEFrL2FCY0Ro?=
 =?utf-8?B?eFFHQk9BVi9mZWJLZFdpbmY4cyszTnRBZkdQUHRXTzdyNEt4aWFTZzRWYU85?=
 =?utf-8?B?WmFjZW5kc2tYOTVoTUNJa3N4cmFHd3hiSzhJc3I2UGJtblZJQUcrREU5M0FV?=
 =?utf-8?B?WjB5L0JIYmNyQTF3VktRZTVDOHpDSERxcGxSNTVtOWhnZ0wxNnNkSjgrYmVK?=
 =?utf-8?B?SGNRbjZWWktrVmRZcUdEalhvS1ZBUC80eUwvcEx1MFgvck9ZS3pNU0ZKb09Q?=
 =?utf-8?B?KzJtb2d3WWNuTjlJUDJaL09scGZXL3luZmdad29STUt5NTJuQ3VkaWJaTTMr?=
 =?utf-8?B?NEVOdlhZcUdvM1ZCK1FzbVRNRTZqbDlmUGxTMW11NEFkOWp4M2RFUFpRelRm?=
 =?utf-8?B?RjRlbDlTQnU4dU1xVVc0M2lZUjRzQWp3YWt0WTcrQnpzRnRQa2s1dktGM25u?=
 =?utf-8?B?bjRqczJnczI4T1NxRjVlRXRxckhlOHBaM0tSbm1sSWhnSVNCZzl4MFlLMHBy?=
 =?utf-8?B?Ylg1UVFFYUJlS3FpRXZvNk4yNXBZdzN5cXFXM1U1WFBKMFhYOUQ1cGE5Y3JQ?=
 =?utf-8?B?ZGZZeElodzgyMFBjeloxVzhxTDFma0lTZkxTR0pBbEtsMUUydEdVOW1SOXND?=
 =?utf-8?B?Y3ZYemFLSmpFSDQyQVdiTGROelNxREhaSm1iSXQ1SVZNYlVCOExQdWtIT0NU?=
 =?utf-8?B?aXFFUVdLZmo4OHMyalFKUGlESTlZM3BDc1lHR0x6WjQ2VDFRL1hodzhzV2l3?=
 =?utf-8?B?aHU2WGhUcTlRT0RVVFBpVDZZVThPRVErQTJyanFJQVlDOG05NGhObDE0Mkw4?=
 =?utf-8?B?dUZNT1Y0T3h2VXJ1WERnR3hOcnpNcTJ4UlZxMy96NWdrd2lrdjF5RTJCSkFW?=
 =?utf-8?B?WXZUdGlqeXdydkxpVG9maGcwVDFJOWJXRnA3YTl4MHh3VXRDL3BvVml6c3NT?=
 =?utf-8?B?cWUxd25OK0k5RmMvaGIwc2VpN2ViaWR3UEF4TzFGMEp1SFpwSVczTVozczJV?=
 =?utf-8?B?YVhjRlRQWVltUTNyM3hhYmo0WVZ0cW1nenhlc01oYlhINVFsZEhoMEpKTWdy?=
 =?utf-8?B?TFZZQVZzQzJBQ2ZEQVJIMm0zcnk1U2NKUDZicDA0dzVHeGVYQWdUTGhxeVBp?=
 =?utf-8?B?c2hsTy8wZ1dLSHNyK0ZjUk9vd3RlK05IWDVIVkgyZDRVZU0xblRhcy9aUzBK?=
 =?utf-8?B?eUpFaGtNYzF3ZXl5MjA3RW53b3RTTFBDMlpZSjdUR3BOTmkraE96SE5EMzRN?=
 =?utf-8?B?ZUtkdVlrdFp3S3hKeE1hOWhiODFLaHZVbjZYRzJ3SjJWOW83ZmVrZjhyaU81?=
 =?utf-8?B?YU5zMUFuWXVwWHd1eDZ2QWRIeVkvQk1wUDNYbitYN3R0SzRYVGVWSW5CZ29k?=
 =?utf-8?B?V1hQR09CdUV3T1owcUNMM3krWWFVTFh5a3R4UDlteWhWMUhnbUpTL3RXenRl?=
 =?utf-8?B?Qmk4Z1Axb09ETEZ0d2g1ZzJnajM2c0VpSVF1SUtrenRGN3pFc0lUd2Q4eTUr?=
 =?utf-8?B?YUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 16d3cadf-95f7-497d-654d-08dd8e481b52
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 15:50:50.5498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFBmQrNg4BgDgBld01TF6bed3nHBN9dUL1IPtvWXdUaRUC+WE+ydoGa72PvleHeaOPgg/rHls8TTY7aEh0IGag4FYbCjDr4Q6VVTQz1SjRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB7984
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> Counts for each Intel telemetry event are periodically sent to one or
> more aggregators on each package where accumulated totals are made
> available in MMIO registers.
> 
> Add a new resource for monitoring these events with code to build

It is unnecessary to say that code is used to add a change.

> domains at the package granularity.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            |  2 ++
>  arch/x86/kernel/cpu/resctrl/core.c | 11 +++++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 6f424fffa083..3ae50b947a99 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -53,6 +53,7 @@ enum resctrl_res_level {
>  	RDT_RESOURCE_L2,
>  	RDT_RESOURCE_MBA,
>  	RDT_RESOURCE_SMBA,
> +	RDT_RESOURCE_PERF_PKG,
>  
>  	/* Must be the last */
>  	RDT_NUM_RESOURCES,
> @@ -250,6 +251,7 @@ enum resctrl_scope {
>  	RESCTRL_L2_CACHE = 2,
>  	RESCTRL_L3_CACHE = 3,
>  	RESCTRL_L3_NODE,
> +	RESCTRL_PACKAGE,
>  };
>  
>  /**
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 2f3efc4b1816..4d1556707c01 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -99,6 +99,15 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
>  			.schema_fmt		= RESCTRL_SCHEMA_RANGE,
>  		},
>  	},
> +	[RDT_RESOURCE_PERF_PKG] =
> +	{
> +		.r_resctrl = {
> +			.rid			= RDT_RESOURCE_PERF_PKG,

https://lore.kernel.org/lkml/20250425173809.5529-20-james.morse@arm.com/

Reinette
