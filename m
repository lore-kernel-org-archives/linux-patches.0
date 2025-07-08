Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53CB239E66
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 20:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752008054; cv=fail; b=pID473vHgEoiDzjgK+28gZsGrR8WifsXriJJVQO2CFq5jw19E2n7L3sERko5w49XtUxzybcV/TjQONtt8Djo7IWzX0AnOPYOJOVAxDVTBbjjv0gXG9taF/+J3YSYGuIZC6DwRpe2GXEL3IAEI7jqMlu+2Dtj4R9jR1AW/mPJYSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752008054; c=relaxed/simple;
	bh=uH626Lxy3+2wcFyjfs1/HWwormty5ckzptLk78whUQY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ae4uOVUU+hZNAFkmzrG3yBgsVGEQ7B2Ur7acuf5vHcYCJOXm/16Y13FeQkdoSnVdpFLpuh+Jrei0oj8Td2Mng86mBjdUYxI+px8E0EjeVzQJCWEeZzyjVv1MoOIwaEiqaYWj6aURa357rR8LwiRJ9nRqWeBIGv/K2TOiBnt7VhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FOBlppew; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FOBlppew"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752008053; x=1783544053;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uH626Lxy3+2wcFyjfs1/HWwormty5ckzptLk78whUQY=;
  b=FOBlppewBlyP8dyCDUfctIeaVOaVNQihYnvaGOBoXn41wAUCWqtDMk0d
   jXZTvURXRwx6zGtKWV87Jkz5KSd095OuNvvAs/gyQV8e1qiWx978Uaz0l
   uAwI4rZwuJxZFM6FAqBIeMEQQokd+cXsdsW9r0J0PdRR2PDJCrqtleKj7
   Ko3hfvivdtGgpzIbrK5rP9IcnFAX25f9H0SC9bKuSgdK47AahUNXgDklQ
   ZM5ciFqJYqLZkta9LknfkSJUcrUyuONkILvi7uHOd2DWoS8SeXAWtHJGK
   uO1j/3LHqhSNv5yhU+bWpoMuJWDNcrMnHikza57/htCChX45ScQEVhjFm
   A==;
X-CSE-ConnectionGUID: zrDUaBjVSbmHtCIRsu5OUQ==
X-CSE-MsgGUID: oPKcK/OdR2GGgh/TWBGzRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="71842363"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="71842363"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:54:07 -0700
X-CSE-ConnectionGUID: ZW9SGkWjSySh5dK5uvsS8w==
X-CSE-MsgGUID: ug3c3NnySfGUMiy/jv7wxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155006774"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:54:07 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:54:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 13:54:05 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.41)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:54:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vn9aJj8jcHmDUIF68ul0FJEMsLMfOzm0m6AWBTu2fcA+SubgMR2giCvCmdxmbpQyTwNbiFb00IGPz9u19+QPGOh6Sr9irFZvj7RjZMhbKP7Xx6DK1bZ+NeskE+ngW/GRh3L585qAN+djANie22guw8OdZw5F/NxGPEBhcizIWTUQujiap2GUE1Jsfdg+PlsP22hJFUZKSaktAl3cNiql55afeNGH86cFZcD6FBqwHqn37pAEwGFKY28xKRx0dgfSY4up9QA4CRk7bLlq9ZbovcPtj320U/ArlU12CO49Hr1Wg7UqrpBkDAdomvtvk8l68RCxoGEaZ10tj6Ct1C9o0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5u1piQYOZd5WOggJA+i3OAXRgb5gGWPUyFL6bDngN+o=;
 b=uy8F4mKUiuTsm6E/4Llj8nxMP6iPRCMECYFxjxrAGCfdSYY85xv/j3IcYDUpT5S7YtjSTYCIYqwdRNoVlWELhGkNnwYngyDRcR4JtKR0tOV0LPSEg6Pa2VcoxJnMC0A/eHoIxpGYz+Ap559xODBW1uKqe2eCLPjMRDptkLqcrocMrmLf2uvNmGdxJ6uvfW4BjHUdEaUDGiy08qls14VwQBV5lkhbtTmd+bHaW1XjJcQJMY5l8xxl39s6QNblUrNVcKx2RPKICqDhoADR6O+bVxvtjelD1WY6xNCS5TFKEUluBPYsi4NU1XfqKY0vgvv/Dbys8NLhcjUL4KUEkuv1+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB4963.namprd11.prod.outlook.com (2603:10b6:303:91::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Tue, 8 Jul
 2025 20:53:21 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 20:53:21 +0000
Message-ID: <d3d31ec5-4901-4054-8dad-9fd0d9b0e7b0@intel.com>
Date: Tue, 8 Jul 2025 13:53:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/30] x86/resctrl: Remove 'rdt_mon_features' global
 variable
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-4-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: b5e909a7-afaf-4f5e-7370-08ddbe617946
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WHB6akRjWVluemF5bzFmb2E2eGdJR1AxcWpsVFVqL3plVTl0T0liVmFhMi9v?=
 =?utf-8?B?T1IrQTZ5dzRIZndxRDVObnlhSUY0SW9FU3lEdldNc2xwUHZNTmtTRnVENWVP?=
 =?utf-8?B?S3EwRzRsNy9EY29RNm1rWjBzRTlDbzdLN0xmM0NyNlljT3BvakZwZHVaenNI?=
 =?utf-8?B?SVB3cFZoS0pMQVltTlJ5SHdOL0pGc1d5YVBydFZjU2IzU2diUnZkUUFnZ05r?=
 =?utf-8?B?MGNKSFhmUHhMb0FaclFHMDVmV20yZlRSZHR0c2x5THlHeHYwc2REeVhZYVcv?=
 =?utf-8?B?c3Z4bUpORmFpamRqTjFtVDlrZDJFdW1rNlFLQ1VzWjZDOGQvMzhsQnMvMGtQ?=
 =?utf-8?B?OGdoZzZuNjJUSUcyWW9oajNUOHRBWUl6ZUZQNWZjQjYzYW9jb2dILzhvdXdZ?=
 =?utf-8?B?M3FCTVRvQU13M1Q1Rk03TEU3NGZXakN0WlFiR3BNRlpRNmVOOUVvNUpaajUy?=
 =?utf-8?B?OVVDZkloZVJqRDVPd2NycXprZXZuZ2IvaUhxVnBuLzdjcGR4UkxSQjE2cXpa?=
 =?utf-8?B?MTlPb0tJd0VhUmlmUDlEL1BJTU5yWWdpd0JuWGV0Y0pVSGcyMzJxb25yeFRE?=
 =?utf-8?B?UURpNDd3UzBUSEdhbFJYV25vQS9aKzh5WS9GVXh6UTBxbWl1dnFoeVdUV0VD?=
 =?utf-8?B?aUpRZjhrRXhEbWZHOTI2T2RSaGZJNGNXd1hOQ3dsTFkwRGsrM0lua1dFVGls?=
 =?utf-8?B?U2VINm9ZdVEvM1lYYWUyS0x5QWVmTTM1RGE0Tkk2aCtDVXJMbFBOOEh5Zitj?=
 =?utf-8?B?aDBYNTg3L1JUeWZrQk5FT0E2MnZUaVYvVXd1ejR0dGplQklOeE1zUDZZRXVQ?=
 =?utf-8?B?QzBINTdXRjNOQzB3eUFDeFl4SjB4TGZkbnJvK2FybGNrZzZabytxQjQ3SFNp?=
 =?utf-8?B?ZlJXTzFzb2dERGt1VXZ3S3lBbUJ5Z2hSYUExNCt5Uk1NMFRmbnd0ckNmbTJ6?=
 =?utf-8?B?WlRVQ2JacGxQYmcvekc4bHArd0hnbnEzalZPRGJ2TmdwVTZwWS9mZ2lGOXov?=
 =?utf-8?B?dnFVSC9uVmw5ak15aGQ5MHkwZXFmaGwyWGxEb0sxRzRpRWFkSUdOVmwyTlI3?=
 =?utf-8?B?R0RyV0hUMFhVd0FkeGtaVWJXZWdxMmRlS3h4cVBaZDU3dU0yRkROVXM5TGFW?=
 =?utf-8?B?MjdYNmh6bXVaNVBjRUxkTmVWbGJ3ZUpBTHdBVDIrNTd3NjJ0WStoQmRBQmdL?=
 =?utf-8?B?eWhselI3cUF6RHdEcVNYL0sySThsR05ZQ05vQ2tRU2NXeDAxYTBCTVF4THJu?=
 =?utf-8?B?V25PaVVuVmt4TkhtT3k0ZXArSFBpeVZrMlNiVjZpVUwzaFRXM2tPdGlibW5R?=
 =?utf-8?B?c2J3dUxnYkNzK043KzZpTHdTNnlZMndUenNtYjVQRWRHSzlqYzhLRy9MUWlv?=
 =?utf-8?B?RG5aTGtQMjg5d0k0cjdrZkdzbXMyeXR5MW51U0d3UDJuaUwvakxHU2dmMDA3?=
 =?utf-8?B?c21VUFdYUmJ1M3Zzc1cvd3F2TUtRNkErcTBrbWhlditTK0VsYWJIU2tZL21O?=
 =?utf-8?B?ZWluL1BtSlZGN04zTFBRZWc5RU1kTEFvQVZwSmNVaEI3RzdHc3RhSTFmTy9j?=
 =?utf-8?B?VFdFdWJNL2VhdzZJbEY0MmQwR29MUkIxejZMb3htQnMwVTh2OFZyd2tkak9V?=
 =?utf-8?B?SlVNMDMrRDNUSDFBdU9OVGl0MytudFhNM1liSS95bnIwUjFRMjhjL0d0cmpS?=
 =?utf-8?B?NUVHMDVObHBZZU9QM3hrYXFid3NESE9VMnNqTGdkQXdXcDNxTVlwRVFITXhi?=
 =?utf-8?B?cXk0WTNTaGpGYjUydTJDTm5hSmZsVmNUd3ViOTAzKzdOb3k0dW51YTJsd0U1?=
 =?utf-8?B?ei90NmkwclRPOG1wcE9tMUlGUWRLOFp2QUJhayt3cDd6UXRlbEdXVGxwY3hj?=
 =?utf-8?B?dWpaTzE2TW9mTnNySGREQ0pxWHEybjBSM3JNeGEyYlRQYlNlQ3ltQ2VxcXlQ?=
 =?utf-8?B?bmdwQVpaWFNLN21NbkdpQUkwQmVES3RJRFZRN01RL2tSSUJ3RFR5R2YxSzh5?=
 =?utf-8?B?YUYrUlgrVXpBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2ZTSU5kNUNRVUpTVHE1Sko5Z2wrdGNwT3E0aU5MZGdWWTVVRWNROGgvOCtw?=
 =?utf-8?B?L0tzN28rSzk3ZXNqRXI1ZjlVQTlFVStTWlEvSlc2OTRMOEltaXZJNnNYSGh2?=
 =?utf-8?B?QmlLdkZ0aFF2M01zVFRDc1pOc0tBM2JCWDZtS1NQUFFxblV2V2R5WHRNTTlj?=
 =?utf-8?B?eURkNGN3T3ovL3BMVVFTOG5VRFEzTjFLZW5NbGFtbnF0Ym5UK25nYVV3NTgr?=
 =?utf-8?B?ZUJhUEtPeFduaXJ3YnFJWUUweGhCWEROT2o0ZGdRTzNzZmwzN053U211TGgx?=
 =?utf-8?B?enc0OURQdWR2dUxMdCtTSDluc0RybEM4blhOKy9ZM2VXS3FRdnJvTTZmWnJM?=
 =?utf-8?B?cGhjQ1l2R3ltTXhTbU5wNnFFWTA5a2JGOWtUdVYzMEJQK0pDbW1vNlRFRW9R?=
 =?utf-8?B?dUFKQUFOd2w0ZTluK0F2ZFUxcUlrYWhlQ3RaQXRaQkU0L0NJZ1BYc2tNckNr?=
 =?utf-8?B?SWJaM093dVJQY2RvSjdUcEttUnp3NGh3QjF6VkJmQ1p5RVBuUkVOTmRER1F4?=
 =?utf-8?B?QTdZSW91MFljNU90czZVM3JYR1BrdDBQWElQOVhCcDEreG5ISlUvN3RkTlZW?=
 =?utf-8?B?VVpLd1h1Tk1hMW9hby9OMHRwOUZVTERCSlNKQm9kblBjb09LL01VaFdobEhm?=
 =?utf-8?B?T09KSmd0bTRpN081OVVYVytrVmNuM29NRTBjVVpwK2d1VmloWHJXUWI5cGJ3?=
 =?utf-8?B?RXFtWWRHVzA1S05hSWxUQ09yK2pzL0Y5Uk0rem9mR0pFSEZKUmo1UTR0UUNp?=
 =?utf-8?B?T3NMMnBLeUVMNEVTRk9Ba01URWdqT01ySVJ5TlBnMDFTV1F5Vm5OQXpjWVVy?=
 =?utf-8?B?K1lhUXlnVHNIREwwYWZGTVFjVG8xU29ZeTg0SEpoQmxIYStDRFBaVFBRNGJs?=
 =?utf-8?B?VUFmS1NMWjk4aVl6cHltWDVnc2YrWkVQTFhmTUQvUkFJVitONVlIQjl0TE9M?=
 =?utf-8?B?K0EvZmV3UVA5UVdDRHhPSGpjVjZ2NUZaTmIxT3VjdVN1dTQ2aTJCT21yRGFD?=
 =?utf-8?B?Tkk2THFtcE5CcnpraERJSXlkVDErVVNOOE5VLzM0MEkvN2dobkNncEtadXFk?=
 =?utf-8?B?QzV1ZWpzS3VOSzBVSnNZaG5uYlcwSGpIZ004UTNwQ0d0dWFKNHZ4RmRuTnF2?=
 =?utf-8?B?eWZNR2JUbmcxcGEybnBBb3dKSkFxK3c2bWlnNVorR2tnSnFsL0Jxb096bmZi?=
 =?utf-8?B?RVYxQks2VlZQZFpYVDJkc1RxcGhYdUd5STBrek9rNVpqWWtad2F4RzZUeW5Z?=
 =?utf-8?B?OURHd1hWc2pmWUhISzFMRmIyeDJ3QkVGdGNoNFN6WEtCakttMzRzYXhOT3RI?=
 =?utf-8?B?N2kxRGJNQThQZG9YOCtCb2x4VlhPS29HTm1YRDFhYnhlQXQrQWRidlpJbmMy?=
 =?utf-8?B?RmhrOVNLWUgvZW03ampqSllUKzRtWlZTTVAyVGpSdHZ6VzZ3RmZ2QURhRnFT?=
 =?utf-8?B?QTllbXBLOHN2TXR1bXFETVdMb2Y2RGp5YUZLQVdWVDhLemU2VEptallodDJD?=
 =?utf-8?B?azR5MzRTNURyQmpaN21QekZtMnVZT1RhVklFQ0dwWFZxUXh3K1BnU2NqRFFM?=
 =?utf-8?B?b2pQbmxUQi92TjFEbVUyQkpqaS85V3hZL1BkQzRJS2NDc2hXTEV4NTJBaTBy?=
 =?utf-8?B?VGw3bmIwTHdCcERVbjQ0dkF0ZHgzQXdLUzRObThscEFXbkxGMmdRc0I4N3JD?=
 =?utf-8?B?ajNwZmdqckZVSzdSL1hwRGtUUi9qS3NJZW1MRnUyUWtkV3psb0JPL0hUYVZh?=
 =?utf-8?B?NUtIRXNZWVpKbkx6NWo0dDlBc2hhUk0yclAyeFB1YjBnT0lxMmVlZ29nOVY4?=
 =?utf-8?B?RGVLN2dUKzhaaUNtS0pqM0ZLb1A0Rnprci9GeXZrVXM3TkNSQjhIRHlvTUU5?=
 =?utf-8?B?L1REMFlYRHhyZndOL3IxQnNsS3MyZ2dBYXBMUERLYlZLczlxb3RLOHc0Tloz?=
 =?utf-8?B?U3ZUOSsybnhSQ3cxbXFHcVN1eTdDZ0J5WkorU2hRYXJ3aGxVR2dpSEpoQTNl?=
 =?utf-8?B?N1BOOTJaYkJHL1EzTWFCWVlBbzhBMC9qa2luRUt5dk1wSUZpR01Bd1p3UUJw?=
 =?utf-8?B?RUhHbXUvQmZVdndSWlRkUmhDVk5CTmFZREpnNXhGUGlaV3l3RWVSZmtxczdC?=
 =?utf-8?B?d0NHc1k0QVFDVXd6ak9ZN1Rka0ROZHUzSTEwS01SQWw1WmxrRSs5bGFDOWZ1?=
 =?utf-8?B?aUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e909a7-afaf-4f5e-7370-08ddbe617946
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 20:53:21.4187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q3nasUBcR/3SkbulzW4lxjG3dT4RvahxxtLVpe4Ar0jHSBDYOye7fPQGizj0e7DKPHorERBbYH6ABDsd46V2dgTlLyHaPaC8G+hCkHFwYjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4963
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> rdt_mon_features is used as a bitmask of enabled monitor events. A monitor
> event's status is now maintained in mon_evt::enabled with all monitor
> events' mon_evt structures found in the filesystem's mon_event_all[] array.
> 
> Remove the remaining uses of rdt_mon_features.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

