Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792435461;
	b=xY02yC7R7J0GDpgti+VU9oHOKwX4jMdglHZEtjwA+TIPsnR2zGgBH6V7q3malYaNNw7C
	 AEin5yTQFPWIzvbuTRLnMquPmh43LJr1Qqqm2nvamXqCtWjDgEH+LZNcl3y7NCglvhePX
	 OlPq0N2JKUOkMu/Mbe9BubqkG+wex+5z2sOfzLnVatrXY/PIo9Y9he8dK64+W7Bc4Pup4
	 eV4HmJePeUOncwM65Qv4OnE4x0usCD0HJyEWIP7J5oAzPf2IjpVFIfH2NtmAHKLd8nRzh
	 gCwwOG4oKhYoM/xUEyPmsURhW+i1q2s3RJzzT+5qTt4JOPGG6a5FJmnk0C4i+SKWiOg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792435461;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=fVyW9qvN4czLQYOzv+tzXWnmanP5rY+vrT108rkDt/4=;
	b=SetxeACR5EmrUtiJ1t3hO/Io3/loexuseTMaayqVWmZAFHnujApndc8Jtpft9NTgfB8i
	 lUqHccZs1H1ljxQSefJWEXv0zZ8uitCFaNHN7B504Nor3sXddEEYHJq8TpO1QczQ4GR/P
	 zLnXPRY4x/u3syIq2a+0RdldRFii0dQ3uHQzf0gYagl96ZAF0VTx4/nyJgoQtlLlGqqeR
	 8AKppvJ0cwHRIiWtSqhJRIqurSQWlaVXGqcD5UkeHov1Q44wwrzmSvGwicCvvNTh2umQv
	 J1kVt+rRLA/RKwz7mZ8+ISuZey4JKzTGRHP0YCHbX8lKwzpSp4GyAreBkXFkYLY5JVQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZKrgFYfL;
	arc=fail smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608BF606A31C
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 18:44:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 608BF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZKrgFYfL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792435459; x=1823971459;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8WJujvJ3ZkFJsBDAux48qIPYvtLhcsL+v39Gb4UExac=;
  b=ZKrgFYfLXfD7Zq+VwokckJMQ3RHJoEzzGIXlcq//G5u38wjWIpn/SX5g
   RuBM84aHLrRXPEJpMZhqzumY5qf7+eZxxoSHBpUhBIZhn5Il4JDoUvCwq
   3xRSMaIEV4pp/z1dPomtuu0LiHAFV4G2BW2SQ8RGAQrYQfLem62dYzUXu
   EgxbslhLusILTKCrqgkZ4i+2RS/3ZipPmOsRDHam2kxOEb8BGJQ6qYsLx
   NYcsNmLIO6pGECSq6y4uZX+h582WJnjWOeKJKhd7W9q79lvx/c3obJETw
   OOlS78ChLgLd3Lp351TbK4/un9foAiiUg6iH7Qoo1JLBM5VvrXtcUlYDk
   Q==;
X-CSE-ConnectionGUID: zv3sUa0cRnezRbpDCCBVCw==
X-CSE-MsgGUID: KyQkmKmhRYqdaqoOzh2CRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1132409"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1132409"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 11:44:19 -0700
X-CSE-ConnectionGUID: 2AW0GafmR2mR0Sx5cqRWUw==
X-CSE-MsgGUID: k27CJAZwQQ6de2zlgsWeOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="3027083"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 11:44:19 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 11:44:18 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 19 Oct 2026 11:44:18 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.2) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 11:44:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P0YBWCKLn91EisXSau9oUtKRcvSVDZw0bLvyi71Ut97v4pqfUPMuqKpasLdMRRIG9EnVv98S7BV+9gEsueRL+Qp5C9StF8DsajNdnzk2/laOyVDQCVTB+NL4e3GuQE2VqKnACPhjDGqc6laDp+X6/z46AEGbOQfrpmW7Z6CBvevoprmx9ns08ihPrbsR6GV8NQ1nJ9FUaklB7AoRrhK9TMtGLqLwRFbSzOpVxAOPqXlYmf0xbQoQID4Xpmbvqfugvg0m1WuwuW3D5JbqTTtxPVB7wfCO7WCXOjVSlKRvMqkenHQW24R2fYmPrzM5Zb6Psloj2FXU8IhWFSY1QjRVoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fVyW9qvN4czLQYOzv+tzXWnmanP5rY+vrT108rkDt/4=;
 b=JJOqymFkKCp2m4fVvIZS1ygvvyRaBEvFaS3x0J0OW/R0WGx3DRTdELdTpkxROt2sThLL/l8NdoBlTEKIPYI/fxo6znECa19DNHWesf7zJ5vNWOmZoLcE87vrrbdr6blAgO5OPddIzGD0/bG8G/1D2gG0eWylOUQrduIYfFwD4g3TA8n+1rnuqxJr0GwcJ2Gcoq4lUemh/6lzgZISBY9m5qN/xtHhhcBuExHz8hrCkftMHHCJoYSIOO+9sFVTaZiY9Gsr0v4gRgXziLWLNaJ6n8w+VeSL0x/W1afo+JsphLTmhYd0zY+uWre+62BN0RdVXBWMJjkZHPq48JraXRoUQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SN7PR11MB7092.namprd11.prod.outlook.com (2603:10b6:806:29b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 18:44:14 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 18:44:13 +0000
Date: Mon, 19 Oct 2026 11:44:11 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Chen Yu <yu.c.chen@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "David E
 Box" <david.e.box@intel.com>, <x86@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v13 10/25] fs/resctrl: Remove redundant calls to
 resctrl_mon_capable()
Message-ID: <atZk-3SBGTMUZqKK@agluck-desk3>
References: <20260928221509.68002-1-tony.luck@intel.com>
 <20260928221509.68002-11-tony.luck@intel.com>
 <atY33C3JoNI_sQ_P@chenyu-dev>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <atY33C3JoNI_sQ_P@chenyu-dev>
X-ClientProxiedBy: SJ0PR13CA0153.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::8) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
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
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SN7PR11MB7092:EE_
X-MS-Office365-Filtering-Correlation-Id: ab4dbebc-5289-40b9-0ff7-08df2e10f85d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|10067099003|56012099006|6133799003|22082099003|18002099003|4143699003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info: dOAvRaRY1bZV3sohJv/4K7AjCtZi2x4hYvzQ/57btPt3frFCfnVPsxU7u+9hyFeR66w98kI5yh0pE2yGSYmWu6lykpRC7T2ndDImHch6xeVxqFMm6TjjK+4o6clvhq/0exzHzR4uczyQlcCiC99da5nrfahCHnWxqXtPUWSH1cWzdr3NJMDBRtMWttuYKb8MpIk4R7Wh+6skrL2bRDhvJtt+sq38WSBOS3cZTDfTn486nuhX6dLtpxKZZGr6l+SpyUUNEES6k5BSYd89HBfJvycmrK8+XZJ/yB62WJhSz8ndVwPEsHrv/sGK2aEukiIlwo4lp8fOKiacbjvZVZJN5Trp7ZqK96p585aC3mL5ssayG1eS9FR0iBq54B+4uuCYjzBGM6f9OoK2Pk+zG1wnzQ4+hUYhGlf4XS5a8DGn2dcwTJ8LlKEdfvQkgiGiIzDjizI/87ClYBlOjvBGy1hgtOlZEWYHkJG10LDMnmmedBC+xBSQYSN0RIBpySw7Fg2nFJXPZ6Ooo5wDtX0j2iyfLvMkanXYxUR+eM1zzFKWqLYiX8n8kHf8rIQ8FgT5QjgSbH7/J+Xvr5TACbW8Vc38AcsMXfiheLzAO+vQcOb38FleY6zDeBuWV+SNV8DggnuuciRIPvraKQacy/YS8OEdXcYzfWYTjy74TU+Gkzol3PM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003)(4143699003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X1QmMXr3doAqRJ6Oos5QTRNPzHK1H1LaYOWD6cQI6RlM/za3pcVsX1UFqaP8?=
 =?us-ascii?Q?/NWkXZGK1nn/dHtRE9I5VsC1+pMbz4Y3RmVd7cghIdz1Hy/dmgMRgeK+A0Yi?=
 =?us-ascii?Q?Q4O08VR75NYSxJ0gdaWPE2bLe+oJrPtUMiGxHgQWt/W2zxMgDbOeu4Mvwn6F?=
 =?us-ascii?Q?Ui5CS0jOQUCnd5tHhiJB/rgKCtKFvG09SFwSD+GwShIyAL9c2tGT8qpqByfT?=
 =?us-ascii?Q?agKQGKvPkHo/KArfWVqE2J+4rIksr8dBqw2yp5bKQ+4zhhRE47quAGjbI052?=
 =?us-ascii?Q?a97TLEoJ0NAOtB7MFGJLGltZ5zPAvlwyotZa/lgnvAso24uzMHaK5HJN9DBc?=
 =?us-ascii?Q?wP2BvBUWB+DTo4Stgj7sZCt1x2u1x7ha22uJ0Y5zv/9ozwAi7kuO/VwMxcUl?=
 =?us-ascii?Q?cvInLcBG7lyep77eAtSkWraEzUIwTUG2hlLgeawxDaQ+I8jzWV02vc3jmAHN?=
 =?us-ascii?Q?PHjN+7PMV0IZ0m1wZSk+SHaHZdtySbrw6nJ10OW6F4NnZvioxKe7KswkQzEg?=
 =?us-ascii?Q?MvZAJmFb8J4bVd2DyGzZ1GplUhaaKTgZnKyGZCGZmCQbjRLq9zdaNAkbNVRJ?=
 =?us-ascii?Q?ObuGgO5l/M5LeVFTbAPrpffUl1kWPV+RUiVDWz7SXtECqFvLCM6YnaF9Cd/b?=
 =?us-ascii?Q?Jl9pBcYIEz4OEWffIWkXODJpFN4EZfFMrZ3N4oRFoC7wU/RwfW/XRPm/pR4H?=
 =?us-ascii?Q?2rE1hBgE5Mm+d13y3MdpZLPNf5QAhNz1P0SRo92BZ2z7vEoSbrBL/e2B1YYv?=
 =?us-ascii?Q?aYD+Fd6SggrnkD1z2d3xWhXIPwC+dIIJLKhDzbZk2BU41h6/2NcIEEXhfkH5?=
 =?us-ascii?Q?eE/nNma62hbEv+Y9sGTo0rKruXPmNKut52jM89LX8awTQStKRR6afFCOn0TR?=
 =?us-ascii?Q?uMCMAntr3ix4zXXotHtHvyiVGQbP0agMiHFhq0oHg23ioGMqjIkDqVJRoY2P?=
 =?us-ascii?Q?1n4G4dnwe07XNWQzSQtCcnvM5NsE6vvaaddhs8Uc26cR6Hl7cV/vWZO5GPea?=
 =?us-ascii?Q?QHjQ+PZCnKCYBYRJv5ne/3d/WPIqEvDdnmEYnvFcrtnZx/uOd74JKRxfsoDc?=
 =?us-ascii?Q?mN5I0AAtFeZp/1PhnN0ZjZFwtzaJL1V1ZgXT/ejdDAvUamqRTLLql3KCb+mb?=
 =?us-ascii?Q?c15KaVpQy51KVDwUGc/x1iDikvHYlcUM1GAGJvGzAiL+SjpgW2IY4c4/fE9V?=
 =?us-ascii?Q?dKVsANMCrtv8TUB3IzYRJjjDmfl4iFAoxPXwM0ni8OPBAORzw+p93Ab6YZ9r?=
 =?us-ascii?Q?m/bxCZnyHyWjgE6DE7GHIkgeQzJj3jVRUwWdT/RHnvPi46TrqXHGcb2jS9B5?=
 =?us-ascii?Q?pl4j4wHc0CJczMWhY2knY7mrKj5adjCNDlzLaGLT+1iMoHcQ3ty8XBElI34A?=
 =?us-ascii?Q?JnpFVh6wMjLzfklbMctzN5lHPwy3rUv79KsfDcH9YqDzpyCT7FABM1qswlu4?=
 =?us-ascii?Q?yyuvhT7duE9dsSL8r7XF37z3dbrUS1LHB+l5Lo08mAF6Ua/1u8mizr2m4I/J?=
 =?us-ascii?Q?e+mcVDzfgbLAfGAzk9QIoQPGV0DQOLEbO2E2UDUhe80uT849RVF7Glxcf5H9?=
 =?us-ascii?Q?r/YrymM4z/9/DDJuO/Nm/v2jllG6fDIg9mt0R6PiNnmTyeXuBl3qGBrV8i3h?=
 =?us-ascii?Q?fg7g71vZnHuIV+PlpwbOfRshUtgNmi4YMP9qybBbsq7oJd6Lkr2QhCtUeue/?=
 =?us-ascii?Q?zLcsqckCR3kUOpUTualqHbE1EwKXmMsfZMQJkb9Xq5VCDUPWoJuzNenHnns9?=
 =?us-ascii?Q?UF8rvbdBKg=3D=3D?=
X-Exchange-RoutingPolicyChecked: lRusDnASJzz2LoYY4O6x1guOpeor72yFaVrQjUBcOcAIDBINgjk4suIrm+NZjzITYOdR5QfIgOAUH/NrvOrfry/u2kFtBW69tT+8Ra6oDlx4SUM0q++3NJvhnh5RZr/FAFho6KP2Voyh9N4pr73m3qAJQ+vqWBmV8PVHzmYGrRvEnRcFpbjJTjQuVhEu3snq7KAoerx0XKCxJVYsIgTuYLPBEROc0abraVHIbxsuJpGWZDOINHm62g6/k9f23AlxLZXMmYBsf7T3sNW6x7GTWqvPeM1+rN2zeOeIadZTciYVA4C2RecgWLOHN0VuY/H3VugCN5l47xthC2nSRnfGHg==
X-MS-Exchange-CrossTenant-Network-Message-Id: ab4dbebc-5289-40b9-0ff7-08df2e10f85d
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 18:44:13.2428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dBG7WKVkHX4yJsq867OwPblUmKeVgE5Dsgy+Qu09C4dtpNeO+GRZQfxFl6vuztzW1sf2wa9e0DROd/eJy98etQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7092
X-OriginatorOrg: intel.com

Hi Chenyu,

Thanks for looking at this.

On Mon, Oct 19, 2026 at 11:31:40PM +0800, Chen Yu wrote:
> Hi Tony,
> 
> On Mon, Sep 28, 2026 at 03:14:54PM -0700, Tony Luck wrote:
> > resctrl_mon_capable() indicates whether any monitoring resources
> > are enabled on the system. It does this by scanning all resources.
> > 
> > Redundant calls to resctrl_mon_capable() in hot code paths should
> > be eliminated. There are two prime examples:
> > 
> > 1) mbm_handle_overflow()
> > This function is called once per second from worker threads running on
> > each L3 domain. resctrl_mon_capable() is clearly redundant because worker
> > threads are only created if the MBM monitoring feature is enabled.
> > 
> > 2) is_rmid_match()
> > This is called for every task on the system so making it less expensive is
> > appealing.  
> 
> Nit: since patch 7 turns resctrl_mon_capable() into a resource scan and this
> patch then drops it, would it be worth moving this patch before patch 7 so
> there's no intermediate window between these two commits where these callers
> pay the extra cost?

Before patch 7 the overhead (on x86) was negligible so not a good reason
to make this change. Agreed that there is extra overhead until this
patch is applied. But since the series will go in together, that would
only be seen by an unlucky bisection that picks a commit in between
patches 7 and 10.

> thanks,
> Chenyu
> 
> > resctrl_mon_capable() is redundant because the function also
> > checks "r->type == RDTMON_GROUP" and this type of group can only be created
> > on systems that support monitoring.
> > 
> > Remove the call to resctrl_mon_capable() from each of these functions.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>

-Tony
