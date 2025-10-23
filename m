Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2FD1DC988
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 04:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761192925; cv=fail; b=tR3OtpaOLWfi/1cJtBgUf9RA3hoJkarILDjCDBjXjFJSHH7tO3hjtC6n+NyKGKCRBA3RnSkgTmteQwqkuczkIVdj+1jGG35x0sUSjWyrv9VfkKb5QT23ivu4SnwvDUgWWjyHt8ulvZPgI77XfYOy1wDNs/heKCWXIy58Ebxwey8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761192925; c=relaxed/simple;
	bh=Ar53t4TKMiA3tehXgroExVuZx5cL+fsAscDexoTnMxE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hK/yTXKqO6Zu5j3NXkAH5QwJrdeI0ws+QUnpQWKC9rQ2Olj1XKwc0yW/P/3pac0uAV1+K0eUY2yBe3yKDomTWrlnZG/EnJgrm3yWNEMrxUP5OhBZXqxpAY7rwaEru0qDDKp9DHZS++wCCeuRoHgv6H4Svc8Y5SIivLLdTPll4hQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kqHYeN89; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kqHYeN89"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761192923; x=1792728923;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ar53t4TKMiA3tehXgroExVuZx5cL+fsAscDexoTnMxE=;
  b=kqHYeN89Z4UbT/1j3eZFgU/8GCg+tnJaP/mS9CKkHbWqtnFlQYX+QQf2
   Xm3QQOhYY2Nu9sxWokhS2jEp+nGNrZQV8YTMqtCbU+ZwYAaxR1J0Obr8r
   29UeropbdGQTAFd0bDg1v/5+VZ7qlRCbJBpFKShVsp9Cvge4bWDx2jXL2
   nIU1izbOiD7XSSIfFHyFliJFqsd6a5DUIOe2rZ+KrucVlCF2BscQe9aRh
   238YaFpSWuEcCmuzwa0U15L2TIw2WdiHqpD2lZVU8uEqE0ufX9qbRe6WY
   EhM1f04hIpelitqseICNdATKajbd2TGnNhJj12Tc+7QhSqkVGxdj6stL8
   g==;
X-CSE-ConnectionGUID: i/g5seJ4SEK5Nwvv3l5l5Q==
X-CSE-MsgGUID: eQjfb5MvT4G9HQ+oxHl0hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="67217715"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="67217715"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:15:23 -0700
X-CSE-ConnectionGUID: kdTJJ+X/R6KxmFCbmJm3PQ==
X-CSE-MsgGUID: e8IIsGt5T8SCcqfgddRihw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="207710035"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:15:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:15:22 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 21:15:22 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.36) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:15:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rArRvlvum6let+h+j0AVmHndzfmqcpziPW6z+1PFjruJml8HtWWUqbGJsM1vTLh3olLcQAT/T8Jyeki/Pc4GjPVeuOIVRoJvFvqrvevhVD5g4LXJMQovAOs/TUxTpClniaUka2uLaSLkaiqWY0Alus6m+ct8IMUTjaHOeSI+RsFH/shpbasCmsn4+mHZyjQzMxceWYMEnYdVLEa+KXYdxS4IqqocB3fN8VpbX2fZrFU34SLwaT/frmk86M5opSKhy+zCrXu/iTpEzczu2ChTdVdNwFmtWO1gvT1GLR6iW9ruWpaYAI0cT7Smv6qoJOTklzujFH7Oeisi6WT4X206tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vVzVmucTAFxGYkqBMjx1SeYzjbLfWZMJOZ/eMPWe+t4=;
 b=sUzTAhwvDNuh650tzhKVg610MT7jA0h7mT5Q68T7I+8Ua1imA701+zF1FMdNu5RP3LpS726mlYK7lsuxXxngkN9nCn1afgoRBupvQ2id1QIvp6TliTBOEVvZnQV5k2/H2U2vJ3lAoTqWu0ebPdgQ3GF7dXTrWe4H5h8DrDKFE5/JXo77oKlVn/XP/TgR0CO0lLVHQUmiDoJADB/Q9rrQMnFluy0zgRcn4aZWxKtcCz7rMmExOdEAVlb4U4mR8Zhpb5ybVGqsfBRMOx94Ft83LQpMYkB7FzycFPanLKCSioFjgrV1XPR1dLOm5dCT0ldP7xHnvXlh+RC5CFwY9db1gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPF267298081.namprd11.prod.outlook.com (2603:10b6:f:fc02::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 04:15:19 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 04:15:19 +0000
Message-ID: <224b358c-17e6-4e5d-935c-7559663ddf7d@intel.com>
Date: Wed, 22 Oct 2025 21:15:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 05/31] x86,fs/resctrl: Refactor domain create/remove
 using struct rdt_domain_hdr
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-6-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20251013223348.103390-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0277.namprd03.prod.outlook.com
 (2603:10b6:303:b5::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPF267298081:EE_
X-MS-Office365-Filtering-Correlation-Id: 67f673cd-5c42-45f5-ae9d-08de11eac732
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dTducW11K0ZlSWF2V1JGMno2S3JuclpXT1NvQlB5L25XMi84UmptZWlza2Vt?=
 =?utf-8?B?aDdZTlVZaEw5aFBmMUx2MlRNbWk2NTBEbWVoOHhwWVdiNHNZajlHR2kvWnE5?=
 =?utf-8?B?V013citHQUVjWElrSC9UQnNyWWJkTmEwR05ycXpDaW44SWl2Z08vS0E3Syt4?=
 =?utf-8?B?aTFibE42V29jSmN4dHBTZHoycVVDcmhoS2lBTW1BbUNFMVBneDBIMGVqbElp?=
 =?utf-8?B?NDJMMXM1OHd6REg3RzlJMk5zaTAyZlBpTFkweXRNS1gxSk5zS1FhVXdwVHoz?=
 =?utf-8?B?RXE1UmhWc0RXS1ZIa05VN3ZaOFhNRTlrZWF4Znh3OForcktkU0xUWjg4aWZH?=
 =?utf-8?B?TkVhQTRySGZ2OFp6QndDNldhczBRU1R6YmJOWS9PdW83eGZIYm5vSUhCMDc0?=
 =?utf-8?B?TzRVTUJZWXh3K3ZsUjZsTzY2eEtHZE9oZEo5UlZMcjU1allqaG5ER2FCbXNz?=
 =?utf-8?B?emJzdWRRc0FXdGQra2t4dnArYUIxN2pLUDhIRzRQUGJ2RFI0dWlKR3dTVytx?=
 =?utf-8?B?RzhXd3VQajBxWU1FbG1iYnFDa0JKb2MweUdjQ0l4NXQyL3hmZXNpdEJRaXEw?=
 =?utf-8?B?b3lQS2EwWDBtQVQzck5lODAzTFF4VDZhcDVvNlRObjVBeXhGZXZ1N0M3V09Q?=
 =?utf-8?B?ZnJ6VlJmaXpickhLRmNsVExPZS9LdG53aUpoTCtTdVI5bTFTeXBHMGtzaHVX?=
 =?utf-8?B?WS9ON3lQc2l0Y1Y1dEhsS1V4VDdjZGEzY3Y1YlI3Z1cyNzZPeHRzcVRobk5z?=
 =?utf-8?B?eDk3RjR5OFYybzMrTWxoemZWZm94YkZ2RjRYK0FPcE5qMnE4Zk5yOXFzdzlR?=
 =?utf-8?B?em43T1hxSXdTcENSb0tjVjUwWThIWCtLaGlGdU1nSkk3ZXVMYkpXaTZBaGhu?=
 =?utf-8?B?czdqYXp0eTlrWkpZU1pIRzNzd1lJRWJZNUdRank0dERodXByTHN0Z3VvOHhk?=
 =?utf-8?B?aXdzR0EvaEJ4d2lISkVOTnNDbFZrL3lQSEs1TTVNQVVwNVFZc0ZBNnBNTWJU?=
 =?utf-8?B?MGJwRmJsRWVWcW9QbnF3STZFRXE0M1YrWVdPWHJWUFRXTTFJcUpBbnNhRkF2?=
 =?utf-8?B?bWJTZ3I4aWxmVlBYeUpnQVRyK1M0UkFkSEZKQjZSYk1YQ3BlT2Jzd20rOXl4?=
 =?utf-8?B?Q05jejllM1A3K0dtM1hQbDRMbkRkZ3lVRHBoci8rK1hFMjB1ekRESytuaHUz?=
 =?utf-8?B?c1dQd3l6Y2psTk9hK2Q1Ym80QTJqUlhrRUFaYm5qL29ZN0VNOTdEbnhWR2Fi?=
 =?utf-8?B?SlBjdTNibEFabUdPZGZpNFFDbDVFc3VSQW0zK2dmRG12cVhhYTJIenVOWmZv?=
 =?utf-8?B?MUZPbFlPL1QxYitUa2VMK3Z2UExNdzdJODJ2bzdZQ3Y2aXJPKzBsNzN0Uy9a?=
 =?utf-8?B?cVFhN2owOUxKNjRNclFqMVpqYTBiTit3MWFFdTVBZEEwMzYxbnVwTzhhTGE0?=
 =?utf-8?B?TWNWNHdBOFR2WDZyRGI3L1M3SVNBMkxRTDV1OCt5S2xDalUza2JFT2Y2VW9x?=
 =?utf-8?B?OUxsb3RTREZENTBzUGgvdTcvQktVbkdMdnduTGFEd2xTbE9wc1BFcXdTUVdZ?=
 =?utf-8?B?TzNkMnM1MnZPOEFBKzBPUGt5R3hDMTB3NC9zV0RhV05ndUM3SnhJamFHajlW?=
 =?utf-8?B?aEpTRm81ZlJIeTdRNUhuOUNTYW96UXRTaXlVOFBmeERVK25YdUEzNE5uRjAw?=
 =?utf-8?B?bk1nTUNDN21jTUczVmF1UU5vci9kSGNqenllMm9pVXBTQU9JSUpiMmFxT1Yv?=
 =?utf-8?B?ZE1oeFlZNGJkOVF3MHk4bjRYa3ZjOGRpZmxPZnRCSG1Ic0xtRFczRGZQUlVv?=
 =?utf-8?B?eVVoK2pyQndhQzlaSmUvKzA0bHM4Sjl6MTlyQWF3eG1qeVY5dHF1SEFvdEo0?=
 =?utf-8?B?c0h5UHdCVWlIcHJ3b0dRbDExUXRmMG1aSVVjckdFR0tRZkM3TVltcUFvdXRE?=
 =?utf-8?Q?HUMbCrYRkLxZkN7HsvdBNBmIxcuN7ZCQ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nld5TmFPT1R4cFkrL051R1NJR0hNckVGQ2RaS3RTZjBhSHRDc2Z5elM1QzRE?=
 =?utf-8?B?MjFTRlF6QVVPM1psK3grNGtBSWR5ZCtBb0pmSEpKZ1NDUW5CS1pYOG01R0Fr?=
 =?utf-8?B?c2xBenFmT2lFQlV1a0xtc2xmSzcyZGNKcDRHdHlNb2EwMzEvVWJJMmRqQnpk?=
 =?utf-8?B?UjFoUjA1Uk9oZWFaYm4wNGlzV0Rrc3EzSG8zYXJ1cTVxTzVIMm9WZEF5L2Z5?=
 =?utf-8?B?Y0lwd054Y25tVHFHcVFIUDdPMURRNVFTc2NzTWhBdDlHVFVQM1BDQUtnTE9T?=
 =?utf-8?B?TzNyZHNZWTVTV2pmekhVbW1jVktrR1NSUWIzZTdqR242UDBMaXJGNTArZ3o4?=
 =?utf-8?B?T0w4c01BMXVwSXFySVhQeTBvckh1UWlXbzBWT2VxUXczY3BjaUNEU1N6czEv?=
 =?utf-8?B?YmkvYUxSbEpTMGsxQW9NYlVyUmduNysxS3ZRanlHUDNVUDEwTWRPQXJmbUNn?=
 =?utf-8?B?VTJKL3cyMnowMjlvdDJ3ZlJDVlcwQ2dpNFprWUlQbkpHenVzdW8zYkF1WmlR?=
 =?utf-8?B?YUFlQ2NtSU5kNzhYZkwzdDkyemxKQndjV0R3cXJreE5nUkhMcGJaa2FWMUNF?=
 =?utf-8?B?Y3RvYmxhQ3NkbHpaajE1Zm9hbSt2UGJKbmtuakt1R3ZuQWJ3R1dZZUZ0aU5n?=
 =?utf-8?B?SWxwL2M3SUdRNVVlcThhRy8zeVNwYXlkYytRVFpCYTRIb1lvMkRpWHRyTTl3?=
 =?utf-8?B?M2NYSGxVUjV0dEhhcUQ2RER4d2VnSjh3bHhCQ3VLUXhMTG50TWZiejFlcWJy?=
 =?utf-8?B?cFBEb0xSR01DTDJHS0ZvdVJxOU50VXhEMXFDSy81RDByeDB3dzBlUmZ5c2M0?=
 =?utf-8?B?U0NnOTNud3FxSVp2ZXBXMWpjNWovblFkZ2c0RnRjYno2R2RPaUx3L2ZocTNN?=
 =?utf-8?B?RVFSOHkwVGttSEVUaFJHSFB2RUlSZExqRDBiMVNSbWZ4bWNsTU1vY1dxTmZO?=
 =?utf-8?B?cm9xZTVydEtaL3lPUTY1OXVEUWd0eGhxNDZkUXRod09nSnFMR2VZdUFTWllR?=
 =?utf-8?B?cEhZa0NlS0FtR29rQzBQdTdiNnV0U3EraG93UDJGWWg4YUg0QUZTbjhCNExq?=
 =?utf-8?B?dDAvajczbnVvbE5WUTZleDZiekQrbFFmdGdMWVUzTHM3MlhtTVlFbWRGQVlD?=
 =?utf-8?B?OWtCc1ZiOUx4YVRSU0lMTW5UaTlGYXhldnB2bWhuVmh2SkJITzFnTFhxemY0?=
 =?utf-8?B?WGZmSU50WWtMbmg4ZFYrOVJvTVMzMEluTks3Wkd5cXZ2QXdPUU5rMmN5MktD?=
 =?utf-8?B?dHIvODMvMVhtMXRQYXlGS0FiRWdZeXh6R2pGakxDalFoUktmSzhLUzZHN1Y2?=
 =?utf-8?B?RSt5M29kZmhNMk9Sam5ZcGNGMndQQkRiQUFZU1BHSEZ5aE5CSnp0dXRjaEJI?=
 =?utf-8?B?WTVaRlBrbXZFK1NZU01IVlpVZDJabWdiNURTQXJFN1BWblNTMWJXU044dmJh?=
 =?utf-8?B?MW51dThjazl0MHlyOFBUbG5jVE1hUFRlc0s3NFpiYjNXdE5Cb0tDZHdMblhZ?=
 =?utf-8?B?OHhrekZPcnNLTmQ1RytuRjF0TjZmZWEydXFmeGMvVzBvQTMxMjl1WnBSaDJv?=
 =?utf-8?B?VHNrUFRnWHFOMENwU0x0Q3N2L3lXMUY4bVNsa3dvaG1uQnBZUnVjbUFTT08v?=
 =?utf-8?B?QStESGZ2bEV4SXdRM3NyWFpXbTZMY045YnpUTEMyVmRNRnVOWkpEcWU5M0Fq?=
 =?utf-8?B?WDlJRlhTOEFWSWFGcXU1VmJ5cUxFNWxvOWM0WW1nYXozb216V1ZZekJPYjV2?=
 =?utf-8?B?UGtsYUsrWml0SVhxajJSci9vQVNFR2FibFA5eTZqYW5aRDJxZTdLQzNCTklT?=
 =?utf-8?B?Y0JLZ21jcGYyOUFsMmMvbUJRMzNZRWNwTXZVRWRZbU1Jc2w1NkpBYU1ERXZp?=
 =?utf-8?B?aDJSdWVMMUduUVRwVCtVNmRtTXRJa1RDRXNLK28vYmsrM1ZBNjNkczQwOW1T?=
 =?utf-8?B?dWFibmFkcC9wYkl3c0duVUZSbGI1cDJmZEFaN0lEUFk4aUxKaVNydWxRYXNK?=
 =?utf-8?B?UGt5UnpyRG1NVWxTQ2xlaW5IT0NYRXAwVDF0ZG1WR1E1TUZCOEF2cUJrNWxt?=
 =?utf-8?B?Q1FpdWh3QVN5QkFTN1dXVWNwcmZJR1plS1hzazdHK0hudzBueXVjZnpHU2ZS?=
 =?utf-8?B?THc4S3plOGFpQk5LaHdLd01yZFA0TFhMK204Sll4V1UyL0k2VVcrT2E4bnBV?=
 =?utf-8?B?dmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 67f673cd-5c42-45f5-ae9d-08de11eac732
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 04:15:19.6583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u94EtxUIQMSNTLYVOvWZ6ChvLb1gqn+tbs+8cD/xkJVPKBM2zWdj0CdX93L3tPyeSOOdeCwZBuYEeQDJi6hUvqDZFnSE6J7AXINmVC/BK20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF267298081
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> Up until now, all monitoring events were associated with the L3 resource and it
> made sense to use the L3 specific "struct rdt_mon_domain *" argument to functions
> operating on domains.
> 
> Telemetry events will be tied to a new resource with its instances represented
> by a new domain structure that, just like struct rdt_mon_domain, starts with
> the generic struct rdt_domain_hdr.
> 
> Prepare to support domains belonging to different resources by changing the
> calling convention of functions operating on domains.  Pass the generic header
> and use that to find the domain specific structure where needed.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index f248eaf50d3c..8c07a9810706 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -547,11 +547,18 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
>  }
>  
>  void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
> -		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
> +		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
>  		    cpumask_t *cpumask, int evtid, int first)
>  {
> +	struct rdt_mon_domain *d = NULL;
>  	int cpu;
>  
> +	if (hdr) {
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +			return;
> +		d = container_of(hdr, struct rdt_mon_domain, hdr);
> +	}
> +
>  	/* When picking a CPU from cpu_mask, ensure it can't race with cpuhp */
>  	lockdep_assert_cpus_held();
>  

Please keep lockdep_assert_cpus_held() at beginning of the function.

> @@ -598,7 +605,6 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  	enum resctrl_event_id evtid;
>  	struct rdt_domain_hdr *hdr;
>  	struct rmid_read rr = {0};
> -	struct rdt_mon_domain *d;
>  	struct rdtgroup *rdtgrp;
>  	int domid, cpu, ret = 0;
>  	struct rdt_resource *r;
> @@ -623,6 +629,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  	r = resctrl_arch_get_resource(resid);
>  
>  	if (md->sum) {
> +		struct rdt_mon_domain *d;
> +
>  		/*
>  		 * This file requires summing across all domains that share
>  		 * the L3 cache id that was provided in the "domid" field of the

This hunk is unlike any other in this patch. To me the pattern of changes found in this
patch is that functions modified used to obtain struct rdt_mon_domain as parameter and
after this change these functions obtain struct rdt_domain_hdr as parameter and need to
use the container_of() to obtain the needed struct rdt_mon_domain. This hunk stands out
in that it just blindly assumes that the domain obtained by traversing rdt_resource::mon_domains
is an L3 domain.

How is this hunk relevant to this patch? 

From what I can tell the above two hunks need to be separated into a new patch and merged
with the unrelated changes added to patch #13 after it was reviewed.

Reinette
