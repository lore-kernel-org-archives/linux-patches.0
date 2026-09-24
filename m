Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E138B4A1E1F
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790264273; cv=fail; b=lxaJqg8Yt+iTQJXAAej/U/S1O4SqIjJbCUbI8TdKVGDRfr3X7PNFrWL9RG6kr38n4METTx1XKJWaE5EnMgNdM3jKq5lXZRCINek32/F4dg+I5+R1vCHmbtOAHbGQ+hBnSdNZY4iCxxingS9PTfe204AQdN4c6J6Az7MmoDfFTis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790264273; c=relaxed/simple;
	bh=yEkOdJARH2YDIdqc9QtQwak/fnf8Dr3vKwfuRQUPR+o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U/ZW94GwGG4KdCcMldY9ydvr9Dv0isK/2u06L2NDILbcBrk/ERlq3qbQJV0QPtS9aW+nBjBCXChjldrOEmMyvd676nIRr1Z7O/RWwxaDLQn3rkUY4nKfMotxMipi+kpCxBxiSrAoUNn1YnPxctbfUa0rqFEn/jqucAiI0zPXpy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fEQKPRlc; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fEQKPRlc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790264272; x=1821800272;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yEkOdJARH2YDIdqc9QtQwak/fnf8Dr3vKwfuRQUPR+o=;
  b=fEQKPRlcKZqwV8iQxgygO/tpYpMQvtAW0wgS+8AIrMzPO4BynAGtFiix
   2E+MywpZdSxvpnNuhWeC27FsqdrARZhSLwobJDnG0q7eOPyZGgCeYuNuV
   O1fc6mLyHatmkTfiEjs8sSJplFWMTPYJEzR0Ub9Irfn2dj5F61F01/H8X
   ZvKHMUJBrAUeAzOVHs1J4CzHxeeE8yk4xMiXE1bS99k4cvJKURXE0c2CR
   VUI/7I1rh9MwmZhqM4CHZy0llftceA4FVKOyMuTpKjcw8WvW9mQj3L31Z
   iNpgPHS5tMTS17hEePmBhJd6AXiLs+qHeEnEV9ggcKKSDcO2EclSBW1MZ
   w==;
X-CSE-ConnectionGUID: M6irHCFtT/6Vs0X9uqGRwA==
X-CSE-MsgGUID: rkEcpOPZRImDVeAl5rc73A==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="102399323"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="102399323"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:37:51 -0700
X-CSE-ConnectionGUID: xN04Bp9PQYaaYku4nsV7wg==
X-CSE-MsgGUID: 9cv4f/O2SGOQgsquadKfqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="277448768"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:37:50 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:37:50 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 08:37:50 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.58) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:37:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SrDAi9OGNjMA0d+dkUe0HuLaRiDDwz4kyXqoh8ASupFwyYGcqJaWYjGdBfwd7mRT8iWm69AeK35kcBi/tyFDfAOQ7Rsb6CwuJwMc71csHb0wzS49slPmYfaSppju9zDZSjbsKiLALzqduAAMFJGbNcXGJ3+CQDWqYRt4ZY+Ed0wvs3Qudlwkoawz9uRlu7cS2qfEpGHA5oV2dc43RqT/WuDY0m48pg/oUaC9XkTUiE/T38WEZfUSzCuS+hjwfQMx/BrP8+/i0n5Kxp+dNXvn0XmsxX/9zOk7eltbZesmjJ9/Shb2VVIBktYwY8KGoYrZtjsurU7YXaA0navG3LERmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S8R8XL8EJoP5CqD88y1JcnOIe2DiEtBYQJEriFRfxn0=;
 b=lfp3N5513jHp3B99nmG6PL97zwsLknEeAmokocp+r74t6sN1fR9tt+BwGQ1CGsNdlQG62rdruVh2jsPsUDpjdWRKFk9ombIhj3ZEiP2QyTMRDH4eSSIjOdlp+NCfnQkgc0oOdtbHzabZyG3Yyf/D6Ini+r9gdCVX2G1FwPntA/tXQjGx8Flb7L4R8tDsl26AiHFbR4eOTXyohi8dftwu5bJh/3msDTLy1Ua5Id6+u77L/9rO+ED5PwZ0BYIN7yMQKyMG1Z3fOLhK13etuhWUcUy/rDFFn/mSQlDUvrrTq6LrMpPDWYrcnbHjP2mL8/rPBsUz+DnydLLWO1g53UVFUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by LV4PPFBC38331A1.namprd11.prod.outlook.com (2603:10b6:40f:fc02::22d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 15:37:44 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 15:37:44 +0000
Message-ID: <4cf8fe97-35cc-4940-92cd-6aff56fcdc70@intel.com>
Date: Thu, 24 Sep 2026 08:37:41 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 12/25] arm,x86,fs/resctrl: Allocate maximum needed
 rmid_ptrs[]
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-13-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0063.namprd04.prod.outlook.com
 (2603:10b6:303:6b::8) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|LV4PPFBC38331A1:EE_
X-MS-Office365-Filtering-Correlation-Id: 76e44f2b-9983-4e40-6171-08df1a51c6ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|10067099003|56012099006|11063799006|5023799004|4143699003|6133799003|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info: qbUiFmL1N7ECOOY1it9TEodwW3srmYvtUsqN7A79yzeQ8mp4dDO0dP/cSgW4ns65WJXeNbOhqKv0vXKMZS3ee+sXjb2zI9EYpvP6PDJwig5QaBP+syq0zZ4nIVXTKuMGTRKMUZ7juqAQNwuBnnN2F67Ohz76OErgEZAAIm5YxsDoWmv5FDFJAkWKbT/+frqHqvDDtqF1hozibwBDlYzz3cLNychWDofaQIEVQGCvvoFAtlEJdaH9rjf2Iq0fJ5n1hec1r9/YWzOq8NfJxzTfHUAE/RBvJf1pk0+I90tKuxHc6bqeFFKBRY6wi0ROk4wvyvbQQKQ379puB4dcHJKDkNA3e8mpIbKfdbdQuftYmetV+qhUqyl+Iw/TtiqUiRqhR54i3CeBMfwtukRKaTjUpxwsHHmhrAHeVJueknIBLSIT4qg0ZREZvdqzHLCh0xcjVwFSO0wR4AqBJixku1kwhArhTaIDoj0OLm4UeZ3MyJ3drvHZwONf61zy9IAJJLeW7RZmHG6S+N1a+zvZrUXw/taDnXldIwXemGYHwSeOpQNurv68D7rWndGWTUUm1b3whWPIaN4LQrH5k2PY+F80dYVu/hZ68K++rmUpZ909qs/vcegrzBYn680epzI3KS4UiDBfL5mGKwGw4Z7CWqWzjN1XckKvzur+mmh29lIHe/GOnmhlit35/foYY0MvfLozLxNrot1RX88xix/Dd72bNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(10067099003)(56012099006)(11063799006)(5023799004)(4143699003)(6133799003)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cW1QL1VUMmZzQkR5UmNFSTNIdDZvWDFUZmhpQ3lTVlZEbUFvVTdXYkRjdGdk?=
 =?utf-8?B?M0lNY1ExRVg3YXJ2K3VIWnNNVHM2bFhleXgxKzBhT0lncnZ2UlZqSHFGREI2?=
 =?utf-8?B?WkthQS82ZURGQUcrZ1crd3BUQUM0L1d6ajArL1MwVi9RZ1h0dUNhbzUyNHdp?=
 =?utf-8?B?OEtHZW1HMjhPVTUzQjJCdmJrMG51eVZMNENOMmFyM2lGYlhna1oyTGhKNEt5?=
 =?utf-8?B?VklvQjlJWk1yaDRGOWN3Z1VXc1RnWVgwR3RLbkxWMjI1b1pxa2Y3WkVRaDFa?=
 =?utf-8?B?enhDd3ZpcEc1ZU83b1ViVWMzSDRMSUZldVNGbjFHVVM3U1p3TzJyTXNzZUNw?=
 =?utf-8?B?ZlFUMDltcm5ZYXpyYk5ZRmdhRGNPcXIweXFXdEJlYm5jKytLbExrN3NoWFRa?=
 =?utf-8?B?ZlhLNzhoNHdZQ1RjcFJNaUZBb1J2OURaWUhRWDhzQU4yTEplRlk2ZmVlbS9a?=
 =?utf-8?B?eTBzWnRCRXdEeGJZVjh2Ny9IK2Jhc2JPbXpZM3VwYVJoQWZYTEFxVEV5Rkpy?=
 =?utf-8?B?WXlQSTNISkU1VjNja21qRytLYTI1NUpBYy9XWW5DZ3hpdTF1eTZTZTZFdFIx?=
 =?utf-8?B?Y0doOWgrQVJ4T3ZZWFZGVXVvd2xDTDErVnNObFJiTmU1VE5ibE5haFRmYWpW?=
 =?utf-8?B?a3p5cU40RytCVUZRKzA5WXdoZFdpb2UvYVhGaUJ1cVBYOG1UKytSZ09JMjA0?=
 =?utf-8?B?UnVZOXVIbXU2Q1VvaFdzWXB3UVg4WlhQbldaalErdU9sOEg1M2pmT2Y3WFN0?=
 =?utf-8?B?dVQvVFNRM1hucFVqY05QZFNFR2ZYem01bTZ6YXJNVHdLSEpFaklyeFpEMmZr?=
 =?utf-8?B?aE1JbTlOeXQ3VDVPVlFmT0NWYUpMbWJSZmFFTmlkdTBwU0xDM1J6YXhUZm5j?=
 =?utf-8?B?QjUvYnlLdUp2MHRicE81c3o0ZVJHQUswYlVCTWxZYXpLbHJBN0o5SXZMTFRt?=
 =?utf-8?B?MWcxRTRvR2Z6TXNZSGUvT1JwbkFHdGd3ZW5SLzNibEM0dkJXQnJBOEZHUHJY?=
 =?utf-8?B?RHE2YmFMWWNIdGxlWml3MmJBd0FjaGNiaHZ5cTB5dUduYS9tQnJrSlRxbVh4?=
 =?utf-8?B?WFE3dHBMNHZsckJRUmJlZDd4VlVoRmVBbFRIWHQ4SDRnaFozUXFwdkN4Z1E4?=
 =?utf-8?B?Q0Y3eitocmFrczdyVVpRQTRPZEMxWmdqWlJjR2V6UTQ0NlpydDF0ZHo2cG5F?=
 =?utf-8?B?UU5uMi9jYmRjeUVmeE9pVk9QR2lZM0x0OU00OUFJaC9JN01EQjZyNktuamtC?=
 =?utf-8?B?WDlVYWkwN1YzNkJjN3VPdmg0d1lFOC9QL2xOcGZGMGFRVmtDbDdmVUh3U3hp?=
 =?utf-8?B?Y05Ca1hqRlYrUnR0REl5Zk1pQTc2Y2xrRkdScGkvU2hhejVKLzNjNWo5eHVp?=
 =?utf-8?B?SVNEQ1M3RWorWGNKMkNZQXQ3VXFpVVg1NlNTVXN2eVFXWEoyeEVtajI5MGUw?=
 =?utf-8?B?Wk9aYVR0T0QxT2hBd3U2YlY5Ti9sMjAvQWZvL2NmMGkveGIyaGpKUGt1Z1ND?=
 =?utf-8?B?ZDFaNS9rK2ZJRE10K2pEczRmYzduMTFYelNRYVJrOXNZSFl2Y2lBcVlIc1M3?=
 =?utf-8?B?dS9FRktwQ09XbVZOdHVIck5uTERwdjJ1aGttS2VlaUFOMGRWN2t5VFBjRi9z?=
 =?utf-8?B?UktJcnNLNGcyNVd4MlpXVjFkRjNBbHZndjUvclI1Snp1YlZacERrMGI4dzlD?=
 =?utf-8?B?OEpoMTdqTk9UME5oSmtaSlZRWWYzeTAyakJ6ZlpRQTdDS2ErM0xFWVJCN2V0?=
 =?utf-8?B?NEM4dTdTdkh5UWlWcVl2R1J2MDE3WVM3Z2NxMTNPZFRyaW9lUk5qTi9vRita?=
 =?utf-8?B?MGQ3V2lqYVY5NzBzbkovWEJ6a3V6VUNiekFGNUJJQmV5NWRwdFJQbTJkOU95?=
 =?utf-8?B?aGNzMFFnWUhjV3VLbVdKT2xXZE9ZSkVDSEpxL1EwMVRwMTI3Q0ErSThyMzVH?=
 =?utf-8?B?UkZIdUhzUWZHR09vN01HNkhqVGp5cUJZOEM2by9tSUppaUZuSzRRdE1GMEFj?=
 =?utf-8?B?d28zRW1nVmVoVGN0bHdpU2VwREFpRjhzTUhFc2Z6Ty9QeE1IbkVUWmxmYUdK?=
 =?utf-8?B?alhTZjhmMHl1THFmWUsvYzFLNmwvVVpzYU1veHI2Y3IwcUs3NWZwL1VibnFk?=
 =?utf-8?B?Z0JTbWZsOUhSclFBZnoxZC8rSEJ0YUdEVENva1NwZGVMK1lNQW5HMFk3SmpM?=
 =?utf-8?B?WE9kdkcwRXk5V2pxSEUxUkpkc1ZZcWJPOG5BMXhvYzZGYzlwQXMvVXFid3ox?=
 =?utf-8?B?NWFxQ0IyNnBmbUlGZG1xOFljcnRLZ0x0aU9rZi9yaFdnVzlBRktGdWMzQUNY?=
 =?utf-8?B?cFM5VmRTS2xrcmpUaVlZNzQwVVQyaGIvOXp1cXhNUEs1R1BHUGlTbXcyWkh3?=
 =?utf-8?Q?H4GhAexcmgmdjUWI=3D?=
X-Exchange-RoutingPolicyChecked: lDNT/YR8QVuXyHd/Twve9b3Y4bpld91fm10FjdJdvIGwjz9jlvhP6pa7JJy+k6b+ThsC2VpaqxsIXDqbqqM7WcAnCSmnxd6FOn6aAVf0/NM3bym1xOZJU8FbFP/Sl5tiueNyc2jFO5hNuK1ybjtAz/npX4Im2aWncBhGmE7cRB2F/9l05r8iTLvmZu1WglNUXFv1rVoFI/s+70wN5pUv44x8URY6mSCDJjz21w3AhzeUEbzLvx6cZUnN45baCDyeCNwIJN7VNwLwsHQrc5C2Q4cdszWGZgZQFi8bzi0zKDijk8AfR/qx9hsuF1TlQThuqlV0dd0LxWAUrSdd7Hd9bA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e44f2b-9983-4e40-6171-08df1a51c6ca
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 15:37:44.1087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ofSpshX20XnRfUEXVFmWi6YkTvDw2gG3tfavgvToBymwXE7CIafXwJfarsDXp6CSWLGIMJyGjpGQwkrZZRfHkn9QvnI3Iw8iIvOepL0ZmK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV4PPFBC38331A1
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:
> File system code allocates the rmid_ptrs[] array once during

(no need to say "array" when using "[]")

> initialization. The number of entries needed in this array is currently

initialization -> "first mount"?

> constant. When changes are made to allow Application Energy Telemetry

constant implies a constant value but I think this actually intends to
say that the value does not change from mount to mount?

> (AET) to run with the pmt_telemetry driver as a module, then number of
> entries needed may change from one mount to the next.

tip preference is to separate the context from the problem description

How about something like this _draft_:

	resctrl keeps per-RMID state in rmid_ptrs[]. It is allocated on
	first mount, sized for the number of RMIDs available at that
	time, and reused by every subsequent mount.

	Application Energy Telemetry (AET) requires the pmt_telemetry
	driver to be built in. Allowing it to be built as a module means the
	number of RMIDs can change from one mount to the next, so a later mount
	may need more entries than the first mount allocated. Reallocating per
	mount is not possible because the limbo handler continues to access
	rmid_ptrs[] after resctrl is unmounted.

	Size rmid_ptrs[] for the maximum number of RMIDs the system can ever need,
	so that it is large enough for any future mount.

> 
> Allocate rmid_ptrs[] with enough entries for any future mount.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v12:
> 	New patch. Split out from old patch 12.
> 	New global pqr_assoc_num_rmid to avoid repeat CPUID calls.
> ---
>  include/linux/resctrl.h            |  1 +
>  arch/x86/kernel/cpu/resctrl/core.c | 27 +++++++++++++++++++++++++++
>  drivers/resctrl/mpam_resctrl.c     |  9 +++++++++
>  fs/resctrl/monitor.c               |  2 +-
>  4 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index fbf737e884db..5535bde7b925 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -447,6 +447,7 @@ static inline u32 resctrl_get_default_ctrl(struct rdt_resource *r)
>  /* The number of closid supported by this resource regardless of CDP */
>  u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>  u32 resctrl_arch_system_num_rmid_idx(void);
> +u32 resctrl_arch_system_max_rmid_idx(void);
>  int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>  
>  /**
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 2e3b9c16cbda..a9109f2bc43e 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -45,6 +45,9 @@ static DEFINE_MUTEX(domain_list_lock);
>   */
>  DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
>  
> +/* Number of RMIDS values that can be written to IA32_PQR_ASSOC.RMID */

"Number of RMIDS values" does not sound right. Also, please use grep friendly
names for registers. For example, "Number of RMIDs supported by MSR_IA32_PQR_ASSOC.RMID"?


> +static u32 pqr_assoc_num_rmid;
> +
>  static void mba_wrmsr_intel(struct msr_param *m);
>  static void cat_wrmsr(struct msr_param *m);
>  static void mba_wrmsr_amd(struct msr_param *m);
> @@ -124,6 +127,28 @@ u32 resctrl_arch_system_num_rmid_idx(void)
>  	return num_rmids == U32_MAX ? 0 : num_rmids;
>  }
>  
> +/**
> + * resctrl_arch_system_max_rmid_idx - Largest possible number of RMIDs

To match function name and later quest for "maximum RMID value" perhaps
"Largest possible number of RMIDs" -> "Largest possible RMID index"?

> + *
> + * Return: Maximum possible number of RMIDs used for boot time allocations.

This function goes from "maximum index" to "largest number of RMIDs" and then
comment below goes back to "maximum RMID value" with the caller finally using it
to guide allocation, not used as an index. Pick one usage and stick with it please.

> + */
> +u32 resctrl_arch_system_max_rmid_idx(void)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> +	u32 num_rmid = pqr_assoc_num_rmid;
> +
> +	/*
> +	 * If the system is capable of L3 monitoring the maximum RMID value may
> +	 * be lower than the system maximum. Either because the L3 monitoring
> +	 * feature supports fewer RMIDs, or because SNC (Sub-NUMA Cluster)
> +	 * is enabled and divides RMIDs per cluster.
> +	 */
> +	if (r->mon_capable)
> +		num_rmid = r->mon.num_rmid;
> +
> +	return num_rmid;
> +}
> +
>  struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
>  {
>  	if (l >= RDT_NUM_RESOURCES)
> @@ -967,6 +992,8 @@ static __init bool get_rdt_mon_resources(void)
>  	if (!cpu_feature_enabled(X86_FEATURE_CQM))
>  		return false;
>  
> +	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;
> +
>  	/* Any of the L3 monitoring features? */
>  	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
>  		return false;
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 0db62dd2a71c..0ffa25199f74 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -252,6 +252,15 @@ u32 resctrl_arch_system_num_rmid_idx(void)
>  	return (mpam_pmg_max + 1) * (mpam_partid_max + 1);
>  }
>  
> +/*
> + * File system calls this for one-time allocation of structures
> + * during initialization. Return the largest possible value.

Perhaps just drop "during initialization" since it is not accurate
(allocation is on first mount) and architecture need not be concerned
about this detail.

> + */
> +u32 resctrl_arch_system_max_rmid_idx(void)
> +{
> +	return resctrl_arch_system_num_rmid_idx();
> +}
> +
>  u32 resctrl_arch_rmid_idx_encode(u32 closid, u32 rmid)
>  {
>  	return closid * (mpam_pmg_max + 1) + rmid;
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 2a28fe04284b..e8775e08aa18 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -978,7 +978,7 @@ int setup_rmid_lru_list(void)
>  	if (rmid_ptrs)
>  		return 0;
>  
> -	idx_limit = resctrl_arch_system_num_rmid_idx();
> +	idx_limit = resctrl_arch_system_max_rmid_idx();
>  	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
>  	if (!rmid_ptrs)
>  		return -ENOMEM;

This split does not look right. It intentionally allocates the maximum as
the changelog describes but then it also uses this maximum to guide how many
RMIDs are added to the free list that should still be guided by the number of
RMIDs available during this mount as obtained from resctrl_arch_system_num_rmid_idx(),
no? This is what is done before this change ... and then changed back later.
Even more, the comment that accompanies this change ("Allocate the largest number
of RMIDs that this system will ever need.") only appears in later patch?

Reinette

