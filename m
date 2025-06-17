Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3186C23B600;
	Tue, 17 Jun 2025 16:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179240; cv=none; b=LabjfvUZWG2bOwXEtuWbJZg88XcuZ01EaB6xzzc7CwjNpVqBh6yOHO1huOevaDKGNtta1XOgbqt7utTd3SgSxpAwWKF9LFU89IFh93JyZfJblK6cQuStFqTEWs7fJiWsZ5UsahC0yb85JlfiftcSMTjQTN5N/5d9Dxb+AWbivhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179240; c=relaxed/simple;
	bh=Mlt26PqOmlNp54wCu4oGPBQwgery6F7sXMPB7tuf5Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkiaF4rdiTopXtqCNfksKEPgNu+HEfH/pyOnj5QJG9IZ5bYfCvph+aXEgtmf2kydN2kwZiR6zxsbFOFh2KXEKi9N7vszkHK9l3H4vuUF/+ynnlzRzOTuqIy+WahIIUMcziv+XYfC0/oSf60hBxeld925jZQ0JedZfWGPuXvTLbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwKkxXyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwKkxXyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1571BC4CEF4;
	Tue, 17 Jun 2025 16:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179238;
	bh=Mlt26PqOmlNp54wCu4oGPBQwgery6F7sXMPB7tuf5Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwKkxXyFqmX2PkWgH4TRBtVq31TbyjTnGgi2SGgHdbIerKMNM7cO0FAvKKaYcV79V
	 iAlBlFVfLN8RrEF6hC3MQSNajv4z+PWl7gEBO1Q1fl/BPMvLdTFpmhpfmabzL7aDqp
	 tVZszC3p1izm3m61G2R2CpQyrfBuiehQtdfzcvJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 690/780] drm/meson: fix debug log statement when setting the HDMI clocks
Date: Tue, 17 Jun 2025 17:26:38 +0200
Message-ID: <20250617152519.585835237@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c08fa93e50a30..2bccda1e52a17 100644
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



