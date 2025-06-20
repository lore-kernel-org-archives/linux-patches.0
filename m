Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazolkn19010009.outbound.protection.outlook.com [52.103.43.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE32E30E82C
	for <patches@lists.linux.dev>; Fri, 20 Jun 2025 01:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750384235; cv=fail; b=KB0ANpHqz6MTYeaa+aUSrP3qitaCXMpw2x8vWG9iBfqRzZ/LwRDK7dWLmFXKaOMSVqHD3Bavq1neZsUwdAG+w5QVj6SnONTj7p6C28zQTk3tQ2w++ga69umKnIx8GUPCZZqFyM7T9SfIt+PPcuL5Mtj1x/GPUTW/VJBnWe08jXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750384235; c=relaxed/simple;
	bh=K9MUYYxL+KO+7kxTS+kjM3GWEQosaIX7H2/UW/gRxpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QHyOpGukfRHGRO+QAgkEUWFkNPb5sbyFsiTeLPmhykUu+kn4tX/Olq1oX87WRP1Pq0ThldC6hCnASoLiF5XnS5q/jtn6z7XQNXYv3uTi9HJbyNJn/bjy5H8NX9I/W3EzpwqVvAUNaEqSIF87wC+Agc2I0ui+awc6ttqljHwGLlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=boKDiNSE; arc=fail smtp.client-ip=52.103.43.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="boKDiNSE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v57dDDKSEva7374fiE3y/EpSWU/HYU6MlbE/BdOX8TRJbKDBdu887mJ1jGI31GAmYd1UaUDbTJjT4Jt3S3p81YHryGzbWEtZOs71cU9gqIUHPnmMH7SOIbEkwWGZIy+CcfWhsQjjPJpqyt0Z5uHE+ecx3nSRqH5OUf0M1c5bcDng5H7L1DEjf8YoGbCIow2fDD2bs9zKKF3jxvUUqsMDhk3//B/OjxEvopV5SH5pFtCrA/pK1v8LiPEdHsUtx5fmz5Nl/rFHKuxrhGhW7xW/j3+/RcC/AyPwANyUaQsVt7mLDGvdQwh4na0Y0Vy9Yu2fxIWVUAWJkP7ZEaNjJPeoVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9MUYYxL+KO+7kxTS+kjM3GWEQosaIX7H2/UW/gRxpw=;
 b=uYPvgde0j4SbCrNeYsp4BPWJp8TRA2TJrgsbBLgukV6M9bxIFnOZ0XAn7SC/0tCmeMXAOQGx3/NrDwIJoQ4jrsP06iAGw3Q9GW3E1mc/XbcIVrRAmDdWRZ1h5pQacrgFOKPJc0RCY6RgBzV5hAi+sy4Gs0fkKm6UrDMY8eYYa6sHAADoetcmEJSalpTtU3EI8h5R/C7xaqiL6t7NIddQQ4dcqQGd1DU9xUEHZWkRSmQWdyU88OhAPLR3V205lL1fitXzbHKDnx2+ryDERApfeTmjwEMS1Y/QUVS1NTlC0Q1uoM1iuH9Opu2Ji9ya1eMxh1tiDyS0SOlBGYciyXpzXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9MUYYxL+KO+7kxTS+kjM3GWEQosaIX7H2/UW/gRxpw=;
 b=boKDiNSEB/KQdDsJQgbCKXci1oJzPCIQXP4BXOWe/MLLFfb/QkkR5rKpjPmSMsAxamNM15r/WP2V0Ge/tiber115DsYrRqCo1jQQv/tQdfSTZfUltSs4DEz3P5Sisf3omDWFYdEgPbU5o9QahMc5rHwnb7YP//zemq9vJfag+wuZERr4KPHFeC1UmTM2qnY7lMhd3rlZcY2YTXOm8r1sYqErrZiKsSpJmSncC2nUHaVNHigCNZRut2gRa03Z4S44JzDFOFOdwf9QfU0nz0F+l50Y7/BK3LlvSuN3tf7lLFVVRmEf7RmiLk4qcAAlrJ/DRdQkYaTLmszUeLz7GpjL7w==
Received: from OSBPR01MB1670.jpnprd01.prod.outlook.com (2603:1096:603:2::18)
 by TYRPR01MB13770.jpnprd01.prod.outlook.com (2603:1096:405:216::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Fri, 20 Jun
 2025 01:50:29 +0000
Received: from OSBPR01MB1670.jpnprd01.prod.outlook.com
 ([fe80::c00:ec4e:ee7e:9b7f]) by OSBPR01MB1670.jpnprd01.prod.outlook.com
 ([fe80::c00:ec4e:ee7e:9b7f%7]) with mapi id 15.20.8857.016; Fri, 20 Jun 2025
 01:50:29 +0000
From: Shiji Yang <yangshiji66@outlook.com>
To: gregkh@linuxfoundation.org
Cc: jirislaby@kernel.org,
	maddy@linux.ibm.com,
	patches@lists.linux.dev,
	sashal@kernel.org,
	sfr@canb.auug.org.au,
	stable@vger.kernel.org,
	Shiji Yang <yangshiji66@outlook.com>
Subject: Re: [PATCH 6.6 025/356] powerpc: do not build ppc_save_regs.o always
Date: Fri, 20 Jun 2025 09:50:06 +0800
Message-ID:
 <OSBPR01MB167040F844BD2B7FC20686BEBC7CA@OSBPR01MB1670.jpnprd01.prod.outlook.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250617152339.250901739@linuxfoundation.org>
References: <20250617152339.250901739@linuxfoundation.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0010.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::22)
 To OSBPR01MB1670.jpnprd01.prod.outlook.com (2603:1096:603:2::18)
X-Microsoft-Original-Message-ID:
 <20250620015006.20879-1-yangshiji66@outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSBPR01MB1670:EE_|TYRPR01MB13770:EE_
X-MS-Office365-Filtering-Correlation-Id: 15c804a1-cc39-4984-28df-08ddaf9cd56a
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|7092599006|461199028|19110799006|15080799009|8060799009|440099028|39105399003|40105399003|3412199025|10035399007|12091999003|11031999003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Rav3AVE6EUYINawVEbQBmRr2o1pYfPX71pvzbyY+4ptCsm9ixih04bjI2+J/?=
 =?us-ascii?Q?ll286M4b9TjD748FNAWasrAiu6WSessikgmxi32/YiRqU9f1SXFLNieJdrw6?=
 =?us-ascii?Q?9gMqoSnCpK1G71AMCRhUBZ6pxxqF82TwXSl4r/jmlcPSiVjV7OVAR4DJdxim?=
 =?us-ascii?Q?lmTrOwTEDHDhT8s+bdI6UTaGAHVa++oYnT1d/QUY8TvarSV1BrhOOajsmLjX?=
 =?us-ascii?Q?MiBrJGFKNVkeRQOou7GuuRb4rqVIQSZdJ+Qb5bMOPOZNgFA7uqrsB0AfgLnB?=
 =?us-ascii?Q?yzdlBoa5AXNs1qS5xs8QmyOFJtagqRM0+AlVoyab6R3AXcde4TG8GOGhjWk6?=
 =?us-ascii?Q?6wHyUCd4GtFggWzz/0SvBY4GkmwJ9bOdC9Lw3Vw8y6ejnBuhxafN4KUlVGtr?=
 =?us-ascii?Q?UlwWnQnD+5wLvbbCGsCcNLFBxThnzCacuWXhNWEfN+FR98i2ZHCOZzpgjJ+0?=
 =?us-ascii?Q?a8nEqmibv12PvnvLkKRJr3gY+cT6DLAK7/uCKkImC7ju7zROwBrkdfbvW+2V?=
 =?us-ascii?Q?/BmOHFd3RaUxfHimkPtqzculEDBL9i8fhqFKnVni4m5sNOZ4xg3FDrgQndKk?=
 =?us-ascii?Q?TAHz/U8FIfbM9xDrQ7bpAMbpzM/hIEocxAj8BgCNFH2wBRGA9T/Uadg7A1Zf?=
 =?us-ascii?Q?N+xan23Ke4ij8g+Hut3s/QPHvpK07onkehdYILggim/fPbkHxGSiW3wR6pUi?=
 =?us-ascii?Q?93lHlUUv2OqfuMeOvqp6WDFmn7s2BTGvhyEGmmkscZeOr7p2W33vimaOLrZb?=
 =?us-ascii?Q?Bx8AlFzHk6ZaUonen3YzUaQl+yx1XWibhN3MdfUZCUMZGbCL3XVyLcbO0ulb?=
 =?us-ascii?Q?/VAcS655yCt2+tByVXxHKCTb3DkHy3li1qIVTG6WUA/l/XPt3yp2A9MMVhQj?=
 =?us-ascii?Q?49aPEF6a3bYYTGBJScfMvxeDSl7bCbBn2KnnJVQR7o61o+Kd9bLcszyqZWeG?=
 =?us-ascii?Q?UjJcJ6srBZbaL9RmFbftH6Jt8Wr4leCIRdJ4Ba/OwvVC0RdjF/GrxHyYJICZ?=
 =?us-ascii?Q?cumIbEIx7VfEMl/JmGUpBjZTAgDmSvNfex3FTb8E5Qg7ebJAqea0DKy9Krm5?=
 =?us-ascii?Q?FQJrNmJLnF6kz4eWD7wumbDtkRwBR9vm5cd1J9SYGMUHhp79p1fibd4xLNHt?=
 =?us-ascii?Q?DqXajtpIgCPDW2Ux7iL1zoQZOkKCGsZUPLljyd9M77RB70qcpwsXT9M4C9sj?=
 =?us-ascii?Q?smMVbOEn4wS1OpxCEhJk+bWPDdPIzk2v5KkjDr3kGIb4pcAOrav1hLebLVLS?=
 =?us-ascii?Q?MSgUuBJFmK8JYJPeiVnFtkdcNg9TZm6ur2aX1wgQHfe8t9sx2spo/vbAqcko?=
 =?us-ascii?Q?H49PsWxPmwWLXN3TWJKseMhd7wGnPv1/VQdqLvrxzHsx7rdsDt/QphjMGZjB?=
 =?us-ascii?Q?sqOu8snoT756wXeVxjpc/JXvXAjZ?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EWC8W9xj32nGi64/dhetWU9m7aER7eATq02GXf7fiMnFxUz4CxqBoK6HaHz0?=
 =?us-ascii?Q?JfyxvzXjyL1W8323eW+tlEhC3ndhyEII/DOb8mUwYLvGsllLRZh8QGFKZfNj?=
 =?us-ascii?Q?zb9U/+cFW/iW2juwOJbxftcx93uF7yqKAXXOJ5m9AVZQfK0dv5bvgM6OvlD/?=
 =?us-ascii?Q?uRjU3rsZwpRFGqs4AA4K29Xjn37snMYMG5OIZl2ORxY4/uDejj95K6OWVjZ1?=
 =?us-ascii?Q?Wrlb+dULgAbQYGQ02BPkR/3B3gVL108bhHfZm1LJZKe/HGqjnL8QRy5YHeqn?=
 =?us-ascii?Q?FnP+AOD5qsXPT+WVJOZw2I6pw5ZzmdHTI/ppno3b6DV+71O0wpVTI4SenSc8?=
 =?us-ascii?Q?u8yZ/MtVGBsUulR95xJnYhU7IL53yqCY5x75O+3Xq46QthT+mZX8b/HZ8CuL?=
 =?us-ascii?Q?W7Ob7Y0kbWi5v1bSLL+dVOO2iP6cLon/0jfXZSlzyCGiNN2BojTfjQwIpEup?=
 =?us-ascii?Q?AV5kBPerhTzeDWSXWO4DQJmIhTL9uxMgJsmSQ+pILDwVSvvivPYqP74Puh0L?=
 =?us-ascii?Q?KA+ysfXvPxSrEYFkUMXgb5oWUZSUjcxLMLhS2CPRDAFOnyCSSKpy9FT1NOSd?=
 =?us-ascii?Q?S8Db+H3qdWf47HnByexHAs7A3q/3cJ3YiS/wqJl1b2OXO41Fr0Bgc9YEDG98?=
 =?us-ascii?Q?5yJPBrPZvYsitIliWpbW5diQFG10SEjuWGXZJUSWfj4YnIv0wwaysukr+icj?=
 =?us-ascii?Q?BZFT1SlR5+8n2l4mrmTNJplhdR3TgEwotmZatQ8NpyR87pMw5TEPRZPa6MiU?=
 =?us-ascii?Q?Vqw1Bj/rytMi5SolWA3eFPIEH98ebtctIXjtA36oDMns5eyb2Qlk7lIu5mD1?=
 =?us-ascii?Q?KGWgxDseh15j8vHoEL4ka2BaQy0kSG3YZQ3kOO5yXTSYuvxAXFkzKjeNPaTY?=
 =?us-ascii?Q?dVVxrlDANrhZRG48OyNZfdommdyy03ucyUG3DKkl3DVni4/1JYh1hV++DzBX?=
 =?us-ascii?Q?yvTdjJtZVj2hpB075ndGT8pqdUVmkERSgHTlVXwhPLjQ1OV5uTq5YvzBU2j8?=
 =?us-ascii?Q?+c2yJFP7A1uA/Q3qiNTs1r13zitFJw2rKm+4VojFwK0ZY7BHVjLc0u/Sb331?=
 =?us-ascii?Q?K78ubyY1QMfe8cU4NBPJgvX6Rr4SGBWGwBjdoyx6GzLwkIbmO4cJTuILV/YW?=
 =?us-ascii?Q?YgrzYX+M080yu2QWXRQyqpL1ZPXAaI+qzUNAruLCHPmtQCqcm3uP5UbIyYzU?=
 =?us-ascii?Q?TOx7o6vU/BT9l+ESvP/zEQUl/uAt0CQ20VrIHIFQGipTvkfQzeiBMhzu+6Nx?=
 =?us-ascii?Q?smaiPUztjVvGa+m3rxDj?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c804a1-cc39-4984-28df-08ddaf9cd56a
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB1670.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 01:50:29.0511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYRPR01MB13770

Hi! This patch seems to have broken the build on powerpc. I guess
we also need to backport:
93bd4a80efeb ("powerpc/kernel: Fix ppc_save_regs inclusion in build")

Perhaps other stable versions need this patch, too.

Ref: https://github.com/openwrt/openwrt/actions/runs/15760870446/job/44427245071?pr=19183
