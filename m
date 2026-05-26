Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F643A6B9A
	for <patches@lists.linux.dev>; Tue, 26 May 2026 21:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779829549; cv=fail; b=UfDcf9/e/b1ftBt3ekuhapmea7LXOyNWPuk/CqQXpv/ICrFCTRA+pq0FqGhNA6OXS5gR1uLsNH7tIfiGt7wHrsSpbKazrgPCcaoZ9N4YDa40ZvWFAvCOthY3hNHYIo4uV15Mx76FL6yVEtz6Fl1ufiL+XJTUUxyZr6qEMsddT1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779829549; c=relaxed/simple;
	bh=zH/ehsAfLj202t8ldncWmLdBnEfPC70TL6+DzJOTAzo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TyDZeFq9B/cYKtrI1tqbbIzNSS+j/MyQw27peIq5IavX5EFTnT07lMn+oCI1z9UMALmG3RTLzXQlWfOizNibsoE9dJTwKJJDlUZxNL1Culq86rCr+7NtbQ8M85IfL4t2fw0TDq3LWg47qd/tdzdGcA0l6U0YpWnwxQgLraE4hgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nv/2YLus; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nv/2YLus"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779829546; x=1811365546;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zH/ehsAfLj202t8ldncWmLdBnEfPC70TL6+DzJOTAzo=;
  b=nv/2YLusVgYi186AZTMaNBy2i0/NVNjYlIji2f1ZTBPG5h6M+BgIjZcl
   0Vlzbl8jxeid3NzWaAUnyY24TgLiHrsR3qfHAbKAtkxL8YCcbC0wSmTsn
   NbR6cemQx7K5Mr41WagU1gJI5vNPmTR2AiSeGhQujQsJbXxNnJa5LbbeX
   j8Pl851wZkSCpscuccHqZj/60K39atfV5ZbR885BpKuLHzmzWzkaAavGk
   txlMQD+AI6zZkRMDWCKpJq4dI5IO65VOwh2X31gsmGnCHuVbl8AbqpFBQ
   7ZE+wetXgoQFxFuUYpvbN0/Sp2DkpmmH8iGzEw5dTDrGaXZZsrXP5AyLv
   w==;
X-CSE-ConnectionGUID: hGfC2njXRi+JwznaakdEEw==
X-CSE-MsgGUID: A5OY299rQPiC6YHDeWwFaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="80503860"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="80503860"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 14:05:46 -0700
X-CSE-ConnectionGUID: 4GQ9OR7BTQCtbYjmXsD0yw==
X-CSE-MsgGUID: vEvWmBwbS9Wy+QBn0QsJtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="241194372"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 14:05:45 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 26 May 2026 14:05:44 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 26 May 2026 14:05:44 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.44) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 26 May 2026 14:05:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LIXD21KiI89nAoKk72aIuAMQlsmlajyjA+p2CbwY65IWjduFg8HuliP3boPhkg7vyLxDn8mnftOWa9/7Xz+Y3EKnbaAy/PS3kdevBAACiPhfJe/y1J0FbVmZ+QFJhCVyKgJFs2sMrPpBCUAn5smBZXN3/brslHLgdZIX7LnKcVqbzgKepgFo+ukBA3WlikhjjJj/HLPnb8KY6Yvn6WdVJvp4nWAhLEVDzFec9YayXEHTNNqpVTMTnCdtgvIKSjTRlwGPdF0mjLvgxaoGa2zE/LPd2b0o2bnPYsnZIu3CKjRYjJLTF39k8lirnuBICkL1y1CviINUhyaLTAUZMBqJ9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHy1UOTCZdboSEl3Nd3nJnhvQF30UAMsDhfBIpe9YEs=;
 b=aeQJ74uuvlTRMUIjZAp3zLapXP0679fhzgMXynZmZL9UZTI4npfcLzJDCalpo/yme+ftozkzZBQT5uga6v9hrQtitOZPhGY5wI6nXHKL6/p5lUQTGlc1In+vxTUhQrXNwRbwuDQvkTN7bQsaAcGY/6ou2vHXa3+L+l9NVIye77Bz+e7kDC7EK9TovfTble41FyOZC/t81QIU714ScZMkzzgsAKLUSKXthZUyFAqM4Uy2oZKqAyUdDgxoRsqFdv2rtoBZ845i/C/OrezOCO6O8UXiYvgWUJaPBUoVDVkmcu54WTUrFgTlP4TBKQ/stJcV4Bpy7/wuPJdAMj0l6eQw/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PH3PPFF8B8D6872.namprd11.prod.outlook.com (2603:10b6:518:1::d61) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Tue, 26 May
 2026 21:05:36 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0048.019; Tue, 26 May 2026
 21:05:35 +0000
Message-ID: <d5ead3e9-f878-41ce-98d0-ad7fbcd778c6@intel.com>
Date: Tue, 26 May 2026 14:05:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 9/9] fs/resctrl: Fix UAF from worker threads when
 domains are removed
To: "Luck, Tony" <tony.luck@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <accc44062440c9b9ef220fe7570588e00f8a238a.1779476724.git.reinette.chatre@intel.com>
 <ahW9EJORpIqnvthk@agluck-desk3>
 <da9ec0a6-8ea6-4b85-b4b2-6f4fbd32f687@intel.com>
 <ahXl_UF66yiPiEPB@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ahXl_UF66yiPiEPB@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0006.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::11) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PH3PPFF8B8D6872:EE_
X-MS-Office365-Filtering-Correlation-Id: f644e46e-f5a0-44b8-ccf1-08debb6a8804
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|22082099003|18002099003|56012099006|5023799004|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info: 6h/DESK1L6rK22Pj2wN0Vcl3Z+p5ojS7EtEA8IUMFw3St3Hx9r8ykojUF+40DzBIMm/T6zXOMo7HPY7kQuYB8WoBG5Idhlk3Ls9Dks7U29EnIlW2p9YZS+LRTXIc6lyKAqMla3DmV3uhQcvciMjV07shfM1jDlHxPPR19FuwsVuuNU9On+ZKPsBXRHlfCIQ0VkZr4wOfrUOa/1FiJNzSSjvMnL1QSvwtVYqsQao3a/aRj32zyEBeNPY+m/TEyUJjRJErIrlVuHpNf9ocVkkLspAZLmJOTURIuv0qc94vTWueLxTvlYZVSnJl9aThU/07oNdWEuA2+Vu2nW6UDmfPpNlyKkBZ5wxL3XiqX2u9zO6HB1oBoM0HghEFJycfLkruHyWdOIL914T8Uv2GotMv3jPejPkj4Ivukg+4yHlPH0KPgKiX5igOm16SEFTyambqHpk3q7VAwgyG99Kb61vPd+HF7OMPf08zXW00rsSNTHo2WH68t0kj9FarLdGFD6TmnnJCkJHOXCzOOxuKN0eDeWeQ/hXRQGamL4fHS4S1b3RC+DGvGjPgS7Q4FnTt8orXh+g58oVIceLKtWeQ9pFKoZ21SS3doifeXtDAtWHtCGSa9QUm5DxToS8Iv6umee1D5ceq1TlwNuvOEIN5QfBNygP2fRMvMKZNfsmZ87/P6nnyePXvgfV0wJ2AJWL0gjut
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(22082099003)(18002099003)(56012099006)(5023799004)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Snc0WjBkenB0RE9qcXhob0dRV3dadGJjek1Reko3d09oL2x4U2c1V3FmbjRk?=
 =?utf-8?B?Y0VKSStaMDhEQ0JIRFpINENaS0tobzNiWUpBWS9iRDBhbUZPS0ZaTHJaU25v?=
 =?utf-8?B?SDBieW50c1Jwb2p0ZmU1QS9BVWxnakVxSVZPNStPSVNudmVUWGI0NllqVy82?=
 =?utf-8?B?cVBVRU1BMC9sck9CMUVSVnc4ZkZVclVMc0VHV2JQNHA3ZElwazZpOEtRV3da?=
 =?utf-8?B?bnRyT2ZzVE5WbFpWOUtDU29EVUZtSzA4RERzc2xHNXM5bzFzSTB3TU1NbExi?=
 =?utf-8?B?eWxiSjZkc0NvTEJBYU9vanZnaDVPeG9YbENSRjJSZ2FTcW4vNkdZVW5iTjNp?=
 =?utf-8?B?S3VVWGZjRmZEanRTSWxXSmlDTk9KdzJLYXVURm9XVTlueDhkNXF0L05GUnB4?=
 =?utf-8?B?dFF5UUpQeEZZS3orSzN1NXJmOFBqclo5bFp2M1ZmNXZPbVhvOVJFc2RiSzlB?=
 =?utf-8?B?RFpIbHN0UUZ4QXpLeTRmL0lCNkNTMlZrSjhHNEFnbUZCRGJ0RFdqU1pyNUwr?=
 =?utf-8?B?UEZTcU1talNQR1RaR05ha3dPVk84NHYzREpjQUJWbG95bm05QzBzY2k5Zjll?=
 =?utf-8?B?eUpkTXpnbXR4RlB2ei9MUFNlQnU4ajY4T1A2Y2JkQlZadUJ6NDZ5WERuS2VW?=
 =?utf-8?B?b0R6VzFZc1NJNE1LbFdQZG1PcExBRGFTajl0NWFrQlFjY3IrRDJ1YUhKY0tN?=
 =?utf-8?B?Y0h1L1V5RWczSVRTdnV1cFNFRC9EdVM4YW1pQjRvQ2VHS3dkTzErUzBUTVE1?=
 =?utf-8?B?NXZUUGl6ZTJtMkJ0bitZOE8xZGN6STVmdHdmcFN4a1FsQzJLRlU5ZFd5ekVa?=
 =?utf-8?B?NlVqRnhRT1R2czZ4QTd1OE1FZHowSk1EMjhRUjhqb2ZrWmh0cnVtOUE5Vm5L?=
 =?utf-8?B?aTdrYVQxNmcyR0RvV2ZrK0NpWERSVWhCUFFueEJnUVkveUJBOVlsdzZKNndl?=
 =?utf-8?B?ZnNJQVZqTUVCSWpXQnQveENLR1Q2elNXSlF5YVI1WHJYaVFnQ1l2MDBuOVQx?=
 =?utf-8?B?QWtQN1dUWDFEQm5TSFF3MVpoVGcwVCtHZW5LeVB1ODd2b1lkbk1RMi9RSlBY?=
 =?utf-8?B?Z3A1cEZCRXV5UHFRRnpjMmc5bXl5U29OaG5ua3FBTjRnRW1BMHpQdDZDWGpB?=
 =?utf-8?B?TUN6WmNaSkQ0YytpekpZRE9hQngwTU9TSGZ4NDVoSWRtM3BXT08vYVZSM2Va?=
 =?utf-8?B?VUt0ZTZGZC9GRGgrUkhGSTZjdUFQM0FnR3lGOUkwSDIvaG5hOFhIZzZkQWs4?=
 =?utf-8?B?L3VMc2hoeHgyR0t0NU1VUWdNQnJSTmFDQ3BJcjl1NjE5SDBxZWw5WjJnSUlK?=
 =?utf-8?B?aTlGWFR4bnAzVEE1REVQVFZyUzBxTHBSUGs2NWJZUEI4clNQUFZiRkRNczVp?=
 =?utf-8?B?ZnVrbGRydlVIVFFCYTd5MndnczFaeEwzbE1LYnpMUGtqUkZTY2ZmK085TEE3?=
 =?utf-8?B?UDV0UVh6Z1p0YzNWZUZCTzBJU2ZlcjdpZU1HU3dscTNROUVvV3lFYnd2aGRn?=
 =?utf-8?B?TWJtbjM3MTgrWFJqRE90OC95b1ZTV1NiYzhoZGttbXh2SmtZdDJKOUJYUE5o?=
 =?utf-8?B?S0lUeEVPS0krNFhMV09iaHhBUGxMTW1iT3pPSnZ1SHRoQmppbDJoRmhmVEJo?=
 =?utf-8?B?YjBpWGxnLzRoWXh1NlNhY3NmbWExd1JoZmFiSjRVeE5tbUJ5MXBaQ1NaYjc0?=
 =?utf-8?B?cFF4S3ZUUjBRa3IzZS9kOVFHSUxrQWIweWFKVElaUUF1QmxzeGQvOVhvZzgz?=
 =?utf-8?B?ejVXUTNUaytRbDc1SG1XbUlHcG0wa0g2RnlnankyVWVGQTBoTCsxcHBFdDFn?=
 =?utf-8?B?bUM2ajJqM3UxZm56c09CdU1XOTFwR0xFZmRCVW5DUkxpRGM0VlRwVkpnZHpS?=
 =?utf-8?B?N0dUbjgrdytSWGQ4VG1ybE4vb09OKzdJV05BeEFJS203WUhBMFo0ejFUaEc1?=
 =?utf-8?B?eHhFUmNsZXhYWDF4eWRRWS9uVnNZNlQxS0x4dVdLbEdzb1dKZyt5U3BVeFpq?=
 =?utf-8?B?R0dxVmpiOUd3Umdvb3JBZFBvNVpnU256QW9zaXlMeFY3OVFsaHJSZFhpV0Vs?=
 =?utf-8?B?Wm9RbkJJN3d5LzFTVFJ4ODlyb0MyRDF2UVVXaXhndi9zRnpnR1doU1k0aXRW?=
 =?utf-8?B?UkJtekNXTjRhSi9Pb1p2V3BMSXdiQlplTmkwQWFyR0tBdzVEdjUvOVJUWFZB?=
 =?utf-8?B?eWVZUkduVnpCb2ltN1BJQzB2NGR3MW1ZWTNLMWtNRm4ya1pGazhCOVNDYlFH?=
 =?utf-8?B?WWpTcHF4c3RvYmdkY1R1QWV1RU9ubmw0ckhvQXVidHZERmdQU05PSjhXUTJT?=
 =?utf-8?B?Zzd1YnpZWjhlckZmRFBZQlJkYTM5STkzbTdrdTNuMWFCRU45eFJITmsrL0J1?=
 =?utf-8?Q?4G0TX3l7CZtO6Lag=3D?=
X-Exchange-RoutingPolicyChecked: ggFWONJGA+X/R7nbSBTKozti97R90EBT+Z1TK7MpYjO8gP2ldr7u4PHvZ36ulxBT98Mf/YMlXqLP/h87rOIjS6LdVNS9LvoF4CsJP4yq98A1rbW1b/ohjYHuvD65F6kuIZ8bHK8hfxm+gIKcRjKG9p5vVGLr8uMU+aIz+W92A+kZbqaR9Bn92+HgS5VLbM83fXJ8RAzYPYyJJjBY75EPWYJbR2uBKhGM6YC3MmL/aO0ZX/TRVGVb0/Ukt49gB/e6MHSoeljyKeJSWlLpV1k9A9e0RbXJ0537mFIHOxC/3HRgV51MGE/44LxICwooUEaL33jqqVXqOPKCJjx+U8ry2g==
X-MS-Exchange-CrossTenant-Network-Message-Id: f644e46e-f5a0-44b8-ccf1-08debb6a8804
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2026 21:05:35.8320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: un7r4VYI4qVQUVLhzMVlx9VwrhSLOj/VJgYXOpxoCsYVGsLG1KVmVZloEYJRgjx27WlDC2XIdpYFzr1EJ4BcMTfkdnYu9lJLQgo9mai7V0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFF8B8D6872
X-OriginatorOrg: intel.com

Hi Tony,

On 5/26/26 11:27 AM, Luck, Tony wrote:
> On Tue, May 26, 2026 at 10:53:59AM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 5/26/26 8:32 AM, Luck, Tony wrote:
>>
>> Instead of deleting the patch without any comments, could you please provide some
>> insight to what problems it has and why your solution is better?
>>
>>> On Fri, May 22, 2026 at 12:15:13PM -0700, Reinette Chatre wrote:
>>>>   - Adding a reference count to the domain structure to avoid the worker
>>>>     needing to take CPU hotplug lock. This ended up being very complicated
>>>>     with the architecture needing new APIs to manage the reference count
>>>>     which cannot cleanly integrate into MPAM since it uses a single
>>>>     architecture domain structure to contain both the control and monitoring
>>>>     domain structures. Managing the references across mount, unmount,
>>>>     online, offline, as well as worker self exit resulted in several
>>>>     asymmetrical and complicated paths that were error prone. Locking also
>>>>     proved to be complicated since architecture would need to initiate
>>>>     domain free that will need to call back into resctrl that will take
>>>>     rdtgroup_mutex which means that references need to be taken/released
>>>>     without locking.
>>>
>>> I'd been working on a reference count approach too. The MPAM combined
>>> domain for control and monitoring doesn't seem insurmountable. Mostly
>>
>> While technically possible I do not think it is a clean solution to have
>> the lifetime of the control domain be controlled with a reference in the
>> monitoring domain.
>>
>>> because it seems unlikely that the problem with worker threads would
>>> ever apply to control domains. Maybe I missed something, but just adding
>>> an architecture *release() function that can be used by file system code
>>> to drop reference counts on the domain when worker threads exit seems
>>> enough.
>>
>> Did you consider the locking implications that I mention in the description
>> you quoted? More below ...
> 
> I didn't run into any lockdep splats during testing. But maybe didn't
> have enough code coverage to poke into corner cases.

Your patch avoids lockdep splats by using *resctrl fs* domain reference to protect
only the *architecture* domain data that can be removed without rdtgroup_mutex while
removing the resctrl fs domain data unconditionally. I do not find this to be a sane
usage of the reference count. Since the reference is attached to the resctrl fs domain
(rdt_l3_mon_domain::kref) then I find it reasonable to expect it to protect
struct rdt_l3_mon_domain's data. Could you please elaborate why you disagree?

>>
>>>
>>> My patch below.
>>
>> heh 
>>
>>>
>>> -Tony
>>>
>>>
>>> From 611fd8ad816abd37ef9a65b39175ce05907a1d41 Mon Sep 17 00:00:00 2001
>>> From: Tony Luck <tony.luck@intel.com>
>>> Date: Thu, 21 May 2026 15:14:27 -0700
>>> Subject: [PATCH] fs,mpam,x86/resctrl: Track reference count for L3 monitor
>>>  domains
>>>
>>> There are race conditions[1] when the last CPU of a domain is taken offline
>>> and a worker thread may access the domain structure after it is freed.
>>>
>>> Add a rdt_l3_mon_domain::kref to track users of the domain. Don't try
>>> to cancel worker threads when CPUs are taken offline. Just set the
>>> target CPU for the thread to nr_cpu_ids to indicate the worker needs
>>> to take action next time it runs.
>>
>> One test I have found to be useful when digging into this is to offline all CPUs
>> of a domain starting with lowest number. Since overflow worker runs on lowest number
>> and then is moved to next CPU when it goes offline this stresses this new mechanics.
>> Have you tried something similar or could you try this test with this solution? 
> 
> Yes. My test case ran through all CPUs in the domain in order. That
> showed an interesting artifact that when CPU 36 goes offline, the worker
> next runs on CPU37, which is the place it needs to be, but it isn't
> bound to CPU37. But since d->mbm_work_cpu (or d->cqm_work_cpu) is set
> to nr_cpus_id the worker calls schedule_delayed_work_on() to get itself
> properly bound to CPU37.
>>
>> ...
>>
>>> @@ -680,18 +692,16 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>>>  
>>>  	switch (r->rid) {
>>>  	case RDT_RESOURCE_L3: {
>>> -		struct rdt_hw_l3_mon_domain *hw_dom;
>>>  		struct rdt_l3_mon_domain *d;
>>>  
>>>  		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
>>>  			return;
>>>  
>>>  		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
>>> -		hw_dom = resctrl_to_arch_mon_dom(d);
>>>  		resctrl_offline_mon_domain(r, hdr);
>>>  		list_del_rcu(&hdr->list);
>>>  		synchronize_rcu();
>>> -		l3_mon_domain_free(hw_dom);
>>> +		kref_put(&d->kref, resctrl_arch_l3_mon_domain_release);
>>>  		break;
>>>  	}
>>
>> To me the idea behind a "domain reference count" is to provide guarantee to any holder of
>> a reference that the domain *and* its data remains accessible while it holds the reference.
>> There is the domain structure itself and then the architecture specific, for example,
>> rdt_hw_l3_mon_domain::arch_mbm_states, and the fs state, for example rdt_l3_mon_domain::mbm_states.
> 
> Agreed. I'm not guaranteeing that the whole of the domain structure
> (with all the substructures that it points to) are valid. This reference
> only promises that the mbm_over, cqm_limbo, mbm_work_cpu, and cqm_work_cpu
> fields are still valid. That's enough to solve this issue, but if we
> were to adopt this patch would need some comments so that future readers
> were not led astray.

Adding reference counting to the domain structure that does not actually protect the
domain structure but instead introduces additional corner cases created just to fix one
issue is not something I am comfortable with. I also do not see adding comments to
explain all the sharp corners as "fixing" it. 

> 
>> Above snippet moves the freeing of the *architecture* state to be called on kref_put()
>> while *always* freeing the fs state (resctrl_offline_mon_domain()->domain_destroy_l3_mon_state()).
>>
>> A worker may thus have a reference to the domain but when it runs it runs without 
>> fs state which is just a new use-after-free.
> 
> For this specific case, the worker sees "nr_cpus_id" and avoids use of
> other fields that may no longer be valid.

This does not sound like proper reference counting to me.

> 
>> As I mentioned in the description the release managed by architecture implies that
>> reference needs to be dropped without rdtgroup_mutex held since the architecture
>> should also call resctrl_offline_mon_domain() as part of release. Locking needs
>> to be reworked and needs to adhere to kref rules on kref_get()/kref_put() without
>> locking.
> 
> That's all handled in the existing (unchanged) offline path. The worker
> threads only need to call kref_put() to release their hold on the domain
> structure that has been mostly freed (and likely has no hold from the
> file system by this point).
> 
> The release functions in both X86 and MPAM don't need locks, they are
> just calling kfree()

Right. Not needing locks is possible if the reference does not actually protect
domain state.

... and just ignore the design comments.

>>
>> Reinette
> 
> I see that sashiko found no issues in parts 1-5 of your series (Yay!)
> Grumbled about some issues in part 6. And then gave up before getting to
> your latest solution to the domain offline problem.
> 
> Can you repost just part 9 (or maybe parts 7-9) on top of latest -rc to
> see if sashiko is happy at last?

... and then will you take a look?

Reinette
