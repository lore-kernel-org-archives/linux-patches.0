Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C881F4C9F
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 04:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761194144; cv=fail; b=l7KYSwfS0OEZhfvWPN0KHQ0qzB36WsD+X1+IqxFh9OsRL3dmP110282tBQAqN9iEbZy/0mHeFrpMpeo3LkPQ419bUd6miBbp3yqaM6QQc/VtjLHtctPSxR3uGSpcCp5nP3RjfDeYnZiyT7Bg38OYSirCj8eeKqIJO2yTtIdLkAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761194144; c=relaxed/simple;
	bh=PZr+eInM8WrDqC8s7ukt4OadTvuncwGQ1OB4DTNfUBU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AT0t2USlK0T9lJEazJQG6hy4csZqhBqDinsX/edmnCbmz+tYzk1Sq/VwRBM4gnVDnC3aqYEXrYMNQ9T5rfYLdJErRDw+EKj5/ioe9a2d4D51ej2HQ36eLy/JzqHTRVzz7o3Yc7kmCFex8UEEqtF3ccHi23wzN8DW+OuN/e+NGTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ktgyz5xn; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ktgyz5xn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761194143; x=1792730143;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PZr+eInM8WrDqC8s7ukt4OadTvuncwGQ1OB4DTNfUBU=;
  b=ktgyz5xnTMVtTwznAku1Z/5ceIBRoqVkcPq/pRKJ3OElN/q4VFZxCwOf
   QDwyXJRsuef5IRqlyTiJsRDuzAz4ZpmOsegf8Bhweqsn3o+9W1jVGQssg
   MDWKssXurO9kE94lXfbKKZlJvur+tfueWYRynxzM+ikOR7KETynsQqwdx
   7eV4AOWoVwKEw8ohvbmK8byHpeBX3sWMZBVikJ5vLTeBwW5MrSJnalYWT
   DG96uDrkCwevyswCTi9vcwk3jxmlP3Yos9kp2TQL3L1vyin2U/zsdB61A
   V9sdxUdvzaPeK00m3+FnlI0AmhKiababdWQ6VYrOQwqFyJdp0PtiviWCb
   g==;
X-CSE-ConnectionGUID: A2g4i0wORJWM/ICtm8si7Q==
X-CSE-MsgGUID: YHv3H0M7SiWM4b8OO1wE0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="67218899"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="67218899"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:35:42 -0700
X-CSE-ConnectionGUID: Guew7Y0vThObXPtCqXXhTA==
X-CSE-MsgGUID: 3q6CT2mcTWea7wZVtk68dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="183272229"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:35:42 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:35:41 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 21:35:41 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.31)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:35:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RolLIodwWonkSC0Z1SY6WaeoitXaTSu7f6628zkHy94ufjIQLkbzLOBBm9388/vlwXevNZf5rBTQxLCgQxB5/gjfBmFwNDqM9w6ocSkjga9NHl38TDwhrI0MlRTs4/KMwC9Kx42Kj+uuaSKkYnhiLiDHUj3AdxSC1fX+zzqHT95WoQS9unJ1e2EFcFmPgPT+pKIj91pHHDZuPCUZR+us7zOY0Hsx/qFOi7c0e0jULm1f8kOPgm8f5snIaXgQoLLRn2iYmjmH/7x05PPJrU/34T+x5rt7Obf37c7qExoc9cqB5rhT3hPE3ZE+m98h5G3M2RwnQMLjPR7pMObDp6bTjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3g5GFr6BfrXidPxYwQRl6potXBneILwebIksDDd7ti4=;
 b=k+ExhUdbVOOvBqs5jyoUPmMktKmkVWsPLICdbrLXLnNBgupnDDVUUYeNuNq4/l83TMDgEp2/AgmbSpQf0xvHgMaP4FCSaFxVYgl62ULf0dgPVunpkj1k/qYUanZ/+7WXkRBt9Z3kLUUAFzcP/4bI2j0xB+4JO6zdCseswkL4+OUWdCI2o8o9EPGF2F36aS3IedORxmd1Ap0kwmu6NuIB3tAhyhRY7Ib/T6qG2j03XNHf1sO7oBwEDRtBVbEEP3qvB11NDptc0/1AT3gCJuf+P3DIYftP7kMVYog8A/9GMqnMIxsM8/zKTomszkR9sbtllfb5UMa+lzc77DK1DbEx7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CYYPR11MB8408.namprd11.prod.outlook.com (2603:10b6:930:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Thu, 23 Oct
 2025 04:35:33 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 04:35:33 +0000
Message-ID: <e673afcf-fc43-4227-aa9c-bdfdf5561cb3@intel.com>
Date: Wed, 22 Oct 2025 21:35:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 17/31] x86/resctrl: Find and enable usable telemetry
 events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-18-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-18-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0294.namprd03.prod.outlook.com
 (2603:10b6:303:b5::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CYYPR11MB8408:EE_
X-MS-Office365-Filtering-Correlation-Id: 7afc309c-c716-4877-4214-08de11ed9a80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dXZiZEVTYllPSTdNZ241cVJEOGVYZmlTVzdwN1Z0ck03K0I4VXNzdFo4RGZX?=
 =?utf-8?B?bDIrUFVvYUMrbTFGY1pSODZNcVA2azlBUi8zc0lTNWl1UGo0dzMxWlVVclE1?=
 =?utf-8?B?VkVkVjB6WjRSZDhqS3oyWFJlQ3lhdFZZNTRoQnZPb0tYTmtvejdtVThCWU0w?=
 =?utf-8?B?MENXeTZ3a051TWVRa3hnY1pMYk0rZDFla3JaNXRQazVPaWRhemtKeDBybDJI?=
 =?utf-8?B?amlRRTBWN05WZ2NLSk96ZEZyZ0sxRDdQSTQ1UkxrdXNaZ0hHSFpiTHluL3gx?=
 =?utf-8?B?aWNvczIyS045SVB0NSsxUXNUYjNGRi91Q2xZclNkVll5a3BBVXN5NlFldnF5?=
 =?utf-8?B?WXo3U0doa2Rtekk5UHl6d0pScUdiY2RaTXRMOXlSbHFSQU1nUTZFTTI2aXZV?=
 =?utf-8?B?b0FoQmVvSENIWTZGOEE2SlRrOW15eGtRTzJVV1FWbWhoN1E3ekJLMiszSjdm?=
 =?utf-8?B?V0tmbkJkemJnazFKTWV0aGx0eVdsTVorY2huR2prZjRMREZTK1JSTlpYVUp4?=
 =?utf-8?B?LzFsYXVubEk2dUpLMWUyeFVHcysycDk5WFpwM0Z5TFVrOXU4OW0zTzFURWNV?=
 =?utf-8?B?NTZ5eXFtcVQwN21nbFZhTlpPRUI2TjhWZUVmZlZDZjZRUndtaS9nNS9XeXZl?=
 =?utf-8?B?ZXAzaVIvbXNObjJCdnpRSzIzZUxRVUpHeFR1VVBuVjZhUjNRSlloc2trWG1S?=
 =?utf-8?B?WHVtZTN2UHFNbThjNlN4OVlEMUtUWTQ2SjJYSllKK3VXRHpiZUprWWd5aURW?=
 =?utf-8?B?bitkMTFvQjR5ZytDckljR0ptcUtlRWtrTGRZcTl5Q3poUUVFLzZhSzJpK3ZQ?=
 =?utf-8?B?MThIRTA0N0pIQUhuOGNueCs1ZXIyajM2dk9JZm9pZzhBSFpDbDltZVVhelk4?=
 =?utf-8?B?cCttalc0cTNlMExkK3ZjYjdoSU5hRlhqd0dNQkxCN2RDeHNvYWlwSmxSM2FE?=
 =?utf-8?B?ZXNKa01HbHlWUVV4cHBkMnRka0NVa2ozNGFOUzRGYVJrZkF1YzBDQ1ByclRS?=
 =?utf-8?B?aTJKYXVQbnR6QUFRL3loTjMrUVpsclFxRlhCQmlvNHo2ZDcrWk9sU2RCVVBl?=
 =?utf-8?B?Q0w5dkJtdjBweFlQUmRjYmtnNFlxRGZZdzhPbnJpZG10OWV4c1BOZkdKNk1y?=
 =?utf-8?B?T2FaYmREdU0vYmxZZ1hteDlhODZZbXZVWVBxVG5qVlI3R0pkVStENDYrWHF2?=
 =?utf-8?B?eDlqSmxUZ05ySi9xTjh6SkFrTEF5a3hMV2xVSEd0enNIaHpZT2R2TWptdTJ1?=
 =?utf-8?B?azd2d2J2b3l1YTAvVmNhTmRLSjZSaU5oL0cxZHJ2SzVkc0NZY3VDekg5K1Uy?=
 =?utf-8?B?Z1ZIako1eE91dTJNbDR5b0dXZXlTZHVJWHg1N0xCbmNKZzRBUDJrK3ZEZHhp?=
 =?utf-8?B?d3c2d3FRMXAyb3ltdmlFOUpmclgvK0p4eHFHRGZqUzhNM1psQ2Z1bys1OEMz?=
 =?utf-8?B?ZlhnNXhmcklNekcxT3lyS29Pd3hvbnFmTERnOFY0YWIraWdnRGNTZk42K05V?=
 =?utf-8?B?UlRXR0tlbmlXa240NVVjYy84VUNYY1hXcEhDajhmUVZHSWRSVmIyR0JyczBW?=
 =?utf-8?B?UEpxWVBJUUFGTEdMU3M1ODNMcnMwK0ZQUERvNmdIZUJ1Z3BPcUk4TjVOKzBz?=
 =?utf-8?B?eUlvWVNiNFFOcXBCNmd3MGdRdVVFOFZobk9rRXNRVENTUzJ0RW1iVmhYT0E3?=
 =?utf-8?B?UDJkSzh0SnltNE1UbjlEL1BDREZDZ2NrYi8vdnhvbk1wcHBxL01JVm9zOE52?=
 =?utf-8?B?dGM1TUtRQU14dGhtMGFCTlprSk1MNE9VcStPWEVydGZNclZtTUM4SFFhOFlH?=
 =?utf-8?B?azR5WGoyaHkweU5maFZ6NkppMWdrMW1RVTR0a0VQckErY0RBUHRsQWtMdDh5?=
 =?utf-8?B?UFBoTGN3UHFoU1dYN3lUOXp5WHh6cXk4YU5WaVZxOFZwNHdGcTJKR3FzL1dL?=
 =?utf-8?Q?ZlVUZsvTELFeMexkwg2n22MJcp0OAUXN?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VnFZN00xbHIwdmRINDVJenN1Q1MycXg0UC9qelZ0N0U4TDdyUG5pNEUweHI2?=
 =?utf-8?B?YXhsVG5ycjBnejg4bnVzUnB3dFNnSTNSNkNqYVNvT2NITG1TT2d2NEF2RUdP?=
 =?utf-8?B?d0MzTm1mZTg4b2VRdVNhZG85aENWM00vTkN3bzZwVVgxYVd4bHQ5VWRMVGNB?=
 =?utf-8?B?UkszdDhrWXFIeFlzMHZONHRXTWlacUVJY2QwTTZUbzVBTktaQXRJUTMrcVUv?=
 =?utf-8?B?ZXoyNk43d2wyeEdFM0F5ZDZPUkZvQ2grSFovV2lWdWt4d3ZMSnV0YlVaQlRp?=
 =?utf-8?B?SkFlM3hKaXhCenJxQXExVTZaTENaSVV3MzZEelhaWTNoYjdXazhqS3ZpRlRl?=
 =?utf-8?B?dEdZekJlYUV2eURzK044MFFGVGV4YWRLM01Ia1VBN0t6UW9zVnJRWFZZRmdm?=
 =?utf-8?B?YXoweWNBZkttK0FUT2Z4SDB6U2cxY1UwNElOVVEyZFhHMlFFeXJWSUdtdS8w?=
 =?utf-8?B?MnkxYjIrZmVjcjdMUG8xUW1xYk0wMnhFM1lqN3lMdVhuaWVmZlZ1TjdzOU12?=
 =?utf-8?B?bW9aQ1lTS2R5RXJFTC9vUFNDeGhwQ3plYWNYU1Y2Lzd4OGRERGJ0azRxV1RV?=
 =?utf-8?B?SU1wR0xHd1RZNEJTV0UyS3NCdm1lNXVUZnR1SjZ2WVJ0RWRoa0JsQ21icWtr?=
 =?utf-8?B?dlRZdXd5NDRqK1VkZVVCSGZpOEhXdGI1ay81eGJ1OXJaTmExcTBqYzNEOXVp?=
 =?utf-8?B?VFVtaHNqWFNOb2FwWXhjNDdsNzFJS1RsckkyelU5TjVHWmcrWWtlWnJNK0Y0?=
 =?utf-8?B?b2JkNUJlQnIxSksrbWV4NjVKWDJEUlIyTzhxcUQyYUtxYTZBUDJRVVhoanpV?=
 =?utf-8?B?anRlQUpFekZ2YWhGTlBCZkdRclh3MDZ6dmVkTUo1dXpkbVcreEx5WlZnOGNF?=
 =?utf-8?B?a0lheDIyMkRZOWxNUC91K1lwS1VQZUFOUE5CUGdKbXVRWm00VjNKd3pHeVBB?=
 =?utf-8?B?Q1FvUUFaUzViK09zZm1rek5YV3pJUUhnODVyZThTQWVNQXhlWGhOSm1yTVE2?=
 =?utf-8?B?eDVZaEZLL3hsQnNPVEtwRFE2Sy9jSWZTTjNuRmR2cnFIUk1UQXRmaWxQUVRM?=
 =?utf-8?B?RzNpVm51ZmhGM3EzK3hTOUJuV3ZycmJ4Y3Z6Vnd0U043WHhUKzJJd3pCTHU4?=
 =?utf-8?B?bW1xYkZZOFk2UUhyWE9LUk1hdEVLb0JiZTFjSUhUTUplZmpJQTlRNk45L1hD?=
 =?utf-8?B?TVJuTlV3NU12R2FyZG1tYm5aSklDZjBTM0ZtdllUWGtOMlBhMHJtSGJQc2Nw?=
 =?utf-8?B?NVlCUWp6Y1ZXYjQ1Qm9yRzg0WGpnNXhDdWh2aFVBMDQ3SFlPRXowYVQ4RldZ?=
 =?utf-8?B?VUdWZDUzK1NwVCthU3VtQXU1bXA5L1F4c1NNVUVRZURxV3JZemdGWGRVTHly?=
 =?utf-8?B?OUpXRUNiQUh6STZCcURYdTFuaDFCeDZyTFRyWWJ4cUI5akNlY0dkUmFkZzJz?=
 =?utf-8?B?eGNQankwckZ5eG13L3dhbnR2K2dUQkwwWTFkY2JYSWVzR2xTNUZ2YTBGOGJ4?=
 =?utf-8?B?aGt4bEM2TnRhLzFEMmtlKzlVWnVUalJWdG52T29maDBwclE2Rk5vMGVPeEsw?=
 =?utf-8?B?eUptaDdLTTJabGd5bUVHVFp0U1NBUGRoTWFVSlloTzdXek5SSHR1WnNpVjVX?=
 =?utf-8?B?V085RUdxYnRSTjJaa0lmSWwrdXdKVXEwRmxFUlAxK0JvYTQ3QlZuVVRzNnY1?=
 =?utf-8?B?MjcyVngrMFN4NjlIM2J4OTFVRmpOdnJmQmhnYmZkN1l6TXdaNStkcnNRdWlw?=
 =?utf-8?B?SFNIMFh5SE1JQk9MY2p4azk4SEZHUkNFZVVDa01FeGg1eis2MGJhemJIZTZV?=
 =?utf-8?B?WUl6L085NGI3bkxFZStQSE10ZnpiL2tPU3h1ZDg4dFc2V25ZTnNFT0VtTnJx?=
 =?utf-8?B?NzJDbFpyUXVNWTJsYjUybEVucWlQakJXMmRpeE1FUzU5UExTaTluN3FDcURU?=
 =?utf-8?B?V0N0cm5ZMTM2S0J2WVB2ZmtMSnp5MXF2UHVVdUNralRlQ0xQUXFxVGY4V1B5?=
 =?utf-8?B?cm9pKzNoTFppak82U0grc0R6MHo4ZHFub0VZSmpOSE5Ba095UENqa1EvQXdo?=
 =?utf-8?B?ZkZiSDVJeGx6NU5rYm9iTmR0aGNBUllJZTJCK1BoZmd2VFpjeE9FNU1pVDcx?=
 =?utf-8?B?WGJnUll1UW1Jb29xTDVWMEh6TEJxazVEYTVtaXVwelh3QTZ5bWQ2ZlJOZnBl?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7afc309c-c716-4877-4214-08de11ed9a80
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 04:35:33.1130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17+nyMW+qiX4jLh1xWqlu6WZHUIrlHwRkcrHuL5DjsdSDqYkctF89aOT6g+oJSsgpF//NA4wS/jcWP3CFLRLnpj3+/mvKqbV3sXrYUXhzas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8408
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> The INTEL_PMT_TELEMETRY driver provides telemetry region structures of the
> types requested by resctrl.
> 
> Scan these structures to discover which pass sanity checks to derive
> a list of valid regions:
> 
> 1) They have guid known to resctrl.
> 2) They have a valid package ID.
> 3) The enumerated size of the MMIO region matches the expected
>    value from the XML description file.
> 
> Mark regions that fail any of these checks as unusable.

Above needs an update to reflect new design that will even mark
regions that have known guid as unusable. So far the changelogs and
comments do not reflect the new design and will make this implementation
harder to understand for folks not familiar with its evolution.

Reinette
