Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049199;
	b=P5szeXuKApsWxNfS039EAWxb9YSQUXXdP1KHoWTYuYBzUKJ6HXDJPfaeeN8AmL7CbO0o
	 wyuZMyhsG5BjcRsqAZp3JoqYzJNqdGqE06nE4eARRbR9HpQHUO4dYKDlZM6sTnnaauRTK
	 F+rFT7zqnx1CJ/UmH9itWNR4QLSqj6dOe8v+1avOvm5+HwNRsRl+FEmaOf2yUMluhYVcl
	 LgX8HdVq7MqvPTL2Hip9Ijl1lmGsjqv1l8Jug0W0dgnRsQtYhKtfm7eLpHXvvPEph4z38
	 /E7DTmKyID06LPJ1I6ZUMaG+d1/S3/gTsf4jOZofkSwX36/RYjXKadBFLLz2mv9amFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pKbAzW/TlaYJRHIQHJxF+BaBf1/GsIensHZGeQH7Xfs=;
	b=BQJe6pT546wNPUF5IlFRgSnNb10wxHRgZ+a9fmb5TlHtzLhQg2t1AFMxtVHKjugo/e75
	 UCY9h1AkMy4gCzAQZCtrhpcTzkz25OMOVC4iKcSBd5A3tgvJf4A0s9KJmGl/rdXiNmmPD
	 3+S2p+U6LVZWSXabr8X1zrr9yVoup7tEM17sw695toz7jTq6J7qfVFmML2uRT9J09r2gh
	 4Mr6qmvUI/mV7mWN5NQnrdmw3w+cjWlmNqBF5tDGzH11Re/GJ3ZAp/vMwZRxVuVqocguC
	 IGthdjgk4CZ3KOdWFWPxRZ7OEwD6lrcU+vjzEyea6P/uejS97oojJMwTFp7IpcEUqGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aty1mK3T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC03B606A320;
	Thu, 19 Nov 2026 00:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aty1mK3T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EB51F000C4;
	Thu, 19 Nov 2026 00:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049199;
	bh=pKbAzW/TlaYJRHIQHJxF+BaBf1/GsIensHZGeQH7Xfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aty1mK3Tbm8oL0+dw7W+LqcohuuHI+sY6dXOmWKq/AKkGD2YZVqL7caOXZE0lJl4W
	 gkw7OYRNof62rnaJDG6ctzClrW5OT16hQ3mQWd2q3creRM+jaQs+MYykGeGyl9wada
	 ya35l2Hgfm+AJgJs52d5OHKVlEXBO4ULuTIULW+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2265/2857] dmaengine: ste_dma40: Validate DMA specifier length
Date: Wed, 18 Nov 2026 15:54:59 +0100
Message-ID: <20261118150323.004938391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 9f1064ebe17cf3ab65ac6eb166398e02678aea33 ]

The DMA40 binding requires three cells, but d40_xlate() reads args[0],
args[1], and args[2] without checking args_count. A malformed provider node
can specify fewer cells, leaving some of these values uninitialized when
the OF DMA core invokes the translation callback.

Reject specifiers that do not contain exactly three cells before reading
the argument array.

Fixes: fa332de5c6b3 ("dmaengine: ste_dma40: Supply full Device Tree parsing support")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-17-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 270141bf57b26..6bdc1ce0d779e 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2397,6 +2397,9 @@ static struct dma_chan *d40_xlate(struct of_phandle_args *dma_spec,
 	dma_cap_mask_t cap;
 	u32 flags;
 
+	if (dma_spec->args_count != 3)
+		return NULL;
+
 	memset(&cfg, 0, sizeof(struct stedma40_chan_cfg));
 
 	dma_cap_zero(cap);
-- 
2.53.0



