Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7E939E18E
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 04:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789013286; cv=fail; b=L6yX33A+Eqawjgb/XpRqB5S1ihr3PcS8odS8WoadlwAmlwn8apyigGMTQyucr2gmU8sbPem7lwn0VnqwfNxNQ+FDeV1jazYzwv3kxK0m1CFWoAbcHbIHv7BOnZXyB/6xAXjg6iCULvUrHUbGjFYl0kgMPnP2SDa7PuI0f+MZnO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789013286; c=relaxed/simple;
	bh=+7PwF/MgiObQO8Kb8sPOWLP8eaqtQNnK09W6ivZ/gQw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Uz2hA6PgvX06TgIXhKQTOWK3GW2DPuydo2NgzTeUbLnx7qkmzrCY13PvRdbjQzSjrD29raW4SniMM7hWZuP1+k0prc8lMLhJHMWZ/xEd8Gdz7calk8R9/jSAjVwZitQ6AGFPUMQKirKy5pQk6HCP5kWMQylsMfknn4IN7XE7izk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=niY0b1Gs; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="niY0b1Gs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789013284; x=1820549284;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+7PwF/MgiObQO8Kb8sPOWLP8eaqtQNnK09W6ivZ/gQw=;
  b=niY0b1GsM83eGVS3AmajCZsrRbgC46URZJEnsolDMAGtBhEDqWK2/RcU
   Rb50sanVC+u+qk3+tbzy3jkjrU0LQFcwCYddz1BvQIgbOuzkkAHEWZa5l
   /j88XdzR+zJor2q4B8IrIzo6HwGdaWrTaz+53ZXSPKnkhlKyCjJk7NYtH
   elQMppPQoyNn6lURXeEl4momHuPbrlsm6/06GYB8CJabU8h7I2bc2vs+o
   86eEYjB74x9W2GSJpFa/Eq3DqOiGvQ7OkXs8Dts/+4WiXY+V1LhQVZkCO
   mac3rzh31rO/I+P0CNRKSFFDjchGzd++l8mtO9YUqvX1kfrKfdSNG+G3a
   w==;
X-CSE-ConnectionGUID: gyny+xekSvSPZuQIQn7dHw==
X-CSE-MsgGUID: L82th2k2Re+sK6yqxl2GMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="89665720"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="89665720"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:08:04 -0700
X-CSE-ConnectionGUID: Xu5CbAVGS/SZjX0/Q50hCg==
X-CSE-MsgGUID: Ho86zrjlSfGGKGg6DRr1EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="275280528"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:08:03 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:08:02 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 21:08:02 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.70) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:08:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P2e0GS4yTxLWUbkCS60/wAZiX/IvU0VJrfmX8csHqx4CGR9nMEdBDMjGb5+bCyDf8Q9PR1GNXm5bWC+vtaQ3ZvURAWhEpZKYJSigFMJ+23IoEhkY6sqEXwKRFlHG8G9dKTPucr5CfCqQyzNU+azugMtFNHYgTXnpHs4ypNPog1RxQ7g/D4qxpymRiCkrkmvBh0+TMk2HEJTENocbbortgQ/Oq8JmLmepkqN6mAaPw5BXd9qqykskx7ogdsO2RftMZXd+OsTnqYFxZPCZ7eqWHMTzZJy4WBVTHsKuS8k32apPz4mzD06A6K/RvEkvmwXXdL3UuZYcD5ahixDkFr94sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+OU+H/FTrddyLZCVngGQaKVEvPiPTwWaUKy0nfnyH8=;
 b=ceT8pHTlgVQ2C9cZBShdfoAKgMEgCBmyWsfq6l7NRv8lWnIWBPW1GVBuqIByXUJkFqJOoOjo0CaYlZsGpFEpX4hTiW3SGGizy7go/kZGCchDNMRqeqRIrIXa45Nn0jIK4NOodSPrFuJuCmpfGM+3avUBml1k6TTyLxegYI2DFnRptV+Qtk3KwXuArqfGKr9z3s8tC00UeM2M/kM2tN0lMNEPRSlbrP93TcQjpTh6yoMQ6G8uYbhy/ZUBepmU1tIvSSJsDlQcVtapndqVc0isxBg/HODhazOLu/JTCVtbvkCxs52zfqZyf5rfQcWSbaik2Ipvdu1lgZg8BZKZBi1uKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DSWPR11MB9583.namprd11.prod.outlook.com (2603:10b6:8:36e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 04:08:00 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 04:08:00 +0000
Message-ID: <e8bb8f0a-9f81-417a-9c4a-63a2f8b1de54@intel.com>
Date: Wed, 9 Sep 2026 21:07:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 18/23] fs/resctrl: Call arch code for every mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-19-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260831174421.13921-19-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0234.namprd03.prod.outlook.com
 (2603:10b6:303:b9::29) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DSWPR11MB9583:EE_
X-MS-Office365-Filtering-Correlation-Id: e5db65a9-0049-4de2-7b8b-08df0ef11a4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|4143699003|10067099003|22082099003|11063799006|56012099006|18002099003|921020;
X-Microsoft-Antispam-Message-Info: vVYsAuYVCZgH3sIxIkQE6I7m9Dr+0o1GDXcYFfVl4fVe9vyzsAJL3wxprlXxDe+0qf8LxrYCxiZthZuaUno+G9GnKMap6CTK0S/484OFhw/84nSe94vqZJGppDmthCGKtSWzAuxnNTUWbFG6Fugp3fX53rOraB1DfQwxnE3xKGSyyx6Z8+4aMlyUlwuNm/+Cvum+ZLJ8X1shfWEVCl/KwpAmrEMVxmqtFV6JDbHgFfHuLcZeoY+SXZNPd+v4IBE0K4xbcLL6Ahj3Oz0opHMb3NUpYaboEzNl4p6VNsKAw2CoMD1K4X2wkIhRE0T0GV7+i+GWoBLU0DuRJUn9gnjr26WdDXs67w/UFh7VNr3w7/Vh+JSbFJXVlxJBMM2kFoUueWE6sBWzxk7kIw9Z7VhaPT1LcTTfbCnAdyzrauCeOkeXMQ4bW8hNSct/QRdMd7yLn8EKvP7tAaBOZ4mhzPVAQB20YYZpCKvvy8WCjmFKOQIFrT8R1Hbb7BWf3TPz0rq51gY+oNAD3Sj02nOE4trBlgDZMsZnNeg9fT4HG0xvv38YZuW8agUs4pDkqDI8TGQ33MERRX5l/cyqTdTKuARFl4ImJ0UY2UM4rxID+JIxjIgkJUxI6/i+S9prQTxAMyFDiM6uLbhT6Lx8GcxZdeCF/pqtqlG5sKx685wFjGT6DI4cZ1ywnl71nw2CuWobiDLW7aHGcYUPF0WiVYcXDQtilQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(4143699003)(10067099003)(22082099003)(11063799006)(56012099006)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?em1JMzcyeFI0djREby9VN1UwWExlOFRDS2VRQllRc3NPb3U0TXdXZXg1SUJq?=
 =?utf-8?B?RHJJVnBGbGZkUHMxRWd6SWNnN2drRTJlWFZDd1NIR25VUTRzaklYYVZncmRF?=
 =?utf-8?B?d1hCZFlneFpScWpWWkNHdU92Q0pUbS9uMHdJZ3RldkcwTkozWHhiYm5xc3lF?=
 =?utf-8?B?M1hERUc2WU9UODhiaitXL2I0WnhuS2FtNFIyZ05ZQWI1blNtREFQNGxIU2dT?=
 =?utf-8?B?YlliTktWWjgzb2tDdWp1UW52NlZuNFVORVJORS9JalY0aHdDSHU5Q0xXRkpq?=
 =?utf-8?B?YktMQkJNU2d0UHoxODVDdno1Y3Vqb0R5N3N5S0UrQWhVOGVPWE9Ma2pzbThs?=
 =?utf-8?B?OUFqQnVrRVd0OWlsaEI5MzQ2aDdmWGhGTkhzU09SbnRiQWtUbU53TlZpYnFz?=
 =?utf-8?B?UlVTaEg3VFZXSjRnMjI1Rzc4cUFnd1hFRHRSYjlsUHdBNGlmV0Q3Y1ZHRnp4?=
 =?utf-8?B?Z0dzTStuSGxqbDZNZmhyZHlOYUxCZjZJQmdFeUZLOG5ubENua1l1Ni9PeTIy?=
 =?utf-8?B?NTNneFBRektCSGprbkVoaHNudkdTZXo1QTZvWGIxU0gxYnM2eHdKT0NiYm9k?=
 =?utf-8?B?U0pkMVExV3FFWlVvcE9RSUl2eHpPVEN5SXpoRnhJN3A2d2hFaEJ3aGdvTmpo?=
 =?utf-8?B?V2VTbEc2WkYwWmxIc1l1TXp4b2E3UUVIVytjbzRWMkN1RXJJdk1VWmNBWDcx?=
 =?utf-8?B?MnZsbmJSb2pyRG1BYVdSNEVFeHhMZHZMbE5HUE81eVlWZFBEUURab3dMSkEz?=
 =?utf-8?B?ZzQzSXhxVjFNQ0VXbWNMbkZxb1MwVTNGc1NvaDBKVG1IWTF2dTRRQm9qcERK?=
 =?utf-8?B?QnMvekJxcTBpemR2Tnh2YzNjSmtsZlRJVWU2VEhvLzJPQ2dob2IxVHI0N1hp?=
 =?utf-8?B?c0xvYTJ1b0ZoKzc2dU9nVGFMTDYzU0d4NUF1MEc4VGhkYTJzNXBmUmRUOSs1?=
 =?utf-8?B?Zk1vakRpbUhMc1V6blRaTk00a05uK1dwZXh0UDNTdFRINnVoN1puTFVBMFhY?=
 =?utf-8?B?VllqZ1psd0RqaGJQSGZjZ3FvRGtGM1I4QXNQMCtpbGRiNHV2K0FkMkxKN3Bw?=
 =?utf-8?B?QWp5VWVSQlBBQjlFb0NTdGQ0c3NxMjVHZm5zWDZwb2NHRzV4WkRuRjBHZGNI?=
 =?utf-8?B?Z2R5OHVmQ2FwS1hkNUQvaGlmRm1IWWQ0NlVKM1Y5bVFhR1RkY28xTk1oZ0w1?=
 =?utf-8?B?SUFDMEtzbFpzbHB2UjR2R3ZnUmV4c2YxdkNnZGVNT1pwemFlSE5ieC85NnNH?=
 =?utf-8?B?dG1vWjQvVXUrazJCSlgrNjRXc2lvRFNIaHRTYjVpdzB5YzMyb2k4YS9iQVB2?=
 =?utf-8?B?VVRzZFVPOUlTdDR0VUZxaXluK0lkMmFnZTYrQ0N5MHJkcXA1dFhmMzQ1RWox?=
 =?utf-8?B?cGxiNHUzeUFHRytwaWgrQ2NESWIySkh2YTcyaWlsSWx0bmpYcG9EWStKQmh1?=
 =?utf-8?B?Z203VE41RHZtSVN5UUU3d01IZC85REFMajRCd3BTMWFXbU9zNlZ1eWN3RGFu?=
 =?utf-8?B?cE9RNGxVM1FrVysxelFKbXdhVmxpajU3RUhGRjhodGIxQ2VkOW9vSHRYMTFN?=
 =?utf-8?B?NVkydEo5anE2S1h0dU9PbDRQQk1GeVQyc3o3T2tRbVJrQ1Z4R2E0TlFsM3kr?=
 =?utf-8?B?YTNNOG9CWHJkbWhnSFhtQTc1N24yOGFtTkJtMHh5MXpPV1RzQTMvTmZ3RmVq?=
 =?utf-8?B?MW4veFI0dDMvWk9IN3VsWFFhZ0l1bDA1Q2s0YVVhajhUTDNxdmFQbFhDa2Nh?=
 =?utf-8?B?R2JFL1BPTWQ2L0ZueksrZjB1M1BwVXFEZVIra0c5TXhzY0d6QVVwM1dYM0No?=
 =?utf-8?B?akpBWUZLbGJqVDNYbHR1QW1uczhvUGh5TGRlUVlzYVJLMWFXQlAzeUQxUGNi?=
 =?utf-8?B?eGZJMU1GT2xVaFFWakF1bktPcmxFS2RRZDcyMHlOK3dJeWtrQ3hHR3VDVTN5?=
 =?utf-8?B?RDQxVFZ5d24rbWNVS29uUFh0Tm5yU0FHNkNrVmlFbmtnSUlWblMycWJ2akx2?=
 =?utf-8?B?cTFZRnJXT1FCaWo2eTJRcG1ScUVzQWdlMlI5YkViVXUxY1YzN0NSRVNRSTgw?=
 =?utf-8?B?aW5QejFDMHljYzk0aDd2Sm0rdk1rRC9nQUswNzVDN3Q3eGpvWkRadXhUS1No?=
 =?utf-8?B?cS95YWVrK2l5eDJraE1rZUc0TVowWGFOQTFsbTFZNEFySy96dUdheUo3VkNq?=
 =?utf-8?B?aUJnb1F5bDVCUzN1b0JZMm1jNFd5TnIxR3BDQU5RdVFFUm15K0hCR1VqUVBK?=
 =?utf-8?B?VWdVR3pVZTU2aVRYcFhSc090bUZIY2pMTzlhbWt6WS80ZjlzR05ieE1KaW1U?=
 =?utf-8?B?QkxGUjlBdXFVRUxjaHdNMS9Vc3lPOUFKKzljMTdYT1lZMkJxWko1Y1lVM1dW?=
 =?utf-8?Q?QPE10SCfznJPfRMw=3D?=
X-Exchange-RoutingPolicyChecked: Dt+Dq6/t1i2SYY9mjwQj0DUg5uiiF499U4j6RLvj0WK89Tqv1nGTQRHMV+jRV2duEo/8QJEHC7m0R+WLc40ADGNutNs0zTR4HkXsCr5uqsApScKos/zUTo808fd5z/yWsjamsDSl4sBdilBlpGp0c/yBdtQ6ug4G0KkoueYVeq3KKrencaZw3D22zqY2C1z7Pvj5OGZPYGPRdgr2L2qYX5kMU4CFyOqNDXF/encbynGw3Xpi5IDUscZL7wneI2JfrY+1W9qPSCsZkIqcUhxgYdB4bD/FJZEylX3NMdGf5oOKTgnBTI7ifSMb7F37BS8jL59Ep5ycRgD7W8Xf0lQ+Sg==
X-MS-Exchange-CrossTenant-Network-Message-Id: e5db65a9-0049-4de2-7b8b-08df0ef11a4d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 04:08:00.2268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EjD3iYQEkjIYqDUdrs9T5Ybdmu271RBaBlf2rvt+QvgBbJMqfPcHqnx+rY8v/iHwhfmDYKy4wZNcC2Z1+TUs8cEHP6c704m1kUyijeByWYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR11MB9583
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> Linux file system code provides no serialization of mount(2) system
> calls. Without such serialization calling resctrl_arch_pre_mount() on
> every mount before acquiring rdtgroup_mutex would open up many complex
> races between mount and unmount operations.
> 
> Add resctrl_mount_lock to provide serialization and protect resctrl_mounted.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---



> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 3ac518ed2368..7f09d76dbf8c 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -30,6 +30,9 @@
>  
>  #include "internal.h"
>  
> +/* Mutex protecting resctrl_mounted and mount/unmount operations */

Could you please expand this to highlight that changes to resctrl_mounted should
be made with resctrl_mount_lock *and* rdtgroup_mutex held.

> +static DEFINE_MUTEX(resctrl_mount_lock);
> +
>  /* Mutex to protect rdtgroup access. */
>  DEFINE_MUTEX(rdtgroup_mutex);
>  
> @@ -3149,6 +3152,7 @@ static void resctrl_unmount(void)
>  {
>  	struct rdt_resource *r;
>  
> +	mutex_lock(&resctrl_mount_lock);
>  	cpus_read_lock();
>  	mutex_lock(&rdtgroup_mutex);
>  
> @@ -3166,6 +3170,8 @@ static void resctrl_unmount(void)
>  	resctrl_mounted = false;
>  	mutex_unlock(&rdtgroup_mutex);
>  	cpus_read_unlock();
> +	resctrl_arch_unmount();
> +	mutex_unlock(&resctrl_mount_lock);
>  }
>  
>  static int rdt_get_tree(struct fs_context *fc)
> @@ -3177,24 +3183,27 @@ static int rdt_get_tree(struct fs_context *fc)
>  	struct rdt_resource *r;
>  	int ret;
>  
> -	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);

Please note that after this series the comment above resctrl_arch_pre_mount()
in resctrl.h still reads:
	"Architecture hook called at beginning of first file system mount attempt"

The sashiko reported issues look real to me.

Reinette


