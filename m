Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF435158D62
	for <patches@lists.linux.dev>; Thu, 30 May 2024 20:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717100673; cv=fail; b=DQEaoRyjuokL8/U4mZ8rpS3MaPtNERBUPLR5BGdnnS+FboHVp/f1UYrlBml3QkFkXcrT7cwRnqerq5jenWsK8674dCT8Mp7D6CGafl9QVROlhu/V/wX/Jw8h9UmghjDeCDghTUKpjR6U1+vjMFrz6Oow7U6+1aTZQe7VpvG8ocQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717100673; c=relaxed/simple;
	bh=LlGVTBYVD1bUeKLrnx7KyeL4O5/CDAYOYQWgT3sPx+0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Uv1WmykB05/srvrq8gBZ41tuD0qF/AEKj9/DfMbfFBn984CsHOxLwhvhT71LjRDbVg09h63r3MhJDi4++blh1l5usfwzRMIVixANjBY87Q7+R0VO8TNoqtOspSnfKdgQHYrMxZ3OwIBxqGJf/2k/f6SFrzDakHMov9lzj+5IZmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oFPh2fIS; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oFPh2fIS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717100672; x=1748636672;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LlGVTBYVD1bUeKLrnx7KyeL4O5/CDAYOYQWgT3sPx+0=;
  b=oFPh2fIS9+WTw2rKkko1JuO6ryRedmhLRet054FYbC3b9TPbdNpifjaN
   w7R3AYYuEXO+3ps+i7Wo8h+QoLBpA1667mX360eqyS0l80PvITMugzU+G
   0gagmEULhHbWl25DD9G4kyYBNtXT6dg6HR7LdMRpLLJmKpuA1s/Maagik
   r++dJS6IpNtjTY0/xJPlMHqN8QhJm0PkPvAWFvko9vBu1kGX6NFhiPQIb
   XOmWm11dkOoZNLfSJH5UMdGwoI+6vGzBN5Ru97PV/b8xVk1akQQyc9jJ7
   uxIdnLetsdrbIfkkEZf1+xtr5A2j8UjccTX+XeSRL/zFpSOAfrqRfHz/9
   Q==;
X-CSE-ConnectionGUID: WnFd/cvtR7KufZonthjYng==
X-CSE-MsgGUID: WuWOHXBuSBiirQLaVrtvuw==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="17461072"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="17461072"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 13:24:31 -0700
X-CSE-ConnectionGUID: UnbVA6GaSr6b16artCCS+A==
X-CSE-MsgGUID: 0QdjDtgISAql2vDo8APoDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="40390421"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 13:24:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:24:30 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:24:30 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 13:24:30 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 13:24:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLLBooB1ava2kbO4q+BUSGcuTe9rb5OhXqHgm6SKB+QLLXudpNWyzSjXtzvWw045rgRs5CGm9G4vNOHQ/yjA78EWOtvfJQTXcOLcCO4bzONjmlPBbLV5iWc3/hx+cmix36s3jrT+O+BQmTo+e7JrY84YW7ZLOibBfOhD/auySIYx2qRB9+/y4m2R8irgN7tmD4xvpludQIO3Fh7D9N132Mo6m/Cx61ILt+tKYoybMpIlUPzeLrR9psj9vopBX4/VwKi+eiqzE9I/ymp35uAx/LfSc+fwMImW1+x3kBoK88n/eyPzVXJw31v2V/+rJ/fEUA+GFCGSojW5eRvt5V5opA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OqF0M1VWeKQIWAdD9yML2UHPAhDAeDNJY755nZBdHW4=;
 b=PSOTI3nrb5qrpALoHv40RzUHvmEPmGJiHqx44z+kaMknM3MfhOWQnqp2h0Oo19T96cQp8DN2FUqZjomUBDmOT6vMstE9Y948vPLk6d/SJ9FR2joa1Z7PEElm4kfLdN3cyooUgNr3mR2xhkeCiXzY2gh3KlHt+b4PTKVyR/ukAACc2zw5XXRzawHWO9fLFc1AfU44Hv/FOoZf4jLkcNM0DtX7HnYV3t3Htc3pUuK1LhxLWgU7tg1GT7fZhI39FAX7eIUbO5vaQtnn+mMFrCNn07BJs20oiShu+ZpislP17qAUfVGU6aQLtK0UOX2cePxVuKgB3J4EEJhNShFeMZ/ejg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB6772.namprd11.prod.outlook.com (2603:10b6:510:1b6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Thu, 30 May
 2024 20:24:20 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Thu, 30 May 2024
 20:24:20 +0000
Message-ID: <ccc29a33-d2c5-4aba-a530-240d17ae94e4@intel.com>
Date: Thu, 30 May 2024 13:24:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 15/20] x86/resctrl: Pass two extra arguments to
 resctrl_arch_rmid_read()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-16-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240528222006.58283-16-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0115.namprd04.prod.outlook.com
 (2603:10b6:303:83::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB6772:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f49f52e-6b43-4296-275a-08dc80e67cb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bzZ0OENYVUdCT2VtS2tUd2ZDWUQvNWdmZUp2dFQ1Q2FhaUtUQkthYTdWNkgw?=
 =?utf-8?B?aWtRZnB6Z2hDenVMcURTUWNYZE80cXBLb21WMXpRbCtVRFZ6WXJoQXBncEl2?=
 =?utf-8?B?TUFNcnk0WEx0TzMvdzVBbUZUTUhyb0h6VkhWRldzNnVGMExTS29yTGdWSGxU?=
 =?utf-8?B?RU5wQ0cwRUJocGl2dlI3elVXZU4ybmlzRHljL0pwREdSeTRRU0dWeHJpcU5P?=
 =?utf-8?B?WFFoRE03eEZtUW04c1ZLcGZJZ1NTU1p1TXFuZGpMMEtkZG1LNW1SRkhXQTNv?=
 =?utf-8?B?aSs5YlhxWFZtQXg5bGh6Mk1ScjlOSkdjMjBCNkRzbkFxVGZFNDFhRmZZdENY?=
 =?utf-8?B?OGYzQmpYamRURFdZR1FlNzJsOGdzaFhFSVlQc28zUWwvTEE1MWM1RU5OVFJM?=
 =?utf-8?B?SFVDQVJLb2FiS3BWSmdveU9RZTN3M1Z6OG9WV0lXTUFaNEIrQU5IeXpuMDUy?=
 =?utf-8?B?WHRJc05TZGxrTU9qNEtXK0dGaGNqQ0c2WU5TRGxuL0ExNGMxNFJsSExranhJ?=
 =?utf-8?B?cHBQTVc1cnd3YXNSQ2tTNFE2SVZsL2ZYTkdLY3JuVFQyR2xLb2NwSXB5Mlhp?=
 =?utf-8?B?UEdUTSt0WlhPd0M4RS9ZcytWL0RwM0JyRy8wZHVUaDRvV2syRXFGNGpmb0dp?=
 =?utf-8?B?dEkycE00dHpHbk5IbVZzcTg2SE4zZVNDcmlFUjVKUTJ5Y2lMaE9UWmpmNEpW?=
 =?utf-8?B?NzEvWUJRaE5jaUcrRXV6MkZod1NabjMwcXA1Q2pUQnFKY3hHMFQ5L0RXckps?=
 =?utf-8?B?eTV3RW5CMVd2K0M1NUpoUXZ6a1lHZnVFZ0NZWUFYRTZqb2pKOHZGSG1JL3ZN?=
 =?utf-8?B?TGVGcHYzTEdMdUdzR0ZXU21aWHNZS0Yzb3FMbEpxL1BnejBOTGF0d3RGN1Fv?=
 =?utf-8?B?WVJBM3dGZUtUUGRrYTBqRzRkeGhxWCtjeWwvc1E5T3NZUi84MmdSQ1ByVGs2?=
 =?utf-8?B?MWZLZUQwWmczSDZQYUI0Q05mKytXQkc4ZzYyS3NubzZUamZhN1hERW81SmtR?=
 =?utf-8?B?d2p4QkdhNWZzVG42SjRmTG9CQmJuRU1ickZzYml6aUNPTitSWjd4Umdlc1lK?=
 =?utf-8?B?SWlYalJrSlJya3FwbUZRWkxwMExXclhiL204bVRvU3F6SVE1aG9VNEs5MmdL?=
 =?utf-8?B?WVNCQTFjVlVzVUw4cHFMR3cxNThlNlI0SitDbUhJTi9CMm9kM1oxMnZWNGZF?=
 =?utf-8?B?K0VucHlXWC9uQmpqRjh5em5DSWQxUlcvT0ZKckduYzg4WW8vdkFJcVU1M0JO?=
 =?utf-8?B?RTBha2Yyck5QWk85dXRna29rMmU2TzRnUjNSd0NPbW1LblVja08yc25aTnd3?=
 =?utf-8?B?Q2lnNm04UFhBblhPSG1wV0NFMUhpM3JZRU04cnBKOGNyZW92ZmUxdFRrYVp6?=
 =?utf-8?B?Vnk4dDZTVnNyUVVQSzZVMkZDMFNDSWV2SG5iZ3hBcGFKSlBjalI1ajJmSno2?=
 =?utf-8?B?VXFaZ2lXZCs0TEYrNElXdFBUcURoZVVCYkN4aCtYWjdNMkxJVFI2QnBoVFNM?=
 =?utf-8?B?dTZ2S0VwbSt1bWNQdkpDZE9aZ2JYWUZxdEs1eDV5NVU1S1JBV3UwZjVmc1RB?=
 =?utf-8?B?aTVyNldUeVlEb0Iyc3VmMHpGSGcrQy9najB4MXZIcEo3K29tMTVySy92eDla?=
 =?utf-8?B?Z1Y4UFVId25NMEZaTjlaSElHMWtMZ1EwcFRoWVBKYmIvR2lPTGovWVE5SDVx?=
 =?utf-8?B?bXgvVnJMSmt2ZmUvUXZOVERRTlRiZlNVRCtPMmhDN1M1bE1nMjJyY3NBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THMwNG0zcEJMUnQxUUJlTldWS3h2ZVQvT1lXaDhVMmdKRGRNZlNsaS9sbWlW?=
 =?utf-8?B?cjZJRktRaWZJVnRDNXNWMVE2dWphU2ZrenJRQzlHUWZ2ZExqNGVwekpSSmxw?=
 =?utf-8?B?VWFlVWpmY2xWQnFxWkk4OGJvUFpNWEhPS1cyUzhtaW5nL3VlT2NnSHBESVk5?=
 =?utf-8?B?SG4yV3RweFBhcGJoRWw4ZFZZT1hPSnl6b1pPc3dPYldrTzRWUSsrOG94bzFE?=
 =?utf-8?B?YUp5SnUxa2IzUXNJcVRmUStSZFZNamltek5IVzJRQWNBMjRjRHVGTEFhOHRX?=
 =?utf-8?B?M09nY2twNFVGOTdXdWZZZFpFcGxtTTBMdS9abCtnV0tWWkcyZmJDZDgrQnM4?=
 =?utf-8?B?M0NNamhVS1BhcTdLQlpmTkJsOW16eWE0TmtUVCtOQ2xpTjdxMHFuSmg0VFI3?=
 =?utf-8?B?ZkhTa3BUSkkvb2R1ckVxQnN4RmxTbVJpNG1QUnB5WFlROTJwTUZiVlFkU0lx?=
 =?utf-8?B?R3FtQ3BScTVaOFBnNStKVEpZekNWb1RHdEZKZWxkUTkxVlltT0d5SWRaOWs1?=
 =?utf-8?B?RjU3VkROSm1DbWZpZjBEa0JCN3ZVU1l6YitiOER2S3JZTFQwTWFQUGh0Kzho?=
 =?utf-8?B?ZC9wZFdXTWxtNHQxZjRBby9DUHRaL3BENmpadVhMMlFxT2tRc1FiakNVUytz?=
 =?utf-8?B?NVY4aVk3K0k2aks3dnQ3TUlUZy8rMkNMMzNJcUNob3B2KzdXazdJOTNlSEVa?=
 =?utf-8?B?ZHphZ0NKbE94UXVjMjNIWTRBSFplWVhJWnpRRzNzcHRMWTcxWFRLUU1DU21I?=
 =?utf-8?B?dnErNk9WK1NZUDRZRGV1aWNsZ3Q1RGhMUkxIdkF5clk2cXpESmZUM2RDZ3Vk?=
 =?utf-8?B?YldaTG5QQldoYjJ1aFpHRmRaWVZ1ZFlEVFFjYjlJVVVoRC9xOVZCb093WXhs?=
 =?utf-8?B?K0RtYXJPMnN6bUp2RWNyYjBMZzl4RkpUVUdOU09FTC9JSzRsMDBGbStnWmdt?=
 =?utf-8?B?ajQwTnkya3F0ZEVuL2xLSjBLZkprRGUvMTNIQStydmpWUWhxUHg0cFFDR1E4?=
 =?utf-8?B?ZXd1ZnV3dUVYVEZIN0Q3cEFUd1R1K09na1g3T2VpR3ZEYXJNQzRlWDJIRWUv?=
 =?utf-8?B?Y29DYjZCa3pDNFQrWUxIbEplT0hrQTBGVXpDcUlZdnVTQXNjVEFEb3Myandq?=
 =?utf-8?B?Vy9rY3FWazVTVm9VWlJSMEdkQ1doODg4TzNIcTNRVVdGMkxvTWFodXVmdW5v?=
 =?utf-8?B?ZHZqeHhmY1BSdHBLNG8vcmVQVzJZVzRNREdGMlJjVVpsNTBGeVhYMXZ2VEJw?=
 =?utf-8?B?ZysxRjErRnFKdFhnS2M5aWZ3RkdycFZDcWUwQ212alEwZVkzeEdMZmtNWks1?=
 =?utf-8?B?dXo5Ymo0VGFyZ2lHaG1iN3AxN2JjeEtiUjVIWTl1aUM1K2pnVnExZDF5bENy?=
 =?utf-8?B?K3ZWNXdCakxVbnZVQ1JBazJVbXk0NURCZjZRbXZrQUQyS2FHTTYvQkh2VG1W?=
 =?utf-8?B?MTdSMWc1KzBDbU9YclJYdGE1TjdhMW1pQ0pjbHVxZkJNZGFWeG95YVN3ejY0?=
 =?utf-8?B?VmdIbHA0RjRmSWdENnpnNFhYRHV0SVJRbXBvQzJsZTg3cE9iU3ZuTm5tMEYr?=
 =?utf-8?B?dGZ5b05LTFBWMlpIN0lBakNBSVFoYVNoeWdBUm0rT2JscXZqeS95ZHk3c2lF?=
 =?utf-8?B?YklrZWR2bWZFQlZ3Ynd1a3I5MUFYR3ZhUmZqazVtcDltcUN3MXdIRjZMTXNT?=
 =?utf-8?B?NU1EVmx4RjJVbEZ6ajM2YW1wZ2xVQzRqSGt3cE9WNlZkUmtUVmhUTmhuMEtn?=
 =?utf-8?B?UzA4Ym5zZEQ0TDJ5QmhxYXdPQndBQW9QNVRnMkgycDgzc054SVRlS0hXV0d2?=
 =?utf-8?B?Z0dzeTIzQ1hZTTNDdllzL2hVelpObVJCd1BUajg3SDNCZ3hZeVhCWSt2dkFo?=
 =?utf-8?B?ZnBodXZhU0NNV2doanhYWDUvQXFDTGhrM2dHL1hVU0k5emIxVU9DMUlrckFF?=
 =?utf-8?B?SnR1TTA0cVppZTEzNkFvTjRqaHluN2hoMUJyZDVlODhMRHpJZG05K1ZNekVJ?=
 =?utf-8?B?QlRac2RzS0V1NWUrU1h3NW03cHI5c3RsdzJIeDExQ3dkU3kxM0tSWmdVK3hR?=
 =?utf-8?B?MzI1MFY5UkQrOVN5bit6MlYwUnYybXpuOGRSdkpML2x0T2NiY3plK0xERlJT?=
 =?utf-8?B?TElJelVlMjdCUm1YNmxkSHB1UjNJa0FJdStCeThrWG4rSWhuN3FzU1RTZ3RO?=
 =?utf-8?B?WVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f49f52e-6b43-4296-275a-08dc80e67cb0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 20:24:20.3839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: glaZMX8Bx9v6+J3BWt3xL6Q8XyAd+y8fFMMtaWnQcMtYskh2INYVxg/0+cNHq/wjVNqN61eUXc1brnf7FY4+cexphbxVSOTprOWY2AqUrGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6772
X-OriginatorOrg: intel.com

Hi Tony,

On 5/28/24 3:20 PM, Tony Luck wrote:
> For backwards compatibility on Sub-NUMA Cluster (SNC) systems the legacy
> files in the mon_L3_XX directories must report the sum of data from each
> SNC node sharing that L3 cache instance.
> 
> To make this possible, pass the "sumdomains" and "ci" fields from
> rmid_read structure as extra arguments to resctrl_arch_rmid_read().
> 
> Note that the call from check_limbo() never operates on a "sum" basis,
> so pass sumdomains=false, ci=NULL.

Why is passing "sumdomains" necessary? Can it not be inferred from
domain being NULL?

Reinette
