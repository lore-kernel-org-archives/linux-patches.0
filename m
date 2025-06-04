Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA7772601
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 03:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749008459; cv=fail; b=K5VbwsjBUaKdQeZLvPrbE1+d39X91s1nuOZCZqFUgMwxUAMNcoSZm3uq7obnvCWR7BUuJkYvAhes+isxAwF0g81jcRwd+vj391mdcKIqUzjWnKXuk1/1P9+O0Sbdf7VeoHn1kLeFRP2IGQE19eQ3/Z7N2X3aGlr3IRCpBj9RNYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749008459; c=relaxed/simple;
	bh=mc0wrcCD5DpmLLqhI1o8jNG/qs26VfFxJfsFFsu6iIc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RMRWBwe4PIb3Ie9OYqWzJqaNpBCAJKs3fr6BdK4WUwaWmHOkk4vRv9I8dVyLQa5RJN6LSHasXDejKzg8ryeuwiou9V1a7+GAWmAUtHE82vCGWmcPR9oG9Fdx9Z80C7stEzmQdUNIkojyuJ/lQa6IJL+J4LHTtmIP1rVbWz6XZYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mcOy+fOI; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mcOy+fOI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749008458; x=1780544458;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mc0wrcCD5DpmLLqhI1o8jNG/qs26VfFxJfsFFsu6iIc=;
  b=mcOy+fOI41PYuLbJ+y7kCZ3Z5sM1IMPEDWMo4wOShC35AiMuiP3+/Vc4
   0JhcvHcx4EEAiiQom+38xmoMABc3Va4rH9s6OagEMc/WeufuoKy0OZXQx
   KvNUmmhLbRqAPSXvBPogLax7JGLmJS2pZMnkHMOXDx/4u9VPMUbmFI8qA
   lY+VCN80tvRWzifcqNuXMNX+TPX9aHZambZIHBRHUXEfT1qrfvvS5iByd
   gmSvjWVCfFTbBT0BGCNarieSpcddnpbJgkReRx8SjkDgHTkh/wNls3oFE
   8OzomtSKREoJ3qewcqZ0n935RK77AEewRFYAaZOUt2sHQwJiO+Z56+/CT
   g==;
X-CSE-ConnectionGUID: IaoiWJlxTl+5D29aJkFDNA==
X-CSE-MsgGUID: dDOf2pl8RzeB/HNBBtvm/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="61693627"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="61693627"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:40:55 -0700
X-CSE-ConnectionGUID: zp0bsIsfR2WzcpEPPJBeZQ==
X-CSE-MsgGUID: kgfCWWVvQMiQ9yMs//TNlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="144925071"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:40:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:40:49 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 20:40:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.66)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:40:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rkoDEsQWD/EosfkkhbgLtgCpCj6PAUNkiLBe0bZget2znxFsbHCuH1VkG/QDzcqwGxDqlPEb7aE4DlIc5ICtqXgOStWvaLZoLDIcwmHTK0WBRfU8ihUmSi3H6UZyQlr8HgAXNrxWW/RY28gWoxmka90fJUUr6L0NBi8wz79lvhXG7ApJiOLVozhSs/CCeAMi23cP1jaXTH/Mo2I+STfdOdseJn8lBlc7HZ+QLuHbdquWyQuF6pT0KCizgdciGgwaBB1EXwTmw4MQQnsnwB6+tSsb5xVada830s0hB0jcZmCR5DLeSI+dPCH50RjNRlIsSdGKxWKDlPiOTsPxp6X0nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z4u3YuW5FIKX6wYAJ9FO3x27Co07HwvRx/fq/sk50DE=;
 b=nqK2nz1HYJLLWjI0gDBcX1A3v1l1d6MIGFsd8GOQDVdw37Dja4oyGBCZDFy8cEv076879v0g2aqKUR4izQdwFJQWbPDoEd6UttA19c3hab2abY5owdYktzalQdethsGTVsNIXOP10DsP3DvAbQYWrKYkN9C8ij+OYuWhvS9jrbFZ21fS50JwvIKzhREdOQNiHkAx3mMU3zntWT1osQ9d35pba6k9LTXPRNUInnq+k8MTg34rVSULOrH5K88/F/XQp86CfiWRs6HycLB9v2dA0GcWpbLLO/dl6TXsBMw3apDioShVVWzuhaZPITWh7ypEU/DpYS0xYifIGCy+onc17g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY5PR11MB6511.namprd11.prod.outlook.com (2603:10b6:930:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.20; Wed, 4 Jun
 2025 03:40:47 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 03:40:46 +0000
Message-ID: <22de7c9a-10bb-40c6-b4ad-a371e9630b5e@intel.com>
Date: Tue, 3 Jun 2025 20:40:44 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/29] x86,fs/resctrl: Rename struct rdt_mon_domain and
 rdt_hw_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-12-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CYZPR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:930:a3::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY5PR11MB6511:EE_
X-MS-Office365-Filtering-Correlation-Id: aae9e10d-7032-471c-dec1-08dda3199765
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?azdZUEl0TGxHdHNLSkpVdVRmRnc4cklLdlVWYmViSnZiZXA5bUZBcWpnaVBY?=
 =?utf-8?B?MVdoKzExOUV6YmJvSGxBekJ2dUMrRE1OdVlCWnYvMFU2V3pDZlNJUFhic2Qz?=
 =?utf-8?B?WkJKZVRmVENjMUhicWtkWTg2ekFnck9DdTdBUEE4WlViSDEyS3F3elBGaHds?=
 =?utf-8?B?MlVxM2xuL0VjRXpPbXNuTHkwTVFDWExudVlBM2RrOVcyelJES25Db3hCc2tF?=
 =?utf-8?B?RDkxV0E1SXl6YXd1eU9HNlhSMkR0ZmlsSkVaOWY5L3c3ME5UdVpEZS92UjJn?=
 =?utf-8?B?ZHpEZ2IrSEw2TVdwR2JVYVpTZW0zRWEvTHBOVE51Wk5GY2dnQURvWll6M05s?=
 =?utf-8?B?Q2h0VXJvU0NXQ3FwZDg5WEhvV0lQSkxqeGloekRma2dlbEVjTlFoeTNseTh5?=
 =?utf-8?B?N2tFdjVZemJJeGJoTEhINnhTMnpuSjB4WExxZEV1alF5aTNyYXpGbm1GTDd2?=
 =?utf-8?B?ZW1qbTloNkc5dE9TSFJ1TDFrMC9FWnhUeEt0MW1QK0xmTGlaNE0vd0htUHNW?=
 =?utf-8?B?K204MHhWT3VabTFIZ1F6bWg0TVJCSFFlOHY4N01DR1FiQmFSQ09EQ0I3RlI0?=
 =?utf-8?B?cXlKTWxZYk85czRUYjRSTTNEUlRLQ2tob1oxcDZkaHgwUFZkYWNNME8xZnNR?=
 =?utf-8?B?dnJuZHNEYS9DLzFYeTNJc0w0VVRXaWtZWWwwbnYvcjUxbUdLZkJldVBuV000?=
 =?utf-8?B?bXVHdjR2N2MwL1VsWERJTlFKekFObVBTSDVDanJXTXdTdmlub093U21RaHdv?=
 =?utf-8?B?TjRZbzAxSitBZjJ3eERyWWpOTmZUUlczeXkzY1JGaXI4d1ozWjlxaGkwT0xt?=
 =?utf-8?B?TDlrQlZFM2hJM3BORjRDM0ViMnFxNng4dTh2WVF2OXh2M2N6c0lid2YwODFH?=
 =?utf-8?B?elkyY0JxQ0tMYUNHUzNSMmlGb3lzN3lHZUlNZjhwbHpoVndXT0FBSW5wYVEx?=
 =?utf-8?B?aVFOQzBXVFVhVUh1WWhDekxacGlEL1hRcFRMbHd5UmQxaVhyREZyMm40c1RV?=
 =?utf-8?B?bC8wb2ZiY2QyTkpDZEx3UDNVdkQvREJwd25kNkgwVmV2Mm5SOVB0YzRDdG1k?=
 =?utf-8?B?RUZHUjk1cGhHdmlQTVF6aVY5ZG9mNG5pSC9ib1BHWUNRTFFGODY3MlRsQlRC?=
 =?utf-8?B?b3JXazczbmNWanVuTXQwcUZqRlg4ZzVJaFRyNER6NG0wS2JhcmdIeFFFRnZY?=
 =?utf-8?B?V241SkJFWlJDL0VoanNWL05jNHQ1Y0N5TmprSnE1K0JIRnU1OGUvSnByN2M4?=
 =?utf-8?B?R0NiZWoxcldrR1ZuVmJINXM0Q0JFNXVMYXhGeWgvZkFQUXNTZzlnaWdqU2g3?=
 =?utf-8?B?M3dqQmsxWWF5dkZMU0ZrS1FxVnIvd3FKTUsxQnZ5eXZuSTRYbVdHcXEweTkx?=
 =?utf-8?B?Y2NKc0FFV2htaTZGcnUrMlBDK243QlMrUkZkVkg2L3lyenZ3QlhNWktGZkZ2?=
 =?utf-8?B?L0c2cDdTWllSMTlNbnNVNm1ZeGxqeVlqclQ1NkdmQXMrRTB6NVhKU0tZaGFP?=
 =?utf-8?B?WVJWTnZxWXFMRVFJMHY0cU0vTmphbUhVRk5TSllCcGxOVkhHZERKNUl0R200?=
 =?utf-8?B?STQzL2h4TCtoYVhqKzd0NFc0RDVqcW9OazF1QnhlZUlzYStLV1BBZnVHNDlH?=
 =?utf-8?B?bkp6UmQ1OUxuaWZpNTg3cjZxWlRDOGplZVdjSmw3aVlWaG5sU1pZK1ltK1Fo?=
 =?utf-8?B?Qm51TVJYSkxqdWl6YU9TNkFHUUJyQnArcTFqM25oU2QvN0R3eldRRi94Yklj?=
 =?utf-8?B?UmU5MnMyaHc5SGZ2ZUd4ekU0ZkVjNU5DNkVaWEI3bnE2RllaT3Mxc1I3U1lF?=
 =?utf-8?B?Qm91bkZXUTdVWnYrTkVQd2x3Q1JRQnUyZnZiUWlZZStJS09wNzRXRGw0VWFm?=
 =?utf-8?B?azBkRWhyZTdNOUI3YkNnYmNwZ2hMUlI4ZVU1V0RjUlVuT2N1Ti9YaTlxYktQ?=
 =?utf-8?B?RWZWaGZlWXBSQkpFRU1ZVEpxZUVjSnNJTlFkTDBNVlpyU0M1SUpoRVRFT3Jz?=
 =?utf-8?B?VVFMd2FGM3d3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dCs1R2M2SGxpdFc1bU10NEdpSU1oaklHNE5YSFhsbU5qWGZoY1pleUNBdlZ0?=
 =?utf-8?B?Nm5sTVM4cFkycy8xMDhkdU5nbVgxeS9TV1BrelpVYzI5UFdlSERBbU95MitV?=
 =?utf-8?B?eU5wVU9lSG5GcW5QZ0psTjRCYjZ3SEl6ODRTbVlwcGNMajFaOFdxYzUrRVNi?=
 =?utf-8?B?T01OYm9PWW9WblZQOC9nazVBc3JncHpDbVE3KzdMcEdQeXJBNkc4U2hvdFFy?=
 =?utf-8?B?Q1N4UXZBd2FMalMyZStWRFdWR2tiR3ZWdVhEWlhaRVpXYS8zdjhUQnl2R2JR?=
 =?utf-8?B?enBySjNnSitINjR3cTBsZEluT0xoM3daaDhRL2JUTWFVeXp2MXFvYktTTWVS?=
 =?utf-8?B?MzNHY3BsaWllNnkxeHZoQ2dCakp3aXQrajdmcDZualJML2dKa0RJdG9LZ1Q5?=
 =?utf-8?B?U1YyRmZaRzNPdVBFTDhRcFRJNDVqODQrQzAwYVFYSlR5VjNwOWYrS3R6cndE?=
 =?utf-8?B?MVYxU0pGWllzS3o4WEJKdytBWUF1eGNXUHVzcG10a0hPdE16VU5EanRXWnhM?=
 =?utf-8?B?aEpjbUZwQmFUVXU1ZzhUM2NnYUl0UW5YZmc3OVV2TEtGb2IyajFUV01CM2Mz?=
 =?utf-8?B?eVQ1aEZ3TlRWVGpaZmc3N2VUMEJVcTFna0IxcHdXdmVxVXQ0azlMMUlTT2Vk?=
 =?utf-8?B?R25yMnFsMnUwdmlQckNzcUFuSU03YjIwVTlnMmVpTzhnRFEwWWFwZkdaakI2?=
 =?utf-8?B?OVM4enIzYXpVTGRMY2hER3NoekNzRDNsM0JUUFJLSnFWemJyU2hNQ2IzTFRw?=
 =?utf-8?B?bDNWYkxoeUZQSXFWaTYxbVUwaTkrbXJXUWR6aEJIM1p0VUdxN3FwWk55OE1I?=
 =?utf-8?B?b1VVVWNKcVJhSm1Da2JObnVTN1pJZlVRUzYrZis2S3J2TmlISGpFbEQremdT?=
 =?utf-8?B?djdoWGhtOGppVldvY3B5dElyRk9MdGJUc3BTdmt2bHVDdGtWbXQrMmpzZk5p?=
 =?utf-8?B?QVFaMHg5M0VjRFVjbnBEQjFBS2hYNEtNamJLOVRPWmNpclVsaS9wY2F4VWpR?=
 =?utf-8?B?YjZtdTQwelpERGM0M0owTHZkaFJkeFpTallUNnBJajZrTTcrbmJ3VVQ4bkp5?=
 =?utf-8?B?VWUxeWMrb2NzRmxwOGdJM3c4WVZFZVJlTDBYMHY5LytHbGIvTFpJaFR6Tnlr?=
 =?utf-8?B?UUM4aFRkSVprZXBwUEwrQi8xamRkUU9wV2FJY1Q2K0J6MkNWaXp2WGt6RVVZ?=
 =?utf-8?B?cTBqbm1FZmVmQTlZVkdQZjJId2VndXF5dWVZOVk4QlBqNFRjQjYxMWZNZDJm?=
 =?utf-8?B?N2ZHOU85emF6WGVrTTU2RUxXb2NZNlhoZXhEUmRxSzFyUHpTZUJ5b1lJajVy?=
 =?utf-8?B?bzBrUCtJRmE1NHZWQ3psbE9rTWphSkI5OUxJN2VIMEdiMzB1K2pRUVpLNDAx?=
 =?utf-8?B?Tit3RkJmb3l0YlpjWFRmbmpOTHVCL3RIdDNSb01yTmFrVTJKNDN1ZnFFYmEx?=
 =?utf-8?B?YWE2dElyT0tEZDJNWGlLYmdoS0V6eXJQcUtPci90Vkx1b1pzMksyQ2ZrSE9C?=
 =?utf-8?B?ZUZteXE5OXBFSGVlQnQvM3N2cE9UV1JyS0p1Tlprd3FaMVE2MFRGN05OR01p?=
 =?utf-8?B?RTJ1UjY5aVB0cllZNGFOcVR1S1V4eU5hNnR6MjZoQWJPcE5qOHJRcVBMSVJZ?=
 =?utf-8?B?N3FZdWY4bFlNbEVsZ1ZOMWFGYnZHVFE2Wml1R1A4L21ydTdhUkZuejN1bHJB?=
 =?utf-8?B?SEpPelNVbUZZOUdNNDdYck0wVFVJa1FNeHc2bmxqZ1prWTd6ckNHekxzbWJN?=
 =?utf-8?B?SDBLQ3JIQ1RPTVBKck1zVmxTV2dJbGV5K2lNLzlyTXhVMGN2MWZldHdpbXJn?=
 =?utf-8?B?djY3Z2ZZeHpHcTlOZDNzTHJuK1RneGJRRFZGamNxUU5lMmZQcVEyQllVT0Y4?=
 =?utf-8?B?Y2JPdDdGR3MvRFJOZUxTNWZlK3NacXkra0w5aDVsSFZnaGN1ZGcrWU9sMTl0?=
 =?utf-8?B?ZDE5N3RkajdVQ0xRK0lxZ3hPVmdGMW9HTnJjSG9kYWpXbjgwcHFSWEN3Nm8w?=
 =?utf-8?B?RFZaNlFNUk5VVk1hdGs2R2x4eG9jNnlibXVXclB2cEg0M0JjVi9vMzVMWjI2?=
 =?utf-8?B?MzJiOGhaVzhWZk9MdlB3eUVlRW52NHJsU0dNTUR5WTM2RFpmYVFqMWltVWYr?=
 =?utf-8?B?QkNMbnhUZ3QyR0xxMDFQL1pwQ09EVGJ5ZXk4ZzN0eURiL0pXdkczQ1RDSnFa?=
 =?utf-8?B?MWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aae9e10d-7032-471c-dec1-08dda3199765
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:40:46.7906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QujKik29bNUFhLLxBwz0W7fimOtrntKctPj+Hog5U69S5t95lr/nRdpHZ6kCBDMSBKwrqLy+hrBcGGqzAIMnjILv4FCJnz5egRourd1vULg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6511
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> Historically all monitoring events have been associated with the L3
> resource. This will change when support for telemetry events is added.
> 
> The structures to track monitor domains at both the file system and
> architecture level have generic names. This may cause confusion when
> support for monitoring events in other resources is added.
> 
> Rename by adding "l3_" into the names:
> rdt_mon_domain		-> rdt_l3_mon_domain
> rdt_hw_mon_domain	-> rdt_hw_l3_mon_domain
> 
> No functional change.
> 

Related to question in patch #7 about criteria used to
decide which functions to rename to be L3 specific: This patch highlights
that there are many functions that take a L3 resource specific structure as
parameter yet the function names are not changed as part of the work in
patch #7. 

Reinette
