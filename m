Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794892001;
	b=wzB0nZ7GXAIfT35UySq7R7GOJSVERx8Cpbavxtns0dH0x8mpHuxOpT0+CfkU5WuUUcOw
	 NuT1aV8DfNm2VZupjUCTzfqZ6mYu6BYV9DeFxiyQd+Qz/vfzaBtqwS1j2f2mJBIYflKh6
	 XeKKWwCJb3bDYKct/tiM61OLocOIMoYPV0MxtseDrZMSSf92Hxl9/MBku2OOFDMMx8Lys
	 QQxG4pzX/aMdGpf/OQ/W2rjb0zyC6JynJYrHoCjkddj5QjIYeCp6Dk7IRUlAhUDJdOjQ9
	 cpg7mFXs+sUMnU889G8QQ3KVN+lu+eM3FjIY0yaBd/fttnMO1AcjKBF773aRjoZSH5A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892001;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=ObElO8DNjQnmRaWD067GD7CAl6CRVLmpDcVRB2YSPkc=;
	b=2E5XXkwgc8Z6L0N/t4ajaBSDa5RyQHXxYzn0Q/6JzHdO0Zx6pSeso6NrsXEULWJlaM6z
	 7ReXYBv0pPkCtDy9sCwecCBWWb07tRHKjujzX0GGC5ISbP5XlJWsKv8UHGRI/kHltkgJT
	 HCQmTt3MCuv6LXMjY4jJMztrO5ru9PwDav26CVxmLIwBEhzmR3TzXTph5AmKTS1oKiBm2
	 oNgzYsdGhU4XJsc0AT9hRspZLak4aKtaVLwePWII0JP1jOiXMvrDjrXRl4ljvkmXWXUTT
	 QRGnHwSJ7bhQzLdHPqxZ+udMn8lHIzXE3Nhmr/GARIN4LmmKDkWRbA1IuusQjYxMWIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ARuf0aaU;
	dkim=fail reason="signature verification failed" header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=SaoR7RW3;
	arc=fail smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F05606A332;
	Tue, 17 Nov 2026 05:06:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12F05606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ARuf0aaU;
	dkim=fail reason="signature verification failed" (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=SaoR7RW3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794892001; x=1826428001;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=pzqalaXwyWV6ItYK6JTQ5hnT6anApLFfM1D1P5iaZtg=;
  b=ARuf0aaUAG/fIAFMDm1Kv8Eoa29iCB5MHt2N2sIFX0KqCtn+ERwzbdCe
   RoOqi69cwwbKmEdcazJggnZxWVLtyOjprZnxb0WpOa+4VtHG76zdKVjxz
   6Y6fJb8ypkLeQgni8ophD2lp3fXMlll6+Ggvj2pt8rOnxswTsrvslTS4E
   lHWmCxuSzZAVr3qdeo3B8XbUqxHozZ73sLsNjFQ2OHBZNqakTLutEZOqC
   RUTlgAvg5Z1LOT5xkCLVfA5tT2a912P/4BmVV/QYnVF4YYpW9jhvgXRr+
   FWQFhpTyZKeW3Gltz0tnjwd9tWyuX02xJXZ8fEUQpLXTrld0yy1ZXhMgH
   g==;
X-CSE-ConnectionGUID: JTebGPnETP2uksYMpGxNDg==
X-CSE-MsgGUID: LjF4Jbi2SO6jkSBmThgggA==
X-IronPort-AV: E=McAfee;i="6800,10657,11968"; a="3527375"
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="3527375"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 21:06:39 -0800
X-CSE-ConnectionGUID: fWjdylISSn2eifipzz9XOQ==
X-CSE-MsgGUID: y26lvgTRSuSs6G65l/bFzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="9672862"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 21:06:33 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 16 Nov 2026 21:06:32 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Mon, 16 Nov 2026 21:06:32 -0800
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.0) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 16 Nov 2026 21:06:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OsKCJzNbVC+Kn5PETDJHJD1N2mvC545Vra2QRilKagOiv2DM5BIm/hn10HNMkUc2fxS7EVEI/M6rRGvJR3q3H9CNjVimQdA4ASkBa3bLL1hwZTgRwOHn1Gmzp3Fu6UOSh1JGjgEnwAXLOURKE/uokwf9mjoOuvriIIteT9+z/rZMN1ThKhxLFpqKu8jIZSe0cit3yC+wpWRo5PICr51z6u7IE1PGyXLx4mg6uFWjyFpi1fwSAZ8V8sFkLxEyFgxiKgvk07lqcupviEy4Uk7KIRJ5yoj2yQHrItz67sTbyu3paYtFUMLmYnD453y3sCtyh5o3UqDTBGQ61ioYMRd58A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaTNbu1cGVzn0+/BaFMvr7O3c+lXmwjtdu6/jppubvg=;
 b=bKloQKps1xABWEpB6HAVXjcLXMoRYmfgcRp6QXuu50R1LzdiymzlV8Uttv/j/FiOo3VWFoAmwZ30g5I7IOK+mroVcJLOkhlNNZlVRW59X+mt59OuZdzBCbFu/KcH+sRECD6qadZz/Anw7uIsyvqMK91Kf29CLNotXxVSkqfMKlrZlDOeKYHYMk2wTOvazwJpjmpe34EBrM8fJhd8Gsg7vNag3of5nwS0nQRYpxCGg9bz4JXNy7043wxLVWAB3jjnQ4Q4BlXF2jvjNX1lNy3zA+c0uJtT6pnNZ9uUD/+WJq07QporJW9Qxf33fyAzelMmc76ruAmubcddHQ5p6Mnqjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaTNbu1cGVzn0+/BaFMvr7O3c+lXmwjtdu6/jppubvg=;
 b=SaoR7RW3PucxHuHEqXJ92tFFglaRV2/8W9JqeQzxkXBQWLkWrVMfGpXX7A1Wr2jNuwfK7aVPmL/OUsVOWoAnl0QeoXNADBli+eVn69ac3c3sG+UbSVaqZRO3VwK0s82f0r+2+ljP60K8QhsZaTdTzxsqbTS+aIWehqnTBnE/uPU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 DM4PR11MB6019.namprd11.prod.outlook.com (2603:10b6:8:60::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.14; Tue, 17 Nov 2026 05:06:25 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%3]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 05:06:25 +0000
Date: Tue, 17 Nov 2026 12:55:18 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: kernel test robot <yi1.lai@intel.com>, <oe-lkp@lists.linux.dev>,
	<lkp@intel.com>, Tony Luck <tony.luck@intel.com>, Jinjie Ruan
	<ruanjinjie@huawei.com>, <linux-kernel@vger.kernel.org>,
	<ben.horgan@arm.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v3 2/5] x86,fs/resctrl: Remove unnecessary non-linear MBA
 configuration check
Message-ID: <avveNoKuHfomEHj0@chenyu-dev>
References: <202611171056.912725cf-lkp@intel.com>
 <8fb8b947-482a-48be-8618-32989a840dfa@intel.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8fb8b947-482a-48be-8618-32989a840dfa@intel.com>
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|DM4PR11MB6019:EE_
X-MS-Office365-Filtering-Correlation-Id: 27aa26bd-1fef-41e7-0b2d-08df44688796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|18002099003|6133799003|22082099003|261009223027099003|3023799007|11063799006|5023799004|4143699003|260925022911599003|260925021311599003|260925021911599003|56012099006|261028144727099003|261022105027099003|261021133027099003|261026121527099003|261022075727099003|261021130227099003|261026130827099003|261026140227099003|261022113327099003|261021135927099003|261021121427099003|261022115727099003|261021123027099003|261026135527099003|261102123227099003|10067099003;
X-Microsoft-Antispam-Message-Info: vT8HvwSv6mlbtz3yC8xe+iNv6lo+irKXuYdKyr+0fJZRTDtoTJQVfPDNa2Tk86mNjToTPsMI60oUiXhbRao4Vp+aj5B2J+sf2IUYGNH8DyEIlTiD8w73FJ3T9Gcsye7kZuM6d51Wk9Y7sZIp80P1Le4mJSWQtgPBrhArla71du4In107oC2G8fxgkpt/csge5FUvOVstWnIHf26Hy4642hcyOaK6GTguhAvg/pFkEHWaVp7XqZcxezQLlH7/rvzPgEYtdYDCT43n/9cxjRBqbDA0kGFN/cp3SalGyJVL3nvMR/TPfUd5vlL0hF9RiuoREeU5nxv106YifGWCg4sSNbs3p7BC+0oGvBTKzS75HhUwtGAIo4/3U3YZUgCVW/LfQXdEHhppCoP3pXOLWG15oCGuxLAhTju4LcLwDpVsfqvbShjUqyGSmARAbvtLLtVR0BvtgIlGKhHNqCfTI6NeR2HJ+CgMzgnE5FFfKGNIkf659ynG4hnjFzQDeebwC95hneKtUVWSlbdRagTxAo9mQX5OmE/XtsmQN+BQFh9cA864JOMBHSDBz/Q87DODX3jn/oA8fBZkaXzefPWbf96J+I/7e++1IGjctIjXr1F/9pNAtry2dLJ+WObQCz1ZoOK7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(18002099003)(6133799003)(22082099003)(261009223027099003)(3023799007)(11063799006)(5023799004)(4143699003)(260925022911599003)(260925021311599003)(260925021911599003)(56012099006)(261028144727099003)(261022105027099003)(261021133027099003)(261026121527099003)(261022075727099003)(261021130227099003)(261026130827099003)(261026140227099003)(261022113327099003)(261021135927099003)(261021121427099003)(261022115727099003)(261021123027099003)(261026135527099003)(261102123227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?HFtFXH707IIyFEdwpOEEETlU/79ex8KvpaUFpg1zktcjuuUw/iY4N5KLSE?=
 =?iso-8859-1?Q?rV5kF+S1VF6kq+Y8vyZJl4p4I0OEmMtZYC+gz2p9qcLt6eworDHxu0Mw1q?=
 =?iso-8859-1?Q?zq47OSWdTEcipyg8XYZUoJ0rz0hhPGUX0lJ+DkTs9HDvU2Hx8CRTPFNaFy?=
 =?iso-8859-1?Q?x0fTLssPYY25ZIAemaq7nWNSbYgR9vlZKBr5QsdiZVHr+A4e7hfvnKyJjK?=
 =?iso-8859-1?Q?aSFDpy8/ihaT3KGZNSFAEUtPhMIwv+/cuY/roPxYdp7CKoDuPn4OM1ghhU?=
 =?iso-8859-1?Q?2GcSBN0PHHXuWBC3ZLz+yq/rnFR2SzQosNHC2ZtTq/50hdvnw4W9r3WpU1?=
 =?iso-8859-1?Q?5bwpM3AjN9tORYrIoLshXSKCDbJVv8wIJ6gpN5qALmEckTn/OfzqJww5VJ?=
 =?iso-8859-1?Q?uh2bkkXtfx4aDHaI9Iia5yNiT34C3phE4uAhKlauMnLT4+u3lvfG13v6MX?=
 =?iso-8859-1?Q?qZ+DCjpz+KQHGrDBZw5Y9GO5AYUhRSAnSM3zAWCMqfaNUWXG9Uqi1sxCB7?=
 =?iso-8859-1?Q?0TNDyNNFrVhvbmrnfddLLCGlzvFsnR+5UMqzj13xLIsvKGLbLW+N/U5/SE?=
 =?iso-8859-1?Q?LhQJdb7IxIy/QOu2Rn+OhQP4lWfV0B+1GbHEQcm1WeU5IRUphJShsGFzr3?=
 =?iso-8859-1?Q?5uSqSB3gKGzDms1OlukQ/LmECd0Akw0n3o+2w0Nj4KfNjhOqxiA7gKuDK/?=
 =?iso-8859-1?Q?Ow7LUppJFfuCn725/F2V4gGgeHT73+joMXPxmbrMvoYPK5j72nOsfcHmbf?=
 =?iso-8859-1?Q?ln7e9U+0T52LJSdMGvSaCsDrP+CORLb7S/dCEWMSHgOw9XNAYvLBPmoxII?=
 =?iso-8859-1?Q?8Z9V1ynMbtZgPcH8oYQdQyDClmPWx2ZOYoctxkQLKD17+H1feU9kmajdBa?=
 =?iso-8859-1?Q?NEK+k1RIFXQ2ZB5JXmJFmLtRVJQeIECeh3Vu76AJzz5ndtgNaYN03VcYcz?=
 =?iso-8859-1?Q?W1VYBu62EoNU7YDTGZLaPsJmEnbE185UfhorZKCeFZ/LdvgpdYiyGOMHzq?=
 =?iso-8859-1?Q?A9epfOiU9g3CKbWlgDwvsqyc2TNJXFfS1aWm2+WkmYPpxCYH9NyUw3zPi5?=
 =?iso-8859-1?Q?xc9Txz+Jl5lVfvc24bIjoZJUKwtIBfSWB7BPrrRAJq6+oVvbgkEiAokNV6?=
 =?iso-8859-1?Q?XNVp0EuzYEaXJoN833XUydDsoEeVHgN6iZ1Uz5aP5RWv+H24lKSfp+8XZM?=
 =?iso-8859-1?Q?U1EDuXyJ9GCadoQx8Q6+KRVzQbFtb1NV593L9ar2QlknGqfaWMH9FmM6If?=
 =?iso-8859-1?Q?Lpy2PsRchockvOlsEsi9KlY4Aq17MLcVVDqmkSec+kbOBfXz1V1zeq0iMm?=
 =?iso-8859-1?Q?DIZTzS3SOQAHBGsyfAtiawdzgV2R4KWinR6Lu1/N1bLz5kddSH6zGyeAre?=
 =?iso-8859-1?Q?XEqwiRWHsQXgb3jwSTSn0VvhVMwN4n4NSUTjhKXLFeU0Cp69UfzyYh3c2X?=
 =?iso-8859-1?Q?Om9yJeMY4NcGwVCkL3eMXVn8zsVnfxqMrIKimKk8+thZJs4tApXRr5dRK1?=
 =?iso-8859-1?Q?DOT84fGcd2Z03OH5n681GrU5G51pn/xpLO8aAvaBPl8Vj1l0vT05XL6gsr?=
 =?iso-8859-1?Q?ng5WyD+vh27NdoKYqqTiyJ/F+PrpGF+5qbCgDt/W76LnDYmu7MA2H63r6d?=
 =?iso-8859-1?Q?cRjhg/JjNgOaRLfzpY7L6Za4tvDn6beA3ctK6tQLt/WdwA4ZjACa8L8mYU?=
 =?iso-8859-1?Q?+MpxCv6J5SwyGzy+LbwXDmgpN3tGOJ7ZYCHo/zK0QxiFPE7p2bOg+7chsg?=
 =?iso-8859-1?Q?XUNcT4BNAe+F4KdgaWWC6hJuAnzsmT4CwuxWdKgDtOavPTYUj3KIPkyFO3?=
 =?iso-8859-1?Q?pfDZCLcRYQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: o6gAGdB2G1sR24VzETLmmRHiOJr/kcDGWMDWCeBwFOOF6xzYjUTWyu/e8DprvVGTuqGHfoDbPExS1/8nlsR1sTaWho+nMaGJM9ep81j3nC8Wxsv5mgLEgHtpnANLblKwpR8WWa1odMtzBwGk5ovJ9t0rnGxnJjJMidNnIrZr5Cg/IobIdfogw8djI9pDimwFLB85m9fdq55NQ+mKvWfMqZ66oB82YECOUp0e2gWpQoM/FOcxs7BzH5HqHjtRR6JxK99P20F1hb6lz9Tz0DwxKWWY5HS94/SZH7+Wx6TfjZDlJUGZOmYs2we5t+nnHVLrYgNY+doueN6MWx+uprCtSA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 27aa26bd-1fef-41e7-0b2d-08df44688796
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 05:06:25.4420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tay3fydkvlOxptevvhhjda+t0Z1ftB0BXO0GE4SmLoFZiukEgL6mwfMoPyha05G/m+okMckPZUN4V12la3+mDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6019
X-OriginatorOrg: intel.com

On Mon, Nov 16, 2026 at 08:20:06PM -0800, Reinette Chatre wrote:
> Hi,
> 
> On 11/16/26 7:36 PM, kernel test robot wrote:
> > 
> > Hello,
> > 
> > kernel test robot noticed a 4.4% regression of stress-ng.sockfd.ops_per_sec on:
> > 
> > commit: 12a0f554b3d62eb1270d6d60e9c6ab2c07dbbe35 ("[PATCH v3 2/5] x86,fs/resctrl: Remove unnecessary non-linear MBA configuration check")
> > url: https://github.com/intel-lab-lkp/linux/commits/Reinette-Chatre/x86-fs-resctrl-Remove-unused-non-linear-bandwidth-delay-mapping/20261104-161329
> > patch link: https://lore.kernel.org/all/7e1aeee81a38a33ca889db68e4c645f935e4e6cd.1793834224.git.reinette.chatre@intel.com/
> > patch subject: [PATCH v3 2/5] x86,fs/resctrl: Remove unnecessary non-linear MBA configuration check
> > 
> > testcase: stress-ng
> > config: x86_64-rhel-9.4
> > compiler: gcc-14
> > test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480CTDX (Sapphire Rapids) with 256G memory
> > parameters:
> > 
> > 	nr_threads: 100%
> > 	testtime: 60s
> > 	test: sockfd
> > 	cpufreq_governor: performance
> > 
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <yi1.lai@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202611171056.912725cf-lkp@intel.com
> > 
> > 
> > Details are as below:
> > -------------------------------------------------------------------------------------------------->
> > 
> > 
> > The kernel config and materials to reproduce are available at:
> > https://download.01.org/0day-ci/archive/20261117/202611171056.912725cf-lkp@intel.com
> > 
> > =========================================================================================
> > compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
> >   gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-spr-r02/sockfd/stress-ng/60s
> > 
> > commit: 
> >   0d4f0ec1db ("x86,fs/resctrl: Remove unused non-linear bandwidth delay mapping")
> >   12a0f554b3 ("[PATCH v3 2/5] x86,fs/resctrl: Remove unnecessary non-linear MBA configuration check")
> > 
> > 0d4f0ec1dbca25be 12a0f554b3d62eb1270d6d60e9c
> > ---------------- --------------------------- 
> >          %stddev     %change         %stddev
> >              \          |                \  
> >   56484401            -4.4%   54013430        stress-ng.sockfd.ops
> >     940555            -4.4%     899375        stress-ng.sockfd.ops_per_sec
> >    3901263            -1.5%    3841842        stress-ng.time.involuntary_context_switches
> >    2386355 ±  6%     -10.4%    2138169 ±  5%  stress-ng.time.voluntary_context_switches
> > 
> I am unable to see the connection between this test and the patch identified.
> 
> The patch identified is a resctrl change and looking at the reproducer script
> resctrl was not mounted during the test. The kernel config does have 
> CONFIG_X86_CPU_RESCTRL=y so resctrl will do its enumeration and then just do
> nothing until resctrl is mounted, which never happens.
> 
> The patch does remove a struct member so this does change the resctrl memory
> layout. The structure changed, resctrl_membw, can be found in rdt_resources_all[]
> that is a writable global with static storage. I expect it to be located in
> .data. Could this possibly impact the test? 
>

I agree. I think this is a data layout change, not a real regression in the code.
rdt_resources_all[] is in .data, and arch/x86 is linked before net/, So all the .data
variables after the shrink of struct resctrl_membw moves ahead, then variables in the
network component share a cache line with different neighbors. I don't think resctrl
should change anything for this, perf c2c on sockfd should show which hot global
variable is sharing a cache line, and that variable should be cache aligned.

thanks,
Chenyu
