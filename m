Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D7F1531C4
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 22:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731449932; cv=fail; b=Akp3v49ITHcWn5Qa0pK88jlR9ytVGTO6gdeeEVdTa32pPUPYx46PRfCX4wXIle+cnwHCU7bWgJZnIaRMtxDwSw4LswnCN6LytMSJZlbm8lScSTfm8u0CBIyW1jtfSHGHIRwhe9QkrE6LNdouyj2C3v1obVzHcOgGjaGuZlDZB6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731449932; c=relaxed/simple;
	bh=a/xFRGkq12bzLRqM7qtWUYQnZX5ekJEPXs8tedzcneU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AZ2W9ZrmvFJtNjl8Gv47b6iKV9A+38Pm77QIgqEVGWqIMN8BCoAn5QfQzAaqJzgipdOcWlIOaE+Vr/RUZnmACpyOXmAUHx4bjTkkILsyYpdIajpUqkv4C1juUDPklraBqA0spQHau5WM5VGoFXvYS9KKB0iAzht02Eq5LgGZx8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iXclKBth; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iXclKBth"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731449931; x=1762985931;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a/xFRGkq12bzLRqM7qtWUYQnZX5ekJEPXs8tedzcneU=;
  b=iXclKBthFA3vuiNcErfovaUgu6EUjrNY3WicCNfnbvFi0rgLVZt2TD+w
   bwJkRn2oNmdrzf4aVbnOzTipejTERUsO8gTorLEsaaTdqQub2boXBTnHp
   9PdeVBVngl/a1aMm46fISeICvPtotIwcNM/RZ1d+0wlTlJqLoijmftTzq
   tfoTBLsmEe18DLz2zaFmIQmtvbk8MszAlxD8t1Z17GMrC+1uzssoSZXeD
   uhb84aiIQfhuVAS7+ix0xQ5MNsAIq3+oHZlcKCA4icH+7rWyQb7cmBYsc
   snDQlYJcs0JE2TNgs7mEOXWg0iYXmpAz/YMWztBBjPcfuV4zP/IpGzSyf
   Q==;
X-CSE-ConnectionGUID: jJDTRWdeQ4yxO01LwTmO/w==
X-CSE-MsgGUID: VrlkLBxFSlSNVhpZlGh3lw==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="30717093"
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="30717093"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 14:18:50 -0800
X-CSE-ConnectionGUID: uD5EiTOURGWOfa3L5q14RA==
X-CSE-MsgGUID: aqMZR0FMTZK+THOLYsv9Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="87414528"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 14:18:50 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 14:18:49 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 14:18:49 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 14:18:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yCWEkWRR+mk8Oc124aihGHDDzRZn/zUcFICbtKP+kT2XKWhZ+VSLMYYdpEwUnJXDX6L0XkbUdsayg9d+jYhDB/crZ+nZDarRMvqefQ/zOUZVadCvcU4EB7W47AWElouWI7wXHJN4ZuWHJBoPPWbKRWzyA/Ym09C6C1p5Jxv3VpcmLP/nMVPR0brcZEzcyTZIncRw90GOS+IopBZFKWuf8+3M8SBJh7whOEEPxvqTkRZ0QYn1m/0yzOqgCQ4UtPOhWzf5U1Uxn6+1HsXftCumysboXY9e1kNj8SCtThdYubiEctY+GfbqV1GrFox+jzPh/sogJeJQCkQ/3kAis+egiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Y3xfeYIip3lLKWtXLidf8KJuhbhl9IujbADO0itz40=;
 b=dcP/g9k89OCSGHfSv1yofx+pi9EYYUebGGzSUs7XffrURz7zWr/kI07xzcecOPjLnHGRCKA+f50eQ+SkUaQDuHDKWYkbNGSZNV90SAO+Qe8hVGXbAFO6TfU252MP+nJsgzuH+pjkO24O8DPd5JkkVNXJ+4qbnM45fM5e/UDo6ffn9YWXMNlmsFeqHJA73C5khagyQsWlIxN7ettjb8fSLi5PdrZ4qsXRi0LP9l1cHdK9QBhwb5iAHUhAfT+Xvz5H8FRCTKLkCk4gnph5Knc/e1R3KQcDlvgocM3nff4pLDC2jKY9oZi2OYYDJiWxnKU9qq4so818PYrD1lSHYl23+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB5878.namprd11.prod.outlook.com (2603:10b6:510:14c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 22:18:46 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 22:18:46 +0000
Message-ID: <686d0769-a0f2-4808-b038-9c9735f1ddd5@intel.com>
Date: Tue, 12 Nov 2024 14:18:43 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 6/7] x86/resctrl: Add write option to "mba_MBps_event"
 file
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, <x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-7-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20241029172832.93963-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB5878:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e9311db-e5ab-480c-1510-08dd0367f988
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZEVIYkFoRlo4THFnMEltdG41U1pjVURFdnhoelZRdDdDZllYZHlad0VEOTdC?=
 =?utf-8?B?UVh3VWIvSmJweU9GdEVmT1ZmMFh6WXZEVmtyUDNuNWdJaldMZ2dvTnFZMVQ1?=
 =?utf-8?B?aGhncDhoZk1zNjl5TENFblIrUG0wR2w3WUdldkNQSS9QT0ZTOUU1UTRuSzlq?=
 =?utf-8?B?OHlINTljeWd6eTh3UDJoV216V21UZXppV293VDBnTFljZXAra0NBaE5pSTNn?=
 =?utf-8?B?VlpJWXdnU3J1MWg0RXF1aHF5OWozZ2NCMnJPL1FnelowbkpNMjNEN0EyZ2ZX?=
 =?utf-8?B?RmdQRkxvUm14RVM5d0hMWmh1VFFoMDJVK0NVZVRwRTlPQTlOWGhMaUxpK3ow?=
 =?utf-8?B?cHBKSjFwdjE0Y1RtV3V3d1FOZUJOYUxLV0dEUTFuajhXbHhqdUduaHY1U2hY?=
 =?utf-8?B?YStGelhhRXpVazlSL0lwZnZKS29Kd211enQ0bEFqZ2d3VFlmbk5Wd29wSGI3?=
 =?utf-8?B?QzIvaXp0WElCM1c0WWFDNEZLTGMzYVJHQjhJZkxuTENRLzNVaE83UmppN1BD?=
 =?utf-8?B?eWIxdmVVMWhBQWZpdW1YWFBYTEdnYkxXcnJwSFl3NUpPZmsvMmcrYXhQVXU1?=
 =?utf-8?B?TkQ5R3FFaEZzMnlkSHBQOE9qajAvM2N4YkFZd1B4TEw1bEVqN200OVhCM0o4?=
 =?utf-8?B?bFhnQ3NzOXpjaHhWbnowT0tJc2RjV3FiVmRwQlB2QlJ1Uk4rYVkzT2ZNNi9B?=
 =?utf-8?B?RS9MMlZBU1RLL3hWNlcwWG5xYWljTlpqQmJFYzVMTHhXSkxBQkRnemIvdTdU?=
 =?utf-8?B?VFg4STRiTHFGUVR1MHIvZHYxeHdZRXdhakJnVVE3dmlHVnpOWlN1d1h5ZXZq?=
 =?utf-8?B?ZmgrN1B1SHlrU3Brby9HUk1XNkNDNjhDR1MzZzlZWkZlSzZUYWliVmtENGpE?=
 =?utf-8?B?MlQxVDl5Y1dSMEJkSFQxb1UwajhKZ3pSVDBSakpGZ0pmckNKMWNIVWh6dmFL?=
 =?utf-8?B?UTkydmNhYW9zdDdDTGd5Q0oxTEp1cXowOTBzQktra2ZsaTJ6d1BoTmRXRDN3?=
 =?utf-8?B?VnFXcGRoUzYxR1ViVFRzYUNLTTVJazA2WkFkRWd1TXRlVzlIZ3B6Q2ZNRUkv?=
 =?utf-8?B?czlQMVFlbkdBNzA1cW5mcXBuWG9qdFNFOHNlQVpoeFlWamIrL3VmeDlDdGgy?=
 =?utf-8?B?em9nSVN5UkpFc3ByTDFqazJBOVU2Ujk2YU5UYzg4bkltREc1bisyanhYYktV?=
 =?utf-8?B?UXZRRHQrYm5hTjhUQlpsTlRZL0hrWUN3OXN5dnB3cHM5Y2VESnNVTGkzTlZl?=
 =?utf-8?B?Vkd6UVV6c0ZsQkQrUmMxMzhENk01T0VWbmpqZmc3cjBrVmlVaTZyeGNnWStV?=
 =?utf-8?B?Q2dnSEY3ODFqeUx6bVpOWmYyelJTUG1vS2wxNW55bE5Ea1pxb0pnbUxhOW44?=
 =?utf-8?B?ci9GV1FoREpsUUh5aTVBekM5SG0xYkVJS2swZU1MZmdJd2ZObU55VmdVajU5?=
 =?utf-8?B?Z2VrODhNY01VRVRZOVhuczV2U1h5eVgxVEpQeFhqTDZ2ajJaMW1kNU9vWTNR?=
 =?utf-8?B?dlZHWDBZYVNVRkRRZG80dm1GblNVcjNWWVBSU0VRazc0dExZY0Y2U0VFOVNG?=
 =?utf-8?B?RDlJSHhCMGM3N1B2aTlqc2xub3lOd3hrcGtUbmljeEN0a3Q1ckY0WmNoU0Nl?=
 =?utf-8?B?RmtTWVNYMytzYTV4Y2NqUzN6MFVUWWUvLzUxVFpyL3d6VVBoY0hrczFQODFo?=
 =?utf-8?B?UEJuUWhHNHV1QktDdW84Tml6aGtHbTFBa3NWVGN1TmU4bUtqakptVWhpUXIz?=
 =?utf-8?Q?1JH85zOhPj6AArRI6TzZ6c3q94evPzHgtPpsI7Q?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3dMR2lqQS9ia0gzODZTdHFEeGlDVkhzQmRlVDhPOUJOVjdtYUdXY1R2RWs3?=
 =?utf-8?B?amMrMG1ta2VCV3JWMHlCdVpzWFdpa1kzcEJNeGFURGdmRkxuSW9DK2p2cS85?=
 =?utf-8?B?V3pRTXZvM21wUUl1YTEyWXFIM045emtJSmJVV0UwdkJQSC9iNjNUQXlGODJh?=
 =?utf-8?B?NUowYnBQcmJwYklFVTl6dXNaRkptRE9xZFg5T2FWWEpoRkhaeUlxRWxoU2Rt?=
 =?utf-8?B?K2JPTWxobEVLQythOFB3NHR1QWJMRloxbTRKK0JwMktuNnhHcFNTWE9paGJ0?=
 =?utf-8?B?dTd4dHpSZ3lSa1FQZVBOYWhjRWNLMzZXeUV3cU9OcTJjWFYvSVI4TGY4Z2xh?=
 =?utf-8?B?SFlSeWk1VExsV3gwWE1TWHJ6bHpSWTd1eEgxUW40ZlVKR1pFbTZLWEU1YUlW?=
 =?utf-8?B?cHF1VkdPVzhVOUU0U1dWSS9GUVlQRHk5YnNKTmV1d2NaQXVseVZZWVVjMldE?=
 =?utf-8?B?M3FPT0h5VzBZOTNUdWp0MFEyTzZ2T01sYUFLSlRYcTFIZi95V2Y5R1FiRkFI?=
 =?utf-8?B?VFYzYjNZcktLRDRLVUk4NncxbUxDb2RYRHZxS21EYm5vbituQ0JiMnZzcTNh?=
 =?utf-8?B?dEllMXNkMHJpdE9CYzZIV1R0WnNOSmx5cWg5dFZXanBnYjVEUnJ0Vm1RdGJs?=
 =?utf-8?B?Nk05SHBGM1V6RmMvbEFpeVE3VE5hSnUxMDRsdTJXTWVYSHIydklyRGZQVlJK?=
 =?utf-8?B?NE0vR2d2T05maTdYVEd0b0svUUpRUGt3TlNadEYrVmI5ZTVVQ01pUFhNSlZn?=
 =?utf-8?B?NmZTdFd5UHJHREwxTGUvN2s4UDE4UStsSHlrMGF4b3UxRVI4YityT0xCSlhR?=
 =?utf-8?B?Q3h2aTlrRWFmRXczRkFWUVlKbmFFVll6Y0FGV1RlbDRFaDBFRTZqV1hvOXpk?=
 =?utf-8?B?WDRWbnZTQjM4MFRrSlN1VFJlckU5b1o0WDBQb0dSYzU2UFQwdzF1ci9sWkI3?=
 =?utf-8?B?Zjcxa3FrdnJzUnM2R2RnVXdoQjRoZVRoL0ZNL2EvbkgzZC90cjNDbVV5enp5?=
 =?utf-8?B?Y2Q5L3IyNERRdExaY0UxSGZndjRJekZha3JjWEhqOEJZY3FvanZHY1FDWVJQ?=
 =?utf-8?B?N1dsa2lmbksyNjQ1WFlXUUpqdkpvOFdMbUROVm1WM3FDVnNUWFZpV0pkWlUy?=
 =?utf-8?B?WGdxVGx5UEkwWXJyRmJ2Um82aldDKzhFL3VwQ2FxSXNmRkpUZ255UElJVGZX?=
 =?utf-8?B?cmNkRWtpaE1YZnBSUGdDS2pDU252SnBNb3B3L01HczBCaHppZDhMeDlxbThF?=
 =?utf-8?B?SUtQTHp6TnBLSmgzdm02Y3FhTm9xbDYrWko1QzJISGRFeFFoRjVqcGFMNXdy?=
 =?utf-8?B?SmNLWUNxR0ZYMjBMTDMrVzdnWkZlM2gzM1l6QmgxVEVBTGJJSE1RUkIrUkZI?=
 =?utf-8?B?QUJEbWdyb3VzanlVSG1TM1hQd2VPelFrSTNaZXJoUm8yZGVOSGkwYm5VdjND?=
 =?utf-8?B?M0RITEFTdzNpalZoTVd1QWgvSDFvbG9oaWhtL092RHc2dTBTdXZUYmExRkMy?=
 =?utf-8?B?U1NIcEtxRmNSTDh2UkNIODlmajZ5RktKdHdMQkZjckQxZkZ5RUNlNmwxUVow?=
 =?utf-8?B?QXp2aUgzQm5BcHpSc2Y0K1pSeUhnUjNSeisrUW1PSnlGSHJHWFgwL1E4QStk?=
 =?utf-8?B?ZlNvMmtFM3JkOWlad2hmT1JwMVlVbFJMWjdqbVpMcjZnaSsxQ0YwZTZlTXNw?=
 =?utf-8?B?K1FhTW5PTzZPbms4Z3VTVUVENXIyMzdkd2xwb09TdmVQbmVyZHZkdDgxMGk0?=
 =?utf-8?B?alpESGFxVXBoOC9kL2RreHY2QnVwb2tmZnQ0ZmRQZ0plbm5lQkxGYXRnaEwy?=
 =?utf-8?B?aDVsUHJUMWRZU25TZ2dhNHo5S0hpcndPdWRweVBmQVFPTmJ1TS9jSUpqY2hO?=
 =?utf-8?B?U2RSSzdRL0d2UGlMTUFFY1dzVXlxRHQzNzJISkZpbXM4MkVWeGVmcTgxcVY0?=
 =?utf-8?B?RGJ3QjUvSzZQOGhOcW1WNThzMStadDUzRmN6K1BPN1BOY3lBbS9EOTFrc2R6?=
 =?utf-8?B?eThUSG5tb0M1bWh6YitpUXVLbkdiSCtkbm9FRXExUitUUHpGaEVQZUo3Kzlj?=
 =?utf-8?B?SGhsbzBrOEtaWHZ3Z3AyNGZoL21heEcvbUd4V2xDaGJSUlAwaXVLZWZLN0xI?=
 =?utf-8?B?aFp1YXBwL2hhQmhhUjFnZW1FRkZYNHR1Y0N3aG1ZTXJWK0Z0ZzN6dTdIajNO?=
 =?utf-8?B?V1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e9311db-e5ab-480c-1510-08dd0367f988
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 22:18:46.0530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJHdjVvxGtJ5d8KB1fKH7QZe1QbjifP7QTlarSSu4brWyiOcCJYhsNhUg47Xkq0pqRgOtdKDJEXSY2fQTseiAMgV88QN7GcsLc8sQrVaejE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5878
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/24 10:28 AM, Tony Luck wrote:
> A user can choose any of the memory bandwidth monitoring events
> listed in /sys/fs/resctrl/info/L3_mon/mon_features independently
> for each ctrl_mon group by writing to the "mba_MBps_event" file.

Please review the changelog based on tip requirements. Folks used to
tip customs may expect changelog to start with the context, while the
above reads like it describes current context it describes what this patch
makes possible without ever getting to description of the change itself.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h    |  2 +
>  arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 46 +++++++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  1 +
>  3 files changed, 49 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 5f3438ca9e2b..35483c6615b6 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -609,6 +609,8 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
>  				char *buf, size_t nbytes, loff_t off);
>  int rdtgroup_schemata_show(struct kernfs_open_file *of,
>  			   struct seq_file *s, void *v);
> +ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
> +				      char *buf, size_t nbytes, loff_t off);
>  int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
>  				 struct seq_file *s, void *v);
>  bool rdtgroup_cbm_overlaps(struct resctrl_schema *s, struct rdt_ctrl_domain *d,
> diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> index b9ba419e5c88..fc5585dc688f 100644
> --- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> +++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> @@ -518,6 +518,52 @@ static int smp_mon_event_count(void *arg)
>  	return 0;
>  }
>  
> +ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
> +				      char *buf, size_t nbytes, loff_t off)
> +{
> +	struct rdtgroup *rdtgrp;
> +	int ret = 0;
> +
> +	/* Valid input requires a trailing newline */
> +	if (nbytes == 0 || buf[nbytes - 1] != '\n')
> +		return -EINVAL;
> +	buf[nbytes - 1] = '\0';
> +
> +	rdtgrp = rdtgroup_kn_lock_live(of->kn);
> +	if (!rdtgrp) {
> +		rdtgroup_kn_unlock(of->kn);
> +		return -ENOENT;
> +	}
> +	rdt_last_cmd_clear();
> +
> +	if (!strcmp(buf, "mbm_local_bytes")) {
> +		if (is_mbm_local_enabled())
> +			rdtgrp->mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
> +		else
> +			ret = -ENXIO;
> +	} else if (!strcmp(buf, "mbm_total_bytes")) {
> +		if (is_mbm_total_enabled())
> +			rdtgrp->mba_mbps_event = QOS_L3_MBM_TOTAL_EVENT_ID;
> +		else
> +			ret = -ENXIO;
> +	} else {
> +		ret = -EINVAL;
> +	}
> +
> +	switch (ret) {
> +	case -ENXIO:
> +		rdt_last_cmd_printf("Unsupported event id '%s'\n", buf);
> +		break;
> +	case -EINVAL:
> +		rdt_last_cmd_printf("Unknown event id '%s'\n", buf);
> +		break;
> +	}

nit: What is the benefit of distinguishing between these cases in messaging to
user space? I am thinking of the scenario where user may write "llc_occupancy",
this will print "Unknown event id", which is technically not correct since it is
"known", it is just not "supported". Perhaps the default error message can just
always be "Unsupported"?

> +
> +	rdtgroup_kn_unlock(of->kn);
> +
> +	return ret ?: nbytes;
> +}
> +
>  int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
>  				 struct seq_file *s, void *v)
>  {
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index 3ba81963e981..6fa501ef187f 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -1947,6 +1947,7 @@ static struct rftype res_common_files[] = {
>  		.name		= "mba_MBps_event",
>  		.mode		= 0644,

Writable bits can be set in this commit.

>  		.kf_ops		= &rdtgroup_kf_single_ops,
> +		.write		= rdtgroup_mba_mbps_event_write,
>  		.seq_show	= rdtgroup_mba_mbps_event_show,
>  	},
>  	{


Reinette
