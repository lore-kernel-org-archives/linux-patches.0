Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1359730649D
	for <patches@lists.linux.dev>; Tue,  9 Dec 2025 19:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765309112; cv=fail; b=KuB1xKd/kHIa4mRBgSaE29cMDsoPub6pn1qCb6vBWMk5jaDZ+vFuezyCmRYvm5yKlSgTrI/jcCaW2UUF28ubDEpSdVeBmZuOmlENwW2XOzJxEGDKbBZJ6tZT8+yir+yWr4UpGUuExEKqBxMhqoxhPmF94Zj3GCjFwRnfyt2ruZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765309112; c=relaxed/simple;
	bh=uGUieRX24J4h6b5UiZmLUocKLJI/IUAEGuZGEt7T71Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J/oQOb2zeAF22pJDguDe7b7fO+aOv4vvHEkT+a7bIAo3YuNyrzTNrIS68b8zREg2CuYvy3wPjNfJAupLBlZdrM+K8+QgUo79JKzjjXb3Bo2BeNYsgLc/QAsq/lFJu8GTFU5lye88nbRXmPVm6WMveQerEUj2uiXvqheMh9XOHf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IGubg/dA; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IGubg/dA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765309111; x=1796845111;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uGUieRX24J4h6b5UiZmLUocKLJI/IUAEGuZGEt7T71Q=;
  b=IGubg/dAhaWM5PjF+/qFMShAGn0GYGSEO68mguQl9JZdJVDHODFNOvSD
   +Kje8seRUELQ3LMmfyF5UoYQKAYAoZ70lrDo/MfhFXfz9/ifZDRy4bk3V
   RsQrNB+bG2ZNEStr98lMxDLov04Zu1g0t21HCfqAV5WoqUyQ65563UzVG
   BdvjiK393uPHN/WiO7lDvZZvznCkMs+aYEysUtvUGlLeJ7HMcwVbRx/Xl
   /3ycxTt2/tLGNzpvTxSvr6165qq5YN79VlYYSgwtR8YcxpAV9M28Y2+80
   FF7b41Q5t/bU5H1kvvgGugD/coBrO99C9TwVja9QFt8JANvg27BPirjNy
   A==;
X-CSE-ConnectionGUID: Bg41BFc5RFax+50gFTblLQ==
X-CSE-MsgGUID: NONKSec4TvKElzbH01CB3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="89926290"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="89926290"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:38:27 -0800
X-CSE-ConnectionGUID: 5Y1jR28fQjmB9kYMNg3cOw==
X-CSE-MsgGUID: mL2uPhuJRO+cWfBbUWd/Hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="200479780"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:38:27 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:38:27 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 11:38:27 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.60) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:38:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t1hoh1Nk1xYUB2+9QEFWQmpNI9/ZDhyBVEhkt6BFmUj+ABI7Gg8Gjg6Ks/Go4MdkJfvBxITVNhn2A/iE1AzqDlA31Zz9V8seTXzjA928YGKjjjRrxJ/NUWqr6p0yTr+ziJJKkOWkLPA6thUDalHFj20AXZPQmRYtNp3im3n/oCzEPCSzljIE51mN0fE5A+q3UdV0dVnSUveCwipwOCasn/kGl2FHZgLbDQtJzRgX+pYgKiqaiq4S3f3Ggada3rwAIPo0DkVMEc2h7ah8XdtmyxUqYKKcK4ZkQetU9rkNglCYfAX5QUh35yRqDT8ePq0kA/9w3pee+zZMXz0G8kuHPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ekcv1qqZ29gXpbHGljZGLVEFyqw6tj1/r8TKS7JgBg=;
 b=WbLhuWhb+C5Yd+KGy5rmaQ6KY5cmNdaKOpkMyaDWXCjx6sT6y4OkmWPnGc8NrD24atrKqwBeuEfLkFz7WAZAQzSsu/EGH9ko9PBKhmcz7wm7TedxR/MLHOR7RZa4iQRt3j8KHJQjB1Q3//zfiF+eRM+aQUePxWEWAZXohEslG8WnAgvgcdBhHGdCFsWTFsLriKhGMtm41eme/6XjiQhNF6GtD7ck6SRNLIuwJgYZyhj1wtYNbYY//BLd7qnK4g8lJhMsZcR7ufo9gi79692traQSCmelpd6JhzQrc9sXT4+bTvM1rKGiMNdp2RFn8Egai1cojPGD2asb0g0lpsxKjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW6PR11MB8409.namprd11.prod.outlook.com (2603:10b6:303:24c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Tue, 9 Dec
 2025 19:38:24 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 19:38:24 +0000
Message-ID: <7974688a-7d12-4c59-be05-c5f4dff580f3@intel.com>
Date: Tue, 9 Dec 2025 11:38:22 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 07/32] x86,fs/resctrl: Use struct rdt_domain_hdr when
 reading counters
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251204205404.12763-1-tony.luck@intel.com>
 <20251204205404.12763-8-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251204205404.12763-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0216.namprd03.prod.outlook.com
 (2603:10b6:303:b9::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW6PR11MB8409:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dee10d9-f0c9-46ef-776b-08de375a8498
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RVNEVkUveGVSZmc4UTNUajQvNnYvUGpEM1h1Q1BNaHZiaHEyNWJlZncvWVBk?=
 =?utf-8?B?R0g5K1UxenVwTXVBZVN2aDM0TWZWeE5GSHIrcndEb3BjMjYxNGJtUXlHbWtF?=
 =?utf-8?B?Qnh5QngrL0F6MUNuSzA3VHJBYVB3VHFaYzlhcWN2OUI1SFpwZXBkTEpKYjh3?=
 =?utf-8?B?bHgrams3NkhFNWk0aFFaaEtZbWRuSlg0SXdMRmhYQU14Y215VXNNSVlwZ0pz?=
 =?utf-8?B?bmNYQnpFYmMzK1hHdjJ0V21pbWtRQWRiY2lVRjUwbEVrenJUUEhlY3FlcnBK?=
 =?utf-8?B?ZnJBZ1EzYmNXdnF1R3lCMmRROFVVTFJab2l2Qy9pRHl0dDExUUtNQkxRcFRi?=
 =?utf-8?B?NXVla0JaaUhxczRXWVoya3hJbi94WTBBVXEzS3BUalRXbTREdCt2dDB2eERk?=
 =?utf-8?B?bjRrN210dnY0YTJxQjRxbWVzNUNkSTgvL3lqcFMzV1VRVmd0d3JwU2psVFhI?=
 =?utf-8?B?dy9ZVUE3Q3dVZ3dnS0VCVG1rRTFRZXNSNmpxT2toVmF2RC8zakxPMUE5M3Q1?=
 =?utf-8?B?SGN0a0tLQzZUTjUrRWloVFJ2L2g3WU5sb2lrRnVaeUxSaksxOGFFd0VqT3RX?=
 =?utf-8?B?MFlkdStZTE5xcVFMTEIrcEZDQ29heU80cS9YRk92VVZqS2lPQXJzM3JkazND?=
 =?utf-8?B?NlFUY1p3NXh0NDJKWnAxak4xL28yVURBMEFqOWNyK0JBajFWMVZpVktWaVl5?=
 =?utf-8?B?eklwZ0czd3h0STJ0VU9hZ2JtaFFacHNMdWJNMGxOclBURHJtdk02Y1ViVzNq?=
 =?utf-8?B?eHpjTVlyamVBVUprMmZYeVFhOVhYemR4NmNSUFh1SUVJV0oxam1GZ1UwcHNI?=
 =?utf-8?B?UzNDYUJ3UUJ0NE5KLzA2SEJHV0hWbG45aE9XaFE0OUc1NjdKRHlYTmg1bkNa?=
 =?utf-8?B?REZtSURoT0RhNlRIRHV1WVR6MTV3VkhLRjk2MTJkalYxZGw1MjdvR00wOEpx?=
 =?utf-8?B?Mm42WWwzdGpYaytDdnF4SzNaU3VBblBoTGlEeHA3TjVHWllENXVSMW1FQkd1?=
 =?utf-8?B?bkVrU1NIY21sUWoxUTRPOUV4b29waVhXOVJVSmR3TGc3SHB4REUrdE1WeHJw?=
 =?utf-8?B?SWJtRHJkdlpldkYwek1WTHVidE9PL2ljaXR4eFI2ZHdjYkJBSkt5OXNpOHhQ?=
 =?utf-8?B?ejJuM3RhV0JoeElUR1VtTFZPTE9rQUpFV1dRNTcvZ0tiMWc4M0xscm50bDVs?=
 =?utf-8?B?UzVCcWd6NnVPZno5NjVrSXpGTDV0elBEc1ZtY3o4VHNLay82SjUxSjB6aVNk?=
 =?utf-8?B?K3FBQUJMUDdpZUo0Unc2UVJwS25sR1dhZjhKb21ZRmZFNk43T1kxZTloRFNy?=
 =?utf-8?B?U01TbUdzeDVXNGM0aGI3MXFEcDFDODhVN0R3YkxVaDR0ZXZucGYvR2xQeVUw?=
 =?utf-8?B?N0VRckk4ckNDeG5XUUNNcjZCQjR1QmFPM1NsVjRQK1l0d1JLcmxDTW9mTG5r?=
 =?utf-8?B?Q0lKMjBQUmFQeWhEVmJxeG1CbUpZZVNOR2psS2l2MlcvemgrYUhmOGMvN01W?=
 =?utf-8?B?MFBmZmw1eGFFczRCK3hrNWZtbXJ4T0RTVi9jR3ZhM2o2bFA3bXFHemtCOHdh?=
 =?utf-8?B?dzNFYTRIOEhyZG9VYnRoUEpBbUFUYm01N0lLcFdaT09aOTJEU0NXamI1d2t2?=
 =?utf-8?B?UVdHRDd2azl4bGdGaUd2bmxoN2ZkOG5zRGJNU3FRSGk3b3ZkcGI3aVRORm1V?=
 =?utf-8?B?MHRubkxjNDQzOHQ2SXU0RHFCSE5JREs4amk2RzJkZUFwVDJOYXgveHMzZ2hr?=
 =?utf-8?B?NnJ0QkE0SXFoRGN3VmNqdGc4bU9pZnJCNmM0aEx4cFo1Y3FoMGtzNVpzbFQ1?=
 =?utf-8?B?TWNUVUszTVhoejd3Q20rN3FrUCsra2dDVUJaZUhJcEpoVDBQRUdLb2lGdVBp?=
 =?utf-8?B?ZW9hUDJxak1TRWNSVHFIMjdLN3FxMmJtSERxWFAydS9rY24wMk1GUUlMVXhS?=
 =?utf-8?Q?ZsSyXMijVYiWzPwAXnKzRcwRH2t0/4gm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXB5VEdHQTEvL1hUQ1I0VUdBWTZEa0FyMW9aT21KZmdhZVp3dStod0xqUTN5?=
 =?utf-8?B?c0FZR0VwZVRkSjdONElsWXVBL2U2eUVGOGtiWmdqYnpaMnZhcWJGQ2pBdm9Q?=
 =?utf-8?B?Vk5LVHByMlpLWlYxcWhzRE5jM0RSZ2ttd3VJTG5hbGVFVkQrR0cyNG9GelQw?=
 =?utf-8?B?T1hrT2FnQ2FJUTl6OVJQcGlBUnMzV2w2Z2wvU1BvL3RJS0hta2c1eCtCRkx5?=
 =?utf-8?B?eGNZb2drWmxpQ0tHMmpQOVFGRmdNTHhlcWJDcFNBZWN2d2pONGtwWVdjQlpu?=
 =?utf-8?B?aEhIVjVZWUtCYmpoMGFzNjE5Y3NqNERzYU9jSXgrUk00bjErZk9tRHdnZzhR?=
 =?utf-8?B?NkVKV2FIdVNPKzFialV3cFhYK2ZNK1VzV0NlNko1OEhhYmxoakxoVldFL1lo?=
 =?utf-8?B?MFVEdWRXeDNaR0dMcVRBaENBd01GZU0rMzMwb011ZDRUcUJxYXRyNTNkUFVX?=
 =?utf-8?B?ZkRiOFBQUmhuN0k4WG8xTUlPVlJaRjZ1L2xwWmo3bVpLTkNoajUyQ0o0U3Az?=
 =?utf-8?B?dEtmYVpESlJqelJsbjZxeUs5MDVxUm0vMGpwUVh5Y05rdms4dlNOUS9udnBI?=
 =?utf-8?B?L3gvMFc2MWFrODVnVjE0MUZQZmlVVFhSMXFtVUpkN21CUU5xeVVJcktzcmhz?=
 =?utf-8?B?SndiNVNRdW5DY3lLZzFadFc3UjFLSHc3eDBpQWI4bTNYbGVpaTVoOHpHdjdQ?=
 =?utf-8?B?T1U1aG5xUFhaOG9tVGY2SWpJQlh3ZGd3YXBQVnBuTUpVZDRzWlhuRHNXN1Fw?=
 =?utf-8?B?cnZyd08yOWxNc3J5QU5JYzlOcEQ1a1NVamJuejU1WC9rVGFPOVhWaWU0dHpw?=
 =?utf-8?B?UUw5OXlQNkl0TXZPby9odmM4cC95L0tRbWRsL2k3UWt2cG5zRGlPRUR6V2hN?=
 =?utf-8?B?K0VQaVV3ajJiZ25KOXV5UC9lL09lVFFWcFZQUkFITWMvWWlPc0c1UERCSmNl?=
 =?utf-8?B?bWpaVzhvL1lnalpvQmtudXI2aXJudXpOcjVuNUQzc2hVWjJGK3FBZi9ndjlj?=
 =?utf-8?B?WERSV2QrRWtTZS9jTVVzUEdWNXNaczN3TVdybjM2MXF3OXE0eHJQdXdTakk4?=
 =?utf-8?B?UjB0TXFjQTFVSEM3dGM2QVFtclRaeVdzd29lZmxJeG5vSjd6eGVDR2NyQnN2?=
 =?utf-8?B?MVVaUE9LdkxtS01jMHhjN0NkVEowbWZQbldQeFQyVzRoVlRXeGJPMjZpbnR2?=
 =?utf-8?B?Ylc4cjhWS1B5aFdKU2Zaa2l3SHorR3JOMVp2Uy9ZNFNiVVl6aG1uQkU2aW05?=
 =?utf-8?B?b0pEZzEwR29NaXJ4dk1YbE9aZE82aGs4T1JjZW0yZ1hBNklhRmxzNTVZQkpV?=
 =?utf-8?B?SjMyd3dIYzFMMXExL01oZjNTOC9NS0FwTHExa2pUb2JFWmtKZ1loMVlpRXdS?=
 =?utf-8?B?WDJuamViTyt4ZG5YV0JRRzNETW9POVArSXpNZ1dzaGxNcWg3T0trNjRwNXJP?=
 =?utf-8?B?VVpSUXVGZE0zRi8rcUorcE02TnBpVWwvUHZFcGhqSjRQcFZjNTZqN01DcVhN?=
 =?utf-8?B?MWlZbUNiWkJ1cldGVUI3MzJ1aEIvdy9UcUc5UUNxUGlBWXU3cXZFbGVLemRh?=
 =?utf-8?B?ZWNTWTdZeDdPSyt4eGtTNVBEZ1d2U2xSNVYxTm1EWW5EUmJhM2l2TXQ1eWJB?=
 =?utf-8?B?N3dFVFFKaXg0OE5NZWJ0YktGVHV5R0lFYmNWdnBxZGtVb0RQbGlycS9yZ3Vp?=
 =?utf-8?B?NTNFOXBNeHd1SCtESHdoaWNQcE42emF4VjIwOGU0UElJUm9JS1pwQXRlTGtU?=
 =?utf-8?B?RHFvdVJCOWxmOXh0dzlCUnRMS0twZ1VUWTd0Qm1RVzRFVnFWbU04QWJLaE04?=
 =?utf-8?B?SFFVazRBQ3RIMGJSL1g4L0E4UGVienFCbjJIMUxrWXJidEJjYmtNSXYrTyt0?=
 =?utf-8?B?cUpQWFc1SnFvc3Q2emlSS1BaZ1VPbEp0bGhnSGlPQ0Y3RWxTZUFZUm9uWGh1?=
 =?utf-8?B?SjcyeXYvRVlvcWxVbjlYOUxtNVBWMkZhWWk4OFU4dWZNM29EQnZ5VlR0T0dB?=
 =?utf-8?B?N0FDeEpWcXN6a3gwSXhqL1hwc0V6bHNnVWNtV09lSzRHTGFLenRHWmpaSkxR?=
 =?utf-8?B?NHVja1FLZUEyWUR5bjRsSlVCUlVXT0hJY2ZjUE03OVFaQTlBTWs5VTlDdm92?=
 =?utf-8?B?L08xZmxhRUxFazBLVVFSRGtNVmR5Z2ZPQnh6bGl4K2xTY3FWazRmT21DMXQ2?=
 =?utf-8?B?UFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dee10d9-f0c9-46ef-776b-08de375a8498
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 19:38:24.5960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a99EtiGn8PQrtBlTJUF3qMYQcH2Me9spFPVZD+L4LPbsLXgTOK8Qf9UqptAFBtUpIxrYTiekD9iBiWsr7jt5Ph9NfRTWWQDgWGKSoY57NQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8409
X-OriginatorOrg: intel.com

Hi Tony,

On 12/4/25 12:53 PM, Tony Luck wrote:
> Convert the whole call sequence from mon_event_read() to resctrl_arch_rmid_read()
> to pass resource independent struct rdt_domain_hdr instead of an L3 specific
> domain structure to prepare for monitoring events in other resources.

Please add a snippet to inform reader about the additional change that splits the
event counting flow. Here is a draft of the idea to start:

	This additional layer of indirection obscures which aspects of event counting depend
	on a valid domain. Event initialization, support for assignable counters, and normal
	event counting implicitly depend on a valid domain while summing of domains does not.
	Split summing domains from the core event counting handling to make their respective
	dependencies obvious.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
