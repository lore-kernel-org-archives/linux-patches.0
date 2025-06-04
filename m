Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE03470838
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 03:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749008987; cv=fail; b=LGR64lSQaCYzprn2RlMmO14VEyWn8jzSA+lYRGR9Ia49gQVrOKNcywsHBYyoi+ErzuTiBe42/eAQzn/n2grd3sAJe1L41rhOhKqNjDAbcLsMbrAGueUVPma8r+Wo5c5cux/cfgSqfFew8lsQ5WicMNO5jcEYeVb8tVwTZnIamf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749008987; c=relaxed/simple;
	bh=CIroONOYsDCiSChMc5SWbpRs9tcBxbiuh9ah5iY5mJQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SEzBiyngsalOq5MIUsnKsPB9JV9T3/679TMFMZu4GnwyLWvNtTd6l5qMTPqVjLPI3Qajr9EYEB77QpECEriBt71Z0BWUlWSpjW3NzaM8WRgl3eOxjIx6up93KBSsFxkjgjV21WszPgT/JvuMcmM5oC0C2OQXFz4Zc1TM7F996bY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nXEMQW1W; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nXEMQW1W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749008986; x=1780544986;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CIroONOYsDCiSChMc5SWbpRs9tcBxbiuh9ah5iY5mJQ=;
  b=nXEMQW1WxRgEEGVlod/c+vCUzwdJo2F7SngWBaQlXrzOL8oNhRM6ZQqn
   K+M3mmb5s0IaA70XSL0lPUPpNuzf3+8rsyK7xCoelbM3Fml8K7t3vb4C9
   N/Zo51ZpAWfLHEhQ/PD+l68bG/lUSqb8jBSbGf1QwfdjtZpLyOXhvEh7C
   gnSF8AJ8PjkaBT1Fu7fJEwmm8po5oRh7aU4dNCtj2zFwwPWrPa5Qh3RDQ
   cpkUx2G5vrW4jnk7HoHdw+qRza2oEDouQe9sj+r7t26Btc831lXK7wZzM
   WjNcJSX8dysaL46HzpRX0g2qVpfn60ZSMUVgOqZDJX68VSK+n2KnzM5vu
   Q==;
X-CSE-ConnectionGUID: SZyLL2ZZTwyfHEv22Yt0ew==
X-CSE-MsgGUID: JRUPHWI3QPuh2PUtOwVX6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="61338924"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="61338924"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:49:45 -0700
X-CSE-ConnectionGUID: ffUMWw2OS/q0odgxe7v7dg==
X-CSE-MsgGUID: aFFvZut0RsyKRgIWoUJiQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="149946249"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:49:38 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:49:33 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 20:49:33 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.73)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:49:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gvagQBzt4NWry8KmX7mg4pzZyBsy+Fu0uQcvaWJo/Pn/UIoyDSqrzcnlSfxCEKMl4wPS5XfStg5c0A/ZHe2gOoXZQNXQfMduKXE1YEh8/5zIBbKLF5in4y33L7HJlCwOYviwg00Xyecz335oB/gR1u3ZmCZmqKf8ov5pgr23BJbTtQkCgmvmlp9BW/zkBeeEYwAeBC4MbEJFbSrzK95d1ZTMaetJsBSd1Sp+cQWlt89o0hYNoLWXzXk42m74gcGz+/d7UXvl3KcG6MN24q9FBSqn4XOX5Ba4OKnd0Xj4MYQqopZDlyPrNXZXotnbHL1ztFchQGhJjtCJ4sYCGGUzDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/oVoTbG0exMasaBDfyMCbenLYV1tbXJWEuJjx4nU0s=;
 b=rlfA6mfAXqLOVoPv7kdK1rAC843XVQndFyydWIp1JUqd5BOPJO2VNb1xG6eWPSaHj+DBjo3/4iYGuHFbxrA5cxIwUy4hVEtNewzsCoYvRMiQxJ9BbyGuOgUIr7vNWRoXxDG+vZe0F+BnsAQQR0tOkgom59xspmL0iVVgCAvoSZFdfK0xQodALO9qJHKPY5cFze4ZyAY/nekp6TaPIg2A4A109Q30kZE6D3hDeIYt2z2viIwP5bHwvgE4iZsfDnCU2HgXBDlYEItbTpy+2oNCr5ZYGvHVD5d9bTx7hGoQeV/3FvFpVHCqY+mzYvWWGjXcc4THsKGG8YxGT4686XokLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB7599.namprd11.prod.outlook.com (2603:10b6:a03:4c6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.36; Wed, 4 Jun
 2025 03:49:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 03:49:11 +0000
Message-ID: <f368c506-c479-4e8b-a5c6-b9bc5bcd5674@intel.com>
Date: Tue, 3 Jun 2025 20:49:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/29] x86,fs/resctrl: Support binary fixed point event
 counters
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-15-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0090.namprd03.prod.outlook.com
 (2603:10b6:a03:331::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB7599:EE_
X-MS-Office365-Filtering-Correlation-Id: 16a4b88f-552c-416b-2c55-08dda31ac3f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OEhaenZBV1l6YXZ2cVdlRjV5ckdpMWNjcnUzb2FtdlBnWmlDR290eEVWbENK?=
 =?utf-8?B?MkhyeklVU0VBa1hneitrZTlOTzJ1a3EvdVgzVE1JOVQydDNFb0xETDMvdmVn?=
 =?utf-8?B?SVZDRjZSMWRoeE5XK2dDSjRISUhLcjRveUpPZ2F4V2hyRU9adkJMYlkrdFI0?=
 =?utf-8?B?QWx3NldyNHhyYjdRc3JkQzdiVVNQN2NETlZOcEFtWnBzZWJwcWNOY0JxUXIy?=
 =?utf-8?B?VHRsdXRnTTJZV1pEd210QnJ6S1pmL2ZYaHdJMXN4SmN3bWV1N0N5ZjBmd3hI?=
 =?utf-8?B?UU5INWJwamxHeWhnczVGVnVRQWY5YW4xbFBpSnJJMFhqZml5ZXpyN2JpNm5z?=
 =?utf-8?B?dTl6emszS0MvM0dscXUxODgrK0tpcWkybW53MWdqNGpHVTNqZjRQd2Z6Z1Qx?=
 =?utf-8?B?L1NnbWw0dlVKaWkvdGg3SGpudzZNSnVXaW1nUHN3VW5UMmNTQTc2YTJSQVp4?=
 =?utf-8?B?Vmh2VUFHci9IZkRGY2ppaGdTV1NaeVJZS3JyQ2JydlN5WnVxZzdzSFI1SGlO?=
 =?utf-8?B?WFJ6QkhYOTM3UE90a0gzc0wzdmdSb2NVUzczQS9ITTBtcDhwZUdSbDZxZlFT?=
 =?utf-8?B?MEtybHdSZG5BbnpteEFCZHJtOUo2bjJBcy94VXRaeWYwOC9jdUU1L08wZ3Zm?=
 =?utf-8?B?RStVNHV3YWcvQklrbEV5SkVmRnVvZWxVclNsR1czcTJqNnlOQk83UFpBSk1r?=
 =?utf-8?B?R0tYMlBXTjRrakYzbllmQmUwRmljQzRhZUVSSXcyVDhlYStEMEhsL0ZUZExY?=
 =?utf-8?B?Skwza2FmV0paek4vTnI2Z0pYMW1uVVR5VXlwbXppZFB4VURkR0NOMEpnY25x?=
 =?utf-8?B?SWxNV3MzZG5tQm9SME9iMDhCa2dldVp1V29MNmFEWm00SG04TGdHQ0V3L2pI?=
 =?utf-8?B?VFp3Mm9iOStXMHBOTFdLaUVNb2dTQTFNai94WHN1eDJINXdpVzJ1cmlFWlJT?=
 =?utf-8?B?Q0VQVFlIckJVVnc0TGs1UW5mMzlLS1IwYmV5TnB2dUl3ZGlwTlR2M1Y0cWda?=
 =?utf-8?B?SndtTklsZkhHM0xDdTVNL1BkZk5DR2JHWDRLQVBXbXlpN2xqYjg1TnBudlFV?=
 =?utf-8?B?UXp2ekVHVmpRa2ZwKzRJRGlmL1BpOWZCUU9DOWJ5RkFrdHZqdzNmQ2lRSFZi?=
 =?utf-8?B?dEVIWXYzY3lra2hKeWxmaUNNZytmbVNyemZKWmZKY0Vxc0ErS0NDaXFKdkNI?=
 =?utf-8?B?ZGZDcjBXRlErcUNpeTZYYzQvNE9MM2xYTzYzMXo5QWZmNkxWTUxrMjdPaEl4?=
 =?utf-8?B?VmdsaVBhR1o5ZGR3M2FUcHFkUFNpbFgzQWVhNXNFYjR4ZjF3RkVRUkFtMU9H?=
 =?utf-8?B?MktDN2FMK25MYWRidGhoTjZqc3l2NUpqSWFSNGQvek5lSkNtWG53djZLa3Mz?=
 =?utf-8?B?VmFTaU1DNSs1K0JZd2xBcTd6VkoxZkgwdGFQd3V1WDgxRytMeS94RjZSMXJL?=
 =?utf-8?B?aHJCRXFyMXNmS0hRaTNOcjdhcnU4azRHQm85dlcwSWhZQ3JValpVbzkvOEgz?=
 =?utf-8?B?NEhqNmhSRkdXV1R5MksyYkhxN3Z1SGx3eHdKb2pxL3JLV05jajE3SGZoY3Uv?=
 =?utf-8?B?NkZQQytoK3cxdWF6TEtwRkFRRmxLNlExVnpHZlQ5T3J6R1hTTjRpN2VNY0da?=
 =?utf-8?B?SmFpYjBlUSt3TkZPaDd6TDJnejF5WjBVNzE3SU83VzdjQ1pCNUNhRm1VVVlL?=
 =?utf-8?B?NUlhd1NoVFYxdjg2V0dIZVZ5OEo0c2syTVpHcFBxWDdhbWNMSTFaU3dhWVBw?=
 =?utf-8?B?dVBQbjlhSmpMODNQZkRjeExpZlpaN3NNRFBmNCtRZlZqQVc2eWttUzJvcHYx?=
 =?utf-8?B?Z2FnTUdqZ2YyekFqbWZnZlJja21yekY1eTMrY1FvcG5BMTErWXVWVU55bFNz?=
 =?utf-8?B?QnFtR3ZVbkdqamk2bTA2Q1FKb0NTWlRsZG1hY08xclhQQ0dUS0xLMEI4MWVI?=
 =?utf-8?B?MklBUThqU1pVVzlBNVpOWUVFS2x5UW9TUkV2cHRpcmJGaFRwb0Y0OWdPUVB5?=
 =?utf-8?B?STlrRjdkVWl3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3R6aEg0a1NTbEZ0YUNieXgwbks2ZWdNVVg2amlkajQvcVlxaXNCdHFKRVFF?=
 =?utf-8?B?YVZ0Z2hUcDFBeU1WdnNuR1hTbnNnQWwyYSs4Wmc5S1VoSkpqdURjUGFTVGF0?=
 =?utf-8?B?K1F3aWYxQlFSalRTNytBK1ZVZ0twa1JDc1BSZ01ZaE5sMStDcWxRVlRzSmo2?=
 =?utf-8?B?OERpUFNlK3dUd2JRczg0Ujc2anBkNEhtMWErckcxS0lid1hqU0I5REFhcHRC?=
 =?utf-8?B?aVRvcERRSHBMdjN2aUlPRGtRcEVzMXdGaG93TzdXZGkybkt6MVVBSjE2Zi9U?=
 =?utf-8?B?NDIxb2EwWUdvYWlGSmdOQTZlNU50YnMraVJvazFFNkJnVDVWUEVzVkpkaHJs?=
 =?utf-8?B?MG5MdEhtam40MHUzYzJ0WnBsR3lGQkQ0ZmRSZVNaRzlqZnRCenZOZ0JSSGFy?=
 =?utf-8?B?VDB4RjV1UTVVSVBXc001djJJdTlRMXZESUh5UUZDRkhGUVlZUWwrcTdkbEpa?=
 =?utf-8?B?ZytWTmtlSGplWWNrdGtwUUE1ZnhFbjVCZUJaa2VVUlVRRFZrMlJkYXR5UHhu?=
 =?utf-8?B?ZU5JN04zTlNDUkt6NXA2UVJnSThKL0lhazl3b29XOFRuWkw4eGNrMTJteEw3?=
 =?utf-8?B?ckpHMGoyVzJRWnMyVmRiZjUrR0ZTdmo5SUs2WnpYZlM2clNIY0x1SFBiVTc0?=
 =?utf-8?B?MjFSTi9nNE5BUTdOUWZzSTBUMWc2TStGdlF3cTFUVUZvNDFwdnJxTEtoQmpr?=
 =?utf-8?B?MXg3c2JIZVFpSUtFdGc0Q0F6ZStoc28zbUZnNUdSUWJpSUFGN0hPSGI5bnlj?=
 =?utf-8?B?ZnpJeFp2a3ZaYzNxelZFejVhQ1FtZjJuRUZEQzdDWERzYUhFcUZqdEVzMVA0?=
 =?utf-8?B?Z2hOck5PSXBRSmNoMmtzTkxRWG8yY3lsSUdibVFvNHQ1ZWUxTjRrdXcwNDlo?=
 =?utf-8?B?YjBMOVhvMFJVdUNmUGRLdzI5dXNTd1EvZmkzUEZ4WHMrWGpXaE14WFl2TVJI?=
 =?utf-8?B?M3hyTDBWN3dZMTVwMW9TbEdVUnpKNUYvZ2laY1EvQlZQUG1yQXBvWTluY2dx?=
 =?utf-8?B?Nk9Yb29JZUZDc1ZoVmIzM0hJallUT3IxeUJEQU9QeDhkTkVTRXpjcUliYmcw?=
 =?utf-8?B?a3FBMk1pcXhudGpwT3lJOWJPL2c3MU9iYk1pMW44cmY3anIxblJQM0lFbHpV?=
 =?utf-8?B?a2VsWU4wWHhiTE5HL1VLVG1NYTZXMVBWanQyTVdZQzMrdWx3ZzVxaHFmVVRO?=
 =?utf-8?B?Rk5CUDRDWjJkUVdlcEdxcUlNQmt0UmsreUplMHNSclhOZ2E1Y3J5Ujl0V1ZF?=
 =?utf-8?B?QnJxQ0YrRHdwN3hnNTNhSjNZV0krdG5QcUZIR0x4TDJZRTU2KzNzN3ZQQTJw?=
 =?utf-8?B?bWpkSzVvcm9DTTRkK01BVFpVbFN5SkUxQlVvc1p1cTlNM2grTzI5cTM1MEUv?=
 =?utf-8?B?QVlwQS9xRW4xY0daUGs3VXFEZjRReVd1RzJhc3F6aEdqMGRTY3pxSXNnbEpC?=
 =?utf-8?B?c1VGZ2VDZ291c1ZvMkc1NjEzNmhwcERINnkvM0lyMitmbFBHOERwZ2RmOVNh?=
 =?utf-8?B?aEhucnIzemxzZnhkc1czSmo1UUlPcU15TmJJWmZhL1RYSmxyWGtyd0ozWDln?=
 =?utf-8?B?MmNSSFdVZDFTcTRTYXZJNU1tL0FSSTcrQ3RjTlJzOVEwQUt3dEhsVzBSOVlk?=
 =?utf-8?B?WjV3MllXdGtBTkZoVW1CU21SSEI5cTduOFhvQTAxdGFJSEtoT0NXQjAzNWpK?=
 =?utf-8?B?NmttSnFGRDY0aTlNUlBVcXFYenJaeWVjcXNsVFZBUDE2NXd4QlZtWlIzK2wy?=
 =?utf-8?B?SmltclcwYUJTTThhZmFOQ01lNGtPcDNVZU1hekRNeEZHQ2IrdWZMOEt6TVFt?=
 =?utf-8?B?cVVuemR1MlZjR21WNXBnM0dYOXZ0TzJPR2tHNHB2SzRuSkQrYmNva0I1TUZp?=
 =?utf-8?B?dkdXazU2MkVJZ0hnWGRFZmpWeEhNT01IS3ZrbmR5TUpNN21GU0FTcHpPeFBy?=
 =?utf-8?B?Vy9oeWRCenN6b0lHb2VrOUlLVncwU0RaYmw5MEphL2ZDTUp0bjdVak9CYTRi?=
 =?utf-8?B?UEc2MjEyOUdhQVlNMFBmd0pqRFU3KzczYUNLeHNvUHJjVFJUUVUydGcvV1Na?=
 =?utf-8?B?blVMUkcrMjBOaWtYVUV2OGJnLzlxa1JHV0pKbnFMY2xMMGgycGxobkJtZElm?=
 =?utf-8?B?a015Zk9aWCtHeEZEOVNEd1AwdFVvYXNrUnptZXNJVzF3Z0NiR0JzNnl3Zy9F?=
 =?utf-8?B?Zmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 16a4b88f-552c-416b-2c55-08dda31ac3f7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:49:11.0175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKsKF/NjFFMnJTpd52we0WYL7YdLcRhVFOkEXNVh1Mv4BCz6QPjyD97eHNzP89FYcjVxOr/6a+czQgRiMbQIANP0kIQmrqgKz6R6DCnRmDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7599
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> Resctrl was written with the assumption that all monitor events
> can be displayed as unsigned decimal integers.
> 
> Hardware architecture counters may provide some telemetry events with
> greater precision where the event is not a simple count, but is a
> measurement of some sort (e.g. Joules for energy consumed).
> 
> Add a new argument to resctrl_enable_mon_event() for architecture
> code to inform the file system that the value for a counter is
> a fixed-point value with a specific number of binary places.

resctrl fs contract with user space, per patch #29, is that only "core_energy"
and "activity" can be floating point. We do not want to make it possible for
an architecture to change this contract. Other events should not be able
to become floating point. I thus think there needs to be an extra setting that
indicates _if_ the architecture can specify a fraction.

> 
> Fixed point values are displayed with values rounded to an
> appropriate number of decimal places.

How are the "appropriate number of decimal places" determined?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            |  4 +-
>  fs/resctrl/internal.h              |  2 +
>  arch/x86/kernel/cpu/resctrl/core.c |  6 +--
>  fs/resctrl/ctrlmondata.c           | 75 +++++++++++++++++++++++++++++-
>  fs/resctrl/monitor.c               |  5 +-
>  5 files changed, 85 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 9aab3d78005a..46ba62ee94a1 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -377,7 +377,9 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>  u32 resctrl_arch_system_num_rmid_idx(void);
>  int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>  
> -void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu);
> +#define MAX_BINARY_BITS	27
> +
> +void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu, u32 binary_bits);
>  
>  bool resctrl_is_mon_event_enabled(enum resctrl_event_id evt);
>  
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index eb6e92d1ab15..d5045491790e 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -58,6 +58,7 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>   * @name:		name of the event
>   * @configurable:	true if the event is configurable
>   * @any_cpu:		true if the event can be read from any CPU
> + * @binary_bits:	number of fixed-point binary bits from architecture
>   * @enabled:		true if the event is enabled
>   */
>  struct mon_evt {
> @@ -66,6 +67,7 @@ struct mon_evt {
>  	char			*name;
>  	bool			configurable;
>  	bool			any_cpu;
> +	int			binary_bits;
>  	bool			enabled;
>  };

Perhaps a new member "is_floating_point" can be hardcoded by resctrl fs and only
events that are floating point can have their precision set?

>  
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 5d9a024ce4b0..306afb50fd37 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -880,15 +880,15 @@ static __init bool get_rdt_mon_resources(void)
>  	bool ret = false;
>  
>  	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
> -		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false);
> +		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0);

We do not want architecture to be able to make these be floating point.

>  		ret = true;
>  	}
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
> -		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false);
> +		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0);
>  		ret = true;
>  	}
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
> -		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false);
> +		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0);
>  		ret = true;
>  	}
>  
> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index 1337716f59c8..07bf44834a46 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -590,6 +590,77 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>  	resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
>  }
>  
> +/**
> + * struct fixed_params - parameters to decode a binary fixed point value
> + * @mask:	Mask for fractional part of value.
> + * @lshift:	Shift to round-up binary places.
> + * @pow10:	Multiplier (10 ^ decimal places).
> + * @round:	Add to round up to nearest decimal representation.
> + * @rshift:	Shift back for final answer.
> + * @decplaces:	Number of decimal places for this number of binary places.
> + */
> +struct fixed_params {
> +	u64	mask;
> +	int	lshift;
> +	int	pow10;
> +	u64	round;
> +	int	rshift;
> +	int	decplaces;
> +};
> +
> +static struct fixed_params fixed_params[MAX_BINARY_BITS + 1] = {
> +	[1]  = { GENMASK_ULL(1, 0),  0,         10, 0x00000000,  1,  1 },
> +	[2]  = { GENMASK_ULL(2, 0),  0,        100, 0x00000000,  2,  2 },
> +	[3]  = { GENMASK_ULL(3, 0),  0,       1000, 0x00000000,  3,  3 },
> +	[4]  = { GENMASK_ULL(4, 0),  2,       1000, 0x00000020,  6,  3 },
> +	[5]  = { GENMASK_ULL(5, 0),  1,       1000, 0x00000020,  6,  3 },
> +	[6]  = { GENMASK_ULL(6, 0),  0,       1000, 0x00000020,  6,  3 },
> +	[7]  = { GENMASK_ULL(7, 0),  2,       1000, 0x00000100,  9,  3 },
> +	[8]  = { GENMASK_ULL(8, 0),  1,       1000, 0x00000100,  9,  3 },
> +	[9]  = { GENMASK_ULL(9, 0),  0,       1000, 0x00000100,  9,  3 },
> +	[10] = { GENMASK_ULL(10, 0), 2,      10000, 0x00000800, 12,  4 },
> +	[11] = { GENMASK_ULL(11, 0), 1,      10000, 0x00000800, 12,  4 },
> +	[12] = { GENMASK_ULL(12, 0), 0,      10000, 0x00000800, 12,  4 },
> +	[13] = { GENMASK_ULL(13, 0), 2,     100000, 0x00004000, 15,  5 },
> +	[14] = { GENMASK_ULL(14, 0), 1,     100000, 0x00004000, 15,  5 },
> +	[15] = { GENMASK_ULL(15, 0), 0,     100000, 0x00004000, 15,  5 },
> +	[16] = { GENMASK_ULL(16, 0), 2,    1000000, 0x00020000, 18,  6 },
> +	[17] = { GENMASK_ULL(17, 0), 1,    1000000, 0x00020000, 18,  6 },
> +	[18] = { GENMASK_ULL(18, 0), 0,    1000000, 0x00020000, 18,  6 },
> +	[19] = { GENMASK_ULL(19, 0), 2,   10000000, 0x00100000, 21,  7 },
> +	[20] = { GENMASK_ULL(20, 0), 1,   10000000, 0x00100000, 21,  7 },
> +	[21] = { GENMASK_ULL(21, 0), 0,   10000000, 0x00100000, 21,  7 },
> +	[22] = { GENMASK_ULL(22, 0), 2,  100000000, 0x00800000, 24,  8 },
> +	[23] = { GENMASK_ULL(23, 0), 1,  100000000, 0x00800000, 24,  8 },
> +	[24] = { GENMASK_ULL(24, 0), 0,  100000000, 0x00800000, 24,  8 },
> +	[25] = { GENMASK_ULL(25, 0), 2, 1000000000, 0x04000000, 27,  9 },
> +	[26] = { GENMASK_ULL(26, 0), 1, 1000000000, 0x04000000, 27,  9 },
> +	[27] = { GENMASK_ULL(27, 0), 0, 1000000000, 0x04000000, 27,  9 }
> +};
> +
> +static void print_event_value(struct seq_file *m, int binary_bits, u64 val)
> +{
> +	struct fixed_params *fp = &fixed_params[binary_bits];
> +	unsigned long long frac;
> +	char buf[10];
> +
> +	frac = val & fp->mask;
> +	frac <<= fp->lshift;
> +	frac *= fp->pow10;
> +	frac += fp->round;
> +	frac >>= fp->rshift;
> +

Could you please document this algorithm? I wonder why lshift is necessary at all
and why rshift cannot just always be the fraction bits? Also note earlier question about
choice of decimal places.

> +	sprintf(buf, "%0*llu", fp->decplaces, frac);

I'm a bit confused here. I see fp->decplaces as the field width and the "0" indicates
that the value is zero padded on the _left_. I interpret this to mean that, for example,
if the value of frac is 42 then it will be printed as "0042". The fraction's value is modified
(it is printed as "0.0042") and there are no trailing zeroes to remove. What am I missing?

> +
> +	/* Trim trailing zeroes */
> +	for (int i = fp->decplaces - 1; i > 0; i--) {
> +		if (buf[i] != '0')
> +			break;
> +		buf[i] = '\0';
> +	}
> +	seq_printf(m, "%llu.%s\n", val >> binary_bits, buf);
> +}
> +
>  int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  {
>  	struct kernfs_open_file *of = m->private;
> @@ -657,8 +728,10 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  		seq_puts(m, "Error\n");
>  	else if (rr.err == -EINVAL)
>  		seq_puts(m, "Unavailable\n");
> -	else
> +	else if (evt->binary_bits == 0)
>  		seq_printf(m, "%llu\n", rr.val);
> +	else
> +		print_event_value(m, evt->binary_bits, rr.val);
>  
>  out:
>  	rdtgroup_kn_unlock(of->kn);
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index e6e3be990638..f554d7933739 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -878,9 +878,9 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
>  	},
>  };
>  
> -void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu)
> +void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu, u32 binary_bits)
>  {
> -	if (WARN_ON_ONCE(evtid >= QOS_NUM_EVENTS))
> +	if (WARN_ON_ONCE(evtid >= QOS_NUM_EVENTS) || binary_bits > MAX_BINARY_BITS)
>  		return;
>  	if (mon_event_all[evtid].enabled) {
>  		pr_warn("Duplicate enable for event %d\n", evtid);
> @@ -888,6 +888,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu)
>  	}
>  
>  	mon_event_all[evtid].any_cpu = any_cpu;
> +	mon_event_all[evtid].binary_bits = binary_bits;
>  	mon_event_all[evtid].enabled = true;
>  }
>  

Reinette
