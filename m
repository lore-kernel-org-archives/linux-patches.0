Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032940;
	b=LwKYQK6sXqTUpQHlBldpmMYCrNpddpyP7V998iAL5rNF09two7A3Rg565y4u483CoCyw
	 k/UjiUx/PhEBFVj6QbNWGfFElLxwbxQF05LG8tbtqnkInWhas5OXOWzwNdgtdgRZKfq2k
	 8+wtTJy3qquGGUa1YBbLY8FDtKQhxvhD1aN1WcYcsIBa6khoDvgrT7EUw38oaMrALIyuf
	 bMOe9KKw1d95HOirK1PDul3UTxK+UqmWvGJv9gPSXul2Y+1nykYDdmeKTf9hxik+382ax
	 hxHP1+6ioMANDPvyCKWzq0O/rYvrQ0cAjP85kq7Z7fsKDi+F2XSRCFuKAw+T6h+UK8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/egvt6zLaIxGi0yaNSfXaT6B4bDyJmiaipc/20Px/1o=;
	b=Da7UR0UoXILu3Jr42t+MqBgwpPZTyz04IoLosHG5WPpkNGo2A4HCC6915wtgePrM0GVf
	 C/INGn/48EAGeL7NzW01EQhOitFzXkE60qpGW7WhfCKfCOyNxtZNJXnm/TwXDZi6hI7at
	 BIZ1pgdISK0llVnWMpd6Ffonwwtx2ttl4Xt+3/XzQ2Lv4Ta+2ediu+ftxzURV+ReJo43Q
	 /8XqsBffsn+GP1cusoeIAQG/24nflwy2CIGp2IQhcdqAgSh1kwnOJZluYGUCMWCdQPihl
	 e6uvIQIgZ1o6sfI3byco39QhYzTd9lTHrBrYVb51LVNk0uYMihRZFSMOBej2ihMeOWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GHwM/mAE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4BA606A32C;
	Wed, 18 Nov 2026 20:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHwM/mAE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F441F000C5;
	Wed, 18 Nov 2026 20:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032940;
	bh=/egvt6zLaIxGi0yaNSfXaT6B4bDyJmiaipc/20Px/1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHwM/mAE5PIeupZHCNFKSyEEStiobA1fR1aGPJcaYymnOMZMM8q59ncEkhRTfUxTd
	 81P2hZsUYqim2XVXAvQ5AnOavgS8qtWsc6pBZI8JdlyUZuKpoKxfCEzXHNMip6rcqh
	 h1LtJLD6J8P/LJkpkJjiFKdIOIgiETb6QZy/fKcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1589/1756] clk: lmk04832: Handle reset GPIO lookup errors
Date: Wed, 18 Nov 2026 16:01:56 +0100
Message-ID: <20261118150113.193157821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 5c7c0cbf81bba69695efa12e451f0f2ecd4b92a5 ]

devm_gpiod_get_optional() may return -EPROBE_DEFER or other errors,
but lmk04832_probe() currently ignores them.

Check the return value and propagate errors from the reset GPIO lookup.

Fixes: 3bc61cfd6f4a ("clk: add support for the lmk04832")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261006110501.57051-1-phucduc.bui@gmail.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-lmk04832.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/clk-lmk04832.c b/drivers/clk/clk-lmk04832.c
index c997e74919961..8c51cbe44ac53 100644
--- a/drivers/clk/clk-lmk04832.c
+++ b/drivers/clk/clk-lmk04832.c
@@ -1413,6 +1413,9 @@ static int lmk04832_probe(struct spi_device *spi)
 
 	lmk->reset_gpio = devm_gpiod_get_optional(&spi->dev, "reset",
 						  GPIOD_OUT_LOW);
+	if (IS_ERR(lmk->reset_gpio))
+		return dev_err_probe(lmk->dev, PTR_ERR(lmk->reset_gpio),
+				     "failed to get reset GPIO\n");
 
 	lmk->dclk = devm_kcalloc(lmk->dev, info->num_channels >> 1,
 				 sizeof(struct lmk_dclk), GFP_KERNEL);
-- 
2.53.0



