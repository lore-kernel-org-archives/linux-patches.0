Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112AD1BEF70
	for <patches@lists.linux.dev>; Tue, 10 Dec 2024 18:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733856210; cv=fail; b=TD99n1FS3jqt48+xq3y9CrR0bYwOMoJcWp2HGCBi0JZxvbsTY+wstqHsAsvngky57CWfa5rf6tsW0TZr8r9g+dGKnHUI8v92h4gNmczH6UHi17VFhwRsSH0dFgKe5lT2ixFzANJzdPBOMFPAv+1YRzeGGct1LYGe917ZM/guAbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733856210; c=relaxed/simple;
	bh=2OtXGqZ39jqXRjKfft0oqQVu5ts67oTsoOjv9bUIsc8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bWOnNpSdi7rJKjcwcl7yUaEHOyMsTOIDC4EWbR8W5Iot294HCWGykNvWIYLz67DTLbhEWJWWT2ii8V86DHSK+a6JGgPfV66haTlWC5R5CwKMzkrmcKRyWe2LcFEX721tecg3ZDGOy7IlByZK/l1U5iJaeNF02S1xpHGE0+M27KM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VNeHw6nF; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VNeHw6nF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733856209; x=1765392209;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2OtXGqZ39jqXRjKfft0oqQVu5ts67oTsoOjv9bUIsc8=;
  b=VNeHw6nFZd7/rvmvM35yVlcPrjrHJdzB3tyuYLf6vx8GAsuevLRVF2LC
   YWkx2dUygAWwWspR4Ne69S+fam6L4cMZZIIJjt2Y4L3+XZk9QFOef0iEO
   dXVzW4bNp/X3G4eDMqDlabk9NVCzXoVSDgFxtbIDUG8E/HTYIwigW9IK5
   +8Q6zAqScWiy0x6uUSpQWsw3HPO6C2B3zutji7blOlbRgETnFHj+LlKhx
   VSzlcz69ncUM3EXMOC3ALeKczk7bBDMwS/4W2xsu1jcXbNlx7hXpaLYW7
   m3njHroyjXd+4xal2wsmbVqLua0lOSsvejLfH2sNnPEL5z4vpDnllicAE
   Q==;
X-CSE-ConnectionGUID: 5f1c26eSQmyJkUbFBAgnIA==
X-CSE-MsgGUID: 65v4KnJMSBG3MkpRDuiB8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="34354416"
X-IronPort-AV: E=Sophos;i="6.12,223,1728975600"; 
   d="scan'208";a="34354416"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 10:43:29 -0800
X-CSE-ConnectionGUID: JaA5AuBRTEak3NfHJbwrsA==
X-CSE-MsgGUID: SqYwX1iLSbujKmeJLjAdjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,223,1728975600"; 
   d="scan'208";a="95969051"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Dec 2024 10:42:57 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Dec 2024 10:42:56 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Dec 2024 10:42:56 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Dec 2024 10:42:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KX6h7Ub9R/V0f0+0/0lhcgmc8dMHdKvX7QezJ02mA2r7EGi4t78Qsj5ICaRJkllnl8eFjFHRZiAEPPlYATC9d/WPaBj1StAOoWl7GQw/My04QP1k6mp2k59e8XX2gGmWn63Pfg5BXmDl8cbp83+m3yfuHhm7xgoUsc3QnccKopyLvToITvei7h4AwVN4Kzahj3u1mHr2myCgvcChH3vOX/wQaefQAPB/sm9FvTX+QYs8TECAect5tDgYO3KPNjmsoorMn+mZGESqXpARIIEkhE1d1bKBV0Uv7dSkdUKK6LTCS0fW32bj0GlyrGshZbHu6Zq3oVU8AuAYkERyi5Snkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i3YxHTBz3pH4/BggNVZEbGs5Qc+2dDgNJKQQdezb4j8=;
 b=xTcbzeIZlFkcHT5GHstgQrb9LOh0X/meCP0+1u7CVmcfKTTF+vQ9lOlUKjjXV7SAFqq+Ylol9gwSlDkX++cr6/BYV/19Qg1n6g+lkY9LT6ngQDGoAOZXVlf+YgYizSOLKN836fEOHDG4gr31P77ZDBUJyZ8fjCqlIYMiOwok5mEFJSBsfHKKBq9esXpuJ8uyB0hEY0ocayJbdjKgk6R5t3bEo3vmRVsU6yvSdubw6y8Rju1pQOrDYH25YBlN3FmSXsh2MGmiY61Paj0JuW355B7Stmw78AH/dtXsh84a4wklj2LRixFbVVL/Rskr+qy82ISfWN4jw9HFrE2Vr2cGwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB5823.namprd11.prod.outlook.com (2603:10b6:303:186::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Tue, 10 Dec
 2024 18:42:35 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 18:42:35 +0000
Message-ID: <5267f71d-3313-4cbf-a834-a30c96da0fea@intel.com>
Date: Tue, 10 Dec 2024 10:42:33 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 2/8] x86/resctrl: Prepare for per-CTRL_MON group
 mba_MBps control
To: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, Peter Newman
	<peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org"
	<x86@kernel.org>, James Morse <james.morse@arm.com>, Jamie Iles
	<quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>, Randy Dunlap
	<rdunlap@infradead.org>, "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20241206163148.83828-1-tony.luck@intel.com>
 <20241206163148.83828-3-tony.luck@intel.com>
 <20241209204519.GAZ1dW3-NjcL4Sewaf@fat_crate.local>
 <SJ1PR11MB6083BA367F2CDFC92D87FDA1FC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <20241209222047.GKZ1dtPxIu5_Hxs1fp@fat_crate.local>
 <SJ1PR11MB60830B8ED36CCA7E304D9E97FC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <678cef69-78ef-4951-bd31-10abe646e6d8@intel.com>
 <Z1eEti6Kswtb3HC5@agluck-desk3>
 <20241210101339.GBZ1gUU3LiI7wAS3vQ@fat_crate.local>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20241210101339.GBZ1gUU3LiI7wAS3vQ@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0363.namprd04.prod.outlook.com
 (2603:10b6:303:81::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB5823:EE_
X-MS-Office365-Filtering-Correlation-Id: 93afc227-f149-4b48-3177-08dd194a6a1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cWhjU3ZqQU05K0tHcGhNUmNCT1RrbkRqcERYMk5Vbmx0c3JtSDN1V1ovZjJw?=
 =?utf-8?B?QTZLN1kya09NWUNlMExMUURGVkJOWENqS2RHa0RoTEJuV2NyWnhMVHZoTXlw?=
 =?utf-8?B?bmh2ZFc5b2tUR1NBTlZCOVpnNERtNW5TYkFWSno1S25IWFNvQzNiUE1rV2py?=
 =?utf-8?B?dmpoOHkrUmk5OC9wVjk5VmtGVnN1R1RTSjg1SG9Pa2FjbHVBcEl6YVNvQWtk?=
 =?utf-8?B?d2FPcHhPOG52djZnYWFpWGd4REhzZlZhSFVKOStUQ3ByRExNY0JZeE1sbnBP?=
 =?utf-8?B?ajQrTG5DWkF4MzN6NzhMMGRYUW16dE1MNzVlMk5QRTdEWVp0ZWNaeDFBNUFS?=
 =?utf-8?B?SGxaSUhwYmxYMlZrZ3NoaG5ibHF3VHVyTTRjWE83RElOUmhFbFdhQlVsdzB1?=
 =?utf-8?B?d0ZleFVpWUFFUFFoRStobkh1WVJQVWFneGFnK0Z1aGRzMGpRa2QyT0hCeXMr?=
 =?utf-8?B?TXBxdks5RHMydGxZVldIRko1QU1SVi9HYU9UR0VQQXY2REdPN0NzdUJEMFFy?=
 =?utf-8?B?bk9ZdGFsRDMyaGpnY1MvcVJ3WnJ3K1JzS2lIN0tYYVRVLzhadzhkc1VWazl0?=
 =?utf-8?B?SWtIdm5mNEZ1MThXQzZnMXo5emt2SU9kU1pqeDJNb2t1T0VVbUFNMWY5S0c3?=
 =?utf-8?B?QXhxM2tacEJnQVpRbDVjR2g3V05sT3dsUU15bkNSZThibUpYbDg4Z3dHL2lQ?=
 =?utf-8?B?czNNYmZWdUhBWTBCQStSRzJUaEtuQmYvbXRnci9pN0VsNXhRV2g2RGpaaGVy?=
 =?utf-8?B?a3VtVWZrb2x4YXVEZ09QYVB6YWlkcW9xazNNckVOZDlyczFoSm9qVHBOVjFo?=
 =?utf-8?B?N3d0aUh6ZGJZYktwTm9ab0RhRjFTL3oySDR5UTBTN3pnUllDajQ0blVSSEdE?=
 =?utf-8?B?Q3dMY29Pd1FkOFZ0K1ZNd2FlU1ZxYkgzMG9YZGVaOGxLZ25QZXJFRmEyUTYy?=
 =?utf-8?B?MUE3Q3JFUElDSmlKZzdCRm53RktaYlZVSlA0aGJ4VjJnREd0UFRhcDVZUmEw?=
 =?utf-8?B?TFpHd3NnZENjNExCSURqTk9Qd3VnWnJOUmE1VnFPamRqMEVPTllucUxoSzA0?=
 =?utf-8?B?Rk1ZQzVOQ1ZyZ2pnYlRodXdUTXV5dTVZaUNrOU1ieCtwS2hmSnZxdDRNS2Vy?=
 =?utf-8?B?dGFPU04wL1Y3SnBPbHJjd0thdklSRlhBUjR3SVBTditjYloraXRSbWYxdzR0?=
 =?utf-8?B?YUxiUzZzUitaZmlrNkxaUGl4aFdTUUozWEo3Y3d5TzdPZXpwWlNOMTFSeWlo?=
 =?utf-8?B?WFNTZi9EclBkK1o5cWVwczcza2hEMnRDUzY2MklSY2lLRk5GamxET25kUVdX?=
 =?utf-8?B?cDJWcEVnUVZXSXc5aWk5eE04ZzEvNzdqaDQ2WW1lU2M3U0p2bzVvWHpONmNH?=
 =?utf-8?B?RFUvVnBpZWtLdEd4TXRsbWFlV3VYdk5kTW14R1R6TzcyNDl3cFJDdFFVVThS?=
 =?utf-8?B?U0IzZlNhY2wwWTZBRngyMHNWMlVJem1nSTVaRi9vNDh2aDVPRnhMUWhsQXkz?=
 =?utf-8?B?d0FxNU11TzU4ZG84Z20xdmxaSnhUclRPTDlGK2FqZ2RtS0JuNTBnQnJTb2tE?=
 =?utf-8?B?RDc4eVFYZzlaVDdqeHI3bDJFWm8vL1dYbkxYeGJ4V3lsc0l0YlEwK3JqbE1N?=
 =?utf-8?B?cllEVXZqZlZaTFp3emRFTkF5cnlZQXNPOUdYbElUejlYSUJrL2o3T2c1VGpM?=
 =?utf-8?B?WlZWTUplOXpEWldBalBhMkRZdHA1R0lUdjRzQ0hQakdXM3N3cTUrOTdlSDkv?=
 =?utf-8?B?RXRreFdSYnR5T2hKV3BhNWx5ZzBjbmI1ZDdYMzY3MmE1TzQ2aDA2c1ZDSkdj?=
 =?utf-8?B?OURkZjE2ZW5RczJ5T3ZFUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SllmQ050dWptMVN5RVllbHg3aTZQSUg4cVFJd2dNZ1ZqVUFIRFlPSzAxWmov?=
 =?utf-8?B?WkRjNXhBNnNkSlJmMFAzRExXN2paT255bW9keXlYMHE4U052bE1vNnJWc0Ja?=
 =?utf-8?B?SkhPZFZiNVNrYzVrb0tMeXJuWmU2eEVCK2duZEY3cVg5QlJidmhGZTlheGxq?=
 =?utf-8?B?STQ3MTJtUVM1VE9aUTZjZHozOGlQVDZFNGNvY3dUMnV6c2JkVXMwdFdBZXdu?=
 =?utf-8?B?TWQxT0JFRDQ0b1pZK25KcVdLWnFzeURNN1NJZ3dxdEZzbHRTZGtLN2ZXaXd4?=
 =?utf-8?B?SDBDdWNrSEhUdWtMdzRJdm9kdW1uZnBDZTVaWFM4Y0xvd21tb1pFaWZEdGov?=
 =?utf-8?B?cUY0MzVVYzJmRWc4dzJtNU14VThVWkNVR05Td3hNNW9oWHVUS3NMN0lBWVhn?=
 =?utf-8?B?MEh6NU9OT3VBbjVETDBnZzh4cXZOdFQ1RzVQYkIrM3dlbmsrdFl0THJTUGR4?=
 =?utf-8?B?VCtFQ3ZOaUNWVmo0Nnc3ZFpNNE53NGJ0SDJzYjhqalZSUDVUY3JjZytFNU93?=
 =?utf-8?B?c1drWFZ4UjFzbC9LSEJxaEZZZmtxd3RKMitHUnhGNWh4UVFxcWpES2grUjJ2?=
 =?utf-8?B?SFgzUHlsQ0tEU3VIK09QSDkrYkxvZWM3R1ZURjhWRGZNODU2L1JzVlprRE1s?=
 =?utf-8?B?ZTlOUnZIL0Q2c3ZSeWNYeEFWVEpUNnVNb2NVNjVpSHZ0b3ZobU8xYVM1Mk1a?=
 =?utf-8?B?bzZYWEkrT1J2ZHBVaXRwRUo4VmJSZ1lPWjhUZkJ4WXViWlBOeGxTN3psaHQw?=
 =?utf-8?B?bytRblp5SUorSUR3RnhRQ0c5K3JrZC9ORGw3TFhTcmd4NWhya00yZFVNb0g5?=
 =?utf-8?B?dFRLUzlla1U5dHNjd0w1Kzd3VzdUdDd4RkpxQ3ZsRW84ZWRiWE82djF5bTgz?=
 =?utf-8?B?Z1VYOGxhcjluNU56QzJWZGYxMG9tdFRKZ0hhdjRua3NOTGdySm9XWDVidU5l?=
 =?utf-8?B?REJPY1hqdUZaa3AwcUR3YUF2WnRnbjZTV1BiRnNFWDZSODZpTjQyNXQwVWJs?=
 =?utf-8?B?RG0vQythZjFRUW9nUHFMbnM1eEpQUlZjVTJlM2Y3VUpWekh0SUYxdHRwUHBJ?=
 =?utf-8?B?VnB5WXd0cE9JWkNObDdBZ3BqZG8rdEdNU0hGbGVQdStWVFhnbjhsZk5xNHli?=
 =?utf-8?B?YXgxZVFwV2JIYkVxc1dCdU5abVBnQUhKcVQrbHRubjJBSUdnRHlFUkJ4dHho?=
 =?utf-8?B?a1Z4bkVSMHNxbk0vNXR3cUZTVmV3SU9aNVJEL3dtRGk4cjF5K3NMSUROWHla?=
 =?utf-8?B?TW5pQ2U4R1dFMGIwb1hnKy9oUVZwRmNRZGV0SWszSG15ZU1pN1JvLzhKOTky?=
 =?utf-8?B?ZTdDU1p2bFBRLzBzUUd3UFRYT05kTkYzVHJab2taM1JWVnRsc0QrSXRFT0lB?=
 =?utf-8?B?bGJKbkEwcHUzUzRxWXRMN2RpQXYwWjNjanJvTFFadlpaOEFqMnlRdHkxaDd6?=
 =?utf-8?B?RnMvcy9nRzY3V3k2c3IvWjlHb0I5N0xnU1ZKTHB5WjhiVEhOc2VqT0gyL1pv?=
 =?utf-8?B?ZWtINnFGNlYzcTlOeVFQakRNQmxsb2RTaW42cnBNNnBEWFJVUmh2WVlDMHI2?=
 =?utf-8?B?d0U1N05SUzNycytLNERiV2F5T2ZXZUJycmJ1TS84d3pQOERmMWpwTUcza0tH?=
 =?utf-8?B?UnZHVlNRd0JwSDQzQkpEckJodGVFSkhDcGNXc1ZlMEFpL0M3UFFBZFVGVTdX?=
 =?utf-8?B?K2Y0SG03c0k3aHZHOU10Y1EwUVM2Q2pnS0FWYU4zZEJvdG5JdWRmSEVzenpo?=
 =?utf-8?B?UE5mRFNLQ2I4cUlnYXM1bEFub2lENVFCbDJqWG0yNFlab2paaFpFWjhpcWJJ?=
 =?utf-8?B?TTVha3RaL3htWHpLNXVzV0JzQWxtVlRrYVZwNWRTUS9hN05xdXgybElZNnlk?=
 =?utf-8?B?RHZvQVRFd1ZXTHBLR0p6YUZVaU9MYlA2OFlVU0xNSVB2THFJYk53QWhhd1VH?=
 =?utf-8?B?QlpSeFQwVXRSVk1zRmlpTjYzTDRjOHI5TVlqUDdOQU5mSDZoaUdFS05xZ1R0?=
 =?utf-8?B?c1k2YmZTeHBRTHBjZ0p2bk5VNVRaMVd2NWxsR3U4VHh4STcvcjFWeW9DSXFO?=
 =?utf-8?B?VFpMNjVuVzVRZ1dQWDFCZnZuRkpKZFNvT0FUR0xybDhXQk9MVDRsckxpZjJJ?=
 =?utf-8?B?OGZ0aEFrbjAvTHNXbFB0UDF5aEJEN2pZR1g2bk9CMytBL0p4UE1XWHR1WFFW?=
 =?utf-8?B?UXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 93afc227-f149-4b48-3177-08dd194a6a1b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 18:42:35.8052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RDcfEgLzAXXa/+Ya+6HDwT4AhsAACogNAzG1gyrc+V1SJ31oybjLVq6ggWQ7LA/lz/yQjR7Yj1eDe7A9NM00MEvlwKWaYGQPB6jW0k/qqq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5823
X-OriginatorOrg: intel.com

Hi Boris,

On 12/10/24 2:13 AM, Borislav Petkov wrote:
> On Mon, Dec 09, 2024 at 04:00:54PM -0800, Luck, Tony wrote:
>> Reinette is right. The post-split home of this is not <linux/resctrl.h>
>> but fs/resctrl/internal.h which doesn't exist yet.
>>
>> So Boris is right, this declaration should be added to arch/x86/kernel/cpu/resctrl/internal.h
>> by this patch to be moved later.
> 
> Done:
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 485800055a7d..542d01c055aa 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -510,6 +510,7 @@ extern struct mutex rdtgroup_mutex;
>  extern struct rdt_hw_resource rdt_resources_all[];
>  extern struct rdtgroup rdtgroup_default;
>  extern struct dentry *debugfs_resctrl;
> +extern enum resctrl_event_id mba_mbps_default_event;
>  
>  enum resctrl_res_level {
>  	RDT_RESOURCE_L3,
> @@ -653,5 +654,4 @@ void resctrl_file_fflags_init(const char *config, unsigned long fflags);
>  void rdt_staged_configs_clear(void);
>  bool closid_allocated(unsigned int closid);
>  int resctrl_find_cleanest_closid(void);
> -
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index fd05b937e2f4..d94abba1c716 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -49,8 +49,6 @@ enum resctrl_event_id {
>  	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
>  };
>  
> -extern enum resctrl_event_id mba_mbps_default_event;
> -
>  /**
>   * struct resctrl_staged_config - parsed configuration to be applied
>   * @new_ctrl:		new ctrl value to be loaded
> 

Thank you very much for catching the issue and taking the time to create
the fix.

The middle hunk looks to be an unrelated change. I squashed the first and
last hunk of this change into the original patch and all my tests pass.
I am still waiting the 0day test report though. 

What would work best for you to have this fix included?

Reinette
