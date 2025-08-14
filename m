Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849CF27AC5A
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755208722; cv=fail; b=ArqaEXD8he25p3FDibcWCPPHqrRktINs6F0CWO7rjzn2/PyyJP6/XnrwtMPz/f2N/oqu984BatN8PhHUolmcaO5EXaCXFylj4Dkb3sezleAGvhE9MdvO5Ugl/9ZiDJnZWuUBYoFQyGmbyAh08FDrkR8i3++GbU7VQC9EJzXf4EA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755208722; c=relaxed/simple;
	bh=nbB7Mk2G5Zic+PEbT36UVWV2Ko7564adGXdebVVmXbo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MazWoU+mLikFhecsHuN0sk5RvVdgoj+rcSGwN0n5frYMLBXlPuTXIYvgt23IR3H+tEKgIYp76DT2+gI2XI5Lpq+UUo+KUfp+unavCxRWrPLNgH4/4lHFccRwFN9QdI3AQJRpHHciB8MD0OybU+expwu5LlVCFqQ6xHpN0gxkGcs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KmTH1Q8W; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KmTH1Q8W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755208721; x=1786744721;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nbB7Mk2G5Zic+PEbT36UVWV2Ko7564adGXdebVVmXbo=;
  b=KmTH1Q8WPFcAOZmM/okF31v3SdJ/noXirTnZMDiIZJ82fEAVyNXcQ6GX
   VZBiNk993S4eJNOM6uikLTY8pSRz7eMxSKR4j4cgcW39jDAe0QtvT1rkG
   UrnS3p+jqL96K5FuZGYgYypTLsJgampuU9NhIhEAcN4JvhwT3RwEBzRRf
   RnaUByaDSEKRyz9hO50T2JzyGy5UmffiTi29QU1KsEST6C7Dc4C8HUvDQ
   tXhG8n5FJkhiSo/q6abPD+xjlMVNaz8aNhDFSpTEmGMCwHtU3rk9qCLro
   HOyDObmV1eGLCCQHYdNrra4hkQgKpHZV/lPo+SUavEsepIZw8UjazTBZH
   w==;
X-CSE-ConnectionGUID: H11bnhhNT1OI+tbseeK8eA==
X-CSE-MsgGUID: 5/IYVWgVRvCZgUl7Bqsk0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="67807630"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="67807630"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:58:40 -0700
X-CSE-ConnectionGUID: vYCLS5tkRDuVpuZ+RJzmjg==
X-CSE-MsgGUID: /cxeZ/0zQCygtQq2R17kgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="167673355"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:58:40 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:58:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:58:39 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.53) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:58:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QctO5e0DCEovr4t71NLUNr0msxZuZDb40s9Fbo+5fUycQL9AeBlP3LTkYeDKeMVm9octoLJDgGncYZH4r/CjgW3EgKd5oC9aMolnt70qtBH7eLz6VDOSoe0WITQylUfz4+eG5P/dnL+4DDp4S0lmiOqxwbxdqukPRHpBT/exxAeYzquIl8VTjeXmRNHAzKEsFdvxce7oPZmqsLyWihSDgeaE3Dq7cztw/JrfTy+5+Z8DaknSyi80sxPioCqS6j9xzv3+7DxJsEsn6dBJx4n31os1DMz9XfOoiDKTq3AVB3e57JEsSTtxO+s5TYqLDZZPDKEa6i8ZDtUMdkQ5lMIBrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CgZiJWqEJu6z/7W52oaWqky59LqYcmbE+6lHSqGrqSs=;
 b=szvwzNlKYQpPpaXI4HrwUQ2u97vsCNslz8nwQuR07/TOMy8m/k8pwrDoPvLAcEtvcHnO5kr7egQYOowEwqiOMvn1QNVAACCJ7UwNuBAT6uZAUF0DsMpxqqxkG5PZpVxdEzAHdIoNwgxer20bCi+FuFLMe1VaMqKfeDuL6arCa2eGWIap9+7xgel00LQNx0bdF3ZiQqrLakZfBxkYQVInooo/yvJYJueMr7kLjF/O7cwPzruohAda30eZsQqTSSb0XOqM/uhc4eHR0+xuuISLCIjOZ26YnUgdVoFeNKTqzUVU4u79/1UDbSnBVlTE4PDWd3PsyqqeRx+Gm9/SN2fPtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPF2F7FC4EE6.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::81d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Thu, 14 Aug
 2025 21:58:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:58:37 +0000
Message-ID: <94c855b4-1a30-48e7-a4a4-26a57bf4a5c5@intel.com>
Date: Thu, 14 Aug 2025 14:58:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 28/32] fs/resctrl: Move RMID initialization to first
 mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-29-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250811181709.6241-29-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0057.namprd16.prod.outlook.com
 (2603:10b6:907:1::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPF2F7FC4EE6:EE_
X-MS-Office365-Filtering-Correlation-Id: 648e1f29-29ee-49ef-c491-08dddb7db871
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aFpmZkpuTVFQb3BMb0IyN1RlZWg4Ni81cHdPcWZyeFdPR041MXh4dkNEWjdh?=
 =?utf-8?B?ZzBrK1RBRkhwVDlHeGhpbFA0OFFxcTJOUkpTNlVOZ1FWa0t1ZHorNmVJSndL?=
 =?utf-8?B?L1RxMzVid2h5VWdqRW9Hb2NWcDhOTXhWZ1N6YzBKUzA3N0RWdmVON3V4d25r?=
 =?utf-8?B?L2wveDVlTVltYURnTWpVampYWlEyTDFZNEFyaDlzSm1nNGs4WHpRUUZkekxz?=
 =?utf-8?B?aG1sbmVkZ1BkeUdNUnVER0VnVXp5b3RWWHZUOVJxRmFtOWR1RlE1a0s4RUtk?=
 =?utf-8?B?NmNZZ1hhdVE5Z29KczZtc2xNS0FhWmxqdWgvOGpqYk9pQVY5UHV2Z3loaEI3?=
 =?utf-8?B?dHJyc2h1aC9XMkpVcFhOOTJtSUtJS0xjZ1EwUDFHcThIUm5ESVl4YzYyT1FM?=
 =?utf-8?B?d3owd3lEbE1lQWhsa0dXK2xuMHovRTNqUGJMVnVRTS82OERpZ0NhOVd4dHdQ?=
 =?utf-8?B?SnR1Y3YydEpiaGcxQ1A2cW5JUElMd3VqMFNBZ2hQQ3lYNXJxRmIwUFFsa0VG?=
 =?utf-8?B?Tjl3aDBZdFZvRExTZCsxNFhQR0ZGQjBuUDNUWmw3UG8rTVFoeVlvMUwwN3Fm?=
 =?utf-8?B?WjZwSnRDUXJiSTdKc29CREhJSStFR2ZJVEE5MzUydW8zZ3JvcXBPd3lYMnpE?=
 =?utf-8?B?ZzB2NFNPS0svdEpDck9CR3NIOVNhOVdTZEZBMGtUK1VtMnZaS2VjU2YwWEZS?=
 =?utf-8?B?Y0I1NE1BeHBMVWxWVHNtNFhYd0lRZmNUdWQzdGlSTkVCd0JmNElwSnp6VmYr?=
 =?utf-8?B?R0hMdHFRU1h5WVdSZmQ1VUhJdU1qc1V0UTZZNzRleGhwa2VTalhySmJTQTdG?=
 =?utf-8?B?UFhJODZWcUM0T05XVjJXazgzSXQydmNnVE50VDJlVjh5OVVEbW5qclVKb01q?=
 =?utf-8?B?cnkyWlpxTm43VmxpVUdOQnI3UWVJL1dueUVuOTBDaXRxZXlDUXkxOHpqeFFD?=
 =?utf-8?B?Q0JGOEd0MjBLMVV4T0R6TjZsVnlrMnJaTldZYjdjZlY5ai8xNTI3ZEpmM054?=
 =?utf-8?B?Y2NIdk5YZ2VoeXJ3Rzk2YkhiN3hTVGtOT0tnR2RnN0dZYWRXT05RVnJZcGpT?=
 =?utf-8?B?SFUyaE9WNm1aNzB4ak9iczlqNFN2SXdQaE5pV1VGZWFhRkJmaDFOV05HeG1z?=
 =?utf-8?B?TnJOdUg0ekdURDJRNVpBRGY0cHJZTDB4b1BPcVplRnR6aEJlTTV6UHR1TEZL?=
 =?utf-8?B?UDdrVWZLcldvVDZaWDlKR0piZmJvL3JIUmJYZHNRcWN4VlJFVnlHV0UxSjJn?=
 =?utf-8?B?T1ZxT1gvVDh0YWVqME9hN0Y5aGZGMHc2ZEc2aTE1WFNydGMybEVqelhNS2xG?=
 =?utf-8?B?VHpEOXUwWVVxdDFlazAzenplckp2Y2VvdjkrQlFwRzFhZmZsTHRWcS84SS9F?=
 =?utf-8?B?RnJ5QTFaSnJCM1B1L21Tc0tVNDJkdjJlUkJROTRNYUk2dkZXTWloNEU0K3F4?=
 =?utf-8?B?OXZSQUdadmR6a0RiMnhUYUhMT0Y5dytkNkJQNWcvaVhPVVdkYXdydXVLME5z?=
 =?utf-8?B?akw2SHBxQ2pBQnNQVFM1a0ttOWowWElrRzQ4cXVYRGNhRnI3eGJsZURaZDJP?=
 =?utf-8?B?cDQyN1dodVMyb1VrdnZvd0t5WkRjZU5sRjZ6dllkMlRnUTc1UjF5VkNCQUFN?=
 =?utf-8?B?aG52ZlMycjBCOTcyOEJRUTh0WDBENmxwS1RHWDFqL0NLTm5XTmk0bnVVLzZO?=
 =?utf-8?B?MGs3NDJDTm9xaUNSYWRmdklHQ3pMNktXckJHRFNxNjc0V1JkNEovNmhEL1pU?=
 =?utf-8?B?S25YY3JwYWlqRGczRVhveHhTbEV4SXB5dTZ4aE9LZE83OVAxT3huTmpodS9o?=
 =?utf-8?B?c1A4VDQ4M09ab1Z6aGlUUkZPUjVTSVgxY2pnQWlMSDB6MEhlUGJ2Y09UR3o3?=
 =?utf-8?B?anFKVDY5RHc2ZGJxRy9PZ25JbHJXZ1ZtamtOMUZ4eHBZclE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zy91d201WlZvWFBFdmw4eVA5amlQSVVwMXJGM2svaXlMT3B6MCtqdFVDUFlo?=
 =?utf-8?B?aFhHdVlJY0U0d1ZIMXNKMWZBdWNQUVpXdVFQUVdjSzcxUmp5MDJSRDQxSTBH?=
 =?utf-8?B?YjNIbWZmZ29iM0VQNHZLTk5ndWQ0RWUrZklNOUhROGs4bE5mSlhxd2l3WjNo?=
 =?utf-8?B?eUh3N0VsOEIwT1B5Tm83UEJOeHVGL3JFRjF0QjFMY0lWOUltczJGSTRidWFZ?=
 =?utf-8?B?bEZSZUVvTUxIUTJHOUovY2RiaSt4Q01aemM3TGRwcnRleTdMUTVDZWhWWmlx?=
 =?utf-8?B?emNOMFdWRVhsOEs2Sy9RVE4zTXU4NlpYSytRWjMydWIrQ0tYb2R3aVAvZDdj?=
 =?utf-8?B?YVlwcTB2Q1BiOXU1aTVINnMvYmdlVDAzWEExWG1iQnl2Z1hCWEgxT0VRckVS?=
 =?utf-8?B?ZEZpSVhrb1NPMUgvcUZxRzg2SXF6U0ZzeXhrQWd1QnEwajVFbXVVYTNvajlC?=
 =?utf-8?B?VUFUYTJlbHkxckhpT25mNjF5SGd0OEZHOS9nUGFEa1NVa3I4RFFQRzA2S1o4?=
 =?utf-8?B?U3NUbjN2Y2NZeXgwV2hwTmMzVXRuOVRNZ0FQUmF0cXhsMUozS0llWjRnZGw2?=
 =?utf-8?B?QldrNDVRRDZPVjVBT0hKWll4ODVQSjQ1akZxOTR1aTJPeWhTOHh1YnhTT2Mx?=
 =?utf-8?B?Skc5NEp6bkhoTHhpck1pQ0xrSlVhZEJZLzdoRlp1NmtwOFFtbkNOWFRXN2or?=
 =?utf-8?B?Umpvb0hFWk1TNjMxaXRJZXc1OGxlM29tZ0tLR3JxVTRrREcxOGZ2cVNNYUEv?=
 =?utf-8?B?Wmt4YkVUcUpBd2xWUC9XQmtPeUVWaGhjaEkyK2czYUY5YnpGcTA3dEd2aE1i?=
 =?utf-8?B?aXp5TEtMN0gvZlk0RkRlN3hXTHNjdUFNUjlaVy9ZRWhiaHVKWmhVU1NldjZh?=
 =?utf-8?B?YTk3UGVaS1JMN2dJMzZZMFZnaVNoeHY3UURhSjhySDVGUmtpZXNGMzJGb3hi?=
 =?utf-8?B?dE5ZT1dKRk92dzY4am9ZdGZvKzhjRzlHV2ZpMGJYVEpUWGJHaHZNRHllZ3dP?=
 =?utf-8?B?bW5LSmsraitXTXpBTDZLL09PZnV5Rjh4QTNsSm5rZ1grU1FqRVhheGpjajkx?=
 =?utf-8?B?TEhwNXFiSFhlU3B4Qk1wdzJaeFJSL2YwMlh4ZGQyMnZtZEVkUVIyS1dVSVdq?=
 =?utf-8?B?ZTQ4bXE0amx1Zk02UFVGR2RRQ2JnbWIveU5ub1lpY0s4TVBjQ2hFR0xMNk5s?=
 =?utf-8?B?U2Jwb3M4VWZXc0Z0cnl4MDExQjhzMUlRMmVYRHVtVm1DbXdaakU3dWR5THcw?=
 =?utf-8?B?MmNFK3Z2OVc4TU1ZT3p4cGJkZlNIakxzSGc2V2ZKNUtFRWNpS0hKQTgwY3c3?=
 =?utf-8?B?dE9MS3NGZjZBTE05OW9pandVenRiNlladldYRm90R3pRMktVSFZjdmpXREVr?=
 =?utf-8?B?T3htNTgxdXRoSnkxOVQ4QnA4UC9jNmsrRXEwdzROUVZpYTZSWHM5K2lPamxZ?=
 =?utf-8?B?ZUtkOEtuc0xya25WcStqYTI5cGxJejE5dUE3TmhrY0IxNUE5bEIwcWxvS1BU?=
 =?utf-8?B?VElrUzVUWUp1RCsxREpzYUo0NUoxVDBlTm5hVTByUlUzNUJTN1Y5blBqQ3Nw?=
 =?utf-8?B?ZFhXeENCRDAwZ1cxSm1aMHFKQ3p0Y2tsZkhUWVhzcHNFaWtUNTk5dTdYVWE5?=
 =?utf-8?B?UFcrcEtDVW9zMUZWU0lhb0I5NDlDRkc3UnFXYnpGUnNiZForSDIxUHBEbHdQ?=
 =?utf-8?B?WWJxdStERGIzRDU5UTJTajBDMkcwSml0Mi8rdEIvaDVtMVBlTzNRei9tMFlQ?=
 =?utf-8?B?OU80eStOS3RZaWwydWtBbnRmOWpqcG5hdmoxcU5SSG4vTng3cDJ2b1ZXUkl0?=
 =?utf-8?B?N05YbzhET3JoTnA3QmZnNld1VVhjSTVFbFlxRERkb09LQXppZGFWNUZ0a3pP?=
 =?utf-8?B?LzBWSXI1akR3QmFGQjhlOXRDTkkzd3BCYnpNcVJqcUhrRkJjT2ZpcWF4dEU1?=
 =?utf-8?B?MzZEdEZtZzhMQVlRZ1hqNzhaVkJDNVB5dGs4ZW1nL00wZGUvMzNSZE9uUXhC?=
 =?utf-8?B?UG5yOE8veW5ZYzF6SlZ4eS9uYitRdGJXYld6dUtwc2pWU1padEo4SmFIc3RP?=
 =?utf-8?B?Q2NMcGRlSlFYRy9YaTVXSHQwOC9uS3FoYnNsditkOWhJL09GenFjbFpkUTN3?=
 =?utf-8?B?UEpHRURUTUJTbGxPTmI3endmSDRrd3R2TFNOSytVSlREdXVPbkVzK1liemp5?=
 =?utf-8?B?TGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 648e1f29-29ee-49ef-c491-08dddb7db871
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:58:36.9374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 54pkrlMWeZGbd6eXZ9QtYAnJPnl26JT1s1X/2mP0HP+uB9p3XN2XV8kyrMl6quqvNJrS8nKk7s30XF5YwYzwYAxOkDFrMM3uyvvL2NxKTew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF2F7FC4EE6
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:17 AM, Tony Luck wrote:
> resctrl assumesthat the number of supported RMIDs is enumerated during

"assumesthat" -> "assumes that"

> early initialization.

The context can be made a more specific though. For example, 
	L3 monitor features are enumerated during resctrl initialization
	and rmid_ptrs[] that tracks all RMIDs and depends on the
	number of supported RMIDs is allocated during this time.

	Telemetry monitor features are enumerated during resctrl mount and may
	support a different number of RMIDs compared to L3 monitor features.

> 
> Telemetry monitor events break that assumption because they are not
> enumerated in early initialization and may support a different number
> of RMIDs compared to L3 monitor features.
> 
> Delay allocation and initialization of rmid_ptrs[] until first mount.
> 
> Rename routines to match what they now do:
> dom_data_init() -> setup_rmid_lru_list()
> dom_data_exit() -> free_rmid_lru_list()
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 0d9c8d4e0e9c..4c13b55db995 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -802,20 +802,19 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
>  		schedule_delayed_work_on(cpu, &dom->mbm_over, delay);
>  }
>  
> -static int dom_data_init(struct rdt_resource *r)
> +int setup_rmid_lru_list(void)
>  {
>  	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
>  	struct rmid_entry *entry = NULL;
> -	int err = 0, i;
>  	u32 idx;
> +	int i;
>  
> -	mutex_lock(&rdtgroup_mutex);
> +	if (rmid_ptrs)
> +		return 0;
>  
>  	rmid_ptrs = kcalloc(idx_limit, sizeof(struct rmid_entry), GFP_KERNEL);
> -	if (!rmid_ptrs) {
> -		err = -ENOMEM;
> -		goto out_unlock;
> -	}
> +	if (!rmid_ptrs)
> +		return -ENOMEM;
>  
>  	for (i = 0; i < idx_limit; i++) {
>  		entry = &rmid_ptrs[i];
> @@ -828,31 +827,20 @@ static int dom_data_init(struct rdt_resource *r)
>  	/*
>  	 * RESCTRL_RESERVED_CLOSID and RESCTRL_RESERVED_RMID are special and
>  	 * are always allocated. These are used for the rdtgroup_default
> -	 * control group, which will be setup later in resctrl_init().
> +	 * control group, which was setup earlier in rdtgroup_setup_default().
>  	 */
>  	idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
>  					   RESCTRL_RESERVED_RMID);
>  	entry = __rmid_entry(idx);
>  	list_del(&entry->list);
>  
> -out_unlock:
> -	mutex_unlock(&rdtgroup_mutex);
> -
> -	return err;
> +	return 0;
>  }
>  

Removing the mutex lock/unlock from setup_rmid_lru_list() is correct since
setup_rmid_lru_list() is called with mutex held.
free_rmid_lru_list() is not called with mutex held so it is not clear why
it is ok to remove mutex lock/unlock below?

> -static void dom_data_exit(struct rdt_resource *r)
> +void free_rmid_lru_list(void)
>  {
> -	mutex_lock(&rdtgroup_mutex);
> -
> -	if (!r->mon_capable)
> -		goto out_unlock;
> -
>  	kfree(rmid_ptrs);
>  	rmid_ptrs = NULL;
> -
> -out_unlock:
> -	mutex_unlock(&rdtgroup_mutex);
>  }
>  
>  #define MON_EVENT(_eventid, _name, _res, _fp)	\
> @@ -914,7 +902,8 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
>   * resctrl_mon_l3_resource_init() - Initialise global monitoring structures.
>   *
>   * Allocate and initialise global monitor resources that do not belong to a
> - * specific domain. i.e. the rmid_ptrs[] used for the limbo and free lists.
> + * specific domain. i.e. the closid_num_dirty_rmid[] used to find the CLOSID
> + * with the cleanest set of RMIDs.
>   * Called once during boot after the struct rdt_resource's have been configured
>   * but before the filesystem is mounted.
>   * Resctrl's cpuhp callbacks may be called before this point to bring a domain
> @@ -925,7 +914,6 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
>  int resctrl_mon_l3_resource_init(void)
>  {
>  	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> -	int ret;
>  
>  	if (!r->mon_capable)
>  		return 0;
> @@ -947,15 +935,6 @@ int resctrl_mon_l3_resource_init(void)
>  		closid_num_dirty_rmid = tmp;
>  	}
>  
> -	ret = dom_data_init(r);
> -	if (ret) {
> -		if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
> -			kfree(closid_num_dirty_rmid);
> -			closid_num_dirty_rmid = NULL;
> -		}
> -		return ret;
> -	}
> -
>  	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
>  		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
>  		resctrl_file_fflags_init("mbm_total_bytes_config",
> @@ -977,12 +956,8 @@ int resctrl_mon_l3_resource_init(void)
>  
>  void resctrl_mon_l3_resource_exit(void)
>  {
> -	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> -
>  	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
>  		kfree(closid_num_dirty_rmid);
>  		closid_num_dirty_rmid = NULL;
>  	}
> -
> -	dom_data_exit(r);
>  }
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 5352480eb55c..d1ecc5cd3089 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2599,6 +2599,12 @@ static int rdt_get_tree(struct fs_context *fc)
>  		goto out;
>  	}
>  
> +	if (resctrl_arch_mon_capable()) {
> +		ret = setup_rmid_lru_list();
> +		if (ret)
> +			goto out;
> +	}
> +
>  	ret = rdtgroup_setup_root(ctx);
>  	if (ret)
>  		goto out;

Shouldn't this be cleaned up on failure? I expected to see free_rmid_lru_list()
in rdt_get_tree()'s failure paths.

> @@ -4408,4 +4414,5 @@ void resctrl_exit(void)
>  	 */
>  
>  	resctrl_mon_l3_resource_exit();
> +	free_rmid_lru_list();
>  }

Reinette
