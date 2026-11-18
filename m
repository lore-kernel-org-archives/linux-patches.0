Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016430;
	b=eGWavk/w40Lnp40j7bRmF3dGtUrpbZ7eEdNd5CnvtYG2wYAOHw3IGO8SREoM6EuKpouD
	 Y00gUFB43VzmkMuCymU4mK/QhRtE3YRhR0Ny3P7kHdG2Aiqj4p48sUf/tBRvUHvnYqlYS
	 /bPTVExmu2rVM60rVZENRv6mpoCQvojNwGAYchMerVe/6noB8huhI/dpkZfmgx90XCNbW
	 j+mS2zeOGpRYTHPwGFf1BPV/yfj6Wx6dr55rhKsO1xyvZbWK6P18Fr99mUTP8IekecYiz
	 H7pDOnAr/84JPUm5tblzE5EZM5NMzr2tCUK6iMXP+3F8wx8i9Z+oXjFBgAv/FgUW1Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VdW7IDgCnJ4qpu0lrN46RsYHnk0NOkoT+LrjZWN5ttk=;
	b=b481ujpW+Kra8ieojiu3XLVCemGYNk6DgmahN4PY9XqZSzmMG6RJpdzj1+A++o3x13nD
	 ZIffYVtFBW5FN0e5B3RF1mN9xwzCZjn5tYWf02R40Vr/XE6DoSaVyPQZQXVoZHFPZ+BmY
	 XK/ZmZyoQ0m+c9vuj12u4b6trx3cm6iMlaGbKFh2cA+Fa5TEz4cilTgMEzDvlCWY3+9Le
	 rUHrIPUO+ARz/ZgUBZkOkhRBIGA3XO1K9juD4KXtCzqRiEJ213ttX+KTg0I4OTpEKYU+R
	 Nnc8ZIyeb4nzD0V/V8InKnaKR7i/K1r5QQvpz5wiTp9N5sTcRk73ol3XeDZkBiBPXqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QsSMikmb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF024606A325;
	Wed, 18 Nov 2026 15:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QsSMikmb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0271F000CA;
	Wed, 18 Nov 2026 15:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016429;
	bh=VdW7IDgCnJ4qpu0lrN46RsYHnk0NOkoT+LrjZWN5ttk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsSMikmbf5m1S9Gl42M/dpVAgsB2GO/MsnEgyhJWKCojpUlz8rRONkhwbMZRhcGKy
	 IFMrsHpA8i+YUAALbUB7HccwIVvWixJ1qcVwKdj729utgjK3AP79Ow8i5WGQFp485a
	 JShgBbJbSy7BPI7t+sovbGvKddZ8x/7whJ9rJWq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0527/2651] ASoC: mediatek: mt8189: Validate MCK ID
Date: Wed, 18 Nov 2026 15:29:27 +0100
Message-ID: <20261118150306.737165250@linuxfoundation.org>
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

[ Upstream commit b6b47040e897f18df1ed53c658ab5159b035b5d1 ]

mt8189_mck_disable() only checks for negative MCK IDs.
Reject IDs outside the valid MCK range as well.

Fixes: dc637ffeed6c ("ASoC: mediatek: mt8189: support audio clock control")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260916050020.14575-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8189/mt8189-afe-clk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8189/mt8189-afe-clk.c b/sound/soc/mediatek/mt8189/mt8189-afe-clk.c
index 56362c4756c92..7fe9d01006d51 100644
--- a/sound/soc/mediatek/mt8189/mt8189-afe-clk.c
+++ b/sound/soc/mediatek/mt8189/mt8189-afe-clk.c
@@ -675,8 +675,8 @@ int mt8189_mck_disable(struct mtk_base_afe *afe, int mck_id)
 
 	dev_dbg(afe->dev, "mck_id: %d.\n", mck_id);
 
-	if (mck_id < 0) {
-		dev_err(afe->dev, "mck_id = %d < 0\n", mck_id);
+	if (mck_id >= MT8189_MCK_NUM || mck_id < 0) {
+		dev_err(afe->dev, "mck_id = %d\n", mck_id);
 		return -EINVAL;
 	}
 
-- 
2.53.0



