Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFED2288C6
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 04:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761192474; cv=fail; b=lmZujObfTZGAqP1APDQP81W4Q3zqkCu//UuJp0l9P8qHgBJI5J0/3bqlNi+xMhZ1u+nKUM6Ojanq5Rygc0359KPlFHtewhInLhmSMhhBn+njLJfy6WtiNoh6reWcLXz/r69FpWz3es1NkDj/Dg+ZfiQA1aRSWNJ3viFf0CgO5VY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761192474; c=relaxed/simple;
	bh=/1Qxq97Y/jzgAMdBASf65HDhFYhTtdBvITCWRcTESsw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qqnvkEBB69zAeSbatqa69p8xPEQnPpUuPkVuG5EtdLvpE6V7CL22WbkV5ckDce3vGJUWKuY8ThMguAcW65cBhEGozJIWbcuoZDpwxTjar6IAyHu4B1Ajf0RECnZwWWSU0yZ5Q+N1aMl97IsR6R8RiXMKD4+pk4wPl2FjwZp6j0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a210k8vN; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a210k8vN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761192473; x=1792728473;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/1Qxq97Y/jzgAMdBASf65HDhFYhTtdBvITCWRcTESsw=;
  b=a210k8vNl+rfBbbeIsvjl2Fd+42zvjthQ2LXewOce8dOPoEo+dQOQapq
   rDiGLg8QHGvZPzFC0+kzz0fKWRp7H47g6G2OFro27H1TeeQ518RWpv4m6
   4kHV6nY7UJ1VcQyzVE7zJb0b19+CceBQWBODDQyf+5dcfK8qOPYh9mnpf
   ac/Axly/JTDfAp4efItZ1Omdck3vNIARpkGYlet3fYzpQF5pGw6an9/mH
   uIIMLrXnoYs6Ihjf7BWn0/L9CGP83J2Z6yR+kFPjtX5+W3+5cq+QOgCOb
   xWIS8jS5Ynx5HMaNn5BPc8UrCJcyGBq5TooDqimlY6veELPrr7gNsMfSw
   w==;
X-CSE-ConnectionGUID: UyURfgbkTz6Yz/X0FBxAPQ==
X-CSE-MsgGUID: wxdRgu7eR5ykmlLkqMbUcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63055429"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="63055429"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:07:52 -0700
X-CSE-ConnectionGUID: 30HzqalzTNirdt//RX9tnA==
X-CSE-MsgGUID: YlpZ5byUSQOb23UMjJxTuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="214700180"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:07:50 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:07:49 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 21:07:49 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.50) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:07:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ihr/7VGCGAE/czcygz/PHqEqPtQa4RjgTeMA5d6w1UW77TtsEl3NkdQ1VAG40gn5QcAJKZ6vV9ldkhlgMDIZw/oQQDMu589CLtx6+myKGYDm6ppzZGgf7AKIaEjFXpoHFrdgwHpjBFCSyaT2YVbALrpPunvxp0Y1XQdKas8zMqQ3wIsvjJdsw50HQD3pBH5ATouuW5qgCSoouYt4kzRml95DtWq7g0Fmizmqp3kjwds0cUJCvhtqYNz37vF++QW7h0IPpsm9TSGOU5DzaQXSkVdu8ycVaeMSaU84XSnd2HCjajegYddC/FflMZKlbkTVnUtYYDyAm08JRwIMTqnlbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TPBXN8XlyoXvPdH2Ebxy7o9et4Rev4WMxsB3GhYIk5Y=;
 b=pEcyHh/+qB7pzzgjG7suSrOw9hVnPFP7Hw8Wy5suJy1uqykR2kJxjEJ2DVSh8wZDw4PkfgYTE2AUbOcBVZ2VS3OD7Jd5iR/3JpOh34MXvU5D9uu+R83RuC/e2hZk1azh+HTnCw7Es9brJVci2SupCEbL8dmbELGG1hdvBvi0A/Nsm8Ra9sHIjNyDRCiItGkFPgc+azRQxEjLcBN4utbxQ1NKOxeM/8u0sHmoWZPHTEihZSXKxOnl0RSa9EuFl5HjQxJ27cJkGn6QYm9AMYO6tFo6u282aA7BHWdSby/6Rh5FxdntsAts3GMrCAcRLt5tZOZa7jvhdR/jUlPe85pIGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPF267298081.namprd11.prod.outlook.com (2603:10b6:f:fc02::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 04:07:47 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 04:07:46 +0000
Message-ID: <02057050-c280-43df-8965-73555fb3c41a@intel.com>
Date: Wed, 22 Oct 2025 21:07:44 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 01/31] x86,fs/resctrl: Improve domain type checking
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-2-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0346.namprd03.prod.outlook.com
 (2603:10b6:303:dc::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPF267298081:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cfe34a4-d447-45d5-c93a-08de11e9b90e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aStWRk9IeG1PS3BEdE94SUZYTitFVEs4YVdxbHlSSUN6RzFnVFdGSWsrVDdm?=
 =?utf-8?B?TnRuaHJOZHdDUXNlZVZ3MjZkOS9HRDY3bUcwTmtJMGtBcFNHTkE1TlF3eWVq?=
 =?utf-8?B?VlpBd0NNMWxTenJOUHRJanA3UzhSZEgwU1hsR3pOYmVJMG9QK3NNendyUXFm?=
 =?utf-8?B?RkpLR3I5TEpZdU51NHQvMWQvVXkxSEk5d1QybkFWMzU0b3JJUXVVVHpTYklk?=
 =?utf-8?B?MUhaeklCQmgrNFZXWVVtTUF2ZlRjQ1NKc0pOT2JIQ2hveEkwSlYrZWxtSGVr?=
 =?utf-8?B?b1pUM1ViM01ETjJVTTVmdkxFcEhxcnBwWmQ1NHNFNHBqeHROYjZXdXVLK2tW?=
 =?utf-8?B?V2VQWmxDL2FtWm9rNkpneHNOMzFReldDb0VLS0xLOTR3MGd5ditvOXZSMXk5?=
 =?utf-8?B?NjV6dFlZL3FPN0hyRVZvUGNmdWZEUElYRHZZcVlyQ3NyUm1qWDNyVHFvbTlj?=
 =?utf-8?B?VUFBS1hxbE0yNnlnUjlHTGhmZ2RndGo3RkFXWExaeDdMcG5mL3JaeFlxNGJ6?=
 =?utf-8?B?SDJZVHZTU0lRUUtUNkozZW5QZk54V2tZcmxwSE0wbE92d0NnbjFpV0ZTWXU2?=
 =?utf-8?B?MDlLZXNQWGc1eXpYUmNZdnlXOTlRK25XcXljUysyVUFmeXZNRHI1eTdOaWhj?=
 =?utf-8?B?ZjRxc0RvV1NRcmhLQ0RXcWJiZmZXN2t3K0JqcytiWWY3SEorUDd0S0hiek5o?=
 =?utf-8?B?MzRHaUF2ZUJZMjViR3ZjRVRVUjlXSzBhZ1p6NHA4UUdXN3dvaEVrd0V3TVQy?=
 =?utf-8?B?MFY1aFJEb3JKOThxR0x6Z0daRnVwYnorR3k5eWQvY0tmZ0phdVVtQWo5Zmdk?=
 =?utf-8?B?U2tNUERueHFJYmtGR0QzTi9IV1JDYXhocWpNbUcycjF6T3crT3BZbkU5Wk0w?=
 =?utf-8?B?T0xJLzN4QWlXT295UVRxeWpqWDk1T2h5eVBCY3VoekZpL2l5bEFzeTVQeUNS?=
 =?utf-8?B?RGhYZEhkdXowN2RGZkJiRzZ2MFQxRnJaUXIwVlhOdllHcEZqV2w3d0hIR05P?=
 =?utf-8?B?eGdJdjFRNVdra0o5YStTOG82cnRwOTZnSnF4Q3BZOHA3SmU0S1RjSG5lc3V0?=
 =?utf-8?B?M3RyVlJkMTRPTzlKMHZaSFFRS3NFc3ZPMS9ncEpPdEcza3N4aWowTVA5RE1H?=
 =?utf-8?B?RzRmZjYxL0dRVThpbXh5Qmd3bXA0VXpyS1lTWGoxakhxbkhvVllxMkZGVEpy?=
 =?utf-8?B?S3pKZ0V3SXY5blRnVHlUZFFFVWswengya1crL2RVZytucVBZcE9UekZZNTkx?=
 =?utf-8?B?clcxcGdBWFBscnl6RUtjVXUwc0RRMTh6bk5yd2xCZnkweHN2SnA1dXp3NjVJ?=
 =?utf-8?B?NGNZRFhzUkhMajg2a0U5T2czWlR6OU0yU2swYm1KY1dYRlVFZmVvU053ME5X?=
 =?utf-8?B?aDFzVHpaNGhmaFloOFN3Q3dNamptYlMzem5mM1VsUWR6KzRrYzNOUFFTQWpn?=
 =?utf-8?B?UTEvcVNiYno2cTZ1RmtYckVFOUt0WkcvRFBKVU1YZUp2TjlQNUJYVmg5R1lz?=
 =?utf-8?B?OEVyY29adnl1L29oNnZTWDhZL21DTngwYW9RVzVKa20wdHVRd013dDRPSFNj?=
 =?utf-8?B?MmJCNXUrVEk1K0QwaE5TajI4c2lEcUs3bDVsVEdBbGo4OFZaaWo3dENOU3hV?=
 =?utf-8?B?SE92SUZRRWhxcjNrL01SbTIyaStDMktBZHZtQkhwamtYYUdzSGM3NloveE54?=
 =?utf-8?B?aE5aK2N4UFpkbU9CejNWRHIwV1NMYXIvOExBV2R5bHI1Q0R0ZlI4WUlhZmh6?=
 =?utf-8?B?dU1uMWRrb2JPTCtWZEwza0xta1haai9iaUgxL2lEc3hHS0tXTS8yUjRqQUs5?=
 =?utf-8?B?TWRaZW9ZK2FpVmR2Uzg2cUFrYjlrNzVSYkw5aDh3TmpmVHJlRVVSSHFXTnJo?=
 =?utf-8?B?T0VRb0F3ZHNQV1oxdXdqNkY1R3lGMnlQTzM3YUJQTmlERXU4ay9FWFRqRDk0?=
 =?utf-8?Q?pfZhbniVcsjVcblf7xHuOS2ImXmegDrZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mk1EaEk2d2JYYTM1VnFVUEJWMjFnWkhjV0xxejR0T291R2YyOTNYNkkxcWlm?=
 =?utf-8?B?MklkTjB6ZndXSVhIc3hXamh1UmxvaENlZ09tbmluMlBUbVVtWndvSC91MitL?=
 =?utf-8?B?NnZlWFAxWnh1Z2tnWUhNVnBlTXFZdzQvcmlFSW44Q28zMFNjUnVFTGJGOXE3?=
 =?utf-8?B?T2lIbE5rRWdUN3R4dTJZUDZMMG9Cd1hPdG93NkRjRlMrYnl4UWIzLzBoWkVB?=
 =?utf-8?B?aUhGSU5IaWhRWjdiVmNsNGxXUG5YM3dPOUxIV3c5azczUEsxeTVGeVpSWXJw?=
 =?utf-8?B?UUR0eXF1Mnh6R0w5YTNBQzhqWjcreGNhampUSTBqNGN2dlcrbW0vTGdwOURr?=
 =?utf-8?B?emNDTHlNN1QyME1BUGJEY2p4N0YramZkUVRZTThTOGZSamxlZDhjcWwycktO?=
 =?utf-8?B?L3VyUENmSUVYaHpBMVBiV2kyZG1XYzZ4MzdxRGxISzFpc0JuTjhBRDV2NjdG?=
 =?utf-8?B?VzQ5QW05WWYyazhVZ2pjeFJVNmJsR0VrK1dMZ3hJbnFLWkYwVFZEdVhDS3RC?=
 =?utf-8?B?RjZxTmE3YVZ1Uk9sd2x4Z0o5RHR6ekIyMkpPNU01Vm5VT0Z2blY4KzM4VVox?=
 =?utf-8?B?bXRRUStzbkNQeEFDWjdUYktIVmJydStsUkRmcFR4eCtaMlpGaWVSYWRIYTdI?=
 =?utf-8?B?MXRjR3kvRmVQUlpLVUVLMUNlSG50c25oVkxwKzVob3g1ZUVFT2tDUTlISmVX?=
 =?utf-8?B?eDc4ZlhwaHJnVWtJMlQzSHZHRExzS2hydDZVeXJRSjRIWjJ5WmJhQ24xK1h2?=
 =?utf-8?B?UVBnUkJvVGhiWk1OWUZEKzEyek9FQ0lOc0VIOXU5dStsWmNVUm1sQXB2TXFt?=
 =?utf-8?B?cjd1RVJWdVRET1l3dFV3KzhwV2pJUXNYMFZ4WkpNeUowbEtOMmlpb3Y3Sjhu?=
 =?utf-8?B?WVNLWUtUMUNwK09vcWVoNWlPc0tFVW9QSTBUS2hwZFJZcjhMQ0lwVGhYVnYw?=
 =?utf-8?B?TDQxbkdCbXpTbTY1RlNDUzVENzU4UjNxMEtmdStNckIzRjJqVlc1aTdiYVdC?=
 =?utf-8?B?dkE2K25CYXRYRHRRRUQ5WXFKaTNlOExQdmRLb1JFcXhZLzRpazVJWDFqY2Vo?=
 =?utf-8?B?cEdQblVla2NLTUhrdUtxS05Qclp5WUt3dnNvSXdVVW5nTUk0QzEzLzl3ZFNZ?=
 =?utf-8?B?cjVFSGRSQWR1VjdJcS9IWVhxWlZOanBJVERXRjJhQjQ2SzIyZG9FMXNKMmgv?=
 =?utf-8?B?eE5xN3lxZkJySGJhOFVlZHRMM1dOaGhjTHhqY3grYnc0L3dPNlZxejRCZkx4?=
 =?utf-8?B?RkYya2dGdU9Ha1I0SmhZQWJoNXdoaXYrMmx4TTdkMmpXTnR5ckdIbTRYQ2Np?=
 =?utf-8?B?SklDMmR5Z3ZqbW1SL05CM3B0djhnQk92R0NnRVJmenJ2WWhVejd2YVRldTRQ?=
 =?utf-8?B?K1pjZVcyWmpyakZGWEdLS1dITU1zR3d6UGhXQi9JRnpXNU4wUjFSaXNPZldP?=
 =?utf-8?B?R1V4L1FSNDFuNTBpRzlxSDk2N0YrUENwMmo1Z3FWRmZ1U2ErSTJ6SGZLc0la?=
 =?utf-8?B?dzZ5SVA3aTJNb0RRRWdzb0JZLzF2YTZ0Qm96elIrV3J4ejBhSFJMcTV6NnZl?=
 =?utf-8?B?UDh0V2NkRGZPS3VXcUtzRUxvMVpIem40Qm9mSjhBYmUySGRHc2xIVU43eWlH?=
 =?utf-8?B?QU9qU20vQTg1bGpSRjZEaXR4WEZFM2htQ2RjcnFyNkdxQ0xXTnQ0REZuTloy?=
 =?utf-8?B?QUJQWFE0MUF4cnB2bktpSlJrTFY2ZVJmeXRlZm1XK0RORW5Bd2pycDhmUm83?=
 =?utf-8?B?Mk9Tb0k4NW9VUjZFWTc4R2xmUDBOaFZVWnNFNElwSFlmc2dGREtPWkMzb0cz?=
 =?utf-8?B?WVIxS21EUzcwSVhnVlFsSHJCUWJRTWRjcm95MzBZcXE1NG5nek5QUS9ieFlD?=
 =?utf-8?B?OXRXTmRDRUdmdkptSGNPMHU5SElLYW84L3V5amhTR1A4RURPT0cxMXVLcHlF?=
 =?utf-8?B?eXd0V2syUVg1dS9jSEFsMjZwNHZOYnRiVE9aYUNIdHAwTVBvSEIzVmdQNkEv?=
 =?utf-8?B?RHFwSkpveGV3RkwrWWlNSTJTcU1SbEdURE9nS3hMNFJuc0o5ZFRsZ1U0cWxq?=
 =?utf-8?B?ckg3N25YMDBjcHRYNTFKeFBDaitzTkpNeGs3RHc5dG05T1VocDZoWWUwZFNv?=
 =?utf-8?B?TzY3Mk1ibnIvTHpHOGRrM05HL1l3SVA5Qi9ySVZZNnd4WElhSzFHa1grNDha?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cfe34a4-d447-45d5-c93a-08de11e9b90e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 04:07:46.4405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vF5+vjjf7oVXAtyr3v3LOZsTfJejkMfGyAAOaC/PQpb5I/x9Shf5TtStXihaPQNulZb0qfYcil26wSGwk9ygHl3ZO4+Shw4UgE7PJ1dJnv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF267298081
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> Every resctrl resource has a list of domain structures. struct rdt_ctrl_domain
> and struct rdt_mon_domain both begin with struct rdt_domain_hdr with
> rdt_domain_hdr::type used in validity checks before accessing the domain of a
> particular type.
> 
> Add the resource id to struct rdt_domain_hdr in preparation for a new monitoring
> domain structure that will be associated with a new monitoring resource. Improve
> existing domain validity checks with a new helper domain_header_is_valid()
> that checks both domain type and resource id.  domain_header_is_valid() should
> be used before every call to container_of() that accesses a domain structure.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
