Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4CE20F8
	for <patches@lists.linux.dev>; Fri, 14 Oct 2022 14:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62753C433C1
	for <patches@lists.linux.dev>; Fri, 14 Oct 2022 14:13:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=licor.com header.i=@licor.com header.b="TfrIWQGJ"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Fri, 14 Oct 2022 15:13:44 +0100
Resent-Message-ID: <Y0lumBwh7Vlz8Q1n@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 07 Oct 2022 16:29:28 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=zlRH=2I=licor.com=chris.lesiak@kernel.org>)
	id 1ogpHx-002uDY-NF
	for broonie@sirena.co.uk; Fri, 07 Oct 2022 16:29:28 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id DD12B61D46
	for <broonie@sirena.co.uk>; Fri,  7 Oct 2022 15:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 5DBEFC43140; Fri,  7 Oct 2022 15:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA729C433D6
	for <broonie@kernel.org>; Fri,  7 Oct 2022 15:29:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org AA729C433D6
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=licor.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=licor.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=fail;
 b=fGRssB4V+Po2NHysRiajlhOfgQomSUxJ+THi52ccxMlWrvGQ0aL/tt8m2DAD67sjhSbtZDLvAyBgmpqHvRWSWHvYex3LZRFTj6LX5ve9lhy959mUG+yHqcFdDl7Or6sH/iZZ+Jij62IlgQYxnvInVnt0ezEO70zKRTFm1FHdlMG8wBR98MWSd+1atEJiSwyLhTfN6rsXgb+szfB/8oY/1SbR78Hc9Rpovj4sYzZVyANLp6iqx+n+kPV3B/CMvEZSWgsYIaBhAfpI2VYLM7YPSi0Lo4Mmv1WzV5XnvS0oOg7u4C1jCpI51WRQ4+ferBE/e9FvsWaWeQbpuB/LhdkCFQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xklumIe8dX+JmLAYE8JQRDZf+rwqC+KSlfhrnrXwE5M=;
 b=JLw9I+eiEtUmA1SWbDNhLkxoxVsb1nrNf0h5NKAMLlh+B5V4oyL/W5gdoefUY4LF1jgbwuNKCIOGmBoMV1dlTA/TEF1NUTyOEEVBBr7PhfziX/gkYzApBPh8kQO+G4DhuE4oxXszJhRezb2ZDLI7WnnH7KAxTKJTvRg0kPpcFGdfi4hsQbjvx3bpaqaEijmLlnfuP6bKjw8n4L7IPe/WIwwrXkMVXLGwYkgLws49qCjbZ8NCvGVVvKESt2SbZwilSrzIa/IG4yC9hBWwPgVtXuRTMneog2lanB29WKpDuaIgJ3C7YgkvRhxX+wE/pDdpV54f1T3pVrHMMyFdKrOO3Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 69.175.48.226) smtp.rcpttodomain=kernel.org smtp.mailfrom=licor.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=licor.com; dkim=none (message not signed); arc=fail (47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=licor.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xklumIe8dX+JmLAYE8JQRDZf+rwqC+KSlfhrnrXwE5M=;
 b=TfrIWQGJMLYgYRr4qeMsj3v++ZvVRYwEn/c1Qg5ABBgjA6UGdmO0XmjZqeN97+msFsOjiUXiOiq3d5mq57IzDIYHFA0JuBI6gZmQK5M2oojwoigR+tGFzgl4Gu3D56C3yTSzgxAj1fSVUI5vjRDArSGRhyW7DpvtAlx6fEnFK+kDwaQjbx5u2Vv2OB4KCgJLAFcZMz6RqcO4hqxGWKNtMTPdN4Uh6Etu69h3MikltWKktRZfgmGv31baIxk/MDRCWvRpS3xEergzsi4eUwzfpB4W2soDtH7041vFKHNQmxDWv3bCPIAWTeH15WVX34IE+/4+c+9CPoiHDs2yc2BmRg==
Received: from DS7PR05CA0017.namprd05.prod.outlook.com (2603:10b6:5:3b9::22)
 by BYAPR08MB5685.namprd08.prod.outlook.com (2603:10b6:a03:cf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 7 Oct
 2022 15:29:16 +0000
Received: from DM3NAM02FT015.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::18) by DS7PR05CA0017.outlook.office365.com
 (2603:10b6:5:3b9::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.11 via Frontend
 Transport; Fri, 7 Oct 2022 15:29:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 69.175.48.226)
 smtp.mailfrom=licor.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=licor.com;
Received-SPF: Pass (protection.outlook.com: domain of licor.com designates
 69.175.48.226 as permitted sender) receiver=protection.outlook.com;
 client-ip=69.175.48.226; helo=elk2-new-relay.sendergen.com; pr=C
Received: from elk2-new-relay.sendergen.com (69.175.48.226) by
 DM3NAM02FT015.mail.protection.outlook.com (10.13.5.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5709.10 via Frontend Transport; Fri, 7 Oct 2022 15:29:16 +0000
Received: from localhost (localhost [127.0.0.1])
	by elk2-new-relay.sendergen.com (Postfix) with ESMTP id C3206602D28CF
	for <broonie@kernel.org>; Fri,  7 Oct 2022 11:29:13 -0400 (EDT)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
	by elk2-new-relay.sendergen.com (envelope-sender <chris.lesiak@licor.com>) (MIMEDefang) with ESMTP id 5B8FA602D28DE; Fri, 07 Oct 2022 11:29:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4O+3wLOIO0EH8FGM3vZQxN+gy7ZzjIZQbzzo4b8j9OgTQ485ZHwtJdS8v5m7jjIVYJ5aku+fNGkY0V4SPYBby0vUuG/Bo1o6wcdczPLjIlyGLUlBSs5O9L0YIyYPxl15F8sAFt2/lZzYT/2ojs5rfvz6BrQSkyl5KUpXXGQH4lDbJMG5deiI4ldo2WjdfpKgVh04R0UxOt4CmH1Btf1TuZgmKH+HuXI1hEzFTey0Zya10w7WNo/7sky8Hyb8rEiDFgpuFrdA8+ByS7f8T4RkktjoVUXeeLlft4SmqVetZ6A6Or2LPMsZwVt5d20f9Y7+Kkwf5glsUSVGaF0XqWwaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZTQ0lepLd7r/TLsCAEJfwbKe23yZey2rHYoL028PFE=;
 b=NZDe9mBvcK0oc9Hx3/++wYfj4xtc5289UxBhG5adCF5sRup5JiCJtdKbhCfffhmVp9+mouRSImlphUjoUdox+Ezy6Bhcbn+dxug3HY69vfDF12QXJPsLDaE5O30FE+G8fEM2vVW7xcAsWjIvlkibLYIOI84IaJDtLj0qtwZZ028lsVZFHKbBQZ6NwrNwvjz80w+V05b6Ea2e/2dZimGKwNa0ZTxRikRK37VuicC8ag2VbzUM4KWDaoBA8CHIjyVNdNDTXu10iaMnRTOnlcBXqZG+ZredfZTb/cvBsZDCX/BvKyIiWmfeFMWV+zUYGZfXIYNsLQXyd5qy++Q6xS0Hlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=licor.com; dmarc=pass action=none header.from=licor.com;
 dkim=pass header.d=licor.com; arc=none
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=licor.com;
Received: from SJ0PR08MB7897.namprd08.prod.outlook.com (2603:10b6:a03:408::16)
 by BYAPR08MB4165.namprd08.prod.outlook.com (2603:10b6:a02:fc::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.36; Fri, 7 Oct
 2022 15:29:11 +0000
Received: from SJ0PR08MB7897.namprd08.prod.outlook.com
 ([fe80::6dec:e209:502b:2c38]) by SJ0PR08MB7897.namprd08.prod.outlook.com
 ([fe80::6dec:e209:502b:2c38%3]) with mapi id 15.20.5676.036; Fri, 7 Oct 2022
 15:29:11 +0000
From: Chris Lesiak <chris.lesiak@licor.com>
To: linux-spi@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Chris Lesiak <chris.lesiak@licor.com>
X-SG-Signature: true
Date: Fri,  7 Oct 2022 10:28:30 -0500
Message-Id: <20221007152830.699869-1-chris.lesiak@licor.com>
X-Mailer: git-send-email 2.26.2
Content-Type: multipart/mixed; boundary="----------=_1665156553-5775-34"
X-ClientProxiedBy: CH2PR18CA0031.namprd18.prod.outlook.com
 (2603:10b6:610:55::11) To SJ0PR08MB7897.namprd08.prod.outlook.com
 (2603:10b6:a03:408::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	SJ0PR08MB7897:EE_|BYAPR08MB4165:EE_|DM3NAM02FT015:EE_|BYAPR08MB5685:EE_
X-MS-Office365-Filtering-Correlation-Id: ac5176c4-a48d-4e81-afb5-08daa878b24e
X-SG-Stamp: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 XmNVBufbJzBhVrlZrZFGlvF/GMO9GAdaUsWheJ5iZ8M1Gh62EQrtpHfeJOMevUlEZPF3N4Y9kP4qktQNJ8zKx+HWqReiSe7hkkGx/+8tZD9EVU21MjsbCm6JfzrPwDKgyk2xuIIVtX4puAOXlJLgfrGZ52rluK/llASt/gaWCCAlmyuQJ0n6bOtAJdDIlI04ZYx7Q29ufnjNd5/2TTPgltxsF6lHL2xJrAicxk5IyZeY3N+agukD9Aud5xJl6sbFHZE2zxon7OlLthZoxTTyUcB6PJH8EI4YcsYmLVgqzC01A7q7Re67tayH8d43HiJ/0BV5S30cDwy2K+1JvgEHse60vPnollHeK53Eh0KCVlJBleP2w5TxNgKfMTD0T1jeEAgh+Prdw732h+1bGeWjbs9TLWgrEWK2a5vL2xg1HjKs7w9fq9VAhp3SOyeR0NsP7OAIlQaWOhLNZtanMRhyPr08PBZFCny8NERCCJcQt93XsK1JNOydSH5OGEEJB4qWrvtAw3YOOt+yTH+DghepXi7SpCbFjSyLbXJS8eYy4E4Oy5GMLG0zf7Kr5u7q5uctrEi5ouZ1q8i85Sm9zj4rkge4/UVIyQWoLicM5yXJRbrGkbnKSwYIdXv+7rAkI/dn7zPjg9kedFnvOpSSih1pOjtI51NuJBVk5AarhR9THmrq8j/vr09+EK0YyXUGrJYAvu6qHrbyLfSTf/c4qEVJEw==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR08MB7897.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39850400004)(346002)(136003)(366004)(376002)(451199015)(186003)(52116002)(83380400001)(6666004)(2906002)(1076003)(107886003)(6506007)(66476007)(4326008)(86362001)(66946007)(8676002)(316002)(6512007)(66556008)(2616005)(6916009)(36756003)(54906003)(41300700001)(40140700001)(5660300002)(6486002)(478600001)(38100700002)(44832011)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR08MB4165
X-Scanned-By: 'EmailPostmaster' on 69.175.48.226
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DM3NAM02FT015.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	332e5fbf-c221-483e-2493-08daa878aef4
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EwaoYzYYMyl+hd9dNs41wYn+suy7aa7nsLCTOYJCorjkEaDzKLOaPsBDlGnlg5fMC4dqe9pu1IY4uYw5ECPNM9/aBNgtn/NwkTtbgiV7i73suTxyla97uXQ+ClZeRsZ/QETAbL1+k/7u8y5sPmHZS5qaVrJVSqK9wwuTO/hBKTWMIGg1eFgnlabW3e49cVbvQTFy5/PsUgzzxfu6mMz2WpO49jGaw9AMeBYq9AYY2zDZ22Uu+YSB3mgKBYIVKKR28q3UPYhgP0w+dRsIBrvpSJ/uuQjk/tOxkmVnlSJcp/j3zYv8qZGMtkRimZC+uuz5uKAc52AfguMEvd8x79NI7v7C7Z0o2dPUsVfsPIHMeyVhjwtNTiecw1ac3vGS+6cVpMpXafs6IoFZkT8AP10ElrOKQBOdEsgrkm/hWHX6Jhmy8KYdw3fom4zltAiR+1AE1hyxPpAXOe4jvO0pxCRkjVw8FqGY6MG+CqsqLnVFVaJWYVdOx3bw/y8ZA5MRPo74tVPO4JkP3qwUSoDroQAQ4BvpzDrG49/g7sX6K6zP3saaqYlK2zHOwIdb71y6M+qCEz2KwxjALa6bG7wosXitLdmPz1FZDaT2YRCd5tEys0ViJJcBElNvo0G6tbvajrDXPgOwnETG36DPBvTjDY74lR65SK9DFurkhlBbHBBfW/iPzMF6vOe94dSUlBxo3cpxo5A3AHEM3396OjreNfsBJhLJT2k3bqY6E8OUzAS1/9IkCU5i4R2JmrTkPEwhYlke7WgTzkjqNcb3FcjMi/lUNQ==
X-Forefront-Antispam-Report:
	CIP:69.175.48.226;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:elk2-new-relay.sendergen.com;PTR:elk2-new-relay.sendergen.com;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(346002)(376002)(136003)(396003)(451199015)(46966006)(36840700001)(44832011)(2906002)(41300700001)(70206006)(8676002)(4326008)(5660300002)(34206002)(8936002)(36756003)(40140700001)(86362001)(82740400003)(166002)(356005)(7596003)(7636003)(6512007)(26005)(6506007)(336012)(1076003)(186003)(2616005)(54906003)(82310400005)(6486002)(6666004)(107886003)(478600001)(36860700001)(70586007)(40480700001)(316002)(47076005)(83380400001);DIR:OUT;SFP:1102;
X-OriginatorOrg: licor.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 15:29:16.6295
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac5176c4-a48d-4e81-afb5-08daa878b24e
X-MS-Exchange-CrossTenant-Id: 48c70abd-da5a-4c6c-86cb-5e003ca01574
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=48c70abd-da5a-4c6c-86cb-5e003ca01574;Ip=[69.175.48.226];Helo=[elk2-new-relay.sendergen.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3NAM02FT015.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR08MB5685
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=zlRH=2I=licor.com=chris.lesiak@kernel.org
Subject: [PATCH] spi: spi-imx: mx51 support for more than 4 gpio chip selects
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: LD8IbdhxPLrJ

This is a multi-part message in MIME format...

------------=_1665156553-5775-34
Content-type: multipart/alternative; boundary="----------=_1665156553-5775-35"

------------=_1665156553-5775-35
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The MX51_ECSPI_CTRL and MX51_ECSPI_CONFIG registers have bit fields
that only support the four slave select channels.  If we are using
a gpio to support chip_select > 3, we need to be careful not to
write outside the bit fields.  Probably the biggest issue is the
2-bit CHANNEL_SELECT field of MX51_ECSPI_CTRL overflowing into the
BURST_LENGTH field.  That will likely cause a DMA TX timeout.

To prevent this, when chip_select > 3, use slave select = 3.

This should allow up to four channels using the built-in slave
selects, or any of the first three chip selects optionally using
built-in slave selects with gpio used for additional channels.

Signed-off-by: Chris Lesiak <chris.lesiak@licor.com>
---
 drivers/spi/spi-imx.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 30d82cc7300b..7ed493200951 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -521,6 +521,7 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
        u32 testreg, delay;
        u32 cfg = readl(spi_imx->base + MX51_ECSPI_CONFIG);
        u32 current_cfg = cfg;
+       u8 ss = min_t(u8, spi->chip_select, 3);

        /* set Master or Slave mode */
        if (spi_imx->slave_mode)
@@ -535,7 +536,7 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
                ctrl |= MX51_ECSPI_CTRL_DRCTL(spi_imx->spi_drctl);

        /* set chip select to use */
-       ctrl |= MX51_ECSPI_CTRL_CS(spi->chip_select);
+       ctrl |= MX51_ECSPI_CTRL_CS(ss);

        /*
         * The ctrl register must be written first, with the EN bit set other
@@ -556,22 +557,22 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
         * BURST_LENGTH + 1 bits are received
         */
        if (spi_imx->slave_mode && is_imx53_ecspi(spi_imx))
-               cfg &= ~MX51_ECSPI_CONFIG_SBBCTRL(spi->chip_select);
+               cfg &= ~MX51_ECSPI_CONFIG_SBBCTRL(ss);
        else
-               cfg |= MX51_ECSPI_CONFIG_SBBCTRL(spi->chip_select);
+               cfg |= MX51_ECSPI_CONFIG_SBBCTRL(ss);

        if (spi->mode & SPI_CPOL) {
-               cfg |= MX51_ECSPI_CONFIG_SCLKPOL(spi->chip_select);
-               cfg |= MX51_ECSPI_CONFIG_SCLKCTL(spi->chip_select);
+               cfg |= MX51_ECSPI_CONFIG_SCLKPOL(ss);
+               cfg |= MX51_ECSPI_CONFIG_SCLKCTL(ss);
        } else {
-               cfg &= ~MX51_ECSPI_CONFIG_SCLKPOL(spi->chip_select);
-               cfg &= ~MX51_ECSPI_CONFIG_SCLKCTL(spi->chip_select);
+               cfg &= ~MX51_ECSPI_CONFIG_SCLKPOL(ss);
+               cfg &= ~MX51_ECSPI_CONFIG_SCLKCTL(ss);
        }

        if (spi->mode & SPI_CS_HIGH)
-               cfg |= MX51_ECSPI_CONFIG_SSBPOL(spi->chip_select);
+               cfg |= MX51_ECSPI_CONFIG_SSBPOL(ss);
        else
-               cfg &= ~MX51_ECSPI_CONFIG_SSBPOL(spi->chip_select);
+               cfg &= ~MX51_ECSPI_CONFIG_SSBPOL(ss);

        if (cfg == current_cfg)
                return 0;
@@ -616,14 +617,15 @@ static void mx51_configure_cpha(struct spi_imx_data *spi_imx,
        bool cpha = (spi->mode & SPI_CPHA);
        bool flip_cpha = (spi->mode & SPI_RX_CPHA_FLIP) && spi_imx->rx_only;
        u32 cfg = readl(spi_imx->base + MX51_ECSPI_CONFIG);
+       u8 ss = min_t(u8, spi->chip_select, 3);

        /* Flip cpha logical value iff flip_cpha */
        cpha ^= flip_cpha;

        if (cpha)
-               cfg |= MX51_ECSPI_CONFIG_SCLKPHA(spi->chip_select);
+               cfg |= MX51_ECSPI_CONFIG_SCLKPHA(ss);
        else
-               cfg &= ~MX51_ECSPI_CONFIG_SCLKPHA(spi->chip_select);
+               cfg &= ~MX51_ECSPI_CONFIG_SCLKPHA(ss);

        writel(cfg, spi_imx->base + MX51_ECSPI_CONFIG);
 }
--
2.26.2

Chris Lesiak
Principal Design Engineer, Software
402-467-0693

------------=_1665156553-5775-35
Content-Type: multipart/related; boundary="----------=_1665156553-5775-36"

------------=_1665156553-5775-36
Content-Type: text/html
Content-Transfer-Encoding: 7bit

<html><body><p>The MX51_ECSPI_CTRL and MX51_ECSPI_CONFIG registers have bit fields<br/>
that only support the four slave select channels.  If we are using<br/>
a gpio to support chip_select &gt; 3, we need to be careful not to<br/>
write outside the bit fields.  Probably the biggest issue is the<br/>
2-bit CHANNEL_SELECT field of MX51_ECSPI_CTRL overflowing into the<br/>
BURST_LENGTH field.  That will likely cause a DMA TX timeout.
</p><p>To prevent this, when chip_select &gt; 3, use slave select = 3.
</p><p>This should allow up to four channels using the built-in slave<br/>
selects, or any of the first three chip selects optionally using<br/>
built-in slave selects with gpio used for additional channels.
</p><h1><a name="section_1">Signed-off-by: Chris Lesiak &lt;chris.lesiak@licor.com&gt;</a></h1>
<p> drivers/spi/spi-imx.c | 24 +++++++++++++-----------<br/>
 1 file changed, 13 insertions(+), 11 deletions(-)
</p><p>diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c<br/>
index 30d82cc7300b..7ed493200951 100644<br/>
--- a/drivers/spi/spi-imx.c<br/>
+++ b/drivers/spi/spi-imx.c<br/>
@@ -521,6 +521,7 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
</p><pre>
        u32 testreg, delay;
        u32 cfg = readl(spi_imx-&gt;base + MX51_ECSPI_CONFIG);
        u32 current_cfg = cfg;
+       u8 ss = min_t(u8, spi-&gt;chip_select, 3);
        /* set Master or Slave mode */
        if (spi_imx-&gt;slave_mode)
@@ -535,7 +536,7 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
                ctrl |= MX51_ECSPI_CTRL_DRCTL(spi_imx-&gt;spi_drctl);
        /* set chip select to use */
-       ctrl |= MX51_ECSPI_CTRL_CS(spi-&gt;chip_select);
+       ctrl |= MX51_ECSPI_CTRL_CS(ss);
        /*
         * The ctrl register must be written first, with the EN bit set other
@@ -556,22 +557,22 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
         * BURST_LENGTH + 1 bits are received
         */
        if (spi_imx-&gt;slave_mode &amp;&amp; is_imx53_ecspi(spi_imx))
-               cfg &amp;= ~MX51_ECSPI_CONFIG_SBBCTRL(spi-&gt;chip_select);
+               cfg &amp;= ~MX51_ECSPI_CONFIG_SBBCTRL(ss);
        else
-               cfg |= MX51_ECSPI_CONFIG_SBBCTRL(spi-&gt;chip_select);
+               cfg |= MX51_ECSPI_CONFIG_SBBCTRL(ss);
        if (spi-&gt;mode &amp; SPI_CPOL) {
-               cfg |= MX51_ECSPI_CONFIG_SCLKPOL(spi-&gt;chip_select);
-               cfg |= MX51_ECSPI_CONFIG_SCLKCTL(spi-&gt;chip_select);
+               cfg |= MX51_ECSPI_CONFIG_SCLKPOL(ss);
+               cfg |= MX51_ECSPI_CONFIG_SCLKCTL(ss);
        } else {
-               cfg &amp;= ~MX51_ECSPI_CONFIG_SCLKPOL(spi-&gt;chip_select);
-               cfg &amp;= ~MX51_ECSPI_CONFIG_SCLKCTL(spi-&gt;chip_select);
+               cfg &amp;= ~MX51_ECSPI_CONFIG_SCLKPOL(ss);
+               cfg &amp;= ~MX51_ECSPI_CONFIG_SCLKCTL(ss);
        }
        if (spi-&gt;mode &amp; SPI_CS_HIGH)
-               cfg |= MX51_ECSPI_CONFIG_SSBPOL(spi-&gt;chip_select);
+               cfg |= MX51_ECSPI_CONFIG_SSBPOL(ss);
        else
-               cfg &amp;= ~MX51_ECSPI_CONFIG_SSBPOL(spi-&gt;chip_select);
+               cfg &amp;= ~MX51_ECSPI_CONFIG_SSBPOL(ss);
        if (cfg == current_cfg)
                return 0;
@@ -616,14 +617,15 @@ static void mx51_configure_cpha(struct spi_imx_data *spi_imx,
        bool cpha = (spi-&gt;mode &amp; SPI_CPHA);
        bool flip_cpha = (spi-&gt;mode &amp; SPI_RX_CPHA_FLIP) &amp;&amp; spi_imx-&gt;rx_only;
        u32 cfg = readl(spi_imx-&gt;base + MX51_ECSPI_CONFIG);
+       u8 ss = min_t(u8, spi-&gt;chip_select, 3);
        /* Flip cpha logical value iff flip_cpha */
        cpha ^= flip_cpha;
        if (cpha)
-               cfg |= MX51_ECSPI_CONFIG_SCLKPHA(spi-&gt;chip_select);
+               cfg |= MX51_ECSPI_CONFIG_SCLKPHA(ss);
        else
-               cfg &amp;= ~MX51_ECSPI_CONFIG_SCLKPHA(spi-&gt;chip_select);
+               cfg &amp;= ~MX51_ECSPI_CONFIG_SCLKPHA(ss);
        writel(cfg, spi_imx-&gt;base + MX51_ECSPI_CONFIG);
</pre>
<p> }<br/>
--<br/>
2.26.2
</p><p> <br />
<table cellpadding="0" cellspacing="0" border="0" style="font-family: sans-serif; line-height: 1.4; box-sizing: initial; max-width:400px; color: #363636; border-collapse: collapse;">
        <tr>
            <td valign="top">
                <table cellpadding="0" cellspacing="0" border="0" width="400" style="font-family: sans-serif; border-collapse: collapse; color: #323232; width:400px; line-height: 14px;">
                    <tr>
                        <td valign="top" style="border-bottom:#0077c8 3px solid;padding-bottom: 6px;">
                            <table cellpadding="0" cellspacing="0" border="0" width="400" style="font-family: sans-serif; border-collapse: collapse; color: #323232; width:400px; line-height: 14px;">
                                <tr>                                 
                                    <td valign="bottom">
                                        <table width="280" cellpadding="0" cellspacing="0" border="0" style="font-family: sans-serif; width: 280px; border-collapse: collapse; color: #323232; line-height: 14px;">
                                            <tr>
                                                <td valign="top">
                                                    <p style="margin: 0.75pt; color: #000000; font-size: 16px; line-height: 16px; font-family: Arial, sans-serif;font-weight:bold;"> Chris Lesiak </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top">
                                                    <p style="margin: 0.75pt; font-size: 12px; font-family: Arial, sans-serif;">
                                                        <span>Principal Design Engineer, Software</span>
                                                    </p>
                                                </td>
                                            </tr>
                                            
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" style="padding-top:10px;">
                            <table cellpadding="0" cellspacing="0" border="0" width="400" style="font-family: sans-serif; border-collapse: collapse; color: #323232; width: 400px; line-height: 14px;">
                                <tr>
                                    <td valign="middle" width="268">
                                        <table cellpadding="0" cellspacing="0" border="0" width="268" style="font-family: sans-serif; border-collapse: collapse; color: #323232; width:268px; line-height: 14px;">
                                            <tr>
                                                <td valign="top" style="padding-bottom:8px;">
                                                    <p style="margin: 0.75pt; font-size: 12px; font-family: Arial, sans-serif;">
                                                        <a href="https://www.licor.com" style="text-decoration: none; color: #333;">www.licor.com</a>
                                                    </p>
                                                </td>
                                            </tr>
                                            
                                            <tr>
                                                <td valign="top">
                                                    <p style="margin: 0.75pt; font-size: 12px; font-family: Arial, sans-serif;">
                                                        <span style="font-weight: 700; color: #0077c8;">Phone:</span>
                                                        <a href="tel:402-467-0693" style="text-decoration: none; color: #333;">402-467-0693</a>
                                                    </p>
                                                </td>
                                            </tr>
                                            

                                            <tr>
                                                <td valign="top">
                                                    <p style="margin: 0.75pt; font-size: 12px; font-family: Arial, sans-serif;">
                                                        <span style="font-weight: 700; color: #0077c8;">Email:</span>
                                                        <a href="mailto:chris.lesiak@licor.com" style="text-decoration: none; color: #333;">chris.lesiak@licor.com</a>
                                                    </p>
                                                </td>
                                            </tr>

                                             
                                        </table>
                                    </td>
                                    <td valign="middle" align="right" width="132">
                                        <p style="margin: 0.75pt; line-height: 0px;">
                                            <a href="https://www.licor.com/">
                                                <img  style="border: 0; display: block; border-radius: 0px;" width="130" alt="LI-COR" src="cid:5242e909a8e684eccf75136f296ac35d305cdadf" height="26" />
                                            </a>
                                        </p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

<tr>
<td valign="top" align="justify" width="550" style="max-width:100%;padding-top:5px">
<p></p>
</td>
</tr>

<br />
</p></body></html>
------------=_1665156553-5775-36
Content-Type: image/png; name="logo.png"
Content-Disposition: inline; filename="logo.png"
Content-Transfer-Encoding: base64
Content-ID: <5242e909a8e684eccf75136f296ac35d305cdadf>

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

------------=_1665156553-5775-36--

------------=_1665156553-5775-35--

------------=_1665156553-5775-34--
