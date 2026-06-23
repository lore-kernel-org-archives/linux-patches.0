Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD72B392811
	for <patches@lists.linux.dev>; Tue, 23 Jun 2026 18:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782239090; cv=fail; b=Zbdnkja4xHssWKjubXxU5hqByGCRnmVlvvQ2AXb5RfSS0ouJMxt2Sh/T5uU6gMysfK7ktYTglJ7GYvOGad9rboMfl42fErTnbxjkidR6LG9WcjL4kRWInjjOOBY0/YMBNZoMjnVQMmK2MYiZGZT70DltSjI/or+U//b6oTlZheo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782239090; c=relaxed/simple;
	bh=PbweYnqNnT0f4IFwBwmUZ5vrXhu0QMAllUmetLgeGbo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RmopFYCr7JsmWsxWbA5FO83MtUKvsHq6RZfrXQfbGVqFR7A23PXCfnmEmPzdttHr7fhaKUl/xgsslkxYI+igOeBN5R2Ur7Yhxq7Ej9Y259mC/E6eva2HqD+FxEc6ESnfcXD692yDDiMWJmktrYK1N4XxmkGaYEGSakKd0mu7XR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j2VMOBVC; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j2VMOBVC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782239089; x=1813775089;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PbweYnqNnT0f4IFwBwmUZ5vrXhu0QMAllUmetLgeGbo=;
  b=j2VMOBVCx1ekYRw+2nKh3Ylwxtm+B3EeugwS4SKKoQBdrP2YIiMB/d2C
   mFPNG3LAD971wbtnrr6h5auLk2/6rOcesWG/he1e2Fd47qjq5AZY6Heks
   GubZCpCgSaikThBtdFIlitAatsexBR82Oe3eV9cvO68A/EmYXfmsJTIZW
   G435PQ1FnQp66Kg47KYhsBeqy8tPkfmDNM+7VeOD/WTslH5Te3brky5g5
   IWFkl3ok9+m341sEnIfwV8ckxYGXvlU0ikbMXpb4bSe/ZdhE58Hp3Qjte
   Kf+kJGnypTI88C3C3T4E442SXq8mqlp0LuTH4J+G4bxnis8tn02Aj1XGu
   Q==;
X-CSE-ConnectionGUID: uO9eNjkCSB6Xf8DqVJtGSQ==
X-CSE-MsgGUID: jLx4o0J9T9Wvvx/wGyE+cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11826"; a="93645172"
X-IronPort-AV: E=Sophos;i="6.24,221,1774335600"; 
   d="scan'208";a="93645172"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 11:24:42 -0700
X-CSE-ConnectionGUID: r80vPn75S/CmTvUX+Bj2UA==
X-CSE-MsgGUID: 4s7SMvw6T5esXH2P4LMH9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,221,1774335600"; 
   d="scan'208";a="287716934"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 11:24:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 23 Jun 2026 11:24:41 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 23 Jun 2026 11:24:41 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.70) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 23 Jun 2026 11:24:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vFWnOKjbuaQWpXpUZPRuEMeKP6XmaAr3pKzlg+ktkfZ/HFEYj+Tf/o/UWfOlpnWouqHeopQ6Api/IaN0mQqhaHM6Zi4n/DonbMRuj264o15PtdrGSut9TeSGfBnlOZoVCeI0SWbFsCgLJlQ1Y2ftBdKFbdpM9g/aQl6+WWmhUlzTs4OK0U+NlgTElcwxHS+Imyk3NdfrqJXoLk8+eJcZ2/2Hi4u6jGsXQ1So1UG+afdoWYuFknN/vq0XlaRTP/tIjisE1VHKV/QME9H8LVN0w7kZ/rWEc7YPF0nwVP0PU9/dtpT8VC4bSO+ul1RL0sQFfhPITfw3xTsirrg+6l9SLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PbweYnqNnT0f4IFwBwmUZ5vrXhu0QMAllUmetLgeGbo=;
 b=VmggNBi37Pe3JlFB9oIHz+maB2roNEUn8XRF2wItfioCN6lS/IsVbFRPukoP8JP4t1+b4U7nA7Wgd/I9MYcq3/rcVg5HUOot1SGhALcNmF213XpEatDgnpOWrHboQpicpSqEoOhp+cqWpnnAAeWCaLqWh7CfU3UygtOiqvdO/3A70FkrJ6e95xGon/1imCNbgaPn53vsYj9otcUWduybpnX0Z6hvPGKW9sQe83pNG1ae8kmp050iwV1kuRLj5nWihDUiNlNTfuKNzETrViaOsnLoJ4Z1eWUqixGgAnHzcKfICa51rJg6BfBdeg868yi6O+DabCM9G19CQIwRryF58g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA2PR11MB4924.namprd11.prod.outlook.com (2603:10b6:806:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Tue, 23 Jun
 2026 18:24:35 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0159.012; Tue, 23 Jun 2026
 18:24:35 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v7 10/14] platform/x86/intel/pmt: Register enumeration
 functions with resctrl
Thread-Topic: [PATCH v7 10/14] platform/x86/intel/pmt: Register enumeration
 functions with resctrl
Thread-Index: AQHc8gDNtD3j8fByXk2FJYBa9biW3LY1V1SAgA+TugCABe2HgIAAeUCAgAEYqwCAACwqkA==
Date: Tue, 23 Jun 2026 18:24:35 +0000
Message-ID: <SJ1PR11MB6083F621043126C0E5FFACA8FCEE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-11-tony.luck@intel.com>
 <cdb00b39-383f-4751-8e5a-3986fc92a889@intel.com>
 <ajRf2P2ChE7SExwO@agluck-desk3>
 <ddc91d49-c861-4737-98ed-9b5d2e583449@intel.com>
 <ajm-jVzj7TUeJkY-@agluck-desk3>
 <fddd44b4-a3d3-4c37-8a01-2c5b55c36657@intel.com>
In-Reply-To: <fddd44b4-a3d3-4c37-8a01-2c5b55c36657@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SA2PR11MB4924:EE_
x-ms-office365-filtering-correlation-id: 56070f15-3586-46bd-4218-08ded154ade2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|18002099003|22082099003|4143699003|11063799006|56012099006|38070700021;
x-microsoft-antispam-message-info: wmxCEBtYneuVn04rgJ1zxFuZe/AA+9mezPxCXewRA2GV4e0fImvuuNtT3tjlIvnfmKhztFZdB1ME77Ju+YRNBn8f2+fOyEwULEpntd9oc6g0Z7Nbmk+KU7X0KWquWr+jS93X8b89ETfgEfiUdm8ZCZ2wdgPs98B1MOrcGG/OureHqKne6KH23c6NxGPPTpW0izlFXOxBT+pE7NXiJu4bPROeulT9bJRFZrS2xyFnwWn8jrwy7+iDoGAEAs73s4xaC31/mnkpucR51BT8z7dNxCUetEYabtny8F8pmIM0jQUR6zU/8VG3cLbP9a1GSTzy9JPGcC5o3oxLKeAwbyrNSpXA7tawpnDKanxVsBnrSL91o02w/NvX3sUBOC/7cuStTWXUXTmY5NPfv447Qns+C9QjqLYa1axpuHumu04Vd0ZiYJqD07zQyU0zDsWiHKwmfNQ1kbwaXPvSwOkemnLbgUded60siG30mkBJU8TBAuP/Zo5KhVsjD7Jv+kJVcDUX27DFg2fr2JbBWkC/QIi3KgbKCuoi5RJACZPZV00jIX9/r5H9G/oWfe+Ksf7I5JtjM8UQBJBSM2YL2es7aaDXk82+larn/1kS0AFqnqnFGOioXqKW4XswwRerEKwpuIQJGR/T1IY5NXc+Cud1Q4YxaquCbFm6YhFr7FUPdBxcABOaIFT85JvEJKpLIl92ZDgbLiG+lwV1ZfMK3FNvVyVDl9pf0PES/21owBhNOTFbEyM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWdHUkVQNUZhWThETG4vcXlBVkRndFJUUExaQUxEeHYxNU1JalVNdWxvVWhO?=
 =?utf-8?B?S0djNzZSNVBzcUNDS3U5UktOTWFtMnljNXdyOEx2d3pVTFdjS0FRWDJVRFhP?=
 =?utf-8?B?Z2VpbjNJNHljSUNnZWlHY3BnaGpId1VZYVpmTEV5enNFV0VMMkY4ak1xNlYz?=
 =?utf-8?B?TzliaXpKVjhjU2VrajRhRy9CUWFFcVlZTnVjQUdyN3FLMnliMUwwelRBZys5?=
 =?utf-8?B?VXIzTlBnYU5WMG9HOW8wOG8yZndEMTBTVUxVMVpSZjArL0FLbS9sc0xsM1d6?=
 =?utf-8?B?REJSZjQzNnBsak16bVNMZEJkV2wxSm9lcHkxSlNzYmUrNTl4Qi85TmpWY0pq?=
 =?utf-8?B?SnJjSTZZOTNPeGxYZDlpbER3Qm1rTkJSSWd3V25ZcHZDY1dMZk9Sa2Y1Y1VT?=
 =?utf-8?B?LzAydWhqRk4va3Q1OHBsMGU4SlBSRGdqaCt4VXhuamxRRDlHVVE3K2ZoSzV1?=
 =?utf-8?B?R0ZqSUlBc3RkZm9KYzNYVERHWWg0WkwyT3lBaVd5UndQN2ZaNUhWcVQzc3pH?=
 =?utf-8?B?Nlk1ZHpwNFJ1ZkxzdUJyNTNyaDByelAyMFNUS2VsU1RqOVBSSWRHb1FsR1VC?=
 =?utf-8?B?Ynk4aEpvbGZCdG5ST3ZVSVR1OStVc0ZzSzFWcThwa3BicUVYa0JicFNiblhr?=
 =?utf-8?B?NzRpWk8zZXlCNWJRWXZTVDFoVWpmbjdpK0M1WTdGYS9XZnp3UjVWUkVscitI?=
 =?utf-8?B?UWNFZTExc2VmcXZDbFBQcDVQNnNRYzJwVmtGT3dTMUdSdDYxOTU2ODk0bkFy?=
 =?utf-8?B?WVZuWWk0UjdRclNqVjd6VWp3Wi9yQUxzTEx6Nm4yREN5aWRRREJpNUJxQ3Mz?=
 =?utf-8?B?cml4NFR6bTdLVkFyVW1DNmNBQnh6cVB6WExyeG5hOTM2RE12b1lhTDMzaDZz?=
 =?utf-8?B?b2xYZDVZSSt3dzBNSkFMMFhlcld2VlltNlNXQ1ZHOXhvcHpaOW56SEgrQ1V0?=
 =?utf-8?B?M3NUSnJPcE12ZkhXcjl4bFByTHpYWlRMZGlTcWhJNG12UzJ1QkJPYkFUZzk3?=
 =?utf-8?B?bmxxWHNXSm9SRml1bmt0dTVpUW9xU3lHWnpWblZldW5jVEp0SnExdTdzeHhU?=
 =?utf-8?B?RStyUGg3d2tKTzhiS2pCQzJGNFFRUmcrSnlwMTN2ZmhXTTFGc0FJMUJYM2lZ?=
 =?utf-8?B?VDdXMTBOb2pzQ3EybmR4OFV2aExJZ1dVUGpyNDJXNnFLclhDd3RxcDBISDJP?=
 =?utf-8?B?N2RRQjdsKzBFRUFkV3NIUHN0R0RRQndmVHl5R0cyR1JoRFh4c1JCakhHaVVY?=
 =?utf-8?B?b2hvd1VrV2ZWaGlmZXBnU0tBQXJEU3Bsa0NKUFp6QkJTRkhSbFUwWmUxdUhJ?=
 =?utf-8?B?aEhidjE4TS8weUJoR0xxeGxjTHpBZ0FYancrYTREclpZU2hpVE40eENUeXVC?=
 =?utf-8?B?bzRGSWtPcU84YVNpS3REb0RCamh3b3EyS1M3QU9SOTRLZWZuRmI0U0UwSVla?=
 =?utf-8?B?OUZVbDYyWjllWElpREV4VGEwQm5yb1FxTUtlNkJxZlNQS0dtUWVBQ1dZblha?=
 =?utf-8?B?WkErM0czdmZvbnRsMU0yV0dPOWdMM25iV3ErSGkyK2o2L1pjU1ZpbmFBR3VB?=
 =?utf-8?B?TjZTeGtGbnBuK1h0Vll0U3c2Y2tERTVDdVVocy9BSlA3eTNiYlRpbXNkRk44?=
 =?utf-8?B?MXVkdnJ3Q2R4VG41M0tsb2ZNaTJ5R1Z0dEdpNGtiaWlZUzBQa0ZLUHBUcEpp?=
 =?utf-8?B?VXRDZXV1bjNiRm8zN0R1K0dzdlMxUkNGRzdPQUdJSTlzYnpmbkJRdDVWNWV1?=
 =?utf-8?B?Zi9nZmp3ZTN2U1dSdEZRMkZnSmFvZC9HNVRTUFRxa0dBa2lrb0ZFTkIyTmE4?=
 =?utf-8?B?bGtSR1UyeDBzMExRYWhhZElIQzk5dlgyMG1kb3cvTG85cy9YVUk1U25IUnpC?=
 =?utf-8?B?SzVCTnI5MnRZS2IzK2d2MjQ2czB1R2hZUWZldkhHa3pTT2Zya29UclNsODJk?=
 =?utf-8?B?WDFidDg4djBpS0lMU2w2SDF2R3h1QlZQSFdPbTE3NjJiaVNsbXYzMG40WTZr?=
 =?utf-8?B?Mlg1bHlTaDU4QWNSaDBnNVRXUG5NRjFJMlFnSmVFZFJ4V1VxRkY5dkxza3dO?=
 =?utf-8?B?RVV2NVRqcGRvVXFQR1J0MWRMKytGOFphTm85clNsKy9laG96b3hFUzZacGFm?=
 =?utf-8?B?OGlJUzRQcDFuZlU5STlMRkJMT3lBbVpRbEhuMjZmTldKWjR4UXhSOVMweHhG?=
 =?utf-8?B?b0pHNHpUTFZ2QW9zR1puSzNDUlFYcUp1eVFNMkx3Q2lQS2NILzlLdVZlbWFl?=
 =?utf-8?B?dHhldEoybVZpRVJVeTRhUVE4SGIzL3EzTkFYWHFrZmJWMWNzZ0puSWlXaEZL?=
 =?utf-8?Q?7NpikJ7XnxByNBiutO?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: geuKYwl5P7PiU/FNs06NbqCkybfQV4y5oq50itkq8vwRuXSQgBSRshDBLewO8sez9hjR7BgrpCkenYhzDV3m/6zK28ikIRhAm2j0bDyjz9wyFhL/yrmppy48NBrrSnJq5lw0fDJjGDHR1Sygqda37b5UupnT5oAm7LWp1mjxBnsawJiDrDT+wfFfK64k353fL8aWCRdaDCqYmjVbY2XioUu52Ps1s73A+yeZw4zFu4c3LoIm117bkt7qQe7wzueT1Z0PlQE/nQm7ut7WA45qrKDGNHqNde46szqoV1wdzJcY8f5nmS6uZFreCWufz2Tnt6ij7SZJVcb8Z734y2H0Nw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56070f15-3586-46bd-4218-08ded154ade2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2026 18:24:35.7878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TyRyT7Hv8+/BNQzpgHESSSXw6/9vbCi0OoxpGLzagqp4sZ7KRevoH8IpGk+SntdRzLaMN7BZtzog7g+cM9xcww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4924
X-OriginatorOrg: intel.com

PiA+IFNvbWUgZXhwZXJpbWVudGF0aW9uIGhhcyBzaG93biB0aGF0IHRoZSBhc3luY2hyb25vdXMg
cGFydCBlbnVtZXJhdGlvbg0KPiA+IGlzIGp1c3QgdGhlIGludGVsX3ZzZWMgZHJpdmVyIGtpY2tp
bmcgb2YgYXV4aWxsaWFyeSBkZXZpY2UgcHJvYmVzLg0KPiA+DQo+ID4gICogTG9va2luZyBqdXN0
IGF0IHRoZSBwbXRfdGVsZW1ldHJ5IC5pbml0KCkgcm91dGluZSwgdGhlIC5wcm9iZSgpDQo+ID4g
ICogY2FsbHMgZm9yIGVhY2ggZGV2aWNlIGFyZSBydW4gc2VxdWVudGlhbGx5IGFuZCBzeW5jaHJv
bm91c2x5LiBTbw0KPiA+ICAqIHdoZW4gLmluaXQoKSByZXR1cm5zIGFsbCBvZiB0aGUgQUVUIGVu
dW1lcmF0aW9uIGlzIGNvbXBsZXRlLg0KPg0KPiBJZiBJIHVuZGVyc3RhbmQgY29ycmVjdGx5IHRo
aXMgaXMgYmVjYXVzZSBwbXRfdGVsZW1ldHJ5IHJlbGllcyBvbg0KPiBkZXZpY2VfZHJpdmVyOjpw
cm9iZV90eXBlIGluaXRpYWxpemVkIHdpdGggdGhlIGRlZmF1bHQgKFBST0JFX0RFRkFVTFRfU1RS
QVRFR1kpDQo+IHRoYXQgY2FuIGJlIG92ZXJydWxlZCBieSBhIHVzZXIgc3BhY2Ugd2FudGluZyB0
byAiYm9vdCBmYXN0ZXIiLg0KPiBTaG91bGQgcG10X3RlbGVtZXRyeSdzIHByb2JlX3R5cGUgYmUg
c2V0IHRvIFBST0JFX0ZPUkNFX1NZTkNIUk9OT1VTIHRvIHN1cHBvcnQNCj4gdGhpcyBuZXcgcmVx
dWlyZW1lbnQgZnJvbSByZXNjdHJsPw0KDQpUaGFua3MgZm9yIHRoZSBwb2ludGVyLiBJIHdpbGwg
YWRkIFBST0JFX0ZPUkNFX1NZTkNIUk9OT1VTLg0KDQotVG9ueQ0K
