Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020577;
	b=isu2eYzTRC3/CKoTuOVxlQqFA4FRlsjDPTDg+XCp/GgVmhPd2kr54BXk5mIMHF9R3tFH
	 Lx54BYytW4OvXMjZdWvJ8inl8dOTvuMaeZ3yFinEZw6pJr/2GMdcQO/8WT7fA92SoHU6z
	 ZEgssedVjtK9ce3lZ2QVg2JFF41h0bTKqhOeRuPxlyr7kitE/pz/gFLD0U1g6Rf72Sive
	 njGBEyGMocVdq4FK0zK9hPsyw5urw0Ke1PYvf3QkMyjMgfxYti/fH8nE1HO5cabRff9/S
	 aNx6gCNZmCD3cRH7Nt6COKAg+q1eG6j9CMS1PRm2KpFdDwUsaE1vL50DQeF/3Ir6Qfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aRKr/c1COO65JfRnxW8NpOQOguXfgnfDG9xNqGNiYg8=;
	b=kV/WSZB5sVWHr+UibItQ2ZQBIVmFgRIRLrq0YCbGSadcQBxNifONgL8JZKCIeZ4gs9qM
	 NY8tSSoRmuoHlh+NgPlQ65abUg/d5JgLna5zPwM3ucxqmDgp5wkLtgBTU5qUMdMiVZD/8
	 tXGAZtCkulYdaOnHfx/SZDerXoKVaQ31BriS/VLVVCSqGer4YSq3pu3SpMSNMBHLe07WE
	 UjlxvkIDcl65IFqlDVvHpQSTiQRkMFFYLkMNxUx777g7NuLIMQb1jd+mKhJW0vwimeg0Z
	 J2hoctrq9Fty16B7v1PzTYlFzvOCM3pQDXMwSD9p8ydD83CaBTjQ1VEFYg55s3EkZLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DuTV8GvW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FE5606A325;
	Wed, 18 Nov 2026 16:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DuTV8GvW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203A21F000C6;
	Wed, 18 Nov 2026 16:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020577;
	bh=aRKr/c1COO65JfRnxW8NpOQOguXfgnfDG9xNqGNiYg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DuTV8GvWfCcLV18RQBO95BL9+LZrcDCf38zz6cypQunUSVsnF7VUSkRsIhFre9QGn
	 OTbVfbN5WoGe+/0OQBfm5TBJEk5+LmRNTGxd7PDMUHp95C0eEdz4ezwrX0zZLuThpp
	 DdsjJhSmfr5eQ3nn+PQMfPZQSF50Dg8vyvqHFw6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2000/2651] ASoC: mediatek: mt8195: Fix runtime resume error handling
Date: Wed, 18 Nov 2026 15:54:00 +0100
Message-ID: <20261118150358.316143441@linuxfoundation.org>
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

[ Upstream commit 933fbfb6648850e003a1fc47b7bcc08fe3687961 ]

Check and propagate errors when enabling the register access and main
clocks during runtime resume.

If regcache_sync() or main clock enable fails, restore regmap cache-only
mode and disable the register access clocks before returning the error.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-10-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c | 23 +++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
index 9e6d1a2a9e7e0..74999ea531bd2 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -2965,18 +2965,31 @@ static int mt8195_afe_runtime_resume(struct device *dev)
 {
 	struct mtk_base_afe *afe = dev_get_drvdata(dev);
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
+	int ret;
 
-	mt8195_afe_enable_reg_rw_clk(afe);
+	ret = mt8195_afe_enable_reg_rw_clk(afe);
+	if (ret)
+		return ret;
 
 	if (!afe->regmap || afe_priv->pm_runtime_bypass_reg_ctl)
-		goto skip_regmap;
+		return 0;
 
 	regcache_cache_only(afe->regmap, false);
-	regcache_sync(afe->regmap);
+	ret = regcache_sync(afe->regmap);
+	if (ret)
+		goto err_restore_cache;
+
+	ret = mt8195_afe_enable_main_clock(afe);
+	if (ret)
+		goto err_restore_cache;
 
-	mt8195_afe_enable_main_clock(afe);
-skip_regmap:
 	return 0;
+
+err_restore_cache:
+	regcache_cache_only(afe->regmap, true);
+	mt8195_afe_disable_reg_rw_clk(afe);
+
+	return ret;
 }
 
 static int init_memif_priv_data(struct mtk_base_afe *afe)
-- 
2.53.0



