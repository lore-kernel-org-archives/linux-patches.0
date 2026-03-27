Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A6632FA29
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774655115; cv=fail; b=A3i0+pvnEIVUpJETGfVG2Bf/yG9OGptK4EbWCuvJV346RtFgblmi4WBZGL0lQXCUCauOyyL0rDA0U9GMHxoY5cEiGqGLOZYApzs7zf8MTcg1HZoiFXNhCo6gx1X9sBLJWOvoJuMmBp1w1LBXJQXlNQfmIczNzm+tOkfjJ6poe3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774655115; c=relaxed/simple;
	bh=/22HI3nUtZBDOJVo0bDBGtwwqRj1zjLEBEZf221wDe4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=thKiTdN0DC4CGL4tDsiYaylp6HMuF3z0v2j+JS0J1nddnYQ6FKbI9QxEKgRKtpgGAJqqZ0ln9JphehOmHHEff110bkdKcT75tWMW1OpSNxEZLmwJktUhGu6brszjhYzxe0pTND69rIaRTHePMBN1mu6a4cZwMVDkiHJT5EkL9yc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RMGF/k4P; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RMGF/k4P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774655114; x=1806191114;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/22HI3nUtZBDOJVo0bDBGtwwqRj1zjLEBEZf221wDe4=;
  b=RMGF/k4Pv5fft40YkrHjDQoPdDwhc87H7fvmn25wvqZc+D1pUmC+w577
   az73lg1wKc4Fgi5ypgdfG9AGt7Na2XMMQE+HIffP1FPznoRk6Ddu1DL2L
   n0yDoVCDn0pCqsYCy88ZMQdasP3JgqurnpdZzGUQVetp5hZaXqxZR7Zh2
   0kvvwbZBPZN2UPzoCdEAxKlG/rJGS1KnUH0XRi/By1jX11PU69BeLFhUT
   20uoDSaUwQfIWfXcueCzgm9JfBOjgaiEozO55vO6mQ0g8Nqv8O9jPCFVo
   qeE4qoy83ynVoWO/1nBKxcKNFYLXFxXfgLLTJ8Aa6UXIa58njvjRbJ3JF
   g==;
X-CSE-ConnectionGUID: zxCFBcvXSdGGn8RUqzjzXw==
X-CSE-MsgGUID: 9HwmY2xXTLi9/KaVIaVoBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="74917243"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="74917243"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:45:14 -0700
X-CSE-ConnectionGUID: +nYjW7AfRZerhqCYdiCUoA==
X-CSE-MsgGUID: 8/EHM5adTmOBPV2XVhS5lQ==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:45:14 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:45:13 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 16:45:13 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.29) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:45:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PlAttzVF7MNASL2HfGkvVsFV0dV3CS+Jx3ULR3McJaZcANSU6gyuUFZ5lVKQM185CyVgF266Mz2wCeMBpLJdwhldySwZPr1CwfQFGXd1B/NcEOav9pZpSErOm4/BBAgIADFLWcU+AEEwBiO1dB+qVfyrDxQFwHFpQWxA93wVbJk30L4cySP/H7QX5qqIFbS5HmbefLCr/Z5yaKIJZenoc7h9rzTZbi1EmhE7EFPmFGkYEwmjz1j2r5zkAcyBWXro4ZzMCvTXzOhpAFCizTxfXRBiv0fAEr+IuGJVrnthpXR69j6scW8RfL7kSKIyzjhbF2kOVWfUv7ZMCHyq7T7zmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZtJ9I/mxZu7nP/b+bDBzbmRgP/5pL/1Mm/DBZryECw=;
 b=Rcm2GZXAMcVDtf1xmvTGaJEcWJmYw/QYj5lz8Wzx+YxjbNMVp0JMDIh5WrrTlnh8aiQo0Hgdku2o62BMXTrd2NqjtNUz7JPFSqATasmvJrI/gJCS8rXpsyMN/fJOS/Xsrv0ZqTOEFGY1ds6uco5XfEfGv226c35qdBZyJFYALq6044qHk6w23Am/PEJAZVfRy/ETYAKO3od+jmfzUOVBtsyUNRaqyGmaNEXCpoke5BO5zKWJgoGXQFYfdDv08HfO62N9uE+wqMZ7jFK5nyTo1xhJLLSpUm8SDO+msweUKgsq3w7otip2N0qC78fERCDhP4Pyt1ESko31Wo5qahDn4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB8254.namprd11.prod.outlook.com (2603:10b6:806:251::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 23:45:11 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%7]) with mapi id 15.20.9745.019; Fri, 27 Mar 2026
 23:45:11 +0000
Date: Fri, 27 Mar 2026 16:45:08 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <dave.jiang@intel.com>, <patches@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 3/9] cxl/region: Limit visibility of
 cxl_region_contains_resource()
Message-ID: <accWhNsUs6Nug6gn@aschofie-mobl2.lan>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-4-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-4-dan.j.williams@intel.com>
X-ClientProxiedBy: SJ0PR13CA0055.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::30) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: 1145749a-16ba-4033-3f6c-08de8c5ae2a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: fq1SM+kZofxiEJbBoR+/KTa63NVHGp641lT9YH+1mcG7itesEr4WiH3pBwkvnwVllv+sdlwrc5KoQosUGj3mLv/jEkRXHZwwutAe40/OGhcMkdXPbOSZQm6JYdxRx2t48b2f9/WN04XitDe+bbyIzg5oONAPw99p3fUuS6eN/bHfkIgAhjRQ3jMPStQQ3YQ12wHYWv2LsdHL7aFhCrSZkcdB4v+inkkcqIBmmLSsDFdHqaL9t5G3ZoMtQ9HdgcDvr6KaMvuHbKrGIuGGUVoBQPjzfoI/yRsLHzu0PIVHOmjq46gm7mFUdUjCNISq5NSe3vugikDxRrNjI07oRGI47UhFsSJBI1GwF9VVKEcz+SO6Q4Hl5iJl2CS97J5lItJntBwLC6oWMsRfBrHtOMH8ol6aC6pGUrpzTv/ryYnDm/sMIa5NYSmD6xSKeHJT0fMM4da2ri7TRcxSA7nNKNwyp06s9jHKV5Y8O4wEEBiX4otxA2osEaIGOLdk14Q2Ol5RvFEpDVBMkLp4LCbpWJejkuLJtChV/RUXk7go7STKKk5Y6dWYNOEp9dTtQBrgpyIPVXXrPxXCdUgkv/bzjRH/VfM85VpttEfSw0vzGOY8qdP8tE6R5ms+h7mMd8aNU5zWP0FY/ufYrWqq6HT+0hPDgYWSL0HC8SmpKnqfA2roxFb54h2SwG/uiT8lycxNApEVy2yV5SHHGrGlhaYVCpP8sv5AVDNK6CvZulMMPIyL/Ys=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/h5cTx9gthc2NJsKLT1f/jUjCVyXifCN6eUMaw1cdEsdReUgN6f4BaAGeBo9?=
 =?us-ascii?Q?5JO+UXovmMtNXPEMiEev1JT9aaJLVBw5ZJ4l26w9KwFQof+ht/G5L4dyTWMy?=
 =?us-ascii?Q?IV8/j+pF/qzPHAXfIsNizaq+SLwLl+9UUlg2FSsOTp2lNRMG/bCOI6pGrzTd?=
 =?us-ascii?Q?TBvlXdlbYX6ZXTt5OGKB4Bpk2xkw/2orRfBC/Nzhne3Fp3OpgZhDgJ+BfF7z?=
 =?us-ascii?Q?Zwxv12H+U1IR8U1O/TaRI/agI44nXEld0tAkaTWYaT05vla2JIY2zKA+v8oD?=
 =?us-ascii?Q?6UI2/tGKjD6AEDO0Xq/wAPPv4pOr+62urNKoawgBVwPDHLHfbtQ+X7w6mzQ8?=
 =?us-ascii?Q?p7ig2OFipYQfpgvWHM7WmDtOSTjwPlmwfmPgpTYjHyEPtW53LCViEFeADmQd?=
 =?us-ascii?Q?dkVWEGghoJ2HrdDaRHyFDP04irbYJHpDrtOWL+g9+gOe9Evpw0Ts1T9AL5ts?=
 =?us-ascii?Q?3Y4pKmhCsUT+/aA6yyVRaQEzN2Wmknk+WrSrtvDVxFx4j2dxnT+0jto6j4uL?=
 =?us-ascii?Q?oCPb4YoBu0IspUE77KXnBKQO/KZlGY/VQisZYd9LE60g8PZNZ6KsJw23iGlT?=
 =?us-ascii?Q?DeKdqJJZPZmal7G2AtwYzPC1OPm/3+EMWzCy2eU8qQF3vMjSATIcPAjb+qHK?=
 =?us-ascii?Q?nQXkiWQWCCRkVmVxsDCkRAva6kQVxrYkabY1yCFKIwfP9MMOfw45ztjFsO0+?=
 =?us-ascii?Q?+oxb69aTyIHJn6Ae6NU5h54fZuEmUBNjEINAK+uB6OF+UJ0XP1iEBUMPCYT7?=
 =?us-ascii?Q?k4lhB7Q09wqog/Zv+mlmp3QjDhmtr3SqYv0/d++IHsl5d7d7eIZnFg/EmOs0?=
 =?us-ascii?Q?nCPb8YGj8+7kQJut9lqTXfuepJDhDyt+cYv3XPC9EMxD4BztwjL5bNHc7uZb?=
 =?us-ascii?Q?4EfQnAeo8e4r2znZMAqrLeqnjcK/cvKPP/a9K8On6R3G9KMwPnFqMNLmZSwM?=
 =?us-ascii?Q?4J59eRNW2lKgiiwcg25XnPlOAhg2xhZX6pfF8uJNyvkGg1A88U+XBoNIV199?=
 =?us-ascii?Q?KdAGrtE3EPAtaNtPDmOM2/T1DO6OiDGSeqzcztodDdny7ca6sVOoBmFtEJbD?=
 =?us-ascii?Q?02Fybh3xBwdyk2UdB8SKk0fh8Q8phHR5vcU9lCUDK+SB+b7HzGVIb/iOXANg?=
 =?us-ascii?Q?03/QAo7rJmsvTK5ZapudIrdVlSrINsJakttr5Njx69Yri+o64qYhhmjz3wpO?=
 =?us-ascii?Q?Lzza2PGJvWzJG4O0AWzwYfev/YYb1GrBu+OkYvP8G14N3jTXFeAYvbmZ82Lr?=
 =?us-ascii?Q?V3TU9kBf5FiWOuEZHCJp7WZrx+J8R3B1xg/CdjYn9v5NPWSPOnZQPqJR5uZ+?=
 =?us-ascii?Q?QK6N2xIvL3xpbcTQPIrwMCC+qRtruxAju2NWkan7p8Kw9e2av5w5agGvns3v?=
 =?us-ascii?Q?Edo2n/GsTDnqjmvsk3Glu/KwfKxUjY/RheKM20f3FW1vMtEaMywh1tHSJafO?=
 =?us-ascii?Q?baudHAZUXnc9ngSqYFPqYYo3IRv7AkIb+vc6hZ/6Atrs8D/bQ7V1pKlFeyY1?=
 =?us-ascii?Q?hcbtcqfrKdIZXneARHB/U1RJE/zpjPqEbbfAiVTR0Tnv/C4ynr85bqOrcwBj?=
 =?us-ascii?Q?N4pl4pom/wAv/C7YORa+jJhC2eXtDk2pu4Lf2g9jEVxUPool3yb5FFOQeJib?=
 =?us-ascii?Q?XRld69tRH/knbz9Pf5rd6jwdLDIvRMIioTOsp1Gz600W01axK9ZggImix7Tx?=
 =?us-ascii?Q?H/+p+JrhccNyUc5D7igRdW47IS9C8eI0LH7uPDHKaI1MS8jatQqJvVC+1vc4?=
 =?us-ascii?Q?Wbtfica7rk2b/vTtigNDJV8INNVGRVs=3D?=
X-Exchange-RoutingPolicyChecked: S+585xRtkH3+w93JQn44htJ/W8EENxLNYk3n+kU6JOCAxLPDzt+8Dl5KSODr8WxKESSRmDmSDB6qK5yUuX29NcS2rc6GVLFltE/BIirMDpnHPpeDOnoQj/67xXzxlAC8WoJl9KkKm2dDr1W761CAUiGo0UZbRhxjrtSsUK+oih37DvQIBqISEiiyY/PuqSiYGg/iF9lir5v9GVDP2NBmBvSSz1rxNlp35/bRar/j8JvGO7AH/NoUaJNHQ7D6mm7UT6QZ4vyAUl3P3T/WCvyd3Lir14ld5bPGQuKMqPVXyjN46nkYe0m1AqeCtXix9e8dzIlA3wmUNZd8RNXX2S3kvA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1145749a-16ba-4033-3f6c-08de8c5ae2a1
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 23:45:11.1698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1b2qr/JyuGm80EcpdtA0txwihGxcQls07Tt0JwAD8kd88vrEg8mYewQm/zZlypUESg/msC3WckRiu7gKWr/GgXcvsQgmVtNRCbDlGiNM81U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8254
X-OriginatorOrg: intel.com

On Thu, Mar 26, 2026 at 10:28:15PM -0700, Dan Williams wrote:
> The dax_hmem dependency on cxl_region_contains_resource() is a one-off
> special case. It is not suitable for other use cases.
> 
> Move the definition to the other CONFIG_CXL_REGION guarded definitions in
> drivers/cxl/cxl.h and include that by a relative path include. This matches
> what drivers/dax/cxl.c does for its limited private usage of CXL core
> symbols.
> 
> Reduce the symbol export visibility from global to just dax_hmem, to
> further clarify its applicability.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

