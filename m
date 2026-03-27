Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8572C322A00
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774655329; cv=fail; b=DYdS4tF+9LPYqNRTMdSbw7zr9avuLCYpqcvEf/86eJwczxYN57t+C+nL0WJg6ZjjqT9aBrEGGbV1ldO2RGfbSL4h/5ClkRi3aC0fEh3Hga0rIOCWi8iACKr0juNnpPwAxcfDlfasz6eX1vorWHMh21WBxY4K58DjImlp4FiN3PQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774655329; c=relaxed/simple;
	bh=jbLVoSzrG6U4K4eyTFiIs0WdmvtLXeW3mLZAlj45dvA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FkagcW/iVzA0jgnauACrkXckgT5WYXiqnNJIXFboPrkAqiVLBqaZAnu0h6/BAth1+ZXQQDFxcogtDz8JEzKKoH3kUk7rhEXYwBEmtqQ4SfdhwjGDb8tLJQ+OBFTc+MbCx2+D0hTHF1uYYgmVgHMtx/rhCRvgyxRpkUZYJ2FfMHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D/XAIxU/; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D/XAIxU/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774655329; x=1806191329;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jbLVoSzrG6U4K4eyTFiIs0WdmvtLXeW3mLZAlj45dvA=;
  b=D/XAIxU/HA2F6tAUHRwBYUfLa3Uhik/nVVU+RLGS/IJjpoCXQXyFM3nh
   39TbU6yAez0j5smIgo03COQAeYDlk9uKG5v4vCCsc2k4QzX/nYEQXx6Gi
   2JZ8kX3wyFIHNeFy589jOytn40qm5eL6CegqN7tS9s+3kO02wx+RRqcRW
   isxRyDZVVio5rE7VNo4pW1rQKqRLG2URuUory0iL/tyA6w+kvyKc41G5/
   YA8tqK2tM7hjkjjlTab6O507EeEmahHaZm8gaA2w7ZIbUuaiBZVnDvyYo
   5KH9283XQ9Z86w+0gGFxWtM+yfiUd6H6dFfsAZb+5Vls3rj68i2+y8GLs
   A==;
X-CSE-ConnectionGUID: T0S/IuhrSVScRtymy1tlVA==
X-CSE-MsgGUID: TS/5bbIrQsaCY4diJwJjcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="79640147"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="79640147"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:48:48 -0700
X-CSE-ConnectionGUID: BP9PmBtNShW3gwn0YZQPdw==
X-CSE-MsgGUID: YmzPeGIQSCSHdWqeDmWaKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="218823383"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:48:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:48:47 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 16:48:47 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.63)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:48:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=atEXo02T/a3aiBfoM5B9X65foP0q6LoZ+GbOC9+mztSD9ZuNePLlGmXpNd/B5P5lVjbyMO8LFkFOH+0/KwDqFkblDqTTmNwvBgLIe2iePWxNjnFjba7aormqn1cEi3MGjsVHx0F9n43LS1eONr/DzFcPMXvnZdDWtETEh/WqY9l92IhyCAUv7Igrt7fceyKo4uhFMf1u3Wfz+dITNFCMhOflPRPUHRuYQGbD69WntwyGk2o36rpfXeYJTYc/bFY+LL6THipnXYxYB1b95EvjbKBDUCtZa98nVuMPWx4zXr7/jrhSepCUWJCPDFugyHq9a623EYfDfB7xnQGJ/tMARA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMOvBUXHOuCTxz1mYwn+pQqx5F9nnVaUwrMqeweSHYw=;
 b=PT6KLq/aCqSzZHqNiCmzI1GpuEFugVUbwGYqOoQIA8JsKwnw8LaeKPzoSJb/0F9cJUA9ZncBRpOkvUVYMnLmV1r4D0wrMv6MbeprbjHaFVsHX9U+Xi+t1EX4+VAz+VjzvnvXXscErCsAz1sZTpKWF8RZTtqUF2cnLQwx8WVn0dKqR4RTSDPvu1M5oNFCGn9DXZ2CoUAcenvEVplPpSlu4KfnaG1C7TZUy0jL7FG/GrJ9YgwKcBt+kzdc70ofKUpdiU1Lkk8PyFy3ZVbwktpYFvaDIcVuAa6qY7iR7zDJoahQi06mtCe0F6cn+BBijHU3pJMjBzkXQgTbghDEmf/6dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB8254.namprd11.prod.outlook.com (2603:10b6:806:251::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 23:48:45 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%7]) with mapi id 15.20.9745.019; Fri, 27 Mar 2026
 23:48:45 +0000
Date: Fri, 27 Mar 2026 16:48:41 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <dave.jiang@intel.com>, <patches@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 8/9] tools/testing/cxl: Simulate auto-assembly failure
Message-ID: <accXWa_PZB6Ruuwt@aschofie-mobl2.lan>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-9-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-9-dan.j.williams@intel.com>
X-ClientProxiedBy: SJ0PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::23) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: 84d693dc-0e23-402f-2133-08de8c5b6236
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: QEGBVMfRltdU4nULYFKB/5P1/+2l1495Q9+9Ud5VJEnY3liM9aarHaLmDU5Hq8p5QQM6CYjkGxkvo/ONkWr7eaO51WyXj/r+Ab+W+85ZIT7VloAYXAMS/Ne0OH6siETmlnbVRhghKOMcTQXBB1gqQuJT8B7P5jgt4B9rRWQL6U4CzsL7hAXcl//+AKhzWQtbUaPKUm3UumTWjJ3U1xsquTzBMpiL4HBYakWFXhnLjiIzQxERvnlRZZ2TabOkBV3TaXn5fQKIu7rJrrGOWW0NWgCyDx5p6fdeWEfo5Pl9BNAkQto2taOC+GhgfQztnzCys00bj71/jpifMkUCkOi3cXiWp1/LEFdIzKp2nXr4fHmXZLNFfXc0kjrwkGdySO+mMZPFrbD4nmlkNoVCOrrP0BN4L5wdhePrOaOA7xZtwHPyIIR3gPywpDctYQUhHh9hEUIJY1VdgzQGlW2bmdrPofpB+Ygdxt8L0t5u6QY6VqlWlRTwK+LUL6QfIeiUBUUHfR6ymAKvj3nKWFuGqdJ7sY0oWkG7E5OxRxDgDSMz4/1kIQhxn5VNrCM9YQnEbbQCO7TDkC/ITS9xRpY62Bqwalo9Ja7/3RjOqr49CFLw5cvA2qg2xwPlNoxOSGxYBfSUp/EkF+hYxA4YfU+hjdXQOj3ldbBdCtNiWbPiDkO4sYNFPDfuMc04RIKo72qZZY5MRyuH9njV8D/BIxENac7kAc1zMKZcCbmsydldoh2lgBQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uMEefdNM2ae6pgY1HH27Sdes4GDoM6h44kS7mPEkYunbxXmvxu0GBDJXUsfM?=
 =?us-ascii?Q?5hSeCaD2Ej8fe8fc8kDa/e1q8wY5gTcwIjTRI2YrDcavDjbS91x6b0N/98id?=
 =?us-ascii?Q?47O0YlHqL/wNc4Wqeby3i/i3SXn39CmATk2VGK0ZxMcxIx+sG0P3QWMFbPxB?=
 =?us-ascii?Q?PBHCRWS+5a8IZLgNPSqYiN7+wA6rzaPe0jlHjilPnYPKnLfnFQf/4IaMPvbM?=
 =?us-ascii?Q?eyq6DvqL4iN33SVr+e9uBraFFIVO8PkpVjsXwmk7vXZknc/g6kzklkTCsPWn?=
 =?us-ascii?Q?p613ZT5WIoJ1ol+D4Dp7xG8wZm58WVpczZONuzClTR+fCUQAhqaoRMjYc3Dv?=
 =?us-ascii?Q?NcYy+TYrYHhmGFtF5Zd18fZWzneJpOyuOfOA7iqNuBnl7agvF3Rz0KBXlgGc?=
 =?us-ascii?Q?4XONgKzdOyq6fWn2tMnI7XyVQ4v/6FkDTVNzH2yfikd3vboUZDck9VnwEVkx?=
 =?us-ascii?Q?tmd+9ffFrgfgAdCtYA5KttCPE/henfGgOOIxaZzgOwzIFPgV+/EgNrCskNT4?=
 =?us-ascii?Q?I1kAp/Wl4q+cEPj8UPANN1ue67KY+s1V8uOx7XlsbkDdUlV0t31P7TIXApF/?=
 =?us-ascii?Q?BtG8FFxOj2iGAjgjiJiWESjz/wW1Nplq2tP12It16eynTSwfksjDnqBcVK/9?=
 =?us-ascii?Q?8PXxAYJXilej1HyZwm1d6KEUtArYgDgZfqZnVs66iZ0ZH/SXtOKK6RTzTF4L?=
 =?us-ascii?Q?q9XEM9UN8EyOdm3JL0o0EKu2Swd/7X8vKTW9nPWGFPDlztBsWOpLAXhir2ix?=
 =?us-ascii?Q?hDNOAH+rYi628z/CShQ7dsO2EADT4waam9bAisSu7kZqKQ8kX7b0dcA5U0xH?=
 =?us-ascii?Q?P4njkIsI1PZEbzXS/nkrfLhZ35xSXEzQxtlr/bhTJimIMcjB3SOj/UHzSKLK?=
 =?us-ascii?Q?J7dC+0EjsOpckAFqvAVDNvwHosWJbuHsn3te17xoClEbNM5ykIG4SzCy87HU?=
 =?us-ascii?Q?1ySFmNuq8sbitHGCC74yzl4G6tW9guaeVwsKHGhspyEu4xgbtNOmfWJVMdN7?=
 =?us-ascii?Q?wH6fpnClteV568SvDQP1gOMlDR9i6IviZpsDUl43yhhmwVJd2ZXpQDgoPIi0?=
 =?us-ascii?Q?Pvc1Um60MzZX2oLi9Lq49JBp3etdlO4dnCrcASrQsX4YAzSQ0cCGe5YBStV8?=
 =?us-ascii?Q?NSGRrGW7FxmCe+u306GBXqeW9AVFGORgES+vA0HVDgc33XcQw6dHaEnh+bYO?=
 =?us-ascii?Q?t0EdchVXE5qaWKiToOiR72Eujg9p63HgSSTduD1sMm4Uly0w5eYRJamXpJCE?=
 =?us-ascii?Q?pd1p7exndOCzGd9yeSNtNMAwgxhBHZqX8myMokZSuNMRvs+ofUHF+bc0Y3Eq?=
 =?us-ascii?Q?1L4A8zYFTsZb9Q037sgckeKolhCYpkwlDD1pBpIDf9pW4wrKpqA38/w/O/WJ?=
 =?us-ascii?Q?Bs4ZAqLCL/KZmFm1luh+CN950uQIN6bHoYJy7rbwthiSJZZivKm1xqAkVE1t?=
 =?us-ascii?Q?p81NXxiVvylS8F9LghJiPIykvTULoJDfQOPalLva12tHDhiTs/bCX5awTnBt?=
 =?us-ascii?Q?yBQYiupHyir+BaWOWsWZolsKeNeFCqFRVSdWkFlShqsHKUpmqsmu0SM45yzs?=
 =?us-ascii?Q?5jJ3d81hnyYYKXa27TG+5B/Ac2VsOV8b2RkAgxxwYH158ksD7FHdn1LHCUzt?=
 =?us-ascii?Q?U8J2NQbYC+ZAED/t6DyPMkN2Lz+Ql9+9NYGR0R0SL6wyqyRep0U57ybTBCtc?=
 =?us-ascii?Q?tPZDpUxd4YrrJpji12Vk26KOccrRMQ3fY+2pVlPu61Ib9ZcY152wi/HvYgx1?=
 =?us-ascii?Q?AFjJl4ck2O1FPa54tDDMJIYCTKKna8c=3D?=
X-Exchange-RoutingPolicyChecked: hU72GYNXibkOC6cJ19e6b9XUJvL0tAOE7AW38zxHq1SkVJAkhcONJC3gteN43tg7/i+/wLYyBPHWjSFORxVyDKTbgKyz/LV6XtmCEmUjIGzEfEXnH1FJqFIy4AS0s5T2N3wFlpJfMCKW6nvu5yG7M6EYDoj+KS6H6/3VABDrTRnD0r+2LTdeXR5YxnmD4sRCVJIebG+X7l63D/ErjtKfzDgDERmUexAYWEdbPNz6RUpwnBYtdBGlL6pTUwaJ36L3uHe8Lr6ZYYh5dVgIb0/x1KKnqfi5CpOa4rvZpD2QK9+ZF++vGZezmx3wN7vjQ/h+ubUNbB2QbrKGCahD1cfWIQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 84d693dc-0e23-402f-2133-08de8c5b6236
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 23:48:45.1983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iupRfQ1ZisnmAQiENmEdQvtPX8MTHd4eyiSJTp4GlKr0fkMAHj5mOMvkowyhIiAm1bEx+5mbeo5HKGZC+Inzn1CO16oMb0cLQg20+P3xTqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8254
X-OriginatorOrg: intel.com

On Thu, Mar 26, 2026 at 10:28:20PM -0700, Dan Williams wrote:
> Add a cxl_test module option to skip setting up one of the members of the
> default auto-assembled region.
> 
> This simulates a device failing between firmware setup and OS boot, or
> region configuration interrupted by an event like kexec.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

