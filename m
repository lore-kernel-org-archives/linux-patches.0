Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57536227B94
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 22:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752012343; cv=fail; b=TBCQQxMQ4BNDJrEzB8zq4Rcos7afSvKkQSmmYAGxXGzevT4SPIXvAAFaWA5uTzPoucGjpGBUVd26ul7KTfy+7FibuRGBAGs2G0G47r/4FEKYjQOfGNkH2gFGUDAgDOqA2jWuC+crhWwtcGnTY9VI3A8ZThRTSVgjYvNCYH/RZbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752012343; c=relaxed/simple;
	bh=fcWMj1W3wkwz5fZREurrt/jd74Tf68FUN3MYlMWO8f0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=INw/f5nZ8aj/qp5O0CtERYCsK4H3tT0l/+5wKI14VsFkRmxjcQ41K2IBR1P5Hg4ylO2E/ZA2AwpH6h5Lbyi2F/9bOXcYTIK3t0kfYtghQemzEUoIntyGNJdwLUGB+/hZh/yW40/elo1dQcXClCakdJM+NAMtgmlYwpfEaScYgnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gl0TQaSx; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gl0TQaSx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752012342; x=1783548342;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fcWMj1W3wkwz5fZREurrt/jd74Tf68FUN3MYlMWO8f0=;
  b=Gl0TQaSxEtUxE6s8Nx7YtQlfUTPlUJOK0B5jt05oQMyEGJwMHSM0YapE
   feDOFOhExNxCODrMdywpcc84XgI2SBsOSCTdHCKe04YA7d72uaxiLdt4f
   wb9Pdvp1r4yO+j2jNPFVs6RDZA6w0gwdFduMukdl2ddWE+Oeh7783f7Jy
   SbAE4ym2oo9wPqUDBOKox+H7w0N3biV+8cxIa6ws3bbAdq9wv7QRBo3uz
   GodUgBfFt2l/9r0BnRq5vE7V+DvaCu3g5Dfv6YnSyUZmso7A1EAQ/zz+f
   ZWULFzaExkH3j2KBvmvjO6Eivxm5X+zm9FnNyMjZu4ihzu8ovETV1pwUY
   w==;
X-CSE-ConnectionGUID: QyJCGHzsTNOJ1BrrrvYIeA==
X-CSE-MsgGUID: 9Y2E7LbCSDKgoICXQO0h3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54405028"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54405028"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 15:05:41 -0700
X-CSE-ConnectionGUID: p3gNGEZYS26kdwgY0pjtgA==
X-CSE-MsgGUID: 9K8qhcCdSJm/qXkEfEQ50A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="156090248"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 15:05:42 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 15:05:41 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 15:05:41 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.65)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 15:05:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eCgXelpsE+JGYizY6dLwOkfL8GK0c7N6b/M6oEJftlyckmVsnlHRBaaCA86zLsidwL+RvGGkO8x7Y8O/miMOsv26iRG+mQRZc14fvaLRGgBzDYCrLWk8OB37rVAcMVmuBm5TMxXKmHPPnlb3Ojr+zYTe56mMr1UIRxz80pt6rkfvOsSgVkJWaykIHNln5e2JUBjYwdRY5M+W0y1WNzkHqCjb6PxX7pfK5WsP2M3yRjxEZBQF+jt7JzAb95nflK7NHtp2KG6Ppz5gJC6+T7A7ra7jLypIJSBnBN+ePGwJBBGk0n2uOk9/Z4CFxWeBEDTfN0DBsOL1n5mJ1R8tzbhz2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nnYOUk+7qhdJXPs8pLNdW8i3IpgmN9YPzOzwEnAPGvQ=;
 b=cSf4o8SS9ogXrmMtgDeNOOJG35uyKmrI/wRCTW6UD66tlaK6TjsV4ct2dQKHdsFc3oYVRVPXLUo8DOkU9Q2Wd05QZqMCqHkQuwoPw3EVGR/jsiP9t38BHFaK1pXDOb6SbmD43fvrbYR0m5twuDCimOKDtBwPvWq6QtVGHNSwPTjXk3vslp+lVy3/v+wtG8UJL6byKFy1dQQCXSD5UKbxK5/b6priizwDtWFg01dQUqCxIK3aCz4VhgFFjs4nrLAhNGMVUCJYxmo/5gR4UI0AnKHuOmMsCtd7nn6Mm8q+s/8n18Zziv7B1wfVUuWTNao61bymewREdSnflvl3hbNCoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Tue, 8 Jul
 2025 22:05:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 22:05:38 +0000
Message-ID: <882ae5f2-08a2-4d7e-ac9f-088c7b3f241f@intel.com>
Date: Tue, 8 Jul 2025 15:05:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 16/30] x86,fs/resctrl: Add and initialize rdt_resource
 for package scope core monitor
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-17-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-17-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:303:2b::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB6077:EE_
X-MS-Office365-Filtering-Correlation-Id: 5890464a-14ba-4331-a58d-08ddbe6b922f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MGFCdlpwNGlwWkpFekE4V1h4K3ZKR0ZHMGtFTmprTDJsTEhzTklCck5hVGZr?=
 =?utf-8?B?K2hjN3J1OWl3SkNTOTZqVG5KbG80dzF2WGYxR3BLcVQ0dm0xYlk3bUwzdUw4?=
 =?utf-8?B?OEI2TGI2R0FweVZsVmpUcWNHYzZmaEZKNUFnOGJia1ZBQUJQU2tOZzZWVkM2?=
 =?utf-8?B?UnpNejFRVHdhTm5pWkhQMVY5eCs4N25TYVRLbnFpblAreGF5bGcrdXJpNHVX?=
 =?utf-8?B?RGErU2w2TytwSWxwUWRGanVuY0tTZnJlcmJBNG92bmtOZDYxOGlNbnprTVhU?=
 =?utf-8?B?dVdaWHhXR0N3cmNPRzdXMXlIZ09BOHlsN3lQSUVkbnpxNW91d3prekI1Qmox?=
 =?utf-8?B?YXBFZHl2YXQ2dmE5SEVncmVBUlFyNGI4V0l3SXEzNmNqUlBxaXU2Yko2NnFY?=
 =?utf-8?B?TjQ1U1AzeG5DN0UzMDM5UjZxSDMyMHRRY3V5WkNFNFhQY0JEN08xVnhBRE82?=
 =?utf-8?B?Sm0yR094RUdkM25tK0hodWdjZjNsOWJPajBVY25TT3Y4TnV1M0hEWkN1ajQx?=
 =?utf-8?B?WjRralNkVnVvV0lpY2lMYzJqdjM1KzYwZy84aFJndytZYXZtTTRXSG9pbG1C?=
 =?utf-8?B?ZlltVFZPc0FKQ0QzMkRRWWtGWVNuN05uZ1JTOVVPN2phUm1yQTV3SDlxVllJ?=
 =?utf-8?B?SDB4S1I4eWN3dXNTUFN5bkZrT0QwaFpJcnpkb0x1T3kzTzdUMXVYSjQrNlBj?=
 =?utf-8?B?M0R2R2JvU3UxWWxMN0h1SmxyTy84V002UzZPMWF3OXhub0Y2WUYxRFZ5cGtR?=
 =?utf-8?B?S0RTU0FaWElxdEhkNmVMMUZEVkZFOG9mOHRpZC9TelZVc2tVdUFYSExxL2ta?=
 =?utf-8?B?NlpkMndiUVNOVHBIUkNKK1A4YU5QbnBXd3JaOGxzc1NTNzhaaXFVMXJKd01o?=
 =?utf-8?B?L0xJRXdBUkFZd012ampIbmNtUGNmMEpld20zN1BZTjNoSm1aNk9qb0tBYUtn?=
 =?utf-8?B?NWdYVGJFTW9vc1JZci9WNDh5OEdLUTdSZjlRdEhVVi9yRERBWG5Wek8zT0RB?=
 =?utf-8?B?TVJnajF0YktpNGdxcHVOckEwWUFkYURqUTlvQnI2UmpPbzRwQWl1eDFVaWdP?=
 =?utf-8?B?R2dscUxCa0ZIVGZFQXVFWDlZbFQzbE1DVVY2T0tnL2xVcjd6dzk4UDlxeFUy?=
 =?utf-8?B?N1ozdjBpN0lmVHVldTd5c1YrSmFVMGFUS0ZhVTZpVjVRQ3JyWDBUWWloKzEx?=
 =?utf-8?B?VG9KNmZoWXp3b0lkM1hjcGlLcGdPU3FLUit6Uk9jVWF1d3BnOURUY2pnYTlu?=
 =?utf-8?B?a3RLL2Q2VTVjeWZ1QkxnSE5CSmRrWTRoZVNFbUJPMjNEMVZEdnBaUWNLK2hT?=
 =?utf-8?B?ak5CckZtMHhWSEJQU01aZkE1SVE0NlNoMWhZeVRtS1plM2hFamhZbUZoWFZj?=
 =?utf-8?B?MEZxbXRZY2JocXRWeW1tYzBOT1M0MWZFZUFEcUcybTgwdjlnNjl2cU15N1Fi?=
 =?utf-8?B?aThydGU3QzJlNmJ3UCtJeUw0elNtaVdhZWRTY1FOa2lmQmdhSjRraVdIRUt5?=
 =?utf-8?B?aFJUQWRWaS9UcFVISHJTZDdWcnlPQnNFNFk4b09iMDd4dC9OQ3F2bHZScEVJ?=
 =?utf-8?B?RHlmaXo2QmcyVTNYa3piMjl4cEhDUmpVOW5IZnFJSGsxMVhSVUxKdzNTY0FC?=
 =?utf-8?B?Vy8yck93VVJxY1oxOHljTG44U1hOWlNmdlBxYVVsQkRWMFV2Q1BoZXJaZGNI?=
 =?utf-8?B?L2hjcXZsb1UrUHBaZ0dpaDl3T2w5dlVoWkhCcUZuRmZWKzdvOXhjRkUxZldy?=
 =?utf-8?B?bjZ0cExBZ1REbWY3aHNsQmlXbXZNN1lvT1pXYVRCazM4Sm5lbXpKakNhaExU?=
 =?utf-8?B?N2N1UVB4ZUt0aU4zZHp5U2hacjFzdUFsWXlYamNGTTMvZjdjL0lTSWIvUko5?=
 =?utf-8?B?UU5rSVAvbkhSKytHbWkwanR2TnppTHdGbkI3dzlJUnJjRlhYN3hseWo5b3ZK?=
 =?utf-8?B?UktPUGpkcEpMazI4NHJGa3krTEdKZnkwUzBCUkFFQ0dFSDdpb2gwYWU1K1Bv?=
 =?utf-8?B?L1FMbjdCVVhnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0ZLQlhGd2VIUC8rRWN2YVh2bnJ6cXBvVEE5RW1KNUZCbmJlejJjdnl3dWpJ?=
 =?utf-8?B?L0tUSkdoeUpBRDdxN3phVXBXSVVROGROMzVlbHAxM0tORkFyNW1UTFFXU0k3?=
 =?utf-8?B?UTJuSmE4eWQ0RERwa2pKckdWcUxYZXNjeE1jUUpucFBZMXNvWEFhU2RENW9o?=
 =?utf-8?B?NGJnNWpaS3NTc2FYSGxUOVFSM1FXY01JWWFvUkRZd1Z0ZHUrSXY5aHA1MHpN?=
 =?utf-8?B?K01vTWFyanRLRUFkRjhtRHRxbTlHRTh1eHJQdEpBQUtwT1RBNitqcDJabzNq?=
 =?utf-8?B?c1FTWkFqSEpGdWVBVTJJSnQrQkl6V2lGM0ZMcWpMSThOeTlpRWtaNmQ2OHVt?=
 =?utf-8?B?SU1mVlFRWGpvelRaUGJyZUFhMVkrc0ErVVhqSDY2NDVJSmEyTnZ0bmRCR2Qr?=
 =?utf-8?B?VGJqZzhwaTlrSXdRM1lSWGFEZk9hMEoyaXNEdHFSVWxtd1hJbjZwSDNCWXRQ?=
 =?utf-8?B?aytWTEJXenRLQ2h4VjVBdlhFNnJ1aWVJdjJycHlDVkErUGNRdHlMNFE1RmNi?=
 =?utf-8?B?MXl4NUtxdEVJbFhhb01ValpjdlJ4OXpmRThFeS9CeEF3d3lTQ3RHbHFEcXB3?=
 =?utf-8?B?Z3Y5ZFZjK296L1BDMEVwbEZRY1ljYU8xSnNML0hnVXVjY2J2UXp1Y3paa0g3?=
 =?utf-8?B?RVRORGNITU5sNEczSGZPbXpGQVJUOTlKNUNLMGpXSFpDUW9wK0E3LzVHNERM?=
 =?utf-8?B?SDJFcXBEaENZU0tVcG9Hc1V5blR1L0ZpbnJNOWVXQzZDSXVnbG1FeUZsbVVU?=
 =?utf-8?B?bjE3bDNyd1FYRGxpTG5UN29xUHFVaVEyN0srbGNqMjcyMGVDR3BrRDhLbk9X?=
 =?utf-8?B?Tm1ZNUYrb0lFcUFHQjZxeXdpbUVPZnVtNkg5SnJ0V0xCVCtNU3pqUk04TmJD?=
 =?utf-8?B?eWdZbUpsbnZyMkJQQmUrcWpmVDRJTXJrYlVHN1BxOEtqRmpkRHRObWdyS3FF?=
 =?utf-8?B?ZWtXWW5uTFRxSmVjN2ZGSHkySGdTR1g5dUN6UGIxL09HQ0hISUJWMlZSMTc1?=
 =?utf-8?B?MXJ6eXdVMnRKRDdHQ1g4NVpScjU3OVJNWnRCem5hMklRMUozZFI3SWdHMXlU?=
 =?utf-8?B?MEU3VGJqamVRNWx5aVllVThYSUJvTVBjL3hUVHl2SHg1Y3FYbzEzYkVEVGhB?=
 =?utf-8?B?OHM0SjV2YkdLcU9GUjY1RnRqb040SzNoQXk5NThqT3p5T2p6OVV3MUUrNXRO?=
 =?utf-8?B?MnpJZUNvS3ZqT0pLOHNxKy8vdUNCRHZFeU5YalViQlBYK3d5azlCYjJ4MVhZ?=
 =?utf-8?B?OFV1VDM5d3ozZXhHbkFnZTR2ZVkwS0JRV2tJWGFvbStuZytiSUk3MzZ3WFBr?=
 =?utf-8?B?RHV3N3JiZ1FYbGRBZjFpaTUyclBPekFaVVZvNXE2S1FFVi9pL1Q1TUZCZEdD?=
 =?utf-8?B?eGx1NkZYT0tHMW91T3ZmdVVzN1BPUmtUZFR1WUdvMDlVQlhJUTdiNnQvK2Rx?=
 =?utf-8?B?QTZBeTVZa3JaK0d6ckpYdmdSL2VsZnhMdGtlK3oxcFhVcWRqQ2h4dUxJWUhz?=
 =?utf-8?B?K0tNSXFOenJhcmYvSnFXVFpsbkIwVWE0Zm9nNlhQTlIzTE1jMFVuVTBOZ1NX?=
 =?utf-8?B?WWczNVRTNXBPbTQyNDVZOFhzbUh1blFaQUVLL2JtOS9PRzJQZ0RIR0E5eWtk?=
 =?utf-8?B?My9OUGRzVlV4RDh2MU1xaTZlbTZUc1RRUmloVkRZVmIyZjV3ajJNU2UxYmo4?=
 =?utf-8?B?MU0rbHlQUjdTbXVvYmdRcnZDS280YURieTIxV2FTdGVZTmdQbjFTbmlzVEg1?=
 =?utf-8?B?aml6d1VLS1RSb1ltR1RoTElMcDM3Qm5tYldoSEN0SmhXemIzZXVQZ2lRV1J4?=
 =?utf-8?B?emVIQjlQazBGMWhmS0Vmd01mdEJ1enZoY2pQOGFSaUhaSnBTTHlJMXkxY3FV?=
 =?utf-8?B?S29UbVc5Z3djTGIwc0c5cEJQQjRSTVIwajN4NFpLenEyWFFGSjJwbENnemdO?=
 =?utf-8?B?MW10akhxTFpFcTZUMzBVamR0RDNFbjJaRmdZRUJra2h0ZTFxeTFqYkdkUXF0?=
 =?utf-8?B?VlJ4OFlvZUhMdlo4WUpDdG5yQldQNmJNYlN5ZlVUdjBCNmJGcEw3cm50SVR6?=
 =?utf-8?B?elNIQVRRaFNDZ3AyekpIVTdiZFk1UWZJeHlhcmN1ekFFejV5SmovNUsxUzJz?=
 =?utf-8?B?bDBQU1lHTENNaS82Y0lRMEpmc2xnUUxQSGVWZmJiRmVUbk03SW1FOFlDUkZQ?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5890464a-14ba-4331-a58d-08ddbe6b922f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 22:05:38.2021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xckbiL3v/WCX55zt1AFPQneITar7wQ579m0d9Khg0MhPEaQY13zK0zh0UbvPRAZfsxKPCzZrr/ALQyE9EasYnUHk5ub4NVL5xiGc+QRiG8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6077
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> Counts for each Intel telemetry event are periodically sent to one or
> more aggregators on each package where accumulated totals are made
> available in MMIO registers.
> 
> Add a new resource for monitoring these events so that CPU hotplug
> notifiers will build domains at the package granularity.

Patch does a bit more than this. This can be expanded to:

	Add a new PERF_PKG resource and introduce package level scope for monitoring
	these events so that CPU hotplug notifiers can build domains at the package
	granularity.

	Use the physical package ID available via topology_physical_package_id()
	to identify the monitoring domains with package level scope. This enables
	user space to use /sys/devices/system/cpu/cpuX/topology/physical_package_id
	to identify the monitoring domain a CPU is associated with.

(Please always feel free to improve.)

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Patch looks good to me.

Reinette
