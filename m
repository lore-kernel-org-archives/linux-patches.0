Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040889;
	b=0oYln4k+TKLQRdcmnXEHoAv+/hLrDxBKXbiLouM3EF6Boq9zBUX6EZ1kxdgWRXZW7ZrT
	 yXwdDkUB0M0P0FhRWt+1AUMIVOtgoDmJGXHOvD2fsgsyV24LoP5H2Ty7j2Qkvrp4h0GxR
	 DFOXl7PsBmxoQPLw4FqAyctbAuQcVuHcGKZoKhSjG9Vhvk8NCdwsGWxSAcIX64TDF8m/R
	 6NhfNfEvrFby56hr4+YEp3XjSEfVVZ4HKLHupHo3SR7eTdjHfHicQQh2elyl1pcfQPyOG
	 JgELtrgXeYuM4WbCp801nYgENvCV6wEN8l0Gf0WzjWs6AS+fgbZCkIRe0vb/JT4xjbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u8cKBY/486+tgAhtDIb9fmCXUxDq9YE6c7/epVmAX7Q=;
	b=BgD/zi+VHloGIOW1+Mv6pwkuD4rKS8LNoAm5p0T9X/83xxu1zQ9BPuUvaPx2eiPpXNSK
	 WO9TM81HspRepjFvX2MyzeDBlbdadin/it/mGhYKO0I4NRi0wM2GyJtNXRGZhldIuo+US
	 juZsJq8OWHjWELhx0U0Kws15QZhlb5tjFTZ6b9jDEuLfLfmcH/tTA9HteEduGQKS10oKf
	 aC5PnNZEqiU/8zvhnjQlPtbU2KDmi5/IXIvVWobzdQh3b8zj59FsYR1cUddb1NXoydTn0
	 ypi24wT0tfme11PdyLxUaSm0mU0QLxSNtoeZjaA8EZqyfHMOe0aeu0PhGe/AVoDWyAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sTaPQDsB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C1D606A325;
	Wed, 18 Nov 2026 22:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sTaPQDsB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18421F000C4;
	Wed, 18 Nov 2026 22:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040888;
	bh=u8cKBY/486+tgAhtDIb9fmCXUxDq9YE6c7/epVmAX7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTaPQDsBFqXBulP8wsVQN+WJm8DYC3bZIDb6YLG1P5Md9aEV+kQNhoKMGoEB/of5d
	 qTQ7Nc1T+bAGR7yIVlrxwivWgk+UXfuA11Q+cwKo/SsQg7NppFAVG1zsB5jMIrkLYZ
	 KT06u8XvdaOf/caqsGmjpSmkXD9aYJS4oSiRYtwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2616/3318] dmaengine: ste_dma40: Fix logical channel bounds check
Date: Wed, 18 Nov 2026 15:53:58 +0100
Message-ID: <20261118150439.602498452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 57938e0c2a24f9f792fe9f611391ef6b58d1aa21 ]

d40_validate_conf() checks the raw dev_type against num_log_chans,
but d40_allocate_channel() derives the lookup_log_chans index as either
2 * dev_type or 2 * dev_type + 1.

Validate the dev_type against the derived logical channel index limit so
channel allocation cannot write past lookup_log_chans.

Fixes: 26955c07dcf3 ("dmaengine: ste_dma40: Amalgamate DMA source and destination channel numbers")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260618051539.15E201F000E9@smtp.kernel.org/
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-19-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 3d244cf9808a2..83c2642e788ae 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1752,15 +1752,26 @@ static int d40_validate_conf(struct d40_chan *d40c,
 {
 	int res = 0;
 	bool is_log = conf->mode == STEDMA40_MODE_LOGICAL;
+	bool invalid_dev_type = conf->dev_type < 0;
 
 	if (!conf->dir) {
 		chan_err(d40c, "Invalid direction.\n");
 		res = -EINVAL;
 	}
 
-	if ((is_log && conf->dev_type > d40c->base->num_log_chans)  ||
-	    (!is_log && conf->dev_type > d40c->base->num_phy_chans) ||
-	    (conf->dev_type < 0)) {
+	if (!invalid_dev_type && is_log) {
+		int max_dev_type;
+
+		if (conf->dir == DMA_DEV_TO_MEM)
+			max_dev_type = DIV_ROUND_UP(d40c->base->num_log_chans, 2);
+		else
+			max_dev_type = d40c->base->num_log_chans / 2;
+
+		invalid_dev_type = conf->dev_type >= max_dev_type;
+	}
+
+	if (invalid_dev_type ||
+	    (!is_log && conf->dev_type > d40c->base->num_phy_chans)) {
 		chan_err(d40c, "Invalid device type (%d)\n", conf->dev_type);
 		res = -EINVAL;
 	}
-- 
2.53.0



