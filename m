Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E103AA4EB
	for <patches@lists.linux.dev>; Mon,  7 Sep 2026 06:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788763360; cv=fail; b=usavNXVMTASs2uWfLI3zw+ecJRGPybY5zlqV5tgX0Biqb4F7ANPSiEzaKy4jLq14NzZTCVyS5ve70rCOiteu4oLU/pKxxAT08qg4HUx6T/zzLTGq+BPeKiJXwJH/DYJH4bL3e2hU7G8ZTDo1Jpx1+xHexWLMH0aRgzO+HhYEUhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788763360; c=relaxed/simple;
	bh=18Y2ipD9IKFs2sDA/lbW1/OUWtHN4+zI7QgpZzA6tE0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MGgNnisbaRAne6sexWF2DavJ0KfICbkF8a1giR4pKVh90AJ3d9ZU4S8Fhi32YEhBR6vhWS8OqvJJj9MJGTzs1ZWsQ8Feu8A3NW5dp0NXNMp6Lo3enJBreneBwfciaufOvKRz/kzby/7aUGw7oxzvhTVuFX+ZoyiZ1o3R+aXXGt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gJNwc54V; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gJNwc54V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788763358; x=1820299358;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=18Y2ipD9IKFs2sDA/lbW1/OUWtHN4+zI7QgpZzA6tE0=;
  b=gJNwc54VO0ANZjzFD1uEZYYEg0bga5k2tSSZoTAR88UqjqNVc6SiHWAf
   PVwq7mg/J9qJ86vu1ZjF89LSz9r9T+vXTEsa8ZhNGTcOfC9sq4bilieaj
   2Ep14VBliqQnTg4pP3HUiDBjgRlRz4EOwLpHFFRgt0/Qr1fH9gGz0bHjG
   5709/0/HJphA8PfshvVI6gRtoz94IhIhCGXvDNDVj1ZwA1KKa9a5RjG2d
   HQF6/SpC/ptwY+xADEGfLqyA0Ra1S67gPOOqdRkXaAVZrpo9MDqTnUZCX
   zLiUbRvXIGKrSnRNI6JEVQFm707Hyk/E18OEk6h8oVKK3n/mVIbhUFkLn
   A==;
X-CSE-ConnectionGUID: MpVnfvfMTcOq2ZYl42yKTg==
X-CSE-MsgGUID: u1S46G+NRAufUo0iyNDNjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11898"; a="92977015"
X-IronPort-AV: E=Sophos;i="6.25,266,1779174000"; 
   d="scan'208";a="92977015"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2026 23:42:38 -0700
X-CSE-ConnectionGUID: dcc9bb4aSUKfGiEaHQ0POg==
X-CSE-MsgGUID: vR8YBtqJRzuVR/NNYgmHJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,266,1779174000"; 
   d="scan'208";a="267378554"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2026 23:42:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sun, 6 Sep 2026 23:42:37 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Sun, 6 Sep 2026 23:42:37 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.43) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sun, 6 Sep 2026 23:42:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ajJcbmkXzqb/F5FU1cvI3BWPn1kocreLuMaKMlrtO+mA68wG3SoHZI7sPnkL/atItPPbDn2tQsVHkuaVpLnvb4YE4hPWhX6q0f+NLwRtxRGxAG4ffyoq3ST/eCHhWk4so9TJzdmHODxnCeWs25Ipdfk0jsJmrFFIFGPPpOf47X9NVSVH5POvbKl+KmMWyah9f0WCmVFOe7UYRHBX7n61ziCJ7JQIRUJiEggPzHQvhsYNF4unhKzL1bcweqQINrchwldmu4wsSl1V/UapkhjFxtLdh9ZwtJABtkCWAXNY39XLinNiK4dZHLbZcBxsXJZYNlcGcPqkO1Qq/Dutv/aJaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bB4adySnC1Dd0VoZN7+S+/GIhP0REykIM5mRqD/jIM8=;
 b=mHYyBLtTyH52zbxG6JwfKIQfo1P3YFOQ6aT30EPyJeDlKBJlKuht+j3fp/BnWh+Uh7mzmP4FX/uEN5SnckqccqKNmZNowIJty81Gqml5Zd0k0/LaiUbd3ZjRLtMxdAvln+gcBC1cL8d2sUJLcwyU7IZ74t0g2uiUdaNVafiBgrv/iXhiZQOp3Ofe2UI7MdOfS8KS9DA3rzIh7Vv4RqdeJYGyNNfVpEvo19penl3LL9AMI30MEG02ltnNX1E/hWaTCHjAXCJwSR/sm8F01BVKClJs7TKpWXHSINgq3xEqeLwS1wptpITmX4tABydmSo/5bwL1Ifgk1/O+T9nRTkkEaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by DSVPR11MB620494.namprd11.prod.outlook.com (2603:10b6:8:37c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 06:42:30 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::2c4e:e92a:4fa:a456]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::2c4e:e92a:4fa:a456%3]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 06:42:29 +0000
Message-ID: <c6a90e1e-371a-4905-9ecc-1784ad00aa03@intel.com>
Date: Mon, 7 Sep 2026 09:42:24 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 381/403] i3c: master: Fix potential UAF in
 i3c_device_uevent()
To: Sasha Levin <sashal@kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, Mukesh Savaliya
	<mukesh.savaliya@oss.qualcomm.com>, Frank Li <Frank.Li@nxp.com>, "Alexandre
 Belloni" <alexandre.belloni@bootlin.com>, Vegard Nossum
	<vegard.nossum@oracle.com>, Harshit Mogalapalli
	<harshit.m.mogalapalli@oracle.com>
References: <20260904045734.806166532@linuxfoundation.org>
 <20260904045743.458413377@linuxfoundation.org>
 <1a4a92b4-b87a-4654-8d73-05344415069f@oracle.com>
 <20260906181000.reply6-sasha@kernel.org>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <20260906181000.reply6-sasha@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0221.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b4::28) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|DSVPR11MB620494:EE_
X-MS-Office365-Filtering-Correlation-Id: 888a4d61-84d5-40a2-d10b-08df0cab2ff7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: BTWMKOjNUnSYxzEqB7usaObbSfju7IN3LnvNDkaLw34zNzn5H34aL/G+24Vmwu8EHMz5+4CSM8NzwkXIwghJi3S6v6I/pwcA20Y9cFsy9Ghz3JH7kjm3lpiIbATMBfPdxO2G/FLkqJs/fUPYoFXFJICnwobQyuYWiiScyuRtqp+u3xnNiPToq9Ng3OT8ASZjwtGvyGHlSbJu0pgJQzEj3WAXFDl6WdfUCQB3nHodDUJ84HNynAyZpl+RaWR0xzS1NMLf8Bpnddg6qauxSlFk/rCDofwEUKnynsCLXG2RIIMWEqisaCtM8wN3/y9rEjXu7NT1R3y9E1RS7K0WdWLgg1ArSfaEgVdKZ56VK2mTrAyr9XOE63S9MWUxyzmHt5OYKFhHpEanAZ/6MndPZL4DjUiNKC0na+qBFZkxGDqLhhZJtAaUJADJhL7090ZjhBzWLEUDM8N0ucy1Xjp1Pbo+EuZhXWn2wNi96UxJE9Do3LNJg7kdCo/98S22kS8xmb9vQrLvechoRU7I7CHoXGyhO8sZpPa933V5ZD/jG1pi/Kc1+Sk5OPbjw/U4ri4AmFKF8xykHBymZaGfj4x1cResVlS8cbSJLNRUNNyvMQG0p0ZV8lP4npuirg9r9dJxjSsUuy0hbqI9i0aMt1eY5gFGgM+x0VEi+zigWyyfL7ADrts=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEViUmU0WER4WFM4Q1NYN05QeXZCVXkwWFRqRUtFQWRna2JOTW1PYnVjQ2N3?=
 =?utf-8?B?WGhsVng5MnRMYXlsdkhiYm0ySjVCZ2h1Z2Z0RUsrcCt3RnpSa2hFTU0xc3Jv?=
 =?utf-8?B?QW0zNTN1Zy8vM2lDam9KMDduYk8yN2ozSGpVTTRSZG1aYSsrd0t3TWcxeC9t?=
 =?utf-8?B?Y29FUksxOGN5TjlCc2xtdkZWOFFaSDR3djEzd1VWVjVaajAzRXNScEpCaFVq?=
 =?utf-8?B?ZlRoak53Y254RWFZZmtJMkkxak9JRmN3bHBkV3NubkxTSk9FQ0dHOVNaZDlM?=
 =?utf-8?B?MkMzMXA1dGdSZ0tSOFpDd2RzMk1qS2w0aEhkQklkODY4NGpnbTRmTy80Y2Qz?=
 =?utf-8?B?M29ZdmdybFFQcllwZTQwaS91T1JOZURjYnNEY2NSMUoxRDh1ckNoaGRsb2tO?=
 =?utf-8?B?My9sLzlYeVlqZlNpNjFRc0NoZlRraHlsb0QyNEVQUVFRbmlSbll5dlpMWEZu?=
 =?utf-8?B?VmFkV0ZwS2tBWnEzNFN3VTNaS2xOWU5LTFNFcmI5a2RZdzI3NlR6UHBRVmdF?=
 =?utf-8?B?K2xRUjEzMUVmdTltVXZvU1B5bWlXY0FRN01aRW5NbGptdVA5aGtNT0VZUFYw?=
 =?utf-8?B?ckpYOU42eUhuUkNsaXlwdzRKeXdsOTZaTXRGb2FsMWVCV1MwTDczMktncGtT?=
 =?utf-8?B?U3ROdDI2MmV6VzV4ZWg1Ym5SNlptTmxHNENnZ3N6c29iSEtWZFRUYmxuTnVR?=
 =?utf-8?B?d2FQSWhLWGVzWTNXU2d6U3lzLzhFcEwwSCtGd3g3SFlIcTNBendUWWJrQVhH?=
 =?utf-8?B?L2dJNUlRVWFtMDJpSWljei9vV0dDMU1EVFI4ZC8xV1lXYXRmRmFrelpwbDJN?=
 =?utf-8?B?NC9pR3hVd1FHU2d1ZlIwaVdGVWRIcFpUU2pYcHZUYnQ1ODdzNEowMHpwajg2?=
 =?utf-8?B?ZGdTcG04M2NIVHJHVFJiR2ZyRzJYWmtpSjdkaVpBRDl2RW9ETThCNGR5MVRK?=
 =?utf-8?B?a1NJUTY0TnA4ZGhNWFB1ai80emNuZkRuMTF2UVpFOGU4Ymk0dGNNZ2xsVHFD?=
 =?utf-8?B?dEcyOG1PRmxtdUhVbU9nY2l0VVVSOUxXekcwWGRFaHY0SHNsMmUvZkUydC9G?=
 =?utf-8?B?SzNMS0VCRFNPM3daOWxtNHRNYUFJanNOTHl6NGNlMENaTnMxMy9aM1JVekFx?=
 =?utf-8?B?NEs5Tk5ITHI4V0NkSFRNbVN2UGVyS0NOaVRRYjF5alFZVkY1R0dxQ1NodHVE?=
 =?utf-8?B?N3p6RHRYbjJzeXlyLzZOcjdrVDg5RjcvekJWS1RkNjhObnNtWExpRlZQWU0w?=
 =?utf-8?B?aVdhNFdNV0c0eDBxOHFidS81Mi9mbTJvTzVxbXoxMlU2cWFUZTN4NWlxWS83?=
 =?utf-8?B?cmp4NVZNT2xrL0thU2kyUnpETUM3SllpeUh1TlRyWWJlb0toSmM5cDBhdU0x?=
 =?utf-8?B?MGhKQzI5Nm5CdTBRWTNHWGVUNWJzeXJiQjM5anI0My94OGZtbzFLMUtnZXJS?=
 =?utf-8?B?UHRwMXdUSHpNM2l5eUZNbDlHZmJVVXZZcFRhSjJ3Um9pVE51TGh4T2Y4Nlk5?=
 =?utf-8?B?dVJGOTk3YWxkMDFCRlp0YmtpYkVvVlRzT1NqYnJJRFZOTk9oRTRLOG9GcktL?=
 =?utf-8?B?bHlLbDNZWkxJQTBvbnZ4WGJGcE11aWpXM3dZM1MyZFc3UWZhUGN0N1VLSlpK?=
 =?utf-8?B?SjlvQ0VkU29jL1JLdzEyZ0pEcUdLTkVMd0tJWS9WM3JMVnV1NVhRcFlxREpq?=
 =?utf-8?B?RzdjUlVxQXUybTRGR210YjB3VDBxVHBtM2I5dnY0VWxGZnpmai9pTmxxUUwz?=
 =?utf-8?B?QUN4SWdVak5CWXZpVmZuM210dVFXTEozVVpBcVo5OWRVVlY3VmJGWlR0VUNt?=
 =?utf-8?B?RTB4NWQ5VTQzUllWb3dtbVdUa0FBSk1uc0orc0lQN0tEN3BXU2lURzF6c29o?=
 =?utf-8?B?SFY1ZUdacks3cTlZNGpYVjRzT3lsU3dNOFdHV244cmhsK3k3ZmRJcXRNRm80?=
 =?utf-8?B?NTdQSzMrT1RHdm1HSFVRNktTdjZrNFFReE5rcjdZb1dEYnpOUmpJcTlYelRt?=
 =?utf-8?B?cWRkUmQxSmttUWdXS0FtQVlvUDhCOWpSSXQ0UTAzQTFGRDY1MStwdzVjaVA2?=
 =?utf-8?B?bHRqVjNyUmpoYjQ1VlNJYThGNUo1QmxRak9DRlB2YWxpMm11UEhrQTk1SWNi?=
 =?utf-8?B?WTRLeldaa3Njc01ldnlvM2FOd0FCbVFNT1pOQ29pRk50VUR2YkFEMStnckhE?=
 =?utf-8?B?WmN3eURCUER0bWdpTmg3cktTYldEMjBTQnhQOVdwWEhkekJiV0hlZU0xcjJJ?=
 =?utf-8?B?dUludHFJdEp5ME5WNzJBMlJyK25kUVdvcmNZdVZMOUc4UXRkcEE4eWFkUHE0?=
 =?utf-8?B?WEwrOWpiZU16Sjl5dWdta2ZpWHI2aHl3ZTRXbW8yMnJaTkw1WE1UK3UxVW5m?=
 =?utf-8?Q?pNHqXGUyrXjez5HE=3D?=
X-Exchange-RoutingPolicyChecked: iBi9pCCalH/XMXqQ+R9i7XWqG+7VtgvD+7OudSrfvvY8m+Azbkpkd6FITvw7JeFJdfgZlxc3M7x6b1sHl+yhAQY9Cw2ViRVBWvEeDic3MP9+6kqjO/4esApPEnQNW6l/7JsUEhCUEkZeM2y8BlUcjwYu68Uyn7lHhCtubNPjs+nG0Yoej9b7GXFTJWLHtegn7aQTLAzs+g2h9u4I151Qa3vmMDkklQRDt+BZpght/apzfs8+rv32ihZwt8bc9A8UUvzv7Xnw/bqiczNPMFO7JT1mY+byZcIBIAIGgEwK5XIB6D4ZIusUViBxy41TFZYPdkq5GjIuzcdtoW8vHg8rCQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 888a4d61-84d5-40a2-d10b-08df0cab2ff7
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 06:42:29.6246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJf2vXBuDAbtkKIIDGlZmr8LcuDvnvbCia2dSjrDy5ertRDiWQDV3Vu+Yw7Z59pzCwfMRKKRCP/fYokREiFESw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB620494
X-OriginatorOrg: intel.com

On 06/09/2026 18:02, Sasha Levin wrote:
>> Upstream avoids this with prerequisite commit: 456f832e5fc2. Maybe we
>> should drop this patch without prerequisites.
> 
> Dropped from all seven queues. Upstream's own commit carries "Cc:
> stable@vger.kernel.org # requires \"i3c: master: Fix recursive locking
> during device registration\"" (456f832e5fc2), and that prerequisite
> isn't queued anywhere - so it needs to go until both land together.
> Thanks for catching it.
> 

AFAICT it was queued normally and is in Linus' tree:

	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=456f832e5fc26fbfd3b8200fd4553eee520cc377


