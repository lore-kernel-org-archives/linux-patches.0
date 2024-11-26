Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835C01DE2C6
	for <patches@lists.linux.dev>; Tue, 26 Nov 2024 18:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646498; cv=fail; b=TjTAFORFqyLM9iCR6YNCc3KSvuBx5HS06jrmageikTlF5APvOzusPXVvHdCYDpj2fo2CC3QXCwxqn6KJRRMZcuoGQYCd36g+ixFDFjTw9qpKhYGza0hiHQFpGxqjheT32EmFBNWl3jW+ngTxq3V+WikmWbDkwf4HHbQYzPWhV/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646498; c=relaxed/simple;
	bh=0+dDolKkvKKDflka+NOLoDEyHK3l4ndRG4s7UjZxhp8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RoOrEFVdrcFXMjmOSwxmX02iOaK4CeU80Jk9h8+12JuzGFZKpcKudoJrj8+tYuJDcPcS6Pmb0MQ2Gpd9fXYp/Twlz9XHW1DFttMkAsQhcT3+IUYlsNz/y0UnB+uvIsztvaf4OJaSRFsRMHqHAjae2bZSm+83S7uLwJI4447WvLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HJB+s1ey; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HJB+s1ey"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732646497; x=1764182497;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0+dDolKkvKKDflka+NOLoDEyHK3l4ndRG4s7UjZxhp8=;
  b=HJB+s1eyNl6lNOdk8z6f/d9rPTR/Atn3ni3v8IjZwDN1AEc0/q41WkUg
   2Xqx7MHF7pjpA7B5CDM/VgEP6UPwMqaYeblk+Gr5Dr3zfSuqFeCNfyjI/
   BtYsKsamNMxVwwPJvm8lplNfy9Q/ECxoMxuMc8USFBQtDrj4cRCI8Ha+d
   OEL7wKFy4yIJCVBV+r4CBCtRv8D95mTQZXv3gvA7p73S+UJw8fxD2aOPh
   lYgFpE1mhk+JZRIRrBEui5xnuMhohlHwG31o4D+0BTD0e7l0K/CeE3DQQ
   pWt0RKf6490B6vTHTM4kGmzgeO8WyjyZYamnniAbUiTIPkwZyw8XOBuT3
   Q==;
X-CSE-ConnectionGUID: RAYTgJdAQ2SgiUxg2W8EKw==
X-CSE-MsgGUID: PpPvUJOTTnSIYqty5voTsQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11268"; a="43894252"
X-IronPort-AV: E=Sophos;i="6.12,186,1728975600"; 
   d="scan'208";a="43894252"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 10:41:36 -0800
X-CSE-ConnectionGUID: 2yKRllT6QnGE4Znu42watg==
X-CSE-MsgGUID: biXs0ha8SuW8u9ah4yH4uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,186,1728975600"; 
   d="scan'208";a="91594798"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Nov 2024 10:41:36 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 26 Nov 2024 10:41:35 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 26 Nov 2024 10:41:35 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 26 Nov 2024 10:41:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tWYKtBghqvH3lWJakcS0O80OaAyDk6qSfE3bll0QQ7fRDx9lpP8J6SRzcMogfk3K1lGML6zFSLpEQzAR2W1PXB4uyHQBDN9k5QcKQ/PsIqZEq2iPwYlyKxXlF16TYnj5zR87iMxPArbV5Y/WE2b/tzg8IDc8o0UE/92tAWVdyzy1Awin29ovkumumdM3iCBSBRNPu7YHdWhWs/dXOzlKMTSzvz4tFgl3fXonZZHS5vefC6rmnLCWVokUTz1gqgzgu8aC2XeYxlpsvvdW05WWzDBnDnDzMVLqSYWOFrMK2zCySkz+URTF+wthn+q91qj3NjMKLTv2VAK0T++zmuBZTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=peQiaMCZICyHJsFZehUdTG2zyM48IQsA2+KvWCgs96c=;
 b=LKRZ54q3mr51Pg4Wsjie2C5PwB7zbm+yutTi9qAPID/PSYu3DF6C68X8uFx/WQCAR4E9f+qjpTdG5XO1zeG3MtDfLcRU8KsZJDzQ3mUEE1qXkWmDZnP0onGhaI228cEBDJiQFWVzQfwcSxA17YK+dC2IRdf+draSXzYZ4g4G6mQ3L+6MGqxjKQ0M1bLc465XBXA1XKeUwgLGhfWTqvjSeSX1lQ58CzcPw6b1iobpvCUnsUzh8pS8eb+EaHnBCyySFuYOQexE7dCErevebG7+5Esf432YK8ZVkEJaX1LA5nGtwnMa90ElGEqtPq/5+P+GpjCvfI+grY5O5C7gicdlmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN0PR11MB6058.namprd11.prod.outlook.com (2603:10b6:208:376::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Tue, 26 Nov
 2024 18:41:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8182.018; Tue, 26 Nov 2024
 18:41:26 +0000
Message-ID: <07e35337-45e4-4c44-ba58-62938ae6ea8f@intel.com>
Date: Tue, 26 Nov 2024 10:41:24 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 7/8] x86/resctrl: Add write option to "mba_MBps_event"
 file
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241122235832.27498-1-tony.luck@intel.com>
 <20241122235832.27498-8-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20241122235832.27498-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0096.namprd04.prod.outlook.com
 (2603:10b6:303:83::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN0PR11MB6058:EE_
X-MS-Office365-Filtering-Correlation-Id: 90e391c4-c06b-4328-fda3-08dd0e49ef0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L0lmNjZiMEdYaXV3ZlMzL3owZ1hjbEVzOFRmNmxiS2l0QUtFUGhKVUEwMS9w?=
 =?utf-8?B?ZzRZWCs5ajYzMWJZODZsL1dUd1lYTC91K0llU3JmR3Y4V0tEMUsybWdmWmxH?=
 =?utf-8?B?ZkRXTU41R1JxRktnZG9uYWVGMStTWkIyQ3dtalNHVE92d2pDTHBKYVg1SHZz?=
 =?utf-8?B?RnN6dWZLMGlrRXFEazI1VWtkNER2ejJWOW50eVlDb2FIaERMdUg5UnF1Kzht?=
 =?utf-8?B?U2tjY09kNjEwY2xjVnZ0OHZlZk1QWHJ3a0s5eEtBcFBhOFJnSEpNR1orS0tP?=
 =?utf-8?B?WVhla0hHQ2ZEcnBHUW1pR0ZYK0dGSnBQeVRkZDN4UlNCWXRNd21EcC9MVGFP?=
 =?utf-8?B?TXk1U3cvbzIyY1BBa1VKZFB5Q014WVBPMit2bGVLM0x0K29rSWdjVFM5bG9q?=
 =?utf-8?B?dlBQNWM4K0tnZ1g1ZjNGK3ZmUitXVHpqNklpcEcxalFNbzgrazFBVmFQYUND?=
 =?utf-8?B?aHJHQ3R1STMvdXk0bkJ2MW1KNVBXR211NTNDdGdWZWhDaElYNk00VDNFTkVE?=
 =?utf-8?B?MkxyTmZWWFZnazVSbVllWTh6anE1eHYrS25KQUtJaWMzdksrRW51Qk1jV0px?=
 =?utf-8?B?QmRmeGdINFpOaFlUdU84QXZjT3R0M3NIR2k2MXZSU3dOV09KRnVGUTB0YzRM?=
 =?utf-8?B?cFFreXhPaE1XWGU5Z05KWnArNTJXR0RtYThETUIzeC9rN2c2TzhxRkdLdFBJ?=
 =?utf-8?B?Vi9DU2FBRXFJQzl4QUFwRW1iSGlRb1UvWkxxRVhWTkZLM25ud1ZSREV2eXhU?=
 =?utf-8?B?RE5xNVdxT0JoRXpaVFZVZWtkWE52aGhaYkNLMHJodU10a0ZFSWQvL3daTHA0?=
 =?utf-8?B?ZndKdmxqTlVBRXRwd1QrK2k2ZUxEYk45T1JzcEEwcnRId3lpUyt0U1RTNElL?=
 =?utf-8?B?ZklqcEZTa0hqR3pGVEo5VzEyVHBocjQzNkZBUElpbkRGeEE3M0xEYTM1OU9H?=
 =?utf-8?B?K3gxNFB1TnJVdW1FNmdtZ3ZidkhiYnhJaS9WT1V3MVpXakpDOERRZFRJS1lo?=
 =?utf-8?B?WUhPMDVZMkl2UllhUy9jd0prOFBacHQ3Vm02T3hWN0trQTJzVnpldVpYN0ZL?=
 =?utf-8?B?cXRGcXBPOXRoQS9BYU1DSTBZR0pjbWNVRzF3TU10MlY0b25SZDRHcnhnYlh6?=
 =?utf-8?B?TzRsaENXSGMwN3V3dENHTW9ON1VVMkxZVnNibEliRTQxTFJ5MmY3ZlkwcHlD?=
 =?utf-8?B?Vy9rZ25qMFdIUmc1NTB1bmp6emhzd0hKdVl5TGU1QmFPNTBFcUFua3dPQ0kw?=
 =?utf-8?B?V3IzT01VbHhpTndCV3VKUTZSRHUwNmpIRHVjbFlmRlR3M01uMjJJaFRhS29l?=
 =?utf-8?B?SEhxUmJnaDlSUUx0R1JnczBsTENGT2pPOFQ0ZWQyNVlXMUxuMDFEeVl3Ymxl?=
 =?utf-8?B?N3JrMjl6enMwdjBWZjhVV1o0N3hFclZnQkVDT2JCaTJycmJVUitXd0twbElz?=
 =?utf-8?B?Y2ZKbnMrWWdGSFhzWG95ZWFwT20wRSsxVlZNZU5XNkY2cU5Oc1Jsa2xJUGRQ?=
 =?utf-8?B?amZPQ081SzhWaFFENVFKTk5ORXF1UVR1V3JuZjJ6N3JHcWV1ZVZ3dlFVUmpy?=
 =?utf-8?B?S3F6QTRlUUdpVkloeURCc1NuWTVQNnNoakEyVVhlVFU3bjFIZm5WRWUyY2ly?=
 =?utf-8?B?TGRpTWZYN29hbjV2WFRHMCtOUzJ6N09Td3o0Uk54ak5EK25mSzl0NTg3d2Yz?=
 =?utf-8?B?VElWUEFtVGxFOEdKcmhVL0FGZ2I5MUpIdnA2bDlJcm1uNFdDQlhnOXh6NE15?=
 =?utf-8?B?S2ZSeVV4NlFFbFpKaHFHbTNOaCtmQk1qUnppOTY1Tzc0aDR6bUJoUTlVSytE?=
 =?utf-8?B?Z2hIOFRQa2QzVG1wSVBadz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkFVV3hiMDFEdzBwenNYZSswSHhpRm5nYkdqODhOYXdNSnArWWVoMmowbVlY?=
 =?utf-8?B?K0R3QWxPd09PVVFkRTBMU2Z2bEhLS1dUcTlGdVhEQmVuSGpYaU5FeGhDYmlU?=
 =?utf-8?B?RkJpaXVuUDQvNTM0OElIbVU4TXNaNWczbHlod3BiMlQ2UmdXcjRKQXRyVTVk?=
 =?utf-8?B?TFkydlNjRklMRm80WFl3cDRpTFZQd1NQT0xZTjdUdFhlUVEwUVVGSTZNaU5U?=
 =?utf-8?B?cytGNi9GK1dEdzFOSjBXQUFkWmpzdHA3V2lCdGNJa3hTUHBHejFnZk1Zbnp3?=
 =?utf-8?B?Z0luSTVGTnVZUjJwaG1ZbGx2dXdmaVgwR0wxeUdMbnlvNktLS1pHT1pKMUpL?=
 =?utf-8?B?aUJ5aHR3cWdjWXhNNEpuNGZMM3UxR3AydFFucTJZbC9reGo5RGYyVytkTWxB?=
 =?utf-8?B?dzhWcmFCTytqOGQ1TUszbUhKK3J5bWpzV1hEWU83c3ZmMDAyZDh3amV5NzN0?=
 =?utf-8?B?d2R3MVRsK2ZpM0ZlRlRGUHJKSTh6VURwOTJER0I3eHBwK1h5SlhmYXZZbU9U?=
 =?utf-8?B?eGZJMnVYWndIOFpGV1RSN0JLbHhoUFR4UHBxUFNuTkt5cllPemtGVEtrRG1G?=
 =?utf-8?B?Nlg1Wm1CUkUvZzlUcGE5cmdCVW41YjI1QlA2ODkyQXZsKzY2a3JVUS9QYWpU?=
 =?utf-8?B?cVRKV2tIUWNNSzdFOHJPR2FDSzRsSHZhWEhyQlR6WHVBYlBsYVU0MkdYSHVI?=
 =?utf-8?B?SWN2SXZFaUdkM2lMWE1Md2JidmFVaTJVOWxtUEN3Vlo0OHEwL3Q0TGQ0ZVBi?=
 =?utf-8?B?MEI3MDIvaVViSEp0WlE2dlVXM0d3Rnp5dXNPYnd0QzIyMzU0S1pjbzVkSlk5?=
 =?utf-8?B?dHJOamlkQkFJcFp2b0g5WHdwNitibnE3OGo5eDJrUXUwb1Q4VFFtMVREUkV0?=
 =?utf-8?B?b1J4UXI0Qlg2RFJRR2QxUjhOY3liNHg5VjVSSG5WalZpYTQ2NUMxTVRheHlk?=
 =?utf-8?B?QStFNy9Gc29zSFdqRWdYZFIyc0twTW1rSDc2eHVDdDMzYndOYUptcThxekls?=
 =?utf-8?B?VWpOcFI5V0oxVVhSeU9ZeE5IK1FvU0tFTkh2S29MZ2s4bElOejY5RTdiR21z?=
 =?utf-8?B?bDR6aUtCQzBDWmIzbTByVFJMcXJZd0Y0bWlUc3d1YU04UnIrRVhIazJadTZp?=
 =?utf-8?B?a3pscHh2YUVEakhpRGE5YnBzbzN0ZUVETmVsOW9kZXE3UnJ0bjFQSTVOL3Va?=
 =?utf-8?B?L1dCVk9vYTJWbmcxNVl1cFpoZDh6UDlKdzJ1UGpVM1pxSDgvdndoWjhXWFpl?=
 =?utf-8?B?UGtxb3hLaUJmUEg1UUY4NCtTUmxsR2dPakNhNEZhTFdUREVpNnBzeU1kU1VS?=
 =?utf-8?B?S1grRlV1S3lYS3JvaXUrRzNETk5ZSGJHTGIzMWlBVzlLRWNhRTdvc1hJbGRl?=
 =?utf-8?B?L0J5UUNqQ09oVllSdTVld2htT21TL0JhN1VwTDA0Z3kyN3pSTmFJdXZHcElZ?=
 =?utf-8?B?c3dKajFoWVNxcExMSXdxRk0wWlRNZXRJMW12V2oyejNWUlhsZVdxMWwvVkJm?=
 =?utf-8?B?Uk5hWEN4eVFVSmxzeVlBcmtLNUZzV1Y1MG9HQ2w0bGpNM0ZmRjZKN0t1ZVRL?=
 =?utf-8?B?SU9menB0Y09OK0NvYjdZQ3B3U2MxNktSeDBtaXloYzBsZDlsV3hkbTdXdXha?=
 =?utf-8?B?eXhiSUladEFMbUJUdG13MlJhUnBCZnp6SEFSNzdyNnpXOGp0WS92L3FYb1JC?=
 =?utf-8?B?SitITmZjNWYyK1ZsVWNlTnI5Wk9IRHN5Wjk5T3VsVjRQQ0JQUGlUTWxTOWhw?=
 =?utf-8?B?Tk8zN0g2b3VFSFJST1NOZkpnRXJJTHZFVWxsVUV0NHVNVDVvYk5SZnBoalY2?=
 =?utf-8?B?a2FyOEFHQWdBRGFZQTFpYW8zVEJhRU0rQWRPYVY1WnBGc1J0MzhIUkhjQmlL?=
 =?utf-8?B?USt5aDNNS0Z0eGRyOTluUjh4bTRGY3pubkRqR2N6S1dBVEhMUEFUejBzTmNB?=
 =?utf-8?B?VkliM05tT0gwZmg3WlpEQVBjeVFGejdFZmY5SW1XakZuN3UyRWYrYis2Zkpq?=
 =?utf-8?B?bmd5ZHZ2R081dUovWXJQVWtTOVIxRmRCdEVJM2xSc1Jva3FKVnEwZWlOM2dP?=
 =?utf-8?B?Y1NyU3phdGwrL3h4SWxPNkpaWGMxNGRSYzlqVlluUVVTbk95R0dPY0YrT3FL?=
 =?utf-8?B?OGppaG5qTmpGY3I1REhzQ29xM1hpKzVBN2dGTFNKM3BiWmwwbURyMXBFcDBu?=
 =?utf-8?B?ZGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e391c4-c06b-4328-fda3-08dd0e49ef0f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2024 18:41:26.4438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kdcmE+3OA4pPI7O4ypYrQtsyGwMlR85MbUhbVvBbJZYy+uaUd77U60mxxME+zuYB8ZKQM1vOlcEilZk3CbnFpYbxPsZ6wd+nrAWGtRJNUvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6058
X-OriginatorOrg: intel.com

Hi Tony,

On 11/22/24 3:58 PM, Tony Luck wrote:
> The "mba_MBps" mount option provides an alternate method to control memory
> bandwidth. Instead of specifying allowable bandwidth as a percentage of
> maximum possible, the user provides a MiB/s limit value.
> 
> There is a file in each CTRL_MON group directory that shows the event
> currently in use.
> 
> Allow writing that file to choose a different event.
> 
> A user can choose any of the memory bandwidth monitoring events listed in
> /sys/fs/resctrl/info/L3_mon/mon_features independently for each CTRL_MON
> group by writing to each of the "mba_MBps_event" files.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
