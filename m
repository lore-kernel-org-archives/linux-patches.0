Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A2E34BA42
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 17:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673254; cv=fail; b=gEyVD1zpBoMGADT29OMrbM6bkSE28TYXDFcnqNG1qfcpkZwiISBPedO6gd5hvroxFIdTceXV5LsJ5466DxlQXYT0fwZRvwAx+JuPeeEi/FTYHWjv7/BPud1Lo6p8veMCaXR5vrX5tcmDYWxXuA6bjXRMZyt+r4froDi9CHhAYxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673254; c=relaxed/simple;
	bh=sMCs/Sxh6udtjU0tMDN5F2ald78v62V4ifMTYnGukCM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qgZTDOZiC1+0Dn/xNlhdlNY3wuj0j/eUlQyb5PNnCDyxrg3LwYVNv3RdzuhV/xI3DVvMBQnWcF+xPuUsFzAp2iRcvLte3ub25YGTKktoMJdtL0J9aa6rn7GVzGtPJ5i8DWLChf5KhGKVzBDQTGjBGAmn0o3UGvq6WiXvmMnjvDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NkubCexV; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NkubCexV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761673253; x=1793209253;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sMCs/Sxh6udtjU0tMDN5F2ald78v62V4ifMTYnGukCM=;
  b=NkubCexVcuT5g21Ac6LJysLyTNasM1ft7Ey5aTn6NCGNIVsBghKg7nb/
   wFswXZhE9j6uMMbl1LlGh39uOfg3GNcnffQIhIJwiw6rDFN57K4701+iN
   zKspQPGWGCBnOgQq/4viXXqCRscQ7RIrtdX2Bf+eZJyrP9hlx2rri3HMu
   RddppJ4wdABhX/AYmzx0USXPjf02gt5XSE20PM+2HfhY8IPEuShLj4Gtb
   82a1UjQaQKldtxqo4xqemBpiWW/nrjjhzbxwYHeBsjZUaOG6e0TXccjd4
   0JGEcyrUkvFUphQtoF+HdAIJ7U27PQJq/xQ1uuj1c/1ixk24zGC4CAP7V
   Q==;
X-CSE-ConnectionGUID: tpukXuB+RCyUzXHp4OKdkg==
X-CSE-MsgGUID: h0Mj34d8ShOfNlM43FUGFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="51356921"
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="51356921"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 10:40:52 -0700
X-CSE-ConnectionGUID: qEcpN3VKRJOSHU7TP9cViw==
X-CSE-MsgGUID: re9YlkawRjq6HdCmTMRk5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="222636604"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 10:40:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 10:40:51 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 28 Oct 2025 10:40:51 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.34) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 10:40:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ntiB5kL2wHutlNzx8QL1KjKX1QQmIeLI6QFv2Rg7O+YjW4RccLnU+WxOAEUMqv2ADhEgIOu1Do8TNYcVe6f6xFfnceiOCF9PCaGJKHfi3KviIi6jz74tcTwVK2Lteoo2eknKmAQxLOp1763rQLNJlRtDJ+w7RZ5z0PVxyojh6lOuUoxD/inH5ySG39wSfAuhS6pnuIO+GcxXwcssbnMYxr99TyO9RARNQD3WSvL0Egp+xLAGDV29BkZM2CPJFV692lwQS+nzhKY9J51v2EWtnV/9Of3RKrYxwIh0L3WlqmrcjFXx/DEnAmAIXz+A44aIIYozWm5z4H/usqm7s5jQvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xm96D7+PyKvWzOVYPLvTTFuCLWM6c4dJEPf1/AR4gvY=;
 b=QPCL4E/oGrwZ2bVZxqmEm+mzdtTCbA8duMJtrgFA1AcMbeXgom+njSuKCkwE3w0VKt6fE8bsSXdx8qukWvVq1iDNX/YBttEyv8KeVWElUENlXc1CxO3FYkaDwh3xXYRX3VUapLE5dvGmQUs6YURYOfCRQyCEAmnRvOgboPIB7M+HSb16GpMbKfA7pUl/dDfQ7zpfOkMnsoZ3Va2AEftOaYLMYgcnXpi6yxnCFiyJlq7C+O9FrytFiPpIoqQKmmhozTOAJCzJl8WATvlgNZUBetKDmV4kiqfmXUbGSExY/3SzFAd5B1XE85/GaQ2w4v7e96RcQwwXuExKqiH35Hwz0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA3PR11MB9111.namprd11.prod.outlook.com (2603:10b6:208:57d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Tue, 28 Oct
 2025 17:40:47 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Tue, 28 Oct 2025
 17:40:46 +0000
Message-ID: <820cd2b6-b71b-435b-bc67-c35318f869e2@intel.com>
Date: Tue, 28 Oct 2025 10:40:44 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 20/31] fs/resctrl: Refactor mkdir_mondata_subdir()
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-21-tony.luck@intel.com>
 <4bcb8320-687f-4c43-b4b7-150d503b9890@intel.com>
 <aP_5eW_GHwXebeyq@agluck-desk3>
 <b4921b96-3f86-45d8-a353-471c8f20e2b1@intel.com>
 <aQD560ppyTDob_Wd@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aQD560ppyTDob_Wd@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0112.namprd04.prod.outlook.com
 (2603:10b6:303:83::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA3PR11MB9111:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d10b835-1f5f-4304-c458-08de16492083
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TThmRHNOSTJYWlpsWUM4cUdPRDYyb3VGWUtSNjR0cnQ4SEhRSHdmTmNXb0Ro?=
 =?utf-8?B?UXdmS3JWZ21EWmJJUUQ5eGw4bkNjbVVzcDB5aWtCYzk1ajFYS3ZFUnVKbWNE?=
 =?utf-8?B?aFdDZzJaNjlYWFo0dlN4bWZyM1htZk9pbXlzbHAxeWpsTjd1MjJwNFc3a2RQ?=
 =?utf-8?B?ZG1sa1J4VnNzN1hQMG1ueGZMbS9vbkpDdjBqV0U1aFhJTTVQWU5BVXlsWDAv?=
 =?utf-8?B?NHJ0WDdEeDlrME5GU1NsQkR5Ykxvb2s3N1dmOEtpaG5YNU4veFUyNXlvdHho?=
 =?utf-8?B?ek01ZzZKSjE3U3lZdmZxSzFVbWo1czFVLytPWE5OYVBzeUtHM0NGVmY2ZVlt?=
 =?utf-8?B?VVlYZVVqN252TC9GZWJhRmFOMThaRUozS2RUSXZHQTZiai9sZDlaWHo4UjZx?=
 =?utf-8?B?SW91VFNCMmVHUXpzKy90S1BmM3hMS3UvQ2NDWFNmcUgxem1rTG8vbDcvUjR4?=
 =?utf-8?B?WUE5T2tvZ3dxUkZxSndmNk5iRGplYnpuQlhFdXBGaWhNZytIV1FRZDNuQlo1?=
 =?utf-8?B?aWxjaTVUZjZPUDV5ODhzeU9Yc2p2VWs2cVYyTWJNRyttZ2c0SERZZ3dPUFla?=
 =?utf-8?B?SEhwcC9WRkNPMDQ2dXRhL29ua3hkbjFxeHZBaDE3dlAxSHN3cDNCdGJEZUgw?=
 =?utf-8?B?bEtGY25uS08rRjg2U1duM2o4MjRmbmdBcU02SHZWTzRPV250MGw1ZWJ5aVdz?=
 =?utf-8?B?OHV3YUplUVNPVCtWNGlxdE5DMk5abEgweS9VdlJFbGlkK1lsSjFRenVucGp0?=
 =?utf-8?B?TnhqZGZFOGQyV0VkOE1LUXRMR1M0bDRjSGtiYWZHT1E4YUJwbzN0ZjlFMlpB?=
 =?utf-8?B?TEFBMXZGSlpnUldpY25ORkF5bnhmT2RCTWFIRXJZS0lLalBLenBTNUtyb3VF?=
 =?utf-8?B?N0hTTktFRHozN0piSGd1ZXdNUVh5cVl2UVp4NDZKVVFmNS82RUNDQzl0TjUx?=
 =?utf-8?B?VGtmWExwY1JWNUt1a21jRUZKQ21id2gxdTIzTll2UTFiblRiTGlCekZzRUFl?=
 =?utf-8?B?ckI1RjZ2eDNTbHV5cGdTMmsyQW5qcFA0bFR5YjgwSmRKYUlrdFdrd3ZleUsz?=
 =?utf-8?B?alBGVkFVT0ptRm95QUQ2WTB5ZHJWM09YektvZUVWeFpTZzNFeXFrTEhXL3dk?=
 =?utf-8?B?a3REcVA5aTNqSFExbEZrek9WbmFub2UxMml1aHIyUm9GcU5icWJTRmVhVGk4?=
 =?utf-8?B?UTNKTnpxUzIyM2VpclV2djNCbzJBbWZpb0hNMXRobUdTdGplSmhSWUxLbzFU?=
 =?utf-8?B?YzB1cHB5UnBWZ0dleUxzQlFCZkZJY24wMUowNStVZU9VMFMvU3VXV1ovU3h0?=
 =?utf-8?B?c015STFLWTM5Z1JiZXZvN2ZKdldGaUFpekZKbGk3Ky9ndklxRENsV1VOK012?=
 =?utf-8?B?MXc1RWhwNktTZUdPb05WZmVJMnJ0Q201TndoWTFKSnFEbE43MW5ISFg2QmZJ?=
 =?utf-8?B?V3RKbDMxdDhHdkdRZEhUNGZrQkprN1Y0U25CSk5uL0JzSDBBbDdFTmtINDht?=
 =?utf-8?B?Q1NzbWZMT2s0elFqb3gyaURtWk9taVhnZHdFWFFxeHAvSzNjdDM1Sk1jQTFh?=
 =?utf-8?B?ZVlNWVJHQS9CWjZRMm9jVHZseElPdU51UzNzVTZoYU0xT1liZlVlejc0a2pw?=
 =?utf-8?B?Y0J0bGtJZ3VLeUFYaDd1UllnWDlLb1pzVGpiZS9HMThSNXJNWWRISjk3Z0dV?=
 =?utf-8?B?UVN6YXpyVGhpV1NMUUFZbTZXWEJCZjYrKzdWRFhUdXhzMEZvY3I1MHZGelR1?=
 =?utf-8?B?b1NNRUxUZmM1Z0xFYk15QTBCWjhXRXJaQUlKZFJRVWV5ZDdHRkh1bGFZejgv?=
 =?utf-8?B?U2N3dDJwbFBkMGsvRFl3cG5ZL2o3MUtzOTYvVTh2MEpPYkttWjROL2EyNzBj?=
 =?utf-8?B?KzBhVHhDNDI0RGF6Sk5vaGhzTEkwNDNEdFdYenBrOG9hdWpKS2ZGLzFid0Vz?=
 =?utf-8?Q?/xfw7l0r4FRMiKg4cI5/ztgnz/JWlXk5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVE3ZlZzSzhvdlhES1BzVXFkY3NDYnlRVDNmNEtLanpUZ29zU21LaVVNVkpZ?=
 =?utf-8?B?VzBJdk1QMHlJNDBjeE4yTHJSamY3eGhTcEdseXpWWlc4SDYrcEJPb29SNGRY?=
 =?utf-8?B?b0VrZUxyZk8yL094K0FTS2ZJdjVtRHRtTXl2QU9hZFU5T0ZxcEdGakZKMGxB?=
 =?utf-8?B?VFp3WUNzemYvMjJ1a1ZKa0NEbjQzRnNIWXNiaStOYWV6bTdqcjR3a3pQSTFo?=
 =?utf-8?B?OWkwYXpETVVtSUNRak5CWkV2NEdEcEMrcDNMSnVJamRvOU9UbmllcXg5YjdU?=
 =?utf-8?B?WEFGZm1ON0lTd1FaZi95TEw3Z3o2bHpCbXRlVWNMVHFrTGgrOWJUZGxFQ241?=
 =?utf-8?B?T2dJOVdzTU52dEFtYmVMTEVwN1pvK3lCSVY3OVNDY3dwWHBVNjlKajVYc2M3?=
 =?utf-8?B?L0doVDQrWFlpcTBSVFRxbDFWSTZQam8vWG1Yd082YmxDQVVwNTNSUUFldWFp?=
 =?utf-8?B?MGVocnYvZ1k4amw5ek55Z25mN0ZVSWRPK0crcFBramtRSGdyZ1UraXVkb2Jz?=
 =?utf-8?B?RWk1UVNCZEJFeUFUZEtEaFdmOGF5OFhQVTh6dHRnUGNOTGx5dkU1U1lhWG1L?=
 =?utf-8?B?YWsyc2k0eU94RDJYMGxrS1lUQUhoT2NsRTBnbjRtQ01jR1lMNUw3K0E4ZFQx?=
 =?utf-8?B?UUJKaUo5LzErU05QU1ptY1RXSytvbUJsd05yUm15SWM1MkJHZGZpUU1aREFI?=
 =?utf-8?B?eXJ3aGVSb1l5VU1qUVFrNGlmYWlzNmNFMmxkYWNPS0g3a2dlM2NKR0F4YWRa?=
 =?utf-8?B?THBMWkY2S0VsKzZxSm84dTZVVDk3TUxZWmsvWjE1SXd2elgrSWEzY3F5Rjgz?=
 =?utf-8?B?amxaYko5d3ZWVi9UWDlMeVZBeGRZcWlIQWxPUndSNXRZeFRydnVzbFFQa3Iv?=
 =?utf-8?B?eDhGZWlldmZJeEpXLzNnOUJCSGFIcVFvOStrKzNhUmNaRUtHTTA4U1dHQ1cr?=
 =?utf-8?B?YS9KdnRoQWFHbkprNU9CNTk5VjJBeUMxaEhiK2lpcmpMUVZjYU9ZR0xzN2dL?=
 =?utf-8?B?cEVxeHlqK1VraGtMVUFuMUZqVG5NNndtT3k3U3pPQmF0UERNMXZIV0M5eDZh?=
 =?utf-8?B?SkM0SjY1aE55cG56MFlTNTRXbzdZVXJhT25wbkN4WEV3YWNJejZjYkVaVjV0?=
 =?utf-8?B?RVZsT2w5MnNBSmhHdU5iWkZyQVh0dnpkTXRBQ1BDWm84V3ZJUzluWEh1QUZw?=
 =?utf-8?B?WnQ1RjVkSVpSRjgrSXZwdDZDOVJVL1BHcG1SOWZ6b1JqaUwyaStGOFhvRE9G?=
 =?utf-8?B?cFVmd241dmpFN2dhZnhQdTVvbmtleWRFQlMya1p3ZkpWcVVFOUYxS0g5Y05B?=
 =?utf-8?B?V2krenc2RG5aTCtaYkZqZnQ0SGZDdzZuY2FkaXZYT01CV0hqQWRodGxOVFNn?=
 =?utf-8?B?ckJ3Nm1KdVpRUVl5RGFUM0NXUzA1QzZEMHNTVmFnbFBnODJaQ2FkajVBNEVp?=
 =?utf-8?B?S3IyV1dJRldrRSs1T3BSZC9Eb3FUSStDK0VEQUhBQ0FNMHMvaG1GRXVrS1Bk?=
 =?utf-8?B?QjNTNGs1YnpQRDRDZk5VSTFsa25mZlpGQjZGZlVOeU1xY3VKU1d2aXJBcW9i?=
 =?utf-8?B?bG0zNjBOY21LZVRTTzFJcFNYU0dQa1Voa1lraWpVUHdFb3hIZ1JKSnlkWGRW?=
 =?utf-8?B?MXBLdWJiQ3owdlNLMXc0TjM2dmt3ZGJDcEFZemlHSks1RnR5aDdQbTZmR0Va?=
 =?utf-8?B?RHNtZWlZZ1J5WWNrLzJkSnc4Q0dJdkVhRzV3RVFqcFhOOEVteGhIb2x0UmE2?=
 =?utf-8?B?MWRMSGh1ZnRPWDIrWXUvMnN6MThBSlJUeGY2dGp1YzF5RGc1QXc3cUVON1M0?=
 =?utf-8?B?eVFUNTZoYjhBN0tMNEJQRlR3M2xVRTZUeHRSNm1nZHVZM3JoWXI0cU5xcm9M?=
 =?utf-8?B?RndWME4rNHFFU1V6L1JWMnV1SitibklDbjU1dGsvYm51VXpLOEczTXozaHRZ?=
 =?utf-8?B?SWJBSmg4VTZqRU5IbThzSVFJaGZCWW5pUUIxMnl2SFJnSURUc3RiZFY0Nkdl?=
 =?utf-8?B?YzA2MFo3ZmdsZXdYb2xpcDgzRDhvV0xzRU1hdWgyYyt0VzJEeU9RRld6Z2R1?=
 =?utf-8?B?b21aQit3WTYyVDVFbXVMd0hoRjNLalM5d0MrMW93bys1NE9iL0o3SG5EV2p2?=
 =?utf-8?B?SUtETi9lcHlzY0prS0hIcDE4amlIeXhNc1IxWFExVWVXMnhxVnB3NWhKNUJZ?=
 =?utf-8?B?bFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d10b835-1f5f-4304-c458-08de16492083
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 17:40:46.8985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5bwTG0uvfYSJjYe/E7kWSE6p5SPEnZnMYbiDlxCzFmxoV8RxJUmaCHE5Iz0fY5X8rR8Nm3/k9cngZXFOHIpSwvIO0daj/q+1R0VTHzdFasw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9111
X-OriginatorOrg: intel.com

Hi Tony,

On 10/28/25 10:14 AM, Luck, Tony wrote:
> On Tue, Oct 28, 2025 at 09:00:46AM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 10/27/25 4:00 PM, Luck, Tony wrote:
>>> On Thu, Oct 23, 2025 at 10:45:06AM -0700, Reinette Chatre wrote:
>>>>> +	sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
>>>>> +	ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
>>>>
>>>> Noting here that kn was created earlier with mode of parent_kn->mode. It thus looks to me like
>>>> above can also be written as:
>>>> 	ckn = kernfs_create_dir(kn, name, kn->mode, prgrp);
>>>>
>>>> The reason I mention this is that this patch adds a third copy of a very similar code snippet
>>>> (kernfs_create_dir(), rdtgroup_kn_set_ugid(), mon_add_all_files()) that looks like a good
>>>> candidate for a helper?
>>>
>>> I looked at this. But the helper needs a lot of arguments to cover these
>>> three cases. Something like:
>>>
>>> static struct kernfs_node *make_and_fill_mondir(struct kernfs_node *parent_kn,
>>> 						char *name, umode_t mode,
>>
>> I aimed to preempt a response like this in the text you quoted that notes that
>> a "mode" argument does not seem necessary. Are you hinting that mode is indeed
>> required? If not, without "mode" there are six arguments which is just one more
>> than mon_add_all_files() that will be called by it.
>> What is the threshold for there being too many arguments? This series does not seem
>> to have trouble pushing an arch API call resctrl_arch_rmid_read() to eight arguments
>> while there is a concern with the number of arguments of this static call that has
>> fewer?
> 
> Ok. you have me convinced. Since this helper will be the only caller
> of mon_add_all_files(), would it be good to just add the extra args
> needed to this function and have it create the directory and add the
> files? It would need a new name to describe the added functions it
> performs. Maybe mon_add_domain_dir()? But better suggestions welcomed.

Modifying mon_add_all_files() sounds good. I assume the node activation (kernfs_active())
will still be done by the caller which would have this new function return a struct kernfs_node *?
If so, I think it will make code easier to read if name implies that a new kn is created.
Since the caller is already mkdir_mondata_subdir(), what do you think of _mkdir_mondata_subdir()?

Reinette
