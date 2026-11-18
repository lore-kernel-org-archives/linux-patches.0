Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032148;
	b=ciPX0Jq+aNEQTXVw+182nOt8KLv/7up3p56J982nTuDR6JdN8CzBAZfnSKJR7Qv/SHLI
	 8ABmv+MQGiLQpAszU747zo7MiG4Ba9GDA+znAtt5LdxiTXKj53Fmy/WS3y3i9zDmCLt9Z
	 WyKAtW50Dpa6SWsvTpH2sVvs+kmwf7cC+/OzRrtU2EmfqcPwQAUugB2UPj928T44PnvWo
	 M5nKBLXPxbR1St8oBtWKCHiOc8GCSFtRcoQP40PV2hYMggSTvTR5K7Etb4Q31PVe2SYmK
	 f/eFkPUdS4fTsy8eVfmsyUS7ivVMIf4laaIR1mAqKvlSBr/AV+P0Py6VcfSQ2YvMB9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xf4ExapDHG78IZ7tDznqeja/xAQOMdk/aN3S9tXOXRs=;
	b=e2zbC5WK4/0HIWwLnfYmeaCAgEfwJEb/t4zD3DqeMV3bUCdQYH+NS9JptDBCruIthb4a
	 WABuYLTm541ywHUfNawsX4i1oExmVhUqfCLOMBqt4431Lyh3i1ZrEDyetdE9xIQCSjxAy
	 zMZrTzqHEyz1FCWbIiFqzIhbEfBtO3LDnFMGEJSq11r/OPYK5mRPd1EfrT1AW6Bohn9h+
	 NL8x5AXvd85pofMWv2xJ5oq7WYVFd187g1o6svqC2yToMyW61i47yF4uYt6/asKcGCj3e
	 AF/DOKXI4rLojxU3QAV/QBtmVd0Z+Q5T6o7pw6lTyLCtREiSSKhHt35p7+GHuNZBsGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJLh1Ce9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65A1606A31C;
	Wed, 18 Nov 2026 20:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJLh1Ce9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C321F000C4;
	Wed, 18 Nov 2026 20:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032148;
	bh=xf4ExapDHG78IZ7tDznqeja/xAQOMdk/aN3S9tXOXRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJLh1Ce9pk0Jmd8gO+IWhYN002BEC8lBGFLe6/f6ih+C0TWBMDi0s+lpTx56GwDl8
	 7f3dGQKacDrPMV08fJ+nuObKVVevzqTQVSSjxToo5ep13RQ7+fX0qdesrCwy2nN8rw
	 PGGH2lQ5P5hZ994vcm2QZ2iCT0H3Kkfu3j7DS5WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1309/1756] ASoC: mediatek: mt8195: Fix runtime resume error handling
Date: Wed, 18 Nov 2026 15:57:16 +0100
Message-ID: <20261118150101.594343170@linuxfoundation.org>
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
index 7f771aaf04c18..592b5956342ca 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -2967,18 +2967,31 @@ static int mt8195_afe_runtime_resume(struct device *dev)
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



