Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DBB2D5C8E
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 18:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756923586; cv=fail; b=OWdk0DU1QAw/miTpPTqu+Tju6QaEGyLvfw9I8bKpFFJDJV+bnfJrnq5pc7RH2zGOKQtScAQeqFpC3F8mlZyjJ22xpq3sMgOmoydMjU0rqD8uUg4BB9Q5T1Rt7qz3NOkj/MwMbTwDjXBLhr8irEZyTV62gxlomCqlHXxkXwKSxPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756923586; c=relaxed/simple;
	bh=G8N+MqlHNDW73Mb/9M5bpRHsv/sSd/SPnmLZeAX3UzQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ooSN77GmzcBlqKB3Hs8jOt/yEAnvVWbG1mpKime0Q91TgPgcE0WTuQv4KCohpQAKQpLYACaXker3Y9zcwIZxLG4J+lasYNuUh0zHdEJKZ8Uy+4IEvW4/OwuT25bPFiI744NlCOjX1B2+5GLcwEjEa50oOc0ldiS0AiLZhvynLRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ktnYJkvf; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ktnYJkvf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756923584; x=1788459584;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=G8N+MqlHNDW73Mb/9M5bpRHsv/sSd/SPnmLZeAX3UzQ=;
  b=ktnYJkvf5mIRnvuQGzT3gderZQOxDIOT1bL/Jl1+rGBDZddG/cPOAQkb
   Vk7weKdPDlDNOApJQRdTfmkg6suFuOiuRQ0/iCjLv6MOEQuojD/+Kks0L
   qglUIqPXShAD3hzSflIoIA+G05ZC6larEEKllWIHkPTh3aVYMVo//Z9L7
   8vXebbJnxSMf3W4jR9sCrZOdzJyknUm0GXd9U0MSm0xnJEES9AhnDQFbp
   DjYRxZ3FIybNjbqD6lBLDF61tC060DHgZj5s6OcfzmWgEBGynGWd7SrQo
   +yme1glIDPCPuF4ZXZp8bJn6SCS/33Alh6+kxDb5ULWQ9tWkjpnuoaukA
   Q==;
X-CSE-ConnectionGUID: LMgDJ4ktSky7/jsMoQcsIQ==
X-CSE-MsgGUID: mRrPaHQqS/WVFZSY5Jpkxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="58281125"
X-IronPort-AV: E=Sophos;i="6.18,236,1751266800"; 
   d="scan'208";a="58281125"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 11:19:44 -0700
X-CSE-ConnectionGUID: zs2VqrRDQ8SYYwWx4sYRow==
X-CSE-MsgGUID: OV79WoSnSpCN6sfExMVHTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,236,1751266800"; 
   d="scan'208";a="171222839"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 11:19:43 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 11:19:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 3 Sep 2025 11:19:42 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.71) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 11:19:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yjo5YhPkBvIJ2kPvtA1YyGNANvmjUlOhQfCzeSn5H2Y7AMosOuZbi7d6Yjakue6ecLCdF9yXwn4s58GxeodoEFM3tq4tw2f/nHPdctWHGPpfYES0RzXWpK3+Xuw4dO6P9cJDTkprWqW8abdmyQ4hxVuTcpF2mar77qvszGC5gc84p1fZsBEcfOjYfdZ82oBbDHkxROFQh0E09Awz43cJKlXMPVG0MMw6+c6Ye15JmVRqW+xLqDZhcWQXuUQuXxSG9lzDqQxqexbSYMihGgcUTa40/ZfszpqZ9xd+j9SIkuvcCH3NHliZ6BaJqiqdtHnIdJXDdJqHEC8W3u50mJWjaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ni9ve9WqWX1i5jsFIyzcIWBsTGBnDbz8Qz4UKRXB+Q=;
 b=OixNQn6RS46xk9uen8hwtqAPrbYHXRlTmbf3Ag/sRxxgT7wk28nM/nQ+XG4dm6/iOdDVaKBNlAySXBSpsGB41d7MsYQB2GFzGbyZwu0MdxJmXvlYBAPkB6yXh2onFtqD712P6yKASvfPQucTNY+sFEbzIrMnIig2SaFgc25JPcsGLixbn3ZKSfpQlgr06lo90cne8K74EgZO9qfZ4iuh0m2/XUqZmm6XYQRlpJMYPMRbkXmrETLSlJs3kvyfxEmwVYswI+deD63W0bXKBGTgYwgA6l31AVn+4Ctta+5IYriorYdc9MC+Fcz6oew8weIGK3lax1W48DE3+vXhZCo8Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB7450.namprd11.prod.outlook.com (2603:10b6:510:27e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 18:19:39 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9094.015; Wed, 3 Sep 2025
 18:19:39 +0000
Date: Wed, 3 Sep 2025 11:19:38 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 20/31] x86/resctrl: Find and enable usable telemetry
 events
Message-ID: <aLiGuhOM4ciPLT8K@agluck-desk3>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-21-tony.luck@intel.com>
 <9ac43e78-8955-db5d-61be-e08008e41f0d@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ac43e78-8955-db5d-61be-e08008e41f0d@linux.intel.com>
X-ClientProxiedBy: SJ0PR03CA0364.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::9) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH7PR11MB7450:EE_
X-MS-Office365-Filtering-Correlation-Id: 323b7ed1-2811-4516-890f-08ddeb167230
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?kte/PF8pFCz+AA3wInv64Y0mEJOKSeBN3QdzhfHFjscL/3Si7RvrsWQ+/9?=
 =?iso-8859-1?Q?g6Gxphbw1qyfUVlWNOLPy78GVu7gSBVPMARTnwwyKRK0oz6MiYCXJq90Ws?=
 =?iso-8859-1?Q?75crMs7ZTiZpPLHFhJIr33/K7PtQslBPp1EMzSQb2yPnSsWyGetQ53bLS9?=
 =?iso-8859-1?Q?STowGgT0pH/2CRsbM6r6ljMaAFq21Su5QccoeiBX0/FyxHVYdLOaFPZDXy?=
 =?iso-8859-1?Q?WHd/nYVrPKZMNHQmxgsuCdIXk/I67eVbr7OBKjEFdvtMW33OX0LTtFGpc2?=
 =?iso-8859-1?Q?1jEQbb81nXOM6s3XE+CxApXisrKGj48xM5vrNaZzH2EcebLl0CRiwJggOo?=
 =?iso-8859-1?Q?HcWFIk3tEJCeXoOKRnLJfwGclEzETn+dHQl/Zva4OD+/RlNSHTLBKHpFbg?=
 =?iso-8859-1?Q?BY7wC5/4PJP1ZUB9soC3Ay5Rvwjtb21CLoCsULVX4WzHmiM8ucGDD1zcwH?=
 =?iso-8859-1?Q?2TvDy0XBcBXxzGHHuAA2EytJouYiL5fQ+hs7ZSVkuTKqNlt9fkbmUiEa13?=
 =?iso-8859-1?Q?vDPZpx81f1Opa/0VqSz6syI8H0JSisDLdb7LCNVvr8VrEetgNsGV/Xh0/s?=
 =?iso-8859-1?Q?UiTDpx9e+Evp6i+jyHnSrU3ctdCxBh+Y8DDzDVWcLBRYootGoGrbAPz7zR?=
 =?iso-8859-1?Q?TYd1b5AitvUTn48x9kifZSBCA3yMJzd622rEQ+bIwox+Ra+wPhN3FVy8rd?=
 =?iso-8859-1?Q?++y3Nzgn3T6fq6WCIFwxVX+pqh1bds1NBz4neEuTqPHZx0GBtrp5LlMCvD?=
 =?iso-8859-1?Q?TQNZLlMoB1N3I28NJBTEGNttr9WOayjMeevsa0VoGAy+27MsIDw4rsNTPj?=
 =?iso-8859-1?Q?xPEZveWutuOCWKSU8LCxDdHHMGGIyG0Q4b6AdAy9L27kFsgPXzKN5k8I7Z?=
 =?iso-8859-1?Q?YRAqhJLOr3UWJWhYs6TFYe9gn3cbxj6xqXkjTnMwwQu+8UGFPerTVACUaY?=
 =?iso-8859-1?Q?QhW/pTgZ0oIO93H9iYHW48PtsttC9+/nuJ3lFSVxie1sQE5giwW162UFut?=
 =?iso-8859-1?Q?US8IP+LGA7cF7r/EMmZMVxwYf8fZ+eQjNRb5WYOWicvEcbqZA4H9pwUntX?=
 =?iso-8859-1?Q?kQ/IjYooaDMk+P4144UxMTRnmAa3bwb16v3m9gaxNsZ0+2en625vU4QbMJ?=
 =?iso-8859-1?Q?cOMw5bKRIknD4EwD4YlzHY6oBEYI95KUQ2tocY1G+wPD5PsyN+g2nUuxaj?=
 =?iso-8859-1?Q?4f7aQc7LfAyQhfocr3G+OfQ9O36MU0OacxMyaXbUfw9NUATTYkDNMBwvQo?=
 =?iso-8859-1?Q?BpiW9R9ifZ6k1/sZ3p8w+Lw3Z8Y1Ugu3N9EPpmLjtmAbiMqm7juQ/MF5XA?=
 =?iso-8859-1?Q?4tNsLw4qLa4DeTV+Ij0NU+z4bfGxEclzz675MOfS7tqrCiz46+3Vm3tpAr?=
 =?iso-8859-1?Q?bH1QXuJ0kQKErbYvQg/8+MhU4MgP6905otWtlXu3Z2oqOZkvHULaFEcHzl?=
 =?iso-8859-1?Q?6HfJ1FbPIdL8oOobrxhwFX23g5y0sVeHZn/q0ofygOuxL/+bTILJlOSwrW?=
 =?iso-8859-1?Q?k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?hHMErSGgGlrSe/1ylS8t+f6t+5Na//zq2aiObxTA1h8dntuv6Fai2fHq6A?=
 =?iso-8859-1?Q?301wXgQXdO0jXFXi8wRFPaaWDP6VFmyrCzCL8j9z4oA8TfOJflTgcJKNXW?=
 =?iso-8859-1?Q?O/bJy+f9Gqd6eiPbuT+aSctEbCqT3PDLNgzqTsSiAbtXOFTdWIcttknQgy?=
 =?iso-8859-1?Q?w+LEZ3eDwfyQ3BZ+52zUYdkP76gL04sW2LiTqwF6hvDUR8N67ptSQFOyML?=
 =?iso-8859-1?Q?Cytuc3Vjf0s/1voBWkfTJeDg5hiY09e28WKG9By4Ti3+h0j68oHOFdPnjU?=
 =?iso-8859-1?Q?rZRJJmr2QtFTUyVjgnlBBomNhRj9aeiEwKF2PbIdpgeTQWzniJRErr8w9g?=
 =?iso-8859-1?Q?3O+aKePDmWK1IvwcXbDqvhsIKF5NXXdRiCP1hxTL0ZzxcZLfN/xcDiz4Uf?=
 =?iso-8859-1?Q?n31fsD1j2IcllUL4c8tjjdnCm4MJPxHLOXk7EGM2P/eGDFYKZ7bD+AmgO1?=
 =?iso-8859-1?Q?yd5pEfQBjGiXA8NMboxiGNI/+FJPj7Hxc9pIDUD+POayPNSpToK9dulpQn?=
 =?iso-8859-1?Q?gmIfhSXcXvZKFQEH2+ia+I8NIjSmwQ04osXMQ35iJTIB+UZ5+bC/0IPh7l?=
 =?iso-8859-1?Q?h1OCUICNBxvVyYN9Lr9knmqmzlUoG1pODyXUTN6Pxq9gOHPs3VJ59Ftazc?=
 =?iso-8859-1?Q?G9WtU6Wu+9FJlLLw7KsJ3gni8xGHA22hZUZ6dS9QEzNaqcXJlY4Qje9oDn?=
 =?iso-8859-1?Q?89j9hZd3s3V+27Q5m3MQ80Kkf3PLJH3zyuTvQPqHvsZSdcNeu43GeNp/Vz?=
 =?iso-8859-1?Q?GVrJrx5WC7IhUs48l1r1FLMhWPYqvQYVd9jWBKWPrKzSLoUIUDmHIN2J8y?=
 =?iso-8859-1?Q?rUnRXcFVcEB7cMj2cBN/ohBisXJLtMIWQWskTTzlrRtHLosaYqY+4IxC8X?=
 =?iso-8859-1?Q?2BxLy2EM2ONQj/fovn6WdFUxQ4oJezmMhsRvn9+VRexXe2+3ZWbWYWxnM3?=
 =?iso-8859-1?Q?iF51BXcWdrHjpSp4kNbQ7ItAe4cClPRz7bWCBD5uBvgFBjsukxEdDphQtN?=
 =?iso-8859-1?Q?xVfOdn7B/Uek9YdGkRK1TYPnVcJMtUj777K2wf+pWViiBgQjRjNPEwirc4?=
 =?iso-8859-1?Q?OVD9kw6aYaqFGanrfkwy+u7NsERZmNglvj8NpAp8j2lX+zq3iu7zUzSMdK?=
 =?iso-8859-1?Q?xHLTHpKEf+XYvKVhkjurYvaMv+7TpxkAC567cKs3l6gijd1iT2I+kdYIly?=
 =?iso-8859-1?Q?uLYXjJSaiVr5j0M/YX+vmxML+7zlDtScbjtr6BcisBe1YfCU4YebpyTPiZ?=
 =?iso-8859-1?Q?PLeg03u8x5fM36JDTNp+jUZiQreX+zq7ZtTkTVqeY+I1V3ZP1tsDdWny5K?=
 =?iso-8859-1?Q?dc8Bu5gkEQSuhkJ/MWUhXFbLMrjyfQXNozo9Srx8LNr8I+IYZA4uEEpcGS?=
 =?iso-8859-1?Q?UPx45b4EJVGyjnxmGYfIJSHdjZ6klhtF4X/souaSV2mkxW4adxWZh8HW4h?=
 =?iso-8859-1?Q?rRL03LMYQDUihorBb1d4EnMp9kU3P6+zjisyDXP7/GaRGsKQ5jwAb5097K?=
 =?iso-8859-1?Q?6bPbl6ppyFjPZYVel1fXG9/5k5mEA4BdX2a0S1KelgRfABDTZVPR+IyiqS?=
 =?iso-8859-1?Q?JV7DUJPxbOSZa94Zafpa4XYxdUrq81CPm6wVTISHbdvl6HlAI0FBr+G4WA?=
 =?iso-8859-1?Q?FoqEkpNvJe7NMMoA9kw/0FYqTIKLVpOALL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 323b7ed1-2811-4516-890f-08ddeb167230
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 18:19:39.5833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F+sgjM8FhvoX8ZFiCSxMvHgeiNQCpEulyrWJfCtaWjn+tk3xgxPGGWna0UEWHafPPr7AuTcxGITrWE/y93yWig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7450
X-OriginatorOrg: intel.com

On Mon, Sep 01, 2025 at 11:58:48AM +0300, Ilpo Järvinen wrote:
> On Fri, 29 Aug 2025, Tony Luck wrote:
> 
> > The INTEL_PMT driver provides telemetry region structures of the
> > types requested by resctrl.
> > 
> > Scan these structures to discover which pass sanity checks:
> > 
> > 1) They have guid known to resctrl.
> > 2) They have a valid package ID.
> > 3) The enumerated size of the MMIO region matches the expected
> >    value from the XML description file.
> > 4) At least one region passes the above checks.
> > 
> > Enable the active events in resctrl filesystem to make them available to
> > user space. Pass a pointer to the pmt_event structure of the event within
> > the struct event_group that resctrl stores in mon_evt::arch_priv. resctrl
> > passes this pointer back when asking to read the event data which enables
> > the data to be found in MMIO.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/kernel/cpu/resctrl/intel_aet.c | 36 +++++++++++++++++++++++--
> >  1 file changed, 34 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > index 565777841f5c..5c5466dc3189 100644
> > --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > @@ -102,12 +102,44 @@ static struct event_group *known_perf_event_groups[] = {
> >  	for (_peg = _grp; _peg < &_grp[ARRAY_SIZE(_grp)]; _peg++)	\
> >  		if ((*_peg)->pfg)
> >  
> > -/* Stub for now */
> > -static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> > +static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
> 
> skip_telem_region? It would get rid of vague "this" in the name.

Yes. Much better name.
> 
> >  {
> > +	if (tr->guid != e->guid)
> > +		return true;
> > +	if (tr->plat_info.package_id >= topology_max_packages()) {
> > +		pr_warn_once("Bad package %d in guid 0x%x\n", tr->plat_info.package_id,
> > +			     tr->guid);
> > +		return true;
> > +	}
> > +	if (tr->size != e->mmio_size) {
> > +		pr_warn_once("MMIO space wrong size (%zu bytes) for guid 0x%x. Expected %zu bytes.\n",
> > +			     tr->size, e->guid, e->mmio_size);
> 
> Are _once warranted in these two cases? Do we call this function for the 
> same guid and region combination more than once?

I think they are "can't happen". Dropping the "_once" would provide a
more complete picture if they actually do happen.
> 
> + include for pr_*().
> 
> > +		return true;
> > +	}
> > +
> >  	return false;
> >  }
> >  
> > +static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> > +{
> > +	bool usable_events = false;
> > +
> > +	for (int i = 0; i < p->count; i++) {
> > +		if (skip_this_region(&p->regions[i], e))
> > +			continue;
> > +		usable_events = true;
> 
> Do you need to loop beyond asserting this?

Also don't expect a mix of usable/unusable regions. But if it does
happen, then check all the regions. So I'm leaving this as-is.

> > +	}
> > +
> > +	if (!usable_events)
> > +		return false;
> > +
> > +	for (int j = 0; j < e->num_events; j++)
> > +		resctrl_enable_mon_event(e->evts[j].id, true,
> > +					 e->evts[j].bin_bits, &e->evts[j]);
> > +
> > +	return true;
> > +}
> > +
> >  DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
> >  		if (!IS_ERR_OR_NULL(_T))
> >  			intel_pmt_put_feature_group(_T))
> > 
> 

Updated patch with changes applied below. Also pushed to
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v10-wip

-Tony

From 19f90ec0c526791be589fe3ff4797536f7e9e9c9 Mon Sep 17 00:00:00 2001
From: Tony Luck <tony.luck@intel.com>
Date: Mon, 25 Aug 2025 10:47:06 -0700
Subject: [PATCH 20/31] x86/resctrl: Find and enable usable telemetry events

The INTEL_PMT driver provides telemetry region structures of the
types requested by resctrl.

Scan these structures to discover which pass sanity checks:

1) They have guid known to resctrl.
2) They have a valid package ID.
3) The enumerated size of the MMIO region matches the expected
   value from the XML description file.
4) At least one region passes the above checks.

Enable the active events in resctrl filesystem to make them available to
user space. Pass a pointer to the pmt_event structure of the event within
the struct event_group that resctrl stores in mon_evt::arch_priv. resctrl
passes this pointer back when asking to read the event data which enables
the data to be found in MMIO.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 38 +++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 93862060652a..e36b3790733b 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -20,9 +20,11 @@
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
 #include <linux/overflow.h>
+#include <linux/printk.h>
 #include <linux/resctrl.h>
 #include <linux/resctrl_types.h>
 #include <linux/stddef.h>
+#include <linux/topology.h>
 #include <linux/types.h>
 
 #include "internal.h"
@@ -111,12 +113,44 @@ static struct event_group *known_perf_event_groups[] = {
 	for (_peg = (_grp); _peg < &_grp[ARRAY_SIZE(_grp)]; _peg++)	\
 		if ((*_peg)->pfg)
 
-/* Stub for now */
-static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
+static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e)
 {
+	if (tr->guid != e->guid)
+		return true;
+	if (tr->plat_info.package_id >= topology_max_packages()) {
+		pr_warn("Bad package %d in guid 0x%x\n", tr->plat_info.package_id,
+			tr->guid);
+		return true;
+	}
+	if (tr->size != e->mmio_size) {
+		pr_warn("MMIO space wrong size (%zu bytes) for guid 0x%x. Expected %zu bytes.\n",
+			tr->size, e->guid, e->mmio_size);
+		return true;
+	}
+
 	return false;
 }
 
+static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
+{
+	bool usable_events = false;
+
+	for (int i = 0; i < p->count; i++) {
+		if (skip_telem_region(&p->regions[i], e))
+			continue;
+		usable_events = true;
+	}
+
+	if (!usable_events)
+		return false;
+
+	for (int j = 0; j < e->num_events; j++)
+		resctrl_enable_mon_event(e->evts[j].id, true,
+					 e->evts[j].bin_bits, &e->evts[j]);
+
+	return true;
+}
+
 DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
 		if (!IS_ERR_OR_NULL(_T))
 			intel_pmt_put_feature_group(_T))
-- 
2.51.0

