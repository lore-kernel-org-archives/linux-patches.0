Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0519E4685
	for <patches@lists.linux.dev>; Sat, 19 Apr 2025 00:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745022674; cv=fail; b=dhoG15VQ0XptiJ/wEniWRF8KWpf5goUmmWUoLgRA+WNW5WOWjZ4HTLQHv8tpNFMPjwGGYcfUxvNdmpbO8sypvWKyyJxzSh+2r+WIZ823tj6uB5FYXnKfozDxzqvBHkx5f05SITGg5QG7N7P4wnD8hBPIWGHTmfFvFD5BiTSDphw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745022674; c=relaxed/simple;
	bh=tE0b1wgoSxNW7xvB158X02BxIHE5cHE07pkafqVFiiQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jEvOZ8gLkjFptzf+djNeRhM8MqOHhKj/z6C1OBJVT57H/E3J96VWrDpCci5r5HjpmuNNYN9N/i5dfTUAY7F+se+IvHoTWe+xcOLrd4LSxPY3A321Mtw1RlMLD9a/QmfT/E47uFxp3k6XnTyUbIFKlAucsIlyfD47q/+XKF4FHT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A36pqmNp; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A36pqmNp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745022672; x=1776558672;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tE0b1wgoSxNW7xvB158X02BxIHE5cHE07pkafqVFiiQ=;
  b=A36pqmNp1q+2x+DcAv5WydZjVYWSvFVn0KkYyWPHDq33BDLaGqA8/t16
   jrjpKOXrlZLgP+OXkZyDoY0WFivnoqJUszBzfl88ArJdyvJ7f1elqSO6i
   G4xNHzSwcYXy6h/vMcmAQ6/2nN9KNZVLgCK76rcrcDBmvYDMFsSHMtuwB
   Xg+lYKXjV5KZcrRnXZN2CULeVmmnL0fzOMs2oyHzfjJQosbmgD0fXWPIc
   znBflj3mNPkAzvmAHvMFU6T5GdvaYUuaNMsuWNAqT+P6pZ0muF1Grk7VG
   Jn2zaYqzZrR9P2rjRrUghz1YaBarWk6EE4k+4xZCvvc7svvimfjH+Ui4d
   g==;
X-CSE-ConnectionGUID: +T5f6W1xRQeIvV0GRZ6+dQ==
X-CSE-MsgGUID: JsMp6kYfRCyLyaBG2d6tjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="64190679"
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="64190679"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 17:31:11 -0700
X-CSE-ConnectionGUID: I0h/2M7hS9W1qcEslaC/Ug==
X-CSE-MsgGUID: o7vO7b44QxmKAXXnxdzYng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="132131208"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 17:31:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 17:31:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 17:31:10 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 17:31:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rPWQGeUZgnhd5YInId1uaTxJ4737fLFB0IVCRad7Cx0O7hXsk7PyU2RpyfPe2RNtD3Uaw3JcxIABoZ694sVViZoeGoLFZ8rKwSJfJcFL4mFjHymtDib9sJVsV7LahqvJuporYlCr06JGyofZJcxxh6Ty+VcgQ4oP25HuVRhA7VRXTGOZVVorDCk/r3OdFuGMX5ZkOld5M1lAy9Wg4lrkk2oiJjjikzi+GuZo4ztQa7uM2iok9FtTcZPQU+m9+h/qoq0X3RkierBXqBHzF3cTask8OYOHFAdekvai/FoDXnwhUrwFHZAoBGr0KEMd0qgmVjPjCiCACwE9uXU/83kQCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZX5XxW+KAXUFd+/PXYNOt5O5bEyouyAXsGmwWXeCKo=;
 b=SQ7PyY/tre7IhEFSrkLPQylnGHwOc4pqLXEMnh1X9zQTzgFRAuuAFEEG0X6mWIhczl15rE+0h2p6ejvSVzi55jBGNaQti+7xwmfKpdj32xikHt5TZq6TdsgBWlEtLAeeG2V3bmHIVeFzuGwvrG4sHODo7zU/6aqPJw8cvZWM3OAqeBg1AL47qwLel4t4zhvbKxIhFtqrABQ4EkH80Y67UBW6BvLw6g3BvV09vPv0AvzYIJJBaEd5Lz73isLJxZKeCYJYq9xknUw3sA1oe2F2N7jWQWRQKU/C55jvD4tSdPR4fb/FH0korgH52POxONrori2Rl5WWFhWbzbyteGJw2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB4836.namprd11.prod.outlook.com (2603:10b6:303:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.25; Sat, 19 Apr
 2025 00:30:53 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Sat, 19 Apr 2025
 00:30:52 +0000
Message-ID: <3f152477-89fc-484a-bcfa-f625b6b630e3@intel.com>
Date: Fri, 18 Apr 2025 17:30:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/26] x86/resctrl: Second stage of telemetry event
 enumeration
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-16-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-16-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0012.namprd06.prod.outlook.com
 (2603:10b6:303:2a::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB4836:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e6d5029-db23-46ba-650f-08dd7ed9709c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SWlvazR3V0NzQ2M1Z2Q4ekJhYTZ2RjlyZGtWY015RW9OVGdOVlQyTmVBZUFh?=
 =?utf-8?B?RlluQmNuWlNjRmVBYk9VbkdKODhIdWpyM0dhQXZubzliZDR5Q0tYV0ZQNXdC?=
 =?utf-8?B?bUdla1ptd1JlWXJYRzJWaDI4cWdxVGZpdzRCV3ExOFc1VmtiVXovOWpEQ0dY?=
 =?utf-8?B?SVpsa040clByZkd2NEJ4TTdyL3VBSCsrWG8zTWJSN3BPWTRnN0JFYXB2d1Jk?=
 =?utf-8?B?UUdKVmZJd0tBRVV2OWxEampqZngyU2xXZzVoekxIUFZrUnpuOWVSL0RGeXFw?=
 =?utf-8?B?eWw4Uk1UVnNVMzR2OW9MOW5LNVhXNkZ6R3lxQjlIZTgrOVQ3M3o1RTNuUmNW?=
 =?utf-8?B?aVJkck1nY0xHaXFtYm12NUZDMTdzZmtWYXl4anN2ZGcwc1BBVTZBMmJZeCtJ?=
 =?utf-8?B?NVFXQ0phWjh4eHNmQkRvUVdyZzVmd2JaWS80bVhWNURMemtXWkdPTERseWxP?=
 =?utf-8?B?dEpvWlAyZWE1R0tFMTdBeHlNQzNFbEozRy9BcFZycGF1cDZhQjR5T2Z3R2pK?=
 =?utf-8?B?dk00QkpnZWFTcmxMTVdsMmdoY1g1QXFDYVlpWTJWS0RwWmk3TXROU0o3a0xD?=
 =?utf-8?B?OWRkVFF4MkJJSS9rbGNHclI0UE5qNmNSU1RSek1ESk91eHM5amZybzlNTGtH?=
 =?utf-8?B?akVhbVFuM3R3NndnUkRBSm9YWjBDVGw5bGtjVk9NYnhkMHdMK3MvNFo0dzY4?=
 =?utf-8?B?dnFvd20xSHhoTVU5Y2FwMlNOcFNwcTVGRndDS0daNmd4RjREbDAzQi9CYkJ1?=
 =?utf-8?B?VzBZN0Q0ZGFFR3h2VjJ0eGlaZVZxVWRVMUVkKy9xRFBWazRZVDRHSU42UklU?=
 =?utf-8?B?YTQwRDIwVnB3Vk5IMDNVQkVhN1BGcitNdnNXdkoyeDhKV2IxNDlnME9GUnFk?=
 =?utf-8?B?L0NyZ2VpaVh5a0k1cjV1WWhlanFSN3VDckhHY3VkdjlaMFc5T2tBTkFQTzVP?=
 =?utf-8?B?Smh6bFlwOGxEYmRBUW9qOEEyOXdSOXEycVBrQ3p3L0I3SWpHWlY2QzFlZXNz?=
 =?utf-8?B?YU0vVmU5ZnlGa0tZZnhvcXBVTGJSYUpjemwwYk1nYTV6REI4ZUlkdzdCU1VO?=
 =?utf-8?B?RnNqRnVFTmV3RFUxVnJFTlhrdldKcDhodFJ6OWtUVVBSQ1A0YmdTbFFydGRM?=
 =?utf-8?B?a3hyNEF3QzV5d2VtZkFKdGdxeTVMbkpGM2tBdDBaaGovK1V1L2g1OWNBaGQ5?=
 =?utf-8?B?a2hTVEczWWViMEZuZDVPRHd3TlFDbDR2T1k3Q3hQSjhuUFpCSmRJajFScHhF?=
 =?utf-8?B?Q28yUEE1VmwxT2RvZ0hzNVlYdE5RUHVjTDZSaTEzS2NiQUk5R3Q3cmRiWllh?=
 =?utf-8?B?QThaQndOY0FraTFDSmw1ZlhSbXhTNS9FTko1dkdBckprSUhrZWZiY3A0YmpR?=
 =?utf-8?B?U0RtQWRCREZhRXpWWWcyOWQzaUZMMHZRWTBSNjhuMjZqSXUyTlJ6SHZYclpE?=
 =?utf-8?B?WGVWMENtcjZEZU5ERWcrQW9HOUswbnpsZC84TmxPUkZxNmR0aTBHWnFYNzJh?=
 =?utf-8?B?YnFaN2ovajdleSthMW5HUE15U3BFQnFtRmxnUmduRDRQQmZGODlUaWc1T3gx?=
 =?utf-8?B?aFdPTjZwUTZ0azF4REZnK3NlQllhL3ZOZGZkcG5JSDl3SlAwQ1dHd2pqbVdw?=
 =?utf-8?B?MGxBcklKVE5aeFV0K1lnc2xzSHd4Qm9WeGxlaHhIYnhjM0dBa0F1S29yVGNW?=
 =?utf-8?B?dmlNL083bmdMbGkvL1pMYWVlYzdzY3BNdVZqa0NHY1BaM0pGV1RUSElxOFZB?=
 =?utf-8?B?anJqdTZ1YitwTHBUL3labGFLS09ma2ZnRnFreTNqSkRiL2ROS2FEYk0yS1Bh?=
 =?utf-8?B?azVzVkhwTHpxTlRCdm05cDgyMm50QUFzRldzbzdPK1RVczlpRDFDQmcrOHdk?=
 =?utf-8?B?RVZNYzZzd3ZQNWwvZHlRUTY4dDV2ZnhHUjkrOFhlNHQ5QVdoaEhtQy9LaGp2?=
 =?utf-8?Q?Lcl03I6fMqc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUExYnlKV2NzcjlpSC8zb1Q4Q1AxWE5JMlZIV0ZraFBtczlvMktZTXB4S3ZD?=
 =?utf-8?B?NDZiZWFoYUVYMC9aMGxwVVVTNGsza1hUQlp2TGZqYUxNdmVMV2dpWHNxZXI3?=
 =?utf-8?B?WEpqSk5sWU91S0h2NVEzQ0ZwM3NMRGw3MEp1RUZBaWpWQXF4YkRWME9Qa1Nr?=
 =?utf-8?B?ekkvZHlVdzlWVDI3Sm9kRmZHT0VHdDdNbVVVT3V0YllBb0dBSzgzbHFublF2?=
 =?utf-8?B?WkJRK3QvakJ3VWpmallRSGd5cmVlWS9zcU16bWRWN3dkYXA4cEpCc3JYczRI?=
 =?utf-8?B?eVFjSHpJa3VGYW9NMVVDL3NxQStNYVVBODFYdWtmMXF0RXZLbXg4SUZzcS9W?=
 =?utf-8?B?TWZUSjl2WGgvZHpzOVRsNElsT3pZZDRDUjVvYzBlMm5wVHAzQnFFSjN0SXM5?=
 =?utf-8?B?c1lMQXM2bS85T3lvWk1Yak1mdy9QN2JHN3Y4SmdKWDZQcHlwQ3o2NnBHT2Iy?=
 =?utf-8?B?K05PY2laUm11dDlUWmJjZWVmcFhlZVdYRTQ4K2xwL3RIVExyZkxha3VhZ0JC?=
 =?utf-8?B?NCtLVm5KWHc0S2E3Rzh1cDhRYi80ME1TRTAwQWY2Vk15UEhaSXBET0NhYjhx?=
 =?utf-8?B?clY3anB4OEgrZy9mallXRVl1NW9PQ0ZrNS9tT1lrSXRleWxZYUdrTDVGMHBQ?=
 =?utf-8?B?SENFSk1vWmxZNUdWWjdaYlB2MGhzZ0E5Z0QxbTgrWUQzKzgvdHBYNlhLOUpW?=
 =?utf-8?B?bnd5NndhRjNmdDBQZ2VPcU1pL245N3JYYTV0RklEZ3hwQ3M3c2xYT2JBZk01?=
 =?utf-8?B?ZDFTZ0NqNnArM0F1OCtORlhsbmUrWVo1R21DcGNiVU5pQXMvMEVSdExXeUJa?=
 =?utf-8?B?Mm1xeFQ3NFVXYzVHd0VnT1pGbjFCSng0ekduYjNsYjVoaUNPczdJOUdOTnhJ?=
 =?utf-8?B?bmpVd2tsR2JmSE5BUW5ZTzNNR2tjVjFXUnFUaUNzOWZidzFxajlNWlVrdjl0?=
 =?utf-8?B?VThENzErdUlYeDhtVUhrZjFycTIwaXEvZHdkTUNndFJJRitUeGd1c1pBak5v?=
 =?utf-8?B?V3ZJcVlnZUhtbE9KQTlVSS9MMHpyZE9rOEhpVGNnMEc5WGhGK0M3THlKQ2Nm?=
 =?utf-8?B?VWhUeTMzS282VmZhMWkxNll6WTd6Z09hWnRCbEhiOWQwUzRnRVlINnVIOTRZ?=
 =?utf-8?B?K2lmbE45RXBhTENZRTZDZVhHY25CZm1rN3VnMlNaTEl4Z3huYmlRUzE1Z1lM?=
 =?utf-8?B?UUNvdkdJdUJtKzFDWlZSYndMMnZ2U3hUTGZBenRJQXFSRDRlc25CODdsd2cz?=
 =?utf-8?B?bFNVc0lOb3d5WEk2eTlNYzc2REQ4MlUrU0RpWTV3OFloVUp6UWxqUVZSdDRl?=
 =?utf-8?B?allQSVl6cE84Nk8wOE9tM3FRSGxCSFF0bUhPVWlja0Fjb2lnYjgyMGJGdVFo?=
 =?utf-8?B?b2t3YmFzNC9ZM05KZDJMb3JSRG5jcGh3L2N2dUFyOE0yRklTcmQ0Z0ZiN0dq?=
 =?utf-8?B?YkdxdTYvTjJuQktoWURiRzg0N1k4Sis5RkhNK24vV2QvbDBhd1RzZGY2N0hx?=
 =?utf-8?B?OXpmTnpxdnNLbFk4MElGcVdDUGNLdkJLdC9QbjRwenJXdmJQcGV0VFNxOVJm?=
 =?utf-8?B?d3hzUUtNQm1tTFNNUHRyci93QVhQUkdQQ05DS2FmaEtqN2h2dHR1ZEMzK0lH?=
 =?utf-8?B?SW1OYStuV0IyeHg1Njg1UzFJYU1pTG51Sy9YZENxeHVhTDBGN0NuVlloZEoy?=
 =?utf-8?B?amtwT1YyNk9CczE0emFFcVU0dmRSc2JlSVFrYkZzZWhNLzBBSzFGbzYyM1VX?=
 =?utf-8?B?aFJNYi9McnN1OGk3VVVRY2NNN2lBTm1nQzVWeGVZZSsySXVnLzdTTVJYRWdV?=
 =?utf-8?B?RDAzR3gwY0FxNUJqeUVVQjNTbUFmZW5tNVEvZVVYVzAwUUNlcGgxZUtBdFpN?=
 =?utf-8?B?TzVVUWJ4L2N5U0pYbTBZWEo3Y0dCSXhEaTJxVkphaUsrTzhPblQ4cnRjWUhj?=
 =?utf-8?B?NldtaDN2VHV6WjlMM2p2bEVNQkgrWXRKdkdETWZRZzhBbWNXeXJSaUhWMFJJ?=
 =?utf-8?B?Y29sQWdscURNTU9PZkdqemhuRzJpRTR0MmwzZ3ZycWhXRlVoSzU3cDlHcWd1?=
 =?utf-8?B?ZytOR3lwZXovdHZPWG1LRWlGQWpWVUhhZmZ5ZXAxdCs3eVZ0NDV4c3hLT1da?=
 =?utf-8?B?K3o2UVNaODMrU1RuTGZQbXhzZ3AxaTdwSGphcU5ab0U0ZTIzOVhaQ1E2SXZk?=
 =?utf-8?B?dXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e6d5029-db23-46ba-650f-08dd7ed9709c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2025 00:30:52.0710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X9yjmmzvaiGjHShF2Dhhh98DQiw6yWBGeoHw4+g3y6nznr6ARWxBQk3NLqPX5MFM6CCYXjKuWRy8oY55QdSdsfWUeQvyfALOXbsw1TqOXgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4836
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> Scan the telemetry_region structures looking for recognised guid

Please add context before description of what patch does.

Also, please pick British or American English and stick with it.

> values. Count how many are found in each package.
> 
> Note that telemetry support depends on at least one of the
> original RDT monitoring features being enabled (so that the
> CPU hotplug notifiers for resctrl are running).
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 112 +++++++++++++++++++++++-
>  1 file changed, 110 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 8e531ad279b5..9d414dd40f8b 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -23,10 +23,100 @@
>  static struct pmt_feature_group *feat_energy;
>  static struct pmt_feature_group *feat_perf;
>  
> +/* Per-package event groups active on this machine */
> +static struct pkg_info {
> +	int			count;
> +	struct telemetry_region	*regions;
> +} *pkg_info;
> +
> +/**
> + * struct pmt_event - Telemetry event.

Why does it need "pmt" prefix? Can it be "telem_event" to
match telem_entry?

> + * @evtid:	Resctrl event id
> + * @evt_offset:	MMIO offset of counter
> + * @type:	Type for format user display of event value

I cannot make sense of "Type for format user display of event value"

> + */
> +struct pmt_event {
> +	enum resctrl_event_id	evtid;
> +	int			evt_offset;
> +	enum resctrl_event_type	type;
> +};
> +
> +/**
> + * struct telem_entry - Summarized form from XML telemetry description

Copying from v2 review:
"It is not clear to me how useful it is to document that this is
"Summarized form from XML telemetry description". Either more detail should
be added to help reader understand what XML is being talked about or
the description should be a summary of what this data structure represents."


> + * @name:			Name for this group of events
> + * @guid:			Unique ID for this group
> + * @size:			Size of MMIO mapped counter registers
> + * @num_rmids:			Number of RMIDS supported
> + * @overflow_counter_off:	Offset of overflow count

Description just rewrites member name and changes "counter" to "count".
Could description have more details about what is represented by this?
What overflowed? 

> + * @last_overflow_tstamp_off:	Offset of overflow timestamp

What overflowed at this timestamp?

> + * @last_update_tstamp_off:	Offset of last update timestamp
What was updated at this timestamp?

> + * @active:			Marks this group as active on this system

What does it mean when a group is "active"?

> + * @num_events:			Size of @evts array

Would __counted_by() be useful?

> + * @evts:			Telemetry events in this group
> + */
> +struct telem_entry {
> +	char	*name;
> +	int	guid;
> +	int	size;
> +	int	num_rmids;
> +	int	overflow_counter_off;
> +	int	last_overflow_tstamp_off;
> +	int	last_update_tstamp_off;

Most of types are "int" ... I do not expect many of these types to be
negative so I would like to check if int is most appropriate for all?
Usually size_t is used for size and off_t/loff_t is available for
offsets.

> +	bool	active;
> +	int	num_events;
> +	struct pmt_event evts[];

(missing tab)

> +};
> +
> +/* All known telemetry event groups */

This is more useful by not being "All known Summarized form from XML telemetry description".

> +static struct telem_entry *telem_entry[] = {
> +	NULL
> +};
> +
> +/*
> + * Scan a feature group looking for guids recognized

Switch from British to American English in same patch.

> + * and update the per-package counts of known groups.
> + */
> +static bool count_events(struct pkg_info *pkg, int max_pkgs, struct pmt_feature_group *p)
> +{
> +	struct telem_entry **tentry;
> +	bool found = false;
> +
> +	if (IS_ERR_OR_NULL(p))
> +		return false;
> +
> +	for (int i = 0; i < p->count; i++) {
> +		struct telemetry_region *tr = &p->regions[i];
> +
> +		for (tentry = telem_entry; *tentry; tentry++) {
> +			if (tr->guid == (*tentry)->guid) {
> +				if (tr->plat_info.package_id > max_pkgs) {

Should this be >=?

> +					pr_warn_once("Bad package %d\n", tr->plat_info.package_id);
> +					continue;
> +				}
> +				if (tr->size > (*tentry)->size) {
> +					pr_warn_once("MMIO region for guid 0x%x too small\n", tr->guid);
> +					continue;
> +				}
> +				found = true;
> +				(*tentry)->active = true;
> +				pkg[tr->plat_info.package_id].count++;
> +				break;
> +			}
> +		}
> +	}
> +
> +	return found;
> +}
> +
>  DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
>  	if (!IS_ERR_OR_NULL(_T))					\
>  		intel_pmt_put_feature_group(_T))
>  
> +DEFINE_FREE(free_pkg_info, struct pkg_info *,				\
> +	if (_T)								\
> +		for (int i = 0; i < topology_max_packages(); i++)	\
> +			kfree(_T[i].regions);				\
> +	kfree(_T))
>  /*
>   * Ask OOBMSM discovery driver for all the RMID based telemetry groups
>   * that it supports.
> @@ -35,20 +125,32 @@ bool intel_aet_get_events(void)
>  {
>  	struct pmt_feature_group *p1 __free(intel_pmt_put_feature_group) = NULL;
>  	struct pmt_feature_group *p2 __free(intel_pmt_put_feature_group) = NULL;
> +	struct pkg_info *pkg __free(free_pkg_info) = NULL;
> +	int num_pkgs = topology_max_packages();
>  	bool use_p1, use_p2;
>  
> +	pkg = kcalloc(num_pkgs, sizeof(*pkg_info), GFP_KERNEL);

sizeof(*pkg)?

Reinette
