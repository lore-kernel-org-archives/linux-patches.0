Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB8B2192F4
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 22:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766009822; cv=fail; b=ewRb+Tr2ZcPREO71LnH4dyDDZ0vtNOKmmUiem9bzGgfdNOreYv/qg1HhpZm/wl5rzzybkW3Itl+Fwhk6aLv5yjPdN9KCi/rVfpHrEKIhdA30i/NreE+1YpFBXlj1L/EDvZJrbA3RKy/K0nMSBS0EAcPUyBFUnNhRRmHi3ZqGVGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766009822; c=relaxed/simple;
	bh=0k+BwnhUCG0Mmsvef/c2wMEKgYOhNXSxKgwKgDNUuYw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g89imwyhG3QbVx5rVVaRTrNfR/V+n7+m2SaQsm878gThr7R97TapVpUmVIq298jFvXQC05YMlJW6Uq/z9wTvqARycdL3v4UagpqX/R9gqCWyBztithkH4j+AkKTgaOoaGMQc9ZItdIsTxj/OLF5CTlnEadFs+Q85CoZXiey6eRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fs90WQWi; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fs90WQWi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766009820; x=1797545820;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0k+BwnhUCG0Mmsvef/c2wMEKgYOhNXSxKgwKgDNUuYw=;
  b=Fs90WQWiYgZBEzuUeosWWIz3eAzTTojZlc1Si6rF1Lqn0Pccs0XCetar
   o5p4LEvxWyl49YyweFFAGImHDBx7yHIKzseGDIw1khKC3g/9RgvYC8vzF
   ArcXOeBO0rbwnoOahIfVhtCamA1ZZEf0GeEa78og7zIKiIU0afoReStFp
   7PtThkT8JSFOh7IcHAGUp0cnrl62910xxR+6LmRKoAaC+wGGsvfiySsZf
   HLzT602sEp8e891fbXuLXeLawzdkXEU6Vw0o2DlYs4CrEagq+B/8fpDZv
   vCwn/mB91wWDuaFk71AnBXJxn1HLxeZby7je+qkeWkX84DjywHJ3nqqi+
   Q==;
X-CSE-ConnectionGUID: /sfaBkipQOayUavgKsNHtQ==
X-CSE-MsgGUID: 0SCpKLNQQZi3jGJqCNYLbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="85380328"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="85380328"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 14:16:59 -0800
X-CSE-ConnectionGUID: E63LuR0STLSVfQuqIeUHQw==
X-CSE-MsgGUID: k+y3GL40SSC/BGTdPqqYjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="202792899"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 14:16:59 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 14:16:58 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 17 Dec 2025 14:16:58 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.3) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 14:16:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iHFYkpUtcPjGfEjIg2Ky833dtmzbK9xqd9PobZWgkjK8bsrik7utFZ0iWC1SJwCTvp4UzGLpIBDm+PBueNdrh+6NFgIg153PbFq/SJsCM4jlYorrYQSNhZatjXYuv5TcjTN8tGWJXJWiFECazTbLejGZmijaO2INUlBtjkmmdDq+p2jrRqqYLO/SA7RcNLS9MgoL1gzg8dOLSYI5F6nGY8pcL8BoEzNudGYtYi5eHmkCMf2eOrMakpSI2eJ0xAbR0BKIMeunU2CDNc5xlHovVaCh7uzKScEWbSxiCIm4xeSf1zGrHD6HhB0DCiig1vbvm862KO/1qmBQRs4nQe4SMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EUK02ziHoXIgcolhgr8b7PekKVvmfF2qD02ZBGsoPUo=;
 b=AM0ga1K44UcmuLnJMBdrpyLDv+HRdCyozLDVqbl4Mp4ItardA1A62bZdt5cUvQx1n5Poz4zU8bHeuyEIkS79s2GSrbgpz8DHwRQDgQch1TUmp1riPXJI29y7U13ojmZh5MhrXcvwGjrdVdrQfGeeMR0vxoBw7KITcu1EhHtXrvuPOOWbvH9OgnEHHVY6TYXkooqJhJwEydTNxw/yGQ+zlnYVEz+4y8J9iLvjwnuoOfSm6uyfz9p/eJ+b+1qntaWvbVFFUyCYSb8yqlDhqb2shV9vP6fhVAxv38dJIMTZHgRInm4Hh3dJgPUCTVXJJpSyiyn3SeOQjEmbrfD+E0lGMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB4854.namprd11.prod.outlook.com (2603:10b6:510:35::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 22:16:56 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 22:16:55 +0000
Message-ID: <b085963b-5bcd-4859-9011-f31840929a1c@intel.com>
Date: Wed, 17 Dec 2025 14:16:52 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 00/32] x86,fs/resctrl telemetry monitoring
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, Borislav Petkov
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20251217172121.12030-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251217172121.12030-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P222CA0007.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB4854:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a27d8b7-6f28-4935-4dd2-08de3db9fd02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L3lud2xCR1VuTzZKZWphRzBlRmlVbUFGNWlSOEJFdFo5Y1BoWVg2a3FyQlZU?=
 =?utf-8?B?ZDZ0YXJiM2NtYndvb2tmMHNSLzFHVk1vUEFydUM0WVVaQlM5M09BaXo4TC9x?=
 =?utf-8?B?YXFRaWxkTkRRSThod29BL3p1UEVNUTM4V0ppMDA1ZGNWT2MwNnp3Y0trTEVi?=
 =?utf-8?B?MFhuOE14eWczRWVRYXRIRElwaXdiZ2VkYzVPYWwxR2hGWUJraEgwc0FNZGxn?=
 =?utf-8?B?UnlLamdYWUlybGtGRVJWSXZEeDcwVFkydTZVWXJzbU90NWhEQ0gwa3JZakN3?=
 =?utf-8?B?VFZjVHprVUI4Y2FRYjl3RlZnU1crSDBzVGcySVVwNzJhYW42Z0ZvdWNKSUNY?=
 =?utf-8?B?SVRCQmQyYUZ6aWxRUkJSSTBQclhsNVNTNm9mYmtUWk9sYUdOUEVLZU5RUDIy?=
 =?utf-8?B?Q2ZMeXk0aUdtQ0xITytlY3oybEZWcyt0Y0pIT1lIRlVCQUdIUEtnT2NjbWhF?=
 =?utf-8?B?QjI5dGhkTUVrMVd4S2kvelIrdFhBdkp4cE80SG42NU03QUNDK2tkMnN2L3Bs?=
 =?utf-8?B?NCt0bUFaMnc1d1NoWWY5NisvVVI5eG95MVVnMW02SVoveitjZkl1NStlZVVM?=
 =?utf-8?B?VlZQUDFjZzRkZmJCdEtpTzNpNERXS0xkQVJMVk5sUmtKMXZGOVduYndwdWRp?=
 =?utf-8?B?bGdXdVAxRHFzaFlTVEViUTNRT0VSbHkzbEZoSjV6ZkFveWZTVkhhVkRuRzhJ?=
 =?utf-8?B?WkIxOUVWZ2NjRllJelE2V1FaN2tHaHlOOWREcHZsaVc4dXplblRQYmxnR0hv?=
 =?utf-8?B?L3dBM0s4NDNRRExGQWtGVGhDTEVvTzNTd3NpWHBvaDUyU0F0ZWNUVTRya0RW?=
 =?utf-8?B?TFVGSG5hTFZsS1RGSWdLSjdkQi9tZngvcHRiM2VnNmpFTmpHd0FmQjBFTkU1?=
 =?utf-8?B?M0hIbVY0emxxWXorczd2R1NhOHNJRnZlWkJSd1pXUy9tSS9sL3B1RlY3aC9Q?=
 =?utf-8?B?MlJjSkJJSlh5R2loWVljOUpZVlZqVHFGeWtFc2xJaWVkS0hZcEVkTU8wTGxp?=
 =?utf-8?B?YmhuMEtkYUlzYjMzZS9ablpuRXdEckpWTThJcFQ4WXMxeUpXdTBCVFFZTTVq?=
 =?utf-8?B?SjBpT09vNVIwN0IwM0k0VmJxMllGeW43dG9FWTV0U1ExajRaRXMwbGtFSDhU?=
 =?utf-8?B?VUdiQVYwY1VjdUdZeEtVcjFLWk1MY3VabXJRajYyc1hIbjBrVlFYZ0ZJYjdN?=
 =?utf-8?B?SlFEbVZqbitqeUFseFI0N1Q4cHg1eVlXS0dCUWZnQjlqNHB5ZzIyaUV2YTh2?=
 =?utf-8?B?RXJGN2JWUDlXZ3BXdkdQMTJ3dWoycm9KcjFibGpiejJQcWlKL2VUMlZ3WG9G?=
 =?utf-8?B?WmFNaytueVl4VlRiSDJXeDJtRjBVSnVsMXU3UzdvSjNlWGFuU0dkU3FKKzBr?=
 =?utf-8?B?T2R3ekVyU1JkTDZSekJ6dTY3djA4ZXFLbFNZMjVXdTdRN2pocDA4OUNROXhu?=
 =?utf-8?B?Rlo2a1FWc3hsOEZWTExuczRXWEh5VU45N0Q0K1Y4WDl3VC90R1dINXNyZVVN?=
 =?utf-8?B?YWtyY0lnZW1tLzNtOEpsNWRUZ2RNTFBXZmdDaThrakdweGFZeC9nbnhEM0Zi?=
 =?utf-8?B?QWErWWlpVGF6QmpSTmloYXpLSnNHb1FHQitzdDBwWTdCdlM2d1k2RGxOOXE0?=
 =?utf-8?B?TzIrbndJaXdzeFpCWUJuTjk5Tm85WTdMVHUrK1hkQUR0NnB2bGpwNit3dWdk?=
 =?utf-8?B?WmVjRG45UElwZGcwVDgzZG1ZU0hMV2F3Uy91NTdOa2p2UVZFRnk2TU84L29Q?=
 =?utf-8?B?VDhGT3RZYjBObXFXN3BsNkRPNWtoQWxYdFprMWMxaUxiQ1FYQlFuSkc3bGhy?=
 =?utf-8?B?MlNNWTE3eDJEWm9uMkZHWUdBc0R5L1pIU3lqVHR6S1FOMmxodnI3Q1o4MmNE?=
 =?utf-8?B?QWZhQjIvdXUwVzNMYTB5L29FUzBVU0VhMkZxSFdpb3dKNXNHREtxTjVNRGVZ?=
 =?utf-8?B?K2ZzT0VvRXhQdFoyOGpDcFNYNE8xNjBRRmkrSnNtZVIxUXJZTzgwaURwNnZj?=
 =?utf-8?B?bGpPUU1vNkZyOWFXT3NnV1NLMUU2SVFFV2VIZlkvZVJTK2dKLytmcnBYYVhM?=
 =?utf-8?Q?whmpv0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFZ6NGpmR1FGclQ3YjNsb3Q2eGE1U1BXaWdDblRFMm9KeUgwNW1HQUY0U1VO?=
 =?utf-8?B?WEVMSEhSTzRjeitWWE1HL09oMVB6Q21PQXZFMHJWRzVVMlppVEhJVUJSdGV5?=
 =?utf-8?B?VmxUVlFuai9DV2F1WVZDVzBPaERZR1YxdE9xNmVQZlhOdFhlUzU1NDZRZ0cr?=
 =?utf-8?B?YmtWVDFkalBMQXdGOUhZaDRpeEhQVmhiMGREWm95VDJVWTN4dnF5M092eU5n?=
 =?utf-8?B?dTVwTVN6V2VZSGFGVmh1MTRyejROREVqRDI2QmROaEM1aXRhUy9xN1V2eWtQ?=
 =?utf-8?B?Z0x5UHBVVFVZOEJLUVVIbFdHNTRjSm1VN28xQmtqa1I5bUxOMGZXR0Z0KytK?=
 =?utf-8?B?TFNZWE9WYi9TMFlsamVseVlJS2pyQ2lJUFN4TVRsVVhsM2hOeEdBSmNOL2Zx?=
 =?utf-8?B?amtOU3Q0enpVeStLZTNBVHlXc3NaVW5LdWVjY1NiVVZ6bitReXhaaWM3NVcr?=
 =?utf-8?B?YVJnNjNzREdhRkxZRDdCN3RJVHY3THk2OEg1Y2o4d0w4SU52TW9ueWJId2wr?=
 =?utf-8?B?dmtORWxZaHg0MlZRcktEaEhSbm5uQ0RRcnJyT2JBK0pJZkJqMFV3SU1ZYWFO?=
 =?utf-8?B?enZrQ25Dc1BvU1JqaktGeStRS3pyRXFxT3Vrd0NEOEsvQ3E1VnRXdDJPb1or?=
 =?utf-8?B?QThySDBBUllrY1crN1RYRHBpUDl6VlB4UHR6Z25VQVd0Q1BuSExmcGMxNVBF?=
 =?utf-8?B?cDZYVWsxNmlISUtKT1pac2ZMSVV6dUdvNjUxNTJadU1sb3RkTGZWN2YvQ3li?=
 =?utf-8?B?djkyMWFTY2lpNjV3YWhhakIweGUzOWNlTGNOVzltNnJhZ1BCMzU2aTFtU3Qy?=
 =?utf-8?B?SElFMWptNk1lT1d1M09DVzRRYjh3U05salJsWUN3V0l5bVQ5eVU3N0lmWFVO?=
 =?utf-8?B?N3pCei8xM1NYQTdId240NC9KMW5TMGlvRVArelQ5cDNSYklxNSt3V3FXTXRw?=
 =?utf-8?B?N0ZPNjNWaU5IZWxOS2F6NVpaem1lMVEyWG1ZUmh1RngxMlZaL0ZDWXk2ZXgy?=
 =?utf-8?B?YzJ0WjNMVXV3TEp0MnJpbWwvWE1ndHhiak8rRXFGeTJQTXRPRHJsOUxKenl0?=
 =?utf-8?B?RGdOcnpLNnlvdklLUlRDSWUyck9tdWM2Q05LNEpzLzNUUUhtWHhacTNzK3du?=
 =?utf-8?B?bWM2RG9sZXVleVZIeDdrWTQxS0lCRndzaHBXdjJybEEwbDdxNVNMWHRWbmZw?=
 =?utf-8?B?cEIwZVJQT2dyeWZQa0xCSk9lNUYyZE5yMHhNb1FkZTdYa3gvRTVXTVp0OGhn?=
 =?utf-8?B?clE3RElBZGxva3RETC9OZElBVk96UjFna1FYUml3N3ZuNGNLcVM4NXBNV0FO?=
 =?utf-8?B?d1oyc2wzZVp6cUFmdFRtY1BCL3VKVzlxSUxHdER5WjFnaUtIeElHcmZmek55?=
 =?utf-8?B?cnIrSmxVVzFUNTFEUWNvSjF3MEc1cG9EWVBGbzlpZ2NKNWFiOWRpYWJGQ2lQ?=
 =?utf-8?B?clNMT1grdGR0aUd6S2dsMXVjTk4ycXZKQkg3SVZQTk5jQkVRK0d6SVhYS3Bx?=
 =?utf-8?B?OFFDdHFpSDhkb2p6am01cHhzM045QlV4RUxDa2Nxcm5PcnoxcGYvNEdPb0Ra?=
 =?utf-8?B?aVdVbG5GVzFFbkVtcVdxQWwzRUlPS0VhSXRYZDZCM0dmd3doUE11MFQzZi96?=
 =?utf-8?B?YTFxanI2NU5BMzF2ZFZhTEdJb2ZNZHB5aGFxNEFkMDlITW5jaVl1OTEzaFFw?=
 =?utf-8?B?bUFLeGxXWExzck5PemhJd2drWENVKzZTRVNCMnBFMDRrTEs3YmpjTlNFSlFv?=
 =?utf-8?B?TURlcm11TnBISXZXcDVxRVo3WVFRVHMzTkhadUFYUHJUZmRaK2d5dWhjc3M5?=
 =?utf-8?B?ZDI1bkI3MWVlSTJkRWlORFhlMG9WUnRYQ0pRK3dEaFhLbDhkNXpTeE5HRWkr?=
 =?utf-8?B?UDJvamJIMk94dkZSNC9XRGMzYzY5WmFRaDBlRkMwRVVyN2hzVnlTQXhkVG5J?=
 =?utf-8?B?VmlmTVF1Mks5ZWFqNnQvbWY0WDcyUU9HYUtsdTE0ZjVoV3FBMzJNRXZaWGNK?=
 =?utf-8?B?ZExOdFp3dFZBR1JHWEFIRFE5UGdpeCtkbGtxeVpkUlZwcmcxTTBYL0drR0ht?=
 =?utf-8?B?YndLTTU1QytEdmJYa1FpZTdqOU5nUzFsQzV4c2lFSHdUMk9iMzZKUHF3VWdP?=
 =?utf-8?B?NTVCR0tSNTVEdDcyenJtNWQ2NUE4RkNybVZxOUNBaWg5UElYQSs3bkdoVFpp?=
 =?utf-8?B?aGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a27d8b7-6f28-4935-4dd2-08de3db9fd02
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 22:16:55.7742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xdRrbW5cl+FuRN49brpo5lzqcP7lwW91apxN5HW8Qkf/BquyhOejKGyTXWBdSQ9MdGqByRnDp6NITf9BcCEF5O5wRSP23Uwg7rquJbDz+wc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4854
X-OriginatorOrg: intel.com

Dear x86 maintainers,

Could you please consider this series for inclusion when you find is most appropriate?

I understand the timing before holidays is not ideal. I myself will be offline for a while
over the holidays. We can surely continue discussions about this work after the holidays.
I just thought it best to make you aware right when series is ready instead of guessing
what an appropriate time may be.

Regards,

Reinette

On 12/17/25 9:20 AM, Tony Luck wrote:
> Patches based on Linus v6.19-rc1
> 
> Series available here:
> git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v17
> 
> Changes since v16 was posted here:
> https://lore.kernel.org/all/20251210231413.59102-1-tony.luck@intel.com/
> 
> Cover letter
> Added some examples for Babu
> 
> part 11
> Added Reinette RB tag
> 
> part 19
> Update commit message to explain why it is safe to enable just some events
> within an event group.
> Added Reinette RB tag
> 
> part 24
> Added Reinette RB tag
> 
> part 25
> Drop unneeded local variable "ret" from all_regions_have_sufficient_rmid()
> Added Reinette RB tag
> 
> part 32
> Added Reinette RB tag
> 
> Background
> ----------
> On Intel systems that support per-RMID telemetry monitoring each logical
> processor keeps a local count for various events. When the
> MSR_IA32_PQR_ASSOC.RMID value for the logical processor changes (or when a
> two millisecond counter expires) these event counts are transmitted to
> an event aggregator on the same package as the processor together with
> the current RMID value. The event counters are reset to zero to begin
> counting again.
> 
> Each aggregator takes the incoming event counts and adds them to
> cumulative counts for each event for each RMID. Note that there can be
> multiple aggregators on each package with no architectural association
> between logical processors and an aggregator.
> 
> All of these aggregated counters can be read by an operating system from
> the MMIO space of the Out Of Band Management Service Module (OOBMSM)
> device(s) on a system. Any counter can be read from any logical processor.
> 
> Intel publishes details for each processor generation showing which
> events are counted by each logical processor and the offsets for each
> accumulated counter value within the MMIO space in XML files here:
> https://github.com/intel/Intel-PMT.
> 
> For example there are two energy related telemetry events for the
> Clearwater Forest family of processors and the MMIO space looks like this:
> 
> Offset  RMID    Event
> ------  ----    -----
> 0x0000  0       core_energy
> 0x0008  0       activity
> 0x0010  1       core_energy
> 0x0018  1       activity
> ...
> 0x23F0  575     core_energy
> 0x23F8  575     activity
> 
> In addition the XML file provides the units (Joules for core_energy,
> Farads for activity) and the type of data (fixed-point binary with
> bit 63 used to indicate the data is valid, and the low 18 bits as a
> binary fraction).
> 
> Finally, each XML file provides a 32-bit unique id (or guid) that is
> used as an index to find the correct XML description file for each
> telemetry implementation.
> 
> The INTEL_PMT_TELEMETRY driver provides intel_pmt_get_regions_by_feature()
> to enumerate the aggregator instances (also referred to as "telemetry
> regions" in this series) on a platform. It provides:
> 
> 1) guid  - so resctrl can determine which events are supported
> 2) MMIO base address of counters
> 3) package id
> 
> Resctrl accumulates counts from all aggregators on a package in order
> to provide a consistent user interface across processor generations.
> 
> Directory structure for the telemetry events looks like this:
> 
> $ tree /sys/fs/resctrl/mon_data/
> /sys/fs/resctrl/mon_data/
> mon_data
> ├── mon_PERF_PKG_00
> │   ├── activity
> │   └── core_energy
> └── mon_PERF_PKG_01
>     ├── activity
>     └── core_energy
> 
> Reading the "core_energy" file from some resctrl mon_data directory shows
> the cumulative energy (in Joules) used by all tasks that ran with the RMID
> associated with that directory on a given package. Note that "core_energy"
> reports only energy consumed by CPU cores (data processing units,
> L1/L2 caches, etc.). It does not include energy used in the "uncore"
> (L3 cache, on package devices, etc.), or used by memory or I/O devices.
> 
> Examples:
> --------
> 
> As with other resctrl monitoring features first create CTRL_MON or MON
> directories and assign the tasks of interest to the group.
> 
> # mkdir /sys/fs/resctrl/aet_example
> # echo {list of PIDs} > /sys/fs/resctrl/aet_example/tasks
> 
> For simplicity in this example, assume that these tasks have their
> affinity set to CPUs in the first socket. Set a shell variable to
> point to the mon_data directory for socket 0:
> 
> $ dir=/sys/fs/resctrl/aet_example/mon_data/mon_PERF_PKG_00
> 
> Energy events:
> -------------
> 
> There are two events associated with energy consumption in the core.
> The "core_energy" event reports out directly in Joules. To compute
> power just take the difference between two samples and divide by the
> time between them. E.g.
> 
> $ cat $dir/core_energy; sleep 10; cat $dir/core_energy
> 94499439.510380
> 94499607.019680
> $ bc -q
> scale=3
> (94499607.019680 - 94499439.510380) / 10
> 16.750
> 
> So 16.75 Watts in this example.
> 
> Note that different runs of the same workload may report different
> energy consumption. This happens when cores shift to different
> voltage/frequency profiles due to overall system load.
> 
> The "activity" event reports energy usage in a manner independent
> of voltage and frequency. This may be useful for developers to
> assess how modifications to a program (e.g. attaching to a library
> optimized to use AVX instructions) affect energy consumption. So
> read the "activity" at the start and end of program execution and
> compute the difference.
> 
> Perf events:
> -----------
> 
> The other telemetry events largely duplicate events available using
> "perf", but avoid reading the perf counters on every context switch.
> This may be a significant improvement when monitoring highly multi-threaded
> applications. E.g. to find the ratio of core cycles to reference cycles:
> 
> $ cat $dir/unhalted_core_cycles $dir/unhalted_ref_cycles
> 1312249223146571
> 1660157011698276
> $ { run application here }
> $ cat $dir/unhalted_core_cycles $dir/unhalted_ref_cycles
> 1313573565617233
> 1661511224019444
> $ bc -q
> scale = 3
> (1661511224019444 - 1660157011698276) / (1313573565617233 - 1312249223146571)
> 1.022
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> Tony Luck (32):
>   x86,fs/resctrl: Improve domain type checking
>   x86/resctrl: Move L3 initialization into new helper function
>   x86/resctrl: Refactor domain_remove_cpu_mon() ready for new domain
>     types
>   x86/resctrl: Clean up domain_remove_cpu_ctrl()
>   x86,fs/resctrl: Refactor domain create/remove using struct
>     rdt_domain_hdr
>   fs/resctrl: Split L3 dependent parts out of __mon_event_count()
>   x86,fs/resctrl: Use struct rdt_domain_hdr when reading counters
>   x86,fs/resctrl: Rename struct rdt_mon_domain and rdt_hw_mon_domain
>   x86,fs/resctrl: Rename some L3 specific functions
>   fs/resctrl: Make event details accessible to functions when reading
>     events
>   x86,fs/resctrl: Handle events that can be read from any CPU
>   x86,fs/resctrl: Support binary fixed point event counters
>   x86,fs/resctrl: Add an architectural hook called for each mount
>   x86,fs/resctrl: Add and initialize a resource for package scope
>     monitoring
>   fs/resctrl: Emphasize that L3 monitoring resource is required for
>     summing domains
>   x86/resctrl: Discover hardware telemetry events
>   x86,fs/resctrl: Fill in details of events for guid 0x26696143 and
>     0x26557651
>   x86,fs/resctrl: Add architectural event pointer
>   x86/resctrl: Find and enable usable telemetry events
>   x86/resctrl: Read telemetry events
>   fs/resctrl: Refactor mkdir_mondata_subdir()
>   fs/resctrl: Refactor rmdir_mondata_subdir_allrdtgrp()
>   x86,fs/resctrl: Handle domain creation/deletion for
>     RDT_RESOURCE_PERF_PKG
>   x86/resctrl: Add energy/perf choices to rdt boot option
>   x86/resctrl: Handle number of RMIDs supported by RDT_RESOURCE_PERF_PKG
>   fs/resctrl: Move allocation/free of closid_num_dirty_rmid[]
>   x86,fs/resctrl: Compute number of RMIDs as minimum across resources
>   fs/resctrl: Move RMID initialization to first mount
>   x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
>   fs/resctrl: Provide interface to create architecture specific debugfs
>     area
>   x86/resctrl: Add debugfs files to show telemetry aggregator status
>   x86,fs/resctrl: Update documentation for telemetry events
> 
>  .../admin-guide/kernel-parameters.txt         |   7 +-
>  Documentation/filesystems/resctrl.rst         | 101 +++-
>  include/linux/resctrl.h                       |  67 ++-
>  include/linux/resctrl_types.h                 |  11 +
>  arch/x86/kernel/cpu/resctrl/internal.h        |  48 +-
>  fs/resctrl/internal.h                         |  68 ++-
>  arch/x86/kernel/cpu/resctrl/core.c            | 230 ++++++---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c       | 473 ++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/monitor.c         |  50 +-
>  fs/resctrl/ctrlmondata.c                      | 113 ++++-
>  fs/resctrl/monitor.c                          | 364 +++++++++-----
>  fs/resctrl/rdtgroup.c                         | 293 +++++++----
>  arch/x86/Kconfig                              |  13 +
>  arch/x86/kernel/cpu/resctrl/Makefile          |   1 +
>  14 files changed, 1440 insertions(+), 399 deletions(-)
>  create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c
> 
> 
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8

