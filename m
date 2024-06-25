Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81F117C9EB
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 19:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719342133; cv=fail; b=kCLzZzmIju6t+CElkxBfuSL6RkdsaBmvrIY4FROcujquiVnUFPhaBYX2xp1EdvvR+X1D2/YLw3MlMEQaT3PqKYfrrbjIqjo0rCY4+UOMsi7rTzvXMZp9iRGFhVk1uS7ScLM67AEZSePfiqyNQLjW0JoXGUWZNXPEJLPNyFRKEv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719342133; c=relaxed/simple;
	bh=I7Aui2jTyg02jZxYF0iaVydBTtGjAYbUYnaZ7azlDpM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D4Au5DXixpQ2FknGriA4vgZrS9TJZ3elICwX+eIQeMsLbUJlhxSF6UjcH6uVb0Z9CVQtg2gdh3DziP99FON5EqDv/orPNF1Trk9W+J3fnUfUK+toqlWTz8C6BxC2pS90UOku/rF8SoswZyXFC6bIljmi5gXOXYmqfrFp5YQvEpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MBrCHB/0; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MBrCHB/0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719342132; x=1750878132;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=I7Aui2jTyg02jZxYF0iaVydBTtGjAYbUYnaZ7azlDpM=;
  b=MBrCHB/0P6Naf5FE4I7O3SG3VFPp9alBRz4UF1Cl9sYmY2DjOk564xQk
   nY1RVgx2Xj7KQfa87WflIdKztosscLBMPMZ3d2mK+QwCKNsXSLeMtBuJn
   88DTEATEk0Wa4JYomvwYb3+TsDEJzqGY1OfLMlSKD5fHcJN+DV2CCac3s
   qwx2F3fBDSDKFGhVdEaRZv0D2gH9gDbyGMNH5cBT5okeJS+XzrNzfQSDx
   fnHe5gDLcFVRVDlLUH/ppTsLfT0HW6KOwuf1JgBCrwmdy7PiTDG2C3RW+
   z99Su6xZD+OocQIWicCreYri/RiXCOWcAnnpLXV6kOcDjVcsaybWAM2Fz
   Q==;
X-CSE-ConnectionGUID: Y8MejpXtQyqArgvD150hCw==
X-CSE-MsgGUID: WFpFJvCWQ4CZLbAiGkpXrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16065962"
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="16065962"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 12:02:11 -0700
X-CSE-ConnectionGUID: /Yuv1MBPTv2+GrVETeHeYg==
X-CSE-MsgGUID: biA10xSCTC+MZkXBlXd8+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="66965642"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 12:02:11 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 12:02:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 12:02:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 12:02:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 12:02:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mopwk3CyloD/BVhuuKczedsVslSkwkmKAANI6jsA5phwMtoq3A2j9x4e8mpIMOl/Us8C+rjme+r+GGaHY6ECCIJJswl/EPsVa/Ne7XukcTF0ND/I0D6/CucXSoRtevQvqTEKfH3biXn8AGy/2hWbipT/sQm9qJmHxg9vp1s5CaGApl/BDZAuqHUqj3gD0uoPN/ijDEk0FKm/zy8uE+mdflavWMc0wG/E2EppFDCzHue4IVcNn4YvEVs3wR5RGMwfHxzw2gigqHnJ9Dhdg40ePIhjmisdR0YIbdXmTrwp5QBIk98PJFjWTwrUCicS7APQdIgcdI6K/Fx5R64g8GQ4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pzCSm6asZbie9yvTFZ2xkdlpaCJ7sdvqwxxe7JMqXsA=;
 b=GCTzhL2vXs0jdaAnl6lo10Wurm41g9rNQAwM33kVzcM3GD4t5Ax5IVROTfudC4aSyqLPtH086W7pfyKcarcS30PuI2D+jorMdWhlZmd/q/hgdpoLwBsIl1WktXtDakmwlOUAyUVSaXLpYgL37Vini5IffVlxgktYJYdHsAfxVKgi4Q2+Cmy9jPNTp3k+eLlVmZcj5yspNENzfGvpAs3qSjQ0hbRd9yGHOLOoKWVxim3BnMZ+CflG93eu+D5g9dQLl5crHD4iKbqChB8NtRGIu2u4Gr8NMRqfN/N4QT3vZ1sIRP/Ai8TA8NoHOwbX4AEBx5JAzO7E6DoQ3ejLkNG0/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2854.namprd11.prod.outlook.com (2603:10b6:a02:c9::12)
 by DS0PR11MB6496.namprd11.prod.outlook.com (2603:10b6:8:c0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.31; Tue, 25 Jun
 2024 19:02:07 +0000
Received: from BYAPR11MB2854.namprd11.prod.outlook.com
 ([fe80::8a98:4745:7147:ed42]) by BYAPR11MB2854.namprd11.prod.outlook.com
 ([fe80::8a98:4745:7147:ed42%5]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 19:02:07 +0000
Date: Tue, 25 Jun 2024 15:02:02 -0400
From: Rodrigo Vivi <rodrigo.vivi@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jani Nikula <jani.nikula@intel.com>, Dave Airlie <airlied@gmail.com>,
	"Vetter, Daniel" <daniel.vetter@intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, <tursulin@ursulin.net>, Francois Dugast
	<francois.dugast@intel.com>, <stable@vger.kernel.org>,
	<patches@lists.linux.dev>, Matthew Brost <matthew.brost@intel.com>, Thomas
 =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>, Sasha Levin
	<sashal@kernel.org>, Lucas De Marchi <lucas.demarchi@intel.com>
Subject: Re: [PATCH 6.9 073/281] drm/xe: Use ordered WQ for G2H handler
Message-ID: <ZnsUKiEiZEACancl@intel.com>
References: <20240619125609.836313103@linuxfoundation.org>
 <20240619125612.651602452@linuxfoundation.org>
 <ZnLlMdyrtHEnrWkB@fdugast-desk>
 <2024061946-salvaging-tying-a320@gregkh>
 <ZnqyFRf9zPa4kfwL@intel.com>
 <2024062502-corporate-manned-1201@gregkh>
 <87ed8ldwjv.fsf@intel.com>
 <2024062537-panorama-sled-3025@gregkh>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2024062537-panorama-sled-3025@gregkh>
X-ClientProxiedBy: BYAPR08CA0060.namprd08.prod.outlook.com
 (2603:10b6:a03:117::37) To BYAPR11MB2854.namprd11.prod.outlook.com
 (2603:10b6:a02:c9::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2854:EE_|DS0PR11MB6496:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eb72f45-b828-494f-44a5-08dc95494f0c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|366014|376012|1800799022;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?PN9zIoSR577G5VJDytre2ORC4sBcvauypSIXLKQEly1jvSIWSiTtwprl1U?=
 =?iso-8859-1?Q?K9od42tw/vOXaUpFWy9+LWE6vbdgsTXwqwyaMhECxfEsYCwkG+x/cuYGUn?=
 =?iso-8859-1?Q?R26ciMau4QXYNOUWGUnhL/u6bqzpALTQJn5+VIjCmDhXuhypkkKepes/QA?=
 =?iso-8859-1?Q?mUvS8dsQSXeiNaGyhu51xJVzJSQKrlCHq5VpYHdgUNONGCH+MXcyYYDfP3?=
 =?iso-8859-1?Q?K/Piqm1DOCRyBYrFpHd3ysyYOrmN3SY/Khz2FdBTe+QQVzioBv3U53IoAa?=
 =?iso-8859-1?Q?5Ws9kiPCF8BrGxgdVMTeiUrhhiVqwOMyGETmXBTcPp5yKxyIK28wbdjPx+?=
 =?iso-8859-1?Q?wG37W8jL7vjvaSR9ErkF0NgrEeFUQjZZbDlPV/dpUDNxTu73Z374lu+aIA?=
 =?iso-8859-1?Q?cXoEIfJf41ciu7C/0OO21ElMxtEq0GnXRW3aq5o52lD7mQTkT+Z0vqs88/?=
 =?iso-8859-1?Q?K1doodbPjuAAGPJC3DdrLXqcn9i2AXxNXs6z+WEalDrgSGx1RmglefzKFJ?=
 =?iso-8859-1?Q?/4IQUjPc1dLmb4eGGb3ORdXHf7Ato0XK8MzC59PKbKaHFS8EsGOvJyT7LN?=
 =?iso-8859-1?Q?YxketL5o/hJEowDpzeQbyEubJuADN2OcoMSpDtKIY0AoSQajbdRAFZFaT5?=
 =?iso-8859-1?Q?CiSG52atsoPBwnd706AvqwIjm1XmAQBnjQq63YRhyuMSJwb/mqQWgQJh53?=
 =?iso-8859-1?Q?Cg5OhXRUjlmr1gOK0ZSTHMaBx5d9Ouu1Dz6onN2xTNA68F2iAR0sTTUi19?=
 =?iso-8859-1?Q?V2eEwhAqc9YCflsZWjWkopOHrqs+hEnJmTO+0gcsOT9WVvTw78gluqhs7a?=
 =?iso-8859-1?Q?1BlPGsn03a4MPjHqtHsA4kSjRwduXCgLpStinOF+CcVMcMZSvky5+CLEKk?=
 =?iso-8859-1?Q?50g4K+yP4OieMrt9bE4dCJ4f/nkVryPmkvFd8qc5zeIDp1ENQDwpRsSXWA?=
 =?iso-8859-1?Q?DjDqLr54r88dzsCJ0iPdP8MV43h7UTVR2dL4WwV0E/3T+7ldw5qJBp+9Xz?=
 =?iso-8859-1?Q?j7aqgU/yC34XisscrLhn+bJyr6dJziSnUMLiT/gANHpepzSStCv1QzRSLk?=
 =?iso-8859-1?Q?DmtlyF+tqM3WGrfzuh4cDjKGpDGA85aQxtQ1/edz+fNhln+kraxUbDQQoi?=
 =?iso-8859-1?Q?dMwYXk44Z4CnhDC61ZQnkbHaDD7npmPLZY/RoKBlvyuUBf2Kww1Zpvufrc?=
 =?iso-8859-1?Q?NnJGq6DYkDz6k26wx/rdicsZa/oM2eXpMS/sPbNYa12+n/W04KdP0tmksO?=
 =?iso-8859-1?Q?9j0Ue2JukRkhlp482+Gr8BF23jGbP8Q78t0tydt1y9bmFObUCX44H6jUyi?=
 =?iso-8859-1?Q?SpxxoyGilZ57cg/JpjLa2tEjC75MZVWRIGcJbANPSwdn8fqVsHChn1+ziL?=
 =?iso-8859-1?Q?YRbA6VntVW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2854.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(1800799022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ijI8F0ir1Rky3YBIws+PmUje1eLHkgLDUV56q0Th3lSyCbMj1x7LmjfOJt?=
 =?iso-8859-1?Q?VLVIyVZG/L7123xnIfm6bhwfEwaH7wv8iG6ZwA1Hv5F6O1vesxGRYG8uy7?=
 =?iso-8859-1?Q?5QpSlf8yZZYxqAwCNn2C/Pezk6BPPFztsFPLMKwr+UTYogDFt/pN/FuH+w?=
 =?iso-8859-1?Q?UHUCayeWDBdGI/OmThbd5F9xQ7jerJT5fQ4Glr5UuA0YtucSfrpUEsGxlx?=
 =?iso-8859-1?Q?NIry0lwNrynnH2yFEciBkvKnfYFBgUp5u4Pu1q8S5gWEWfbk8oLkHNZvzX?=
 =?iso-8859-1?Q?ire8O2I5VqPcWWoXdc6Y0o7Wc97rrCbDHyJ1JGSMOoKn/W/zvCb3f9f+Qt?=
 =?iso-8859-1?Q?bIgzyEf6Le5Lu90ALMShdKIxugrLAg2xtZl3icw4u9sqvsD9Q+toTZohMJ?=
 =?iso-8859-1?Q?e9b01SZ7QVX/NTgZFYYVT6h9ChKeX+27HiFtdmmzw5ivFBugmRggtu4tKj?=
 =?iso-8859-1?Q?LG3h2+/yfR4fV4UUST6v25ODFvd/zJBVPwCKDnrKvyi1X2AMUC+Hc07BxV?=
 =?iso-8859-1?Q?Fa6NmrGhaUIy4YSCvHIRU0HJYmvXrYWUvWjB7CRcBChz2dNjvX6ZeEPWUi?=
 =?iso-8859-1?Q?7U8vRYKt7snIE9AITXW+ek3JFs4gkOdm4Uk1PbCltqxeohlYMx8OIysOH4?=
 =?iso-8859-1?Q?9pqIIi/0dLSWHLbk7CLYO8qp8cCRmCvstn3KvQY+UUr815VV9SMjDk7cgN?=
 =?iso-8859-1?Q?tTqgu+2U7bMaN9rXal8viV3CUxwbVunOnU5yYDJNu21fkRB5DvcI1imiB6?=
 =?iso-8859-1?Q?w4e4Rv/Pw+YCruRibiZRMkFdVn1oZh4L/qoTE71E2s86ZdouMBNmS3nwZx?=
 =?iso-8859-1?Q?Fm9oCcllf0Q/F/Jn3kPzus/UYMeYWcCRQa11P2STay/Lz8VddGk6fT/5Pe?=
 =?iso-8859-1?Q?KNtT+3nNJ7er2cd8kZHygRAkxp+VHbWw/NZwlldz1CxqifRXRMA4pD0gmY?=
 =?iso-8859-1?Q?AFFPCBBeTTOJ+BWUCGvECTuyyr2dZB2fIVjMN3NHr4yvLdDp7vH2zfIYlD?=
 =?iso-8859-1?Q?7fL4bnqKOcLf726LRYV+rldiQ4P9pWXkt5V3QOSPguhY+KN748PK98IFa6?=
 =?iso-8859-1?Q?YAU4QOAFPPQasJmDKjkW5ipW8PIR1zQlp8/JCXGu6fQumrdEPEKtYM1Op+?=
 =?iso-8859-1?Q?bcvh+yBvnBDBmrGZUytDB9fL4QE7yHyO/Xv4/sVQru4UvvX0x8rDSPU/Ng?=
 =?iso-8859-1?Q?MI3blG4yMJsZoppC9v9Xf9rxbQ05u/S1uvCucCSqKioXv5tCxz/kJXpvLz?=
 =?iso-8859-1?Q?4ks0iFf0eXdQ7BSUs4l6Z4nhLiv9vZBCcOm1o7kXpHT9H0ZBzNq20MJ/h5?=
 =?iso-8859-1?Q?PvH9WWzMhtGA1ZyRUwzilTxYPoKLjty2ltGHLg56MsMYDhFtZ50lMg53qZ?=
 =?iso-8859-1?Q?zIqPYecaja3CmJjyKN+YvFyHEBx+7KazpQnreEzuE09Ih6ZatTr/u/CBhi?=
 =?iso-8859-1?Q?OyAzBBUnTwMryJ/ZqGdTWb4Ije5MjA6bVF10kSe8Qorqbs+TKNTRVy2nGP?=
 =?iso-8859-1?Q?xTnR6OOQ4tr1+XaT9x1zpY12xEdSu99fqV/FYlMir/feRhU7l2Yn3gIv9S?=
 =?iso-8859-1?Q?7oN5Skd486Or1hcQgNhKBgufYL5p65lyBnOSVW4u+UliGn85QJTo7EDx+l?=
 =?iso-8859-1?Q?UuET7NrXrRApk/sX+GlKraxylGM2T7VWpl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb72f45-b828-494f-44a5-08dc95494f0c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2854.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 19:02:07.6150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s/ooPTw/6Bc/SZCgkz2toOI4qnx5k+sI18bFnnL1FzP6+Estpt3CXSZXPpkSn3Tl+B7zUSPqzbKc7uwiaZlwnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6496
X-OriginatorOrg: intel.com

> > >> > 
> > >> > > > (cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
> > >> > 
> > >> > Would help out here, but it doesn't.  
> > >> 
> > >> I wonder if there would be a way of automate this on stable scripts
> > >> to avoid attempting a cherry pick that is already there.
> > >
> > > Please tell me how to do so.
> > >
> > >> But I do understand that any change like this would cause a 'latency'
> > >> on the scripts and slow down everything.
> > >
> > > Depends, I already put a huge latency on drm stable patches because of
> > > this mess.  And I see few, if any, actual backports for when I report
> > > FAILED stable patches, so what is going to get slower than it currently
> > > is?

My thought was on the stable scripts doing something like that.

For each candidate commit, check if it has the tag line
(cherry picked from commit <original-hash>)

if so, then something like:
 if git rev-parse --quiet --verify <original-hash> || \
    git log --grep="cherry picked from commit <original-hash> -E --oneline >/dev/null; then
            echo "One version of this patch is already in tree. Skipping..."
	    # send-email?!
        else
            #attempt to apply the candidate commit...

> > > Normally you all tag these cherry-picks as such.  You didn't do that
> > > here or either place, so there was no way for anyone to know.  Please
> > > fix that.

I'm afraid this is not accurate. Our tooling is taking care of that for us.
More details below.

> > To be fair, this one seems to have been an accident. The same commit was
> > cherry-picked to *two* different branches by two different people
> > [1][2], and this is something we try not to do. Any cherry-picks should
> > go to one tree only, it's checked by our scripts, but it's not race free
> > when two people are doing this roughly at the same time.

Also I don't believe there's anything wrong here. It was a coincidence on
the timing, but one is
drm-xe-next-fixes-2024-05-09-1
and the other
drm-xe-fixes-2024-05-09

both maintained by different people at that time.

> 
> any cherry-pick SHOULD have the git id referenced when they are
> cherry-picked, that's what the id is there for.  Please always do that.

Original commit hash is 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de
50aec9665e0b ("drm/xe: Use ordered WQ for G2H handler")

drm-xe-next-fixes-2024-05-09-1
has commit 2d9c72f676e6 ("drm/xe: Use ordered WQ for G2H handler")
which contains:
(cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>

drm-xe-fixes-2024-05-09
has commit c002bfe644a2 ("drm/xe: Use ordered WQ for G2H handler")
which contains:
(cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>

Perhaps git itself should be smart to avoid it since the info is there,
but unfortunately it is not. So probably a script on top like above
could help us to minimize cases like this.

Thanks a lot from the support and patience here.

> 
> greg k-h
