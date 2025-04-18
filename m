Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91C420296F
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 23:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745020087; cv=fail; b=ZFtSTqBKJXmWOZVmy6R9SQAijIB1iW1k54LPNTpYj66j5Z5LaMKzsc92qF3H2ohcThI8P/WFSywLzrLbwHew2XpfZGUsHf3N3JI996FmK3b1Gh6uWSDU568RMCi9t49g7sKp7G4CLZJGqe444XQI1TLvUNgzopDzWOnc/atvuqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745020087; c=relaxed/simple;
	bh=qmbLurkXaXe7RdHXVtOSrTEtTzI2Y1U+blg8kBrc+Yc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HA13DtNdQcuwOKwdFc7EnrB5DApZY6zgfi2GQulRzrK4DTKBjdMvgKPSMZ8zKsoKDVlNb+odfe6Ix92VdXnfrS/sPwMu2/hfEDvQ9gsGd1Jpb0tWJIYtgxcJR3v5U2Y7CkpqKp/ylJobSnpkWD96IR3y9mq7aNFsqGe2vuXuZ54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nfn9A+wT; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nfn9A+wT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745020085; x=1776556085;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qmbLurkXaXe7RdHXVtOSrTEtTzI2Y1U+blg8kBrc+Yc=;
  b=Nfn9A+wTwbL/zgD+63rXQl+9KlMpWkQ+Dd6xwvqdr7YEvN2MVj4b03Tx
   gXfJUyPtlATRKSre9Bg4a4vPU2Ccy8DaT1Edy6FTC2Rae1gR/+I8MYyjl
   c9NaitQAMA93R6C2YkWPz+fDTLXdGlmuifHvrkFBKtBGJ+U/ZH1Op9VtV
   GPpiPmAJZyjZ7e1JHggCuu7wYuuUC2Ae6xNAEcNF3EzOAM27MAHu5Dxbf
   kw512K9xscKgZgsqasuq9aVD0ZGAczz8BGQe5bVKkEuhFXQ4R9g26ulQh
   vhKC3He9huI1n4XowL3eqmF3UIvJC2t/JlcL4PqccoJk4e84afWJxuFlK
   w==;
X-CSE-ConnectionGUID: TAJrzjmNQQqeRNYsiRSxIw==
X-CSE-MsgGUID: JsPx9UmjTdeen4poDSbBTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="46825671"
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="46825671"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 16:48:04 -0700
X-CSE-ConnectionGUID: cnsWyeTRRYKspI/X2ubY2w==
X-CSE-MsgGUID: 0nLEf53iS6eEWKZyq5qRNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="131181126"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 16:48:03 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 16:48:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 16:48:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 16:48:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U67YzJboS5z6cqt4VrwvqKVoUMlf3h4Hujeo6lkm28TwpUSKqHRQ2CNjQuMe2B5Mp7HTIfiqRrRGwtOQLfQDnG90K8ArqvBLtzWMCj+H2bHEYNUttmH0uyxZOrG5Ao+djmBHrnxM3C67YmNnxAnwuFnGdhFo2VhIh7y7DJNDxrG1uXM6BpiPJ8n7YfQJ4FrQAuCy00tY9QLJ7P5pcgIBUfZ9nn+eY7MerCj0/JlasP1RRcpUyl37CppTMmsPe+JXf2yEJrGxVxmAGAJbrejGM3fmKwyptygeJ57/USFBJ6/AjLQlM4Shrx7El1dFVoxKeiAJuDU1Xy/bbzBJhxecIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfXMLKY4tomr4Ccs5lLqVetqN5KMD7akQbBxZeujLWY=;
 b=xlBfLna5SIUUepS7VCLsKmN7KpHgz3JcrRoXdX2niAzqd/CvOATCTd9Q2rVYiwn1GzVgBnHk3Wp+EyQMNpgsJIO8Lq7rmvP+SjpLhZByk88wvX7z9BT8uSsVeMyhL8eVM1aRG0Sjb6KOGzv8o0UCUcX6o+/eA9Z6DvOfELuf1X5EMpGuOPtOLmjXy3/DMT66DWb+XMmhkP6w7rTmwFbjfx8X35cPKVLl+ECEs2j30lWdvu0zJybD1ZJpgG2uG/rw4XLelZmpRBT3/CeU/Ify7eulNw67HGR0sd7hf/9ZBD3m6T9qd6Sg4md2OUT5m3xnvNc50iUVr2TQ4MdU+SwpxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN0PR11MB6034.namprd11.prod.outlook.com (2603:10b6:208:375::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.22; Fri, 18 Apr
 2025 23:48:00 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 23:48:00 +0000
Message-ID: <ed7d0612-7b90-4a41-9740-7d4d04f442b2@intel.com>
Date: Fri, 18 Apr 2025 16:47:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/26] fs/resctrl: Add an architectural hook called for
 each mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-14-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250407234032.241215-14-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0002.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN0PR11MB6034:EE_
X-MS-Office365-Filtering-Correlation-Id: dec4aa51-bbdd-4369-e2c0-08dd7ed3739f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?enZ0NlhjcnRmT2VYMlZWMmVHczZPNzlxZW1uU3Y4ZHBOMlR0Q3F1TkV6SjJV?=
 =?utf-8?B?ZEdqb2pFMDNVcWtQK3RGcjdSVWw2T2pvVkRLMThSRlJ0ZkEwSVhNbVVQSG9Q?=
 =?utf-8?B?NE5KWm9XdkJXWmhOOUNBWmlBVzIrUGR3SXoyL1JoN2o4V2pDVWoyMU0vdXpI?=
 =?utf-8?B?TXYyb2wzZExBeXN1Tml6ekcwVWRkZjdURk9Wd3NJbmdkT0FmVUVFRG9TU2lo?=
 =?utf-8?B?azd1eW4vL1dxNVVNS083K0FxNHJHQzRmWWF0L1N2YjZLOVFIV1dJUlZOKzJJ?=
 =?utf-8?B?bCtTWm9BS2NWdytMaFFISm1iMi9pam5ERmFweVRldnMvenlLZXUwNlZkcDRH?=
 =?utf-8?B?czhlRjBYTEovR1VuZkRGTXhMR1Z1OStPdko4Qy9lZEFnMVM1bXhsV2dmdEQ5?=
 =?utf-8?B?SHNITjJTM0sxeXFlcmNYYmNIOXJyT0o0YzFXYXVDNTlPdmpXMzQzUmNZaWsw?=
 =?utf-8?B?NGQwRG1IMWlpL2RnVHFETkx3S0dtR0h2bklNRzZ2b3pKWkhzd1RqVkNTakVm?=
 =?utf-8?B?S1VxaS8vVFZQTU1BZ2FGZkVBMXZhR0ZyNGJZUlhiZTdRODVKQjZvMzVmK0wz?=
 =?utf-8?B?L0JvWHBtTEpLT3RSZmwrWVh3eDBKb1J4dGJVZElXNFRmcEh4QXphTVF5ejRI?=
 =?utf-8?B?MzdsdlBIa1UrTElDWldyMStMZ08xV0EzYnp4YVVQVTlDeG5RWGFsQVN3MGtN?=
 =?utf-8?B?WWNWOGkwZ3hyWkV6bDVWb3J6Qm5iT2hBWXR0RFJLek1kenY4RTFCL1lmTVdD?=
 =?utf-8?B?RFFkTjZDZmxzY0M1YjRMa0x5NUxkZThocDR5WkJuK3RFYWtoY1JUTTFCZGJK?=
 =?utf-8?B?R2FOLzNWa0JldzdDR0llVzE4TTF6UXNqdURxY21ScmkwYlBzdWY2c29YZE0y?=
 =?utf-8?B?czIzelZ3eFdWUHNDRHoxWUxtZUFRRXZjeURxQVdKcnh0OUovaU1tdmZlT3VI?=
 =?utf-8?B?SFM5SklTV0FaN00wVml2SGlHMTVoOWxLSkVRVGEyQjQ5cUF1UEFJZm03QzJS?=
 =?utf-8?B?MlBqZ0tPdkJaNmNhTlBvU0c1aWZpMThkcGFITk53QmUxN3pRb2lkUFhZZWlm?=
 =?utf-8?B?ZFluRTFzRVJnUUdyMUpsVUpNTkVGY1dhRVJrT0FHK3NSaW1CSjQwY3ZKN004?=
 =?utf-8?B?TVFOelZTbnd6a1hmYmMxTWFSejEzalBIckphdk9JMkhTV3ZEZ1hENkZadkhR?=
 =?utf-8?B?V1JSMjhKU1F1aVVib3M0UWJtZlZ3bmZTeDN2bTlzNitlMW1qR2hxTFNDTkcv?=
 =?utf-8?B?bU1kQzJHdDB5OGlCYUxsSDFOK1Z2N3JiRU12cW13dlJoaVpYYyt2NDVIdXpJ?=
 =?utf-8?B?U3BQSUFoRGt3THJNK1puamZrNklmN1M4VDIxZEdjU2hvNGszVmlXSFFTT01G?=
 =?utf-8?B?WWRxQVJCcmJhaElieWZMR09jbmROdUcwUGdNY1NEQk94VVZ2NVZ3U0xhcytn?=
 =?utf-8?B?cHVlOEFJM3lKUnYxcC9YWnB3USs2R0F0cFVYdklHbU03ZnV0cjc3SkRmcGlR?=
 =?utf-8?B?K3YycEhwSDRnM1VlOXhySXlucDh5cHZGcVlVOUZmdndxd2Z1M2tXQy8yRS8y?=
 =?utf-8?B?RjJSZ1B3eXZEUWNMM0MvYjRrRFJZL3AybzAzVE9mUTFwOW1TWTBrSUtjWFVh?=
 =?utf-8?B?T2wyK3JIREE3dWNnZHZTZ1lHVHErbmtFd1JMK0dNNTIwYWlVZzUxZ0ZXS2Rh?=
 =?utf-8?B?ODJqOXVaazdDUTErQmQxZ3VKQ2o5NnlabzVhcUdDTE9SRWFHK3lBNjN1UktQ?=
 =?utf-8?B?ZEgvUEhQeUViSTVCK2lQdldiQ3NsbnU5cUVOTnQ3azZvMW9ZK0tYS1ZvNVQy?=
 =?utf-8?B?OGwwZ1ByN3RnUDJxVVJMZlBiZ2Iza1RCS2JCZkZmSHVadFNROStGUUg1M3Ax?=
 =?utf-8?B?WkM2MHdVc0FSeFNNYjFZWXJTalhDam1MSmhWWWVIZkxNTkE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEN3amlkRkZhdEwvell1aTVTMDRaTGRYODU2T0kyZFZUR2JDQ1R1cmR2Qk5Z?=
 =?utf-8?B?UWNsNWJlWEdSTDRiSVNtUWNiNXdzKzBkTmVET29ORm1heWpFTGREa3BER0Ir?=
 =?utf-8?B?Q0JLVVpTRGpvSHNRd211cm5LNWNZZmlwZmVhWjJJWThGK2tZb01pdHVxeEY1?=
 =?utf-8?B?WmJoMllya0psVURBTThBQWQ3L1ZWRjFJc21zaXhJSVN6WEt0ODVTd3MrY3Ay?=
 =?utf-8?B?N1dWU25qYm42MW9wbXlqM2czS2U4cnVtRmJRWVdWaGtuZ3pnZXcvQURtZVVR?=
 =?utf-8?B?dVl3L0pPbS9XbGRPME8xb2FYY3d6eW92bExyNG9WeGFMZForRG9YTTJNUnh6?=
 =?utf-8?B?WGtob0tSZFZSZDI2RzZvL28wa240ZlpMbVpBTHhyeUEzOXBsd2U3YVQ4K0Ju?=
 =?utf-8?B?OEVJZkNCOEZuc1EraCsrVStReEthRVhnQ2ptQTh5Z0ZhdjdYVXl5K2ZZa1Nl?=
 =?utf-8?B?ZU9EQ2ZIMno3cVVhK2VVOEpkeHd4ZDgvNjd5eVVuNGNmb0J6REM4dWJYN0xl?=
 =?utf-8?B?ZHpoM1FrRUw4UmtaMFVJK1hRN1lOS0hKdVBCV0EwR0tqUDZSNFkrWGxqVS9O?=
 =?utf-8?B?K2FyWU5NKzY1SXJsYWFIMjdNenJOdUtEUitDY0RxcU45cjJJbHlEK2dxQXpH?=
 =?utf-8?B?UXN5bUdjcWdDTnprQWlJdG5Xa1cvWFRxTStMSEZmVFFBcGo1SFY4dmlWY200?=
 =?utf-8?B?aVVyRUxCcTFnZ1FhNnA1d0R0ZHNLQ09mTjEzTDlldGlHRllGT2ZKaUxkdzZm?=
 =?utf-8?B?d0N5VE8yVEJ6K2F4STVta2xTdWYvMkxjb2FaSFhXcWVFRUQ1dkdiRDNFYUFi?=
 =?utf-8?B?THZLaGVEK0JwOEdBVEs0VkthdDRXQmRScndhOVU1NU5WMEF4UFpzOWVYVVh5?=
 =?utf-8?B?UUhkdThvMGpndlExVkZLaGgraTRtQWhkSk5UaG5GVFl0QWVSNVZ6TzZJSE9L?=
 =?utf-8?B?VmxDODZRRmJjUXVuRXV5bnpPc0ltclZWQk4xcTJDY2k1ZmR1SWhQVUtDOTRq?=
 =?utf-8?B?ZitqSDB1NUR5ZTltQzdZR3daVG1EQy9UL3BuVll6YytNRExvWG1OL2psTFJ5?=
 =?utf-8?B?YTlWaEIvUWo4NWJIbTNWeE8wa0dKc296eTJrR2F2S0NsVXpJeXExKzd0djU0?=
 =?utf-8?B?ek5CREtVNjdzdHlRazRwaEc2TGJ6K3dXS1RnWHZMVU1oM0hld1E4bmsxOTdn?=
 =?utf-8?B?eis4SWg0YXRPcUpNc2ZmN1dleXdMVHRZRHArNzUxQTJPSWVTdGZwTVdteXAy?=
 =?utf-8?B?Z0lheXBVL3JkVkJiQUtNaVNtaC9Rb3Nhb1BVcTY5S0wrN2RqRkFXVldnMVVJ?=
 =?utf-8?B?STkwSXF5emtlMkpWdXJMTkVrV0p0K05GaEdIMjlUb2lDRG1vc2YvR3BDSngv?=
 =?utf-8?B?K28wRWMrTndJdlFnVWoyVkFpVG05S2s1bkQ1SWlxOU1wZUcySDJBV0Ywck5y?=
 =?utf-8?B?anZ1Y0d6MmRteHNTRWhGOFZIWkU2YkVHbHhyZHY3N3NHZHdHTm52UlVOd0Jq?=
 =?utf-8?B?ZEk4d3dhdkh5Nm13emtTeXNyVG9PNmNIYVpQcnBYQ3JTcVc5Z0ppZisyQ1FY?=
 =?utf-8?B?REZPRWc3QzFGNm5TNk5GSlM3dHp4bXhlV05mdlM5N24zbWpXZmRSVlkrK1Y0?=
 =?utf-8?B?aWZEdzBlMFVDTVJlcml3a3dLTkNVSFZLZEhiL3FmMTZBZXczL0l4ZTFRZnBS?=
 =?utf-8?B?SWZabUQxVi9jM2l5ZFA1S3pQaU5HRzZ3TFc5VlV4L0llWEVYZWlESUdxUE5m?=
 =?utf-8?B?d0JzNjlTMytBNUNsSkhPK3NnbjA0bmFEWURlTm1DV0x0SHo0dlFYWU5IM2pV?=
 =?utf-8?B?a01yR1N4ZkZsY1U5dVZiUzc5Sko0R3JxdUxmVzJya2toSEk3OEo5R2hDcXNM?=
 =?utf-8?B?SnZ6WktBdHQ4S0pEbzdlWVRXOVpQQ1lWc0VhaHJTUUJBeU5PL0VIamdvaXBG?=
 =?utf-8?B?dkhsTThWMTZFYW9pMDJpNkpkZFV3dmRRNituS1luMWY2U1JkVkFDeVZJMkFr?=
 =?utf-8?B?U1ljelMraEptTEc4L2pqcC9kc1FtbDlXWkZ5ZG1ndjJSQnN3RlV5d0N2R3Bx?=
 =?utf-8?B?MW9qSGEzVys2aWo5SytOUGN1NkJtdjRNd085N2kzQVdJdnlKYWc4d01wdFRt?=
 =?utf-8?B?UXlleTQ3ZEJSREErYm5UV3E4SkN2WmZkTW4yaUVIZlpQSytzU3JGTHo5OG9p?=
 =?utf-8?B?T2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dec4aa51-bbdd-4369-e2c0-08dd7ed3739f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 23:48:00.1595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sLRyhw9026S2BRfIVNeeDBUaCE0HsUpnw0z6UfS6pZNxYgymD+t7QcZsvxDmguh2cqCe+AoQFyQciOPf6xe/2GD5lRq9FwVeTGbOHeIX0Wg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6034
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> Enumeration of Intel telemetry events is not complete when the
> resctrl "late_init" code is executed.
> 
> Add a hook at the beginning of the mount code that will be used
> to check for telemetry events and initialize if any are found.
> 
> The hook is called on every mount. But expectations are that
> most actions (like enumeration) will only need to be performed
> on the first call.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            | 3 +++
>  arch/x86/kernel/cpu/resctrl/core.c | 9 +++++++++
>  fs/resctrl/rdtgroup.c              | 2 ++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 8ac77b738de5..25f51a57b0b7 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -421,6 +421,9 @@ void resctrl_offline_cpu(unsigned int cpu);
>  int resctrl_set_event_attributes(enum resctrl_event_id evt,
>  				 enum resctrl_event_type type, bool any_cpu);
>  
> +/* Architecture hook called for each file system mount */

Please add some description of what architecture could use it for as well
as more specific detail of when it is called during mount. I think it is
important to highlight and make it part of agreement that resctrl fs calls
this on mount before any resctrl fs actions. Considering this, perhaps
resctrl_arch_pre_mount()?

It is also worth highlighting in the API doc that fs does not actually
call resctrl_arch_mount() on every mount but every mount *attempt* (resctrl
may already be mounted) so it is up for arch to maintain any needed state.

(Also see later comment about locking)

> +void resctrl_arch_mount(void);
> +
>  /**
>   * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
>   *			      for this resource and domain.
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 59844fd7105f..a066a9c54a1f 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -711,6 +711,15 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
>  	return 0;
>  }
>  
> +void resctrl_arch_mount(void)
> +{
> +	static bool only_once;
> +
> +	if (only_once)
> +		return;
> +	only_once = true;
> +}
> +
>  enum {
>  	RDT_FLAG_CMT,
>  	RDT_FLAG_MBM_TOTAL,
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index bd41f7a0f416..5ca6de6a6e5c 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2564,6 +2564,8 @@ static int rdt_get_tree(struct fs_context *fc)
>  	struct rdt_resource *r;
>  	int ret;
>  
> +	resctrl_arch_mount();
> +
>  	cpus_read_lock();
>  	mutex_lock(&rdtgroup_mutex);
>  	/*

Could you please elaborate on the locking requirements here?  Worth a mention of these
expectations in changelog also. That it is called without any locks held and arch is
responsible for all locking should be documented as part of API in include/linux/resctrl.h


Reinette
