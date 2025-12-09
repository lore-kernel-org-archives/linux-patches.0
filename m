Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B443C306D40
	for <patches@lists.linux.dev>; Tue,  9 Dec 2025 19:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765309389; cv=fail; b=qooznWUD0NIwIN3Dhzm0prUixqY5yxHzHdHA0m2I6ZU9JU0ESIQ4lXNZm1/MfD878snoFqc2YwBMBK7CBB5myw6AviiJZLFit7tPthhUFmuuxf3vpGCGHMM0q5g5OKD9FaJ5nZMhUlsYBnpOiUDJX/24cvw5WSFtewiXFK6+b6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765309389; c=relaxed/simple;
	bh=ceqG9iicPYpkBZn5XjuYRwj0HHT9x2MPGCnkEwoGGKo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lwSsq3ROl/EwN+M6n4lSO+2+DWS9vjL/Oos2Xl3puoX2obpOxFZOaFk/pke3OsKDH2HJSG0rWpo2T1oDS1q5UP0Jg4DvYmAx4FKmuJc7E8qsy6rBJzukRhbzGWdXNW+lDe3AYBGMsi/yHTWq7zbzG+U2EeYEBmlW8N39SZkoH4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=luDOr7Ub; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="luDOr7Ub"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765309388; x=1796845388;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ceqG9iicPYpkBZn5XjuYRwj0HHT9x2MPGCnkEwoGGKo=;
  b=luDOr7UbgPidBAW+IVNSjnNoEOlQN+DeBHFFtSfLFlOjdQ0IuFARJn7G
   npfCMDdjzG6nx9cnchr5KAFBfOe36OP+Re5ZnqZFkAcgCIqHtlFVMKD+z
   Cx0aGL8kI9emPyO6eD1o4KDclPDRljhT5xtOV8mnFI/FEhPGgpiaTwx8s
   yOFIeOM77nItDtN5/5iUVHsz4Wrc8uJkcEZ+EWjhtd34HpsL5dzdjaGi3
   PdMJTEoo9qz7c9PGjgMhV44b1A9PQ0d3Jai8/kHJ2jNT9oy4Eui66fvU8
   mIaC5YWIB+H1noV2pPfrFXeofgev0tm40D4Fl/Nu9iZQ3LMNUPktSVd78
   Q==;
X-CSE-ConnectionGUID: dA1dtph4SGmx7xm/J1EDog==
X-CSE-MsgGUID: U+oOUQGsSayw26mCgqkYIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="67326801"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="67326801"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:43:07 -0800
X-CSE-ConnectionGUID: jRUZa64WTdadgfDrJ+YEcA==
X-CSE-MsgGUID: NRv56AlORWWrDiOJnMF3PA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="196222215"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:43:07 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:43:06 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 11:43:06 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.54) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:43:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hAt6GgUbnvaaQEBlnZgi6B4N10vtpu/bO0kcMI/caKD0TfUZupiTtsxiQWA/9sQoULFR7FaQv688wHUmw6w4jlDd1rpcQvtY+mq1EfXwTGO9ThOAHhuDDVEge1kfE5HsAMRmJPc8e3OHk/el99/Rwl74U/ZI2Pn45F4adq9TeMiF5/60A6xAufcZKK2lg+HIDBHnnmt9kDVAo7D7FNUE6bxQlIdH15i+CjEa1pKtPeteHE1vvrwv6SqY0lfrH605vOliYvO0TgPxw+07g8D37XAF9qoAU8ReIT55N4XJJULF25p49RMzPUc+IpEcW24SHbZWp9zTOxGZ2HSPO8HQGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P0j9tVcooiANd2kQW0mQRZBVwScBmGhk/2WcnX+SVa0=;
 b=If4r1jln/y9IJctdPxvPjjDL57qXRqxnFykesCyy3aMu3ygD5CWMP8yLc1j7Wn20w474hG1m/svCSMV9THhkLLbjIKpGLnb5vX45b+NSa6RfzUEEW5q6dWwYmWiHizCXpe5sNrFh1+vwgevm4fQ+qK+Yp0BfqW+NYJ38+VS9XkR4koxDmp70SkH+wv2FQGNxjSpXRbUx0acygsdumzsfdd96tVAk/t/DjITUvu7DH0HkTGh3ybPw9Y/m9kykWKGNTQYBiSoEoRIwfUx+osROGQhDwwwqNEEJXXghcrZjX0pyPJodsjdG/I3zCAdjkFEWWbD8V9VuR893Z8wrilX0Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB8152.namprd11.prod.outlook.com (2603:10b6:208:446::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Tue, 9 Dec
 2025 19:43:04 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 19:43:04 +0000
Message-ID: <af1cd3ed-e847-43f6-9459-d2d74ee94c88@intel.com>
Date: Tue, 9 Dec 2025 11:43:02 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 25/32] x86/resctrl: Handle number of RMIDs supported
 by RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251204205404.12763-1-tony.luck@intel.com>
 <20251204205404.12763-26-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251204205404.12763-26-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0122.namprd04.prod.outlook.com
 (2603:10b6:303:84::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB8152:EE_
X-MS-Office365-Filtering-Correlation-Id: 7421eace-18b7-44c2-a3d7-08de375b2b4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dFdnYWpZeUE2WUxjZ2dXaStFb1pIZkJaejhVMEErakFyOUJRRUVZd2k2L3BE?=
 =?utf-8?B?elZ0U29sdDU5UE9XSDgzSjllOTRSMGNadCtwcFJabFl0bGM0WUhFcGZSb2Jm?=
 =?utf-8?B?NFl3dVZtWC9YcjlKWUlmcitxUlJzZmNmd3RNa1RreXZaSnRYa1lZbzZQQ3FG?=
 =?utf-8?B?Zzh6MWZJNDI1MlI0eDZnWlhCTThKL25GcmZFdmo5WmgrZ055azVWMDhuN0xJ?=
 =?utf-8?B?RnNJNGxvZFdyU2RVLzVmRXp6ZG8yUXVQQll1Rzk4OXFkSDUraTNUcDlmcFJl?=
 =?utf-8?B?M21vcHM1K3BDWkVJSEQ3RmFsVENYWWVMY2c5T0E3dUlsWHJTeElyL0lEc1RU?=
 =?utf-8?B?bEFjSDBubjczc3hhYVRtTHRacmlldHdNN01QSHQzRUZQV1pLOThyL1F5TkJW?=
 =?utf-8?B?Q2hZZlU1NFNNZVBFakJvT28reTFkMms0eHJuOHdCa2tEZkNtZVBBOTc3MnR2?=
 =?utf-8?B?VkhhQnNIdVcwV0xGWnJZVjhQK0JOMWxnQmo3VjdSNkNRWUlJekhESDNUbVFT?=
 =?utf-8?B?N29kbHFGbmptN2pXelc0R011dysxQ2RaZ2pRV1ZhRnZrYU5FaDBWa3lHdVlv?=
 =?utf-8?B?ZW1xUmp0RnFGSHpEZDdSUk5NZTZCNi92VnNwK0pvbml5YnBZYkJubjFEblJj?=
 =?utf-8?B?ZlVSWDZsVnV1NGVsZmVRWk9TMkdrTURhVCt2N1lYY1NNSGtrZnhRTDlPVzZu?=
 =?utf-8?B?My95VEVrQUs2K05BVVJsdy94Vi8velpSM0xYN3YvWWJ3NnJCVGtzZzBTN1BR?=
 =?utf-8?B?dTNxYjZIZWE5ak54TUFYa21mZ3ZBNml1Skl3UW5GM1VJbGgreVF2TUFnZnNK?=
 =?utf-8?B?MlliaXhFelRVMkdNZStDMldvdXVzckxuNktsVUJRaWlIdTZXb2NQdEdvU25B?=
 =?utf-8?B?TlZqSDNJWWpnMnV4elFCdXYwT2xxazgxM29md2hYQllwR3hmNFhNaS9zeGVz?=
 =?utf-8?B?R2k0L1VEYlpmN3hERVhQUE56T2V5anh5aW90SjRoTDEvSE55QnVKRXB4N1BV?=
 =?utf-8?B?MitoM2hGNGlyWnFYQ1U0VDkwWjJuSHY4Z2UxL2RpVE5nSnZRVTI5a3JGckVE?=
 =?utf-8?B?cGFxQnRCL0JmRTRVSE5yVVhvTE9rV2ltT1c5b1pPY3JmRlZUNVRWeVFkVTgv?=
 =?utf-8?B?eitFY1BjRm1ab1JneTZLLzhiVTRWM2dERklGV25PWnV1SnN5M0tFc0laRUVp?=
 =?utf-8?B?K3FYa0RQTFV3UUxJSVQyNFpNU1pmTXlqeXgzZWZyYVNzM2V6b1B0dFRHUENK?=
 =?utf-8?B?Ui90SVRIVGVEUGdhR3F3SldQSUc4eWJQNmFPNWJlN1pPY3E0SmpTdG5tN2Ew?=
 =?utf-8?B?eUJnaG1iVUEzdFJHelN4N2QrV2xsWHowYWxjVThmbXRsTW9CN2I4eGZ5Z3Y1?=
 =?utf-8?B?NmNwc1A1Sm9ac1hNN1NvZjZlaE4zWFhrSlJWY0IwcFZCQThpbzBSMUdYQU44?=
 =?utf-8?B?T2kzTUc3NjVPNXJKYUZOcGk4Unh0bkNBZHhkc0NodDBMS1ZCU0c2UFgrSmtE?=
 =?utf-8?B?Q0tqdU8rekY2L2tEVmoyUmlISEsrYStJa1VRam0rQWJ4K2QzY0RzWE1aMldP?=
 =?utf-8?B?YTU2b3JQUmRUUWY4VGRqSGx5TjdYaFF5UTBuN3RNay8zNXJhQmhVSnBaSUM5?=
 =?utf-8?B?NGcrN3RxOHVvSDlOL2lKb0J2UFM3Z1ZlMXFFM1pldmd0Szg1SDgxZXVqUmJI?=
 =?utf-8?B?TlNHUVZzOUxicDNpY0UwVER0ZzVSdGR4Y2JhOVo0SVVBMWs1dkQzamZiWGJa?=
 =?utf-8?B?OEZrMlNteWVCdm5zM2xMTDh2aDI5enBKWUhZRTN5YXJTaUwyQmpnLzNYRWI3?=
 =?utf-8?B?T0tHNk5wTzVzbWdFRHRzQXBIcE9FSjRiNWoxNCtFcHRPMTVZVWs0cnlHSmJT?=
 =?utf-8?B?bUZvdVFFM0U4azI1RDlWMXkzV2hISHJYUDlEdjArcjZvTWxQWS9CNFJTSFpE?=
 =?utf-8?Q?gTPB5mKCbi+yscOYJt04tPtA68gDj13X?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUVxYXRoakxUVkRPemxDdmlTQ01jdVlQMmk0d3Q0aFpCTFZPTG1rYXc1NUJw?=
 =?utf-8?B?ZDY3cVgxRCtwT2RTVzQwS2R1Zm5UOElRYVNGeVBzdThjUm1TcHF2aXBKd0Za?=
 =?utf-8?B?QWsxdGs2WGtxallQWS9TeCtWRjAyR0FKYWwxc2J4c0p5ZWdGSk0yVEk4MGZo?=
 =?utf-8?B?cUlFaS93Yjg3UldDV2tOOThXdjVoNU1IWWlOQUNZalVFNlJCSnVFaXl6UTl2?=
 =?utf-8?B?TEs2blFRYTR0YmJQOW1aa05xaHNxc0ZSTW5aZEMzdEhmYmFqSHovcHRUd2dj?=
 =?utf-8?B?aFJQeU12Z1VBcjY5Zm5vT2g3WmFZNnFaMWhrQjJZN2VHL3FWOEN5WEQwcVE4?=
 =?utf-8?B?SE1MaUQrQkxNOWpycFp2SjQ5cEorUUNDMWY5b0w0ZGN3YndKa1pnenZxY0FP?=
 =?utf-8?B?WjFBb0JrYUJuQ2xKZWJGMDV5aHFJWjFwOVJoT2pIaDFGU2hFMldEQjk1Qm9m?=
 =?utf-8?B?TllSRm02YUFHNDVMRUpwVFcyRUxSQkpWaFoxTS85ckloRkNuK3ErSGk5dThG?=
 =?utf-8?B?MjA3VkI1dTJoYzlqejJ2VUFBd2FnQWRHelVmYUhCbElkUC9mdTBGbmI5QVEy?=
 =?utf-8?B?enY1UkdVUGRxSG9JemZSRjJ2RmhXZEJCSnhPZDA5QnFtekh3K3JaQk5FbE8x?=
 =?utf-8?B?VmIvUGlyeHNnMXRIY3J5ZnRMeDluUGFzaGVjOVhja1J2MWo1VysySlFZWkdI?=
 =?utf-8?B?K3dGeWx3R0g2VllITEs3NEd4cENSVDMwMk9KNFNEOER4RlpqdTdvQjA5Smlu?=
 =?utf-8?B?eEtCRVlkcUtMb1J4Q1lsRTg1SHJEeENUMlZzTGFqRWY2UE15M20zU0Ezcmow?=
 =?utf-8?B?ZDdnQ0djc2xtQ0xxNS9yNEZ5am5wRXJDRXlOMU1lMTJpKzdtemovaldJNU4w?=
 =?utf-8?B?TnF6ZkN4dlpyaEpDN3IwZHNISGdKWHBEVElwb1gyMjFoTTAwdWlESjIzTFVi?=
 =?utf-8?B?UVR4aUJXTEEyZXNkcHU5bk9uQVFpd3o1QjBocVAyRm9hNThQQkNCVFNlL3ZK?=
 =?utf-8?B?dG42Mlpvb1l2MjBoNHBpUzNSdGdaSHhnZVhtZDJJODZ2SHpKZWVqdWt0cHpN?=
 =?utf-8?B?TVltTnM5V3A4cVhXMGUyblpDL2RxR3MwMk9DTkEweVVJc2xxV0FBSE9yTUdP?=
 =?utf-8?B?TE9HYklhcEVRS3JpcU9ETnJId2dlS1p0NjJjenBzNDhpYko0RlFpV0U0TlpX?=
 =?utf-8?B?L2l0NHZWZG1QNmVCSFBnNndVelJHQ0xNMHIxbjNFTWl1WkU4ZERaMzVZTjRE?=
 =?utf-8?B?SDhCcCtxRWZ2aUxjQVAzTU1aRllNdzdmc2FXempOc2VOV2M0WmErc21LUVQx?=
 =?utf-8?B?TGd2ZHdMUDh2MmxoZ0VYckVCRkdoM1RBVSs3SVhmTDQrdTMrbDIrR3huWUk0?=
 =?utf-8?B?VFp0bDR6aEE5ZmJZVXg2dlNKT0hDYkYwSVFCWHVZN1l4REE5UllnVlRtM29I?=
 =?utf-8?B?TFNWMzJOVmJMMXhRWU1nb2lhL095dUVvNDBvZnNHelYzdFk4YWNIUWUzQ2ox?=
 =?utf-8?B?SnlJUTZnaGxHeDF0TGkxTDFNRmlSaUdyZHladkhZV0VwVEJPWFEybjY4ZTdQ?=
 =?utf-8?B?Y2x3c1VlOUUwOXppTVV5bWVQZ3cyZ0paditSa3NrNTF1WHVNZkwzN08vNzho?=
 =?utf-8?B?VDNJR1NCVS9aZXR2dDFvcjN1NnE3L1A4ejJyOGFpTlA1ZnZ2c2M0U244V2h2?=
 =?utf-8?B?eUtTUE5pMlRmcHY0SE1nc0xEakJ3azlUdkk5dnVIYzg0VXFOcDRjMENYRjNs?=
 =?utf-8?B?VVE1NHZ1cUlENFRZNmo2U2xzQjB0SEdmVzRDUW85Z1lWMlVaZWhBL3l1T01o?=
 =?utf-8?B?czZjWkFZWDJRV05oN1lPV1pXcGdLMkh6Skx1Y0FHMnZsZUJPQkhiQ1RCQU1Q?=
 =?utf-8?B?NE8vNVZWdmV6Y0JyQ3EwdzYzMkduWDRFbkRvSlEyUWUvYUx5VEhjUjg0NFFt?=
 =?utf-8?B?aFpGcElLWFlYVEsyTjNuT3ExWCs0K1pLWWhMNHY5bUViaWJReHI2OUlBanBQ?=
 =?utf-8?B?aTZNZlQrUFhKZ1p6ajg4OWFMWWwwcFFwZ1VKWVhaTkI2Z1dSdmVFY2tJdzRz?=
 =?utf-8?B?eE1lODlna083ZDJyTGg5L3RHYWNMYUtaMDhyMTRyTnYyWXo2bGxMd1B2U3RN?=
 =?utf-8?B?MG5BWmJmb2k1YzAwODhXNDRkWTAreUhvU3B4eVZFUXNDOHVOd3JscG1YcVhl?=
 =?utf-8?B?WUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7421eace-18b7-44c2-a3d7-08de375b2b4b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 19:43:04.2207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vFyfZmyozzHREG43+pQbeI8EofZkiNyIC2dvRekmKQl2ChlEDPuq494P5wXMvcgeltZTq/qWNs1hpYBbNS/ltqc2kJUBJ00Kn2VtgdSzf3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8152
X-OriginatorOrg: intel.com

Hi Tony,

On 12/4/25 12:53 PM, Tony Luck wrote:
> There are now three meanings for "number of RMIDs":
> 
> 1) The number for legacy features enumerated by CPUID leaf 0xF. This is the
> maximum number of distinct values that can be loaded into MSR_IA32_PQR_ASSOC.
> Note that systems with Sub-NUMA Cluster mode enabled will force scaling down
> the CPUID enumerated value by the number of SNC nodes per L3-cache.
> 
> 2) The number of registers in MMIO space for each event. This is enumerated
> in the XML files and is the value initialized into event_group::num_rmid.
> 
> 3) The number of "hardware counters" (this isn't a strictly accurate
> description of how things work, but serves as a useful analogy that does
> describe the limitations) feeding to those MMIO registers. This is enumerated
> in telemetry_region::num_rmids returned by intel_pmt_get_regions_by_feature()
> 
> Event groups with insufficient "hardware counters" to track all RMIDs are
> difficult for users to use, since the system may reassign "hardware counters"
> at any time. This means that users cannot reliably collect two consecutive
> event counts to compute the rate at which events are occurring. By default
> such event groups are disabled. The user may override this with a command line

"Disable such event groups by default."
(imperative)

> "rdt=" option. In this case limit an under-resourced event group's number of
> possible monitor resource groups to the lowest number of "hardware counters".
> 
> Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG resource
> "num_rmid" value to the smallest of these values as this value will be used
> later to compare against the number of RMIDs supported by other resources
> to determine how many monitoring resource groups are supported.
> 
> N.B. Change type of resctrl_mon::num_rmid to u32 to match its usage and
> the type of event_group::num_rmid so that min(r->num_rmid, e->num_rmid)
> won't complain about mixing signed and unsigned types.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                 |  2 +-
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 57 ++++++++++++++++++++++++-
>  fs/resctrl/rdtgroup.c                   |  2 +-
>  3 files changed, 57 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 14126d228e61..8623e450619a 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -295,7 +295,7 @@ enum resctrl_schema_fmt {
>   *			events of monitor groups created via mkdir.
>   */
>  struct resctrl_mon {
> -	int			num_rmid;
> +	u32			num_rmid;
>  	unsigned int		mbm_cfg_mask;
>  	int			num_mbm_cntrs;
>  	bool			mbm_cntr_assignable;
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index fec4bb781f82..38fcddc72ed8 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -22,6 +22,7 @@
>  #include <linux/intel_pmt_features.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/io.h>
> +#include <linux/minmax.h>
>  #include <linux/printk.h>
>  #include <linux/rculist.h>
>  #include <linux/rcupdate.h>
> @@ -60,10 +61,15 @@ struct pmt_event {
>   *			Valid if the system supports the event group,
>   *			NULL otherwise.
>   * @force_off:		True when "rdt" command line disables this @guid
> - *			or architecture code disables this @guid.
> + *			or architecture code disables this @guid due to
> + *			insufficient RMIDs.
>   * @force_on:		True when "rdt" command line overrides disable of
>   *			this @guid.
>   * @guid:		Unique number per XML description file.
> + * @num_rmid:		Number of RMIDs supported by this group. May be
> + *			adjusted downwards if enumeration from
> + *			intel_pmt_get_regions_by_feature() indicates fewer
> + *			RMIDs can be tracked simultaneously.
>   * @mmio_size:		Number of bytes of MMIO registers for this group.
>   * @num_events:		Number of events in this group.
>   * @evts:		Array of event descriptors.
> @@ -76,6 +82,7 @@ struct event_group {
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> +	u32				num_rmid;
>  	size_t				mmio_size;
>  	unsigned int			num_events;
>  	struct pmt_event		evts[] __counted_by(num_events);
> @@ -90,6 +97,7 @@ struct event_group {
>  static struct event_group energy_0x26696143 = {
>  	.pfname		= "energy",
>  	.guid		= 0x26696143,
> +	.num_rmid	= 576,
>  	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
>  	.num_events	= 2,
>  	.evts		= {
> @@ -104,6 +112,7 @@ static struct event_group energy_0x26696143 = {
>  static struct event_group perf_0x26557651 = {
>  	.pfname		= "perf",
>  	.guid		= 0x26557651,
> +	.num_rmid	= 576,
>  	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
>  	.num_events	= 7,
>  	.evts		= {
> @@ -199,6 +208,24 @@ static bool group_has_usable_regions(struct event_group *e, struct pmt_feature_g
>  	return usable_regions;
>  }
>  
> +static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	struct telemetry_region *tr;
> +	bool ret = true;
> +
> +	for (int i = 0; i < p->count; i++) {
> +		if (!p->regions[i].addr)
> +			continue;
> +		tr = &p->regions[i];
> +		if (tr->num_rmids < e->num_rmid) {
> +			e->force_off = true;
> +			ret = false;

Can this function just return here? 

> +		}
> +	}
> +
> +	return ret;
> +}
> +
>  static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  {
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> @@ -210,6 +237,27 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  	if (!group_has_usable_regions(e, p))
>  		return false;
>  
> +	/*
> +	 * Only enable feature with insufficient RMIDs if the user requested

"feature" -> "event group"?

> +	 * it from the kernel command line.
> +	 */
> +	if (!all_regions_have_sufficient_rmid(e, p) && !e->force_on) {
> +		pr_info("%s %s:0x%x monitoring not enabled due to insufficient RMIDs\n",
> +			r->name, e->pfname, e->guid);
> +		return false;
> +	}
> +
> +	for (int i = 0; i < p->count; i++) {
> +		if (!p->regions[i].addr)
> +			continue;
> +		/*
> +		 * e->num_rmid only adjusted lower if user (via rdt= kernel
> +		 * parameter) forces an event group with insufficient RMID
> +		 * to be enabled.
> +		 */
> +		e->num_rmid = min(e->num_rmid, p->regions[i].num_rmids);
> +	}
> +
>  	for (int j = 0; j < e->num_events; j++) {
>  		if (!resctrl_enable_mon_event(e->evts[j].id, true,
>  					      e->evts[j].bin_bits, &e->evts[j]))
> @@ -220,7 +268,12 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  		return false;
>  	}
>  
> -	return skipped_events < e->num_events;

As mentioned in earlier patch, this can just be "return true" from the beginning?

> +	if (r->mon.num_rmid)
> +		r->mon.num_rmid = min(r->mon.num_rmid, e->num_rmid);
> +	else
> +		r->mon.num_rmid = e->num_rmid;
> +
> +	return true;
>  }
>  
>  static enum pmt_feature_id lookup_pfid(const char *pfname)
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index ac3c6e44b7c5..60ce2390723e 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -1157,7 +1157,7 @@ static int rdt_num_rmids_show(struct kernfs_open_file *of,
>  {
>  	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
>  
> -	seq_printf(seq, "%d\n", r->mon.num_rmid);
> +	seq_printf(seq, "%u\n", r->mon.num_rmid);
>  
>  	return 0;
>  }

Reinette
