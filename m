Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F84242D6C
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 17:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761241517; cv=fail; b=cIr+9ys3q1HG3Kze5hYDoh7F2+etpG1FDeDWnhn4cQQLvGRhLupGALSjoeyqRo1Jb5i3zbmuB41wU+xWSgcH/2bygSLZIpeR7y5DofAB4OLOwRWFy7oOY8aEfaF2wYTddCUvMURMTg9ZF2gAleYK7RWnbADTZ+swZt1v69l3F1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761241517; c=relaxed/simple;
	bh=Fiqkdu6eixfcNw8cSFFcZ9pzB5+/SxuFRiknOq8Wy80=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tWp4QZ9sbLBx/32RkUOYwIblxfgi05yC2SpS8CmfyTiQ6PFaj+1+Xxjr7dXFv8PuPO6C4JW/xTekpUagaQJbkr8gBZvdZ4Xj5OeTvFPIg4KRUKCCoQYA4dvAMXHNRAthVIP3zWqw9UVSBcDyxBIAwxF+IW4M5dE0zRCBXkiPBfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SxXmY5RR; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SxXmY5RR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761241516; x=1792777516;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fiqkdu6eixfcNw8cSFFcZ9pzB5+/SxuFRiknOq8Wy80=;
  b=SxXmY5RR74w3LNX2V2zoiOcYt0UJDPFbcXVSAs3HNrFmFL1fyCsSYae3
   unPbGEGGTf1VRg5MaB6iwINwb47jTmB5ijdQWeQq1ciG6Wfw7uVa4th+E
   hQtXSa6LtKbB5bcTz8q60Dsf1qIEO97H6r0u3QhUIsNFe0Sd54NXcQX5+
   mxlxpzD1qs+uS9sWDfVE7nKcFs2aosXhFJ4fMhoZe4mM5IwTCizLHh6hc
   trTj4s4PJ85KLTRBwndNJepHwg8NIo7cy3KhrgCG0xKVx8Ltaqvyp9XFU
   VXDzqSc6fbEgkR8F6dOcQHMcxggsW4Bc0cBYBg2Ce4m3Rt2AHNsyHM9pd
   g==;
X-CSE-ConnectionGUID: iNK3D6dFQ9SjON7+/qTnXw==
X-CSE-MsgGUID: d0IDvAJeSeK8oO7jROpyDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="66035724"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="66035724"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:45:15 -0700
X-CSE-ConnectionGUID: KLofpJpzTRaqPyCnWB0dDw==
X-CSE-MsgGUID: GWhUKWxXQ/26w7LH9YvjVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="207870381"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:45:15 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:45:14 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 10:45:14 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:45:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B9iqhvoFEY5jD8PoiDUIOD4jv6PobmN+goIz4oAj8vOCfBefTBHN3qiGdiVdtWkoa7bkiZy4Vio1Kc0lYb66mdM75zBznZdk1aYFbXfeQGiF859YrQ/vkgwRMR9Mveke2UVJJDJ1Ev9yHTzqCwbUuXKluJ1E8yqMIAwVkoR26k9Z8xXMyum+MpbPXesX/vRxKyEUG+V2qY69dLQE553IyU+3Gk2Mukq6eZtgDkRNbPB2XdA0UEA9/V+okHujdfLoI9uG8fjia7fMqZgwf+JoiZ8j4mCVCM2dRdYR2iDCU8PaNNX+HqNeohb2WrFTVf9smIyjnMZyYgianPDK2z/zrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+EZMvkgaw0xLDFajyld5q03uw49WiTkzg/bPqAdFDo=;
 b=Y20zq/E1Cp2c+K0fyCEN20iyGpYVRiRBhcPr+y9YWjqjNm+711L2b9/LsIXnfUt9RVE73L7EBIoiN3vCx7GaXGasbIDi0un3p5ylMt8tN7GZZhJSJ+L3Cgk3PqaNOC6ygHyKDijnOOHXdw+3sCcjE7CEjDcAZns5FPCOVbst2ERYr4YU64BBBNye3yw9id5TBljtyNzic9M/XtdeVLzt15DOTRbLk+M+r0Nqy17VKdZJ5ulHIJ+EsszOmNpq+7ASsEooSFP0qA8zodn3WjoACoOmXzJQ9SKkC3WrjPFblb7G7tAQ7QxRoHqb1W0Bbl/el5V9lEb1TwcqNrnZpCYwZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB6784.namprd11.prod.outlook.com (2603:10b6:806:24c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 17:45:11 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 17:45:09 +0000
Message-ID: <4bcb8320-687f-4c43-b4b7-150d503b9890@intel.com>
Date: Thu, 23 Oct 2025 10:45:06 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 20/31] fs/resctrl: Refactor mkdir_mondata_subdir()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-21-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-21-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0011.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB6784:EE_
X-MS-Office365-Filtering-Correlation-Id: db453d69-fd9a-408e-00da-08de125be89d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VGpPMlpKZEtnYStpNmdCcmtQUDhHREtoVDJIVWd2VEV1U05KWC9NTWJTSXZu?=
 =?utf-8?B?elNzZzgrVmh5VUlHMjczdjN6WnZZdUV1THRpNnFwTVFNOFNPcWhEWlEvTzM1?=
 =?utf-8?B?ZWZUNmdUbzQ5RjFrTk00a1ltRTBoajM0ODlKa04vQWJwRTlOKzJjUW5Wa3hE?=
 =?utf-8?B?d2lsSlZFSGY4SmpRbEd1REZnN2gzdXljdFBDdllSTndCcnRobEdkZkxLbDhD?=
 =?utf-8?B?cDhHeDZhaVR1ak5RTlh3QUZFMVhNaHJFRUJiZU5VeC9OV1dvbGZKcnF0N0tZ?=
 =?utf-8?B?cjUvbTNEUHVtN3d4ZTNhQU5QRTRUZkdZYjlMWHl2Mm1RcGJETmZyNUl4Q2Zq?=
 =?utf-8?B?TWFmcjRtS2hScHFBWkgyRHRheG1vTFBRN3djUmZqUWxuOHhEYnZGR1p2RHRr?=
 =?utf-8?B?OTc1aVM2bjVDVzNZMmhiTUkwOXlZNzRLY0xTbTV4TUc4elhCVCtNbExibXU3?=
 =?utf-8?B?VlJLdTZWVHd2TEwzWG8xQzdWUFF3WGpGbDk2Yzgya2ZTblMrV0JFRXRSbDhx?=
 =?utf-8?B?RmtGRXd5alZ6bVJ5Y3JQQW1TZVJrdXIzRElOcHBYZ0phS1JPd1pJeHlEMERN?=
 =?utf-8?B?Y2NOWXRoR2Q2UFpoV1pvOEJMOTM0Y2k1bGVkT29ITks0ZkNoZlVPand0VkJp?=
 =?utf-8?B?Z2s5d21PSFBNc0swdE9nT0FVSGJueXgvTzFoUUlvKzJBR1F4M2JRWkRqOHVo?=
 =?utf-8?B?MXFiRFFNMnV5NUJkdmszZHpvSFR0ZllYZ3VlOFVIYzVmSUlsVjgxT2FvWm5U?=
 =?utf-8?B?NTRUaG4vb3EzSHdnN0RFdTBLRlllQjhXQTY1ZnNmU2EvS25NZ0ZwdHp1Y3ZF?=
 =?utf-8?B?VXBGV3JvaFhKUXdHTlFON1F4T2VzYm1RdGJuamdCeXE5cEtVYTdoVU1ZTGJp?=
 =?utf-8?B?VTB0Zm5JY3NYd2xNajNDaHRLOEhyUzVYbHRVYXcrYkYzY0RsMCt4WFg4TUZp?=
 =?utf-8?B?MG1uUjJERlVWTjN1R0k0OG9IN0ozdEhwTUxyVzVVcmpORUx0MmlhYUdqRVlJ?=
 =?utf-8?B?clhUYi9MMyt6emF2aHRYM1JRalMvZ0JWZmtZUVJIemNncEgrbWFzRDBaMGJx?=
 =?utf-8?B?RG5sS01iVE55TlEvdE14dUZneUFjUzhqMmhMMFhTak5zNlIwZThDdDhLc3Y5?=
 =?utf-8?B?OU5vUGlyOWloeHRaV2FjRWNQS2hSMld5Z0ZTdEEyZEsyYjJmNjdaeUYyc3FU?=
 =?utf-8?B?ZkRrZ25tU3B5VjhDODI1TmU2TFI3RDY1YnBQNDVaeVNxQmppMXk0Y1lBNmQ5?=
 =?utf-8?B?UUplUzRQdE9RRlJucHZhNC95UHJ6TThNcmQwOVJxb1B6aXJ2Yklka044eHFr?=
 =?utf-8?B?Y0xzVjNlRDgvcU0yb1JkVmdUZUF6dzJ0VGFzdTRxRjZzMldCZzEzc3hQajFj?=
 =?utf-8?B?bFFTSlY5Y09QbFljdWY3N2ZkdVc4U1ZIaE9EbFBzMGhKZE52azJnd1dCdjJM?=
 =?utf-8?B?TTNaeFRMNGxrOWREMDM5R1A3Q0VrMTZyRkxDYkpIVndDeUhzelNZajJpVjZS?=
 =?utf-8?B?U1BhVFViSmNFTmNPUEFTeDRNMk9IWXhVTjJHUDhqQ3YzMHhBak5RTzVuZitw?=
 =?utf-8?B?VUZ2Umd6V0RHVzd0VGxZY0RrY05XTFV3eGx5YzdEcm5xNldhb3dzMnBCZWhX?=
 =?utf-8?B?RTJVUSsxWnZJZGZXcjcvbk0vazhwZmc1VHpvTTdvaG9NNTE5a1VHOGhEa1d4?=
 =?utf-8?B?blFVa211QVplV3dRTUZrdFVacVBkOERheHd0dXc5azRId2NmVVFpcGhoUHU0?=
 =?utf-8?B?c0V1TnJKVnNFdE0xTmdRa1MxZVhzUXFvVC95andNTEdpeS9VVDdBV3hCaEt0?=
 =?utf-8?B?Q0J4dTI1cWVLQTdnWHdzMnluTjlnQVlsS2I0OXk1NlNENWlMaklIUWVCaWhI?=
 =?utf-8?B?RVljRm5nUUI3WURvdEYrNjZvZ1BMTkRnWkVHUW1CUEREY3lMQmFnYkVmaHJ2?=
 =?utf-8?B?QTZaRDRjVlZqZGhmdm1NRkdqcW9pKy9MczZJSFB0S0Vwc2U1ekR0d05DcUdn?=
 =?utf-8?B?dTV2MTdLd2NBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDZ6ZzlGMk1ibTZISnlpS0VLQkFOdEtGRWxzNE5zTzJ2NGlmNWlZTldDbW1B?=
 =?utf-8?B?VTJPZ3NxQnNqWEZqR2dqSWVmNnE5eFdna2h1ZllnY3lXbkxZSEVCNGVrZFFz?=
 =?utf-8?B?OE4xUldqTjMxZlc2bm9DQkM4ZmptMHJ4bGNQd2xndHBJUjZLUmU3U3BkMFg1?=
 =?utf-8?B?dHViTFpFVElzczBhSWh4NTF4NTVuU244dlFwOXRFMVlqdC9rVmpjdnh5YlNB?=
 =?utf-8?B?MTFxc3g3eHdXWHVPY3kvSDR2cnZXU0JwRWREaGhnVUZrS2NhQXNyQ21VUDdn?=
 =?utf-8?B?QjRzUFJyMGdsd0RRNUMra1hQMkFubDhydTVmeWJwbVNRNnNhU1dCVlExS2xG?=
 =?utf-8?B?bjBoWHY1QkxjM0l2M1BEMGcyS056RkZaa0h2aGx1ZXRDdmJmSThpM1ZubHJz?=
 =?utf-8?B?MjRxenRyL0xCN1Zxcy94VzdNMzFKbVllcHoyWXM2NU5wb0kwTzV5cWdpd1p3?=
 =?utf-8?B?c0pEYktxTnJYUlZQcmFiUEE2Z1BFRW1HQmRLdEgzTkhoMUo1SXFBQmh4YUNn?=
 =?utf-8?B?Rit3MTJhUm95THRZUVRyVWg5RTc3Z0EvTWh3M0NjNTVQY09yRndoR1hRazlG?=
 =?utf-8?B?dEIzRVpaUjNaemV6OTZCWTV0TGVGR2VoU2tueVBLVVdrNzZYQlhGeEJ3ZjRI?=
 =?utf-8?B?NUhXSjI1UFhRbExQWjlobC9Jazc4SWVYdWlBQTMwYnhaN1JUaytlZEg5Y0pq?=
 =?utf-8?B?UGwraVRuZlRrQ1hhQXRVeGh2UFJTdUt0d3g0c3RaODVzenIweWZYa2tOVGVp?=
 =?utf-8?B?WnRMZll0TWsvb0I3eUJrNjF3QWtPZHVxbG8wd0VrU0lOUytxenJMSURyYlpz?=
 =?utf-8?B?d1BFZmJTY1RNMXJPQVZTdU1rcTZmdnNlbHBEUWowOHE4SGFyRmxlZ1dsbnBM?=
 =?utf-8?B?YnRpekdBWmd6VFRmUGVscTRjZVhnZHlMT2tRYWQwYnpnV2VkZms2QW1IWW9v?=
 =?utf-8?B?N2ZrcjI2QVlhWXVBQUhtS2g2dXMrR3BWUTZXL3duNmdadlFOWnp3ZUt0RmQy?=
 =?utf-8?B?cUwrYXg3MXoyMXBZZ0RaSC8ycVpvZ1R4azNac2ZmdzZBbmxOMnRqRitPbFll?=
 =?utf-8?B?ZStRMEU5eVhzazN0VFNNcWdPYWsvcXBYWktqYUljU0pIYTVjT29zUExLZUI1?=
 =?utf-8?B?dVpvQy96bTZ2UHpmUCtScWtIaWFOSUlHeWdoNTNUU3RaMDFCMkJUSzN0QnJu?=
 =?utf-8?B?eXNWclVBK3IzQ2REREFJMVNOWnpRUnNSRzVCeEttYW1PUi8ybWhaUEc1cm82?=
 =?utf-8?B?MFhZdm1SVkxrZ2FNZ1VxNFM5ZXd1UE01QjJkL3hJK25VQjl3aTV6bHFBTXkw?=
 =?utf-8?B?OUk1enRCOWlTN25BU0tVUzliWHNIZkVacFcvanZrTmtBcFBhbjRyTVVSSXVC?=
 =?utf-8?B?RlZpbkp4V1pER3NFd1p1S2JIdzg5cnhvMnlqYlh0RGdKSTN1eFlrcG9RaFlI?=
 =?utf-8?B?VzNPNHJBNW1MYmlINFh2dmNMZ2dBTWpYNUlZTmxabFByMStkV0V4TU9XRWM5?=
 =?utf-8?B?Zkl1MFErWStlaEVWYyt5c0o0MDdJeXc0RWZXTWxpOUorakE2UndvemNqcjJS?=
 =?utf-8?B?TFRkczZickZyRnZYN2plRjBzY09HbnpTdTBMSjROT3ptNGovT2tqV0h3QjQ3?=
 =?utf-8?B?bFVhekNBNjZRdS8wQWhhRU9ndW9qSzFSaWxrdm5RVEdLYnU5bzFmY0pwSGRr?=
 =?utf-8?B?dUVsdkx4bVlnU2ZHUG90dmR6Zm5tUFlKak9Jclh5ZEtNY2tXTnFKazIvMkRa?=
 =?utf-8?B?V1FqaXJISTBBa2lJM0tjcVhRRE94ZFNzOEZIN1dzK1dVUG5ERkVORFVoc1Y3?=
 =?utf-8?B?bUNUcFBpdzBwU2l6NHRiMTM1Rk9aVmRQTG0rSXdMM3NDVEtEUUJ5cUllL3c2?=
 =?utf-8?B?OEdkNUFMUGNWWDB0ZTQwUVBpSCtBazB5dks5aVVtb1h2SDZRK3ZIeVRJY01U?=
 =?utf-8?B?MTZkM0JYa09pVjNod01NMjVrMFR0Z0tpUGFhNzlMOTFLNjJ6akxzVmRBUWQ3?=
 =?utf-8?B?a3gzbnVLWUxhODZ3elIwSVByOWdKd25EV2pYNzlRd2F4Q1RpNDRhaTJqUk4z?=
 =?utf-8?B?dFRuZjVKWlIway9TR09xQzVLZDFvT2tVVFpuUm0vZFlDaUM5NXo3TkFNUVRG?=
 =?utf-8?B?NDl0cmg2UmdOS2lFUVNqYThZUVZRRmlORU12aFVSSnJsSFhFY2o0SmRJNWpO?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db453d69-fd9a-408e-00da-08de125be89d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 17:45:08.9096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ovzf0CmPixO3dEfe234plnXNDF2HMcj41O//ckTqlCq+CU5TujYdPbjoKpIhj/0Uv2aLdGgvHq6KL3jNt79gS3gMka3TqVAeiljLm9+0ui4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6784
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> mkdir_mondata_subdir() is unreasonably complicated because of the support for
> Sub-NUMA Cluster (SNC) mode.

"mkdir_mondata_subdir()" -> "Population of a monitor group's mon_data directory"?
(to not describe code but what the code does)

> 
> Split out the SNC code into a helper function to make it easier to add support
> for a new telemetry resource.
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/rdtgroup.c | 83 +++++++++++++++++++++++++++----------------
>  1 file changed, 52 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index c9d2cc1fd8bf..b7eaa4388768 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -3196,22 +3196,16 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>  
>  static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
>  			     struct rdt_resource *r, struct rdtgroup *prgrp,
> -			     bool do_sum)
> +			     int domid, bool do_sum)

I think there is some redundant information in the parameters that can be simplified.
It is already familiar that a domain/header of NULL implies that this is SNC/summing of domains.
For example, mon_event_read() and rmid_read::hdr. I think it will make things simpler and consistent
to do the same here where a hdr value of NULL implies sum of events. With that do_sum
will no longer be needed.

>  {
>  	struct rmid_read rr = {0};
> -	struct rdt_l3_mon_domain *d;
>  	struct mon_data *priv;
>  	struct mon_evt *mevt;
> -	int ret, domid;
> -
> -	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> -		return -EINVAL;
> +	int ret;
>  
> -	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
>  	for_each_mon_event(mevt) {
>  		if (mevt->rid != r->rid || !mevt->enabled)
>  			continue;
> -		domid = do_sum ? d->ci_id : d->hdr.id;
>  		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
>  		if (WARN_ON_ONCE(!priv))
>  			return -EINVAL;
> @@ -3227,24 +3221,20 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
>  	return 0;
>  }
>  
> -static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> -				struct rdt_domain_hdr *hdr,
> -				struct rdt_resource *r, struct rdtgroup *prgrp)
> +static int mkdir_mondata_subdir_snc(struct kernfs_node *parent_kn,
> +				    struct rdt_domain_hdr *hdr,
> +				    struct rdt_resource *r, struct rdtgroup *prgrp)
>  {
>  	struct kernfs_node *kn, *ckn;
>  	struct rdt_l3_mon_domain *d;
>  	char name[32];
> -	bool snc_mode;
>  	int ret = 0;
>  
> -	lockdep_assert_held(&rdtgroup_mutex);
> -
>  	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
>  		return -EINVAL;
>  
>  	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> -	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
> +	sprintf(name, "mon_%s_%02d", r->name, d->ci_id);
>  	kn = kernfs_find_and_get(parent_kn, name);
>  	if (kn) {
>  		/*
> @@ -3260,27 +3250,58 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>  		ret = rdtgroup_kn_set_ugid(kn);
>  		if (ret)
>  			goto out_destroy;
> -		ret = mon_add_all_files(kn, hdr, r, prgrp, snc_mode);
> +		ret = mon_add_all_files(kn, hdr, r, prgrp, d->ci_id, true);

Continuing from the earlier mon_add_all_files() comment, passing a value for hdr here
does not seem right since there is no single domain attached to these files being created.
Now that this code is made to be more specific it can do so more clearly by passing NULL instead.

>  		if (ret)
>  			goto out_destroy;
>  	}
>  
> -	if (snc_mode) {
> -		sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
> -		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
> -		if (IS_ERR(ckn)) {
> -			ret = -EINVAL;
> -			goto out_destroy;
> -		}
> +	sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
> +	ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);

Noting here that kn was created earlier with mode of parent_kn->mode. It thus looks to me like
above can also be written as:
	ckn = kernfs_create_dir(kn, name, kn->mode, prgrp);

The reason I mention this is that this patch adds a third copy of a very similar code snippet
(kernfs_create_dir(), rdtgroup_kn_set_ugid(), mon_add_all_files()) that looks like a good
candidate for a helper?

> +	if (IS_ERR(ckn)) {
> +		ret = -EINVAL;
> +		goto out_destroy;
> +	}
>  
> -		ret = rdtgroup_kn_set_ugid(ckn);
> -		if (ret)
> -			goto out_destroy;
> +	ret = rdtgroup_kn_set_ugid(ckn);
> +	if (ret)
> +		goto out_destroy;
>  
> -		ret = mon_add_all_files(ckn, hdr, r, prgrp, false);
> -		if (ret)
> -			goto out_destroy;
> -	}
> +	ret = mon_add_all_files(ckn, hdr, r, prgrp, hdr->id, false);
> +	if (ret)
> +		goto out_destroy;
> +
> +	kernfs_activate(kn);
> +	return 0;
> +
> +out_destroy:
> +	kernfs_remove(kn);
> +	return ret;
> +}
> +
> +static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> +				struct rdt_domain_hdr *hdr,
> +				struct rdt_resource *r, struct rdtgroup *prgrp)
> +{
> +	struct kernfs_node *kn;
> +	char name[32];
> +	int ret = 0;
> +
> +	lockdep_assert_held(&rdtgroup_mutex);
> +
> +	if (r->mon_scope == RESCTRL_L3_NODE)

What happened between the time you indicated that the above will receive a resource check 
and this patch?
https://lore.kernel.org/lkml/aOhd_A5L8PV0OYba@agluck-desk3/

> +		return mkdir_mondata_subdir_snc(parent_kn, hdr, r, prgrp);
> +
> +	sprintf(name, "mon_%s_%02d", r->name, hdr->id);
> +	kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
> +	if (IS_ERR(kn))
> +		return PTR_ERR(kn);
> +
> +	ret = rdtgroup_kn_set_ugid(kn);
> +	if (ret)
> +		goto out_destroy;
> +	ret = mon_add_all_files(kn, hdr, r, prgrp, hdr->id, false);
> +	if (ret)
> +		goto out_destroy;
>  
>  	kernfs_activate(kn);
>  	return 0;

Reinette
