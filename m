Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C9C7082D
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 04:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749009939; cv=fail; b=kMe4IVVvSha3AHj7A7Kd8fQFK8+lNMKrEqPKCjcTVsMfMOgAB0xvfbPNSG+n6OisYy1Sspt3RUhZhO4MDpc3m/0Dd48LUafC3qFVGJxQnRtdn7mAY9qiEcEbSDA1VTBrunT53lHWY2gySJ52ZDIjYmtR6rk5nckafPy0k3Ap5bM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749009939; c=relaxed/simple;
	bh=YOF/xMJ70oq4AOXqVh/CCl4DFjNnz1U+IELZTikX0r8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YYwBsdNdYxo4ThmhcYzzOWfo8AO1/KANYRWJQ5yKqjtJNPE8RCZGj/cuz6VuQRWiNZqEt8CtBkVL48L5OHpH5mWU0k9ukX/yLLxAhEy5oZCV+CQzHs0eA9wyOO5rACSb0tlT3Bzn5H85wWUNCjQK5xzUqBwfqZmF/bV3u/26Pu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X9soyqOX; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X9soyqOX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749009938; x=1780545938;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YOF/xMJ70oq4AOXqVh/CCl4DFjNnz1U+IELZTikX0r8=;
  b=X9soyqOXpsD2R4LWoBmEQEv88remc16WihgBU0j7cG7VapnySrDu4Fmh
   sLopoaEXwzXf7DbRGTVc/oxioTI+eolGHwz4RFberAkxZQZx4or6BUBam
   8TmXkNngUr8KhXu1+g4CIHDxHg1iaMRJeLQ5ZhBLsmW+kbYFOMG6MkUFC
   5oHqZOzDgb6nsikS/Y1CPhlEvo7HYk8ONyjHxQjNKAz0tarHVBr01Fn+1
   Mba0uaPSKZWQ0Lnc+jvOKuOw0ALdt6OXlzNu+AxyAQEZpXDIWw4XhzJU6
   DMENlVrxt6xpkjTrFYLLBtNnnTDQXa6y+mGpqR+2I4mWXyKz59LbotyhF
   A==;
X-CSE-ConnectionGUID: cx0d0fEjRIKzF0zaUyqXKQ==
X-CSE-MsgGUID: 5cEZ+XUhShuXCxjJJXtNyg==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="73604869"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="73604869"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 21:05:37 -0700
X-CSE-ConnectionGUID: YId733V9QBqLJoasg80E1g==
X-CSE-MsgGUID: y/+5jR5PSDyP2l1HpCiFpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="146038139"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 21:05:38 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 21:05:36 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 21:05:36 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.61) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 21:05:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q/3y1G2JRd8ZRt7HLRdBcqyt4gUyLDYDY5Pp73Fuqo6WRutRxI+MkFK77L5Nnvw+4rNX59ZeDrJ59KMeOCoRlDUt6rEIiXoJsm++3Gmxr/lS52mpJimxpMr/dpE0N7z4WvfAgcAEogfcyWUEbkHoGKd9TFhizFbGGC+ln+1LwYvttDCqvtmXqkUUYRHycRG12E0uTKf++smRwW4HNIi3rBCBug2Qr9pM5BihkxPAmTFeiZMJKWigq+oBMRDNVCboRsTP1gxprkgwa+hJ4kdymCa34DgE2cPeSU4h9rS13yF7hBb2JYVLCwQmTfv1rFaLfrl5WkRYJM1SOo/sW76X4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nMidXde9r/qolqqG+WbbLSdumnuFM8qz99fTf3h4DnQ=;
 b=A60HFT/g8m6uAu0yY09gVxRf26CzEYDJFfLl6VJsRHE8kM1iBIVlYgicMaZh48QkI2FhzcDbRc+dxwspIB+GCEQanQUCUD8HawQQT8vAjBRRriuYa1zDloJ6+hoKV9vKxCSWCEMCAAV6tIPyZ0dQmo0tlanVLSm5n+JdS2Qqm/cfN5MX3PAhOKiLf/Wqs5X/rYQ9qFrECuoswcvKfhMqLN9xTmhSpKrUbjqFNShzJBn8lLVEc+BxqibfzArBd5JU57JLp4XtbQEcE7slBL14rRWyQMJ95fV9LMwpsfPEK4QjlHtdXgQDEJPZs2TWeXm/VIV/Il+tj/u0niSce1cpFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM6PR11MB4515.namprd11.prod.outlook.com (2603:10b6:5:2a9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 04:05:35 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 04:05:34 +0000
Message-ID: <72c9b4d8-25c6-4766-9b78-4eabb3ee564c@intel.com>
Date: Tue, 3 Jun 2025 21:05:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 19/29] x86/resctrl: Complete telemetry event
 enumeration
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-20-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250521225049.132551-20-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0083.namprd05.prod.outlook.com
 (2603:10b6:a03:332::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM6PR11MB4515:EE_
X-MS-Office365-Filtering-Correlation-Id: 9644d7ab-0ca5-4193-b292-08dda31d0e60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RFQyNzhnSFJyUFNhbjN5K1FvNGxJZ2ltSnRVM2praTRhWmFHZWozOEo2bytF?=
 =?utf-8?B?ci9VKzdreWg1WEwwd2ZpeG1teUFaTzJjZjFmbCtVMkl4bTJYQ1dWeTV0SFk0?=
 =?utf-8?B?UzUxbzgvQlVQQ3cveHl2ZlkzeFZSbkg4VUJOcHRhTy9VWWVIN0dRaUhGcGF4?=
 =?utf-8?B?OFp0OHovSXpVdVg5K3RKYzQ0eWFSZ2wxRzlQQk9GamJlSEtqNktWUXZEa0ZK?=
 =?utf-8?B?TzlCcStaZ0pzR0NuVWlBWElEZ1FBaFRnbHJiUTJIQXIvUVQ2ZE5mYVFmRkJk?=
 =?utf-8?B?Q1RXMTdPUndLa09xZXFxV2ZBSEpySXBqM29MeWhzdmFUR2Rjajh0UEFHSkVh?=
 =?utf-8?B?TndzRnhTQXM3OXc1VnpkOGp2YnpRRTcwTSszNE14ZHlScnBQbzcwRVdnUU0x?=
 =?utf-8?B?S3hqY0hMdTB3dyt5SkVidjJ0NjdRamc4UVJRS0pBYndSZjNrUUlTVko3b25F?=
 =?utf-8?B?a3dFd0YzK3VxMXN3cWp2QzlDanZVcGRxb3hwQmVMT0xUYzRleU14RUc1b2NK?=
 =?utf-8?B?RStQa3J0MmlHbWE3UDJZVFAwaE41ei9JWDMrM1Npc3VDL00zYmpYa21BWFVZ?=
 =?utf-8?B?QVVmYnF1aENpdWdvcHhDaXBJNFd6UnQrRlhSTWlpY2k4bVdtR21ZTmZISk92?=
 =?utf-8?B?UjNkQ2J0dG5GUTM5cVB4MVhWRERmcWtxTCs3OEVSemRmWDlId1ZqSXA5Ykxx?=
 =?utf-8?B?cW4wdWFBNit4cVN4am5VSTk0WXN1RGZpWXJBTjJFUHBlaUpjMnpuWUhZd1cr?=
 =?utf-8?B?TVZCVGMwNjZTTlZFNnp6U1NyTlZJU1dyWXQvTDA2UjdVeHh0OHk5eG55QXJO?=
 =?utf-8?B?dkZ4WHFSZUxSVDdPYWk5cWtkVGx1VmhuSG1oRDZjV2hZa05VcEpTRVkyQi9Q?=
 =?utf-8?B?S1QyMCtQVWFDU1B1ekJ4dGh5WTcvUUJMd3BrdU0xNnJuS3NTTWZLV0RoSFNZ?=
 =?utf-8?B?KzJ5Vm12Ujk2VUN0RlRLbUdCNnFwVXZ4TDVWS3VDTllmRzczUVRVRlpNRnlE?=
 =?utf-8?B?MHJpNUdLby9CQ2VXL0NYWU1FQnd6OHVMd0VEeExhS3VORWF6V09RRHhjajFp?=
 =?utf-8?B?WUxlWGM3V01IdVJtRGdFdUFPUnk4QTQ4djJYN3EzdmJWNG1NRGFZa0oybzl4?=
 =?utf-8?B?bzJKTlhDa3JnRUZwcXNVSzJUNXo3THh3ZEFBb3BnMHhXU2tjSEkwZk9UWFVF?=
 =?utf-8?B?OHBEV1lFSXF0LzFQZTM4Qm5RSzZpWUNjdCs5eXFLMFV2ajl0cWRDN0t1ak5S?=
 =?utf-8?B?WWVjTHgxckJsNG9HN1hicVdITndabUpURWlsT1RkM01XOGR6am5EZ05raG15?=
 =?utf-8?B?U2RrYVdzMTAxNHJDUUFKTmZCQmFvdlM4VmNwdkNzL3RUSk1YQjFXT3FzQ2Ru?=
 =?utf-8?B?L2VuVkZNRlVWc0pmZy8zTnJFQlg0UitRa1NRN1NYVXJMajZhWW9xWmtKRk5k?=
 =?utf-8?B?MllkRmxqUmFPUFQrU1pSdTZUbWdYV1ltZ3BlSmo1Nm5tVlVxelhoS0s2M3N1?=
 =?utf-8?B?QXI3OTdRMWkxb2tpbCsreWJlTitkMVBtSXhDZTVLbjF6d3g0Z09ReVlYd3A3?=
 =?utf-8?B?aXgvbWRqZzhDM0FCMERIZFVhMklTU2ZMK3FiSVJWcW1YdStWcnMrQTVqL2RD?=
 =?utf-8?B?MUNUNk9tNktKZHNvL2FGNHUxZ05WNjlRSFRFSzQ1SCtZZHdFS3dVS2wzVTZH?=
 =?utf-8?B?bithRS80M3FRdjNIcmJ1dTlPWGQ2a1BqNTRsWTBKTlVLbzJhRFJ5R1VhZTVv?=
 =?utf-8?B?VmZiZlFuYVFFUjFjMFJBU3g3dUFCRUNGa05UWldQMFc4VGFHUVRLcS8zMHJk?=
 =?utf-8?B?VGhaNVZHL1YrMk5NVXYrTGpReEJlMnNQNW82REpqZTVhRmttalZXL0lGR3NG?=
 =?utf-8?B?eW9xcFFZNGtLSFJkbGpKUzFsMjNkLzBsVzZIQjczN1B6ZjJVd1JVRTN3NGgx?=
 =?utf-8?B?cDZRSTN3eU1uNUJZZ2hoNmZhNUJTSWFjemZTaG9pMFA5R3AwZDR5c0g2aXVo?=
 =?utf-8?B?K0pHUHlZZlZBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVhVeGU0OXYwODc5am1jN0hjWExQUm1nb3JmRC9tc2s3RytBN0Z6ZGZmaXor?=
 =?utf-8?B?dCsvUDYvY0Y5OHBTYzl3MWVrRTA5b3dXV3ZEaVpUWEVlaW9mdDFKZUNEOFFQ?=
 =?utf-8?B?VFFGbXJHaEV3RUR5MllJcGRWZkZyRDBqL3VReHZWUXdlcFVNYmppTlRLN1k3?=
 =?utf-8?B?NGd3UUZOTHdTM3pRaXRzZ25FRUdCZjNVUE0raDRTYkRWZ3JkM05iK1IxWFg4?=
 =?utf-8?B?TXZ2b1V3aGpCbVBnbnFnRmZWcDNzeEExaTlvcmVlQWRsQ29nNUxpcDBvTXo0?=
 =?utf-8?B?T1FLZXV3SVl0Uk9zb1BqbjgreGsyeFZHRG9ZTjlieDI2T0J6Y3gwc2V0Q2lC?=
 =?utf-8?B?WXdaREZjYzhCSEdOdCtPUE12cnpzUTFkb3BSK0VpWGgvOGZQdHlHTXgxcnJ1?=
 =?utf-8?B?dGNteVRPNVVXYWo4OTdCVmR5WGNZTkZaRml6TitMNlBqNEhDcEJ4dGZ6U3Vh?=
 =?utf-8?B?Wm9CV3hxUHcyQnRhOGt5SWlFeGFXM2ZMTmpwMDhLNW5QaW9ESnRlZkFYY0Mx?=
 =?utf-8?B?SUFrS3dNUXRDemFiZUZIMVZqTjVDQyt6K25vMkVTUEo2QlMvY0haL1BUdmhM?=
 =?utf-8?B?K1k4R25iNFVuclZkY2w2MVFZUG5ucGtkMmFqQWRXc0JsUm1GTHNPdW9WRkdp?=
 =?utf-8?B?M1dHN0ZGc29rQ2puK1V1Slp1ejhQeG5xZy9iajByRVJwUkpTN1dNazJjbEkr?=
 =?utf-8?B?NWw3czdQaW9ST0VYemFDZ0pqS01maUpRR2FLK3llMDMxSEgrQnU5N2RyTjZG?=
 =?utf-8?B?VzVvc1M5bHhPb3JlSGNzUklCSVcvRkRkdXJKS2x1VkdXaUNWVzJ2d29IWlE4?=
 =?utf-8?B?YWRNR1ZEZlpNMHRLTmdyNzIybmJnUmJqc3FOU01EZ0pXbGxMVk9kWnR2eGQz?=
 =?utf-8?B?N2tBbWVyZzRXNUgwUEtIWmlOMWZrTXgvMmw5L0hqcFZVLzlpK1hiTHhSMlBt?=
 =?utf-8?B?eFdFUnpNNkhCWVAyaHRIMjBYdkc0UjBzRlAySElGclZ3Y29XVkYrenZkYm41?=
 =?utf-8?B?cVRNZTJxc1JuZk1kNDE5amFvNWVESVNsYnhzUk1XL2UzL3VuV3owM2FhSUx3?=
 =?utf-8?B?a0I2SG1BS1lnQjJkZHN0WTFzM0JYU1VidGxkQ1c2Ty9HenowNUQwQTEyaFpr?=
 =?utf-8?B?cWdONXdHZXhsYS8wd3RKay9rdWtVSzN5b2ZFTFlCWWdlWjJFM0RVNDdwT2JE?=
 =?utf-8?B?S2pEMnhJVDNZZy9tcmlQdGx2b0xFa3l3Vk9yckVpMWRHZHJxc3F4c2xKY0Fl?=
 =?utf-8?B?QTI3SGlqNGl1eXNQdm83QUJkWGp6TW15K200OXRRTzl4bzNqbWxYYndMcUlT?=
 =?utf-8?B?UExXM0pmZjlwUkxqYXU5SDE4OWI0dUtESW9hczZOZUNNdUxsaTVrRW0vakxV?=
 =?utf-8?B?am1kamdHVHZqeFlybUpWWVlXL2lvQmZSdzZnV2pmQVhDSFVBdjY1QjIwcE04?=
 =?utf-8?B?ZllrSS9lbjVDRnU0WTZFeWZia2lscmJ0czl5V21UWDhsQStiQVhiTnJHZnNp?=
 =?utf-8?B?TGJCUVIyQ1RhNmZyWFRSeDY2Vm9LTFNTVXZ3dHQyZ2Zucmp4UUpRbHU1UXJH?=
 =?utf-8?B?TW9CNVlEdUJnNnBKWGh1S3NlUWx1RFlhWGR4b1NuZHJHTFFFYkZMTW9KeWFu?=
 =?utf-8?B?NlVmMlMrbHZtengwUFFkVTdmT0NneWtwM0NaYnVCZHloVVo4VGtNRDFiZWJN?=
 =?utf-8?B?T2FieFNhWkFTdjVzWlRCaWRUNFQ4bnN2TlBsbmRoU3hYZmJ1bHZFK3JsNnJZ?=
 =?utf-8?B?TGpkOVl0TVJ2WmJHeVZSa0tjSnBFQ2FHODBHcnoxUFc2aUhUcFBmNStzU25t?=
 =?utf-8?B?TTdTaFR5SCtzN1h2RS80T3FtVnY4MnV6M2E5di9ZenVwTkhaMGd4Q0VXOVRz?=
 =?utf-8?B?d0NBdXF6K29qUy9FZW8xMll5MklRcWoyY204VU1KVGY4a3dVYzlBYUtTeTJL?=
 =?utf-8?B?SUxpM3Z3UEpnSmNhS1FYSS8wV1NMM1ZCeGdSNVMxdGxIeXBrSjQ4OVJyZkpH?=
 =?utf-8?B?TGhLUm4xT2UxcHZFZUtzUmtTRWxzQkV0VWZ4K0RHR2pveEVnclF0NzllL2kr?=
 =?utf-8?B?cVlvVzVWWU9yM0liOGxScVFKN3V2YnllaldsQ09FU2dmWFR5TVlwcksrQnlQ?=
 =?utf-8?B?RFg4ZENJalNxUk1nckFPVm0reXNGUC9Ra0xGc1FYOFFMQzFKRWM2dFdPTndt?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9644d7ab-0ca5-4193-b292-08dda31d0e60
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 04:05:34.8393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QfW8VRMUAiQK2bjXynQvvyPxQkXxBNOX6iC7efafkBrLOrdCOXJAXpcp4kKWPP4vSWOFqL6nhkjQu25Bvf0JEW8Q776fytooH3gg//LpgIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4515
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> Counters for telemetry events are in MMIO space. Each telemetry_region
> structure returned in the pmt_feature_group returned from OOBMSM
> contains the base MMIO address for the counters.
> 
> Scan all the telemetry_region structures again and gather these
> addresses into a more convenient structure with addresses for
> each aggregator indexed by package id. Note that there may be
> multiple aggregators per package.
> 
> Completed structure for each event group looks like this:

The depiction is very useful but please note that the above description
only equips reader with "a more convenient structure" to interpret
what below represents. It is a leap. 

> 
>              +---------------------+---------------------+
> pkginfo** -->|   pkginfo[0]         |    pkginfo[1]      |
>              +---------------------+---------------------+
>                         |                     |
>                         v                     v
>                 +----------------+    +----------------+
>                 |struct mmio_info|    |struct mmio_info|
>                 +----------------+    +----------------+
>                 |   count = N    |    |   count = N    |

I think renaming "count" to "num_regions" will help a lot to
explain this data.

>                 |  addrs[0]      |    |  addrs[0]      |
>                 |  addrs[0]      |    |  addrs[0]      |

[0] -> [1]

>                 |    ...         |    |    ...         |
>                 |  addrs[N-1]    |    |  addrs[N-1]    |
>                 +----------------+    +----------------+
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 65 ++++++++++++++++++++++++-
>  1 file changed, 64 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index ffcb54be54ea..2316198eb69e 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -21,17 +21,32 @@
>  
>  #include "internal.h"
>  
> +/**
> + * struct mmio_info - Array of MMIO addresses for one event group for a package

"MMIO address information for one event group of a package."?

> + * @count:		Number of addresses on this package

"@num_regions: Number of telemetry regions on this package."?

> + * @addrs:		The MMIO addresses

"Array of MMIO addresses, one per telemetry region on this package."?

> + *
> + * Provides convenient access to all MMIO addresses of one event group
> + * for one package. Used when reading event data on a package.
> + */
> +struct mmio_info {
> +	int		count;
> +	void __iomem	*addrs[] __counted_by(count);
> +};
> +
>  /**
>   * struct event_group - All information about a group of telemetry events.
>   * @pfg:		Points to the aggregated telemetry space information
>   *			within the OOBMSM driver that contains data for all
>   *			telemetry regions.
> + * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group

Sentence end with period.

>   * @guid:		Unique number per XML description file.
>   * @mmio_size:		Number of bytes of MMIO registers for this group.
>   */
>  struct event_group {
>  	/* Data fields used by this code. */
>  	struct pmt_feature_group	*pfg;
> +	struct mmio_info		**pkginfo;
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> @@ -80,6 +95,20 @@ static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
>  	return false;
>  }
>  
> +static void free_mmio_info(struct mmio_info **mmi)
> +{
> +	int num_pkgs = topology_max_packages();
> +
> +	if (!mmi)
> +		return;
> +
> +	for (int i = 0; i < num_pkgs; i++)
> +		kfree(mmi[i]);
> +	kfree(mmi);
> +}
> +
> +DEFINE_FREE(mmio_info, struct mmio_info **, free_mmio_info(_T))
> +
>  /*
>   * Configure events from one pmt_feature_group.
>   * 1) Count how many per package.
> @@ -87,10 +116,17 @@ static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
>   */
>  static int configure_events(struct event_group *e, struct pmt_feature_group *p)
>  {
> +	struct mmio_info __free(mmio_info) **pkginfo = NULL;

struct mmio_info **pkginfo __free(mmio_info) = NULL; 
(checkpatch.pl)

>  	int *pkgcounts __free(kfree) = NULL;
>  	struct telemetry_region *tr;
> +	struct mmio_info *mmi;
>  	int num_pkgs;
>  
> +	if (e->pkginfo) {
> +		pr_warn("Duplicate telemetry information for guid 0x%x\n", e->guid);

This could be triggered by user space so may be safer with a "once".

> +		return -EINVAL;
> +	}
> +
>  	num_pkgs = topology_max_packages();
>  	pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
>  	if (!pkgcounts)
> @@ -104,7 +140,33 @@ static int configure_events(struct event_group *e, struct pmt_feature_group *p)
>  		pkgcounts[tr->plat_info.package_id]++;
>  	}
>  
> -	return -EINVAL;
> +	/* Allocate array for per-package struct mmio_info data */
> +	pkginfo = kcalloc(num_pkgs, sizeof(*pkginfo), GFP_KERNEL);
> +	if (!pkginfo)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Allocate per-package mmio_info structures and initialize
> +	 * count of telemetry_regions in each one.
> +	 */
> +	for (int i = 0; i < num_pkgs; i++) {
> +		pkginfo[i] = kzalloc(struct_size(pkginfo[i], addrs, pkgcounts[i]), GFP_KERNEL);
> +		if (!pkginfo[i])
> +			return -ENOMEM;
> +		pkginfo[i]->count = pkgcounts[i];
> +	}
> +
> +	/* Save MMIO address(es) for each telemetry region in per-package structures */
> +	for (int i = 0; i < p->count; i++) {
> +		tr = &p->regions[i];
> +		if (skip_this_region(tr, e))
> +			continue;
> +		mmi = pkginfo[tr->plat_info.package_id];
> +		mmi->addrs[--pkgcounts[tr->plat_info.package_id]] = tr->addr;
> +	}
> +	e->pkginfo = no_free_ptr(pkginfo);
> +
> +	return 0;
>  }
>  
>  DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
> @@ -168,5 +230,6 @@ void __exit intel_aet_exit(void)
>  			intel_pmt_put_feature_group((*peg)->pfg);
>  			(*peg)->pfg = NULL;
>  		}
> +		free_mmio_info((*peg)->pkginfo);
>  	}
>  }

Reinette
