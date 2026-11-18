Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017664;
	b=zGiazuFcZ0AnF6zf8jeYgH15rRCUot1j7r+BSPYX2W90RWvh1uc/Vk5LttcooIaM/s94
	 4sm26g4gqeC9qqKJmPv9Q53cCrN8p9xSEn3uFVKxdMUzGeW9Zbppb6QLDQ4SDguxjBRqP
	 4/Pn4IqjgM4AdXV13dLoaOvVpCKJNAG8C70v0CVLz5Amk/KO0xUhqF87FUva1yEmZeQ5F
	 bzVNkeVNPjfOILgxaCG2v8+PG65RDyKnC+r+vFlx6nlY7XAdQjowTHe/JtoNrlm5FponJ
	 Tb7ofmiq/AQ/dA0pEWIRNgD5gB4tdelSQYtx2vSumfwWxLYAjK1oTP6cbLuXUZREeOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lWyOg1tR6aFX6uFOsGFiR+TgHuX8cg1XdiwmhFKPzt4=;
	b=D/E+mqMt7Ar+oksyzCw2rKCUjcmmpgFZKF+basaHNNAvLXdFwYT0zvNWEAwfqiq8ZF+j
	 MdOlCAg9kmo46w9/nEf8HKDfSuME4lSbIFfCKHMZt3mA7w8sTeSKVZkSW0tKOa/PmHUVJ
	 aA8+kkq72b6q3J1MV6ywBsOLr65DXBulXOSYsGgGRbShmRQk42fUolldVWzfePXH0bBgA
	 O6DR2DDId1yTBnyObbkW5fKgBvc/lzcWFp+J5DtQty4GvY0pgc5FWW4ki6DwmcQ2be2uE
	 FVm/KyW5k+LZYOEAzMs/pPFwajZ3HKS+g27yAfw2nv0Q3dyTo1zqpoqIG0xDUkiVC4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mv3LRrlR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523F6606A325;
	Wed, 18 Nov 2026 16:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mv3LRrlR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9CB1F000C4;
	Wed, 18 Nov 2026 16:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017664;
	bh=lWyOg1tR6aFX6uFOsGFiR+TgHuX8cg1XdiwmhFKPzt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mv3LRrlR1teFN1xK8tykFJoZXqDgz3Kr8+R6JiIjplaO9Ynq0TIAvKXer5PuZPPtm
	 SXC0KJrUs6KookfZ6x3njj7B8JAlLHVFoAjIhRdf+1wqLk+erdNqPHGeYjRIlk35WT
	 C643Km5jI0wrP2fszICcruZqXxdAXJFN1CR7Dqww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0966/2651] ASoC: mediatek: mt8192: switch to devm_clk_get_optional()
Date: Wed, 18 Nov 2026 15:36:46 +0100
Message-ID: <20261118150322.681650783@linuxfoundation.org>
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
index 77f596cab92da..9b9a3465ddb52 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
@@ -672,13 +672,10 @@ int mt8192_init_clock(struct mtk_base_afe *afe)
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



