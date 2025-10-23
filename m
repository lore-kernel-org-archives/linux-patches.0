Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426E72D9EE8
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 17:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761241801; cv=fail; b=IExaH1GPQsMlB7kYYEdRf7aOiu5brIbRWh/KZuI7KKceov8lzI4YGPhPK7bOLVRExZyA98RYdRu9O19JmpmItG6Y6t7Cdcb4JwOxuR5uUArQgCsOUyROwVUU8pJiaTpv/PZ/I6Wp5F08826ceUVEU4fTz5010Lglql+E+tCJdaQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761241801; c=relaxed/simple;
	bh=FEb9+rOrg4HVotbSONUG2CzGpXco6fha8YKcZn1Z1iA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c995Aj/j4MiFvv2n/2F3XqMiFI9sA0eKZOoODqMioAePK1DsophEy7W66XkRyW3JUgm7FrpPEd1kgMr+JTfyyuofZM0qWlooocQnHMBxEQYkD8dff9bLzrzP6DBMXmF7tN5/YbNUBxm0E3lmTXTnPJ4AFIQowb62awotZevy/Hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KZf//Kb9; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KZf//Kb9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761241801; x=1792777801;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FEb9+rOrg4HVotbSONUG2CzGpXco6fha8YKcZn1Z1iA=;
  b=KZf//Kb9UxpSllox9U/X+RufBNOfSUUTIOGf1oY5NkqqLdInAuRO5R3K
   zO9tEjLOTuuGEq6mqj5NS9nugZPU96jYkzgxOyXtaESDvHmEpxIdES4XH
   trp7N2HocDpxvMOMo9aXHX6MLlQx9KWGd2crur3Zkc/tRbyhB5VC00EpX
   MhaqEv/Dp7/44nnQ4eHWeu3ROCDowrTCDPmFBK574JpSkrNbUTx9V+nma
   r+CCUZsoiWWbqPqAUALMfcJmVpit3/GsN340f+vwv8rD9P+kweJ06Kdxs
   YxMsvc539i93+ii0nR35mRmJTEs+9sKlKn0EYTrVKEmNCRY2VQr0zNivs
   A==;
X-CSE-ConnectionGUID: qInY/ZSoRmKpdrXs6o7HRg==
X-CSE-MsgGUID: BQ/WN3TXRzSnyzr/HkE/UQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63324179"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63324179"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:50:00 -0700
X-CSE-ConnectionGUID: Co0EB1ukT8SkhiYg7w5Oqw==
X-CSE-MsgGUID: fG4+j3H2RNa1d5lAS9kqIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="215141536"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:49:59 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:49:59 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 10:49:59 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.56) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:49:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ufmnddvvnPahyodCNla8YKloDFMnIfjxKYo5PgEMNRNxilZBhj14hbGwVQGAuDtyskb1anRUj9TX8zAVcgqHsIagHKbyLfIoAq9EIasmcIcluOxYJoMJOy3tvqhqAadEyajajUQ/4MHPT8+LI83GgXImyLRZOYA4V11/sp3CCUKfUF5IP4Njz5mlvFHKe7u8WIPxwd4L/ND1IUBJfRgtp0mDxZn/pflJ1JSOJBy57UtSxCra+uJcfCfnJGGqWWI4UycnEHrVfoUVon0WxUtv/jWigNqGFF59hUjvyAf6YeV0INR1EjRkCgWH54AYSCPlSyw4USgeSPONQqEYnqtK6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zskNe/rark4RifgVpSNZyuwrnQBzAEcbjzpjEErL2T8=;
 b=r6egREQpg8/BDYVAnOal1hO32rNxWxemFMRPxHGdQYjmLMgN8a4H4M932ca4iaLuJHQVf11H0P/tRfw1ePVVFrvINZO/ShJGL/zT8B/htfaq5ptkPV+ZGxfetPoIbscviHWmwSi+fl/DsP6P/gxkY6RJ1OlXw/AGbK8LwZcLm5AKll6UT/VK55ac2fWIGnSVc16oEGwluSYLZzyoDUHgCckJkAZ8GUi5CPEbJzU11UOlgx7X51jiCeHezV5gyN7CGmntjEqyAJxWzu3NKFKuKsx1Oi2ZFvHqsOucZCXlwEBICnBMCHRbW25qfW9QDQwvKRVCxACvydTWlrsOcSIM8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB8469.namprd11.prod.outlook.com (2603:10b6:a03:57b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 17:49:56 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 17:49:56 +0000
Message-ID: <f772f72b-86cb-49d2-b55f-655efa9b9d23@intel.com>
Date: Thu, 23 Oct 2025 10:49:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 27/31] fs/resctrl: Move RMID initialization to first
 mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-28-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-28-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0134.namprd04.prod.outlook.com
 (2603:10b6:303:84::19) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB8469:EE_
X-MS-Office365-Filtering-Correlation-Id: f3bcf5f6-69f8-4997-1e81-08de125c93df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?akgwTGJrRjlQQXM4bU1aQ0VJWFMyQzUyL0dyOFd1N1BlZEdvUFVPRkR4ZGJo?=
 =?utf-8?B?VzN2SC9RQ3NhcnJOWTN4bXpIYmRoT0s2WTcvUEp1SjBJVTVuMHMzb0FtaEZL?=
 =?utf-8?B?RTgrQ1V3Qk1EZ0UzQU52TS9hbGltMy9SYjZXd0lzMmpLSG5RdS9sYjI4SHp2?=
 =?utf-8?B?QjlzWVhhVG9NTjJDMHRDMENmNFBpaXg1OEFhUk1DTWlyUkVBQ3MycFJyV094?=
 =?utf-8?B?ckFQREVLdk8wbHNqUDhqU2ZMTXNWR2VGenFqemt2RDd0UnkrS2dtT0pLeXc1?=
 =?utf-8?B?UmplQWc4SG92aEVWVG1PUUdkSmhuUkxiU1hQSlh1TU43OUhFU1VJaXkrbjN4?=
 =?utf-8?B?YVoreUxiU1o1SkQzZ2RrdTVTV0JESjZPbGdYS1RqWTRhTmE4M1ZUTjI3eFpT?=
 =?utf-8?B?WjMrVFJnS3hlZGZqcE5TK2JPcUUvakRYSXVyV2h1QmhBSzllS2dsNDJMNy9Z?=
 =?utf-8?B?VVE0OFYrMnlETXA0NERQUFVsSmtta1NrVnFLMExocndUbFZlcU9MWExYWWdG?=
 =?utf-8?B?NXYzbkdWV09RZS9RbHdhTEVaeUdhWHZuRkVoYnBLSWl0dDJxZmNzVjQ2aWpH?=
 =?utf-8?B?dGxML1I3emhwRkg5OUF5ekNZS0Zjd2szOXgxQVN2aWxOZjhmN3ZuTDFMYjg0?=
 =?utf-8?B?MWtqVU1kNkZxYm13cHVhbkdUV1BIc1ZqdmtaclFYSnNMcm95SS9QVGNmYVpT?=
 =?utf-8?B?UU1xNmJBR0grSzdPRlpmSk5BN1dDNWlnQXRBMEdqQm04ZFBPcUFvSUhZd2JJ?=
 =?utf-8?B?d3JPSnBIYXRVNTNHZ1ErN1FQYlhER29SbzAvNWNNTTMwNXM3V2NGT3NTU3dV?=
 =?utf-8?B?UGVOZWtoV1QxRUYzQ3lTQmp6cVJ6V01keS9hZ3N6cHpoUkRLbnA1S1JpUE8y?=
 =?utf-8?B?TkEyYzNlR0xqdWtnT2RWUTdvZWZLMUZwQzhTeEVZOG9Ldm1sZHNTRHd4eEts?=
 =?utf-8?B?MUJKWEh1M3poZkJ6VDdWZjc4a2hXYWtPUUFiVFhqWUVrclFCOFc2YVppTjRw?=
 =?utf-8?B?WmVldHdDSFNzNThGOWFhbUcvUHg2Mm5pOGJCdE5CTTBMdld6V1VKQUZWU2dq?=
 =?utf-8?B?K3k0Z3NaQUFvQWtiK3FzbUFzcjZ3MDVaaisxSlk5aFJXS2lJQXJvLzNFUHB6?=
 =?utf-8?B?bnB2SnY1Tk8rb0l3NWxaemxmUUkyWDl6b0RrN1ZJeXZERElINXRDMkFrRU5V?=
 =?utf-8?B?Wk92aVgzWGdSdUljam1oWUVCTHJ2aEl4NTBZQTBCUGU2RkVIdGZtcWs2ZlAx?=
 =?utf-8?B?VFc4SmM3RVVRdS9GODdCYW8yaGZSc3EvM0VoRnRyYTRaSnJWTnhUK1ZUUlJ3?=
 =?utf-8?B?akZHNWFBRHJwak1tRE1sWW1GaFlPdzNmaWNPUmJ1Nkk1dmE4eUFvcXF3TWxX?=
 =?utf-8?B?WXJOVDNUWGlRalZPYU0vMWV6c1NCZDQ4ckxSM05NRGlEWmJyUnhtVDFXd1J3?=
 =?utf-8?B?eVQvTjhqTEM3UFhxWTdGRU9pbkdNT21KWDZNVFd2aHNYV2psS2dLNkkrb0NG?=
 =?utf-8?B?ZTcvcEJYYXR3TzhSZSthakRiQnY4WFZzTGs0ZXV5TDRIaXhNeUNsTTB4YktB?=
 =?utf-8?B?SURKcFVQcW9qemNnVkFONXVZVFNmd2Q2VjVCVytaNGFvQWlxRjdJWC9FVHA5?=
 =?utf-8?B?NlRsa2pQb1MwMlpOZjBOMDVYb3VPSHc0OFBWK2t5c05zQVNiekl3UCtDM2Ry?=
 =?utf-8?B?V25aNUVqZ3B1My9HYnk3eUJST0o3L3doczVLWHJEZUl1dW5McmtKNVZmV2ZL?=
 =?utf-8?B?anpoZnNGRGZnb01DVkQrTzUyWFRHVjRxRWRWU1dSbmNsTmtRem5xNytyR0xp?=
 =?utf-8?B?RlFSZEp3OVNkVk9BNk51TDlWSlJIcHhPQ3BNVDhCYngyRUE0Y1dFY0plY0Fp?=
 =?utf-8?B?NXZFZmNZZHN4a2gvYVVYZ3BPM3B1VUxscTVNWXIySXlEb1lVQnhxSGt6VjJ1?=
 =?utf-8?Q?kNmFVk8zZUNiaT24JEHTlivdO8q+TdDm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjRCUjIxVGJSd3dCY1EveTdOcW14RnpmNnZyTllZd28xMHFtdEQ3c2xFZnJ2?=
 =?utf-8?B?aHhmK0hDOEFjZmpCUENVTmRPTXVtWEYvNWVrR1BqU1gxY3B0RitNb0dBU0xC?=
 =?utf-8?B?Vkd5UDJ5SXhjVDlOY21Zd2dTdHNacHRqbWtINXUxVmtyRWh3d3dPTFd4M2Iz?=
 =?utf-8?B?NkhOOU1aSCtaVVpXZXhkQTd2emQwbFZSMisyRnhPWEhFd0pXeGFNb1lHR1NG?=
 =?utf-8?B?cnpCQUZUam45czdIY2dRZExnT3dEMGFHK3lEMXdDWUlVck1nV08yODJGenNH?=
 =?utf-8?B?L05oTGN3ZHVrdVpXY1dPRE1DZVNrdHAwbVJPNnUwd0lYTzRXMzR1UWhJS25O?=
 =?utf-8?B?bldZWXozSEpJd21ZVkJsZU81Z0gzVS9TZENOMXQvUG1KbVpEbC9oYUJZVXMr?=
 =?utf-8?B?cUVha0luRDVDbTVJMDVxbGN6M2xpR3o1Wm1xMVBiR3h4NHE4WGVQSm80aGl5?=
 =?utf-8?B?VC9ZVk1JSFN1MHV5ZG9Zbyt6dDNZWVRlRm55RTU0cEJzeG40TTI0TkVCUHpW?=
 =?utf-8?B?WWc0ZjUxNHpYYlVNbEJ2d2tZa2ZBM1Bpa0E3UlJMTldhQUJnMkdQbGVZeFdV?=
 =?utf-8?B?c24xSzRZR24wdmFrY3B4c1p3Y3NxelhUR2pMZlYrSGROVE5Gd1U4aEt5OFRK?=
 =?utf-8?B?RFhJSisyZHZDZGxXODl2ZHNKaitKMVZHTG9iZmsvL2dHTG42LzA3elZrUXRj?=
 =?utf-8?B?UnlDN2ZFNmt0b2ZqajBzeXpqZ3A4RGZuOTBnMG5uLzNleHh6em0vcGxXM0FZ?=
 =?utf-8?B?L1ZObFZNN0V6VEtvdi93YnhWS0lUMUZoSDBBR3VJaUdKd215UG1YS1FQcm13?=
 =?utf-8?B?MDBiM3NQSFZzSmFsbjNKWGtoRTNRYjJjd3VnTW9nNzlERjMwbVV5eEZBQjNR?=
 =?utf-8?B?Uk1sYmpwaDNXWTBBSlQ1ZFlwRTk1ZWRNNGJoNmU3WWdXakdIOWRlQ3lSQmY0?=
 =?utf-8?B?eW9vQkttL1RFSVRab3pnZ0YzU1hUb0V3MjluNzMyZnU4R2kzMm03TWFjZnRS?=
 =?utf-8?B?MGFJWHY4N1VMK21GTUlFc05XVWE0UmdRNUoyNHNpT21zU0V2NmVsRkZNenV1?=
 =?utf-8?B?REM2MGlOdDJwNU0yNnV4WTNwdkZzTnRkQzd4dGVoMUtKZGhwNGZQeVh1N0tD?=
 =?utf-8?B?UndoVy8rdFZmOEhIeFM5MGtyMzY0MGFEakRjTGxwNmJyWGpEY204NmowNWpo?=
 =?utf-8?B?aWkwL3p6dlpYRE1FUGZzckVYcnJLUnlpNDVnTDdlNWdkQi9aWURObWZ6MmZv?=
 =?utf-8?B?aFVpa0RZOHFvR01Qc3FyU1RwWDRHMWtnZ0VrRTMzQXRkcGNhM3ZJbHJOMHU0?=
 =?utf-8?B?TW1PNHZwSkVVWFJRWDRFTzF4WXkvMXAvc1U2VWlzWU81YWZtZUtmSVRkVGpp?=
 =?utf-8?B?cTNvSGpoSUhMRzdXM2JtNXd2ejFKVExXb01Da1ZiQmIvSDZXQ1UyZ0hTNzJN?=
 =?utf-8?B?Rjdua005REJSVVRVMTZUL283MDdvMWx3M1lTdHhjcngvMVk2Rnk2ZXE2WlhH?=
 =?utf-8?B?cm5wbFFWUFJZZC9lQWJLK0Q0LzNwY3hZTHBHUlF5WFJicFJBaWdiRkNJa0da?=
 =?utf-8?B?Q0JQMlFPZHB1ZHJBRlB6UGgyYWtRZERZbVRRcWFhbS9uQi9BNi9pU1JNbXlx?=
 =?utf-8?B?SlZ1K1JHTk1xYklpN0twUExJU0hESzRqRXBld05jL09TSER1WVIzdzNEVnN1?=
 =?utf-8?B?MHlRbEQvN3FVMndXS1pQV0xEeC9lVElUcm1RZHgxWm80MW1jaVZ3Q1VKTUlt?=
 =?utf-8?B?ZGhmZkVVOVNXalByT3krcVI1M3dneFNWVTBoY3QxeFA0dXB0ZWNkVHBrbUJz?=
 =?utf-8?B?V3YxcUFxaXpoRTdTeE1jTlVRU3BCSHZpZzdvYUpZak9WWlZKdy8xVTNmbW5y?=
 =?utf-8?B?OFFyWkd1Zng5YnRmbzYyZHZ6Nms0SWhMSGRodDkxODFwaDhGVWdnR1E0R0hB?=
 =?utf-8?B?QmNxcnRhUHBhNVpBUG85ckVSaUdDTG1lY2VkUDBudkF0MytUQldEbFpoUmlU?=
 =?utf-8?B?R3ptOWhwNDhVUlJhaFk1alBJNDYwa1MyNU9lakxGcU9BL05OUEdBdUxEN3Jz?=
 =?utf-8?B?QmQwS2pEK1U5bDg0SVdqY081RmJVazdKM0VtQlRnNHZYS1FGUzJyL0tVc3B5?=
 =?utf-8?B?cGNnMm1pZ20rYURyYU9kYWpZWDA0bUt5MGhUbDhTbWl6UVphR2NTUEZVWXlK?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3bcf5f6-69f8-4997-1e81-08de125c93df
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 17:49:56.2032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7e46CKalelanoVSBLnmXLWevBg800JZZdLVhrbIdJc+FPUrsAGdTfxM0/zgZJ//W8XcEZ92RivOhqF7O4s1JmP+95TmUy5yuJrTDXRT29tI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8469
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> L3 monitor features are enumerated during resctrl initialization
> and rmid_ptrs[] that tracks all RMIDs and depends on the
> number of supported RMIDs is allocated during this time.
> 
> Telemetry monitor features are enumerated during first resctrl mount and
> may support a different number of RMIDs compared to L3 monitor features.
> 
> Delay allocation and initialization of rmid_ptrs[] until first mount.
> Since the number of RMIDs cannot change on later mounts, keep the same
> set of rmid_ptrs[] until resctrl_exit(). This is required because the
> limbo handler keeps running after resctrl is unmounted and may likely
> need to access rmid_ptrs[] as it keeps tracking busy RMIDs after unmount.

"may likely need" -> "needs"

> 
> Rename routines to match what they now do:
> dom_data_init() -> setup_rmid_lru_list()
> dom_data_exit() -> free_rmid_lru_list()
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
