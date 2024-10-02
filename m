Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1581474BC;
	Wed,  2 Oct 2024 14:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879966; cv=none; b=Y+o5E9g8TXBePGs4MjZwTBXDCTYUKOuVqiUiu1Ns9iL6SZ8ZHvdaRGn1V+lOEfJXoTf2cqwRPnuzZ2iSSwScP+g9bZmLK8avvT25eEHAUuw50dj1gXVaSWRr7Htffb9rQISS8yxni2Iw9nZesnwhcNM1eD1BkX4igSpQpeFnwQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879966; c=relaxed/simple;
	bh=RSgMgVlj+Dfgvg6qnpME0N2t1lm3fnq34lJlkd1dfXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qP8+UtT9F28dIJLtysseslTlZG3m9niAtK4prGs/FopVkYiZ8MQiNoks87Edw58RqOyYit+UtUewZevkmLg2RBHkAofSqfgGUjaFY0SU9S1Yszc+t2BNzxP5Xnvf0o7egsOBZ7RnXpvYlkbB72PJxOfEn09BPKYCTjAp1NMjHyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIOhzd+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIOhzd+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8973FC4CEC2;
	Wed,  2 Oct 2024 14:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879965;
	bh=RSgMgVlj+Dfgvg6qnpME0N2t1lm3fnq34lJlkd1dfXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIOhzd+ALCfrBhDwLmWq/2oZe+OTY0kbl6i8BO4xXc1sC8e6AWxFF+FdX+X4o/hXs
	 StRreU3+j/5efU2o1ccRIEFcmXUvIWlAcwpCu8Q/2ucE2n0vXAfvCHPt/+4A2WaSE3
	 2joyQq5hEqUvraC1TrO2f2gy1zzqHnVCpsU4Zn6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Lv <terry.lv@nxp.com>,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 267/538] remoteproc: imx_rproc: Correct ddr alias for i.MX8M
Date: Wed,  2 Oct 2024 14:58:26 +0200
Message-ID: <20241002125802.796190868@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit c901f817792822eda9cec23814a4621fa3e66695 ]

The DDR Alias address should be 0x40000000 according to RM, so correct
it.

Fixes: 4ab8f9607aad ("remoteproc: imx_rproc: support i.MX8MQ/M")
Reported-by: Terry Lv <terry.lv@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20240719-imx_rproc-v2-1-10d0268c7eb1@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index cfee164dd645c..ac32b46b4e0f8 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -213,7 +213,7 @@ static const struct imx_rproc_att imx_rproc_att_imx8mq[] = {
 	/* QSPI Code - alias */
 	{ 0x08000000, 0x08000000, 0x08000000, 0 },
 	/* DDR (Code) - alias */
-	{ 0x10000000, 0x80000000, 0x0FFE0000, 0 },
+	{ 0x10000000, 0x40000000, 0x0FFE0000, 0 },
 	/* TCML */
 	{ 0x1FFE0000, 0x007E0000, 0x00020000, ATT_OWN  | ATT_IOMEM},
 	/* TCMU */
-- 
2.43.0



