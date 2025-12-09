Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640D3306D2A
	for <patches@lists.linux.dev>; Tue,  9 Dec 2025 19:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765309311; cv=fail; b=L00HCHJ0qmEffpv2hmw+U/WuVB2R1pvH8XCX+DIsGdzhNWQ1kCKfpvYFXNYaKnP6jzHv9N0+Sf+YWqT7U93g05CT4t3chUFjgL4Q5xX528ePjRLio6v7RNKSwO/nHLtbYBCRg7thalePOVX7MbEORdatzIzha0Q9BKGC27yFa0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765309311; c=relaxed/simple;
	bh=iplflH/l3HA2lmFom2/lL6ovUsON3z3IJ1a0Zv3WYRQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HQXAE8FTN7gYSLWlwzy/aZxPYf8V/qXt1buU0ZC81nSMbb3XruvJwEeUHK4cp6IWILmPffCGoB7+dsLs7iUVlE9MrmxKyVnyWdv1V3PLbpszUR0u0uZPzMw7EDAbqEhBAXmUTrd88IE5YEgCs1cAsmuwOuml9BeTKZ8bRdnaF/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kp0hZwiy; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kp0hZwiy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765309309; x=1796845309;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iplflH/l3HA2lmFom2/lL6ovUsON3z3IJ1a0Zv3WYRQ=;
  b=Kp0hZwiyyUFtZGiy06fzhLa9HRuHGPDPCzxddbX8aiXPytrSm4agx4Pv
   yRwMJLv/s/QBMnCZQ2me3spPZSmnkJjucCp5kOTq/r1iW1+w5D/FIOSfU
   CdOYV2MWrWCd7rEKek7feq7vhTT0ZB0uM77hk6gYkNcOgN1yXEI7g8HxO
   b04oHQKY1RoDGBAWogvzvWbJO+psvrTVEEYmNBsTF+ZhiGliNUM/NagJj
   WQe2xCXbUfz+BX5SO4GbjsnwURoNl5sz2vsVp9b8Hjv2BzPNsHBoTIqHD
   YTIwv7dJVzZmNgw6D4xdKyHEqRf92zuQcv/2dgWLVoE5L1fU13xE+2rcD
   Q==;
X-CSE-ConnectionGUID: mS/fOmw9SYuWx3C0EmF6yA==
X-CSE-MsgGUID: 8RanUd3MTcSaE66fk3YXHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="67350446"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="67350446"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:41:48 -0800
X-CSE-ConnectionGUID: z1wW2ZOgTl2ZS6VH+GkvVg==
X-CSE-MsgGUID: Fy5EVZDBRsueIBQ0aJLRGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="196315871"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:41:48 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:41:48 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 11:41:48 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.1) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:41:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nzkMLcNsxaT9TIxgL3+sKvrNflWMekKwzsReCYcrqfR2b79ow2why8gI5GrH8FHxV50bM84WmYh97oC4fKnsAoknz26XfQJTTH2CdKYNyben9oPoMZ+JduztWieYCBGnuKKxhD4NqvdQLKbTvlT/DpAxqDRljgujFw1RjzhlrvBEN2QTyRsCmPSL9npGtj+v/mvIFl9q8nty8KhO2nBVw/Zff4qL9a9C/iXGhBjmTqu1Q2+x8BuTLYxhz/jdTiJk1VnaA1Wqiem/Ravfe4Fmd/cEL5wzjq/6ml4yRrsUhZF5xZK9ghPtcDtlLZrgUro5PE6mbp3ae3lEz5LcjFmeSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DONu3QLCD9OV2+xusffuu32VJnfSPQP96sFmv3EBa0=;
 b=beZd9KCPAV6eIi0BjY4tXlWn5jkJa0DGzwCvFmu2zATQ7I2oap7k4vZUT1vhsBRyKceMDF/r8EFgTyoRtV5BLTK+3W1SfdKaiRhveJe+fHflwjVLyQxH2w/2ExnAa0v0N1GUGH+hU1G3n9kqW4FCi6PtqpgOmaqj0RWOxvscxW0XpqdGlP6YQKFarSoa8mtf9tHiBt1imlPiHV4LhKuLxbluDSOiz4uN4wRcxLJRbaYqDXkSQ0ZoVcxxsKmsKjM6mzqLW35mC1LXQKoaKFLEwpFpEpH0zK4vHFFkO7g5BtUYgWm6mw2Zh9P7ZbkMhr8xzfR8MgwklbRLNiNUQjxuMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB8027.namprd11.prod.outlook.com (2603:10b6:806:2de::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Tue, 9 Dec
 2025 19:41:46 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 19:41:45 +0000
Message-ID: <290e8f7b-82f0-4189-8bfe-8ff198746ecc@intel.com>
Date: Tue, 9 Dec 2025 11:41:43 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 19/32] x86/resctrl: Find and enable usable telemetry
 events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251204205404.12763-1-tony.luck@intel.com>
 <20251204205404.12763-20-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251204205404.12763-20-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB8027:EE_
X-MS-Office365-Filtering-Correlation-Id: 2488977d-0950-48e8-8a61-08de375afc7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SW1wOGpZMkM0M0VTWDRTZFRLdzZPeGlGamIvaE1TREZ2QTVOWHRjeGVIWGZX?=
 =?utf-8?B?ZXN4T3pnS29qdkVmVjVwa2dldHZlUkI0RnNpanZpUEZYVTNqQmVnanBFYXhC?=
 =?utf-8?B?eU96SGxzbkVvaFZwajBDM0U0Wk9WRU5ZKy9TV3dQT2o3S2laTUZmMjRXdVRF?=
 =?utf-8?B?aDZYMlplS1pJMEhGbHlaMjAvdGh5Y0JMNUxLT1IrUjVySnJBVnU4RzNsV2Fh?=
 =?utf-8?B?bXhZT201WS8vTCtJNjU1MVplRjB6M055OEVKTlRiZTY2N3pObFI0Mm5XNlZU?=
 =?utf-8?B?QU03Ylg3czBaWElYRkQvZjN0NzZJdFJ6bXVIeFhzTFQxWENIb1NzWmdZNmM3?=
 =?utf-8?B?N0daS0NGdHpkMjNoNDNBM21sS1hVcVFudU9lcmxvOUtGOFVoWjd2UjVHa1Fs?=
 =?utf-8?B?T215Q0lpNDUzL085Y24vN0toSEl6T1dleGZyamVPRjN5c1JaUzFzSTErSnc4?=
 =?utf-8?B?eVNGMDliWXc2RDh5TlY1WWJWQW5sTjhRV3owb3M0Rm5ZUFl3QWdkMDZaSHBP?=
 =?utf-8?B?MlFtcTZWSzBYRUFzaDJWV0JuSEdUUXc2dk9kVnZtejB5cEFjbHQ1eGpURVhG?=
 =?utf-8?B?YlhBWGd1M1VtV0hNTEg1UUk5WG5NMHRXemNIK1VGSGZqaytFSFNqRFo2NTJG?=
 =?utf-8?B?T2VZVVB5UE5pUjJIZzZHK3ZLNHVtNzdVekk4RHMzYUxJeGpTeTJBT3lJVHdz?=
 =?utf-8?B?b2FHOWNXU2d0WlR6T1d2SHp1d05peVJkNFBRRjh5bStRWi9MWkJsTzZIQ0dx?=
 =?utf-8?B?SityU09abkluREExWXlPQ2RpcWg5dzZhdHhxVVBRUEx5aFhzSWRBdm82Q0hu?=
 =?utf-8?B?Y1p4cXhiT2xhYXg0b01CMnRRa2lhRjZNbTdoVDA2M3BSdFIvUEoxVUVVbGgx?=
 =?utf-8?B?amVRanJZSFVOUkJieE96R0ZhREN2bGZ1ZVVkN3k4UzJLamwwM3V0Q1BlWFBY?=
 =?utf-8?B?R2hMdXlBcFNoQmdUcC9LbWcvSGorVitSVzFzUUQ0bEZYQzVIaVYzNkZhRlVG?=
 =?utf-8?B?QURuM2l4ZGZONldRc3JNeUZNQjFkM2p1TmR0a3YwNVhFaXMwN0VmTzlwTERX?=
 =?utf-8?B?cjlYMi9PZmprZDJFVlhKdUF5SjN1NkFab3R5WCtsZE51SEdnRStjWUQyRGht?=
 =?utf-8?B?Q3BSVUFDV3N3N0t0TENUU0JKQlFRTlBvK29TUlBuUktQTEE5bldQN0swdjRa?=
 =?utf-8?B?RVdRa2h1M1dvWExSSWNoUUc2dlJ1OEQyczhVK0pKT01XTE5tNFdMTzZKQmFX?=
 =?utf-8?B?UmxjTUh5TUJCelBKMzFaRU8vbkowVHN4Mm5vb2pQTi8zUkRabnlpdkxTeU9V?=
 =?utf-8?B?aWdVK0V2cWpqUFBwNm1TOWx3eVdnckdLcDdObndhc2k2clc4Z29DbWF4dG8x?=
 =?utf-8?B?M1dLaXhiaXlQQlNzSUJMNEZGVS9wVVVWMnNNWkxjdnpvbkZvRUdWZGlJaDZx?=
 =?utf-8?B?WGhHYUphWVhSSy9QbnNOY2RtMG1QVThTTTVCenFnVzhuVjVsbk5ZQmJZU1Jy?=
 =?utf-8?B?cHloN0lubEwxU0kxTW4zbHRwZklyRU9oOVpuNFVRZFVHdk9pQ0YvSkI4a1lM?=
 =?utf-8?B?SVFScjgzY05ESm92ZCtXQVJrSUVCUjVHaEpwcmVsV2hwWWNoeUxKTHBzV3Ax?=
 =?utf-8?B?WmNhcFhrNTI4U3NPanVWbkR4aWU0VW93RmIxSzJvd3c4Q0RlN2I0UDRYd1V4?=
 =?utf-8?B?VDh6amFubCtuODZ5ZG9uVnJCNnpITUxXRTIxZHZXSmhmbUxGbHBHSmhiZ1Nn?=
 =?utf-8?B?bVhWNFBJT3FQcjBZMk9WSXBxNnZidGZ5Z2psSWxDWGd4UldOWUdpclI3WjJX?=
 =?utf-8?B?cDcwRStpQzBobTNycmdQRVZ4WjlmWWp2UWNCbFRwR2EveXhtRVNLUWVINXBW?=
 =?utf-8?B?OTl5OERsYWd2NkpyU2RFbG1rMncyOE45MWc3SmRkdlo5WjM3YWdZRGh6eGRY?=
 =?utf-8?Q?5dg0YlKJsYWFTgkIlqT1JHjVYQQqtX7u?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0g3VnNaWEFsdzVCOWs2L1Q3UlByZHFZMHMvYklPcDB0VlN4UnVmUXcwMSs3?=
 =?utf-8?B?SG5rRGJhSW02amcrekpxQ2Rza0w3TXJ3WlA1eHRMaXBwMHpMTlUwQkcwNC8r?=
 =?utf-8?B?aDU1d1FWemh5YjRNS1ZzNUZMZGNQTy92RTh5RnpLbkJFS0VBZC82Z0hsYVk4?=
 =?utf-8?B?UW9JOEdaZTNGNExsNU9ieEZyMXBLbkpBcHFES0VsNjh5WWE2aWtLV0RZa1E1?=
 =?utf-8?B?c3ZRU2EwajRvcWF3M2FRZi95NW5TbjlUYlpTK3JWK1BzTENyTFZKNTN1dnhL?=
 =?utf-8?B?U0dQZmNkYUJsVW9aTy9ieWMwT1NWbGhBRURhR2xLVzU5VzNIbUd1UUFFQWRM?=
 =?utf-8?B?blF4dzlhWm1oZ0tHNG1uQndPU3NFMXhCMmN2NCtaV2tqQy9yQUh0YXEzRWJG?=
 =?utf-8?B?R3FWMVF5eTZOVFZvNnlSb2JuOEV3czc1eXdBdUVhSWIxUDlMNkVsZTlnS1dM?=
 =?utf-8?B?WkJPMC9MV3J3KzhsTm9UV1BEajZHUjNiT2E0MHBpZXpLR1NUd2l3UzBFVXps?=
 =?utf-8?B?VktDQml0RFk2N1AyQUxLcHR6TDdMYzJab1IzYWEreTQva3VDZEVuYmtoaEtT?=
 =?utf-8?B?bVo3ZmFoUWhBZHBkZGx3YTNhY202UjN2OURzVlVIUXhrUDZUVUZQekVqbWdv?=
 =?utf-8?B?d2VFb3g2WVdZOHlHRHp5Y1ROakFGRVFDdE9SUmxra0pEdVRpdTZYKzNrb1Av?=
 =?utf-8?B?SGpydHZuWEg2WkJFTS85V1BuKzcwOFQ3MVdWN05EUFduM1ZqZWVwVitYSFFG?=
 =?utf-8?B?alhmTnZ2czFsTFp1MUFRUGo3aXJuRmp0eTRlR1dPNnN2b0FGUnkycnlWQXdT?=
 =?utf-8?B?WWxiQVhmdW16YXlTclNxZFAxMHZPdUl0RFpoOThDMXpkZXZ0SEtZMWdaUXY1?=
 =?utf-8?B?SXdmT3ZNTWlBbGFUcVVnSENZMFM0V3Z3ZmQ1THVRdmJzVGlycDBKblJ0bkMx?=
 =?utf-8?B?V1hFWHhMNFpXSzhpYnlweTIwZVFzM1A3eU5NQlpETXdDOXFQNXlMOWhMemRF?=
 =?utf-8?B?TElZM1N4SW41NGdQeCtCQTMzUityUTA3Rk9MQkdlVlZDU29wc2tpWkU3clNT?=
 =?utf-8?B?d0x0YW1zd1IvTWNYa1JiOEtRWjA0YW01Tkwzazdsa2xnVExWWmhBTmxMajlu?=
 =?utf-8?B?REVlYkZtZkZucWYwWTRZVjhrT1daTGZ3ZU16Z1pnQldSQXd5Y21qaXAzM29F?=
 =?utf-8?B?cUwvV0FWL0FHOWdwNjY0UlpUenZISGtPWmxuNjduOTdOcDBIZXBhVnloS2NB?=
 =?utf-8?B?R3BpNG1RaUs0aEtsUFdZdFAzSkhxdmdkbzBOc3FlVzgyK0UwU2puSzZpVHJT?=
 =?utf-8?B?azBUNWg0MGw0NEJrYUV1Z3hLSCtZUWszTFpqelhDY1dFRnAxbUVRTDN0UjBW?=
 =?utf-8?B?cjFTUGNuWlJBYURHdmxOSzhGSGVxdnR0NHZRanlNK2JlYXh2Myt3YlZUMEQ3?=
 =?utf-8?B?RmR5UUptbmtISUVxL25BcUN5YW1sa0VZdUt6bkVPc05UTm9VZkRwWUhXOG93?=
 =?utf-8?B?OGZJMUpHbU9PSGh3Y20zTm1RZFYyNTU0VEdEbi9Ea1Rhd3Nzb0FCcFFwemcx?=
 =?utf-8?B?M2F4TmxNOHRtbDM2Skt5TTFPT3ViSWkyT2xxVUVYSENMRGdKMDlzd3pCZjJs?=
 =?utf-8?B?cDdyemhMODVHNi9nbko1NnR5NTdPejEvVDlhbjI0NmtSRWpqdVBFajVQOEFK?=
 =?utf-8?B?UU9kN2R5c2lpSzZTc29XYVFSdGdRTitmNDB6WnRMcWJ5ZFUvU0xyWHZuRTB5?=
 =?utf-8?B?MEFMVEtXUGpNY29iRnhwa25lbEk3QU52R1ZFYTErd0l5bkRpdmcrQUVWNmpF?=
 =?utf-8?B?Y1lEQ0s2aUZsS3RERFloKy9lellITzJqc2hJVGlKWGRPUFZDaDNjdUw3Vi9a?=
 =?utf-8?B?MjljbE5PZlkzZWw1OWNJSVN6bTFhejVyeUhUYWo3dzh4NXowWWlwWjN6N2sr?=
 =?utf-8?B?RzJWcWFtZmFrY096YkptN09CRlRvR2pwWThiVzBrSFl3ZGgrTEQ0QW9yZHFX?=
 =?utf-8?B?M1FUNkE0YnVKbWJ4Wk1NUGsvdnVGdytHQ1ByV2VaWVA0eG51ek5UN2JYUzhs?=
 =?utf-8?B?NFE5TlFNY2lRY1pNZzVVSG9MeEtYeStDS0UzVDBuMFc5czVFZE5nRGtIbnR0?=
 =?utf-8?B?QXFRQndFUVluVjl0WWFNUFE2V2hqUW9hTE9GTzJBQy9sZFBVMTdTQUpSa2ND?=
 =?utf-8?B?TlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2488977d-0950-48e8-8a61-08de375afc7d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 19:41:45.8366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDF3e/SJYXrfNkjaaAvONg2+B7OnX84ZvDTJfxR4X2ABUi7jjQ4EUwSuty06KA+b8/n3xqdRR1qCnmr5A7AAAY4tQIyNEDSmeqam7erdo3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8027
X-OriginatorOrg: intel.com

Hi Tony,

On 12/4/25 12:53 PM, Tony Luck wrote:
> Every event group has a private copy of the data of all telemetry event
> aggregators (aka "telemetry regions") tracking its feature type. Included
> may be regions that have the same feature type but tracking different guid
> from the event group's.
> 
> Traverse the event group's telemetry region data and mark all regions that
> are not usable by the event group as unusable by clearing those regions'
> MMIO addresses. A region is considered unusable if:
> 1) guid does not match the guid of the event group.
> 2) Package ID is invalid.
> 3) The enumerated size of the MMIO region does not match the expected
>    value from the XML description file.
> 
> Hereafter any telemetry region with an MMIO address is considered valid for
> the event group it is associated with.
> 
> Enable all the event group's events as long as there is at least one usable
> region from where data for its events can be read. Enabling of events
> can fail. Warn the user if none of the events in an event group can be enabled.

"Warn the user ..." is clear from the patch. Please add explanation why it is ok to
proceed instead of fail when some of the events cannot be enabled.

> 
> Note that it is architecturally possible that some telemetry events are
> only supported by a subset of the packages in the system. It is not expected
> that systems will ever do this. If they do the user will see event files in
> resctrl that always return "Unavailable".
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---


...

> +
> +static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> +	int skipped_events = 0;
> +
> +	if (!group_has_usable_regions(e, p))
> +		return false;
> +
> +	for (int j = 0; j < e->num_events; j++) {
> +		if (!resctrl_enable_mon_event(e->evts[j].id, true,
> +					      e->evts[j].bin_bits, &e->evts[j]))
> +			skipped_events++;
> +	}
> +	if (e->num_events == skipped_events) {
> +		pr_info("No events enabled in %s %s:0x%x\n", r->name, e->pfname, e->guid);
> +		return false;
> +	}
> +
> +	return skipped_events < e->num_events;

Now with the "if (e->num_events == skipped_events)" snippet in this patch this can just
return "true" here, no? Doing so avoids the unnecessary churn of switching to "return true"
in patch 25.

Reinette

