Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048758;
	b=clDBNdANxAIBD/3eGbF2k/Z16PDCiqqegcRcsqJS2L6Bf2GmxgzoRTJXzex0NmGlCU5O
	 Sn9f88XW5icW9crMh+S88M4IpkXsngRdSKHXKjvJHCEJpB37v9tG1Wasq05k+reJfd4ZB
	 yT5FZolGdvIvjvtmNLVh1wNWaiQ98j5UZ4CMRj9JlDQJc/1/XKEGGW5E1pB257vNNX/NA
	 xxN3erzt6vxkO5UBdU2yAWvVGYaj0iJXPfK0iFRSr0a6NTMPTIEl8xwHbqOyPqZN8oU7n
	 pYhEkq+QCuq/rjZpnnsX7zwSIWPRsz8YbNc0MqvZLUNOHaxbez5ybIS+F+dhrYU/9/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KqdT8cm/We/RAD/nuM7UBMFzw0XvMx8LhtjgW2E5G80=;
	b=To6nSGNXqcyfiLV766lSncP/8ZVmf6xUM6r4bmZyYyOKMFBOZcje9kC33xvuM6Yv+rd+
	 pvicqcXogcPlL3uo69xWazU/rY5jlaN7hZ1xlHtj29XSeTMlqXynuVhxN0GnarSonDvyG
	 KhmVSziYt67j6MHOQMrWvt/oG/lGEi068jkU8ed+OG1UwZbY2iQkAjMFSziKFkbA+33+t
	 3wrNBDo4QUWC9FD3B2QwNys2eDYhjD+KzmZRj9RQesFOEDHWh5bsi66bKexYgSE7m1Zyh
	 o9/mRjLU895xCuLwJDtsPtwPP/ZKrEDNgaTBD0V7IR9tMk42+jJBrM7vkJLI/JSjf0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1KOYp3rh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1787606A320;
	Thu, 19 Nov 2026 00:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1KOYp3rh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33661F000C4;
	Thu, 19 Nov 2026 00:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048758;
	bh=KqdT8cm/We/RAD/nuM7UBMFzw0XvMx8LhtjgW2E5G80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1KOYp3rhT4PZVkXCUbdIRrnUiME5B5KUljRbOX+zymlNCLeaYJu/4eoxJi+BtTjFx
	 y7cHVYOAHOtc/N7Mn/JelA8Ft76a/+a+9nr4GD8vcAoofHsPrmtCY0js0otUJWiGrS
	 rGC0tEkferZ5ROExJwxY+McMvZeKtEv9kYlmaRpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2108/2857] ASoC: mediatek: mt8192: switch to devm_clk_get_optional()
Date: Wed, 18 Nov 2026 15:52:22 +0100
Message-ID: <20261118150317.312756470@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 6f4edfdce0099dc0c346c78c85f58a23d4ee646e ]

Switch from devm_clk_get() to devm_clk_get_optional() when requesting
clocks, as optional clocks automatically return NULL when not present
instead of requiring manual check and NULL assignment.

Additionally, handle clock errors properly using dev_err_probe() to
propagate error codes (such as -EPROBE_DEFER) on failure instead of
just printing a warning and continuing with NULL pointers.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-clk.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
index 6983c63a678f0..c26f68ec6040f 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
@@ -676,13 +676,10 @@ int mt8192_init_clock(struct mtk_base_afe *afe)
 		return -ENOMEM;
 
 	for (i = 0; i < CLK_NUM; i++) {
-		afe_priv->clk[i] = devm_clk_get(afe->dev, aud_clks[i]);
-		if (IS_ERR(afe_priv->clk[i])) {
-			dev_warn(afe->dev, "%s devm_clk_get %s fail, ret %ld\n",
-				 __func__,
-				 aud_clks[i], PTR_ERR(afe_priv->clk[i]));
-			afe_priv->clk[i] = NULL;
-		}
+		afe_priv->clk[i] = devm_clk_get_optional(afe->dev, aud_clks[i]);
+		if (IS_ERR(afe_priv->clk[i]))
+			return dev_err_probe(afe->dev, PTR_ERR(afe_priv->clk[i]),
+					     "failed to get clock %s\n", aud_clks[i]);
 	}
 
 	afe_priv->apmixedsys = syscon_regmap_lookup_by_phandle(of_node,
-- 
2.53.0



