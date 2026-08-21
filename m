Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F21E3769FF
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 19:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787341461; cv=fail; b=VzcJ77uoquUnUkJEIOPr5YxdtafX76960p6jj07R2imLMLrbVJOMQfj2PELi+bvS3dqouwufu4zk/Aonzf9Ue9AOqliVyfcVq1jSV/EnHveXd8Lm9+3xt9f4tvZCDDFKHmA44rVYppT5uuGFqTAVQ79QKwUMYVs6jepbnuYbW14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787341461; c=relaxed/simple;
	bh=g1L4V45MaA3jkuDKBmso8w2nk9gCZxb2g8nK3acMCoU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iZfV01NTzvHMmdnxEwvDgodEFKuf4+j/WfPYh6BusNsZfAkP6s4mhKk62omqPAuAyc4vqA2TmKV+Wy4hDI0XTmf3YZRVrnn4mYNTYhQdldecdM0B8hH2s2ddSXdUlnOcdaijnkoLPzS1q2XmsT6H7UXYxJzPziL7uwT3RorsjVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q4hoY44A; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q4hoY44A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787341459; x=1818877459;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=g1L4V45MaA3jkuDKBmso8w2nk9gCZxb2g8nK3acMCoU=;
  b=Q4hoY44AnRl+m6G03fPZmKuOclAlVDi8dx7GglXfL4dyMACoV6jJxjNg
   rTOxmrKoyx2Yffak1/MorKMK1/0fx4lWKsP7v2tkiclasl2fZuCyxXNMk
   64dBNKIFaCJXhukZpV0p3/dOQwK9/jp85q9/8WmTBKmoBzXssrxlrbaGv
   rsniEi4c+Y72BM63bANGTHmxh2qcGM4D7TvWX9fu/J0brGzy7LL1GALbJ
   dCfiF6HgoFJec81tiHzH/3WW5PqNhVpRp0DIOQffQCl26TJy2CVdsHxlU
   Yr2WQlMVpSG6XVAD3/suU8UZ7p/6yZCLkWOxO6/+9s7IU4WrOqEawt7N2
   Q==;
X-CSE-ConnectionGUID: sR2nRJlEQJSERKYbbR8J+Q==
X-CSE-MsgGUID: qS3duEtNT86kqnkdT3e6+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11882"; a="75434161"
X-IronPort-AV: E=Sophos;i="6.25,235,1779174000"; 
   d="scan'208";a="75434161"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 12:44:19 -0700
X-CSE-ConnectionGUID: DsUS4fVdRdG4nsynvtG9dw==
X-CSE-MsgGUID: BA15zSvlTZqiV0VBRrFEWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,235,1779174000"; 
   d="scan'208";a="264664235"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 12:44:16 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 12:44:13 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Fri, 21 Aug 2026 12:44:13 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.52) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 12:44:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pavu2+lX4KCHERsgsmsDS6MsTMl0omwzgck3UorIIe50PjB7I9alV5AHYcF7OzI1i53ZzZvG9ugKLfuwZDOPghITlP2Fla8R1LJqrz/x76AUmAUZ347A1v4mvevMVSjzNCmRbU2+e/dGilIIezHr/XMyxBSKedi0LEyod7DfizbKG7whqwMvPEkH6pL66x4DvAviPte7E9/j2sJagdDZN5+ieknj6/OU3YzDxb8nFy0Ulz9+f+5LqVMf3eWQ81d1vX1+TnaAvTxdROO8dsPwk9ALL8QenRGfg51vmwlr1JeNwOqZBrAEsVtXEqXKqCAppq8dUmOILkLB6Peo2DUUAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xsWNiNrNxR15rJgFPon5AQhRX5omBIH/VdM/CsmfeiA=;
 b=JXAWDysaeOVT2uEvdI73Mu1CZUeIQD5r2STK6m0oYyDcq1i0iKpmx3eVPaIF2AZrvUg1vaSWPeGMD/TMaFUZlpuc9K192MuCVG0Fc4hS72cvBCrdIUA3zr4lJ+zKut4ah6PPVMeufLCwF6D7jV9BDaHIHFbQjZcy8ek2IND2e1fE79e/kzuz0lkWOs7rxkLY+C6SJ9IPCpDi6zj1hlvRw7PNC9DWd+90MXmLJrAKiCjAxcpp26RlWanINFmAZIpz3bHUVPIPSeELc81i1N+WNqRQ2Oawp2hNmHAWouhLrDjVFhQgz7PRqNBLncprEFwrdvGzZF5E3Yn1kI/368cMOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LV8PR11MB8723.namprd11.prod.outlook.com (2603:10b6:408:1f8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Fri, 21 Aug
 2026 19:44:10 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 19:44:10 +0000
Date: Fri, 21 Aug 2026 12:44:08 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [RFC PATCH 1/4] x86/resctrl: Check if monitoring features are
 enabled
Message-ID: <aoiqiAEFJfCxhLVk@agluck-desk3>
References: <20260819161323.11587-1-tony.luck@intel.com>
 <20260819161323.11587-2-tony.luck@intel.com>
 <9787f9de-c72d-4c0d-b9a9-867b0f4377f5@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9787f9de-c72d-4c0d-b9a9-867b0f4377f5@intel.com>
X-ClientProxiedBy: BY3PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:217::22) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|LV8PR11MB8723:EE_
X-MS-Office365-Filtering-Correlation-Id: ee8e38e9-2e23-4796-0c68-08deffbc9223
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|6133799003|22082099003|18002099003|3023799007|56012099006|4143699003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info: B5EFnvfZncsB0/Atsy4X1G6i8Cv8t1P1W4kRNdBRGXqLt1JzeENZmUlgxHNjXNcE21vuHU6rso75fW7SRlOYVBwcVDD9pvI9DtZHQCT31OknkQeyUyCIpfofonX3yp4auGoEP6MWTHc8ULaCXNxzLcJ6zmwG+omgZSlk+Oj06Ialuh0V9miVU0VNwNYzpm/xUcP4aKpYel26pkK+gEqWmW0zMQeZAOXApcwYuJevfoFRQ2np2vU9CajpnzhV2rSY7MSN3rgxI/TATg2Or+jEi4VW3UV3tBtU7dMjETA8QGhx3UddvK64TwC1PzW2eEEnylYKF+dfQfhUtNO7jQL5HbK8F5eb1nx5YKRYBlIn/8TkcUBW3TR+USF3uhalFJ39gOLQqQTc3rXReioHmmmTVgkPyl4T3L5FEJTTu8z9/t8AR8e4PNbELS5KxEZCAnZ9ca4MPUJtSAuqbjdBrIG6zUo+eoORFTeLVjB3sxlX2r2mI/s9U9OmXZniqTMhQMS5r7RtWRSS5ofwfEFG3v+Xc6syV8ityukx9HaiCDJIMURXmek4U40XqYrWDdccDVkkytAyDcjJbgFvjVaDnFLqYIsABTAsioaEiB8i8Vzkq6iTdO7IoRRVvmi0U7Q88x9214j6sMuwCM0WjSCDdpWuYX/XIawKwnBzHKLUFGkBQsc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(6133799003)(22082099003)(18002099003)(3023799007)(56012099006)(4143699003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDZ2a05YNE0vSTdacHdxYlJ0SFAwS2hHdkJYTGdKclRDZ3AycHo2czM0d2FQ?=
 =?utf-8?B?OGsxNFo3NGZRNEJRdFRCQ2FCRUE0bk82U1U3QTJGL0ZkMXpkM2JGRGMrOUls?=
 =?utf-8?B?bHpHZEQzY1hZL1VxYmpycStqRGRnK3pUS2lObWFrSHdqUHVSakVOZWwwcjNv?=
 =?utf-8?B?aVVScmMrUEhQdm1NZjVlUjViaFZiQXdDM2o0cms2Z1MzM1ovUEdVYjgxWDNP?=
 =?utf-8?B?VGdoUTNVY0FjQXRTeEx4YkFNbExEVmRrb2U0a0JqMFlPLzZaejh0TVFNbjk0?=
 =?utf-8?B?MGpUZUhsSFl3ZW14d2dpYVhjcUI4LzI3cmFaQW1JU3FOUmkzWGx0bnFucEZE?=
 =?utf-8?B?dWc3MXpzNFlvcnByRlhKOE1jenNyL0ttU0RmQ2pUalRBRzJvRkZJczg1dVNT?=
 =?utf-8?B?VFM4SmptLzdzeDUrbDdvZUxndGJjOUVTakJlRmhMUTcyVTdYbTFiNzhuSGxq?=
 =?utf-8?B?M3Rxb2c5S3FwakVOa1Z3cVVqamlmUHNDd2NOU3hqRnIvSFlpYWZTbHVwSGw4?=
 =?utf-8?B?MzN1RmZtM3J0ZXFEQ1YwSHRQeTU2ZHROOWlQdFFEQ1JzV0twYlIvdHl1NDVO?=
 =?utf-8?B?WnF6TURtUFpSaEdtd2pPVWRjUDFCZ2doUWpXemx2KzQzN3Y5S1p1Mi83N3JI?=
 =?utf-8?B?ZHU2U2pBWXNlT1dabnBKY0Zubi9ORXNKWVJSaFdubXhMTkFsZnFtbm5hZHBP?=
 =?utf-8?B?VUJ1bm5HUkp3WjJYUE0yQ2lBY0RXYk51R28vR2RDYmovZldQOW9ZVlRpSUN4?=
 =?utf-8?B?L0k2by9mSXIxWlpJRzhScUxSNXlMSk9HZE9CbXk5Z2k0Ynh1NXgrRnI1VVU2?=
 =?utf-8?B?Q09rWCtyTC9QbTlZS1BnVm9icDFEUzZXU2tLTit3dzRlUUtaOVFxWlpIbnlO?=
 =?utf-8?B?bEppWEdYeWNPME41eTM3TnU3OTlGdEJPcjRBYmQzaEFVbUd5UUhwakk3L1pj?=
 =?utf-8?B?SjZoaTkreTdYWE9QdUpBL1M4Vnh1VSs2QTAzUXpwUExjanMyVWhGa1p5aTNa?=
 =?utf-8?B?azJEWE1tZjAxLzhxNVhMdExjNDFSb2txQUpIdzNrZVVyTXdvZGVQQlcydDdW?=
 =?utf-8?B?TGxOeDhFdnNJdlBXd1JDVkFKdTlINjRGK2J4b0F4RTZGME16MlVFWDdvd0pC?=
 =?utf-8?B?STA2OVNlNFdJNW85NEFRMjN3TVF5Y2Fmb0FoY3hxZFp4UE9KSWlzbGZXTWt3?=
 =?utf-8?B?WUdSaVZFMm52QTRIL0NlY09YNGpTSDdKRjFjQXNsNFdubFp1dXhUTWFQYzNu?=
 =?utf-8?B?M0NEdmZNbjBiNUFKNERJZVBSSDRWVGtScUFEY1U1VVR4QnVzc3BwNWZoZmRC?=
 =?utf-8?B?a01rb01obm9kL0JPVE1USEhTN2tGV1ErWExzV3BVT1lyckpmcGFKMVRIZldG?=
 =?utf-8?B?OEwzaXFGNFRRNnZsdTErNDlnMkR4N090RDdLRlN0YTBhUXVtNE5WOXl2Vk1F?=
 =?utf-8?B?dkFwbEJoS29rbm45VkdGNmRxNzAxdCtySDdSM08yaGdPVUVQenNLdm0xcEgy?=
 =?utf-8?B?SVRNSkJWaVd6ZkZ6K1V1ZnJHamJQSnNHdTVhNGxTMFBsZVo5bjB2ZEhDNjQw?=
 =?utf-8?B?ak9xNG5jYXFselM0WVV2MVUwb3g0cndvYVdVRWdYU1VVOXhUYlN2NG9RNy9O?=
 =?utf-8?B?MUlMR01MSWNZb1JQQm5OR3hhdnpnMk9hV2lHcG8vZFpsRDFUTUtZWUFsa0Ft?=
 =?utf-8?B?ZnNjeG40b0hkdWZZa1VTRWRrb09IVlFNWnZRRFZ1d3JzZEJ4M3V6NTM3b29z?=
 =?utf-8?B?a2tnRG5aeGNnY2c2K0NBZHEzT0VHMHBNdjd0MEdCTWEzRysyWHdjenhEdGg2?=
 =?utf-8?B?OVZxTFNieVY4UFJzL2J6M2FuQXlhN1BkYnFZNHRVWGZrbkRVUk9PcU90aFdY?=
 =?utf-8?B?U1ZZZXVBTVFrWFJPYUhVWlBURkkxOHJJMnc5OWsyZVJBVFp0L05nNVltaUd3?=
 =?utf-8?B?S0tIMWgrekdRUzZZMllEWW9ieGllTUo4S29uUXZwazZZK2kvZTdEcitUZDlr?=
 =?utf-8?B?WCsxTTVwek1TbitlaUxJa3ZZMDVmVzBiSVlKajZUcTZjN04xTmR6ck5HbzFP?=
 =?utf-8?B?VTZlN3lUNlBNcHRIcXJJRVFndktKa1VXVVFEc0N4RlVNSkZrSGtqSnBLYVBo?=
 =?utf-8?B?MmRyV0J4dVN2RXJLckRhZzlmYktxSWdYaE5WNDR2NnJQejhYYUFvYkxoYk01?=
 =?utf-8?B?MkNtVE5pcU15czNNWmFWSDFOMlNLMjdNQnZoVkcrYUxONUhiMWJiNFhNbEhy?=
 =?utf-8?B?UUMvNGNUNUN0WHE2b3ZERWtUeWtOUkh1Y0Z3RjA3SytSSXFnM1d3TTZWTERw?=
 =?utf-8?B?RDBMRDR0N3NUMDMxTGc5bDVSZWw0eHdSSVEvaVBKME5uMHlJcnBYZz09?=
X-Exchange-RoutingPolicyChecked: CsxCKWf4c4yz71x+w0yYRZqJ4ubjXQbMy7mU5g/JwnuGjFmWwAHigDqO3uWkmEKcYfLUuI+mVrl7RFQbr+VBU+BIvk2LWv6EcPqB7/yNkaZuFJNLjQvEUO7BkEAjkIxTnA5FNmedTbBAyLtuwifTpbUiE+ovtgog4DDdisrYJLOqfMaG7cJ6k0tXd3gmhcqMyOiYiwilwbd+wUSyejb8lCj5Wd1mi8TTuSNmrPgDxc7mZT5pdSZZPrlU43EWYhucKcHaTOKlwlAT20VsQDcEAG2W1KcsrhVZFqvIm3TbFjfIHZ1G21bFPKnPayNWtyDvbgn7PMPjQqdg7tltYZ+bAQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: ee8e38e9-2e23-4796-0c68-08deffbc9223
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 19:44:10.5896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XqK3SCie84j1wX8sZboviSOVO8IsFjGaBqjzYXTo2O/2DMVCf7mNWuazV3CY0Ny0X0yLvVcyBBw74Y/qrh7T4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8723
X-OriginatorOrg: intel.com

On Fri, Aug 21, 2026 at 11:18:51AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> Thank you for doing this.
> 
> On 8/19/26 9:13 AM, Tony Luck wrote:
> > Both Intel and AMD manuals say that software must first check
> > CPUID(0x7,0x0).EBX[12] to see if any monitoring features are enabled
> > before checking for specific features enabled in subleaves.
> > 
> > Add the check for X86_FEATURE_CQM.
> > 
> > Fixes: cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/kernel/cpu/resctrl/core.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 55214d6fdc49..2677b8a6c15b 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -968,6 +968,9 @@ static __init bool get_rdt_mon_resources(void)
> >  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> >  	bool ret = false;
> >  
> > +	if (!cpu_feature_enabled(X86_FEATURE_CQM))
> > +		return false;
> 
> Is this missing a check of X86_FEATURE_CQM_LLC also?
> 
> As I understand resctrl learns from X86_FEATURE_CQM whether the system supports
> resource monitoring in general. Contrary to what the feature name suggests, there is
> another step needed to determine which resource(s) support monitoring via
> CPUID(0xF,0x0).EDX where bit 1 indicates LLC monitoring that needs to be set before
> the LLC resource-specific monitoring properties can/should be determined.

Yes. Missing that check. I agree that the feature define names are bad.

To avoid continued confusion I should rename the #defines to match the
bit names in the Intel SDM (but leaving the /proc/cpuinfo visible
strings at "cqm" and "cqm_llc" as those are user ABI now).

X86_FEATURE_CQM -> X86_FEATURE_RDT_M
X86_FEATURE_CQM_LLC -> X86_FEATURE_L3_MON

> 
> Apart from the checks here I see that cpuid_deps[] accurately reflects the relationship
> between X86_FEATURE_CQM_LLC and the different LLC monitoring features checked for below.
> I do not see cpuid_deps[] capturing the relationship between X86_FEATURE_CQM and
> X86_FEATURE_CQM_LLC though. Could adding it complete the handling of relationships between
> these leaves?

Yes.
> 
> Similarly I think cpuid_deps[] may be missing X86_FEATURE_ABMC's dependency on 
> X86_FEATURE_CQM_LLC. 

Maybe no? X86_FEATURE_ABMC isn't enumerated in CPUID(0xF,*). It comes
from the AMD CPUID(0x80000020,0)EBX{5}

Babu: The AMD architecture programmer's manual just says:

  "Support for ABMC is identified by CPUID Fn8000_0020_EBX_x0[ABMC] (bit 5)
   being set. If ABMC is supported, the feature’s attributes and capabilities
   are enumerated by CPUID Fn8000_0020_x5 as detailed in Appendix E of APM volume 3"

It isn't explicitly stated whether this depends on CPUID Fn0000_000F_x0
EDX{1}, which AMD names: "L3CacheMon - L3 monitoring capability"

> > +
> >  	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
> >  		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
> >  		ret = true;
> 
> Reinette

-Tony
