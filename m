Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B84B1B7F4
	for <patches@lists.linux.dev>; Fri,  8 Aug 2025 14:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754661737; cv=fail; b=kZeFwab0oE+ngfvPbLugm8fML36mqEm+OY7ZMmM8bryMe9ubPLsm23DQyuPeUT1wW+FFqb6DNqDn5hrTkRJ8ldT4X/KFmHkcmNM6PhykOdvGI9WPsRe0RdnyCKQ9pCVmLE0QkQ+DwtxaX8Ksq89Bx0GB3gZdsBOXWcyaffxRirM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754661737; c=relaxed/simple;
	bh=xLQq2mkdz97r/KJFCN5AkatIOUzCKXW1T2gxs+VLAHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jzoiZ+Zu+ix4Tp6fk9L690F7j9C/WrL9rjFnVbdBUwIteAONYShZhiSHm3bMxlCc+/2e4x6c82cOJQD4RY6yFmoMK7ueZVwkVsDBji9ge+n6GQ1Uw8D3Y51SRbtBVrXUQM0Fs8XvWPhXPwsk4A8rnKSntc2RoR6/n4TsQLuVAQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LxtLSy5v; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SbeUXVOW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LxtLSy5v";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SbeUXVOW"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 578DNTEi014746;
	Fri, 8 Aug 2025 14:02:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kYXVz4j1B2D2mJUr4eh0Kko9qslxutVlYYrxYB0IiwI=; b=
	LxtLSy5vRejPbVzwnwztFoc5kdy7um0Wz07N0WG/fLbpCoLKFM2fEaj/yuFIBSwC
	od2yh+LSeNln5g0QDeqGhLN8TEOCxN0Ti1Af1vfHiuUenog1dEA/Z6YBHxPR4EUC
	jC1cFamZm5PjxiqJMTph2mchwv7NopAjW8nvtnvkjKXVuoCpwWQGMBk1LqI0RM8w
	/0AQGwvFtaI9Idk2EbZ8c5paXsVxoku8zOc9hBSO7p+Ko/zl4A/UFU7k0DGsoZSP
	RyILefxJODdvaFbS1ivnzCkXHTdMSYAQlAlU9VibIwpgrIuaSeicwU1Y5SuTZhaH
	t1S8JgdCa3Wq+64+6btTaQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpve6buu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 14:02:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 578CrUZe028172;
	Fri, 8 Aug 2025 14:02:10 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwq1721-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 14:02:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AO8wQluZeIRgRFTQMjZdzmDNkiWG3dT4Om81yj6yUAtc7RZBl2H94dz1apQthvzt54+ja6mOi9xSKl4FIT5CDyDqCYIj4zmgJb8RS037TCeDHBwQkwD4R4mLuRaclTD7UXcUHzOfy//aaEh66MqBn6Z2zzNe7x0XKG7lP7cG8JpCAj9Gsmc4+2zGOzV3cSPG/q47tImeIXXHQ4bAQYmtFnf0eQkeEE4esDjcrROgHkLhS7R/C/3lZvQbiym1fiZaj2zsM3KGHrtduj3GGSkwE+zn/NmO78OIBVfYL2PQu6zumMjPcp3DwJU6akhUkcOIPhqpac/gC2AgCtAWCoZkxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kYXVz4j1B2D2mJUr4eh0Kko9qslxutVlYYrxYB0IiwI=;
 b=xMbqZ6Rx5AuXwuKthxZnLKXJ2fVnrivcLNKBo84I5VXZjg41YUhGfPB+PI1k60orfQ0Hsa070bZ5s3DAjSnOmNvv7OK+msFTqZXBxGAUXsWizVJfY2dcUfXggchPB6E+stXACZyeCzY4Y6km868+uo+FaqoueTpV59nX9rQHai3nUXyor9EZ5TzUr/BOK8fw2DhlHMhJv+mDO+O2WKbKWhgyy1BRFggAJLFcviRoeYcG8DvyvsHFROX8Gux0t9uWfGd0nadxWjWlMHpDOi+QU4EyWalX43qUV+IF4Aegh04M9SxH3/3zUZ/LcWSkwd1KvOQhUTu8sYXa31UBSRPPUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYXVz4j1B2D2mJUr4eh0Kko9qslxutVlYYrxYB0IiwI=;
 b=SbeUXVOWjA4zco9T1g1FcQoOulnjVXtn40z3uDY39Dy+ob45ofk1XECSJxrwwrxre3QdXNXKZZdUbKBfN/jtrS8MKcmfZNlFK9YXuwiV6FwM2k7+P4nPKT4sWp1CwcUf4LM6LQt6k4xvMRxfA2E8BEqhSRfg2ZhHkWJR/mFw5p4=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS0PR10MB8149.namprd10.prod.outlook.com (2603:10b6:8:1ff::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.14; Fri, 8 Aug 2025 14:02:08 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17%7]) with mapi id 15.20.9009.016; Fri, 8 Aug 2025
 14:02:08 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: gerrard.tai@starlabs.sg, horms@kernel.org, jhs@mojatatu.com,
        pabeni@redhat.com, patches@lists.linux.dev, xiyou.wangcong@gmail.com
Subject: [PATCH v5.4 4/4] codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()
Date: Fri,  8 Aug 2025 19:31:37 +0530
Message-ID: <b7d0379dc05860dcc1b901da015897993a9ab872.1754661108.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1754661108.git.siddh.raman.pant@oracle.com>
References: <cover.1754661108.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXP287CA0017.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::35) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS0PR10MB8149:EE_
X-MS-Office365-Filtering-Correlation-Id: 673fb81b-5096-40b0-3ebd-08ddd6842977
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P5+xXc24e7Or2ddqKroRgS9gy7RN9Tv0VwGYIzOso1rYCJ88F22m8jFLekQp?=
 =?us-ascii?Q?8aQ55pAoqiXvrNkz4iCrQdqGUg80pu3KlHu3bdtcRs3ab2v/XHA3MrtNIXIN?=
 =?us-ascii?Q?OFLE7qD2ASZswhc8m8r92H0W/wA/HQMXi7X4cqYahyYKOCRkEf2Psf4SFRUC?=
 =?us-ascii?Q?IPCd4Vd7Pu0aCWo1meCGZ1RYzfqVTWdJj0Gb0jHRdpVt/Ia6KghY2pQPL/4W?=
 =?us-ascii?Q?IyeqrB/d23f6hbUNEchMNCrCIjRHtS2QiVGUuMNMfMLmSnzKGP9SEJ9KKsl6?=
 =?us-ascii?Q?nceSvurqvJAr2wSM8Qo+Z9FUd4qEY9QQe4DtmE+7HHQFv86SAVYGmH/bM5zz?=
 =?us-ascii?Q?IdnSOSDj8maza0ayXq1dtR6Grv5sxf0M6BKlacms1p3dSMbcQCDSfnUrSf7R?=
 =?us-ascii?Q?ZB3f4Gy49YB9IOB+zXXINTvv+SQcZ1hQYUpZ3ikukFh0sR2gpCwWCmO+4vB6?=
 =?us-ascii?Q?zFEBCE61qcjfEcySumU5X+LfWR6GkxcIjFWwWdyc0yefaVLm9JnA9UYXkOcD?=
 =?us-ascii?Q?W1Miw9lJEP1ykYR4V/F1KlH2HpwJ43hDOS3K786jvP0QBPuCiZAGPqezW7rz?=
 =?us-ascii?Q?wT8ZPxqwTla2FLDO8s06W2nfqSTYgoEb2IPwZKOCDFB2Pm42of5GWmQSySve?=
 =?us-ascii?Q?6O5m/gUeHPpcWoxmQswPcgeFXHbYmFlZFoQCebeLkI3cfsAzfX1PMpWxysqj?=
 =?us-ascii?Q?tENp8tiLLcr5712GxwpOQNNvu5gu/+t3WXfKd4DNfzP45CnGqq8txvrqTEfM?=
 =?us-ascii?Q?x1lAPGaEQaAJ+Z0pU3DhcYG1UbptK3BdqquseDzYKg1eg7JtB7JSBg3FrGZO?=
 =?us-ascii?Q?jSJ0c9TXkA56cDm0Jvf6aCcbLTUGNr/nRwdwNHtX7WJcI4pf2V4FwAiI10iK?=
 =?us-ascii?Q?b4HA94HGN4jY7VHFgHzgjcAakwGzqlDdo36ExocIjiEgRIQvbeOtUB/YkDgX?=
 =?us-ascii?Q?126I8wAz6g/4RhILUh4ylxudLl/1DGFHA0C7IIHH9Fo//OaLtc/SvRNuzv6r?=
 =?us-ascii?Q?5gs4MvY/nBpfJIjKENNrfQqcCn//pwwnyNEPggLKN4lcp0vEIQZs6lKNk/0n?=
 =?us-ascii?Q?bDNtPTty9PBQndZvhGOMfWZUzE8mwqSCnIQtXtHtKVxldu//3IAWDs6eGu8e?=
 =?us-ascii?Q?LSPPsUifgSVlh6K53R3bdPudltNZbq1IrDEcdfc2p125Ym3KhufGM4bOkc+Y?=
 =?us-ascii?Q?FI5M11bAs/fj8o7ePK58NJ8lnXVE5uv1vpXPi0bPXynJ40Nz/yO2nVShg2wW?=
 =?us-ascii?Q?47nqf4AtgMmOTAyHvPLQmWsEcaCv+Foo3kucRKeEAXkMsVqymQ2ctAzqMACI?=
 =?us-ascii?Q?V9vIIt41ASKNbeeGvO9QIxQ69bBCbcJr0aNieAALZATB/1ZS3dEn0RKXVf5v?=
 =?us-ascii?Q?Va+Duag=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rrkgHMKV8fwZS1uhijhhN+akkaR7Ooq91H7XeuGdEbZrAE2Fyr9XAheK4pDn?=
 =?us-ascii?Q?Y16kn0Sd4Evpydoj/wLpydCewahM71BjxwgY6Eyk55zbWAajJGrOGFncA2Ik?=
 =?us-ascii?Q?9vRpQIte5tZAhrfaqZTMFvCUw8sN/cTnajhkNESWm1IVmr6CQDDK9AeCHZyk?=
 =?us-ascii?Q?F6auZnD4Kt70KWIYrxnl5QdBWxPWHKhEFJbbJDy1SGoJVxG2UINkOSM27+iP?=
 =?us-ascii?Q?DCpi+tSU/IKqredjKFgRtqlHiVkTE215e+TuahAFDJEhnGPxoUkhMvJcj/uZ?=
 =?us-ascii?Q?aFjhi+c4Y+A8dcX/4SmjnLJJSkwWYTzn7QyH+tsXXhiBVw6iEXrmMUA8fYYu?=
 =?us-ascii?Q?81lPhHPlJmzkSicfsKHIt/nzAZ//6igxKJdJaohgPyWwQ7AbZnqRaHFZ+40T?=
 =?us-ascii?Q?FDTT+0UfUHwu7TqkQaLGcuSvQMcq0GBe79sr80AMEpgnJdJJOg78CGLjoazf?=
 =?us-ascii?Q?Xw+7BjWDbpx0r/v6u3p77VdXBvWtMtpPtrTUa4HteKpdQMpdYFLQOMyBE/yP?=
 =?us-ascii?Q?wBY8uDlGZMLInYdI5ZUAaJAWidn/TXT7KXykA/E8Zn6xEPTZF84hBYtUS4nM?=
 =?us-ascii?Q?2XkUsSqLX5+cbe7FLNldKyZETEACVH9FTcGzq6lwJ88qD1lSjmS1pXpRuDtb?=
 =?us-ascii?Q?HhIlrbacj72WqF5kRZlGDVsndwvGSLK6GhkGpHTWuNBMQN08kQxM8FDWDQlk?=
 =?us-ascii?Q?6C8slEO/u3TI4seeoDxtvYijX27cLubL+F2/QWQOVxhS+M3yTEYm1UbAvEvK?=
 =?us-ascii?Q?pzoZpSndJa+H214pavbfo26vbYqLrKHwrAP1j+Gtl1HqSnrVd50SEensV8wp?=
 =?us-ascii?Q?RXqQkqNCIonklqBRCzpjbatyGucQ4g2EmeQXJK+jvFUmkcJ2PlIMGy6QvWcg?=
 =?us-ascii?Q?525+//C20LheO77KfEieU4Ax01PYMvsaTUcc4oMw4391wqgXgGQKAPbR48NP?=
 =?us-ascii?Q?k065fvNYURD1rZ5IfBQI+oIOvl8uSUi9xzcMiD+NbX3mJ67MMc+Xa+Pl6LNU?=
 =?us-ascii?Q?R/hobESaJO51bmguG3P8SEBCXwf2Vlr73dw7FKA40Hx1H+hGpfPwS1k/NMjs?=
 =?us-ascii?Q?wM93/I2ZP1QXIfGcpn39uy95xEVhoM1KBe9a+3pvoMh6R9dJKl1dLBwdUvTq?=
 =?us-ascii?Q?q/cllQr+avE0RG05Tnib9T9BScNI1ToPgc4F8U7skNpoe1pDnlHzKcb5qRTM?=
 =?us-ascii?Q?cT0TKrY+TPUQcPYtSY2WsMgGFpZ4DuCJz0mkpkpcgP6S+lUVuKz+Wihb5AWh?=
 =?us-ascii?Q?TjUQJ4+cnxeHMipB7cGwp2z16sE89NH5bj7MnEpH3BlSjgvGV/v+RlMsPt5t?=
 =?us-ascii?Q?az0NUz4QEPKrDoesJq+7WaPf98lv1JoP9jU70iO+zUhF8jVN9egHjGRHUPPw?=
 =?us-ascii?Q?v8XXFb4OhKSMTkgjvYzL2q32r0tN0/zjVs+QiN7ODftsIeK88TIMCljdG8M0?=
 =?us-ascii?Q?wNMH6iiCAiW1RxIUdBFyRAkfY7+4h5WQtxhbKl/iECAuIEzBwuJMuwmHYunj?=
 =?us-ascii?Q?H4BcO8SunUYjh1+EATqF5iSXPaUBYSPEIzxHjSjKDDnEmYzvwo1YapP/b7i+?=
 =?us-ascii?Q?6yWgRrcOKaGRYv0oNcTesQHXxvHwCPDhQSY1rEoHst0eH6Tty3A5CvAYRj4K?=
 =?us-ascii?Q?F3e34q2rfJtnGjY89/3OQf1WnPIbEJ3R2IYgrK9QCeO2sI53QV9DMph6NNzz?=
 =?us-ascii?Q?s6xDKw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZNIwKO1dg+RwYXGQdANFO/7OBMy2UNd7IZPrhiBHDd/q3YSQ3LTMliF+V2nH/sx9qTBYpxwzbAj+6IobzTsS2gyMaSAZUDuv/Z4KKhfFJRJK4ET75N3J6GELKhLmAboseVTgBsng4X9F2VaKABiBp8S5qVPn59Q0gKWCxOSbOZflgLnZ9R0RMSWgnIcWhdW9aEl7azI1jy8MjvZq4CLgAAlaaptdd+/3ry2wdVapArvtdt/Ng6cjTVP0zsovyySMyw9LOycez5N/NBPgvaYFnX2YuXFpzWLprqsWq+HUICzi35Qs432saNgo7SJYShR6Bf/V9RrL9RCQUAKw8bdYOI9bTqBWijbpuDxh5HLr56s18Fi1TlkHy7BgfT8GShnknc6+USHXQfTQyWt2MXUzV4ER8w08a3Bk9sVB0I8FCawQzKYqJYsxGMT6Obm5T2qVDn7QyCQHn/ngnMjhV0T6zFw0pGJFhxmiyTAhHs6Kmq4oBNf1737I/xsgAfaX/dtoYAKJAdqSnXrYPpFJEzZ2IT3Fr+j2DVixi3qw/9ihB9pMOIWxgN4CTA5iLRNcRuc7PmkM+Xq60gTZeAh61rXLzhfrTdv9MJi3sWHIkUNNO5c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 673fb81b-5096-40b0-3ebd-08ddd6842977
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 14:02:08.0176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xes7etLel7l6+7AAhZ68JhJD7DRyZEOpd9QFWurBYhr4GuypJqQgtq2CNWcFqo7jr2F0uyqr87Eyd85WFtY2ha6xJVYZ8v7xFoOUhAv099I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8149
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=970
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508080113
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDExNCBTYWx0ZWRfX4PSrTJfFS0Uf
 asr21RApfAOxUQuq3bqUEmIe768wsYdXcxV6x78Dr7LS3cini26jEoo23TnvNoUcRRhp+QMHkvA
 l1znC/eJtLZm9QrNwMUUkdBbnZyhXEmp4dzksRn2y/9REMlh9/BhG4Uo/hwv2g51SNpsbRQDRed
 s6Oqk7+xjiW54mBuhJbqQgd3Ol1cXJ/sd20qo6l5P8G/urBUV3lgaDkmenRIPYmIwlBfX/6GRTd
 MqWhOmejk1SvhqxknuTTyANw+FFEHuHUqMSnUVjOg3v4b2zG1OIawXToOMjnFvJSKOZ7O6iJ2FX
 qzu9fco0JyFE3F3Ic58SoO5pl96KTFkV/dDDKVndDlPPMNEmBukb3gTYPTV5NTsGju7NQyb6Pjd
 KW/1hkOxRzfpfGV6aK+PSSbDVOw+oxqIbz4qfqFR5UNCmdE2FQhs35N/ogdMOHo3OvGaXcRS
X-Authority-Analysis: v=2.4 cv=ApPu3P9P c=1 sm=1 tr=0 ts=68960363 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=A7XncKjpAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=PIUe620fHybt-iPp2eMA:9
 a=FO4_E8m0qiDe52t0p3_H:22 a=R9rPLQDAdC6-Ub70kJmZ:22
X-Proofpoint-ORIG-GUID: WCI5WAg6f47pBXe-2D51Ia3flIoygSub
X-Proofpoint-GUID: WCI5WAg6f47pBXe-2D51Ia3flIoygSub

From: Cong Wang <xiyou.wangcong@gmail.com>

After making all ->qlen_notify() callbacks idempotent, now it is safe to
remove the check of qlen!=0 from both fq_codel_dequeue() and
codel_qdisc_dequeue().

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Fixes: 4b549a2ef4be ("fq_codel: Fair Queue Codel AQM")
Fixes: 76e3cc126bb2 ("codel: Controlled Delay AQM")
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211636.166257-1-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
(cherry picked from commit 342debc12183b51773b3345ba267e9263bdfaaef)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 net/sched/sch_codel.c    | 5 +----
 net/sched/sch_fq_codel.c | 6 ++----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 30169b3adbbb..d9eff03deada 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -95,10 +95,7 @@ static struct sk_buff *codel_qdisc_dequeue(struct Qdisc *sch)
 			    &q->stats, qdisc_pkt_len, codel_get_enqueue_time,
 			    drop_func, dequeue_func);
 
-	/* We cant call qdisc_tree_reduce_backlog() if our qlen is 0,
-	 * or HTB crashes. Defer it for next round.
-	 */
-	if (q->stats.drop_count && sch->q.qlen) {
+	if (q->stats.drop_count) {
 		qdisc_tree_reduce_backlog(sch, q->stats.drop_count, q->stats.drop_len);
 		q->stats.drop_count = 0;
 		q->stats.drop_len = 0;
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 30796bb54972..eb380b43d52c 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -315,10 +315,8 @@ static struct sk_buff *fq_codel_dequeue(struct Qdisc *sch)
 	}
 	qdisc_bstats_update(sch, skb);
 	flow->deficit -= qdisc_pkt_len(skb);
-	/* We cant call qdisc_tree_reduce_backlog() if our qlen is 0,
-	 * or HTB crashes. Defer it for next round.
-	 */
-	if (q->cstats.drop_count && sch->q.qlen) {
+
+	if (q->cstats.drop_count) {
 		qdisc_tree_reduce_backlog(sch, q->cstats.drop_count,
 					  q->cstats.drop_len);
 		q->cstats.drop_count = 0;
-- 
2.47.2

