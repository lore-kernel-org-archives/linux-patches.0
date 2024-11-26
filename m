Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191727E782
	for <patches@lists.linux.dev>; Tue, 26 Nov 2024 18:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646325; cv=fail; b=BK2J38hzgJYbuHEdiqOjtkYPTuR2zhZQ9iytK/yVI8cJ1bjetKQNnwESlLTPfHQLK8LVoIC5EgFbGWwGFFcD2hvNceLUJzZWt7UBz0dWSummF9/WdhffdNFgLg61cBRB637Ksp5Y2pgXadmNhFEgSiE00BdgIAA0WdgOMC9uME4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646325; c=relaxed/simple;
	bh=oxzywMK9eduYrGjoYJntNRNuHlj7VwmViQg9WL1fL9Y=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KzxyV3JtyKRG3GYcNFtYTiZP2ib6vC5VXd75wTZazm8m/pr+ChVmK706R0h1SC1lAUxAEZLzz4NJ6CjYDaF3XbHRp2z+BlnYMQ+AAuD8G9AaEEXQgAWg7Gyt4xmLvjRYc6T9KwHyD+qG/aeEb1/MzxsmBBfK1Ysbed0NqCbqo/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NUnapsC1; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NUnapsC1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732646324; x=1764182324;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oxzywMK9eduYrGjoYJntNRNuHlj7VwmViQg9WL1fL9Y=;
  b=NUnapsC1AT75cOoOZp/HPH6nPctoLJK0uC16qwZW9cexBBQO+2kKd62R
   xi33dDTBaZ6HAgS4bOIvjDQjEXT5wPOWEgQhPp45MO0iDa2Dh9I2TS1SN
   //rdFO1Xq3zaNr/cZBahHYmh/yKNpJvO8urLmKjOPJ1JDO5CuJTxdqfNu
   o79rdz6B+WFY1xObX56SpgD2T2BrUIa/C346N2pvRu+rnw1BfxOkoIypi
   iZImVgK60JhuNHRA+22o8cVZVqH4EQDT9OgQptWwHj0hb+yaoMx76+4J9
   /walUz9skmDWjUN0/7afHGt6WdbUrp+TlK8X13X4Ub+mMQCcAKmvyCKeJ
   Q==;
X-CSE-ConnectionGUID: CURUa7CSQ9+VD6TfXPvjmg==
X-CSE-MsgGUID: G8w2MszJTQqkZFZMKQ5g2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11268"; a="32972381"
X-IronPort-AV: E=Sophos;i="6.12,186,1728975600"; 
   d="scan'208";a="32972381"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 10:38:44 -0800
X-CSE-ConnectionGUID: YaJyZEODQPygowK/jdQTGw==
X-CSE-MsgGUID: oFLhAc2oSWGOuIYnIsBQvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,186,1728975600"; 
   d="scan'208";a="96130192"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Nov 2024 10:38:43 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 26 Nov 2024 10:38:42 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 26 Nov 2024 10:38:42 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 26 Nov 2024 10:38:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=afX4CKpIV5S4sxx0oWvU20BPzoUArYe5VirudU8DzqjXzuFlM1MxvMtq0dpCnyOQiitCGl3asaGnQfEmxE5Aml42aMaoBJWKOdEgr5BNyKCKjaST7bDTZxlhf+kZTw3kZPE5nOpHnBUL+EuxQucTpzZxYNTHrvbb7UP6H52dyru+q1WTAAutNlprqgB3f3XBNTQ2pyB0h5wX6g3YtJFMdbqo7evH7j63QzDFY6XQ5xF7ZoMgknN5beGzyEgZ3J/VlfzTfnuQR8wWdW930NvBaW788VXWzPayjlQZqRGgEas1JNWBQXuW9kU9WnQNFThVHmgS4Hn2E4wLp8x0uMYPsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5d8wJpBsvTFux9DHnnrIz/WlX3s9TMYyDbOgZbUfgtA=;
 b=pLMKhc4dlf1fHmzi/J2DyON4wOZM3zH6a7gqRoW1NZVNiSWele8sDgSmc7/dsg/7KyrbXuxp3UrSpaPCTtzcJI/GGn7bMffsCieaJbMzN3RWftJYf6BFwOuy2Y5p+p0XsGZzq0QoSPtFmcTVyhKV/S0JjO6njwSDdxsouHzhDMGUaljGF3oufB0bKGxzrHkUahThaANfz1dkB7xvWmNtsbtw+dBEh9x6CMJzpheHdO14MG6/qwgxa8duOgaXu8r3wbNUzdx6hbl1/EmxFPBT+vVQJrp/Z/piQ0QGpawZy5vCdZK2pjn/lVnVGttFbXlkJr3ZxfAJIh1/ZYnmEssMUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by LV2PR11MB6045.namprd11.prod.outlook.com (2603:10b6:408:17b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Tue, 26 Nov
 2024 18:38:39 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8182.018; Tue, 26 Nov 2024
 18:38:39 +0000
Message-ID: <4f74620f-1a85-48d4-a911-e6bc31f32c01@intel.com>
Date: Tue, 26 Nov 2024 10:38:38 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 6/8] x86/resctrl: Add "mba_MBps_event" file to
 CTRL_MON directories
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241122235832.27498-1-tony.luck@intel.com>
 <20241122235832.27498-7-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20241122235832.27498-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0337.namprd03.prod.outlook.com
 (2603:10b6:303:dc::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|LV2PR11MB6045:EE_
X-MS-Office365-Filtering-Correlation-Id: 4146df68-2a5c-47d6-bbc1-08dd0e498bc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NDJLRXVCK0g1cms2cVFIc1lDeEhnR3RieW9EQnlWTW82L3kvRWRYZm1OaVlH?=
 =?utf-8?B?TG1DT1QrRUdZSTRRdGs0dVlaYktzZHQ0UXdGVXZWb0g5RVlrOEZVOHFuWjJI?=
 =?utf-8?B?VHI4djFzZVJ6cVJxQU1ma0U0TmN1SHhMcFVwQVJKN0NkWExiUE1pdkRZa2k0?=
 =?utf-8?B?N2g1MXQ1VHZ3NGNBYkM2K2FyMmZ1elI5RTRMaEZKM0lJWXZpQlNKTDNrQ3Jv?=
 =?utf-8?B?b2piM1FMMkkzN3NjdjFlclhPRHdTTkZlRGdvdUluVWF0THJVNzJYVTkzQjFP?=
 =?utf-8?B?Yzk0WTcxaW1pOE0zK0pjU2JwanhtQmNSRnI4eXlobTNHRHZ3MUNCa0FqZ3pX?=
 =?utf-8?B?Nkc1K2RCWHV6L0JETDVBSEc1UnZEaDdUTk1NWmNZblp1ZVh1UGRCLzlWK1Er?=
 =?utf-8?B?Sk9jbFMxcWFsd3gwSXQ1NSt3WER1VGM5Mk5odkNFcm9RTkpGWFlDcnFpbHhy?=
 =?utf-8?B?aTZJSHFkNnVZMmNJK1lWL29yOFJMYzd0TEpBK1F0K3kxeXBEemgrRndlSnRq?=
 =?utf-8?B?clQ4WW00WnozRUhFSFdqbDlWS1R6b3pQcFY3Z0Q3bFR2dEl3NnF4RC9YaVBu?=
 =?utf-8?B?dmZyd3BJb0JmSXpxcUhRVTJDeXdXSlJOQ0NmQUVLa0l4dEJFUUsrYjRyQ01s?=
 =?utf-8?B?OGtwcHdMTkhYZnlxQ2doMkY5czYwUHhmazhwbTVMM0ZKcFNlYndWVGlqaktp?=
 =?utf-8?B?QkQzOFFWTGpoOGw5RTFJYW0xS1gvRmcvcWZ4Tk51Z3Z2dDU5bjJxY2R1QUMr?=
 =?utf-8?B?dTF6V2Fvb2Y0QW1DdjZFVVRvU3hDOGpBaEc1Tk00TzhPRTlwNldaM3k0S2pt?=
 =?utf-8?B?YmIybzUxV3JhWUlidmw0K1AzbjN1ZStDVHBYMHlEV3RsaVJLbytyYlBOR01o?=
 =?utf-8?B?NTR2UkxyT3VJRlExdSt5c01mU016cStjSVBjRzd5TnY4RENiTWZRanRMdFNq?=
 =?utf-8?B?V3hZNEJOWERlWUZSMmxCeFQxelVrUExEMjBvR3Fjald2dWlmQzh5anRwcjB2?=
 =?utf-8?B?dkdNa0kxblQzZCtpU1lMVDgrTG9YcFQ4OFZ4Z2puQ2YxeWVYM285ZGs2aGxR?=
 =?utf-8?B?SEU4aHFUdDlyclpyMEZ5aE9ocWtQT0ZKQ0UyektORGh6U2hIR3hCRTE5NC9l?=
 =?utf-8?B?NUVEbGM3QTMzcERMTnJLeVpVbW1vb2xLTjBSMzJUMlQySWJyMlpBYSt6bkxT?=
 =?utf-8?B?NnJuRUMvREJtNDJ0Y2xZQVgxcWNVNTNYTWN6VVd1bXg5TmpMOWFUQnFvbk4z?=
 =?utf-8?B?NGttTkVqUjFBY0tEY04rRUM4ZzJhRlp3RDVXdVVIQUdVLzFMZVI0b2cxTm9l?=
 =?utf-8?B?Y2xyV2dHZ2pkUE4wQUxxS0hFakthaW0wM1RpQnlGTWN4bHAyenYyaE5BYThu?=
 =?utf-8?B?RXNTWFpZczNWN2p4N2pZb2c2TWJuK2gvUnc2RmtBZlN1NDRuZ0I4elAwaGpV?=
 =?utf-8?B?Y0dFZmxBd0ZuUStpT0xDZzRTY05rUWRGU1QvMXQ0ZFRqZzdKRFBiaUR5ejk3?=
 =?utf-8?B?NEYydlRJNCtQMnNoQjVtQ00walY0ckpwNmE0bm1STWhuVUZOZHBOLzFUS2Fa?=
 =?utf-8?B?bHVpaXM1Um5OKzBBcU9kYXAzTkpDWG5aU1N2eWliL3JhNVh2bzFNZkZ6L2RM?=
 =?utf-8?B?a1kzN2tTN1A2OFhLclV1ZGxIU3Q1WmdqeWdSakFKcUV4NnB4NEVxbEdLY3lR?=
 =?utf-8?B?N3RtUzhzNHp2UFdEcEVtdmZWYURjcHlRdjJmRm1GaWxsMEwwY2Q1WUZrUkxE?=
 =?utf-8?B?dEtPZk0rNU1hT1lqRDdsTlZxS1ZUUWVlRmw4Z0RiNHhDMm9IekNnNmdqZUFz?=
 =?utf-8?B?RStILzlZRHhVdGl5OEh0QT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVM0K1JvT1pEMHpRSVB2RlZMN2Yxay9IbTlUSHlxYWwrYjQvNTZCZzY4MFZp?=
 =?utf-8?B?T2xkbUVpWEo3NzI3YnhpekNBUkhtQ3pYdUdvbFBmN1MvdzFKWEw5MHZBdmtI?=
 =?utf-8?B?d1JJaU9zUTNZSUx1aHJpM3NtbDlqR0tWdzVPSkFvV1p1elIvdGptM2lrYkRw?=
 =?utf-8?B?ekJxZ1BJcFI4NWpkSzdDVFFleDhhWmtKN2dMdDNkaGVrb0JTR3BRNng5TWhB?=
 =?utf-8?B?NmxxY1F3ZmxmWEhxbFZ5L3FIUERjZ2F5blpYMzI1YkV5bkV4K0o0c1lYQUtH?=
 =?utf-8?B?MUp6QUlqeTAvajFQOWhCajZidm8wN29IY0JEcFVSU3RRN2EvZUtRRHJmNjRa?=
 =?utf-8?B?VVV2Z3ljaG9sWTRFVjE3bXRSUGtsZml0ZkdVejJBMWRlWUY3NExySGoxWWlz?=
 =?utf-8?B?QVdpWVg1MWNvdHk1RDRRQXhqdi94VzhFOTlKdnNibDJzTmp2K2czOHNkZDZp?=
 =?utf-8?B?S3lDL1NBa255a1E4azl5a0Q1dVhRSTZqdHJXNGNVdXJRRE0xWGlpY0lmYlY4?=
 =?utf-8?B?UlZTS0szL1BCM3RrYzJPZXl3R2FPYnB4a1ZiMlJHcmlFbFpGR1M2VUc2Zkt4?=
 =?utf-8?B?S2dYeG9XTFpYeFZORkdabFFjZ2lPczZDTjZ4NEdjTDdNNDcyRlBXK1FNZ0ZD?=
 =?utf-8?B?Wnh6a0ozekVtc1Ric2FMYUg1UVNGVkNBd1lpck40M1kzaHRvTlFqclVRMG5m?=
 =?utf-8?B?ZEI2bGRteTIwZ2lDbDR5TmxmT2dLa0ZyZ1FGbFg3aXJJRmd6VkRwL1dGSTRT?=
 =?utf-8?B?MllJVlVZcjRVb2MzeUE2L1ZxaHlIVjkzVmt4VE1MR2hJWVJkVFNkTk8yREph?=
 =?utf-8?B?YURndFJrY1d1czQ3UDl5eVFPUEt6b3RnVzczRzJnMzlKYTVQem83aUl0QjRN?=
 =?utf-8?B?RDQ0MHdYNzRoVDIzbGRBZlB1dXBXaTJHc2lYdC9RZEx2d0YwYU1pd1NIc3d4?=
 =?utf-8?B?L1QzNTFYWWkreHhweFZoWVpKK1NnaDZTVFJpS3lJWEttTkZVOUo4WEFER2Zq?=
 =?utf-8?B?U3p1NlliMWQ5UldSTngxU0t4d2Nlem13SDFlaE9iSWtPSEtUcHFJa0JHaDJR?=
 =?utf-8?B?SkIybkZLLy9iVlhSTHZUTlF4ajVyb1UveGd6VGg4a2huVHZUUWEybjEzcUJz?=
 =?utf-8?B?aDBzWGx1OWFOdUhlQUVZa3FwQ2NEbmp2QmdqdG15V1dIUVRRdEtkOG1VU1p6?=
 =?utf-8?B?dUg1dVlacTZJbmU0WDROeUhKMll0cUs4TVV6MTRXemF1Zko3TVlFTWtFRnU3?=
 =?utf-8?B?QkR4WlFyVFpFQVlSdk14eEQxNHVwVDZncDJDZThwNGRjaVdnU0tHdEpQeWlS?=
 =?utf-8?B?TWdienY2dnBlakpnM0J4QTVsYzhmVjdJbUFtZnQ1WUF6WmFrNDZlNU9yZmJI?=
 =?utf-8?B?Slp1UGgwMCtpeFpOYXVQMVpFUkZRbGY5dDRIZ0ZlUnN1YnkzTVFxN3R2MDBu?=
 =?utf-8?B?RnBjTEVUb1dOak5aYUFNVWpObWpzejBlbnVjUUNzVFdzQTRTaVQ3TmhNL1o0?=
 =?utf-8?B?Tnh0SVppclhjakthd1hzNEtNbVlveHpJbWNrYU1OWk5UV0R0YzliKzMxbTVG?=
 =?utf-8?B?a3g2eVhkZ2p0K2xiaWhCTlFmeVpkVW9jY2MxQWpSbGNlNGlMRURIMXVvZzhI?=
 =?utf-8?B?aTFOeFdFdC9FdHIwUWYwSzVjV2NWc014bC94TnZHMENtTXMwdjVGZ0xJc0Qw?=
 =?utf-8?B?NEpReHRlSTRrU3dYdHRxYmJST21pL1l1QlFLbGJsQytyT0dRaElRWVI4UHlF?=
 =?utf-8?B?Y1djcFFNNEJxWHBuVFpqbnFqdGFxYlNIWld0bW1VQlZ2SE5FWkVweXNRMEhZ?=
 =?utf-8?B?UHpBb1oySWNrMzlGd0JCd2I5UXBYMlVPZnY0UUZzeWhWV3drQTB6bGRzMkRs?=
 =?utf-8?B?WisxNTVCNFU4eTAzakZSeUFPQjc0OG1uS3lZK0NWTHV6a0h6L25SQWI1dHl5?=
 =?utf-8?B?RmIrcnRTZVc4ZzdaUG0xOEZobENaSzcrTTBiY1RoRnRWTW9MamFVc2p4RVFr?=
 =?utf-8?B?SXU3NkwxbjRKTGhXeTQ2c1dlTmdyMG9OZ1QrNmRTWXU3WStSaE8wRDAvSWhw?=
 =?utf-8?B?MEM0RXFiR2FpWWxxbFNsdXVNL2NwNllOdlRSb2hDVEdNM25yRVhCcDJTMVhX?=
 =?utf-8?B?RnRUNHlkbGlkTkwveGxYWmlUajBFQW1ZOEEwVWt1OVdXelFIZnpicTRuRFNu?=
 =?utf-8?B?RVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4146df68-2a5c-47d6-bbc1-08dd0e498bc3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2024 18:38:39.8097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jxLvjfWZsY70a9Zja+hFSazH4wfzvo41uIH8CFyQhn6nu2J0wZowuuPrCy4NaBOj455QHah31+6fhUNSQlXJ7Q5rwah2FbWvaVJ0WHPmuO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6045
X-OriginatorOrg: intel.com

Hi Tony,

On 11/22/24 3:58 PM, Tony Luck wrote:
> The "mba_MBps" mount option provides an alternate method to
> control memory bandwidth. Instead of specifying allowable
> bandwidth as a percentage of maximum possible, the user
> provides a MiB/s limit value.
> 
> In preparation to allow the user to pick the memory bandwidth
> monitoring event used as input to the feedback loop, provide
> a file in each CTRL_MON group directory that shows the event
> currently in use. Note that this file is only visible when
> the "mba_MBps" mount option is in use.
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

