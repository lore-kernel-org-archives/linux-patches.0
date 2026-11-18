Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018796;
	b=VqIRwm/JWv0Cl7NkTiJRIXmVcfQtuDS67hSualrErPmm1jTwqndy/F61R/Eem5yjQAOK
	 3l5rV1szv2KNU2tcz6tCV8VyJ1PoECAVD6TJwKUgJpki8x7o0Rz6H4sQcPkzS6rKHoVG5
	 F2sBYezK7TvQ0WbUeJeLO7hfI03MiJhXh+vW2cttWG00MajLbnhGNSWCJu+uKOB1okHB5
	 McReaFHgkHEZKdFAHqOUUOd9OWzyAZ4RVOqaJ/cEGdY2IW/HsYRhAbZbK2VLAv6WHSyfQ
	 8APdMeLnFrekfNboxRapovkziXgQ+e7JA60l6eCWP1Tz33xWwaUHUia6yA+GmdOI6eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o8Yz1mJVJTGwDGf3HYf/xqGbLy4Pk+tq3iq7QqtKAmQ=;
	b=i0VW8UELDWpWnlJKKgLj8kMiI1zxq1lrlNnSppcZe4QjlB23+ZA6j/qscsQ7AEY4pPaK
	 ERMG84FTLsCaj6EhHkFQa9Rw92v0Ry2kbU6rcuJwp8smktiow34a9+24pXCBWMNd83O5V
	 8oKERMJxxYmBc0HruUT2ShsIsHUNguLbiyvTwxbN5uUIkW/kZD8hv1MKYISntVqpc3Rw2
	 49D4w1B52sivtLW0eEUJIBKFPyNrRHni29zCi9isZ2nCrUXHYFzrWoZlfr0LPyD0o3yxo
	 6qfuqG8gbvYkaOmC8AZqJ6zHMnac+3u8yJMd6Nhkja4hsWnJiT7R4TtxzJDvMuwZpEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jFiwSjJL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E491D606A31C;
	Wed, 18 Nov 2026 16:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jFiwSjJL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FD61F000C8;
	Wed, 18 Nov 2026 16:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018795;
	bh=o8Yz1mJVJTGwDGf3HYf/xqGbLy4Pk+tq3iq7QqtKAmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFiwSjJLBAqIXTToFOmBPTKa4GMHK4agRiDaGlOIgsNloAjYJhdpMnWp3fQNJpvwB
	 cUaP3W9xvW4DuoEjxifZ2HMHqD1ZFdH4PyC4Y5CLbn+2UN3Ius92weiElbbTfG0tEh
	 B8cu+pVpYWlWB6ixXJas1f9QcJWVStW2O36FHQ8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1350/2651] dmaengine: ste_dma40: Fix logical channel bounds check
Date: Wed, 18 Nov 2026 15:43:10 +0100
Message-ID: <20261118150336.626423977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1b1edcb724804..fcb0749286757 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1881,15 +1881,26 @@ static int d40_validate_conf(struct d40_chan *d40c,
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



