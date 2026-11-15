Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794785454;
	b=WZv7IIvMq4ftRW2fj8ttkLQipE8AafXiOx/fLl2BLhBzguCY3uKOdUFUF5Ven64comdb
	 ixPdgxG0F1jb7wD+KolOds7l5f5epGmp56QNtENILNaPqdfSd6w9SrH3g1giB4E7dVDcX
	 b9UjS1iDEUlnRH5CgjgTs4D3ipv90bwnzt0zKmrrhUShK3C7WNaf0NILQeOHdE/e5CCiG
	 LiTlidCMFC3Yxw++VG31W6E1fkkxKTVKmCVCSy3Dx91mnz+KpaEpoW7t9P5aQt7ayuWtU
	 LW98W661eLnbQW2G3ro1uQYZGccdGTSh7le9daJU0b1BNWYq5OKIyCs7nBsGNiGytbw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785454;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=xyp1buzycIzqa8M+araXIBo295+MZBDKOqj/6Zt7Zro=;
	b=uUKM9301sylRp1MIZbRTrcgPcNAEYkBUTdWRXzZAG7jXF52Wzcyp3MrjIRa6fMXHTnXH
	 VajUF2x6UxRrkqqjDICD1bpuJmXD6n1YdiIPCRCWKLbKNCzPn9BNw4zC2U9WVLPo6cbnv
	 LRQAKCjSTFO08vYbKTQhtJ4G4/y1LBwaVc0lTftgO/ViWBp702NyHZwEfoPbyX3edHg6r
	 6+jXIHWIQokvFA/6HiIcsIeVx7GrMv9YXfXq2s2sI9OV7SuwN1SxvN21uAR0rQpgAkk9Y
	 Bfl0CCJ2yssgsiAe+NaaosuD/I311t52eIJ1GEqCj/wrBojrImlSTfCS3/DM2sz1YxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="pDC/xH8E";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.60
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012060.outbound.protection.outlook.com [40.93.195.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9646F606A31F;
	Sun, 15 Nov 2026 23:30:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9646F606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pDC/xH8E
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uUWE6h/Q9TGhqfXUkC3U8sYCyXOycR9okLrhDEriu46IH0NR2FuUiusuovPQ8u6dt12lTT0C5NHhMH5t02jK0XGq2IkPpWssup1I50zSXZBzD0uKUySh/UXZgkuDTr8wV5C3W/nuJatiUF439xkEd0As4sOvwjst9IhaOKEg1HspWxyBNHTv59FsiKaWisHUXFeAGQLxE/5gXG153RPgQvY9m+iPZRn6J/7zqfihARlKvUk5/ce60ufhlfQaeaxYCYgP2+JTXFKa6XoSaVQ2d75FHbw3gla/Etu/kZIdeDYzYbiOURjo3lNdEhqCAh6d9ZKo3yuCoUdryHFiZYVToQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xyp1buzycIzqa8M+araXIBo295+MZBDKOqj/6Zt7Zro=;
 b=fUIHZFby5AQfqFcA165OyF3c2mCEjPzC+ulTXidhBTYliD9fpiqThltUI/1E3nr/NyxU3eMKAYBoSNjrN7Yu46sj5Kj45Dc310lg9LI73TUYfpRSESB0HzMXouw9mTuM3MZ8Ew+68OI9SsbT4z3e9QD6UUfyWERFE7a3EuXh6gDvEmJMmMwea/DIZ7RUVrIaAabjO5c5iQUFbSLq/5DToIjH5w+OzPLIDQ2XNUWMfKaecKzVmc/1FefOoU0OrpHj4DIJrVbX0xGJ79wLHaj67/VVN9u2T97SUywmkf1xkOJDi4aSIC3Pqvg1IUTXm+PYPjwa7QlWyAASs48w2EeKqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyp1buzycIzqa8M+araXIBo295+MZBDKOqj/6Zt7Zro=;
 b=pDC/xH8E+PASeLlNSwnISr9/DNbRVbz3HmhiLWDS5dAFoQIAW5Ndgpnkho509FedkmzYlAv9d9JXStyWjZRLrlRVJdQqLngo+G1KwjmOu6tvEGJfr8za5w+KsM96CrkmQBWr0hoYGb21zwY0J542fBMzFHeMph5GQQ8C6JbSYXaTyrzAWMQIYnAxWn39sZ+XLwTicHodpJXIRYYFOKt5/DZuM5VG+rbEc0hU8OcTjAZaGYNy7oEyaNAVsG9BDDg8V3hpNGMGkRj46O/L3gNyW16SMQCiK/MRoVBhXY9JxJk0mY1cvGtrNKeO7r488CHDWOTgK6jREGiihkCZzb0AHA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB8815.namprd12.prod.outlook.com
 (2603:10b6:8:14f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:30:46 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:30:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	John Garry <john.garry@arm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 05/13] iommupt/kunit: Skip test configs without supported features
Date: Sun, 15 Nov 2026 19:30:35 -0400
Message-ID: <5-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0011.namprd22.prod.outlook.com
 (2603:10b6:208:238::16) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS0PR12MB8815:EE_
X-MS-Office365-Filtering-Correlation-Id: ccbed500-99db-4df8-e2e9-08df437078ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261022075727099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zAafzJBgOQlh4Tu2TqFs8nPbkcLOj3nScAGzoxhaNxMew0coi/SCcBQRdq7/qmrn2NYKoCOg71pmuVmeiWgtSaigt4jhzwO9l46ezWPWbuuXBn9nTDEa+yGOlAQ86jLtUbMQXSWlepu/TpjQxSEqndm3TgAMdnvspVJn5hd8ZNsxTSZJC0xKH4bvm0eK54ihP3M7RuRDP5lPpLMP49RH4JsaOhgwP/bek65kYClwLRDDTWnOXfDvaYf0g1wjB28i1CZf5x3RrPQ+8GYB9jghqdhdT4vJROT2hixYA3O33ANVRo7659ESth8/Eca7/lIGtnt3sQvFEEHEA1TDA3n6vWkbdF306t8n7wmYDAiebW6bFf1q4eHvDLtuXJhuIukr9K5bRCudslXC2M1ULmQ4nU1jeRvVaoXUpqW+H22wtTqTZrApRwHJaXJItGlrJCyw067tSCy8KZP24FKzWF9PdSTALG7BnroHEjcPyR9Zg6dRJ/fYg2ITODa8crt4x28ewF2DL02lHazGOu6OHZgPYGBeQuP56dfUwlZ23s/ANGpVX/HV4VLEXRVs92zq/R23uDiDBYJNs5VfItDbuqsWOJw/IHuGsZmZgyi6/Lfvt/ZD+tlULRyrJNpo4KjT3eWtc3a+Jv/JPqwxzFEDLT53luph+dal3vU113RrZZ7aWHc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XnrNazG6xXWHOAMThITZPoB1Si2otgk6j/tgE6KHETAaY69sposFIQoCw2zt?=
 =?us-ascii?Q?ZxR10gOSgzOwW0EB85WJR0VKw9ewhW9yXnK4WfzvDyNNhWYqFcuKAIc+kDXZ?=
 =?us-ascii?Q?dMSiI2xvea+QURV0f0QUpA1ek5+fFWyng7m/VD80zzCIqSMLSNmTNJWf3Qz6?=
 =?us-ascii?Q?VZvRe1mdgxU99AJYkv/NQRiJEN4ayN8BSv4O9aTkDuGVCxkFBTo7uqR0Zn5H?=
 =?us-ascii?Q?564jAm9sInJKcbP+nZXk5RB4aoc4yMQdpNENqfNUmEJUzc87AAZnaugvM4Eq?=
 =?us-ascii?Q?Wzk12yWzyZrG/6S4J02niPbBypl9wBKcOeJLAJKWGLtJ9Z4eIvBgHxdtpV2u?=
 =?us-ascii?Q?eAPF9nMWKcXa+lzwci8PIc3TWRToypzMMKfMNH19tPXA6w6nJCcfs+d8fkJm?=
 =?us-ascii?Q?RLAsin58jXyuENILxBBneAjcGckJNNmVRjJCB3JKIO87a4qK+liGjHoUccbk?=
 =?us-ascii?Q?YFMrIiSLx55Shy2cwMDD58e3L5BHI04eoe+Mf4fdWMM89Na8gdkalgCS3fvQ?=
 =?us-ascii?Q?IHm3gB5XqwO2BwCnX+OLqBqZg5yG9/ZiBoYhPEEkEp5FeLNODwU/Wx6v+5oh?=
 =?us-ascii?Q?YVPXOHjdsgP8LpFmJqOHVr4kaiHnk9B32RWKnbGruTqwRhVNMz9LBohHjSkM?=
 =?us-ascii?Q?ncITCkkWAplevqRSP2sxXhMC/2DDPpVdwrBBh4kzgBf0v39D4MSAY0R2ZQDL?=
 =?us-ascii?Q?DaK8QwvYZnTBzhuwTy9g30+oQxj6JCyINzDOUMUtuh6n+LkC8G6oQXrq7zkE?=
 =?us-ascii?Q?hhPPkhc+roN5kKX1JtE9qgRUdN7bG6RHao1SrBvbabsQ4PRgHgWbZRIP4MXl?=
 =?us-ascii?Q?B1Vwr3UIJpjxYpU7T7uZ608NiQzyn/t4pugRsEshPIuUTCtslOF+OhXqOLl9?=
 =?us-ascii?Q?T3iWCgSpQNU1aJ1oUy5J8RggO+AeVQOESn/+EyhAY+rsJRgZfySU2G6TRYGM?=
 =?us-ascii?Q?JsrbhsiKFBiOZLkqcDab8DK0eZ5MBGRBIaYYkq4SFWBBS6r+28l11lo82NNr?=
 =?us-ascii?Q?w34Q9dsc17Figt7Nkh88InFk5roP3Roquw9c5y5vY0i3X9C77kRz0B1sL34E?=
 =?us-ascii?Q?6Qqq2+GS7y+HQnSUcqxbLK9YxlqUrWd0s4xV2eHUycM0eQdQEkg+10QZTGTZ?=
 =?us-ascii?Q?znOQogSyTqDZifUPLUS7b9yqIJjTJSECdO5t8yeR8Sq4Ljk0x0fMVRGm48nL?=
 =?us-ascii?Q?R/FTE3fP6mt6ktReoceH8jjl+BX8N6G6ppW4lnsrHUZwTVk397xAoZjJ7Y2e?=
 =?us-ascii?Q?eiSvq+yLo/UQEGaq631s5AhxecBY3azo2NpR9TcGjs9OGahuIIEO0YebLUPY?=
 =?us-ascii?Q?N/8lseZlwJSYrFvQC8BD/Lhg4830voRv2XNn1TdsVhr8nMqGKGSgf0HLKKLG?=
 =?us-ascii?Q?SyYzUfjNjjNmxOhF4awUZDy0SKnD3Kz+Bt4QPL+h6+UvppHDfykfSm8U98V0?=
 =?us-ascii?Q?LKpIrj2m/d1NNQPXzXnDkcBLmYaxewN4y13X+PqVNa8agXVQ95FOPyXu8iS4?=
 =?us-ascii?Q?f8U4sukD2c53jP4Sz6LYzYqnyNvh/DNjAMhHh2MViPake3C3aACrdiQnwGr8?=
 =?us-ascii?Q?KQaD8kfqJuyoY25y/8vnXTp3EGlcTHF7ZR46fJsfIdMlZvREtIgv++/0GEDH?=
 =?us-ascii?Q?ZJupcJcD7nWckCxuGXUbruwXICvuoVMMRYiHbF61WH3wLCZhRhYRqQf0gap8?=
 =?us-ascii?Q?a6Mw8ELVWqL1liVs5OvtvLV1ICBbRXfPOdTnOF+NzTIqBrj6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccbed500-99db-4df8-e2e9-08df437078ed
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:30:45.5165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ICon6hYNjnM1EBGdmL4rGkWtLvdGOeQehDdN2Jt2aWkZmsBQ1yvJeMUYnn772d71
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8815

Some of the tests configs can test features we don't currently enable,
like TTBR1 on ARMv8. Instead of blowing up, skip the test. When
CONFIG_DEBUG_GENERIC_PT is set all features are force enabled during
the build so everything can be tested. That is the normal mode for the
kunit.py runner.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/kunit_iommu.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/iommu/generic_pt/kunit_iommu.h b/drivers/iommu/generic_pt/kunit_iommu.h
index 79d7f9c8e7868f..558e161eacb05f 100644
--- a/drivers/iommu/generic_pt/kunit_iommu.h
+++ b/drivers/iommu/generic_pt/kunit_iommu.h
@@ -134,6 +134,16 @@ static int pt_kunit_priv_init(struct kunit *test, struct kunit_iommu_priv *priv)
 
 #ifdef kunit_fmt_cfgs
 	priv->cfg = kunit_fmt_cfgs[((uintptr_t)test->param_value) - 1];
+	/*
+	 * Without CONFIG_DEBUG_GENERIC_PT only the format's compiled-in
+	 * PT_SUPPORTED_FEATURES are available, so cfgs requesting bits outside
+	 * that set cannot be tested.
+	 */
+	if (priv->cfg.common.features & ~KUNIT_PT_SUPPORTED_FEATURES)
+		kunit_skip(
+			test,
+			"cfg requires features not built into this format (enable CONFIG_DEBUG_GENERIC_PT)");
+
 	/*
 	 * The format can set a list of features that the kunit_fmt_cfgs
 	 * controls, other features are default to on.
-- 
2.43.0

