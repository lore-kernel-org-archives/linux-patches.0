Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015718;
	b=Zl34sgGf6lF4TvhF6sD7Ygb9BwmU1GarwYSFzErC7Ootk4FFiuuMBOfRpyDlyRbmdTsw
	 rD/Jk/FHSSatskT5IdDipwW0JKVM3815/eXDiYZ6LsK9EKKfr0nmK2KRxyDaleYb4Um8b
	 XuacTS2QFJTpCJJxyMT5qJSPxLGLAXVF2wxxVBWLFX4x/IqUnsw1ZCZKBb3X65iE3D1+K
	 0eYZ6ign2VTkq4l1oi9WJ4pMHA7DpfQ/REJfSVAsdRudgOo7StHFFltPlRi+li55HECtF
	 7ZTLVeRHbK6GNBGynuomlOQ5AzPg9DdCQbH5HLGF8olF7gTN6a6K2a+9syFCk7MyOvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lEbhdU9iYaGIz+wyPZk6oqgBdAY29x6ivnodA8x4G80=;
	b=gPljniZel8bf28iv5KiY0OaStz4iR1osvoS6J8SmH8PTvfhdbYJhRnuWml8oxfSFn/Jj
	 ZHv61dwbX+EbmlRdEtBu1sHTg9IvLAUG6CTSn8qMw6E1nDMXyH+/oIAU6FfdEu5mkOzHj
	 WfhCoyS0I9+OTvexxLAdVXAGOtv7xCd6viNPqSgUz3ixl4JyEgyqWVGOll46BZl2CxF7x
	 0R3brKYcfU6fpTjuZuhK2Fi/uGOClP8sJyK4pSllm4UHVxP4clBJohESZJ+DtbxaKijs/
	 OYWk04GTBGnE45gOTUUazIcKTaNQHErurpIKs8+UEyoGz0fXQcQmm/8kw/rCcwuptkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ky1bcVif;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A26C60A2601;
	Wed, 18 Nov 2026 15:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ky1bcVif
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91911F000C4;
	Wed, 18 Nov 2026 15:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015718;
	bh=lEbhdU9iYaGIz+wyPZk6oqgBdAY29x6ivnodA8x4G80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ky1bcVifvShywqhgiekdJt36F4Gb9wrOv0CbWZfmdKbcZxCoVsxG2xaJZO3ypVeIB
	 17mb9oPGTOuE80XrolxRJiuShYwv31PUmN9s5lyjcpJa3WQkDvw2JiMR5i6usvVXIm
	 mcO1NCfnvFxEtCKV0nTuG8eujWLzPQCk13hPmPAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0273/2651] ASoC: mediatek: mt8186: Fix APLL enable error handling
Date: Wed, 18 Nov 2026 15:25:13 +0100
Message-ID: <20261118150257.735130621@linuxfoundation.org>
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

[ Upstream commit cb552c6b9abe02f254d44d8c29d0dce1ae21f69f ]

Currently, the mt8186_apll*_enable() functions call mux_setting(afe, true)
but do not check its return value to handle failures.

In addition, the cleanup paths of mt8186_apll*_enable() do not call
mux_setting(afe, false) when the enable operation fails, while the
mt8186_apll*_disable() functions do.

Add error handling for apll*_mux_setting() and call mux_setting(afe, false)
in the cleanup paths when mt8186_apll*_enable() fails.

Fixes: 55b423d5623c ("ASoC: mediatek: mt8186: support audio clock control in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903051150.178057-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8186/mt8186-afe-clk.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
index 685dc27c77807..77a0cbc8ee241 100644
--- a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
+++ b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
@@ -353,7 +353,9 @@ int mt8186_apll1_enable(struct mtk_base_afe *afe)
 	int ret;
 
 	/* setting for APLL */
-	apll1_mux_setting(afe, true);
+	ret = apll1_mux_setting(afe, true);
+	if (ret)
+		return ret;
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_APLL22M]);
 	if (ret) {
@@ -378,9 +380,9 @@ int mt8186_apll1_enable(struct mtk_base_afe *afe)
 	return 0;
 
 err_clk_apll1_tuner:
-	clk_disable_unprepare(afe_priv->clk[CLK_APLL1_TUNER]);
-err_clk_apll22m:
 	clk_disable_unprepare(afe_priv->clk[CLK_APLL22M]);
+err_clk_apll22m:
+	apll1_mux_setting(afe, false);
 
 	return ret;
 }
@@ -406,7 +408,9 @@ int mt8186_apll2_enable(struct mtk_base_afe *afe)
 	int ret;
 
 	/* setting for APLL */
-	apll2_mux_setting(afe, true);
+	ret = apll2_mux_setting(afe, true);
+	if (ret)
+		return ret;
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_APLL24M]);
 	if (ret) {
@@ -431,9 +435,9 @@ int mt8186_apll2_enable(struct mtk_base_afe *afe)
 	return 0;
 
 err_clk_apll2_tuner:
-	clk_disable_unprepare(afe_priv->clk[CLK_APLL2_TUNER]);
-err_clk_apll24m:
 	clk_disable_unprepare(afe_priv->clk[CLK_APLL24M]);
+err_clk_apll24m:
+	apll2_mux_setting(afe, false);
 
 	return ret;
 }
-- 
2.53.0



