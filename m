Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF95E231A37;
	Tue, 17 Jun 2025 16:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178099; cv=none; b=MNJULTNbjIxePX5WYgfEBpXS+qsFG7mv5+a/RQQSAhp1S7jaivXCIMrysV0QLtGxATrBS/he1J2f16lUTLlBs4bg2h9PtUZXKgA4DngwIUZ34fcmPwd1soXx2at9cVV2cJ1BnS0WxYBuv5fd5+WM79kf7VyypaX1dc2z0I1V828=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178099; c=relaxed/simple;
	bh=fUK97TwULyh4r6YedBoEQAHJKfN1Zxs4D1Fj+Q7QOVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VON/r0mL/IJkUX37piOpcIZRxWyYhvpIuTak54Pv1TaA3rsfMLQWBJKR+RD/QFIG23sJKjzU79uz7UbNKqEg4az+Yce3cJCMDYlNehMepEk4vewE+NTMdHqIkEyG6KABjHgezu86z1hoDglvhPXzK9f4RLk3JJ6tW9dK7gGUMxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hctOMvf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hctOMvf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EACC4CEE3;
	Tue, 17 Jun 2025 16:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178098;
	bh=fUK97TwULyh4r6YedBoEQAHJKfN1Zxs4D1Fj+Q7QOVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hctOMvf/aA6BnGbl+4+hd+5K1MJJcydZwQyMuxz/PV+8kUpViZ1DwPUeQHfKCV3uW
	 o3igRkcQ9PE3Kz1PC/MHhH0uB7OX/86F6KehOC47Lc1AbLIglmk1PAcuiUrjAEjEgV
	 EhAFom0V6IPp28xVyWr7S8Y31eUqQQWw0PZ7rJRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 446/512] drm/meson: fix debug log statement when setting the HDMI clocks
Date: Tue, 17 Jun 2025 17:26:52 +0200
Message-ID: <20250617152437.640166891@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit d17e61ab63fb7747b340d6a66bf1408cd5c6562b ]

The "phy" and "vclk" frequency labels were swapped, making it more
difficult to debug driver errors. Swap the label order to make them
match with the actual frequencies printed to correct this.

Fixes: e5fab2ec9ca4 ("drm/meson: vclk: add support for YUV420 setup")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250606203729.3311592-1-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_encoder_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/meson/meson_encoder_hdmi.c b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
index ce8cea5d3a56b..2c49137e0deed 100644
--- a/drivers/gpu/drm/meson/meson_encoder_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
@@ -108,7 +108,7 @@ static void meson_encoder_hdmi_set_vclk(struct meson_encoder_hdmi *encoder_hdmi,
 		venc_freq /= 2;
 
 	dev_dbg(priv->dev,
-		"vclk:%lluHz phy=%lluHz venc=%lluHz hdmi=%lluHz enci=%d\n",
+		"phy:%lluHz vclk=%lluHz venc=%lluHz hdmi=%lluHz enci=%d\n",
 		phy_freq, vclk_freq, venc_freq, hdmi_freq,
 		priv->venc.hdmi_use_enci);
 
-- 
2.39.5



