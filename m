Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6894D19A2AE
	for <patches@lists.linux.dev>; Thu, 27 Jun 2024 17:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719510753; cv=fail; b=fWxrt1pHIVqTaUlaDePTb5ZTSJEflNHCpAK1Bx5Air38SMsUP7QxnPImo5Ge950EDa/fTyohvqzMlJuNtemzG00gUC05ZiXSPEQNEy9Hvhyr9LuSmqZvX/yjzlI2kXCr3GINtR742Od169z6MxYV7C41sbsbcJ9tTEsrLbVWxtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719510753; c=relaxed/simple;
	bh=4VE84Qo4PtbbUMklXDexlXV3vtZZbWpbyrliqma4jMw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rroIfyAar+LpI0Y9FuXinXWVs/B2EZoLnJuessLlSIFMxfvOkNqGhEONajgoqbnPQuqGdM29Y1mmZnYF6BWNOakW03K0F3KgN4uK1j32lcugr9OucVweBnPdivL5KQdM62oVV1Eb/yFjU1O7VSs9RQIuWoEUfJ04nfCeZZ57SGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hswncKMK; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hswncKMK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719510751; x=1751046751;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4VE84Qo4PtbbUMklXDexlXV3vtZZbWpbyrliqma4jMw=;
  b=hswncKMKtOshrAD4Uds+hz5xCcTo0zdgHQRF9rzcgyXL8dc8z1RmNh92
   qk0E9TiL+jc3n7Fbii3NzDtyTrkOYGNslrvpCGoXn5BTh0ShEiZI4mYSl
   /aDvSyZWGzg1ec4Xicf0Lf6/W+1EuaowsJu89RyJLJVSl3euizRuMIIDx
   J5PbIK2sCFswFLxupWP3eRc4k0MJIS3AlCHC0foGi4UUjqYvMDt3QSlnp
   TIiBwSQkcni3ExaEU7JI0ovPEcUltv70kGfXSgCrdPt8pP9D+AJ09tEJr
   tWPkvf41lZ+sGTqw0E1/cQwjmbYL7MMTG1/i9JEFY6svn6T2CkZGfyeTr
   A==;
X-CSE-ConnectionGUID: 3u3YcPPcS2K1Vpt9vBg2Yg==
X-CSE-MsgGUID: sSe3i7YgSM2x2IZ4M+vWaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="27284608"
X-IronPort-AV: E=Sophos;i="6.09,166,1716274800"; 
   d="scan'208";a="27284608"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 10:52:30 -0700
X-CSE-ConnectionGUID: rlteKNfQTF+/UcZWG+spuA==
X-CSE-MsgGUID: mIrILlPsQ6WcwLQ+DNAJSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,166,1716274800"; 
   d="scan'208";a="49635958"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Jun 2024 10:52:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 27 Jun 2024 10:52:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 27 Jun 2024 10:52:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 27 Jun 2024 10:52:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 27 Jun 2024 10:52:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2O6aE/y5CSAjLZuZwI8LsSI2WR6ydPoa9Lv3sCRALayAfjkLaHNSRG+l3EJBb/pAmcoWKDVuK4oLScSIHIkbAJJEphmNO3UOBEUkvJLVhV8VzcjJQcglPw7JZBjIp+nWcghv2o7XZONECb6kMns/bmPnSOaOLp51T11VBTDjcu+/U/oFbW4lI7XcvKkNrjm+oGYOXz08+Rciw6+GG8h/00LSpfk9ZVUYNY8q8B8XqsW9pVVevXqZsH988QNVupTaMncgoxcT++2lBANbkZtD3D26b9my/kru39LQdudzSAHk7EiO4PxvZoXAed7N+H+q1M+Ktw6Gj0PW/QaINy5gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZYKsrV0sSts7peZPJ/mRcKy11wNAGW1fcIdi1VOn+w=;
 b=aovEXU5ZLf+OQXbuleWJrl4a/0PK3Jj2kk+b2lcioYGRmQBurFvpzTGa5xh+c9aqx5y9Dwn0xOnyGlIMFH5nDz6f5kfxHBwd5lsB0eDJ9tOMKEfzxKHbIxA/q8aXluKSoks5gku/QQNc4qp4DpaRHbOXhpBenB55Cz1Zi0k+EHPZCvcbqYU4lMi0gFffwUhhJYUjslRGfQYnLMsA7fPjN4TK6pxxH+SYMoy224RPz9OP4mjEY4EQV/kg+knqmXyU5yAc/Zek790k9QZ4g3mRrmqFAnogcfIOtA3w5Z6Oa+nBwF6PhpKrFoNrCGwTvNf68W46EEpMLSs9JPGDf2Qnug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB6943.namprd11.prod.outlook.com (2603:10b6:806:2bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Thu, 27 Jun
 2024 17:52:21 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.033; Thu, 27 Jun 2024
 17:52:21 +0000
Message-ID: <7f6080b8-daf7-4666-9a9b-8ebc8d7ac504@intel.com>
Date: Thu, 27 Jun 2024 10:52:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 14/18] x86/resctrl: Fill out rmid_read structure for
 smp_call*() to read a counter
To: "Luck, Tony" <tony.luck@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20240621223859.43471-1-tony.luck@intel.com>
 <20240621223859.43471-15-tony.luck@intel.com>
 <8df55906-23b1-4772-ab11-703da64d5ebb@intel.com>
 <ZnxtZc140S11gFKL@agluck-desk3.sc.intel.com>
 <d82a0882-1b92-476f-bc14-e8edb6ec43ca@intel.com>
 <SJ1PR11MB6083578781B19FC3111BEC32FCD72@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <SJ1PR11MB6083578781B19FC3111BEC32FCD72@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0117.namprd04.prod.outlook.com
 (2603:10b6:303:83::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB6943:EE_
X-MS-Office365-Filtering-Correlation-Id: e38a626c-a769-453d-14c9-08dc96d1e4d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cmRuMkljVmtvdGJYK01JVHpFY0VQcG1oNWpsZ1hodFhXMUlqWFl2cU81U2hq?=
 =?utf-8?B?eUtyTGdxakdsZzk3c0RsQTZUcXNLZXpIZE5tMHlic1hTU0Y2RXZLOTFzb2JC?=
 =?utf-8?B?YWhEYjNFdk9HTFJNR2xZNzl5bDM2WHlMVEhBbnVQSTkxeHNoNjlQRThDNzFp?=
 =?utf-8?B?ODFKZURKVm82VzRnUVZQR0NZb1VGdm0xcEtBMlNHbVlNeVBucXFJY3RPTFRN?=
 =?utf-8?B?bndSeGllZzdibGdPRmJDenA5dnpaQjBFY3phVjN0KzVQTzAyWXFpMTRtR2w4?=
 =?utf-8?B?MWhYZWs2Ym1vdmNlVGNYWHlqN21FWHFINnB3dU9RZjVVMW1sa2lkQ3hOS1E5?=
 =?utf-8?B?REx1Qjd1VHBzMDJtaFhRcDZaTTl4ZjZkcTBMYlFMdzRCb0ZLSm5LeDdGZEhP?=
 =?utf-8?B?M3NmaTcreDgyQmo3cjMwSkZmQ2VtZksyV0NMTW9EcEpRRjI1YXZjdVdmbkl1?=
 =?utf-8?B?cXhmMUtyMDdSWWpFZ1F1VTk2MXRqZzU0MzFnV2pWSmI1Q3p2bGswR1dtS2hM?=
 =?utf-8?B?NEo5L05ScWJKY29sR0xlUXc4bkRLSXQybUhxQ3plUHV0V1Uvd09HME1MQzVJ?=
 =?utf-8?B?ZCt0MURvOGZOYzU2L21RVFJzcHMxMVBaUUpJZlcvL2FhNFJZYUVlbE9CeTAz?=
 =?utf-8?B?OS8rRGFBUDQzWmlHUGxYZUxMazgrQjM0OGU4c2h2RHBUTDZhN3Q1YkcremNJ?=
 =?utf-8?B?ZGlmZ3VwNlY1NWY5eUZQL0N1Y0Ezb2xpZDNaSEdDaGFLVG1UREl5eXJsTk51?=
 =?utf-8?B?SW15NndVYThXNDJ4WldLcURyekZURVBqYkFscWpacHIrcWxqTERCMCtvME5p?=
 =?utf-8?B?eHM1aFIzTVdJd2IxWDBMK1VvY0NsWk14N0pwcEtuYmI5MGdUOGxhMWtHbEVl?=
 =?utf-8?B?bG80RkJsNnM4SHpLdWg3NXRYRndMOHlwcGNybkVRWWlkZWF6cWNrdSs5SFRF?=
 =?utf-8?B?N2QvL0lCMUlrQXAzVU1xNXJUQzdENmhtTVl3UTVJaWpHN2hBNWhkS1JZU2RO?=
 =?utf-8?B?ckZtT3A5aDBVQjZGSXBuTXdtbU1abnRhaWpLckMvQjZ4WFpkZ2FWQW1wZ0My?=
 =?utf-8?B?SVdwUW9ySzNlbUFFcmRHcVN5TVRDY2svRXRKWmJNWWtLL2lpQlVydXNDYWNL?=
 =?utf-8?B?NU9DK2pCSnhJeW13ZFVYOGFGbHF4cm1LVUpwN2Q1VmxiZkVGYmFTcmR4czBZ?=
 =?utf-8?B?RkRHdTFkT25EWDFsRFAyb1g4SmEvMTZTdkVDZmtob3lxZ3BWUmN5aUQ4ckg2?=
 =?utf-8?B?REFyTUE1TWRaOHowOWZpTWlxT1UzTEsydXpHQ3ZVUUNDVkJpU0NzblhOR3JR?=
 =?utf-8?B?NnZ0STBQLzkrMUVCbUZURzB0Q0lNd1JkalJhYWhsTDBXb1VaRGxYYXlkdU5h?=
 =?utf-8?B?elFZd3ZZUER2d0Vtam9kMVdCMXRhVTJWSlNwVlB4Mit5OWZYRzZWRzl2N1J6?=
 =?utf-8?B?T2g5b00zeHNJVUxQU0hkRXlWODJqM1BJVkl0clBqZGZYVDBYK1FtRm9IZmVy?=
 =?utf-8?B?S1plUFFoVFduaHBEQ1p4eHFmYTZqTjdZZ2xoYmMwSmpQTll2ZFROSVdMclBR?=
 =?utf-8?B?R1EvK1hDNGprb3RVT1RpanZHT2V4QmRPM0ZLcTVjblpsbE9SUlFucXRRRTIv?=
 =?utf-8?B?dGpvYzI4YjZYTXQrNFRyWFpZemRJcWVUUFlSZ2czTmxpcTBRZS84eUtCMzZY?=
 =?utf-8?B?MEhTR3o5YzA3MVJxbU5wcXpQQjB3UXBhRkV1bHpsNkVMbTNQNzdoNjM1RVdm?=
 =?utf-8?B?RmlvRm11eG1tSzlTZTB2RUFyNWM0Q0xZYnpHTG1WTFowdXRJV282QTNJLzVr?=
 =?utf-8?B?alRYSDlvbGE1STdGN2dXZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODN3bWlaZnpYa2dUR2l0N2tPWXdoMExVTXpKdGZPbTRxNnhDSjBEOFFqZy9K?=
 =?utf-8?B?aEtQVlprN1pqbHgvS0Q1TDBsQjdMSG1nUFZKeU9nQkV2bDFhZmE4ZlBDa1Rz?=
 =?utf-8?B?TGh1NCs3ai93SHJyeWZjdThPNGJVeElXTFNaM1NYN1BuTWliQ0ljdE5tM2JC?=
 =?utf-8?B?bTRoakR3eWJ3WHVvN2J3TE1IT1orREdRUEZLN3NNNjhuVE9aaHowMGJnS3RH?=
 =?utf-8?B?a1pSVmhhQWR1dE94ZG5BTDdRV2lqKytPZGUzdVVxQkxKcFZKNzZma2JvczlP?=
 =?utf-8?B?Wkt5SWJKenRFNm0zSzkySzB6bTM3OG5ONXRKTU1rMzhaVXVsbTFnZml1Z0NN?=
 =?utf-8?B?czJMcVZEUUl6emVwZ0pQUGIwZG1RSm5QaUt2RmlHZHk5SFByTzN4RStjTFh5?=
 =?utf-8?B?d0tXUUJzTUtqdUplZE9WUFhVY2V3U1ArQnQwYXMvTUdwN1FYRjFOSlkzNzdI?=
 =?utf-8?B?cFFxQ3RtVzBVRG1DZ3JOUll0OXJ3ZnVpODJ6a2E5c2MxYlFEMTZCaEErKzNQ?=
 =?utf-8?B?QjE0eUVCNGVoaHZRSFJRbm01MTkrMi9KUGVjNjFHelcvS05BZitUc1ZvSmU2?=
 =?utf-8?B?ZGlyenhMZEJmZjRXbzlyZGF3YmlBRHZiNG9aM0pDcGlob0tDYS9kYWpvQXlM?=
 =?utf-8?B?RVFaZTlONXRwcTk2djQ3dlBSUnZYQ2FVNCtBNjVGd3FKUEtYV01tVko4d3Rv?=
 =?utf-8?B?ODhETVcyUzRSK3VxeGs2clVqY29PbEpZT29KdmxFbmxRUjhEOTMxSmhjMFRX?=
 =?utf-8?B?UDJKc2syZGpWem5Uc2p4c3hRWVRkcndhUnA3ZFJ4NHh4NDFaVGtuejVzdHN4?=
 =?utf-8?B?RGFJdG01N3hkT1FpUGxRbjloQ051aDZhdmRBZ2ZVT29ycDdBMitCM2tkN01o?=
 =?utf-8?B?WEk0eTRXdlhEVWtqdXByQnhnd0ZDYWJaUHBXaFlTLzVhSENaWWVsVTgwUDBE?=
 =?utf-8?B?L3AxNmlqYmtuWExySkFSbEZES2dGclZEZ2dyUXNRcDg2Qy9NblhkZW1HTHpS?=
 =?utf-8?B?bS9mNFhFZVZKdlVmeWZPa2lVWlV5Z2RlSzRHVms0STl0VkxKRkRnOSt1TnVm?=
 =?utf-8?B?WUQ0R2tKM2VVYnU1SHlIQmVucWwxMmc0UUlhTDluaFo4d3Y5ZWNscWczRVZv?=
 =?utf-8?B?MmdRV25kZWI0YUxXRmpJZ3NsempyS24rSTZrWldwMXo2bUFvSCtSR3JWVG1V?=
 =?utf-8?B?NXgrMEpJWTl5NStFRktYSk4ybEdmQVdBcWhPL0ovb1NnWlZaZmlvTDBhYnZr?=
 =?utf-8?B?cWRFZDNTSzR1d3M5TkNIS1EzL2pOQVpza3JWTjZ2alh3bnRNWTZYMVBZYXBn?=
 =?utf-8?B?MVo5SDRiV0l3L3FQNXd6K2EwWEJKempyWTlvUWZuTDNobWtVaGN0eG13ajFH?=
 =?utf-8?B?d0FuOE1Qc3FTZ1laUGQ3aE1WMUVHdWlMQVFwMHhHbjBMTFdCWEhXZHRqdjNG?=
 =?utf-8?B?SzlqWlRZNWJ1RW9BbjZ6R09zTEg0UFhhdG5uMGUyZVFseDJqVkFoVVZGcFZG?=
 =?utf-8?B?UHpHaXpaSmpkeXRPT3BFUnpNZE9Ud0YvZTdyM2dCcjZMemVTNzQ0R2MwWHpW?=
 =?utf-8?B?RXRHSzZHMnQ1Z2pxVUdIdUhPNXlsMUdDRTF4YnRhUEdjNVc1UnJLN1Y0VmZU?=
 =?utf-8?B?MXBzMmZlN1VvS1dIK3dyRUcwd0UxR0E0dzVrakpXYTc5b2FTc2tpWUZ1ZGpD?=
 =?utf-8?B?UjY0YU03THYwRkw1WHVyUFNKTkc1b3FMSHpoRHpHVDB0MWRPMytiNnBHRVVL?=
 =?utf-8?B?Ym9sdHU2MVd2STU3UkRodjhPc1dQcmRUTTB3Rjh3dDE2REExWVVrcXZhL213?=
 =?utf-8?B?aGVTelhjdEVuNjZxNDNYYUQ2KzZ5Q2ozS0UwVlRKS05MR1FPM1hGMTUyVWlr?=
 =?utf-8?B?TTRSQW9saEFPc081S1NTeDNlczNHZmluY3FCWUtkY2JtcncvU0txbDBHblYv?=
 =?utf-8?B?ZkxQY2l5WmFVUFA3V2FsT1hXK2ZPVzFaVmc5L1ArSXdHbU0rYyt3b0lCQXo2?=
 =?utf-8?B?QUpJR1cvRkh2a1dDdUR5d2RmVUZOREFKYWJrZ2M2OEROWG8wSzYxVlZXcDBL?=
 =?utf-8?B?dUZrRzhjNjBzeGJHeExJNFZkMml0R0hINEJjTHppbEhWVXMrZTlZZitRWmd0?=
 =?utf-8?B?ci9vZjNES0V1M3dWZFBOeDB6aVZZWGdsTDA1TUNCWFR2UEd2SXhwOTA1dHJr?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e38a626c-a769-453d-14c9-08dc96d1e4d6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 17:52:21.2810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4T7+EwjNCnpdw7qq2/9aNIYc86hbQlqdVy1Jtac/R4C820ag2pFweLA1GX7jLF7AgZn74dRfKJw1g5XEx74yu66S45xbAWcGoznltZoFoo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6943
X-OriginatorOrg: intel.com

Hi Tony,

On 6/27/24 10:31 AM, Luck, Tony wrote:
>>> Or do they serve as useful hints to human readers of the code?
>>
>> You are of course welcome to keep those you find useful to readers of the
>> code. My goals with this suggestion was to (a) stop passing garbage in
>> struct rmid_read fields, (b) use struct rmid_read consistently.
> 
> Reinette,
> 
> I dug through the code and found only two existing redundant assignments:
> 
> 	rr->val = 0; (in mon_event_read())
> and:
> 	rr.first = false; (in mbm_update())
> 
> plus a third added by my patch 14:
> 	rr.ci = NULL; (in mbm_update())
> 
> None of them seem particularly helpful hints, so I'm dropping
> all three in the next rev. of the series.

Sounds good.

I think there is one more redundant assignment in mbm_update():
	if (is_mbm_total_enabled()) {
		...
		rr.val = 0;
		...
	}

... but I think it may be subtle enough to keep to be consistent with
the rr.val = 0 in the following if() block that _is_ needed.

Reinette
