Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F12199939
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 16:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691374; cv=fail; b=BjXo9ReLjwA//mR395XFOCH0wO1cZR8CXEyf2Rbcyg4eBUZAjGeLPtbaImgdcv5QPqriobZrsQxJF2Aiullf4keWhK+d2APJ5hj2aOzRW4ibE7ebBjbzXdcFLigQ5byppdQmUOntnKkfk+OqbLPcE+1ShyhiKDx+3eVONnHC980=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691374; c=relaxed/simple;
	bh=yvCIChoka4gQidULLCusUWGWL3SF37Hxfwm4k1w4U5c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VCsU/q8+WcW1bB0Bvtgg/9f14p7eXn6EiIUffk9q1INP0eGaR3r9t89KvbocHdfNYF1EJnHhfhlHtllJQP1Izkjor3LlQNNh1vsgpSEJA6ECzSgtsJZTP9bFjCVA1545vsr02/cttXdrBhhJvp8Qq/HFYV7MNpSoUxgOwueawyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KdUJXExK; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KdUJXExK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691373; x=1796227373;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yvCIChoka4gQidULLCusUWGWL3SF37Hxfwm4k1w4U5c=;
  b=KdUJXExKUQyHfWVEZZIPYAECGmT2A00xZkY+9NiT/VbW4s+TqA+zRX8Z
   8P1f65k99szdYVgHnODy/mgpcSTslswrBPGGkir++fjctiIWqF8IftVjE
   na+cBdlLdFvtFTZiEdL71HRKmafpBPWzi9KY+ILCTo3ObutCuQfsHF9tc
   GrxWXkpp6IlmF0FA41ZgIaDDmgWtmXw0748n92WKTlSbmZuN51pno1qtL
   EH9HbIs7R9RdgxXtqHjpggB8Omo7s5+xs2MBjybFJIgimjhz/J0Z/sLJ4
   Gkh7moTCgnvy2u/9YTMA+QKAkYZHXQjvd6y1/8FSoNA3LV7RDsZgix3MX
   A==;
X-CSE-ConnectionGUID: X7PIcmNBS5yOfWjVWr4Fiw==
X-CSE-MsgGUID: fOnMLVBrTty5ni09RJBdmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="70521895"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="70521895"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:02:25 -0800
X-CSE-ConnectionGUID: M09Tw+SkSJ+XWWDBGuQA/A==
X-CSE-MsgGUID: /7BWfa//Qz6D6L3T2fGTfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="193714058"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:02:25 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:02:24 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 08:02:24 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.15) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:02:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TczLK5eOCHEDOoQkWajLJUjJ5HtVuu+qp7kImeh8L7mKeTtDAfnyVS5IynAGEP+lTZ/kAdJrW7MB/j372iMpjueRCHZd9rmzGaB1h1M7CtKUM0VJ+eWni7XtB8AdKrQT1v8WxulYtT2qJL6Iao5Fst+MCspApS8GTVl8brNr7q4e7B+qC4nZTzYm5Kxnkiwb9lfP/A5rmKx8Xw6n9W/4nOEVmPlrugbSfvZ6C5QymwGlM4mUs+Z9qwXdADnPcDnQnxfIUeh7pyUb0Qhf1gp/n4AQCsaFXCahtz4M0c1WnLaS8gLuMc/oTNGMqhCfVDcpL66+ReIBuK3WCovlK7GWbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D++8tWA+HjdMPuq6882JqnKY7ydp7mrZ3wGjZqnwjWY=;
 b=Png/o8XsxRP3L/I250jaM+MfvaQvqKSMCiXQQfvIkBWlecjaEKjebPTDK8V2WDwH12tX2r9u1qpuSNpmuOvR006LvhYhHv5Womgd4lbMg51H0LfByVidOA1LH1+6rZ2SSjBeWzBdMT9cdR/YOBUwcYAvALOC9leaQSTRMFLbscypS6L4ukK1Io3TtIMWLVGoFZ+UogJtldOlU5s6nSWlATkyKqwFoDuoUQ04U9eXoRs5zoh3udrtMB2Q70wpwM2zye4PPmgp6O/tfFH4WRzqPLa1srK4JLdTNlEQyHECZkjz5uGaATjHxOfSi5CzcsnShSr5vgDqgfR86yCTGNEOdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH0PR11MB5251.namprd11.prod.outlook.com (2603:10b6:610:e2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 16:02:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:02:22 +0000
Message-ID: <daca5dc2-56cf-40fb-85af-52d2155a6d37@intel.com>
Date: Tue, 2 Dec 2025 08:02:20 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 06/32] fs/resctrl: Split L3 dependent parts out of
 __mon_event_count()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-7-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251124185412.24155-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0332.namprd04.prod.outlook.com
 (2603:10b6:303:8a::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH0PR11MB5251:EE_
X-MS-Office365-Filtering-Correlation-Id: e4727d72-5483-44e4-6d9d-08de31bc2d9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dElFeW9ZYnpWZFFQeHJXOGpuQlh6cUNMaVJVMHoyaC9WWXdLcm15UmtDejFL?=
 =?utf-8?B?Z3UvdTViamtFemwwMWRGMXFDTjJoM240dHFwenFweUJsOHpiVHljeUdYb2Uy?=
 =?utf-8?B?QlJWbHNaZGdaL3RxK2JFSlJmZVN2MHJFeVRMTTZDVytGREsxZG5iUXRQRFl5?=
 =?utf-8?B?dW1YVHVkd2FrQU5iQTZjSFFHSEw5ZlVVL2dRbGFINHRPSmJVUVNqaldLcmJs?=
 =?utf-8?B?K1RCRGF3Y2ZPM2ZlcHB1Z2FLT3MwQWdDRlRid2lWQy9leGl4N3BIbjJYTFNP?=
 =?utf-8?B?NGJmK3phNDlramxoYitFaUZCTjJLRUEwR3NRZEE1a1NuSHZ0OFkxeUVDNFhj?=
 =?utf-8?B?Z0dyTERSRHZ6OFJQSmR1SklnRk15aWp3d1RuQTNqTkRSRDNqR1BwR2FKNUtz?=
 =?utf-8?B?YlpwcjBJVnJyWkNmSVVEL0lZQmtHbjEzZ1c1REFTSy80V1pZdDI1NE5nY3Uy?=
 =?utf-8?B?NWdBU1Y1OXlWbzhOOVYvencwa2F2dVpENEhFR0lkK09PVjJ5aGhyMXk2WDd2?=
 =?utf-8?B?cWhheUZVdUtFaHZPQkpUdTFHa0hKMXpCbkVmZEtWZmJuNXZ4QTgyWDJHUGZn?=
 =?utf-8?B?Tnp1dVA3VVR1UDlnZ0dCRVpLS2hMWFAwRGFKL3FES2ZOVWx4Z0sxUXJ2RnZz?=
 =?utf-8?B?SXlDRlhmUDBHSnAvSWlqaTc0aHExQStDQXc1VURSdXpldW5iVS91bUtlWE1E?=
 =?utf-8?B?a3c4Smh2anlrVy9Gc0tXRmUzenI5Y05JRmJlTzViQ2NETGZWMTUrVlRRaUhO?=
 =?utf-8?B?dTVKRXVzMTloNU83emZaNE9WU0tXdC94b05oKzFCU0x6RFRoOENzTys5R3dB?=
 =?utf-8?B?UmdrSUlZYy84N0lVRWt2U1pXNXV6UzRyc2k3Z2RoM0FFVEVOSWs1Z2dYWEd6?=
 =?utf-8?B?ckNlUVpaNUdXSXV0Q2VHQ05rLzdmK3hSbmlRSWk2Wi91NDhsbXBma3NBaE02?=
 =?utf-8?B?QUV3NEwrUWJPL1owRkRick1ncnd1T09jbGNHS2ZRUkdmVnlScW96TjhVRmE4?=
 =?utf-8?B?dzRlVVF1Y2NrdDk2bFhlMlhZZGx3V3piVDQ5SHpkVmllMUh5SDdoZ3FFcjRm?=
 =?utf-8?B?UzRGRmVDclpnbzV5M0lycWx1L3ptaTkwelF5bjZKZ3hCSGhQRzViRjV6YjBt?=
 =?utf-8?B?ZFBXUXA4d1YrT1pyZXNuOGhrdmxxWHhOWDlDQzlra21EeEJIUmpRNldWMHVw?=
 =?utf-8?B?N3hRNG00V1RSVVNnQ2k2REwyUDFSa1dRYVJxTnVrVFp4a2dZYnh1NmYxNm9I?=
 =?utf-8?B?NndXbDhRblgvWjljOFQ0TlB4WjhOU0IwY0RMVUVBSENBSGh0RCtDNW1EaTVD?=
 =?utf-8?B?Tkh6eWIwdjBmSUNyWS9BSjVXNG95b1NnelJxWE55UVhUNEJ6d2JUaGxFUGhV?=
 =?utf-8?B?M1dGZDZpdjk3WEVSeDBLamlOczdEMGhNSkN4d2xyTE1HYmMxa1lvanlIR0Z0?=
 =?utf-8?B?WVkybm40bW9ra0JPVEhyM0wvZklpNUVWaTVYaU1NMm1TOFd1T0graFRjcUhQ?=
 =?utf-8?B?MDE5SU01Zjl0MGhkVTg2QzhNeTRDYjJ5NnpLOWc1WkRtejFHZ1JLS1JjK3Vk?=
 =?utf-8?B?amRhMWxZc2htRGdaOGoyMk5uMG8rMmltRStoUHlXWTJwSXRxNnJIbkVuTTlG?=
 =?utf-8?B?S2M2amxUcmNaeU5FaXNUc0FsQllYaWZYcDloZU00KzFHSGR0M0JLd2dPK2hy?=
 =?utf-8?B?SlQ4aTNvZEoxTzdzS0I1R2RLMkU4TUdEcWRzdGZBckNNcHEraHhHQ3JLRjha?=
 =?utf-8?B?MzJSclFMdm9LdTlranlkZkJ4MVRCdm80bE0rUWR2ZzRnTE8zMTJYb0FEcFJp?=
 =?utf-8?B?c3pOc2NjNjJINldERUdlRXJzNjVmUTcxNEhaWnBYN3p4TG5NcE55eDR6NGY3?=
 =?utf-8?B?aE9VS1RJcXpuUHVDd2JGNUwxM1BTZlRRZ0ZobVo1L3IvYmxlSFJwY00xMTc3?=
 =?utf-8?Q?xdHr8+z4Nn7EH7+/5JfXjEFZKnoCyqxd?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dG90TkFzb3plMDZhNVBvRFY3M0pEUSs2NTZDZC84V1NOYlVFaEt1RWZDWDN6?=
 =?utf-8?B?NHpESGUrT2xDVEJjMDVQblQ2Z2lubGtWQUtiUTdSYWN5Tno2azNxQ0RETlFT?=
 =?utf-8?B?VzNlUTB3UmFBVmdOTDZKTW9NQTRZZ1FtODQyclFUUU81d0RGdHlRUUdpNDBz?=
 =?utf-8?B?THNXYzVzUEF4SzNDSnVpQjhEZm03clQyL01NeVR3a2h6dDJsRGZlWUZJMGt2?=
 =?utf-8?B?aFFuMFprd1AzTGhGRmZzS3kwU3BjaDJnSjNQc0xocmMzeU44VU41RUt2RFhJ?=
 =?utf-8?B?c3pYT0RHZUhYa3NJcTlGbVBuN0doMUVnUDdvTURmdytwWm5yTXVISHVTZkZQ?=
 =?utf-8?B?TXliYlNiZFg1djk0bzNHbWRtWHRXTm1tS0ZUeENoeXU5TEdIdE4xYUY2UjhY?=
 =?utf-8?B?eEpsazhyaDRPemVwZkhkZktNN1JSem9zUWExTEV5TTNYYXZXeXJKWHpWUVZr?=
 =?utf-8?B?SFk0MG5DYjZOQmhqdDlpSDQ0bXQwYnZzVzdaeDcyS3E5NUxuYnNQaFYyQzBP?=
 =?utf-8?B?R21FZ25FNHNXMDNoNWkveUFRdjB5QzNpdGNrZzFXbzlYYVE4QVVySUpPazhN?=
 =?utf-8?B?RjN0eW0rOHZrdWt3Umc0SlAvSFROT2VlSng3dFdLRlBEWVhxd1VyLy9ZZEtK?=
 =?utf-8?B?OTgwdDA0NGtOaUZESmZtVVNmODZUM3A1VVRxTjdvU3hvTjJ3YlFSUnRFaXdm?=
 =?utf-8?B?THkwZ2dmbnhRa21ic1gvSncvWHhHZUdBbmtpbnI2M3h0djNQdnF6c3U3N3V1?=
 =?utf-8?B?SUZGdHBhU2NhMHVWMTFKS212cjJJSkI0NXJ0T3pkYnptK2FjYkhndkJqbFhm?=
 =?utf-8?B?TG1LaXQyd3RTOC9XMDNSbGdnUmp4OVNxYlpsQXI1Z0NQVTVKZWNOM3BSRnVj?=
 =?utf-8?B?Q3dtVjlyVzVoellkMVpUK0V0cUdXZVpFMGtoODM0aWxqeHI2aUdLcWI1aVRv?=
 =?utf-8?B?VlQyOEhWblcrM2ZpS2trMHpvK1VoS0pXS3N4N3FKRGdibjZ0ZmtLbkx1Y042?=
 =?utf-8?B?MEJ6ZU43WmIvU1FnL1psZFp6OFlPU21kbnpnYVJYYThQY1p6Y01RSERLV0hh?=
 =?utf-8?B?WWJmYzg3elI3TURDTCtZdFluelZEZTJUZG9UZEpveGYwaU1oNURLRVVMLytX?=
 =?utf-8?B?a1pWUDRJR0lNaHd5SUIzbUpmWUdwdFVkeHFNeXZ0bHpUKzJlTHVnRjRSYTNY?=
 =?utf-8?B?cjRFZkFvTTlTd2d0RHBudDlIRGhiTnFhcEN6V2xRWlRUckx4SlRrQThIN1hz?=
 =?utf-8?B?THJKcmxiQWM3ZUlkbTRwS0c0MElGK09KS1Zobm9RYmhyVnlPZ2FyS1dvSHZw?=
 =?utf-8?B?U2tpc3dwLyttWUJQc1ZlUjh2NW5xK2Jnejl6b1ZlaSt5OXlUZjVWVlBLNUlX?=
 =?utf-8?B?ZXV0MzZibWxZK1pVN24zdkVUUmxINmlYL0VRem9wRUVMd3hTQVVhSG1rUGlv?=
 =?utf-8?B?K2ZhNVBsK2dESGVzNlhaWjFsZVI2SUFWTXBweXp6ZEk0N0IrcThRMG1qSjZh?=
 =?utf-8?B?UVFndE9VV2J1ZE9oYWxyUm1JVnpGUi9IR0J5M0lZMjlNRzhPbGU4cnBrT3p1?=
 =?utf-8?B?azdCdmVUZ0xMaUhudFpKb0VaQWVaUVU0bEkyVklsNEZmOUM5dDJFeTZma3o1?=
 =?utf-8?B?YTFJWFlRVnVZZFRYdGtzTWlqZGsvQXlHNjlnMVBCdUFsQWZvR2hkMEZQTFgr?=
 =?utf-8?B?cGJlSmZuY1NWK3lDd1FrVWdKNVhOS0xFSEVZa2I3N2o5N1V4cnBhRWlqT1lV?=
 =?utf-8?B?NS9sTTZjWWVDSFM5Yk1MSk5PalBibzUvVlREa0VqTFM0bTNLQU9lZmNEU05V?=
 =?utf-8?B?L1JTN0t6SHhRcUQ1ZUFUaGgxSUR3MVB1K3Y0WkI3bEIzVHM4VE5qYlQ5WjRM?=
 =?utf-8?B?aDNTMmpDWFhRZTA3WW5QSWo5eE5za1o5ei9RY2FvMzVUektVWWJoalovNURG?=
 =?utf-8?B?VSs3Mjd1Qy84WnJwZkZCU0p1YTdFSVpIL2M0ZXRtdXFVRllvanFhS0dsSDlh?=
 =?utf-8?B?K08zQ1ljZ3RjTEd4ZDJKUzk1eFhnQWtrVGs2SFFseXg4dVRkWStLcWpqeGdT?=
 =?utf-8?B?WEJLTzh5V0ZqOGwxeERZZHo2enNWZ0ExdzdUZmJNK0w5TU5lWElRdmE2VjJr?=
 =?utf-8?B?UFhwYkFTd0FkdStqUUxrS2tVZ2kxRWhuQndDNWRyMnhCbHUzOHp2OG9iem5B?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e4727d72-5483-44e4-6d9d-08de31bc2d9a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 16:02:22.4642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cZeJ0p1kkS8yaUqSPPYNJ7f9430eJg8epVu3D3hGRqMYZVcngDFEgV/CbACRNEE8QxmK4SkOINnaFVZiWgWVznUM5PB5zoRDt0nZC3pWzgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5251
X-OriginatorOrg: intel.com

Hi Tony,

On 11/24/25 10:53 AM, Tony Luck wrote:
> Carve out the L3 resource specific event reading code into a separate helper
> to support reading event data from a new monitoring resource.
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/monitor.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 572a9925bd6c..179962a81362 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -413,7 +413,7 @@ static void mbm_cntr_free(struct rdt_mon_domain *d, int cntr_id)
>  	memset(&d->cntr_cfg[cntr_id], 0, sizeof(*d->cntr_cfg));
>  }
>  
> -static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
> +static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  {
>  	int cpu = smp_processor_id();
>  	u32 closid = rdtgrp->closid;
> @@ -494,6 +494,18 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  	return ret;
>  }
>  
> +static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
> +{
> +	switch (rr->r->rid) {
> +	case RDT_RESOURCE_L3:
> +		return __l3_mon_event_count(rdtgrp, rr);
> +

unnecessary empty line

> +	default:
> +		rr->err = -EINVAL;
> +		return -EINVAL;
> +	}
> +}
> +
>  /*
>   * mbm_bw_count() - Update bw count from values previously read by
>   *		    __mon_event_count().

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
