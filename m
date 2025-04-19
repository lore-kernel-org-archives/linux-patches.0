Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87502184F
	for <patches@lists.linux.dev>; Sat, 19 Apr 2025 05:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745041646; cv=fail; b=EGv2VBppjIx+4OzlqpBk2/GkOg7xm3LWDgwC7RgPFENAdmW8DJ0hypcRYQ8V3olPIpU6xN2VU4SiJ95CZR4pzjTQx4K3FovtZbj82sekQNVqXN9xQd3Egz57P2rw9NDodS4GkYxGBz+RchgmovvIGCl5lDxLdvzaUE4DLcR2kbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745041646; c=relaxed/simple;
	bh=vS0TbOCXb7jGCZRFiRTnaIQRpc+rsmQQtkZTxTPWqbE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rmYQg7VgEWw3brj/gmt+XVGjztVAVzWNcOkX74KrfQ+2rBDpByeR2kTyS2D55TANqHcwJXx5pMWFf5zRBwP5lXj26WcsS46a3Unkkz5+oN4+JLfPPvZ02kNll06BFR06Joa1WJOKlcYC+779LglGB4YqlIPg7lf+Rhh7tOTfLDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HUBcitzc; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HUBcitzc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745041645; x=1776577645;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vS0TbOCXb7jGCZRFiRTnaIQRpc+rsmQQtkZTxTPWqbE=;
  b=HUBcitzcKA0i6OPKANRk6gJQFzIpJX5zvHZtvwf02daIgmr0dc6oxha8
   vbR8DNeHsbCM1/3J1nO/dFUwUR8ADjhOYriNo5g+mDUF1ACkmy1QF71Zx
   u3LB4Py+JMSCJEjFLAL2tBVcCkBDrNSQLMzpQqkNWLZn3VJUJ0jfEMONH
   7sE5efnBSktKIWLgvbJ3HFnWFrBYzRaebE6fW5mYD+uszYyfvfJJgzJKJ
   m7eOnW3WHbv2iiC81ZaJnbrTkKB8Xfc0n14f/A1oXPwL8ycvOH1ca4pEc
   2eXqh3HLV5zzOYenvXrlslai9E9NK0mmQvWdignHTkpL2s2i0jmvNKye/
   w==;
X-CSE-ConnectionGUID: +H1/CQoMQ5uyJpDWnBHueA==
X-CSE-MsgGUID: Ky8VjvtgSBucUYPaYBvS8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="46765684"
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="46765684"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 22:47:24 -0700
X-CSE-ConnectionGUID: k1E4UjORQ0eB98WrCnSUww==
X-CSE-MsgGUID: /cpa83teSeSvGBZnoMYYaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="131854085"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 22:47:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 22:47:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 22:47:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 22:47:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gJl0zcl8O7uS6iYSxoZW9b3sTNtTJojIUu/m5KzbglmIejhltZzx3DyllMtG8p034SeoWjVl0NzCLDaRslvL9T5/ziDgd7Ymo2nvqZspsAinouWPaHJzdoyRPgchVcxQebmw1Dp1xtRfylcK+1H8FOEGGq/FwPmECBL9S4Z4NCJzBZFXWX4fIEig5gmawHmXmnCIDof5QjsPmnY+m+He8fSr5AUk9zsMLfceNCPW4TvdkwRNe3931S7AELZKLWhCoi0InpI0Btef6Ywq4nJSGhTfP80cE+Kwx2vb7UIx2IWC8Jl+vGjZ9MPVLESqL/rqJTxBfjZaLgAN6tLvvSK0OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vS0TbOCXb7jGCZRFiRTnaIQRpc+rsmQQtkZTxTPWqbE=;
 b=g2PZqX95xho1jsH3q3wBM1coQBslr8laqPWBLJv1cu2ywuyF//vabgT/vCIt7FGxKA6fLVh3fE2TgohIJuJW28TALaj7Aja70Xmdlb1e7JwepaatQeCvBRvxRXTebxL38iCVG38En4gwNtsAgaAvXrq9s3TwrS/3RPQwZqIbfdy9tVVBq+VprCrTapc5ihtCKDhhHygm7FCu09LZ9VdTBlyIa79/8EJ0K190KZhpLsdSaGWjn7JdriAYYIO6JYLeq4YYOx2MuXVI/9Iqg2TjalZbuwieaS4qF5BcoXFVDrsnvMZCaA5Xnr/3v5f4LJRJgf4KbB8rbtZpcCF9fyyiFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB5156.namprd11.prod.outlook.com (2603:10b6:303:94::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.26; Sat, 19 Apr
 2025 05:47:06 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Sat, 19 Apr 2025
 05:47:06 +0000
Message-ID: <51256c94-9621-45c2-acae-9182b52a2221@intel.com>
Date: Fri, 18 Apr 2025 22:47:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/26] x86/resctrl telemetry monitoring
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0097.namprd04.prod.outlook.com
 (2603:10b6:303:83::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB5156:EE_
X-MS-Office365-Filtering-Correlation-Id: 89a1d7ef-6408-4e1e-8c55-08dd7f059e17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y3p2VVVjaDJvb09vMUFtOU0wZS91RzNTMzN4Q2xnRi9lcEFmbjBnSi9yeEoy?=
 =?utf-8?B?dzNsV3Jjcnh1VUNsajZ3eDdSTG0zekF3VGpad3VNZ1pnb0V5eUREVktXSWdB?=
 =?utf-8?B?b0Q4NGs1cjYydGJUdHIxVXNPMWt3REQ5MUdZSy9zbExqdlpSazV3Z2xFWTJB?=
 =?utf-8?B?c3hDVTUrMmg4N1NXcDhaaGlVeGszSTJEY2xZdndxT2IvYk9tVERia01UZ0h4?=
 =?utf-8?B?a052b2x6YUNlL29LWTZhU3hwbC93NE5DUUJ6Z2cvdHdMK3hxNnpwNEhXaThn?=
 =?utf-8?B?SmlRNnVoYUlaQlJ0ekFUMjVYMDJYZWJyakVPUG5vV0FTSUkxc0VXb3VTbTVj?=
 =?utf-8?B?b3BEdzFBcHVSYXd2bkNTSmQyMitrVGpkT2ppdS9nNnZTcHZMdEtlOTB1T1Nl?=
 =?utf-8?B?VDB0c2JaK3l0emhuWEpFSkt5d2YwTEtXODl0U09aM2hLOXgvb2FhSzZtN09y?=
 =?utf-8?B?WTBpTFl1RzBhY0Z0cTFUbmtxaFBQWnpmWHQrZFM3LzZmby9ibUlHZGpZRXQ5?=
 =?utf-8?B?bFR5biswWDh0Ym54RTdCQlBoK3d3bTFhQU5CcXk0angzR2JpUnluQVR0alVj?=
 =?utf-8?B?ZGNtOTV5RkVmNUlFdm4wbVVicGFoS0xxVU5ORXVPeEF3cDd0bU8rQm5WNnd0?=
 =?utf-8?B?OWI2OVZzeEdWVy9Cc283SmdPb1hzYkFucVJlQklZQTk5UGErSVNzeHR6T1Zl?=
 =?utf-8?B?TkVXV3pHSGFkS2ZTSVVKZ2tFcDZ0cTI3SWZwbXp2ejkwZnJpRUp3N1FFdm9u?=
 =?utf-8?B?NFE2VWVTaGpIQUo4VE5JM1E1QTc2b3J2dDVZSXloSUdlUmU1eEcreGJOQlRh?=
 =?utf-8?B?Zk9pMkNLazUwMmhtUUdlakE3dGhrQUtOc1RGWUpCYUkwelJBSktHdGxuOENY?=
 =?utf-8?B?MVRlbERmWlVHQnBzMjJTcmVpY1lBSnhXM1FORkxLUXNxMnlZNGNaRkxJb0Zr?=
 =?utf-8?B?c2pndW1tc2FBc1M1UzZ3cnNma0pzZll5TGJGcU9aR1d0MFBBajFUZmhhM0xm?=
 =?utf-8?B?cXhlMmZrb2E2RHpybG1DWUJLQUYrRjltRmtGbFFyYWlsSjBSMTh6dUNwOVdh?=
 =?utf-8?B?U3BzQVpFL3IvY0NxZnNDYjIyclVndkQrM0xpSWIrS3ZIREFuMHVwc2hYdEp5?=
 =?utf-8?B?SHE2UGJWeXlYWnlZR0QvdnRaVVRwVjM0QnJieGdnRGtVQllMcmwyR3gvMlNS?=
 =?utf-8?B?aFo5WXhpUnNadW44TzQxOGR6VzU0MUNkYlFCV1RKVTZvWkc2L3pXZkdkMncr?=
 =?utf-8?B?dlplTHRET0FiY3k3M3VBSm9JdmVoNlRzVkZMeURkY0h2TUhHdWI3dm9LV1Iv?=
 =?utf-8?B?VnV0UCtoekhHSk9EMXlBenU4Ykh4TzhRNEo1ZUJJeUlaZXlSMWNwYUhzOHM4?=
 =?utf-8?B?cU1JcWNNL0pHMXM2MFRoNVBWSlVzQ1BoZHc2bzZDZjZsUkJDZk5vS0RObGFW?=
 =?utf-8?B?UXMwWnhuMkVXNmloKzNKaENFUlByU01lSGtWL3BVSnZrb0tBb2N5NTZrZHZy?=
 =?utf-8?B?bUJtY1h3ek5oVk5WVmxSV2hPT2xyeXJhZVd5U0xYcm5iRUFuZEZXOUtSZnMr?=
 =?utf-8?B?a0NJMGZsUEJDaVhnK1p3VnRraFJjYWpCNWRwM1lZWUZxbmtueGNQSWlUQUw5?=
 =?utf-8?B?M0o1ZVRNZWZidnl2WkZQV3lTNThBdDBpWTRBM2tmOElsKzRxK1hMY3Y1R0Rm?=
 =?utf-8?B?WFBHRElPbEs0Mng5S2UrTEdGZ1lHbFBSeU1VbHJCM29zTzRBUTlYUlZMczh3?=
 =?utf-8?B?RVpITHdtQjBsYXdtcDB6SjhLZlM2d01oVXJHMVZPMGtHbzlhdzFCS3pVdnpM?=
 =?utf-8?B?YklpTEJWUUE5dUY1VCtHeEVPZUVzWHZ2NklDQkdqUlYwMk9jTzF1ZXZYTXcv?=
 =?utf-8?B?bFVpd0tiVDl5eFg0SUcwd2txcnFXZmVDcHJoUmFrZDEvay83Tm56MW9pUGJq?=
 =?utf-8?Q?oHkahXVLvH0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWtpQVIyc0N5eWpRVlMzc1pDMUlqNlJjSXNWd3ZueUxtaWZ0eFdkV3F5dDdz?=
 =?utf-8?B?WlFrakRnN0dBMUJLQzFQRXRmYmxFUGtZTjNXOGVtWmRXUU1obHM1UFNXVjRv?=
 =?utf-8?B?TzhQZ3JTSGQrNFZLRkswbGU0QmpyU1VsUEVlaHVaamxVRUVSb1d2NWY5Unc5?=
 =?utf-8?B?dVpyNmdhNzRqTlNKVU5iSzFPRWswNG8zUFB1TFMxUElXclhJNGVhVitsMlZk?=
 =?utf-8?B?aG95amJYMEpGOW9QQzg0UXBKWVFZVUREQzdhWTdYZVphK0dKLzhibDVxakFz?=
 =?utf-8?B?ZVNzeURRb0ZPVVFRTWJiV1NjNjUyUFFVZFkzOW1INGs5QXRqV0E4WEZRUDFr?=
 =?utf-8?B?OXlISXU2ekhBTHFXbm5NRXFQR25oRFVtNHg2YThsTFdFK3UzdXVMTXo0UzVF?=
 =?utf-8?B?SDJndHVMS25ER2FJV1VKZHNoZGVxUHFYZWtXZmZ6VldCemhNSU40S1R3L2ow?=
 =?utf-8?B?VnB5OWxFSDloLzlEa0R0Nlgwc3FSamsyRE05MW1aNXJEV3Q5MklEb0YxbEFQ?=
 =?utf-8?B?MmJBV3hyc2s2bUxYVVU0dm5KK1VFMmkwWEdWblMydVJRZnMwMzBrZ2VLUEp0?=
 =?utf-8?B?NTgydDhMR3NGdlNxSEROOU04czVKNlV5Z0xHTFpVNFZrUVdwNVljSWNzcUQ3?=
 =?utf-8?B?WlJvODN6bkNqSVUwTkQ1emFmL1NFcDVJOVc2Ymo1b1hXeEY5aEZvcXB1cDlF?=
 =?utf-8?B?dXNnWXNMY3FXWDByM2lWUFltN1BhdGxuK0VrTU56OHhyUFJVUXVqVmZpSXpU?=
 =?utf-8?B?RTdSNkdsbmV2Y3Z4ZVJmQnlLbGMzc1hGR0lPTFdkOUtBZEIzRExMSDJpR0RS?=
 =?utf-8?B?WEt0cnduVlJSQnNoSWJ1SnRzR0U4L2Z3TTVtaEZDNUV5YzZGVEorSXArUGVM?=
 =?utf-8?B?M3htU0Y4M0F1Wms2eEVOenBUY3hXRXdCZUdlWHhsbS9GSy9kVEVpb2hNRnBC?=
 =?utf-8?B?MFNNRDdQTXViQ21rZ1NJQ2hkOEI0VTduWWFnUnQyM01YNzlIYlh4bUloNVNI?=
 =?utf-8?B?Y3pkUXZnNDlBMDZBR3NEQXUvbGFKK0NpdVFraEFDWkhyQjZEdFVrWmhxS01i?=
 =?utf-8?B?amFYZWV4WHV2ZUNLeGZ6UWRueU45QmRFUk1DMUZiREd0Q2JxempqOE5oSkJn?=
 =?utf-8?B?Q1h0ZVdtd3p4ZlplR3VobzY2NG9jSnhPck85YnoxRWs3NHF0VTN5M2pjcFl6?=
 =?utf-8?B?Q0ZjT3c3Y20rQ3RUM0VUODkxMjBmaXcvcW1RMzBwOHdoK2VLQ0wxeDZLRkRl?=
 =?utf-8?B?b21rQUZoOFhyWWtkSjJPbVlpMFFUZ3Bsb2lobU1abURLc2IyRVJBYm41ZGZy?=
 =?utf-8?B?KzdwL241czlRcHZNc0tZSFRyWkRGYStLUEdNZ29KR3NhM25rQ3NCT2ljeHBR?=
 =?utf-8?B?Uy90S1VnZXdlTTIva3RVR0VpNjlPQ1h3YTE3SWVHMnV2QnJsc0VhZzM1UFJB?=
 =?utf-8?B?dnNWSkRwRklwbDYydGVMdWc0dXpKQzBGWEJSVEdqS0s2WEhuYWM1MFdibndM?=
 =?utf-8?B?akwzdlQvNDNOcE56RXZkbnlLOGZNWFNjSGV4ek9UUUwwRlErODRJeUhidEJ1?=
 =?utf-8?B?ajBRcGxySDAvT0hVM2hEVk4xWktnZE1JMUhDQ0Ixak15TGlUaDhMcytleVdJ?=
 =?utf-8?B?ZjVpc2hLa05URFhPbTRmeXVRd0l2YVRyVCthb25kcUJRN0FrdE5KZTE2MTA5?=
 =?utf-8?B?cFNzbm1aalY0K3VWeU1OQ3dib0RpUUpOcmFmVjNsS0c0d2FHRVlkV0dqSkRI?=
 =?utf-8?B?djR0N0NudjJIeUpGZ3VFRXBkMlk5TXBYWjVGZkN0dFNzVFcyemg5QkQ4UVE3?=
 =?utf-8?B?VjBScVVhZVlqb3ZZSDU0ZVVOVVR2Vk1MYldJREdxM29Nd2dXV25QQ0tjT1JH?=
 =?utf-8?B?NTZTRGFlMjk3MGIrZStaNW5SeElHdlNlbjI4c3BnL1lsWUF5UWRvZ05jT2Ir?=
 =?utf-8?B?MVFJSFNYNGwxZVZ5NzUyVTFGaWIxQytzVXVNY2NUVlBUenp2ZlNrbWUxUHdi?=
 =?utf-8?B?RHpIeHJBWHl3dEZOQWh3cVFNTUZQUXBSckxCdEwxQmZDTWJUYW1XNDVFak94?=
 =?utf-8?B?TG5HUDBYMEMvbld3UG9wWlRnZFB6TDRPSFVyeG13cUI2R2h5UlBqTDVYeVg5?=
 =?utf-8?B?WEJkRUVpS0Fyc1JsN3RUdEVkT0FXT2tkOUN0anZIUytkTk9Xb29DUC83QTN4?=
 =?utf-8?B?WUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a1d7ef-6408-4e1e-8c55-08dd7f059e17
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2025 05:47:06.2283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +tnrdpi1ChXhaA5PSdTiTS/PssPRoVtVlBwTGbd+WlVq4VGOUog+Q0OJ7SuXDW6qgoZDygsBTBlNt4E9faP8/hc/H1DkOkyrqGBa04xdFWo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5156
X-OriginatorOrg: intel.com

Hi Tony,

Just noticed ... could you please include x86 maintainers
(X86 ARCHITECTURE (32-BIT AND 64-BIT) in MAINTAINERS) in your
submission?

Thank you

Reinette

