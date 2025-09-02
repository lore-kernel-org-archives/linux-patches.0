Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A17310625;
	Tue,  2 Sep 2025 13:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819393; cv=none; b=Vyxxtt4/OViFej4xE3PLr7l7f5PVFCDMT7OBX+sMfNmiLAmPcR+qbytU0+vwtCnlQrAob1VSiIWlDz1D+x2ZLqBGEvjvwbZWRPkOREFi/ZGNDwTtl+M+KGZTf1VHDoWZ62JHL2lo4CF/0jtpqD/8karfv5oLBulJWKqIK7AgnZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819393; c=relaxed/simple;
	bh=+/aUc+QruCvnPXn2oQBPZ8SF+S9eQW3O8aDtHaJL94s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULYkAUPSY2heSl2Wc/eKF+sNODWakqL705j0ngtzsKJRfpabF+42vyvZQbEDIne1+9deKfjL6ptXDUeV8dy2ufjiRZ5QRz1booomBrfJjgzhc0MckjHcXcd+wVfTkqSfOWVBrD/pO62qZ8WElH6r/0cASeATA56jbcpc2ulNVx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hapx2k2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hapx2k2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC32AC4CEF4;
	Tue,  2 Sep 2025 13:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819392;
	bh=+/aUc+QruCvnPXn2oQBPZ8SF+S9eQW3O8aDtHaJL94s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hapx2k2fR2N0IFpqBo1vwl5APoBHA0xDoIlm5yvINTjx+4ah0fkrXPbKIjkhUrkuZ
	 ttLDttez9dNtRUvXrFjH87aIt9rPuROAWuBtuB1quZR+im3QgMRr8yC1Z0EmdG9sCG
	 XQo55CZx+eNjj2iosEj001+DGO7yIa9s5JHXkf1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srini@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 020/142] ASoC: codecs: tx-macro: correct tx_macro_component_drv name
Date: Tue,  2 Sep 2025 15:18:42 +0200
Message-ID: <20250902131948.922868529@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit 43e0da37d5cfb23eec6aeee9422f84d86621ce2b ]

We already have a component driver named "RX-MACRO", which is
lpass-rx-macro.c. The tx macro component driver's name should
be "TX-MACRO" accordingly. Fix it.

Cc: Srinivas Kandagatla <srini@kernel.org>
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20250806140030.691477-1-alexey.klimov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-tx-macro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index 27bae58f40725..fe000ff522d24 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -2230,7 +2230,7 @@ static int tx_macro_register_mclk_output(struct tx_macro *tx)
 }
 
 static const struct snd_soc_component_driver tx_macro_component_drv = {
-	.name = "RX-MACRO",
+	.name = "TX-MACRO",
 	.probe = tx_macro_component_probe,
 	.controls = tx_macro_snd_controls,
 	.num_controls = ARRAY_SIZE(tx_macro_snd_controls),
-- 
2.50.1



