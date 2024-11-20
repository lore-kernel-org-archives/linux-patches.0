Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FF220B22
	for <patches@lists.linux.dev>; Wed, 20 Nov 2024 04:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732075438; cv=fail; b=Z+BdyRtIRz7g2y6Sh86Gow3WbUyeSxIJBrWrklz2t+vhJPXnZTDFU1IGJIED4YGB+qOTIb3AO1CZhdsAzmJW9tRQhHmdRkOPXImm6bJQmcC8TTu+ZSJCLY2ZtHNr/38pWGALASRql8ZBkfbPDFuf9RLxveiZ9+fy6yVpjB44kck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732075438; c=relaxed/simple;
	bh=xaR/w+V+Jy2k+2QgsjksyiPcfXVbsDUe/aG2AbTnS/0=;
	h=Message-ID:Date:From:Subject:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E2VDxpwBeJQ85bijIz7HepotsalM87mH2zjH7awftBVyXFwNHSNrPOl8hXlw0qArfTtwlUz85vY+orkj0LiRKSR+YXXj8A3kN88pzcLaUeTtsJoVd8zq4/Nx+CX7Xy7PM95JEAWCqkiKzcenZNo91q33Z0TqdQZ6krTIQrVlxzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c9PHkZOC; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c9PHkZOC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732075436; x=1763611436;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xaR/w+V+Jy2k+2QgsjksyiPcfXVbsDUe/aG2AbTnS/0=;
  b=c9PHkZOCZq3rZ8IPYGAkypKr7exuCwZwchTZdTMIYBiHEN6SrIzQ6wdy
   7ct7lJBo0FOFKlcCMeLUd4bRBBE9UlaktVYp2FvbWMco/rIfD3FPa1nj0
   2JHPvU0iT52WOKBnaoJDPmc+IL+5lzTPA/8UfMAEcxuYDRjUedBtZ/itn
   lezimVe8s5en8651aqaYDoV0PzyYajIfjHYC+aSTuFpNLIbxu2oJQVvAJ
   0BChkm3Lo8IZhtZxPPHI0V50yKdKpJSvrVUSJFQR4nDd57tmCKnTV5QmS
   MbEas1VBONK0weSNxHwpSq9cviHispPQiV2fZAZLpWv+Q/GoXdDfD4h5C
   Q==;
X-CSE-ConnectionGUID: HIov1hscSq6k5OOhg94utQ==
X-CSE-MsgGUID: RhfGUpQqRrGNoOQsU5lH4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="43496608"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="43496608"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 20:03:55 -0800
X-CSE-ConnectionGUID: rO54U7E3Re2iOWRuCGMhRQ==
X-CSE-MsgGUID: NAzZo30tQVyukkIwu9rnoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="113059156"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Nov 2024 20:03:55 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 19 Nov 2024 20:03:51 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 19 Nov 2024 20:03:51 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 19 Nov 2024 20:03:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GAo+GeABsS4dCyczLVfZB2cVbr7zNIbPDjFLk0F+gaCeX+IJNN9aXykPB7942f3LjZrrtQvPdnc66jgkpH3P6kgR0h6ZELrlpt6OGKttLo8nFQbpMBg1sXsN05Saybn9u3zOPEN9zDIY6Y+b4nlbMxcpENKcH/heaYuZMKPJH+CIAMXWxUb0riJdPz0dorukpmrN95bT2rWdrjivprgeUa9w0tHMMVCNsWTBtzl4MmHUi2V8LaYbNl3XeLgiMfk0C1nUZzGmklGYnMofj7jhT22iOKScVHB57HTxMl7t3+GM1uLWT1D74ombVDwrnb6mNXnKURIpDxxP/5s1vGrgWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hT+Veuyne5V/7h0y+VRjRY66Xq+zgfoH0kHo8cQo1fQ=;
 b=dyM7Pmr4SYDyt7KaQeftZ0/X0/BnvaQk5ej+jcytpcGVO0xXtHJCigd6Vilt+PidC96oVDqulGm26fWl/0w8Pb7Yrec7m2ZjeqX4c8IRlWlYR+nBFbz25LDJe5ySqmDXFf8vTUKz2unXOgh21+fOQj/xPrCZmuoUglQQ5rcpDEmcd3qL2oui8DGdOg2sgshxnW+XEzvo/8fTU/ZanQBCq/GHcLKFquzuUXXaiCwtZIYCVrLeMBHyTDN9UyFFA0mHu/Ns1bghb3+CItQoCOtPJkzlIm+6l69s3jesvD/UKP6jlxHv0FQxHVciBLmmiKLGVvbhEzCuxBwoJ0wgZVu+eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB5880.namprd11.prod.outlook.com (2603:10b6:510:143::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.21; Wed, 20 Nov
 2024 04:03:08 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8158.019; Wed, 20 Nov 2024
 04:03:08 +0000
Message-ID: <4796ded1-a988-4038-bdbb-fc9a93da0c55@intel.com>
Date: Tue, 19 Nov 2024 20:03:06 -0800
User-Agent: Mozilla Thunderbird
From: Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH v9 6/9] x86/resctrl: Add "mba_MBps_event" file to ctrl_mon
 directories
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-7-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20241114001712.80315-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0357.namprd03.prod.outlook.com
 (2603:10b6:303:dc::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB5880:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c7321c7-9490-491e-f70a-08dd09183e05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NHJUVlBWM1BPbk0xcDhRd1ZBV1RiYlJaZ3JPM0RVZ2p5aUlGK2JiL2lra3JK?=
 =?utf-8?B?UGNvT01qZTlqT2tqL3FEYXhYUFE3bjdGdk1uYW9sQzhBNnJFcWFEaWZYWnhh?=
 =?utf-8?B?TStKdlp4MDIrc3Y3WGNKMEVIdHYwdVZsd0VKWnRncldPMzhlaytzc01ndjJO?=
 =?utf-8?B?TzI1YW5yeWlVTjJ4VUwzVDNpR0s4cGdYQ2hPSEVXNk1WMGhGQkZ1WVovTjBY?=
 =?utf-8?B?NVArSHpiY1dZazJLY0FIOUpzaWY0eWVMN2V5S0c2VkdPcWFHMmd1TFZqS1hN?=
 =?utf-8?B?cUVtRFprLzZlam5FR1NWelhPckwzQWZHbHNzcnMxQ0tNRGNZWGk5Z0RCYk0r?=
 =?utf-8?B?Q2dtUDRYWTQwUTQwU2paZUR1SmxQaFlHWGlNV3NnYzJUQWV2a1g5bjczaFpr?=
 =?utf-8?B?RHFiTXZTZWtNNndYMXNkRVowc3dPQmNIcm1XeC9lNFFwTExBWHlvcFc5NU45?=
 =?utf-8?B?cUYvT0UxZFN5ckdaUi9NbGw1TWdQQWFZcjlNem82S3ljdUpBNVpvK2t6QWRS?=
 =?utf-8?B?WkdJMVFkZDhXcXMvUHUrajFBQ21TYU0velJBWTVwcFhac1gxZXJPZVpHeFhx?=
 =?utf-8?B?cFpEekFPZHl5SmNEbTlXSytFVFNyOU0xTHpEalpudGhsU2ppSTlDYm1pOHNw?=
 =?utf-8?B?SU55eHJ0SmowbHBWaDdHRTRVNHI4bW9XZ0pJWjNlWUdabHZyaUxtejFNbWZP?=
 =?utf-8?B?U1FVMk51akVSemM1MUp2elIzeHg3eWZidjl0a244cWJKTW91Vi9pMUhvS0RG?=
 =?utf-8?B?eS9kL3ZiakV5c0l3YTExTXRuc2lRK05nNU1NekpERXRLejUzVkhLV1FBNFkw?=
 =?utf-8?B?UEp4RTk2YzBwVTUxR3VtblVGQmpKcnV3MTlmczFEaUI3S0ZneXJFeEhJUHZ3?=
 =?utf-8?B?UE9mVlk1TmZ2WG4zenBhY08rWUdUR0VFaUw3Y3ExNVFFcEdFUDlVaXBZTDdF?=
 =?utf-8?B?RzBvbCtZTHNkNHlnSmwwR1diZW45YkJFdDk5WmloTEt6UDdUWXBZUFFlT0Zm?=
 =?utf-8?B?RXBkenN2cHcreUNnam5Ic1JCYjRka0JtQ1RCbWV4ellRSDBkZmNiclpnbm1L?=
 =?utf-8?B?Z2srbnhRN1lVWkJncW9VOU9PUjM4bVZqNElWajlpRzVGUHBLS20yajJFdjgx?=
 =?utf-8?B?VnVSZDJmMTd6eEdYajg3djZURmQ0T0hBa05xOUl3U2dtK0VrVHFFNHNxNUpt?=
 =?utf-8?B?KzVWMlpGb3plTHdXTDZtbEJYOVRqdmhJbW9lRWZLVnNCSzh6dVdNbHFSbzQ1?=
 =?utf-8?B?YjZOcWpoNUVQek9yK3dybnZUN0QxUGMzZ2JGR3dKYi9DZUJDRjBhbXN3U0xW?=
 =?utf-8?B?eDUweWVjajkrZ0UrWUJUbm9BeitpMzRnRkZzbE40b1pjVDI3ckVqREltaGxT?=
 =?utf-8?B?QVFkUTVrZzkzWmxlT2RCNThxNHFIa2lEMmYxVEUwMS9kbUpMdUduQUx0dkVy?=
 =?utf-8?B?dkRsWDF3N2Z5NXNnOVdhVFJUU2xSVU5pNWNlZXp0bXJOaUhUYWxrbGhuc2NN?=
 =?utf-8?B?QVNJTTZESDgyTjkzbG9rWEhBRy9iRXBOM21pTTdmRkY4ZHVPUmpPc053V0Zs?=
 =?utf-8?B?NU0zQ3FKT3EwS2MrTkptMGhxdm5UdWRWbEF4MW5mNWZVNjVRWnZFZnhYWVZF?=
 =?utf-8?B?VVdkcTBrOWtNLzFoZmNVbkdLaEF0WTVJaHYrRUg2dDM5RVBxREJXcmdsT1ow?=
 =?utf-8?B?eHhhQkIyTWVNd2NLREc2UytSYTRKYUZxQTVUQ2gwUEc4VGtxM3RGWko0R2Rn?=
 =?utf-8?Q?ZOKX+8Ramsz6LGPxA4K9sN2fvsgiwlZ8KJ4GYXw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enhBaVRSSzg5RFdXdW1rM3Y0L3dBcWtpT0V0cVIzSHF4VGU0elFHbG1HM0tE?=
 =?utf-8?B?KzhYRjAwUWRNL0FhcTNKMzd0UjI2Q3Y5ZlcwV0w4UlFCN0dJNnQ3WkdsRCtR?=
 =?utf-8?B?dFRiWmdmb1h1Qk83ZHRGNkY0N280S0Q1YTRVSnZXRWhCZGY1eTJJWkF6NzJl?=
 =?utf-8?B?bEJyK0svZHlZamJRL2ZnSDZqclJxYXVTbm0wV1ZZcFF0ejdyeXhxbTh2UkpW?=
 =?utf-8?B?ZVZRZEZzbGxIbmJqcVpLL0VDeXlvOWNNOWFyV1Y3WlB1Smh0THlrMGYzM0xV?=
 =?utf-8?B?cHNWTUNEb0VoWWduazVDYStTQ3RPMVBDeGw5M2s3K1ZQb1JhVDAyTm9pVDJ2?=
 =?utf-8?B?bTBwSXFZZGlpemJSeDRKVlpGdzdqU1hScXJrV0pJWlNaYUNMR2t2TGZ3SGxW?=
 =?utf-8?B?YzNjUWxWcFBzVUZZVkpLZTQzY2VleU55SjRnUTcwZ0RMdjAzaGdjb0xZWjkr?=
 =?utf-8?B?Q1k4dHNtMGJ1Y2dwNFh4ZUVwMFZVbUZZdXlaajdxTFZ4Wng4WTBxYUtqNVZh?=
 =?utf-8?B?MGFnbUdMOEM4aGl0cXpjaU1FWjRZeXdVcTEzRVlWcnJBbVBjTXdRc3RFUVN2?=
 =?utf-8?B?ZlcwVTB5SzdqRjBzcG1NV0s1Z0VwaUhaSEp3RGZ2RlFYbWJldUhoTkEyOWFz?=
 =?utf-8?B?WnpMdGJKM1Q3ZU5hbUZOWCtzTXVjODBWeW0vcnUyTmhZTDBIT0VDVWFSZHYz?=
 =?utf-8?B?ZGxmMmJxRW54bEJzbFE1NnhXbTAxeVllSmlydFRNR3RMWlNCc2lkNkxRODJu?=
 =?utf-8?B?L0NhSk45cVRiSlUvUExDYUR4TmI5Y1o5N0tFNnFTZVlsbU53S24zdkM5Szh1?=
 =?utf-8?B?NzJ3OWFaYmR4MndNSVRpdW4xV1Nsa0JUU0t6d3A3dEFsNC84ZHNxbDJiUVUy?=
 =?utf-8?B?VmlsOEJqaVY5VGt6ZG84dGZFbFFFa1c0VFNpS2lnbEFUUk1jWlI4SXJVN1ho?=
 =?utf-8?B?YVIxc0FZcTU1Y1ZtN1g4bXNUMXRvUW9ndFRvdHVZQ0M3Q1owZy9sQm5MdmFC?=
 =?utf-8?B?U2Z4dy9BczRUSm4rYXlBbjJNL1B2RFlYdklBQ2ZTYy9VcHFmR2lsdVNZTTNL?=
 =?utf-8?B?QWk3dnNPRElVM0pFVHpFT3dPdnJwVTlueXZqb0VuRFB4NzhyWVpPemRyNmRw?=
 =?utf-8?B?V0hhdUpBK05nVGdGbVFjWlFGZGpaTi9ERXlRKzQ4MURoUURqaTVuSTlobEpI?=
 =?utf-8?B?UzEzcUNLZEY5R3UrYzlKQ1EwQzRIOFB0VitTOWFBbEtIQURUSUtnWnNZUHhL?=
 =?utf-8?B?cDhCU0RXVHh1YzhHYU5teVByMFpMRGU1RkRHYk8rTDhCT0FaOUJIVnFyN1Ev?=
 =?utf-8?B?N0VncUlhVkw1Z1h6eml5Zy95NGZCdmJ4V29YdFJtWEk5Rit0bXJKZG5xcktE?=
 =?utf-8?B?VENVdGd4RG55RjlDck1tUVpVOTBnUDdIN3hhMy9iMHpaa29SZ3A5MjNNVXdD?=
 =?utf-8?B?cEp3QytGS1hKZHUxVXBZMFZ1YUtvQUVJM2JhaGcveS9XdFdqUkxINzltazVj?=
 =?utf-8?B?M3I4ZzI0S1NFVjQxWGk0Q3NuSjNGa0tIencxdEpOWVp6NXdLUUNwMVd2THJm?=
 =?utf-8?B?WUJ3MG02OVRRZEEwQWRDc0pWREhzTGRqeVZMbGZyVHJPZUtHUWJmMTRnUWox?=
 =?utf-8?B?enc5eUR4WGtyVkUxbExnYjlTOEtXYVlRaUZZR2pFcnJTUGpVbW1id3BJc05H?=
 =?utf-8?B?Y2ljMjBzRWkzZHpVallnSU9YSnVCU3Y4VE5oenNTSFc3MVlwTFBsR0hrNFg3?=
 =?utf-8?B?WUt1a00xUytPUEl6R3YyTFNQSUJQQ2FzbFlaZW12WnZNYXR6TFBuQW04eUJw?=
 =?utf-8?B?VHluMC9QYjNGT1VkblpDVjhuWmlQenc1czBwVktCZGh5eFRSQlBpUWtiM3k5?=
 =?utf-8?B?Z0t0RHBtKzF6eDZOWEk1TDFoUFMxWnB1UnE4VG16RHNOUDdkdFJ0VURjem0z?=
 =?utf-8?B?TlBDdUdLMkIxcnBnYUhyNEcvL241cVNXd2ZaSFVYSG1rdE80ekY5d1N6anBo?=
 =?utf-8?B?U3JHRStKYjFOT1JmL1JLdzRrM1pEMm02UTBKUVhlckI0WWFjL1I4dlMwY1Zt?=
 =?utf-8?B?N3JXREZ2d1N3K21rWGdYMWdxSzVIMVppM1BGeGJFZmx2dlIwakVDbGxQTEFY?=
 =?utf-8?B?MHZzdXh6THVPckNBS2Qvc3Z4eS9LelNWa2hPQkNzSHoxbHF5UFdqQ0xDUFNC?=
 =?utf-8?B?eXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c7321c7-9490-491e-f70a-08dd09183e05
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2024 04:03:08.2193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +1wJNErdcLykT64knoFla4foy3Ew2v5NfjSyzca2+KsyAElukcwJIEq8x6xRgVF9RYcMQPTl+XzyOwm1q6N/W7IIEMXLgpQrSwbp24thRQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5880
X-OriginatorOrg: intel.com

Hi Tony,

On 11/13/24 4:17 PM, Tony Luck wrote:
> The "mba_MBps" mount option provides an alternate method to
> control memory bandwidth. Instead of specifying allowable
> bandwidth as a percentage of maximum possible, the user
> provides a MiB/s limit value.
> 
> Historically the limit was enforced by a feedback loop from

"Historically the limit was enforced" no history needed since
this is still the case at the time of this patch.

> the measure local bandwidth to adjust the memory bandwidth
> allocation controls.

I am not sure what is meant by "a feedback loop from the measure
local bandwidth" (that was copy&pasted to next patch).

> 
> In preparation to allow the user to pick the memory bandwidth
> monitoring event used as input to the feedback loop, provide
> a file in each ctrl_mon group directory that shows the event

In the documentation the custom is to use CTRL_MON.

> currently in use.

Much better changelog. I think it will help to add a snippet that
mentions the file is only visible to user space if resctrl
was mounted with mba_MBps, and thus only visible when mba_sc is
enabled, and thus reinforcing that this maintains the contract
that rdtgrp->mba_mbps_event is only accessed when mba_sc is enabled.

> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette
