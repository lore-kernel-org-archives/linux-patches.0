Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080EA376;
	Wed,  2 Oct 2024 13:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876174; cv=none; b=MaXBpBOinvY32OkgbiDYMTBbv1lLITlFikKp0koVhu4muO6GlgnZ8WMe97+hQ1FNxbiy4gdYycO3aUNSwAma+P90IouONWNuF7gI9oZTLoRbfWBJkSS5+gi4o/2DfQ3zjilku2YP/bIInSYZhF5vCEWy1zlfS1NXrvQfpTv4JWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876174; c=relaxed/simple;
	bh=Pc1p23Z7SFiYKt+T4zprHn6yXsmFfWOQpmOPpaZ0s9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WD7Jrq1SV2c2CllPMaAiI/HbEZt+zF6uottqjtKndJPs9u7kLe9TwaNegVhAG5TwSmTWlFjoC5pz3OfV7ubK8q7HrKBwXeSBuemR4on+EiI+mFebrl621HT2kKItHR5MYXm80kN76En45tfIV/GjGXDcvHMH2j9b1PznsC8Sy+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhVVLe+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhVVLe+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854AAC4CEC5;
	Wed,  2 Oct 2024 13:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876173;
	bh=Pc1p23Z7SFiYKt+T4zprHn6yXsmFfWOQpmOPpaZ0s9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhVVLe+KtCdsDMv06dloHTeM3+FtTuQGA9HQxy1WB9EkSgkGjr27CGo9iwLtG4w2P
	 EGOUT3O4WY5No6m295heMwVyh2gyfhs2VBvvAlUPDFEgzbB42MqqMWgnCSC65zHaF6
	 4Z/jqvLYJQskda4TeaT8Fi7vwRDQZW5jkSHGkiYY=
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
Subject: [PATCH 6.11 352/695] remoteproc: imx_rproc: Correct ddr alias for i.MX8M
Date: Wed,  2 Oct 2024 14:55:50 +0200
Message-ID: <20241002125836.498998911@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 144c8e9a642e8..3c8b64db8823c 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -210,7 +210,7 @@ static const struct imx_rproc_att imx_rproc_att_imx8mq[] = {
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



