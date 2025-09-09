Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689212517AF
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 21:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757453242; cv=fail; b=ahDD5oF144ME9R0ENHoWJn97JD0YSZGKAj9y4NUuupRZDZ8Tu9s06leFUkvY4Ekk2UEa6484uN0BDwGFHc7b71aAqNQ0CdscO/w/QUoS74dF+5kpEL4BadeQgqag0upvkbAX5LyzTVPV2DRWhEXUHnokxV9f+XnL6293JtlcSdU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757453242; c=relaxed/simple;
	bh=D8Qk4EwerFqbQUSmSDB9O7u68y6to0GZPSsgyBCZevk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NEyQQbcSjc/OK7f89UPXyDynTNTPXMda2ymlply3chBJYhTGwP01xBzUjgOteZLr8hJmtYTktRiP6RszoTQvCdKWuyLm40mbNsfra47MIUuz2Fs8UX3jQR5EenoIIVAD8/9LvJaZ1ffn9iZsK9qf4Nf4l0sGfq14edz5yyRNxC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DurWkDUC; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DurWkDUC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757453242; x=1788989242;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D8Qk4EwerFqbQUSmSDB9O7u68y6to0GZPSsgyBCZevk=;
  b=DurWkDUCEm+8egYTqdBPs2vSoTsYReFvXej1Xf/cny1pPJESNTg1fZVV
   acUH61hPPmZ42Kjzwcgp2suc7tpdhvWOUtODfHh0+vVvtNARHst80oh8Z
   6cCmxi7DlMYBfzLnPejNkLpF8+4mZPduOKiIk6kDsA5lTPIvKG8dUBKYr
   DSbca/9KsOx6QeTuj0wEJd3PPLnoIFGAHjalVwwdwEiQEfA7O5fpBZysz
   eLN4A6wRwmURAB7+ep4UbCCZOVooasovyLgWKfvDkeej9bnXr6rfaByrT
   iq7U6iGDrPKMHxwuHpLPJqHhMDKuyj+pOVVaQTtQ4o+MzcTz1Z8SkQj04
   w==;
X-CSE-ConnectionGUID: UYaFJY3DQeOaZa8nDpwnOQ==
X-CSE-MsgGUID: hUsB07klS/SfUfltV09gGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59816763"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59816763"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 14:27:21 -0700
X-CSE-ConnectionGUID: NUi3RV3dQhecA+jqXtAvaA==
X-CSE-MsgGUID: m+23gYWWTxW4XWDPiu91xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="177474385"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 14:27:21 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 14:27:20 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 14:27:20 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.55)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 14:27:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fE9dRzLbPtXlvscG6w9RU8c7huUasYkFoiqNpPGZeaSh6PentNbJojlvKeU5QWp043IF5np80OYodHAf5ZnQGjOKlu7Ob3BA+a+O3kHCnmlV60Jy+5rPJjJI373fFdVl8dSn+Q0Gjmo6Bszs+UqugRU7gxP1t7RM3WS6ES3q7lT5wa9PqDmbg+SkQlxTacwXq0JlsjO3dpyxJNAGitrWa3IjG54ga9hGjAhpEu6Tqbv9Z5TK73k2j0fFij8wid60/RZqb/ve/Ydz7T6I9FuKDyA0x+GamYBp7R1Rw00tPgqLBQekpeRZYP8xabKET+6UVYP0EbnhiAJ728stG9HZKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B8xS6VqJeuWXCJL+SRpKDWP4JweUX1PeE1qb3CopiIs=;
 b=cUQdNivNzPfyBXSdvuxcZ61bA8xt+EdQ9evngVEM5kwCTm47WwBozuynim1WKo1Pb4i20qqb0z48F1lcpMWliO8PLFgQkzosS+F/ysynjYWIm8QAOfNSE04hs599gnlkPa3NC2zzV5Jc04cqI936qfCmVA6x+mPZMZJO4HDTdAOlowihbThPFPmzNc5cm30xmPvg4kTDDhALMHFb7Ug2JtVftLpq4lRmTLfBdU3Mmvk6ThxB2UWr4IFQq8jv11aBku+saU1xGE8vmos4FZZZsHDhd/EFwlnH/gHMbh52GXawoJDSqoJ970ZNopabKQjNjeXNqXnS2O5ahIIw62MOYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB9297.namprd11.prod.outlook.com (2603:10b6:208:56f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 21:27:09 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 21:27:09 +0000
Message-ID: <40baab62-b776-49a2-9fe8-70307b9b99e6@intel.com>
Date: Tue, 9 Sep 2025 14:27:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 11/31] x86,fs/resctrl: Rename some L3 specific
 functions
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-12-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250829193346.31565-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0147.namprd04.prod.outlook.com
 (2603:10b6:303:84::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB9297:EE_
X-MS-Office365-Filtering-Correlation-Id: a210f2c8-cd2e-4420-cea1-08ddefe7a215
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WktYY3AzS05iZXFMczVJdHFMeG4rV0RUbWkxTXRCbjRpOW1zOVFBWDkvWkRH?=
 =?utf-8?B?ejZIcGQxT2o1ZWJRNEduY0tOSUpvTUM1cVRRWHlKSWpORFd3YVYxYlBaU1l4?=
 =?utf-8?B?bzNqZHhWSUlzeUMyT2FmV2dlUkxtUS84KzB1bVBGRWxNcHdsczBrZUVLekF1?=
 =?utf-8?B?TThySmFFM0ZXdUdiMHlTOXRQWndEQWFQSldWMGoxQmgvU1BhNDl6MEdZOFo4?=
 =?utf-8?B?Z05hSlZiYnlSVGFHUjFHWDF3Mms4c01NYUpyV0dqR1EzN2JnUDN2YncrVURI?=
 =?utf-8?B?a1Npc0NQUjc0SjJ4dHFBa3l5NGFza2E1UC9oMlowMEdTdS84OWMzTE9tMUtB?=
 =?utf-8?B?SUkrU0ZxRVd1U05SeU50bDNqSkhWNXRjV29Nb1hORVI4UVlXaEpCeFRTblJi?=
 =?utf-8?B?ZUh4YlpCcloxWWY4WG56YkgzZVJjb0NmMVp1VXk0b3FWUWpHOGU0alFVMGgr?=
 =?utf-8?B?SGJ0WUxLU0VjcHdCNWhZMm0rdlNMblkxVTlTbFZwTGZwaUt4a09Tc0dKOEI1?=
 =?utf-8?B?VGNhcTFNekRGRDFBRHJseE8rN09CYzJrcXdWemIybHM5aU93a3M2RmYyMitW?=
 =?utf-8?B?UnRQWUpYQXJOVGgwU1VKeWdLeTNBV0tVMXdXUktqM1JmcEpnR0FjRkRrZHND?=
 =?utf-8?B?S0Z1OERVd29wT2VmeDBIaEN0cEl0Tm4vRUZSeUp5QUk2UmYwOWJkRjFkM0NO?=
 =?utf-8?B?bDVpS0wrZzhUNzBPd2gxbExWbVFXZ3pOemJiVzdYK3BoYThSdUp3OThZUEMw?=
 =?utf-8?B?U2JEUnEvUjJiS2d2UWRKZU5jRFViKzFyLzdzSXdXZmY3UnJjZlVQN2sxTVZ6?=
 =?utf-8?B?cTEvQkpxcEM4bCtUUVFoQXFwbStaSy9HRklUQllPZzhUeXJIamZWQWE2dmNJ?=
 =?utf-8?B?TGE3aFZkUEEwYmNYbXoyZXhtSmlYaTE3U1JDQjM1Z3dLUi9VTFhtOUxzQUpG?=
 =?utf-8?B?TFJwcjlqRlRFL1orcFIwMyt2L2NmcU9xcjR0ZHM1Ry9EamNBSEJqS0M4QU9q?=
 =?utf-8?B?QnFsOHNqTkUzaDJxTUVGUTdMSTZ3dUhraVBrdFNaNlNRSEdaUWZvWVBQSjhU?=
 =?utf-8?B?RlJwaS9TUklrMSsyMXlleHhVem9zNEtMN0FJSGxSWS9obU4wUklNclduclll?=
 =?utf-8?B?YytzRG9IeGJCOWdaM1NpTGY2cE0xYW5mYVI2eWRWMUVYQ3ZUZlNnendrNmVH?=
 =?utf-8?B?OWNGdHNacVBVaUJYbEYvRkV0VHRacFlYQzRVTlJlR3BaWUpmSExZV2xYRmtE?=
 =?utf-8?B?cE8yYk9YRWFLcUc4UXBPKzlmTzV3ODRxaGNGUkx5c0Z4cVFOcW5GWTA0QzZM?=
 =?utf-8?B?WCsrYXVPeXpycHlOSW5PMDEwc0N6aHZIZ2tPK1R5WkFRUWFVaEwydVJqSENW?=
 =?utf-8?B?SUt4dGphS0NEeDRYRkx6b3B3dXN4VWUvL1haRXBoRlIzRmxKemFpOFduNW5r?=
 =?utf-8?B?UXQ1RWFKRjlXbjJkVkFpRkpTcG9Edm9JK3ZZcHprQ0tKaHpyeTdvbFFBWHIz?=
 =?utf-8?B?aHdKUnpoSThNaXNaVG1vRnBsT1ZzTzkwVjMyczVWNmUvbURWalhaMXN2MU9E?=
 =?utf-8?B?NVF6QUVIaVZIcjZSenVRVzllR1RvM1VoN0ZyQ0Q4eG1aVDVtbXF4UnEwczJw?=
 =?utf-8?B?TDE1ODR2alUyTkRvVVNVS3c3ZDJDQTdydlcvQ1dkZFZGSGhVUk1SV2pCOUxN?=
 =?utf-8?B?cjNiR2tqWEc3TUlBUGppenJHcEt5M043cng5TTltSEt3dUNJMjFBSEhhTktz?=
 =?utf-8?B?ZE94Wk9RYlJGSXM3N3ozVks1bk1EbXRkOWN4L3c4dUhQRnRCUnM4TUc4ektk?=
 =?utf-8?B?NGY0MDNFcmZkd3dwaWZEVWNZT3FCU0VYOTRjck0yZWdMOXIrdFh3Q1ZjQUVr?=
 =?utf-8?B?UTg5SCtXdzNrTnZEb1l0Y0Iwc0JnQXBPVm1rRjcrTW5SWUJTalE3T2J1L2RC?=
 =?utf-8?Q?ioRcRp5cz/w=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHBPeVhTQ1Q3NE5nM0dXWWNVeHAxdmVHUzZWdHMrZ1FPS1RJNHUxRm1mY3Bn?=
 =?utf-8?B?cGIyVVN6MFhJbTExZDJ1QTZJZE1oaUhEQUZ3ZDA3WG1xRW4rWld3d1dtV1Zl?=
 =?utf-8?B?dzN1UHpCeXNPcTFpTVhaQis5bEFpeUJsbWs0RE5SRWIxM29UTnB0ck5keWFy?=
 =?utf-8?B?ZXVWc1ZWQmJyT1VpVk5HcDRlVytHOEx6VTc1MGhsTXA3VmoyRDRvZllQbWZR?=
 =?utf-8?B?cGRvbG1jcU40Y3pTWGxKZEZtMUE4Mi81eHhzVHdKQms5bEJaK2hCN0hkbW5q?=
 =?utf-8?B?N2dyQ1gxMVVoU0VtaElDaEw2Z1JkSGd5VlNKMXA5QnMyRkNxV1phUUV3c1Iy?=
 =?utf-8?B?R3ZnMlhydlhHbEJjSWhXdWdOKytJOXFqQk53ZEM1NXVPeXVTWjNrdGd4VzI0?=
 =?utf-8?B?emJSMnVXOVBIdHZhdVpFR0oyY3BjRjJIUWZLZ3R5YVhDZHU2dnBkeTJBTlc0?=
 =?utf-8?B?eDBZckVYK0RQZDY4QnJVQnJrckoxNXgzZ2h1T1AyeEhqR2ZGSDdWTXZnSFdt?=
 =?utf-8?B?VGlST2VWbk1uWWxac0Y5dFBQeG9VMzQ2WElyd0hYaGpPMXVReHd2a2xLMFN6?=
 =?utf-8?B?a25BbEVmSmdDbjlIMHlmUHRuRTlnMFpBZURGUkcwL21oOGhiWDB1VFBxRlZ5?=
 =?utf-8?B?MWFmOVI4c3JobkQyMXVjL1dPQnJ1ay9BWGNCVFVRNm1PcXlEbklvWGxwNTl0?=
 =?utf-8?B?eFNlNU9DRHJXM2JMNzlkdW5JMFVLMkYrYS95UWlzMHViWUpQSEVPcTNXMXhT?=
 =?utf-8?B?ZG1Oc3FhcEduYkoxaWpBNDhjZThZc3h6b2s1akg2ZDMvYU1qTEJoNHZCOEhr?=
 =?utf-8?B?NGRoNTdTbEM4V1JkV2FzcmEzL0xRT053V1JBNU1zb0VvYkV6dy9KcFMydEQy?=
 =?utf-8?B?OFNoR1lObWlFbGNNWVFxd1REUmV2Wlk5N2dScWNkWG51NE9qMkUrUzIwYlpG?=
 =?utf-8?B?ZGg0MkFFeHlTUDVIUFFla09FNGpZczdRRG9JUVQySUZtdWtKdVd0SlBBT0Ro?=
 =?utf-8?B?S1JaSTdNc2FoSjZFYm1qaGx1YXArcmJDbUhweHUrYktTWUxCTnlyNW1oU1FN?=
 =?utf-8?B?SXp6T0MrdzY1SnZOOUZ0aUhCdXdOYWRnUmpkWGdOeFhwdE1qMzNmTGZ1ellW?=
 =?utf-8?B?TFRHV29xMWhGcmU1T0V3NkZPUWNmTlRWNzN6WVo0bXBDM2taV2FkaGovTXRC?=
 =?utf-8?B?Qldlbms3MTR2aFZnMnlpTDdtQ2owbDZ0aGZ0SGFTaFVZbDhidXhpaTg3QmxL?=
 =?utf-8?B?QU1hTzFrS1NtVFhHTjZPdUhzZnplNWVvVzQrN045NklhKzhRU0g5NFlhamx1?=
 =?utf-8?B?c09xdlVUMjlpbXhWNXZsWVNCSURnYVBDdnJLYnNraWFDRStVNDFRMHl5cTVI?=
 =?utf-8?B?eVg2aUZuOEJqNEtNWWlhZFBVaFhJUXJCNVc3b2pjd0RqY0tXZWVhT05kblFs?=
 =?utf-8?B?NTB3Q2pjNE83WUVWRGUzNFF2SDE0ODExVy9TOHlOUWtNc1I0bW1OZDZSZUhV?=
 =?utf-8?B?QlRRWktTYjJ5Q0ZKZTRZU05Id2tuTmpQZjh2NHBoc2pQVUlqY1dob1F2VXlz?=
 =?utf-8?B?UFVVQ0lNRUMvNGxGeG0vKzZSVzhvbHJHazNYdkFqOUlWcFJOTEtaR25QUC9y?=
 =?utf-8?B?Mko0VVBLZ2NmaUtSRk5UNENXUkFCWWZORHR0elc1OVhUd1pSTnZMeGViMVVS?=
 =?utf-8?B?QThTMXhhSnl6MXBJMko1NGlyc0xuYlhpWUR1K3FrMVQrQjY0RVdjUXE4OGt3?=
 =?utf-8?B?SWxzek12Vm5FMzV3aytUM0h5c3lJNUptNWVreHlBSU40aTVsZ2dYYmxnbkFL?=
 =?utf-8?B?QmgzK3VHU3pQRmhwbHVlRnBWTnBnenN3K3pxSmVQM2NVcWhTck1jblpxL3Z4?=
 =?utf-8?B?OEdxUWswOGhlaWtUSEZ0eTBoNi94elhzT0Roa243UUZtRDgxZlAvSTJkR1RJ?=
 =?utf-8?B?Z2F5UlNySVlucVhHWjZyTFhZVVZOeWc5cGxvTURId3pqWllUWkhTYUV3T0Rq?=
 =?utf-8?B?YkNIa2gzVnJ0b0tuRVFPR2dFeU1sUGUzNjM3eVFFS3hjSm9PVWg2K3lnQ080?=
 =?utf-8?B?NlRkeHJ5Q09iazFSczRtTCtSWG9oUVdWeGEzMUZoTTBnMkp4OUFCbERmRlRj?=
 =?utf-8?B?aUNacHdHbmFQRG1ZTnFIdVJNcUZXWS9nS2tYTysvMEdlSkpyK3BOcTdiZUFS?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a210f2c8-cd2e-4420-cea1-08ddefe7a215
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 21:27:09.3781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e/qkWlpxawRS6KwneC5n+FCtt7fWQsg9pgHTH0wdeXIrMwM/02+CANY4cHKlk1Rxe+wBBi27dRyrsqTRqa7SFRNtXoaHtEfI6XrFS2DAE98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9297
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> All monitor functions are tied to the RDT_RESOURCE_L3 resource,
> so generic function names to setup and tear down domains makes sense.
> 
> With the arrival of monitor events tied to new domains associated with
> a different resource it would be clearer if the L3 resource specific
> functions are more accurately named.
> 
> Rename three groups of functions:
> 
> Functions that allocate/free architecture per-RMID MBM state information:
> arch_domain_mbm_alloc()		-> l3_mon_domain_mbm_alloc()
> mon_domain_free()		-> l3_mon_domain_free()
> 
> Functions that allocate/free filesystem per-RMID MBM state information:
> domain_setup_mon_state()	-> domain_setup_l3_mon_state()
> domain_destroy_mon_state()	-> domain_destroy_l3_mon_state()
> 
> Initialization/exit:
> rdt_get_mon_l3_config()		-> rdt_get_l3_mon_config()

Thank you for catching and adding this to have all around consistent
naming.

> resctrl_mon_resource_init()	-> resctrl_l3_mon_resource_init()
> resctrl_mon_resource_exit()	-> resctrl_l3_mon_resource_exit()
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

