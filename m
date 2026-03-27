Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B607C2D8795
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774655260; cv=fail; b=uWzR2ok/G9K0nIyAmF6Q+wZOYR6W6HR/2VU5pK61SXI+q7fRH5FTp5kSYvzsO3hk1srHXx89C0G6nTIm33aMf4CEqwXJurZkWqnqkYKV86hgB3DUlF60HfUXn6Mir6tZ+ro8ErcYz0I4+yU6WivVx6xZjQ84pKyz3vOOwHfO9A0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774655260; c=relaxed/simple;
	bh=63oAUoQ+c6T5Gyz/o0wiQcF+5tQMmv1caBtQRYkBGyY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D89InflT3UaxFg5lQWaGbCOvR4EE3iCT/hRmmxhtbpMgmK8jImU2KI2lFmQZo+FEEGM5mvi5qmfzsdPExd0pncui3xZxxJxvDgS/eYyIoiW45DmLrwIPeI0W5RsSUDW5uC/eB/4ye1OIHAsslpAM2uy8zEjK422KIyNhmJrz8Zk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TPy1Tg59; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TPy1Tg59"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774655258; x=1806191258;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=63oAUoQ+c6T5Gyz/o0wiQcF+5tQMmv1caBtQRYkBGyY=;
  b=TPy1Tg59lnfIzmsLx5CWQA0phY4Jenvqvh2ALwZW7JNid7c3UuVHIzFA
   aLJe5JaEliFB+HKWHZG1coI76rmE2EB6yEIPRF5cGqIOPSc78xfkXGjGE
   AvJXGmv6C+Bm+cFX/3TUYeKYbzy57ImNBBFc3MQ1YfJSyVLgsOCY79RTd
   BFftJCnS6PYAAAJ3YUxsUziQrtWBnhPAztvGpnpfRuzUSrB1BaRZ/Z6zK
   vqu7Eih8z18G7hzb0Z+slmJYE1pkvRwm8AqsqxAuBd9xODJAlDLwjrh9r
   /gdHN8fp6JAxIBFIps3vW8pSag9fZS7jCJgVbTBAtrbd4AVHj5xlP1pyT
   g==;
X-CSE-ConnectionGUID: YsSjzoeSRCaQHVxY3GzALg==
X-CSE-MsgGUID: J/sVdTAFQ/2tLFDkz/tNIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="79640094"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="79640094"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:47:37 -0700
X-CSE-ConnectionGUID: LpicLtP1RxWCJ7arNi1+0Q==
X-CSE-MsgGUID: WL3qfv7yTea2mBLn8uldiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="218823290"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:47:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:47:35 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 16:47:35 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.45) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:47:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mUni7CVYI0SEcN3sK0WckODcDdKI1recpn6nDZM1bRlLspXYFrJMUMk5JQ6OA9Wy3009zCXu6RqfzhGpgS9hdpSzHha8qcofpKWie/agJLWwrFbzvEgCF1Z3dfb3Q1YYV1phoWwoL3e8XVIplIn8OEZty0l/PrugoGkx+hEERt42gALgHTtrO72AI/diw2S/nA58/5I1hRguB7ZQ4gZ4qY61/d6gruuG4sooH20MrbkDvx1md2I17lNMio92bmQAWgJ+0BlyAorvd8w1XDQM4Cb4QdOisXbeh2nmJa8Fo5mr2FdWPOt5Cn64OpbSgaoZ8TmsxPZw+5GEBUuCR5qdkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+ewpUgRa3G21oyzFLgMJnOI8s1zjVHk4RbrD+ovyEw=;
 b=caVUun2zJigsEFBNHYhKCR1cwoqafvY7GFKu3CuBymbxlVCqUZ/x72MOv7v2Othuq/HSFr1buVlRMP3pR2rDh5GeXBumAK0DMpX1IMuIbNTQWhbE5lYce+48vKneJ4HVmeg5oOtQM/SNZCDlJ2asc/Llt6QR4hIa1k1TBFswXE3iPyyg9Sv7aT7XOIQamuncchu48ikI2IFDaiQ2eN3Ucv+QQgeo0ji+C71ITa5Qih8dKNm88JL2BH8NFBLI8tJHCnizC1k92JYtn7E678jiJS6a+lorqTotEEsd7vkIIS/hRlB8/cULSOL0OXQskNdyh9KapbtjhNCbppIeppIdOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB8254.namprd11.prod.outlook.com (2603:10b6:806:251::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 23:47:31 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%7]) with mapi id 15.20.9745.019; Fri, 27 Mar 2026
 23:47:31 +0000
Date: Fri, 27 Mar 2026 16:47:28 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <dave.jiang@intel.com>, <patches@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 7/9] dax/hmem: Parent dax_hmem devices
Message-ID: <accXEP3yC239Noxe@aschofie-mobl2.lan>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-8-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-8-dan.j.williams@intel.com>
X-ClientProxiedBy: SJ0PR03CA0279.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::14) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: 4522dbb7-1207-4377-a7ec-08de8c5b364a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: m/NKH0+lUoqgYjWMREd3L56ZM9dqgRL/VxtAY1SSiABFanogx03vnA1i9Y8j4aC9uFItuxnYfSIMxhUX5mV3CVJcsuMVpu1E6R5IPkK/DvM2GvsshNJAFmJGRXV0qjdy4CaCGFMcuWxo98IIvWG8apRUmMUeI4TG8tpcSLgzyCzns/SOFeD00YaYtz0yVRT9NF84X67kUMNTesuS7fhvFDIQT0Wl7qGJHJpAlijhNXYxaFAAAqwWdrv06P1FMm2Yds4cmB6ON/ivgfRlnM023ZECau/pr0MbTYSEFXOiUXuRQp3KQDfd7peC0tT7OUPGMmEK8IOixSrk6IuLMjnqf8VBDMxp844Vpva1LKmB1lnr7CqU7f8M3F0x/cAt2D80sMI9ffjE25qffc5mtdvDZ0kpMRhybaOUDOjxcJxBzj+9PAyznPDX1PGT87ZcOlvgtCLbBGkg+32KGfi9k4pl4cHCE6qa4m1sgV02Xt812Qdqs4f6OpyLkyjEnGlC9mYEKDiSleJXnTUNB7gorNGzSD26WPVXKKIQnNHkbcAgFY+Ac8nHY/AIg0cvYOm4QkS1yYcxyD0CQeuG4MI8KS+e/brnu2wkcbD3temousyw363XtvqOLM7SMm6uuQMmNRFp7S7SJWrD16y90h6jDEKHLEo4fujC8F+/l+6N8ltAUW5oky9uNe+RS3an21m6GZn4vuscYTVzIlQ4G4QqYfqqhDWazmXaDYHW9dDK/dhEOb4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ibeziu+7gGfD+ilJspTaBnQA2vDRoKa4KwE26xC9A3QPRxigBcx6c9WkFQYO?=
 =?us-ascii?Q?gu3qhGle6andq9EdFUgQyJax5HgnpCx3I6EGMZt64ElmTMt8nPdu0bjeRQu+?=
 =?us-ascii?Q?3ckXYwS/g8yuQz61mvZRGl9WS9meMNv7BNUKiuy0Cg7fU1lTEfjVN8POQLLT?=
 =?us-ascii?Q?YBIvVnaVCUeapagFohWM4IwmXZhjEWJbVG1eL404Am1C2574nYSHsOz23M8E?=
 =?us-ascii?Q?y3mGp6wtfBnk2YoD+hNiWLz+55uz0jl/TdrQ6AuZfzoMIGeEk/IK4QBd44io?=
 =?us-ascii?Q?KAIiSUKxS7nzK53Pgc7E8xrterVD5nBJ3+qJKbt3oaoyQlN1d8axa8S1Lr89?=
 =?us-ascii?Q?K5S8PSqOlOmkWkSrTRSYpVO3QqaAQFIaf58yC42AoOZKN8ZoDi/XKgaqGiD1?=
 =?us-ascii?Q?IhekTeIZP3MadHK1leLCPxqquspQMxVP60dkOQJN0gNXp/R7ekFQ7CQWWPgH?=
 =?us-ascii?Q?rFsc3CiSk0LzDE8mqHlDbzJPNjGLoGMgsMFLKN5KQA+WRfPw+hVzb2NGV2Jp?=
 =?us-ascii?Q?A8aX/kpuo7B7h5eNnFUm5G0lQAv6wcegrW45cfGDcJnptAEAOQHRb+VpQrxA?=
 =?us-ascii?Q?xcBZqruGxt4Wk7GvBqi73rlGlFdA8ZIiP25RLwy/1VQYj2/wOGvLLx8bRkyL?=
 =?us-ascii?Q?SAOOW/zBNONolqZKQj758vAM8oQWfqCabIG6UxWL15NJu0QO2XJexb7VccId?=
 =?us-ascii?Q?d22nIHAWC6/aDZSMxERW5EVwHsUhcM6ztOV0xtaJqOv11PEIYZgygrMhJgOS?=
 =?us-ascii?Q?dqaDDpanmv7qxUjDotI7Xo4JBi/GaEE6T4B0So92PDrVDEAATQqkEZRdaBlG?=
 =?us-ascii?Q?1enIG2kjZVKU8GGEsjvWXXAXH2k7f/nUy1LAZfBNwT+CeUjhgFFGlRmz3OSG?=
 =?us-ascii?Q?g0uR3noqYtFRfkU7VUsyDHRXCvATedaWsrdfBUHXCRsUzK3wzFlQYeBy2G6H?=
 =?us-ascii?Q?W2I7fteaL+FxsESUlCtg2E00Y+S94EwNYDcojpBq26TH1sL1p1SsGyGncxgK?=
 =?us-ascii?Q?2rCSndA05jMxVicxHtSHZlUoOgx0Zw9qZsRuSvmYSiHVKlzFTrvbhFgkrlrw?=
 =?us-ascii?Q?ZUnvFRkorxDaDlF5/FSMl8itk1urqtdPYwic7ha2dGU3pfdYgnn+VHqr0xHI?=
 =?us-ascii?Q?3aRF4agIPZ5uLJecnBpq0h/3rNvQivMXmob+dy1vdb5/W+GewnPAR627wpDD?=
 =?us-ascii?Q?SuroyL/fvNXzcKEYau5Mn9TL+qBOvOAGA5xrB/riNH8rvounQtl5du/6df0/?=
 =?us-ascii?Q?nIz0W9HToC4dHxTHkJu/m9pS7BfQBA5TaygPkCvY2k+sLKd9A24NMVl7iFeO?=
 =?us-ascii?Q?Me7No8Ou5VzIC/8q2P+D/ibW1B6J0+02zFe9q4tyNalcAd/chGkGCpmXTnj/?=
 =?us-ascii?Q?nEbhxBRFWhqpkK/jpN/EwvPWo6SIJarB/POaDzAIcJnJ99QR2/+Q5aJKKca6?=
 =?us-ascii?Q?ePNUW4sdbZWoy/PQSVfRd6qPeV2e/YR29Wt/d6f3YUGEY+DMWlTNUasL89ke?=
 =?us-ascii?Q?pP4xITkFqW3Z5Kmy74Iolgh1rG5Jl+a8JuTGlJpI273QARu+vRp0UmTFkwUm?=
 =?us-ascii?Q?Sv6HKRJejxLPghZLn0bdVvHrCTfbgFI71Qp0SPwZjxw8AbVvSgzEGDrbkhH4?=
 =?us-ascii?Q?ByS0R9fmXVMnwMAqMpE6R1EriK+2CPmJQbJIray3pIo6mldgVSdli1oTbZ2S?=
 =?us-ascii?Q?5bw4KShkyoE+NRgFNqPbYTsQZTrytKNdOUyugxuoj/AnQ9+ScnTS2F0YMsyx?=
 =?us-ascii?Q?ScdioXJGP83wVhPYafYglo9u8d3dkO4=3D?=
X-Exchange-RoutingPolicyChecked: mnaRfcu8b5oK+2UgvhMrwYgGFzx+5SU1Z0ghmj73c/fa7EGdRy+RLmqyWKX5BbC8rJHxi1Pmvb0JQmzHe6XSPSqhYTDd08ygzmv0CUhD5Q9xSddhXBeSkZ2Y6KKz1w/5cWfsgGSL11LkLPKyUaTl8hZEDCNlesZFdKW2TIb4jfzs+rV69/k6y+R4WSQLi4aVvblL57SECy6CiCQhQtzLwnHZIkHVMtregvowBrRf9E7WCLRpDIgFj8XQm6kUgO0rR+N6EgZqk/+CSUCDpdeoCmxjlph5iV8JXhj0pH93nMLB/Dz6l1YjqaRXAh5iDPu/2g9t24epeMw8MDbN0/W4/Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4522dbb7-1207-4377-a7ec-08de8c5b364a
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 23:47:31.5737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSZLWC/TWcL0hgsLxeNSdQ3KToD6hvTXDyQS27OZnGh4ixnWpu9NTFyfdyinDXdK24o+NdnAQquG539x3DqCIsq8EuTyZX3FU/h2eNtXc68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8254
X-OriginatorOrg: intel.com

On Thu, Mar 26, 2026 at 10:28:19PM -0700, Dan Williams wrote:
> For test purposes it is useful to be able to determine which
> "hmem_platform" device is hosting a given sub-device.
> 
> Register hmem devices underneath "hmem_platform".
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

