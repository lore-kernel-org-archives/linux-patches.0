Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049724;
	b=nUvgzjgj/McrLvIXaGd1tclKUPbACHf31I6puCf5plEyLusfn2KhyYcnypCvvzJKZ9vu
	 IteDEpWGBW01bn7BaK8VEqe0NXRv8q/2jToI9yuP9GEp60Ujf1OUUk9a59wKEij3ArYCX
	 GYbtVPK69bhNDMQj4Zvj8ZUwiPg51hld73gus8AuQOr6JPoUXyCaXOBhJyQGwvw1jXjpq
	 6NWoIAGUov6yP+KsMWQO0g3umUAshI2Ri+WXJTnR7itu8+IqHoaOjFDyBTdJ9SILYMXVY
	 5QJdhOk1+PlQBL2gGOZAzXyItve/im//fbj6E1VHvhpjnp3EJ4gwa4RXv0kA+iwBkkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XnG2p3IrW/66k5+CGyf/sAHVWBHVoR9Jc/C2q0N1XWg=;
	b=bHAS5C8SoEof1rB7nTsiBc0Y2GV92DKxSp5dEi+/qMQDiY6AnlVH9VaV42HOke26cZpA
	 ozYutmG8MDNYze41aVUG+nVphKOroSHTWBMa0wmcNU2Djvj26VvcsQw7bcHEV8fekuy5G
	 dhoQmi9gd7tyykUN7IqkpMKUYhF000K0n7IPZU4q6h6kuAa2i8OmLrfwis4T0PTkD72ML
	 7uDvs0ZTmp0kVzk85b1haIaloawYIZIgA40UThHE0RkppbrYyTJzsHrcKQ6OJKJA4Ckbm
	 iZeBiiqbUK6bXm6ff3ZWdVixeS+m1s6l0GMQ+Rzu6oWQ46FyPag/YHvalbYuiKIQR+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qyGu0aVq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D73606A33B;
	Thu, 19 Nov 2026 00:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qyGu0aVq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138201F000C4;
	Thu, 19 Nov 2026 00:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049724;
	bh=XnG2p3IrW/66k5+CGyf/sAHVWBHVoR9Jc/C2q0N1XWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyGu0aVqiGtD3izMcli39mVHdpGPrXYXX/upCmZAip/5RMo8WTBFwxU92PGm2a9lf
	 dFBXeomgQojCtXbUa+czC2KwbB8A802gZt3rDBaJ2mvSDMMi6IesGl7cH88kRCHBnz
	 hN0v45/M0LI1f8+ijkWOiFDVS9RWn4ahne+sZ/zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2403/2857] serial: max310x: remove trailing whitespaces
Date: Wed, 18 Nov 2026 15:57:17 +0100
Message-ID: <20261118150328.055374291@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit cee8e0cc9308ab55d4c3bd8eae5f6b4b65898e59 ]

Fix coding style. No functional changes.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231011130317.3562401-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4efacb600bf9 ("serial: max310x: fix breaks not reaching the wire in RS485 mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index cad593d7dbee8..56bd6de30c5bd 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -412,7 +412,7 @@ static int max14830_detect(struct device *dev)
 	ret = s->if_cfg->extended_reg_enable(dev, true);
 	if (ret)
 		return ret;
-	
+
 	regmap_read(s->regmap, s->if_cfg->rev_id_reg, &val);
 	s->if_cfg->extended_reg_enable(dev, false);
 	if (((val & MAX310x_REV_MASK) != MAX14830_REV_ID)) {
-- 
2.53.0



