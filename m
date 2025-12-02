Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83A527280B
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 16:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691615; cv=fail; b=Mzskb3NC2rcztgu+DH+fczLpaWrvpZGr7oYec1DoF09MwuNvvUp8nxZsUoruKzX+YWGaWidBGXxgu1MAEyNXHIP4EzRyWYRmyB3qZg/peo2Y8PhJ16y3yX9m/i+lwRnTAarZBuC/Zv6UGp6a+28d88g1IWP92eEh8pfWOZpQ5l4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691615; c=relaxed/simple;
	bh=l6eHRFKTWxl/qasAl1NiEz7kkenpA6oxoKk4on1udfE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b4KJNXsBip08dLVaoK2fkateXlC0QteBMDiPkbGZDZdZj3C5EvjytCsK486KajQKpUFCX4JKSSaLk7e6a7pgopObQ0K9dDAO2OH6VinbwWLr3BoIuJ54ECaPLKBnWw4gE/f9rNDMjgdHKjV2v6p5OzjSuX0bSamA7Qa5kV9QdyA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i+sK+hF1; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i+sK+hF1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691614; x=1796227614;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l6eHRFKTWxl/qasAl1NiEz7kkenpA6oxoKk4on1udfE=;
  b=i+sK+hF11aefZqDRhDxYFP8qNWCTWKMXVn5vBunxCvWdbXLvRSuO9tLQ
   AQKZlY4ABhpSffZHeVmbfNweNaIVQsOIO23o5N8wj0uERrW2yHFA49Fi6
   BW4onV1OXDM+V5Pr5UIbqr/FsanivniGKk08e9SEaKj5aY+VWb9xGkXUV
   i+NKdb57UfSwYwxD9FZuRccChAZtPMzbCwhgrdxKqwCXfRhaU9fGk353b
   ZpGcICwv5BUWnbbb9L0YzEnCrb0dvab0flKaMf+5st0x9U3n38asQJYvg
   P3kFmCAn+Zmrz1FQxOfhH9uBlwdbN/FWMA1sdhupGIPAYoS4JCO5rt9OE
   g==;
X-CSE-ConnectionGUID: /xiskLkWQtCJnpsrU8Z9cA==
X-CSE-MsgGUID: RgLW6I/qTVa58IpoBWc0oA==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66697807"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="66697807"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:06:53 -0800
X-CSE-ConnectionGUID: Y271/Di3TGm2aWmjJFAVNA==
X-CSE-MsgGUID: gy4WSImnQpO+8cGiAqxbWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="194839165"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:06:53 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:06:52 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 08:06:52 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.10) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:06:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hq+m+r5OX2SnZDyGdAjhzLYttoz3NfLQhSHLnG7T7UPskPjbACaYk4+zd00deF3EzHMXWqoHA+SguepuT3rd/glOPZuejbtL58PWdvZWakBzfPQjudEO2laqgGnCFmBC9Kj3yL27SmndRzK8KTucXK3XdMi1rxp73OIXKNfLsVSVvI1YLjurzWSDgwQOA5NZv20XlW8niZ7vm1enkHRvT4hDYDflzt22jgRl3vO/bF+3+xSiBGMVN6DYVDVHhu8JEJf/lBZQa6jvnHGVug98OyG5qmgcdKa0x+YMbh9hmXKOcOBIrII7VG8Kch9Fl+ZOPumT3eCXUBfHy81XEuYHNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H8gxkZSZs0tkzFvhPwst+iZ0mY3mU6pHcOG/FIoIecw=;
 b=yMTXYm2DoPmYCFd4fr3sWQod93pP+X1qoFxf8XXDClP1STA+46l9lRyRhjew+5JVqGpyhxDSWrSFKMKWFSI3i5Ugpzr3IBabufprI6yT4TJSgjh9BKWD+ae5NTFjdbLFO554Ypk0kWkwDdnhIcS6VRpr+Is9/eShvUBKxa911SsJSl62dOE5yhRTu+h4TuKMfTA7/aOZ5xwKF6v0zgRfegXwpKnmRZUfAM8elNf+Q1v1OdkW+9mlueb13A4aNYjm3RSm42VmwVNtP6WAbjhMaOa4rh6+hYaa2Ur6glrknOpjig7i9ms82zYzAeyMtuuBM7nLRrWsvC9yEbdM/ruhpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPF382351574.namprd11.prod.outlook.com (2603:10b6:f:fc02::1d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 2 Dec
 2025 16:06:49 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:06:49 +0000
Message-ID: <895cee86-ac6e-43e7-aece-e283200384ef@intel.com>
Date: Tue, 2 Dec 2025 08:06:47 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 07/32] x86,fs/resctrl: Use struct rdt_domain_hdr when
 reading counters
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-8-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251124185412.24155-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0140.namprd04.prod.outlook.com
 (2603:10b6:303:84::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPF382351574:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f7ff021-8c52-4ba1-790b-08de31bcccec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T2dWZlFmamdIZlIvWnNobGxWMEFuR2dac1htRU4yZ2JnZmxqenMyWGdReStS?=
 =?utf-8?B?VmpsUVBtcCtLaWo1QUhXSXVLZG1QdHRlMnk2czIwVE9tWkRNZmhraTVZdnNz?=
 =?utf-8?B?WVJFRVVENXhOTnBDd2NmWkVFOGNBK0RNVFBkUWdNaDJZZTB2VXZyQngxRGNI?=
 =?utf-8?B?dVdSRldWQWQwcVdIK0E3bVZIZGsxajVDT1BmMEJzc1Y0Qy8wWTVuZGJBbXpI?=
 =?utf-8?B?dmE5M2dmcy81a2VKRy96MGlyQkovQ1hLQnBwelZPR3lSNHdYcEV0WFNUQmZC?=
 =?utf-8?B?WGVpU29mTjZkNHU1QnpxRlJtL1JkR09lRjdXL1o4WVplRjFyNkU4MFFnWXBK?=
 =?utf-8?B?dkZ2MU0wL3lqdjJUVnE4OXNVLzV0aUE1bE1USUJlK1dVN3M0eUttWkFlanpI?=
 =?utf-8?B?dVAwYmJXNG41aXk4YUZmVHpKSXVCQkw1YmFZME84NVFIUEUwTER4R2dsUHF1?=
 =?utf-8?B?WWIzdnhtSEYyb2pDMkRVWTNYd0N4OHJSMmhqVDlvek1QbWI4bCtoK1Q1KzNY?=
 =?utf-8?B?VTFLYUUrcWcxQVF0dHdZTWtNT0hPUW1TNWtvcFI4UXFOMnJpdmVFU0N2cXAw?=
 =?utf-8?B?ZlQ1K3B2SFFDTVAyeTZZYjU1cHpxL25qejBtaWpiVnNUSWZnQzJBRUlvaHVs?=
 =?utf-8?B?d0JkTGNOSTlEMjVDbHQ0UG9qd1NNNU9qN3pFbTRzOWkydkJHUkFWWjVDY2NT?=
 =?utf-8?B?K3VieGFCK2dDZDdlL0FhVEEwVG9QSVZSZWpjcjFrUVFaMVEzQnVoekk3bVl5?=
 =?utf-8?B?NndxWWhuUVJjeUd4U3NnNGp6ZXZIV1orbXZsb0pXakVKUTJrREJGQTUvQXc2?=
 =?utf-8?B?UHpWQUVSWTNnYjU2WW96QWs3UmJ1MkVkc1MwNnU4Y0NxUkhmVTB6TS9jdUI2?=
 =?utf-8?B?ciswSng4V1NiMUhXalhzUFB1SFpjNHJSVG40U1JJUmhoeDdUZGZJQXg1dzNM?=
 =?utf-8?B?UGZidmM5UkxmVmlrSWhDNHlnU2FCVFZmV3JRWnBHMWxSVlhKVllzMHFvQ2Rj?=
 =?utf-8?B?V25zZEFaQzFlU2NLRzFCaHIvK0ZuTWYrMGZBY2JYcHpMcWhLL3J1Z29JTXdj?=
 =?utf-8?B?WDdDWVFBdXI5WHVEZkg1TUdDTEJUR1VFTWkzWDQ0K2EvWGxXRHBhdWYvRG4y?=
 =?utf-8?B?WmdRNHYxNUY1aGFyQXVMZGwzRmR1ZlhweEU1cGIxQzhtM3doVEg2QWt6UzZZ?=
 =?utf-8?B?c2R2b0dYTDN4aHBLazd6YytpVDRrd2tMcHZMbnFhSk52dnE4dWtrVE9zdllT?=
 =?utf-8?B?bWNtUWhkL3VDOHdFQWhjdVpHSXExTjhkREY4VWZyUXlPTEJ3SDlxMXk1Q0FC?=
 =?utf-8?B?eEtTUkJhU2VVRWUxK3pHR0ZpZEtPZTJ1Qm52bmhVZWpKa0wycW02V2IyUy96?=
 =?utf-8?B?UG5tdEpsalNBUUhJdFNIYlZvUUpiSmhnUGZvN2NpamNxOGt2UnkxNCtXU0FL?=
 =?utf-8?B?c0JmeHlVcDFybVpMaHZpK3d2K042VDRHeSsvaURjYkFBM2xseFVvTEE5cWlx?=
 =?utf-8?B?Q05rY05IZXBVNUFUSWUvY1dRZE9nYjFJaUxuWVFhRktOdUJoRHI4VUNFVFdj?=
 =?utf-8?B?cGtsN0d6a09QOXVtS2JSZGJ3RFNpc0NPOC9HcWNTWW5yMTVjKzYrS1c1QzRw?=
 =?utf-8?B?Z3BiVXRmK1FuL3g4aFJDQTE0RjV3citZUitTb2dKbnpDVUJoaGttdk5FTVF2?=
 =?utf-8?B?blpRMUZZSHRyc2RBeFFaWDdjSjRHN0JJZVN4NEhoT09Zb3hZR1ZubERkRGw4?=
 =?utf-8?B?T2hSM0J6c2ZmbUMwOHUrYVE1cytPTHFub0JlL2pNbEduNWk2TitxcEhYd3c5?=
 =?utf-8?B?Wjkrakw3a3NmQWd0blhGVEpFQlRSbTByNkNRMWNlSi95VzhWTXFJQ1RCU0t5?=
 =?utf-8?B?d3BMUno5UE9BUFFaREhJd2N0VWd6Y3Z6WENKYm9rWWdnNkhUZmtGZ25QbTlp?=
 =?utf-8?Q?/3u31DhVNsTtcMVS7sKNunJk+5eusdmG?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmN0NWlGSmllR3FJbmsxMmV0Mkl4SUdIcitkb2NlV0RiTU85NjZaMlRwMWpm?=
 =?utf-8?B?TDJtWEpOd1QrbkhoQStZZHh2WjlSaGRmV2JkZWdNNTBjMVdXeEJIa3diSFQ2?=
 =?utf-8?B?Mm1Tc1ZyNEtoNGY1QUZPc2RhUTNLeGlVcUVZbGI1M1dBd0JIVTNGa3Q3THcw?=
 =?utf-8?B?aGVIZzhMWnQ3ZGxlemlWS1ZxUER6UC9FRUc0Zkd5YXgyOWp5UENwSlFJVDds?=
 =?utf-8?B?VE9PVUhIZ1VNc2tNZVJpZzZMTXBCRlhUczlKWldOZjZYUGgrL2NEZXpxTWVL?=
 =?utf-8?B?dTRFcUo0cDI4STEreVBWUkgxU2FjT3hzVG1pdWxyT2loK3R5cHZET2dlRkx5?=
 =?utf-8?B?SU1YbG5DSmtlWVdmWHd1aGlNZGRyY3lwenpkdzVCWlVVWElmcnRDK1ZWRDlz?=
 =?utf-8?B?MUh5QUwwekptY2d0Q3czeVcydlhEbG9RdDN0WmMxWmswaUlQY2l5Qmxwa3Mr?=
 =?utf-8?B?ZFFZUGZZSHYyT3RjZmxOdXY2cjhMbGNmbEZRa1liQmNtMU8rSkJIQjRQeGxw?=
 =?utf-8?B?M0dNTnJ3bTladzRHSUtTWTY0STVLcllZQ1lKSGw3VTFaV2FBbXJKMkF1NEt5?=
 =?utf-8?B?YUtrV1IwL2pVZ29tV1hJQTNHUFpCWklOc1FnUU1sZVJFNlNzR25IRkdMRSs1?=
 =?utf-8?B?dVArYk5Eb09TOFZQRXFmOGlOMW53dnlpVG1oVW5zTVZ4WFNGS2pRdjY0c1Zh?=
 =?utf-8?B?YzVoNVIxc2ZJYW41Y0xVRXVVYnVrcEs4V2I3OVA4L2pxSVp0WFVORm5GMmk1?=
 =?utf-8?B?YlBWOHlpMnFxZ0I5dDVnNG43Tjg0SWlyWCtUZS9HODI1YlpyOUlBQlJFOHZ1?=
 =?utf-8?B?Y2ZGVjZHa1o1L3BZeVpVN3NuMTNXUGtxSXBOOXhiVzg0UkxUVVlabWttK1BL?=
 =?utf-8?B?T21KMThKckNzbUVVRnFqdU84Zi93cmlTb1pmZnorOFJaTEdxRFA1dVZxaVRv?=
 =?utf-8?B?WlVlM24yQkhia2YzL25RZnc3TGZKUTVESWZwMmJBYlhmUk44TFd0Yi8rMmJO?=
 =?utf-8?B?Y2o4eDRnRUtsUXE5MUNoTUw1eWcvTUY4THgwcEJoUjVRQjBERWJuV1pWTzlw?=
 =?utf-8?B?aTZobzMwRDYwRFd4a1RHYlJleVcza0tPM3V0NkNFOEpqcmFQcVhMbDh0WXRS?=
 =?utf-8?B?MWpRNEgrcytXcXo2dDltdE41SzhBaWZJQ1ZCUWlJV3dTQnF4STd3VjRpYzBk?=
 =?utf-8?B?YnRxeDd3NTlvMEI3bHFNeFI2UGgxR3IxMmdEOHkyNmNzK3V4TFRNTXViUWJO?=
 =?utf-8?B?YmU1V2FjbmZVMlRmbS84UWVEdFFBN0RKL1dNVWJXQWhWK0J5d3pOL0YvRlNr?=
 =?utf-8?B?M1pTMURhaklBKzVTOUhmc0hoMGpjdEJjYm40NGFBWWxtNTAyMkxROHd6cXdM?=
 =?utf-8?B?bmY0eTNvWHNnanc1L2E4a1QrMlRZdDlQVFcrWVdlY1FtbElhODlJTnc5MjIr?=
 =?utf-8?B?Z0R1UmtCaHd4QUlmV0kxakMvZkNHbzAwejFCRFdvV2RETFJkVFVJbDF1YnVT?=
 =?utf-8?B?czBCT2xHVmJqSWcwdU1YVFpYcnI4cFFuTWdRaHZPcWJjTkVHUVQvbW02YjJU?=
 =?utf-8?B?NDFWak5ranRIZE5uZE84RStORmpVdkkvRkxIbWtnNklnbkFkWEJVQU1uLzIy?=
 =?utf-8?B?S0JKVmZEZy9GWllWSDlScXJDRnpxSkMyVWtPcSt1RjBLZGoxUmFoYzhtaWIw?=
 =?utf-8?B?MGZPRlpYckI4cmNCNFI4M0xpQmQ1S280R0x6QzJMTmpZYld1Z3BlSXYrZk9R?=
 =?utf-8?B?TWxyd2dGYlRKVHZYRlBZZXVnWVZWQkpXTEZ2L0ZHQytkNkdMYmIxd3NiaFg2?=
 =?utf-8?B?UTZiNzgzU25hbGtBVGU3ZGZxbm4wei9IMkpFWmJyYzVqTysxVzZpSkRMclZ5?=
 =?utf-8?B?SnhIVmZHRXhZdlVEcXFnTG1ZUHRUc054aFhOanJESWorSmVZZm5adkZYc3dD?=
 =?utf-8?B?d2plZm9GL2l2K01BR3YvRW1hMm9LOVExVjd4dUFZQUFhY21zZm1QQm9OQXpP?=
 =?utf-8?B?bnZLZGlLQTE2ZStHRlRwYi91OU4xU2g1MXVMbW41bGVvWjVQOGxmWExJd3pp?=
 =?utf-8?B?SjRoT0NTNTcwWlJPd0dmSDd1N2ZCR2p3Q2tjQ09qbTgrZUJicEJxYjArWFNi?=
 =?utf-8?B?eXZDUTVjVTM4bDZYbFY3cnp1Tys5TThyam1zTGNNTHBtY0ZsRjRnakR5MndJ?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f7ff021-8c52-4ba1-790b-08de31bcccec
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 16:06:49.6268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jENqZMIRFEg9+SgRFlYgf1kmwTgKE24uAhGQoo4GXBLMckZ6jTnmkHbAxbu+36txc8FM/NOnoTATi+UU/oHDmd/+eOpdXyadPJelCgoo80I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF382351574
X-OriginatorOrg: intel.com

Hi Tony,

On 11/24/25 10:53 AM, Tony Luck wrote:

...

> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 179962a81362..7765491ddb4c 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -159,7 +159,7 @@ void __check_limbo(struct rdt_mon_domain *d, bool force_free)
>  			break;
>  
>  		entry = __rmid_entry(idx);
> -		if (resctrl_arch_rmid_read(r, d, entry->closid, entry->rmid,
> +		if (resctrl_arch_rmid_read(r, &d->hdr, entry->closid, entry->rmid,
>  					   QOS_L3_OCCUP_EVENT_ID, &val,
>  					   arch_mon_ctx)) {
>  			rmid_dirty = true;
> @@ -421,11 +421,16 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  	struct rdt_mon_domain *d;
>  	int cntr_id = -ENOENT;
>  	struct mbm_state *m;
> -	int err, ret;
>  	u64 tval = 0;
>  
> +	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3)) {
> +		rr->err = -EIO;
> +		return -EINVAL;
> +	}
> +	d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
> +
>  	if (rr->is_mbm_cntr) {
> -		cntr_id = mbm_cntr_get(rr->r, rr->d, rdtgrp, rr->evtid);
> +		cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evtid);
>  		if (cntr_id < 0) {
>  			rr->err = -ENOENT;
>  			return -EINVAL;
> @@ -434,32 +439,41 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  
>  	if (rr->first) {
>  		if (rr->is_mbm_cntr)
> -			resctrl_arch_reset_cntr(rr->r, rr->d, closid, rmid, cntr_id, rr->evtid);
> +			resctrl_arch_reset_cntr(rr->r, d, closid, rmid, cntr_id, rr->evtid);
>  		else
> -			resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evtid);
> -		m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
> +			resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evtid);
> +		m = get_mbm_state(d, closid, rmid, rr->evtid);
>  		if (m)
>  			memset(m, 0, sizeof(struct mbm_state));
>  		return 0;
>  	}
>  
> -	if (rr->d) {
> -		/* Reading a single domain, must be on a CPU in that domain. */
> -		if (!cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
> -			return -EINVAL;
> -		if (rr->is_mbm_cntr)
> -			rr->err = resctrl_arch_cntr_read(rr->r, rr->d, closid, rmid, cntr_id,
> -							 rr->evtid, &tval);
> -		else
> -			rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
> -							 rr->evtid, &tval, rr->arch_mon_ctx);
> -		if (rr->err)
> -			return rr->err;
> +	/* Reading a single domain, must be on a CPU in that domain. */
> +	if (!cpumask_test_cpu(cpu, &d->hdr.cpu_mask))
> +		return -EINVAL;
> +	if (rr->is_mbm_cntr)
> +		rr->err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
> +						 rr->evtid, &tval);
> +	else
> +		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
> +						 rr->evtid, &tval, rr->arch_mon_ctx);
> +	if (rr->err)
> +		return rr->err;
>  
> -		rr->val += tval;
> +	rr->val += tval;
>  
> -		return 0;
> -	}
> +	return 0;
> +}
> +
> +static int __l3_mon_event_count_sum(struct rdtgroup *rdtgrp, struct rmid_read *rr)
> +{
> +	int cpu = smp_processor_id();
> +	u32 closid = rdtgrp->closid;
> +	u32 rmid = rdtgrp->mon.rmid;
> +	struct rdt_mon_domain *d;
> +	int cntr_id = -ENOENT;
> +	u64 tval = 0;
> +	int err, ret;
>  
>  	/* Summing domains that share a cache, must be on a CPU for that cache. */
>  	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
> @@ -480,7 +494,7 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  			err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
>  						     rr->evtid, &tval);

This is not safe. The current __mon_event_count() implementation being refactored by this series
ensures that if rr->is_mbm_cntr is true then cntr_id is valid. This patch places the code doing so
in __l3_mon_event_count() without an equivalent in the new __l3_mon_event_count_sum(). From what I
can tell, since __l3_mon_event_count_sum() sets cntr_id to -ENOENT and never initializes it correctly, 
resctrl_arch_cntr_read() will be called with an invalid cntr_id that it is not able to handle.

There is no overlap in support for SNC and assignable counters. Do you expect that this is something that
should be supported? Even if it is, SNC is model specific so it may be reasonable to expect that when/if
a system supporting both features arrives it would need enabling anyway. I thus propose for simplicity
that the handling of assignable counters by __l3_mon_event_count_sum() be dropped, albeit with a loud
complaint if it is ever called with rr->is_mbm_cntr set.

Reinette

