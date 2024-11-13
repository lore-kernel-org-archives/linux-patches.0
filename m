Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91AD18A6CC
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 22:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731536771; cv=fail; b=Q0TtsLYJa2NJOmGCEFdNV2zGrcQCmHjJUCQxioI1+UII6HMcVjPQSyF/9c8hHJ2zLcLKXsEOrn5cmGgti+xejPBMIxT900Nf8C5jo5xRW58Q22mKiEfisTbI0SxBxt9ebscz+d6Vqmh70d+AZDbVJxAO4J6rIjnG/I9uaRqMLtc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731536771; c=relaxed/simple;
	bh=5f5Fc2sEO1PDlOKt5oLdpui+GsJ+CxpJ5Uo9JgYUxPI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EFtNfEicT2GO55KRqcgTfrd3riaTilqmY+YcIt0WWMlnzgVppsYv/TIR8WjIULuOox5Ccn9Hi4yx71r2MRqb7FsztvDaTOedLeoWx4bUCZMKYsj33CLsGsTG0i+u2hz9PjDG3S4w88ZufUddzgE9j+RuYnLsdG2YGSwYh6YH5P0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iapDncCe; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iapDncCe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731536770; x=1763072770;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5f5Fc2sEO1PDlOKt5oLdpui+GsJ+CxpJ5Uo9JgYUxPI=;
  b=iapDncCehm+BHIqQcr1cWQLCqx1groExBefvnAk0URLA5o2A6t/Xm7J7
   Qff1sk9lkNCT8dxt9BjWCGef8TJC0+vNvCFoNN0lJvtZSqDuxPoNx91ny
   ObCXYGYeogkwuL8ypI9dA0FW0ZkWel0iE2CthqbnRWzk3z2/xuV0/1kg3
   rtjnbAq++zBRsK8NaOaBASyekffH8xPFSSKAW/EaqQS1ez3QoeMH8gYV+
   DJia/Q5ykPxXsLD1twB6JWSaZcWn/yk9SMuUQsl5bDURxV9FvxcjOdnAd
   YdcA9/0w6mTA+j4RPHnaIZEFCoBCJlLhNs05zPEBIlLoaHKSsnkiCnPuU
   g==;
X-CSE-ConnectionGUID: a6fwyQ6yTR+tSenkQUq4Vw==
X-CSE-MsgGUID: mi8mRrDTTCGnfOApgzKaBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="31334014"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="31334014"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 14:26:09 -0800
X-CSE-ConnectionGUID: NZOBwpT5TEqy9puFpPYNTg==
X-CSE-MsgGUID: uXXhdk1ESe6lAD57JyIrkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="87564540"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 14:26:09 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 14:26:08 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 14:26:08 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 14:26:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y8Cuez3HoYEtScY6k/sJWktUySSz/jYWI2Pf9XxfK/4GpG7tiM/vT2Q5jTVukG6YvLcVFj9QeDawVJGjWs2UNNxTQSnkq20+do+gUP7qzEYipmH28UOHbSsmLs97J8VbUlLCFIvvC9YW+01d5lHPz2Iw4MN0KYSg9BXp7oikibz4GhceHayvGBJsu+ujAwGQZgR2r0shqp8y5uCvt9ShFdejAGo5bYQl5w9HaBKt5JVXI+5sqa3obzMdcUIsLNa5C6DCoPs6EyT5xPwErlQUwuNLQgkNUlc5/SvRNmZQv6UT+VQ6FF6wO9ZHcK6eYbz1M4QFdTjUduhH1YQ98Yr8Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LkG4olWeZf2R+hf2+8RLh254D8Iw/boeMnotCxTBJcc=;
 b=dmVrEp7DPT8oChhafOoXqP8I3h45wcpm5L6qSrR+10I6n6mbh5fP7OevWnUT7LEhfRVw5eI7aN6eYAxQwZK6QzthMp9h45pEr+YP6K6CcXWpCaJ86pUTTihIanIrvxcsEJg6DEnykyxGPkl1VWPAu11w6GLiJ3Ek6/oyLyw7gP3eZn4yE4iSMjVYE6owsHBJ0xBmzRny/Fk2h1cVdW53DHpKist3AL3Wq59+Nl/tKyFiC01080O+Q/Som1E73NBLP0lKSAaA2nKWaPmXzmPczBDwSKJD+1hrhjIltiRhzWnorXwWMRzz8e9LNVvuK2IlEl6slQFkOAaw8KiDblYxOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7730.namprd11.prod.outlook.com (2603:10b6:930:74::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 22:25:57 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 22:25:56 +0000
Message-ID: <f4845fee-3f91-4e78-a186-a7bdc58f7873@intel.com>
Date: Wed, 13 Nov 2024 14:25:53 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/7] x86/resctrl: Refactor mbm_update()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, <x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-4-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20241029172832.93963-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:303:b4::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7730:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b8cd2d2-756b-479b-dd99-08dd0432242b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a1hubjRpUTV3VkFWekVJc0RwOUExYVprSWZSTy9ZNnd3aDc2aG9OY3VBU2JO?=
 =?utf-8?B?MStTUHVSM2FOZGx1eFJBSE9LSDFzdU9IWklqazA5VXpvQ2tCWFBpcGNpMENp?=
 =?utf-8?B?aGZyeVQySDZXRjg5aGRFQXhIQUxsdFA0ZzE3SlVGaGFSaEJiOFU2RlBZYlpw?=
 =?utf-8?B?TDZVczdjdWNpUDgwZ0tTVEVFaHZTWXRhZVMwNTc4UTN4YWxuUEdqNGptYWw1?=
 =?utf-8?B?cUo4S05yTURIT1hCOGdSV2VTN2F1bEJxUG9GekFPMmpSQXA4VUFoNGRyRm1C?=
 =?utf-8?B?akkxeGgvekdDbDNZR01ZVmNpN3hvZGplWmV0ZWEzWDVkQVhqcFNmZFo3NFlK?=
 =?utf-8?B?UVF1anpVcFVza05aS01MZzJaTEROUmlxS3RIdytMYmZ2QmQ0djdwY1hXT2Vx?=
 =?utf-8?B?eDRVZjVwLzZyUTdyNmJiSnp0c2lDU2oyS2ZTOFpIZnJsR2hWeS9TbGV5Q3Nm?=
 =?utf-8?B?QW1LVFhpektWS01pNVljTmswK0JkbWpjV0dSRXF2RGxZSHFNZUZrQWY1VkFS?=
 =?utf-8?B?b0syZkdIci9rbjVLUU9GbFJUMmdrdE13WFFSMkd3d1p1MWVzb29IWTAza0Nt?=
 =?utf-8?B?Y05mNGhEdC94dXM3SzFQQTBVT1d3WFhkZFczVktHa3pLZjdjc0NoOENieVBR?=
 =?utf-8?B?VEgxbXhCc1VoTTNZRm9maEJtZnBvZGpkdUYvV2o5MStUSHZ6dW9hdFhMcjI0?=
 =?utf-8?B?NHRCTDhRbDQ0N3dTT0xKMTJHMXRLdmw2RUhXbFh6NmR5YUxjYnJ2aEdDUzcy?=
 =?utf-8?B?bXJ3cFQzbkVvc2FmeURQcUoyZmdnUjVXTXM2bTh4RGsrejdMUE5keVlWR29s?=
 =?utf-8?B?OG0zSDVWUnZmaGZWdG1sa0dVVlZqUnhwdHc1UGFMUkRNQy9WK3EwemhmcWxZ?=
 =?utf-8?B?bk50YnZGbzAxc3dYV3I2ZXEwcFZUUHkwVkkxdkw2RW9WcGV3M2s5R2FDQ212?=
 =?utf-8?B?ZGd0cWtCM2ZxRGdha3B4OTdKSkxCeGRSWWNONEJkRFE2cFhkaGlNWlY4V2Nx?=
 =?utf-8?B?Q2t4VlFvZFVoek4xd3lFOCtTRm9yUjZ4d1p5TGJBb3Iya2tZS1N4ZHpWTExs?=
 =?utf-8?B?eGxjRjdtZHk4alJPN24xL0FScnpTU3MrcDhQRnFQN3ExRDh4aHRhT3hPMGJ3?=
 =?utf-8?B?aXpubUZvTUJMRVBhVlo2VFQwKzdXYVR3NjZJamZMNGlxdGROUC9kUnF2RWI1?=
 =?utf-8?B?bll2VS8vRVg3d1pNOWxETitTNGVTZ3BvWkF0L3NMdnB6TytIbVphTmNmbURO?=
 =?utf-8?B?MmpuZDhKL251OFY3K0l0WkFJNXh0ZysvYWs4VnpQNzNpWDdGeHQvbVhjci9k?=
 =?utf-8?B?QlN6cVVMNWpNc0M0QjRIdmtrUkhWUzR4ZmEwV29XeVdFU3Rtd05xdlFUUXpo?=
 =?utf-8?B?bWpzekk4Y2k3WFFrbzRDNjFQamt0ZkNZUUkxM2wwYlovT3o1VGsxOUFUVUFW?=
 =?utf-8?B?dVlGeWdJZzd4NnVZZWVEUFFOejMvNkFWTitqczJ3K0xTT0JIdFhEVUFZUDk1?=
 =?utf-8?B?R2tvVEV3REtrQTZUOVNpVWJqVDhLRHdJVFBIbnJTYlhmSWVjNnROc1Bmangv?=
 =?utf-8?B?Nm9jU0Q1M21XOFNlRjEzWURjSEZLUGdiRTJNemJuT0RwOTduUFExbXZ3OW5R?=
 =?utf-8?B?eTJRQ3E3YXd5MFhXTmgzdERVT013N29uUVlCeXFiQThEMmRqRGRWMXpTU3Yx?=
 =?utf-8?B?NUxvMnVGeTZhbkVaUVRGMnpXeDFLemQ4K1diZlI0dlhoMG8zU0ZkWGplWHc1?=
 =?utf-8?Q?niFfwrAcawFuPrlieY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zlg3MDBCRG4wK3VRcnNoN29tV0ZwbjJvQjJEOUtLOGR1TkllOW9UTDQxQXlF?=
 =?utf-8?B?bStrdDhjSW1oVXpQOWhIUVZST1JobWt4YmJ4a3Z1M2F5UnRTaHkvejBHZ2hv?=
 =?utf-8?B?YXhIeTJjakIwNm9FbHFTaC9rQnA1ZitJLzBiazBxMHh4S28vVGdndUZYNEx2?=
 =?utf-8?B?b0MyRlVwR3dIc3VGTGRkekljc2xsVjUwS2Jtc3BjZEllbDZ1NzNZRWFwa2xi?=
 =?utf-8?B?NUIyUDduNjY5VFVoZHY2K1M1YkVCOUtENkduYUlmbTFNaWpxVWIwRHhBeXBm?=
 =?utf-8?B?ajRsTFlSWDdwK0NwZUpLTjl4OXJyL3ZhT3RxcHNUQVd6Mll2WVZnczlmU3NZ?=
 =?utf-8?B?MGluWFJJa3RNV0t0K0lVN3ZEMFA0MkVEa0tRVDNIZ0M1UmtwOVJZcndHMm1T?=
 =?utf-8?B?TG4yYWNlK0lFdzZDTkJrdjRRSmhQN1pCZmVFeENPRWJ5b1JUZStNZGVDOE9D?=
 =?utf-8?B?US9KcHowZW50Rm9ZU3pZYi9Wa2pNTU1Pajh1RGNCU1k0NXc3R2Y2d0RYUkRE?=
 =?utf-8?B?OHBsVlNYNFZDWStNYlJWekgrY0ZkTkdaam5pc1NnNHYrUjhyYTJMRitjeVlK?=
 =?utf-8?B?bVBHYXJxRlo3bjVVc24rOHlRZHBFT1F6OVovN0JYMzQvY1RRTDFhR3F1ZmFG?=
 =?utf-8?B?czBnNm9CL1Z3RFZreXg3RGtDK0dzM096amdHVEVkaDlYVUVBZmNXakgzMHp6?=
 =?utf-8?B?ZDB1SG80WE1COXRuaDVhUDNXNnFCUUdpQW5BSTdKTklZdUJSYXV5WGNEdVc4?=
 =?utf-8?B?djdWMHF6TDk5dFZKdFlGdG5wTjhaSUx3WWxBZE9vVGNIMXZNL1kyVXNxck5k?=
 =?utf-8?B?TGpiRkhRWDkxaUU2Smo5TUhxa1JPWk42NFd0Q1NsaDFKc3dxakhnUkhEbzk3?=
 =?utf-8?B?ZURjWkk4cjhIdHNYZ0JBVEZyeHpWWHI5QjV2VjRHNmtZT2FmUjRacDIrUFpN?=
 =?utf-8?B?dkRwN1B3QlhFQjF4amc4R1RjZ05NTW5FeTV1T21jMFQ3dkpqTi9iOGRhbWN1?=
 =?utf-8?B?c0t5OFZYdlRwbGhLbW5mY3hRQjUzcXZWL2Nwa2o0dWtEdmpPUlFVWURPcktI?=
 =?utf-8?B?SUg4N0thcG1weG9QakNadWdEbitobWZOU1VGYmZlVFk1Z3NGWDN1NXR5VEwv?=
 =?utf-8?B?Y3cxMDJ3T1NNUS85VTArWUkvN2FWMFpKTGdLUHBrK1RKb3dMZERSNEE5VWxn?=
 =?utf-8?B?UmVQeHRRQVp4c2NQV2NDM282dFl0TEFNcVFvYnBHMUtYUFc3ZTliM2dtd2tq?=
 =?utf-8?B?am5VU0QrYk9qVUVvV1lybDJuUEJHV1Z5RThMWU83N2Z3VlBta0FTay9SSTA1?=
 =?utf-8?B?aWlKVWwwSXdnd1dUUG1ZeXN2dExpc1p6ekdIWFcxd1JOSVNZRkZGdm9CSUU4?=
 =?utf-8?B?cTB5VE9XNXRua1FzN05GL3pLTEtTNkxoak5KL1NnRXpVYVVWMUZ2aHNMV3Y5?=
 =?utf-8?B?SXhoK1owT2pSZ0tQUGt1QnJQN2x5UkVrTFNvUFoycU4yNXVWWVFUN1FzK3Yz?=
 =?utf-8?B?WHkzdnYwZEgwNGlsQXc5dHl2SkowRWhncEs0ZGwvTVV4bDZxRFVJU0QxRHFw?=
 =?utf-8?B?N01vUTBDQWtNcHJyVmtFVXZSZVJMUWxKQ080M0c2aXJwWXZ4TFN2WHV3YUk1?=
 =?utf-8?B?NSswTWxsdXhhWmU4alVlRjBSdCs4dnQzZUF6c2JZSmMvNmw4eVZiUHNTbnpP?=
 =?utf-8?B?VGVvdklBeXBZVTIvYnFkTkNMSk0wWURIb2tzNlRPd2N6MzZ0V293R1RodnVh?=
 =?utf-8?B?dGdWOCtCMWJNbEhZTG5HVjl4NFFVbjFLbFNkamlBRjN2cXZZOTYrbE0wMjRa?=
 =?utf-8?B?VGVZZTd4QTBOcHVtY2I5aHRUbVJlUHN0VjdZT1hnMExSRGZhU093bDNDc0ZT?=
 =?utf-8?B?bFVQUWtOT2dwUG9nTzQ5MFdVeGwzaHFNRkhJYzloMk9kT29ja0JhaTVaVUcz?=
 =?utf-8?B?d0JzTW03eEgxWWV1NHRoQjRPUnRFNU1rNGdaY2xTSzhDaEkvNXdIeHJxaFRy?=
 =?utf-8?B?d3Y4ak5LS2Y4NVh5SmU5UmxXZGlRcXp4dkJveFh2VEF2VkxuSkNTU2NVQ2dL?=
 =?utf-8?B?b0hyRTNDb1RMRUdsNHRJM0JrUC81dDN4MlkzZ2YwSWwzejRFMmtDRG5QaUZC?=
 =?utf-8?B?MTJrN2VsY1lRMXNrdDBuMVRLWCtVbTlLcHVGWjNsOGJwbXhUNytiZUpGYjB6?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b8cd2d2-756b-479b-dd99-08dd0432242b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 22:25:56.7306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RzTggE/vbIxl7LZlC6rUlKObgbTdHX5pmnNcmV9sYsCKKqHzVtVSeA+sUAbahVqsP+/ds32BMiZZCYHR2tbNKK3PqhrMXuRbkasOn4ZcSFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7730
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/24 10:28 AM, Tony Luck wrote:
> Computing memory bandwidth for all enabled events resulted in
> identical code blocks for total and local bandwidth in mbm_update().
> 
> Refactor with a helper function to eliminate code duplication.
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/monitor.c | 69 ++++++++++-----------------
>  1 file changed, 24 insertions(+), 45 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 3ef339e405c2..1b6cb3bbc008 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -829,62 +829,41 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
>  	resctrl_arch_update_one(r_mba, dom_mba, closid, CDP_NONE, new_msr_val);
>  }
>  
> -static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
> -		       u32 closid, u32 rmid)
> +static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *d,
> +				 u32 closid, u32 rmid, enum resctrl_event_id evtid)
>  {
>  	struct rmid_read rr = {0};
>  
>  	rr.r = r;
>  	rr.d = d;
> +	rr.evtid = evtid;
> +	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
> +	if (IS_ERR(rr.arch_mon_ctx)) {
> +		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
> +				    PTR_ERR(rr.arch_mon_ctx));
> +		return;
> +	}
> +
> +	__mon_event_count(closid, rmid, &rr);
> +
> +	if (is_mba_sc(NULL))
> +		mbm_bw_count(closid, rmid, &rr);
> +

As I am staring at this more there seems to be an existing issue here ... note how
__mon_event_count()'s return value is not checked before mbm_bw_count() is called.
This means that mbm_bw_count() may run with rr.val of 0 that results in wraparound
inside it resulting in some unexpected bandwidth numbers. Since a counter read can fail
with a "Unavailable"/"Error" from hardware it is not deterministic how frequently this
issue can be encountered.

Skipping mbm_bw_count() if rr.val is 0 is one option ... that would keep the bandwidth
measurement static at whatever was the last successful read and thus not cause dramatic
changes by the software controller ... setting bandwidth to 0 if rr.val is 0 is another
option to reflect that bandwidth data is unavailable, but then the software controller should
perhaps get signal to not make adjustments? I expect there are better options? What do
you think?

Reinette

