Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50657198E6F
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 06:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741328060; cv=fail; b=a5/WnRFrwVI4gfYulW0/hEg8707jPIkS7GVIRFvdv69BVRwfLQhkALqdBYUsOcne9HlImDvEjjl86NvGbhWzYvs+dZsd4kEF5l5fHWmR6xEWrpr/gvzI5Dcd0s43yNMiIguGkbVVtBOfJetTmioVz5HBlZr++vvWnu8Skacjs7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741328060; c=relaxed/simple;
	bh=yUSEAINXhb2GV8cqttr6d+lQLTmqPB8ZTQrPzT0ai7E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ox04Cmz2PxFaTMxobPVEG5hSfQQKeni5ol1F6LL+3hOq1Eo4qaGGQm+WmPUSrUIMrrPODwutDVEB3YPFMIfOjG8bCboNMExTtIgYG+CJyxLHfOjxgtWnPw8fCocLKXB/yBeqVHp10XbChlESMbyDG+g1s20IlJ7T/G+D23ImEFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZDESy6jf; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZDESy6jf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741328061; x=1772864061;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=yUSEAINXhb2GV8cqttr6d+lQLTmqPB8ZTQrPzT0ai7E=;
  b=ZDESy6jfOLo61kS5AHJlLDf4p82M+7s5nWgRYGbJfJTvYnzyJvyWaYyD
   Y4eDAW42BkUKJHGwNRZL2wcEuRbM+qK6/Pej7aXytLRhESopzdmMlhJBM
   IOaoVhbIMlDf+BDXUaEhMWoPNbgSZJGQMOeFpcXJSL6mFhxuY4C151mU9
   sNO44Pp/UdfD2hSZeayg0Qa39J+xJUGEzCO0rOw3qhH7hRN/g1oFCNQ2z
   eGHpKDb83ErS7CQMi7dFotqgHQ5yIRrmSRq27XWN/mfObH0UfCa+H7fNJ
   ot0gbF4OTZgD+cwX7E6ggxaCoWhudRxNaH8suplxTtHl1TZ2OWS1CC5sX
   w==;
X-CSE-ConnectionGUID: bY4KVbTBRT+ONa9OxPLuyQ==
X-CSE-MsgGUID: JGmWVMKlQ66S2ONGRne7ag==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="53357247"
X-IronPort-AV: E=Sophos;i="6.14,228,1736841600"; 
   d="scan'208";a="53357247"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 22:14:20 -0800
X-CSE-ConnectionGUID: BEw7BcHoThi9dY8XPFkOFQ==
X-CSE-MsgGUID: IBTyGNXoTeO315SgQ77Ung==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="120155432"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 22:14:19 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 6 Mar 2025 22:14:18 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 6 Mar 2025 22:14:18 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 6 Mar 2025 22:14:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ww7OCnvAnXJVmihEowLDufHW1X4ylnoXpJap9O5Y0NRF8YWHthUohPXborD8/14MJFY+AHQZt2U7pa4cHCc9NtQgUGNifEEW3BU/IBFs3Xm2MBiPy6T91u9ZHDXszztWuGuQMHuV/F3Z4esqaJPIewyAJgEq1JDGfCQHyIh7dOnHmP2whNq28D3rzIxwS/4kQGK0vX9ESNDT57O+IbgZAsmd2bHj2GRt5yU6QOtjpLmbvKAT0P693T5ZaynmY8suN/QConJt2v3U5tdl/5w7RrsNCDxw42uoOO/U2NV2rRaGj+lOs1/LJaqtaYYZMIoypou5TfZ2o3BL5EdDWKYebw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CcDHj/pDpubV+FBfjU/cv5Bku4YiFvOeve9WmQwAR24=;
 b=Uem9/T2S9TLdWen6VPA0gIexr5ntFl7CGOxSM+kQYBMqiMG6bQ/FMGDBg75A92x7Z1IcciQfWa4OqtNysMwx3/tl3MKL0oXvVX61C2keRXkL7rjdUCeydWs1PV/PsYc4WoOVPffl2zodKSF0uBH87eWOWdvKcVXFnwh2zU4rasSIwm2kSxXNblPKhpwsoqkkgiJhH2hEsEmRZMWwJJVvujCkGLl0KASvXPL6It/K2SSJxHfcHXBFiur2plnO1STKsAlP0r/DKHRDb/xPSn6u92y7tR4c+8pul6viBwFThE/J5UmvQrc9dcwpO4z/dZOydzWyOfs35HmWtq8HBPkuhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by BL4PR11MB8846.namprd11.prod.outlook.com (2603:10b6:208:5aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Fri, 7 Mar
 2025 06:13:48 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%3]) with mapi id 15.20.8511.017; Fri, 7 Mar 2025
 06:13:48 +0000
Date: Thu, 6 Mar 2025 22:14:55 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Tejas Upadhyay
	<tejas.upadhyay@intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, "Sasha
 Levin" <sashal@kernel.org>
Subject: Re: [PATCH 6.12 058/150] drm/xe: cancel pending job timer before
 freeing scheduler
Message-ID: <Z8qO3xZ6VmHwCJN5@lstrano-desk.jf.intel.com>
References: <20250305174503.801402104@linuxfoundation.org>
 <20250305174506.154179603@linuxfoundation.org>
 <Z8kklJj90JKGPCHC@lstrano-desk.jf.intel.com>
 <2025030621-fame-chastity-0bbd@gregkh>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2025030621-fame-chastity-0bbd@gregkh>
X-ClientProxiedBy: MW4PR04CA0268.namprd04.prod.outlook.com
 (2603:10b6:303:88::33) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|BL4PR11MB8846:EE_
X-MS-Office365-Filtering-Correlation-Id: 98a805a1-6498-46a2-c8c8-08dd5d3f3973
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cTVUVUJLclhmSE1nOXllVUlGTklIalVkdTBTUVNuTUJFd01hNDRHcktGRm5I?=
 =?utf-8?B?d2t6blVhc3hLRmNXaVFNSkROK29vQWg2Z0xNUTJ5OFpOb2dabjlySFkzNUNa?=
 =?utf-8?B?b01lRXIzc2h6d05yb2JmdjZjTGdtbnVCQW4ralRQaW1JcFdrU3YrQU1GSmts?=
 =?utf-8?B?VWNzU2NqbEl1ZlJmcUdDRk9KbElQRVFMR1I0VFlUL2ZuSWQ3aVJkb2ZTM1VG?=
 =?utf-8?B?SVRGMmRkcGJQalVua0pDdCsrWHpqMC9KYnFDSkFNUlhxa2lZRExtVlFUMFRw?=
 =?utf-8?B?VEI4bStIQ1RrOENvNlNKQi9pd0dtRHJvcndqMHIvY1NZVW1xYWtFTHVLZUZS?=
 =?utf-8?B?NFZPOWJkQzlPT2hsK2MrdDlDL3UzUUw3Ynp5MW9GWHp3L0lHVzVwMjZ3bWti?=
 =?utf-8?B?SlRVTU51Szg4OWdLYUZMZTFrRERVTFRXaE1tUzRHMEVINFFwZDZCYUFPR293?=
 =?utf-8?B?V3FER25TTC9FRFpGRURadmo3cDRkS2d4Qmk3L0tNd2NDNnlVaDhMeHpBR1A1?=
 =?utf-8?B?MHVFK1hKTVlxRlp4NUpNZzFwelVQVElBOUpYbnAvV3hGM0gvQVJGZmtmdWdV?=
 =?utf-8?B?TFhvKzQ2eU83SEo2VkExdTR2S1k0amZ5M3liY0pCRmNsbmJEbkJnNjRIVW16?=
 =?utf-8?B?YnI0VVZwNzY5MStDbVpUZzVnMFptb013RkVyTjZlRFdjb21rbWhZaG13UHRH?=
 =?utf-8?B?Mk9URnJRUFN0Z1dDQlBud1JxVjZqQjdaWGRuNlhVM0llei9DdnJIemlPR0da?=
 =?utf-8?B?QXUyZnVDcW1lRXBCczV0M0FWSnZZck5wanVmTkUrYld4ZG1ZUW9xTkp4ZWJL?=
 =?utf-8?B?MmQvNXJRcHhwWGEraHpUenlBdzBpeXgxMmdDMU5yNkZjbmRhakRhdk10cDVK?=
 =?utf-8?B?VEYvOHFaY2FKcFN2ZHQ1OW40emlVV1doNUZlSUExVWR3WlFXUEVZN2tVN2hp?=
 =?utf-8?B?QzdjQ1RXS1dGdEJVSVJNUDRjcE9XWEhWNVBITWw3NlpraUdkVnBiWVBrNFM0?=
 =?utf-8?B?RDVTaFluaU9WZ3hVYjZNeFBvQ1VUNTFUS0VxOUR6SGpCNDMyTjMvMit0azUy?=
 =?utf-8?B?NTNaVEtGZlJYdG9UaThHRmt3M2x3aVBmVlpHVWhOVDZzTlZXTG5vU1VhMDZl?=
 =?utf-8?B?WUVRZHVYTjZDb3V2SkFteDNLaUZBbklQQXd3dWY2aWtkekxEMVZmdlV2eldu?=
 =?utf-8?B?V2tjWmpQbThFbkxiNGdMLzZJdTJLWVFkVG1OOXNXb0tpOWhVeDd1NXEzc0Iz?=
 =?utf-8?B?emRtWC9xVDN5YlZvUnNlUE90ZFFZT0M4MmFTai9jYW9pdzVObzc1Uk5sQ1Fu?=
 =?utf-8?B?SGJFK3E0WEg5S1dnY0NpRkMyQUJsMFFOQitkRjVxd2gvd21Rc3ZDcFJJUGkw?=
 =?utf-8?B?eXY3aTZDMW51aXAwWkNGempaZzRycm9EM1N4MFpSbjIvN2tIakt4RUdZSnFp?=
 =?utf-8?B?dHFBOGtwNG9TN0huTmlzd2xUeFZJa2pxcFVsZkk5YXd3M0VaUGYzMEVaR1BF?=
 =?utf-8?B?QTF2a2xrOHJabm1QbWk1NUhRMHpPcXJuV0h4eDU3dTFGUnlkMncyRXpTaTNj?=
 =?utf-8?B?bFUwcURuOWFnRmQzUnZCMUhjNHRZWEhpa00wT3JUZVg0Ukx4MjVTTkkwYUVz?=
 =?utf-8?B?UnJha3c3SXVCMERWUzB3bHAwU1VYNHZmdEhCYSt3Zm5QZ05LTlJ1RVRXMDlH?=
 =?utf-8?B?MUpxcFlKcVFHd2c2VjNHcnEvWUd0MjFrd0xabkJBa1ZxRzJuSEtibWZIdFFS?=
 =?utf-8?B?L1ZpWmlhbkZYT0RxR1VkTllicldFa0Y4cmV5TjZlZ3ZwWFRyQWdCWHBqd09T?=
 =?utf-8?B?eTJPWGlPRzRtS0ZLdjMvZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVQ3TGV3eXdmbUhLRmJWeWdOSHhJWVM0Si9xMy9Kdm5KTFpUbFloNmdydmJ3?=
 =?utf-8?B?cVpDd0t2d09TNG5iRkMxUW5seGtnOHphdG5iaGpHODRINTkrTzJMdU1Sak9y?=
 =?utf-8?B?UngybGZaT2tjb3Zoc05idlhqVGpsRUZGc1lHS0M4RG4wbGNHb2xFN0NWbUZL?=
 =?utf-8?B?M0hLeWFkNGpqZkFzdTRQT1dKMmg0b091WDV5VmludXpqU0NVZnR4OFhEaklw?=
 =?utf-8?B?ZDlhZGkrU005WWtFZ3VQWllmK3lnaEYrWnh3RFBDb1VtbnBqTWVKUzNtV2I2?=
 =?utf-8?B?QTh4ckFpMHBLQzZUS1c3L1BmcHZUSEtuczhVWEtpNFJwdlJVWEpSRFIyZ3k2?=
 =?utf-8?B?K0JudFpadTJrRGJWQUg3RlYrY2hFV0s4OVB2ekh6b1A0U3V0cTlPZ3JWTm9R?=
 =?utf-8?B?U2dpZi9ad1BoK0lXS0tZU3dWRFRwbTV1SXRxQm1ORTdCOWxucnRUQWVlcFdB?=
 =?utf-8?B?dmxhWGpMc0NmbjYyYmcvQXE2ZUhkZWFLS0ErYUFwNzRHVkw5M2YwRFdEV241?=
 =?utf-8?B?bHozYTBBalVWc3JiNHRTSnB2ckphWHNLYUZnNmF6V1NxbU9WZWNxWEtLbU1k?=
 =?utf-8?B?UTI3Rkx4MnZVaU5VV2RmS1RnSFNyR2FTTk9VRTZHNXpEN21FeFAzUXZqKzgr?=
 =?utf-8?B?T1FQQVZXZzBOeWJ1YXhMU1N1U2VQY1ZjMDZGcTRidi9YdE1ad09DT0FNeDVY?=
 =?utf-8?B?Q1hVRFZrR3A0S3JkMEp2QW9QaEZlUmxDeGNTVVBudyt6OTIxaU9FdURRVzJG?=
 =?utf-8?B?UFVZa1ZqYXZLQ3NyRHlCbnQ3UlFtaitxSjJPaFJiSlhlWDVLQVhzUEE4UU1m?=
 =?utf-8?B?N1o5QWlnQUY4cVhDN25ObXoyQVlLQkNLNThLWDZxMlA1MXZFNVd5QkYyTnRG?=
 =?utf-8?B?ZXZRbGM3bEJuVXlBbUp2Vld4blFwZGhJclJHZVJZZTB4YlY4N2tDWndLc0NU?=
 =?utf-8?B?UzcyMkNlMklkcS9YMldFRzZpM2d2YlMvT21yeHZDakpzUU1DYnBtVGZORFRi?=
 =?utf-8?B?dmNRQ0ZoS3VNVUVLc1VnYWU2SWhXdlNWY2dXQ1pzQmQwRThJanpmM202ODZD?=
 =?utf-8?B?dlQ2Nzh4QndlSWdYYXJKQ2RPc0FMOEV1RWRBRC93VGxWVTVmQ0luZWcrMDg2?=
 =?utf-8?B?aW9WdmhUMEhwd2pvWHhwYWhaRENhc1F2a3QyUTN1WTYxdjBjbTdHRmZrVnoy?=
 =?utf-8?B?K1BOdTUxUEw2a2syQXBqeko5Y2RvcUo3YW9lSVFrL040clR5Y1R2bTh5eEhD?=
 =?utf-8?B?OXZBZXFnY1EzRWRhUWo5dmpLVVJvNTZXbW5neTRiODlRZUlieFgxNWc1Qzd0?=
 =?utf-8?B?dEk5K2plZzdPWE9jWWpOTkFoTG5jRXpwbWxlUFQ2Uk04NXFzRVlFWUJqL20y?=
 =?utf-8?B?VG1kYjBwYkhJNTJFWmppU2pzUjd1b3o4K3FoVDhsVlRRU0FheVpxR2R4SXJV?=
 =?utf-8?B?bXQ5WE1kNDV3WjFBeTl5MmUwMFBnbzRqeVpXVWN2WHVHSmtqMzQ3azgvdktv?=
 =?utf-8?B?cVBDT080K2NBcjIvR2RkNmMxd09LMndLYUptYllaLzhCYmsyRmM0eWxFRHVv?=
 =?utf-8?B?d1AvREdLRkx1ZTNpejZGK3V4Sjl4R1ZZNFFVL0pJRk9DNWtLdndiQzRNTUhM?=
 =?utf-8?B?Rm1zL0s5aWxoS2REMWVIM0IzNkY0Zlc2OG9Pazl1Y3BCTVdMWU1FcktWdkhR?=
 =?utf-8?B?SWkva1N3M0xtZUl1VFdiVW9PT3N1dmgvSForMmxHaXVPaEQyVHcxbGFXMGt4?=
 =?utf-8?B?RlpyaW1WMVd5Nm5LWlZhcnI0cWpaaXR0N2NhM3VEdXd0a0dnSG5kTjZBRXZ1?=
 =?utf-8?B?UVZuK1JWNDcybFF2TXJFcFRIZUNLa3Y2aFVOQUl6SVFjK1hzQjk5RkJFNWVi?=
 =?utf-8?B?STJrRFNwNE1MZ2hBRjFoLzFjODZGSExtU2RJRjdQQjFqcnVLZ3ZlaGdCbFZM?=
 =?utf-8?B?d3U4bnZoK0ZDU3NxaHNxdTJKcHo1b3ltZndmSGdrTGt1akdPOXBBdUhUV2pY?=
 =?utf-8?B?a284blp0ZERIZ0hDK0w2NzVWUkNnd2trV1JSQkhuWWdZa1E5WFhVWDRWeW5j?=
 =?utf-8?B?THpZY2cvVVB2R29OVDU2ZFNOa2YzOWhoS2R2QnZjNjRQOXk5dEFIeEVHMGlE?=
 =?utf-8?B?NGVmbElkZWFKR0J6WmpncmxYYlVCZ0F5UFNsd1JmWTl4MFFRcURoS2kxcWM0?=
 =?utf-8?B?V1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a805a1-6498-46a2-c8c8-08dd5d3f3973
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 06:13:48.5806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GkmKmgaS57Vw7IR8OMGdEe5Denh+2M8U6DPzdf6n8QV+q1+gwh/8OKCKiUPn+3S/N4D1cR/WfrjnwHeHWGbKig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8846
X-OriginatorOrg: intel.com

On Thu, Mar 06, 2025 at 02:32:56PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Mar 05, 2025 at 08:29:08PM -0800, Matthew Brost wrote:
> > On Wed, Mar 05, 2025 at 06:48:07PM +0100, Greg Kroah-Hartman wrote:
> > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > 
> > We just got CI report on this patch, can you please hold off on backporting this.
> 
> Ok, but note you all better revert this upstream as well soon, otherwise
> our tools have a tendancy to want to drag stuff like this back into
> stable kernels to remain in sync with Linus's tree.
> 

Thank you for the information on the workflow for issues like this.

I'm pretty sure the follow-up in [1] will fix this and be merged any
minute now—I just saw this email after reviewing [1]. Is the correct
flow here to let the tools pick up the original offending patch and the
subsequent fix, or is there something else we should do? Please advise.

Matt

[1] https://patchwork.freedesktop.org/series/145907/

> thanks,
> 
> greg k-h
