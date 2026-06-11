Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A592737F8
	for <patches@lists.linux.dev>; Thu, 11 Jun 2026 21:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781212952; cv=fail; b=DG1SQenyZnOmK8WaHLi28FrOmgTqjRTu57HL/yMmtCre92twiIeiqLrNLWQ9RzEc8ws0Ox/Agdp+SLqS4dcg9FKhKxhrmx6ggb5Olca/wqYfNMXr/Ah4To/UDuo1APaUSxRZJ1wJxk4NXgwnL0zVYpNJBSL7/YM2VNmNBkmko+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781212952; c=relaxed/simple;
	bh=OBbNIU+T6cHLuIiH3EGrCD8ihbK/bArTirHmlkVonBk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uhU2kDfSvjCybZNfK/1nF27/BMwxd+yy9+KLn5XZd/tDN7AfGFAIgufEEK1WUSId6TxpArUDL54lD5ZVeB+9wLonIMhCI4WlOtGDP6VuQmtkyDEDg0TZ42xc8DlCOqpaFuCawqBtJdQUlUmdkICpdhMxk1ppLveZKnu7z+6X5KM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LLZ0Y0qv; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LLZ0Y0qv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781212951; x=1812748951;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OBbNIU+T6cHLuIiH3EGrCD8ihbK/bArTirHmlkVonBk=;
  b=LLZ0Y0qvPjQ/lpZI9sUuAkJP74q6iKix3ofB7fkyN0tiERp7EEs869IW
   xH/MaUcooO4zDWmChvW8tkxrEoFOtjAR44bjO0r2wEgbMOEg8BG9aOdxh
   AR74UfKDQGRgoS7vEo+2Fdy8pfDCccTOO1PTizUl+oCEohyR/wAghAYkp
   44PCcdBGsB5sCEEjgmjp2aFrS7SgNGsbKIqbRJwz5gYrej+bMYYUVAg29
   bx7UfJdwTZevr5gdHzXemYq6K39rTDxJ4eBO2Udc8qr3aimSiND02JUoJ
   u22DYvOdKFFMnF9LHG/PpQs3ohctx702NqZpEDmKHE3qpaQ9QE4YMyB6T
   g==;
X-CSE-ConnectionGUID: 68Bz3YBiQNqDNonrdz9KlQ==
X-CSE-MsgGUID: S7fQJIWqQz6qiwJFzyYU1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="93528868"
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="93528868"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 14:22:21 -0700
X-CSE-ConnectionGUID: ADzIv2GlRmi2Sos9zCvO/g==
X-CSE-MsgGUID: rNkXohvNTBG73XWEp0ggsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="284706512"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 14:22:21 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 11 Jun 2026 14:22:20 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 11 Jun 2026 14:22:20 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.14) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 11 Jun 2026 14:22:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=POrOCmk7BWExk9SRteZ2m7gGd+cYLH1eiIsmBSNKTHuKt0vCxfv7EWGYWM7qE6Wcm+RFqzjjRNaGHYfTHI4ZGnMXug2TJrZGBkkbZwbVyc9Gvunifs5bStmb2OIoDBGtYV9Mk3W7FSuhVlIinx+cbSJ3O4ALlMs/bHJj1Ro4RCQUZAzJriybzSzyetGCZK8cdaG1iX6ArEg8AFJHoDjjNyG2vieEoIK8wrKyp9xWRKBCWlZ39htWLWAlhXbZv3ICtXTlOpNTrgpsKDnBC/AtYLibJlx53LH3uBlGt7OX96wwFRLwTilNd2IBtc2Ai4jRMQJO+E6GilFvPu+yW+Q4fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4qD7snVQ4WVQRI35RbQOrk8VSz/MAREeQ5y26+/NVxk=;
 b=hTduR1aAF56LQIDhUhUs2rFTrYaNkgjslYbW8LHlJT942s+xPPAskoV9iETlk2Y9yraddgr9KLfbZVG4rzObUoFtYk4mbzgvxijVbSAZePga4sBoLFZSEzjkmTKnFsN6BqOzWUOXRN+a4f04hFI/UYY3l9SAA987nSq6mlV1gi0jKdlTD0WggkwRqnGHKI0+ZEkySN0FgdlKZyqvKy2QBpqm7l+eGO1hszQKR24FG73Sr+Riye5TQNDlVwzEkxDTqnMpk9OeH1M7lqqJtuSjW9gGyNYmcN6lfl7fDrDxS6aLqKGurXuA5EpyXOKz5TvJELpCMRXlmGlxHP7Se6caRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by CH3PR11MB8752.namprd11.prod.outlook.com (2603:10b6:610:1c2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 21:22:17 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Thu, 11 Jun 2026
 21:22:16 +0000
Message-ID: <85f9423c-09e3-45dd-89c3-7b6db6be8acf@intel.com>
Date: Thu, 11 Jun 2026 14:22:14 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/14] fs/resctrl: Add interface to disable a monitor
 event
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-7-tony.luck@intel.com>
 <ad6da54f-5808-475c-b46f-858f7f31cc18@intel.com>
 <aihLqhlxS7l1y3jO@agluck-desk3>
 <7bbc2796-0f33-433d-a949-d95fa1db6401@intel.com>
 <ainPljLE0yc0o1mv@agluck-desk3>
 <f9b0c233-04a7-4ddc-b792-f2def000febd@intel.com>
 <SJ1PR11MB6083DF803C214160BA106555FC1A2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <SJ1PR11MB6083DF803C214160BA106555FC1A2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0081.namprd04.prod.outlook.com
 (2603:10b6:303:6b::26) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|CH3PR11MB8752:EE_
X-MS-Office365-Filtering-Correlation-Id: 001ef269-6154-49cd-a1bc-08dec7ff8341
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|18002099003|22082099003|4143699003|3023799007|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: u6IUCNKO56ty8XZRioIfVoU34YCNHdZCyiBwjAqKR124M17Yqy5jMF/X6ilszrA/g9LLnaPNrsVdMobIuJiKdee+psQCkvyJWbKB51WLeQhVwt99+NxqYbsnwHSHWyAb3tljutMVxJA6bZSjCbBmw8Q+UptdWWJGr3mbZsvzQYOcxpMTBeAYkJjL+UvPJGyTtpYuFvBC5sAdrpgpSMJFhbOrF245usxPJ/Ta0f13lxsFW3DsPNHmPRD7tYaX+VkmjE1dAHFc27AqiKUu1m8KkqbU41sOrDWpSbDJ01m0WCUIhb/dGLdu3SfHX+NWh4BbLbVMIqs3o1WAxIochLO6e7XFCoE+LFkfpWTZpOWId5T3AA2wy9TftKQOU2jVJIuqzhbare0R9tMVJnskhEtOnCk+v77ZwYeDFON61hIi7nu3EpeN2g0gJfEBF7m2cNnS7LyvGceqwUlIVmT5UHR9VY+qSHKOEXBs0Z1LueMH1sXqKVj5xL7X3N1cSlQ36hiW4c5w6QaPlbGRWumRZkCqwO5VMVMM0X7ZV6qsqMd/Y2IsNQYA5HpEALUdUCp8Gmk//a8Ui4cDQ7nhZdZDvJlix7CrbXhm3UFJGOiQynBL2lqyk+9ERSIw7k1d3+xsxQWNTecsfzBr5kFMYDp7XLu1o1+pxi65fec65rOZSR9mJht8wx7zZ4q02O/7xUICBrYR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(18002099003)(22082099003)(4143699003)(3023799007)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nmo4U0ZFN1crRmNjU0FJSnhpbFBwc2NTbThOVU5lenM5SWRlT2h1SWNKRFJq?=
 =?utf-8?B?M1pWRVQwN0M4R1Z6MWNUMGUrZTZya0ErMmpEK3UxYVV1RWhORldiNnVhb1Q1?=
 =?utf-8?B?QXAwbnd4eUdrSFBpU2k2S2xRYjNXZGE1M2pkbmJQOGJBSExUaHRxNCtPS3Bn?=
 =?utf-8?B?NFd2azJEbm9kNGJNNU9lKzlJaGRnMVRUeXNwRzhQbFFkWE1HUFR1dTJscHBK?=
 =?utf-8?B?QmVBZjZ4cGg5QzhYL21YeDd4NGJUWGtsSkNNTGxJWFBTNFFSOEV3Sng4djM4?=
 =?utf-8?B?MnpVZTB2Y2l5VEQ4Vk43NTJJaDBaeTFwZnVVQ2RKN0twWXhvYWljZ2wvM3RE?=
 =?utf-8?B?cmwzeUtNaGExTzhuYmVHUGZvRDdFdjQ2VXFUTTU4K1A1YUZPWTdhTXVFZXl2?=
 =?utf-8?B?VDlhRTRzNDA4LzdyV2dUdVpjUTZ0dXRXODcydHlZZlBkODY4TVZVbFFQcDZQ?=
 =?utf-8?B?RHAycTQ1d3IxNFJwdVRPWXRQZ0dWcEk3MS80Z1NvNEtLYXE5ZHBhV2FSSlBZ?=
 =?utf-8?B?QUVMRFJ4Sk53OUJPOU1ZdFc3RldHSmhVQy9JSFJIbXVhaXdlNktIek01a3RU?=
 =?utf-8?B?aDBFdC9NTmZIemxVeW1ZYy9OMk4wTG8wYVYvMHRMeFJjRSt0TXUvUWdtL2pn?=
 =?utf-8?B?SnAyS1RNclN3RVVwMWlKNDNnY216RENjM2xDRTFFSzdnNUhiM2cxbjhpUmoy?=
 =?utf-8?B?VkMwZTdVYTF5MXhmVS9KalVpbVFWUk1SMXpJcWdRdTFqNStCbTNHNTY0RkxD?=
 =?utf-8?B?RjkxUGdtVHdBU2xERWhEYzZXSW1uVHl1SU85VXBDNjNoUk1lVFNIUUIrYXZp?=
 =?utf-8?B?YTZrcnhYV0dXWE1HU2doUFVYYzN1UUVMa2Z3b3BEUjgzcmlZUjN6a0hCUVNi?=
 =?utf-8?B?cE5LekNpTTRac2NZVnhHQlg5QXRzZ1YyaW9MRkNadWJrblR3bS91UGZjNUVu?=
 =?utf-8?B?S1VRUkJHZGZhTVVLQkZZZGd6L2JGZzRXRUE1aTJjM1BGTGhLNmpwMzNrNEll?=
 =?utf-8?B?RitNNXpqczNNTVVMUFNpTXZvVTNnYTRLcDI2czgwRTJVU0tKL1BGZG5LRE9q?=
 =?utf-8?B?NHdPOW92aFVtNXZlSncvcGtlT2FsSmtqRmJKTTFRMFZiMWpQSWtpOGg4emN5?=
 =?utf-8?B?aTRDejA5RU5YVEJ2cHFIRGl4THo5MEYwSWtyU1gxR053MnVrUmVuU0crejFE?=
 =?utf-8?B?NnFWZTdHRWhTencxMXR5V1RGSXNFOXI5dXVjck1LRFVCWU5Ia3dkWnJ6SE9s?=
 =?utf-8?B?SHlrMEZ4bzM3cGpKcG1OWmZFbGNxTEZ5SmFOVkRxKzZ3RXd3TS9NVUxvSUdN?=
 =?utf-8?B?ekJnMkxiNS80U1hHa0NsS0hDVEVyYVVkaFMrNCtpM25yb2o1NVZsSE5vbjVm?=
 =?utf-8?B?dmdWbXB6SlY5N0RVdUwrY0tOY2RRZWk2OVFEK3hZQ3VTakJPU2FZQ21jTEht?=
 =?utf-8?B?dkE4dm5CYlNCbEh4NURmYTBZUEg0OFpqdi9uSDVFKzNrdXd1RUFEZUVFcFEr?=
 =?utf-8?B?UTJLWldzeVlBMXNUVWRmWnMyMkpXaTA1TVlNK3lnZUZyL1hGUkkxM0wybXlM?=
 =?utf-8?B?V0p2M2tzYlV3Z0kwTVE4UXQ1MGk3empjbi9OTHNxa0s2eG5GRjNYV0dNVEhE?=
 =?utf-8?B?R3F5MTVva0lEQ0tFYlEvcWlEaFIvanJMWFk0SXJBVjNocy9leGRPekM2bFVI?=
 =?utf-8?B?WDd3NWFIdnJvbytjWUVvbE9iRUtGY2dHQS9sVlhkL0xPZTJJSzBJV0FNWHpD?=
 =?utf-8?B?Yjk1QVk1SFRYR1lnMW5MMzNzbUpSTWV4Ull5WmRaemJMZG11RDg3NTFTd0FG?=
 =?utf-8?B?eHV3ejZzQUU1MG9OR1YvaWF4N3VxcXl6MjN0TjJPd3lKTjNqUmhOV0RFQkVl?=
 =?utf-8?B?MXNOK0lUQVFKS1BmSTFER2o0Z3pUU1plcnFFdjd3am5QbFM1ME15OE5pdVF1?=
 =?utf-8?B?U1FMQWgzcHlIT1BnMEFtT0F3OW9ra2ZQWTBGampnRWJlQzNMZVFuWFg3REY3?=
 =?utf-8?B?RnFRWnFYRmdXbjZvdXVVbHNXTnc2NDJUWjZ5TUNLamRiOUdrQ2h5NXorOTlr?=
 =?utf-8?B?YWNuNm5EeHEyS2NWd3VaYkQ1T1EzUmpPcS9pbGRNUTdielFVNGRMQU9Pc3E5?=
 =?utf-8?B?a0p6UjE2VU5LL2JaYitJam50VGdNbXNFRDA1UDJObHdZd1NuR0JVL1l4ZVps?=
 =?utf-8?B?bGRIK3grMGxOZlh4aWhOYW5lOGxqRjhVdmJMUFV3ZEdTQkVWWmtLWjhaVTY2?=
 =?utf-8?B?Wlo0T0VmMlRQdnJzMlR3KzM2WUVJVnFkOEVBS3g3bHREbCtYMzJ1Y3A5OERS?=
 =?utf-8?B?cXBrL2FsR1QzVlBmZEpTQTVYYmNQRTFEV25WWUxKLzBYblVYZ1hvYVByQ0Y2?=
 =?utf-8?Q?qH9lZo8ipbhxu7L4=3D?=
X-Exchange-RoutingPolicyChecked: J0BUZiv0eVgZ5uqxtSaClHozUfFbO8RcsUOPH+qHKw8IZHmaNf4HytKnY0/Ouj6iiIsvCZt60GJsodifbYHTLQY9u1NJyiOVJ3ZVxFmend3xjLkqaG71kGJQjmF+I6zqucCvCc0DXKKlOmRN+yBkS91nuBbYQd3F//41o2dbbSmALNQG1SeBDqAXNxldXTi633qbldh6nKGYBk9kU8wIk0/IbosHkJ3HNVgMAaHnAc8W9dkIQ+PjR7OBakl9tnlgsY6YM5UrBfU1XChK+RSOs69xzBLX48DnRxtOZRCKhD5gCKqrKdbUY2htG/LmDmjGeOGaNTUglpohTBvq6+725Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 001ef269-6154-49cd-a1bc-08dec7ff8341
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 21:22:16.7409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0C+kqmV1Yi5A4Tzm96jui01MQ1ucGkiee0FZhKhTQCNCltxjcjJwuLmKe3EVx2qjrQ5Y91QGu56lvMoPbzU3sdJGZId6EXCtnPbkjsJdKqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8752
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/26 4:19 PM, Luck, Tony wrote:
> I took your suggested commit comment. Did some edits of my own and then asked AI to offer improvements.
> 
> It came up with this
> 
> ---
> 
> resctrl currently assumes all monitor events are enabled before any domain
> is created, because per-domain state is allocated by the architecture's CPU
> hotplug callbacks. There is no way to disable an event once registered.
> 
> AET events are enumerated by the INTEL_PMT_TELEMETRY driver. To allow that
> driver to be a loadable module, resctrl must tolerate AET events appearing
> and disappearing, which requires the ability to disable an event when the
> driver is unloaded.
> 
> Add resctrl_disable_mon_event(). The architecture owns domain lifetime and mount
> state, so it is responsible for calling this only while resctrl is unmounted

nit: "owns domain lifetime and mount state" -> "owns domain lifetime and knows mount
state"
(architecture does not own mount state)

> and for cleaning up any per-domain state. Document those requirements in
> the kerneldoc since they are not enforced in code.
> 
Looks good to me. Thank you.

Reinette
