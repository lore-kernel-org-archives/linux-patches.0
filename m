Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D8F25F97E
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753485772; cv=fail; b=jh3Mcas9fI0dCsy3p5N7bAW1bmB4fJ/coHLYrkL9+gLzHEl8ztx+YouEvBVIFABnvB0PXhQBVQhldR0FCi8pyxoQSS1ao21fuvr1MrinbcwEgetCi/8zYLuV+Z+Cgzac1HSdh+M2IrCExm9sKfVpao5T2IUkFTu+9F/9uk1vp+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753485772; c=relaxed/simple;
	bh=7Q9Q1CMfg0CanpcmbeMmA70/4LSThAcLfUz2JH2qv18=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rvGxyUjBZP9ExuveiDheb+wM2qeh5Gr+qtE9Ae4tZNmZds0Uo4MY1BexCyVOh9Rt0hH0bEj5MKEXuGJU4kEZbgmpazsrT/JOR8AeUiaIR8bTLGxJM4PO/J8YBEdPQsrcRnBcJqbPC7oqb/DNrX17Yyv8s8i8FcHcwyn927BCmyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iFz916CE; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iFz916CE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753485771; x=1785021771;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7Q9Q1CMfg0CanpcmbeMmA70/4LSThAcLfUz2JH2qv18=;
  b=iFz916CEk7sqomYSea3Qpf9Hy+yHt3jTeUqCsw6adjD89DpMDWx6GSsN
   NPq14QyNB3+i+Ei5uXj+iWqaEG+b3Cguoob/3oKl2+b1EJ+cyodWk+u9r
   WNOKm9M6gPWvh6ytBSM4hq4ltSrACYmCngWl44m85DcM5tC6BxmSxeCIh
   uIgafy/N9l1L85YVo3+m8oTrRK2SP5hRcwd1BF1pbvjQSMnlPLbx22dKy
   SWktnDBH19jCeu93CnlOKLcZeqGmi1IYctYuiD9hLp+OBd/6KG5+95Oak
   sLZURBogzbK+2DPNiKqEX5eh8lxWQTM1blMZhHRqfS7pUidQMXfdwfj7v
   Q==;
X-CSE-ConnectionGUID: sRMrenN4TXWXm+5OTR/seQ==
X-CSE-MsgGUID: qoM6ZTggQBqONDHw4U9hiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55791900"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55791900"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:22:51 -0700
X-CSE-ConnectionGUID: eNumac69TIuf4Lda9YH8pQ==
X-CSE-MsgGUID: SQHu+WB5TS6KTkh2b0f5tA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="160394170"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:22:51 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:22:50 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:22:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.78) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:22:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GCyv7aaoWbdOYAinf8hT+VrTeYQnuTXxB3MKcK6oyFuKD0siI6ItIZEeiKcMRdd+O1t6HMShVLY1XiNqTAVPwWlgrMRPK21zp/tcH6OdI5n05aMTuarY7YhFdggVNv6X2b3DDZrccyYVztkVZ36ahjZt+ApXbHM0qMIX3oHO8zQY9WkLfG/r/I90YCnrpu19622dUUvBIiBPsTRooXZzLCp8JLtNgl7ES0NQFhC8AIbSf0fFXVbFumOIpt/S3y9YhLfUM91iXsSgb/co53kg5i5VB09WiNthKd7XEEruExLR7TO56njt9bFAFNySADe6SI9j55IPPQ0uH32Yf1niuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iTV8tiyHHFNTlEDUhpvi/M7TMwIwktUh7CfFPFiowow=;
 b=MzPWfLwqWFog/NldUGmzyuBTSQC+ngC9sJjUfqfJgJRbYLuw4ozL8bAy22xbdkiSsIDuD2LMXtVpmawFCWz8Tt5Clbmf/oyL7Wjm33iNoze0XTVsYpqlqAbMv2lOi9POwErBjmZmeUFlPXjkEm/OQU1fBb+pHP0qctZ89V9K3GzfNIp7Gp2pmNED4mRR8/WgcD2fuic1HzpiZgBMCP8ygybU8HWRCm/mfRsGwbWts7eHojmjG1e4sip7oxU1nbLg7kBjG3TDbAlR6iCzyqSOJ3KOhnEaWSFKt+fWmv5IuWfmMCj6c+Z/jW6U7dZsetCeWaqjnzemWcCjBarBU3+rFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB9419.namprd11.prod.outlook.com (2603:10b6:208:564::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 23:22:46 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:22:46 +0000
Message-ID: <3053177d-0eec-4392-9164-a1b93acf8494@intel.com>
Date: Fri, 25 Jul 2025 16:22:44 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/31] x86/resctrl: Clean up domain_remove_cpu_ctrl()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-9-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250711235341.113933-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0298.namprd04.prod.outlook.com
 (2603:10b6:303:89::33) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB9419:EE_
X-MS-Office365-Filtering-Correlation-Id: aac2e9bc-dc98-4c4f-f049-08ddcbd229bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?czhWUmx3N3U1em5XZDhSRVdkelIzVHRJdHlSVDhLNXhNWWFFanRQS2xjL0NZ?=
 =?utf-8?B?R3M4TTZ6SGh4YU5HeGRIc2l0clpuZ2FkbysrL3RqTFgzbnVrRlk2czVFTVNJ?=
 =?utf-8?B?M0owTStZOUhocGhCb2JpaFdDRDZBRnMrbnlubGNNV1pSUUJJMEhSOEhISWNu?=
 =?utf-8?B?aDhtRUpCUWhtTHZyV2ZRd0RFWXN6QWVzVXVlbUdvcUpQTkVncU03bXlMSVdE?=
 =?utf-8?B?dVAvbDgyM3lvV1RseGFNMUV0UFNyeEUwY2Y4T0loR0M0dGF0TmIwNXdORm1v?=
 =?utf-8?B?cTJkSlhFZGMwZzV1TzkzdldNQ1ErbDQ2N3c1MzR0cmNWK2d6Q0pueG5EMHhv?=
 =?utf-8?B?THVvcGhnTTdCZGdzOWNhUTBDeUd3Mm9oQXl4M0JpYWc1ekhIQVo5V0ZiK1g3?=
 =?utf-8?B?eXBYaTk4ODdXZU82bGxCdVpYK1lLamFvZ3Z4K1R0WVFOMDNLc0lJWlRDTWhV?=
 =?utf-8?B?dDVseU1jV2RBVmQ0OVRYU2lWU2xSRFhNT0VlKzBVUkFnZ25kQVJJUy9naXhm?=
 =?utf-8?B?dFVCUGs3VzNlSk8rUFhGMG5iQ284a2E3S1pOS3Q0UmlDQ1JCY296YUJ1V0RI?=
 =?utf-8?B?QUZxTllKOUcvUUlJbDJvaWpOMXdGUjd6azZ0TGc1LzdvVWhWSGUzNzhKbDg4?=
 =?utf-8?B?WXVJRzNvVmF5YjdDMFlMVzFhQVJHUHdkazV3aWpKOWExVDUzQUNzOWpqdW5I?=
 =?utf-8?B?VUxNM1p6ZFFVOVVreFFadGhNNE1hNUNPdENuWWVnbStXaW9DVGRMa2ZjL3lW?=
 =?utf-8?B?QU1wRlo1a2hobEE0V0tHY0lGSDlobTVkU0ZCUTFxVmQwSk40RjVwTWx1dmlm?=
 =?utf-8?B?bmJPS2psVnFGTVRrS2NDUnRJY3U5UjUwemdTblR2UzNuOFZBanF6NHlLTks2?=
 =?utf-8?B?QkxMemtoSU5OVkg5ZzJ3ejg2elducy9WdDh1d1VCaC82NThJWmNZMnpWMUtm?=
 =?utf-8?B?dzJabGowcFBGbjlSQmpHMW5DVVBGOEw2eWVDQjY0b3NKSEJ6VGUwMUVJTWdT?=
 =?utf-8?B?SGw0UXFzdGpOMUJwSVJLMXFtWVFGNlZRZnNLbXdMUEY4UklyNUNRbkFHVndx?=
 =?utf-8?B?TjQ1NU94Mm8yZ0JSMTlOaG9mck5COWlwdHJOWDRPbEFhblluU3pVMzZTbVNE?=
 =?utf-8?B?VFV6aVpzVGNlUURTYjYxaW9lS3AvMVFicHU4Z2xvTWZkUW5sbFBtRjZDWlIr?=
 =?utf-8?B?N2NMMGVkSVhLckF2RlIya0dnWWcrL0FpYUVZWkxlS1czNlovMEJmVDFHWVlL?=
 =?utf-8?B?M2Y5YllwZ3hhWXFFZzl2bjJmaWo1cmFWbE40S0JOUUI0bmpGZDVVeFVUdWpq?=
 =?utf-8?B?ZTdReHpscVI4TzZsWmNXMG9jUlhFR1Y0N1lvUzRRSG00Y3F4bnVJVkNrU1dZ?=
 =?utf-8?B?TzlDbDYxekc3Z1BzNW42QXViUGFJeWpuZUtkdXJnUGhtRGMrUHFSbDg1aVFP?=
 =?utf-8?B?SFpCQzZaQkNYZ0pqaFE5aEo2dG1veDBjamltQ1lBN01VOEc5VGllRVZHUGNB?=
 =?utf-8?B?RVN5c2hWR05rQXhzMEJaZnRlWng1TmNoY3Nwd0lRUHZBQlJQQ1ViZy82Q2hG?=
 =?utf-8?B?WHFZdjQ1Y1YzQ1BjN0VZWlRjSXlVYmRsMHRXcm5uWktIV1U4T3ZXOU1SOG9r?=
 =?utf-8?B?Ukt3WCtUOTMvblhpalZoREVBUXcvTWdZVzVoakRydkNzWHpZWStnYkVGYzh6?=
 =?utf-8?B?MDVPR2NZYXZHQjZLdnJsa1NWcW1qWUlmWnhaVDdwdFpXVXpHcWEvMS9CTTlE?=
 =?utf-8?B?M2FFVUlIL2MrVXROMjlSeFUydTB3N1JFVmxVZUtiSEhjODNaTGFMV1ZDWE1p?=
 =?utf-8?B?eVNJV0NxVWdlR0VUaE1QdHIxNkRMRDZBalB6RmIzYzcwQWNkWmd3SlNtUFp6?=
 =?utf-8?B?VzhaZGw4YW5TSVJBZWs5WVVhcjNQNEYzbXFaU2lpOVU3YnN3Ukp5VldSOWRB?=
 =?utf-8?B?ZWx2bWNJQ1NEZzdIUXgyOTJaandoU1RyKzFaM2ZEcEg1Mmo2N3NmYjhCVXhZ?=
 =?utf-8?B?R2o4eFE2V0JBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dldKSTdsbHErbFpOTWlnc2kzUG5ud1owTmF6Uk1qVGtnY0ViTnJBc3RwcVQy?=
 =?utf-8?B?aENuUllDUHo0R1EwekZiaFU5cjdkdHRMYWo2ZExNSU0vaFFoT01Td1pMUzll?=
 =?utf-8?B?Um4xaTh5MXJoTS9tV2g5RWY3alRua2xNdG5DWU1aVlo1eG5RUWlIa09FeUdo?=
 =?utf-8?B?SVZ3elQ0YzJiQksvbFdPWGVTQjNoZVc3VlNwODlhalFhQTUxeGtoc1ZiandE?=
 =?utf-8?B?THJxUk94U0Q0anNmMHl6QUhPOXFQOUFKNGkwMHRlcnplbWZxbmp0ajdxd2x6?=
 =?utf-8?B?NklwSGMzKzB4cUVLckcyaThtMUVIRnlpS29HYVRiQmRqS21UT215elo0SHNV?=
 =?utf-8?B?UFRVWUFUUitkNGMvRmFRQnREdUFzcjJoVFdzMFVFR2QvNkdGZHJFVTRLOUww?=
 =?utf-8?B?czhYL1Zqd0g4b0hobWVmcUdtMTBJazBFcXhMZXdlcDZ5LzdGWm8xcFZFODNP?=
 =?utf-8?B?Rm94K1FZN0tsU3ZzaDBoS1A0a3Z2VUk4UWcxRTlCZFlISC9wbG1NNXZLNnBT?=
 =?utf-8?B?dzhlaDZzUlgvK1h6SnEzOUNha0tuOWdheVRRWlpJVDFWR2JiOVpCRjg3cEp2?=
 =?utf-8?B?aDFrc2M0UDhJK1N2TU82YlJsQjRDcm42V2hNVmVtOUJxU0pDN0lhWFllOUpQ?=
 =?utf-8?B?ekpuM3JuMUswcWVpcUFoRFFZRnRQNklWSGNqdzZXd2pDWE1NWjNhbVBUbUNO?=
 =?utf-8?B?ajBEN0dnYlowS2ZvNlhFSVpVQnlxRmFpaTB1a1V3UGI3V2UvUjBNb0dRUzZh?=
 =?utf-8?B?MU5DUjdaOVh5Q3NzVkU1VG5jcm9WTUVjR2dabFgyMEtsUERCc0F0NytWOTFP?=
 =?utf-8?B?clgzUWZqRk9iZmJpQTlMNENxdnQySlVXSGlBMFgwRi9QSnAyZHRCdGg2QmtS?=
 =?utf-8?B?V2s0bjRmSXg0c2dCNXdES1dxTnBoZjR6U0VpQVRUcU1xdFdYNXNxNWo2QXBS?=
 =?utf-8?B?d3JPM0cvd25GOWVXZ0xBcWJnNllYNC9BKytrdWJVQ3hURHpQYmhEOStGWnBQ?=
 =?utf-8?B?NE1iRksxWTIrb3ZNVDJhSFhWc2ZhcEFpQVFsOFpvTzdnYmNpdjExWVMwcEJF?=
 =?utf-8?B?MTJtM2VNRmVQbU4wdFBhNnpmYUFxdDVQRUlXcDcwOFpBTmxjRk5GU0F1YUtI?=
 =?utf-8?B?OTVhWXJ2cllpYnZxbk80TUF3THJraW1TYm5IL3Y1OG5ObFl0RXRSYmJrUGk0?=
 =?utf-8?B?YmRURllnTkhFYU55TzBOdkFuY256dzlmRGxLWTNUMExKbnNMYTEyMVlrdThy?=
 =?utf-8?B?cXFnOTlqdHJqWE81dmJmeVRUOG1iZnFKYVk2TDVTTW4ySVZUc3lPV09wZjQ1?=
 =?utf-8?B?blRCbVBpUVI2dm5IMEZZMnExUXprY2ZZalRhNFpGV1FKZXNBNTJSVDVBSnU1?=
 =?utf-8?B?OFllWHJ2SWVrMUxxeWUzNmJBcnVTdjNjY1RjajZEai8zL3ZxaWdHMnB4VldL?=
 =?utf-8?B?SnFHNW1oWXozL1FKUmxrRnlrME8vb3hjemY4Mk5RZ2tKOVZiM3htZHhLQ0lO?=
 =?utf-8?B?YmNVWHpKQXFUTldBYTU0aVVpcUM2ajZjeUdzaDhkU29Ua1lSdEJ2R2xzVFZB?=
 =?utf-8?B?RWRGM3VRczBCcXBad2JycTJxRi84eHNoUjlUdVVOYWFqczhBWm96NUV6cnZR?=
 =?utf-8?B?aElodlhPTnlZZTRaTmFWZDFmcjVBY3kzTkpSVG1zK0xHdjI3WENyT05mU0xE?=
 =?utf-8?B?cnRhZ2RqaE1lRnJXR0dvdnN0TkhsNzgrRmpsZkFUdmJ1U3AvZWM3VVJRUjNn?=
 =?utf-8?B?ejB1L1k2V0NNYVVKUHpxU2doT1RlNXJtbnVXNnlWUlp1SUZYbXJ3SXBIaG5o?=
 =?utf-8?B?YjlIWU1jL045emdvcExUa1Zvc2x4dFZVOVAxdjNMOWcybmxDeU5JTDJUYW95?=
 =?utf-8?B?ZGNLMmI1b2xlem1OQWcwMG1ISndtRFRBM1RWZ1AzTEhPNVhYUWRMdXVJQVJs?=
 =?utf-8?B?OTlYRStDVTFWRjZkNytJdkM5dzFZUnNBNUF3WDdJck1SVFBPRWUxVVNwRE1Y?=
 =?utf-8?B?Y2NqNGdQYXR6YloyQUgwdXY4RVhjR0lDZHRZcEM3V1F0TlA2UU1SUW9TNCsv?=
 =?utf-8?B?c1BnWUFWaUo0NFhabFIzWXppTG81L0ozUUI1eHFHNWpLdi9lbWxhNUhzU1k5?=
 =?utf-8?B?OXd6OEd0ZnI2UENtb2JFQVUvMEpaTTh2WXZEakQ3c1BHWXhPUVg5bm5MRmFx?=
 =?utf-8?B?S0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aac2e9bc-dc98-4c4f-f049-08ddcbd229bf
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:22:46.1710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DkD0RetMpIYcZPGyrx62l4nzAQ0KDlYHJYVL8MIOc0lo0yBYWWuWNwD17rkDDnxFYyLFcnhed8zw6VeGfWT4t0NVTSq6VwH327CAcMar/Rg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9419
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> For symmetry with domain_remove_cpu_mon() refactor to take an
> early return when removing a CPU does not empty the domain.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 49e17c246c60..0c5ada54bb20 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -602,25 +602,24 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
>  	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
>  		return;
>  
> +	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
> +	if (!cpumask_empty(&hdr->cpu_mask))
> +		return;
> +
>  	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
>  	hw_dom = resctrl_to_arch_ctrl_dom(d);
>  
> -	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
> -	if (cpumask_empty(&d->hdr.cpu_mask)) {
> -		resctrl_offline_ctrl_domain(r, d);
> -		list_del_rcu(&d->hdr.list);
> -		synchronize_rcu();
> -
> -		/*
> -		 * rdt_ctrl_domain "d" is going to be freed below, so clear
> -		 * its pointer from pseudo_lock_region struct.
> -		 */
> -		if (d->plr)
> -			d->plr->d = NULL;
> -		ctrl_domain_free(hw_dom);
> +	resctrl_offline_ctrl_domain(r, d);
> +	list_del_rcu(&d->hdr.list);

nit: this can just reference hdr directly.

Reinette
