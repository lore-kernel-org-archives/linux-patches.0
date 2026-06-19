Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179C33B38B4
	for <patches@lists.linux.dev>; Fri, 19 Jun 2026 16:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=100.103.45.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781886250; cv=fail; b=FITvtfZimv9scvfTv/6Dw+d4o+DGWMhvzpC7QP10O31mHhifdpI6TvK1bZsC1Xl5mXcT/CTLKtY5DBb6oaNpnXfQdxIJSlQGpY1ECyYqC62ms63ox9g71YIgHL4hVwwpCC/r9/kRmk6FMIKXyeLEjUMDOYg1E1AaI+HnA4713Go=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781886250; c=relaxed/simple;
	bh=WKs/+BVroKcxhyoN9GXRTuRMhgjUaA7f5gRB4RJl/RU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X/aQYx1DpAKNwACZCa2gcKudINkllSZora5rPI/Gk8EN9O5OhFzBg0xPYT+Rh5MKN8cYQ84oKOuZvh9eZgC7fzQxDXA2rWPLfbk26K8AvGE0fqx0dDhRQ/ggWfkRmQ66ibfysm/1B4KtsNJaYZBe24h//7yn69f3cAXBd54ueXM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; arc=fail smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B8B1F000E9
	for <patches@lists.linux.dev>; Fri, 19 Jun 2026 16:24:08 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Fri, 19 Jun 2026 17:24:05 +0100
Resent-Message-ID: <ajVtJZjZD49-A_tw@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by 172-238-120-221.ip.linodeusercontent.com (Postfix) with ESMTPS id 52A942051A
	for <broonie@sirena.co.uk>; Fri, 19 Jun 2026 14:35:11 +0000 (UTC)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 61A6D601E1
	for <broonie@sirena.co.uk>; Fri, 19 Jun 2026 14:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 2CFAD1F00A3A; Fri, 19 Jun 2026 14:35:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.113
ARC-Seal: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=pass;
	t=1781879710;
	b=Px3+fLubGvOMajx8qu7858/FcUeAAgasN32OInab65llYsbqb3y5XxhiWZLGfQssP+f8
	 ua9U29jaNiObKc7Rk4XoXxu7ALTgiq8iDr+lgIJMp91Ob3OZ3EUFvu7Ll3P8cmg9Onx/T
	 tWMVOlPevZsj7mfd/PL26ZaYVYRhyTR54MVz6GXYT5uWjxPDPohmnc2OdLqa7iyRFphIc
	 fgF3pNE8pWLRu1F5hFe7HUHbmPXkVUjW821H73uH4hpVfWDYNaZeZJpJ4rjmj5UwHF5Gl
	 f3WaDRHvzIfFNONdnugi+cLFgj8HirRYvR1I12FYfajkGdXKkwrrRB8zWsbxSeBgTNQ==
ARC-Message-Signature: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1781879710;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=snGAmiPzCbI2MCF5iBofbJu9tA6iQmGRMbZmGltHpw8=;
	b=P11lV9qsjmt/Q0MWzKQ/bdMhvPYRcznkCesOpBguW2dN08DCrVdY5Vi5ikozhc8r6W6Y
	 HdH4xzHrRjC6sJfGLAHuTcnfeYcg7HHz1GBE39L2CFrDMU/axBET6bo861aK6S0SjB+rt
	 CyINwsIdqpnWMvJ/NOP5ZT3svCTak3UCCxXrst7UNXry/cYnNjvFKvh1VViown3aZvsXx
	 WswD8rMPkwfP/ha//OguI8D8NNEVeHgKNFOkHS11p2aVz/HUb6g5SIQQA3guk0g9oT0dE
	 oAw9nvwmxmdWlQ6Q6SDjovfeqtCdl6DHyRM2EgPT2pzX1eUKMelDcLv4OBzhAC/Smzg==
ARC-Authentication-Results: i=2; smtp.kernel.org; dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.113
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C25D1F000E9;
	Fri, 19 Jun 2026 14:35:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 7C25D1F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QA1JqVue1bcriprZbkPumkE/gBPkPVC7XRZ9WvKs5J7zaqmh12mx7dM4nCbsBR2WtP4THYeYePyikv/OTQXTlrzvsLfjIc3wHjveWlK3cxv+CfF9X+YCdxM9PVXEiK9PHAhHFvL3td/w182H8SOTdBtEhsD4bld67aVdUQiTqsN1lnpX2Bg/XLcdDOov5+MRoKuyGaIr0+cEMjuXvorLx6VBB4dYfA0wcg2Fy2hoYYGSeXs/LzGQYcq0z7CslGiM3QpyaVolOOCAYHn0xYAAQSYJN8px5USeowc3wqeO/cBxR4YTaWmIN98t+ojTa84icNO0m+Bz6bkwwP2yntkbvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=snGAmiPzCbI2MCF5iBofbJu9tA6iQmGRMbZmGltHpw8=;
 b=PgqzBjSW/p9m6slg9koLyAc4UWu43mTSYh3AmwjY0ySAdGJjoYbKIOvqfZgamf2bjZ5+IC6xxdUObut6/C+6QTHUgR8eV0U6mXyofzh5bmlhpyfLw170A7+I5LOwOcRkl+VGhlznKNkgcUalIqjFUqeeip8bCMzUMItswlATgNk2CiHIMPp8EkIHpKp3B0aW4PnQYml8TTkUF7WGSvFLGu3r1cb3o+OXJDSwSyuXSt+QiK7NlFoUSM2Rg8qUimrKqQNY5tm4XGjz6YLxkg/BOG9VWtrN+8HUzotxcm+mIJP1URNWxPqgs4FBOTp1hGyIeEP7uwBLkiZGu0tQ17Z/nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ4PR01MB1202.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:17::6) by ZQ4PR01MB1330.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:16::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.21; Fri, 19 Jun
 2026 14:34:54 +0000
Received: from ZQ4PR01MB1202.CHNPR01.prod.partner.outlook.cn
 ([fe80::e7d4:256c:b066:850d]) by
 ZQ4PR01MB1202.CHNPR01.prod.partner.outlook.cn ([fe80::e7d4:256c:b066:850d%5])
 with mapi id 15.21.0113.020; Fri, 19 Jun 2026 14:34:54 +0000
From: Changhuang Liang <changhuang.liang@starfivetech.com>
To: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	Changhuang Liang <changhuang.liang@starfivetech.com>
Subject: [PATCH v2 2/2] spi: dw: Add support for snps,dwc-ssi-2.00a
Date: Fri, 19 Jun 2026 07:34:43 -0700
Message-Id: <20260619143443.22267-3-changhuang.liang@starfivetech.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260619143443.22267-1-changhuang.liang@starfivetech.com>
References: <20260619143443.22267-1-changhuang.liang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZQ0PR01CA0025.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:2::22) To ZQ4PR01MB1202.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:17::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ4PR01MB1202:EE_|ZQ4PR01MB1330:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ca72093-7a55-45bb-81e3-08dece0fedf9
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|52116014|56012099006|6133799003|18002099003|22082099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	G1vaetnYLb9mnzGG05NE1zlH7m4NpvB75H6foMxo7jpdPRR6ZqQVUCPczm1LlNVFt3vzoy0DyFcazzbfB9m4XznjDwOBXhYqeJqO1RENGew8DwDg7h00n/9VW9hmc2NLgGTiFcQ8lKBl6KN/6HTS59ymCp6CuWJsrIKteMUPyBRac95G0B9Qnm87yxBmSceaAJplsKeeFrXa4h2034VLenFn5gMDGlMTy88RRPKkA+W+B7Rur2V0AEakik0W3zJqquSu1jzaG9jU+2R4PyEyCsPX10XMiQQmE/5mmWO2/T2VMl3YL3N0bfo3Pj3bSMG+S46j2ZLWj+4ABoHuSPLB/TVunvlJ/hi5+igI20hUbOoSk5vB2WT4nV4ITup1pw2pcf6tfAnWCIPmA+4/nMzC8/lIiJk9IKI983uGhuhK52rNRYy6PwxhzPoUEA0HB6dhsvoq3w/FBjuzdWfCZlDc37W+tkXsNpmRP0EbTETPI7MOv73QFfa+nszlvW0Etr5K6XQRJ9wnk6mX0lj8i3jGEjBvvCnnPXAE5GTMLZBWgJJcNMWwQluvGi83psQPQrsY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ4PR01MB1202.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(52116014)(56012099006)(6133799003)(18002099003)(22082099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6yo7LZ8ILNFLwTXJyhUv4gqff+TePB4KCNy5PK6oUIqUPlB6VPdoxATo8SBE?=
 =?us-ascii?Q?zR9ziLRLZ35ZsWLWY/tc6uyus7xSx3UG2YMNWaYOKG0hmp+4T8aymNsgQKih?=
 =?us-ascii?Q?B/pTHRmbaR+sQlMt/nfLR6uqMhlllypeE6/hbuVByi0rkpr9VpR7FfAqB2rY?=
 =?us-ascii?Q?So7Ekw679A1AfmiPr5C2xFzvTNNk5AuPhS1ZZy9AKFZ4l3d33fUiVkD5ABzx?=
 =?us-ascii?Q?0CNEcMTsQ+XZbYccfG6hoQHbb1+/2PQJhpecOUHR5oCjUXsIiWmfhzl1bhD5?=
 =?us-ascii?Q?k660qO+uXcMBnCHQFc5A+jS40CuYeCTOyogM12J27ylTLbXkbF9wLqMPd0s2?=
 =?us-ascii?Q?9gvy4tS7X6XVRsKyWZRTIviGd+GdsUpTsWJSwlTr/uyGso+dN1UQwQCoGVmw?=
 =?us-ascii?Q?yxBW8ooVzJDEgM38NdToRbpJ4Ws55wndy248nfWT0LkzrtWZpor0pHslTb5u?=
 =?us-ascii?Q?7ZCPK8V/at00FTa5WzrLI8zBz+D1X6DKbrVZOPQpoOsuak3W8NqwgGkHc11U?=
 =?us-ascii?Q?pgAKPGmb/5cAvQ1R+xU29XGdFi8vsdaKUWQXO/TcQI2cTUnRxr/7AWl917f+?=
 =?us-ascii?Q?iwnSGPxYIc+kXR2ZRNZuDm5RZ/8GVY92Fs2F+x9CWqDa1XXlkMCLsHkWX1/o?=
 =?us-ascii?Q?FLKgdKyBugeb0SXPQq3G8Rsmd5mWMNRSmOBqC2AXWLI/4U71fsQMdrWCFbaQ?=
 =?us-ascii?Q?+U7/jTn1XLj9WQVyCKJ7UileBNJ+06vAfaXXaJcA7P6IU6dtz2o7j3kyv94i?=
 =?us-ascii?Q?OQ5vmhIuNL7rm9wzwfPwp0/4Vb04e+E9neRLGUAh8br7X5uoPNrDj9G8xtPX?=
 =?us-ascii?Q?vtRmYnkcG9U+f6jfHn+DItNtk0kV0KULwJq5nDcZjmV/NVMVPNDwhLD7Bj25?=
 =?us-ascii?Q?uNmGdb9j9dSFb9cep+SXWZGf/KY9jhaGwIp+oMsokXjOsQb5PVuBqrf7sW5A?=
 =?us-ascii?Q?JB+mljxetypeWWxDdwrwNui2Cj1QbGgtRfZy9pyiWzJ/Z0eUWxFAbkwIcETG?=
 =?us-ascii?Q?/TPTyD6Pe5s3qLK1P7zGWcJx1DDCTN3I0EIrTJ60HA6aSvxzZTy5Sx4k+5v3?=
 =?us-ascii?Q?u7WWoe8qDg/7oTc9KIgmwQRFGgI0IC6CyMx7gmzFAJcparHzzEnsiHg2HUZp?=
 =?us-ascii?Q?7NBZE4QDGEkt5j6afr6G98pSJFA0MtX64V9YM1yYxi1/AzhIq3RoGYq2E7VE?=
 =?us-ascii?Q?6pIAWm+/kJa2OAGRqvmYKkqGOw2ibn3SkQ4rURT2iFhQsM8M7yG0J1CAalRZ?=
 =?us-ascii?Q?bGXCo1Tl7/UtRTWUGzmm50aWhCK7S/CJlLk6Ry5UKoRkfHOVT9ioUJeeS0Wr?=
 =?us-ascii?Q?hzYi1wQabyaAMkwwW1S7nzVYPvDxAaJZqhGb0XmLzDmr5Fl7WtEuCimbQLzu?=
 =?us-ascii?Q?Wwh6+rwePeJOPld/Q+HRuywjLuJs5iaL94Uu8muEmT929xnlhc1sOdH/gnEQ?=
 =?us-ascii?Q?jaH0TGVRvJSU/UlhQ/8Pkh9cMQdxboSKijkVZY8w0J2luQO2iZ9S50tp03MY?=
 =?us-ascii?Q?1mUPhrhbXkNlt0JQkU+DHN67H7yMBERR3v3lG+lWiVTIyHzlBdwj/5a3ABFr?=
 =?us-ascii?Q?JqxEFova4GKO0SBbk7YvtkD2ZVdR+6C1P/vsWra4v5s46KyhR4QB7FggUApO?=
 =?us-ascii?Q?vX2yO2BJV2fOI4b90jrWs8sSaw83DbNIJH9/9+KPbf/ZZB24qEzO3/SURhP4?=
 =?us-ascii?Q?xaH10zzmS6Ztr06Zmb5iRLV0Be778PYPKb+mxcBdAK0vTdltbX5x3fsejFJS?=
 =?us-ascii?Q?MsW24IRdIUHJdcjkqxCrHQo4ss/SkWxozjvEktAiXXql377aMUNg?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca72093-7a55-45bb-81e3-08dece0fedf9
X-MS-Exchange-CrossTenant-AuthSource: ZQ4PR01MB1202.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 14:34:54.6962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UOQzvCXoY00mpXKUGt5VFmn73o+BgOhQyqfn51sVz4oe1vn8iI5ZZvmt4DBLVLD1+5C7ULbPUCSpn13sXKca15nR9TObAcBXMLBx2Je+tMOLRgd+Bz8w+BwplUENkfDx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ4PR01MB1330

Add a new compatible entry "snps,dwc-ssi-2.00a" for the Synopsys
DesignWare SSI controller version 2.00a. This variant uses the same
initialization routine as snps,dwc-ssi-1.01a (dw_spi_hssi_init).

Signed-off-by: Changhuang Liang <changhuang.liang@starfivetech.com>
---
 drivers/spi/spi-dw-mmio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-dw-mmio.c b/drivers/spi/spi-dw-mmio.c
index 4fc864d38cff..603e81a92c57 100644
--- a/drivers/spi/spi-dw-mmio.c
+++ b/drivers/spi/spi-dw-mmio.c
@@ -438,6 +438,7 @@ static const struct of_device_id dw_spi_mmio_of_match[] = {
 	{ .compatible = "amazon,alpine-dw-apb-ssi", .data = dw_spi_alpine_init},
 	{ .compatible = "renesas,rzn1-spi", .data = dw_spi_pssi_init},
 	{ .compatible = "snps,dwc-ssi-1.01a", .data = dw_spi_hssi_init},
+	{ .compatible = "snps,dwc-ssi-2.00a", .data = dw_spi_hssi_init},
 	{ .compatible = "intel,keembay-ssi", .data = dw_spi_hssi_no_dma_init},
 	{
 		.compatible = "intel,mountevans-imc-ssi",
-- 
2.25.1

