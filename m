Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053649;
	b=ER/A9fHBiDtwQDb5k5jYUdNQzG0uwzF8CunVNaXeCg3J5zH8PEd050o5uWFV+lZx+nqJ
	 HfWDeA2zNaADYPeuwY/xDrJyks5b8zevqIRcIOwLerIb6qDsFRZ+7QuEjWasG3QAQ8FoM
	 VEjh0yU6JclPJMywERDoWcnnsLDrtG7e4mp8vrA1SEnAm7LixH7SYzzr1UfFn7XH8ktWK
	 Y29XpnSsBhAxYppFlDgbmWUozShKa9ycMct8GYxtvRB/4BFgFUxFnE1QPvdO+qkve1Hfs
	 wr+eAuS/2o7CR8313BHZ6xVl35q3+09Z5rnaprB+1LB7OYx3Il1RRxpLF2qwuyRG5Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j9RljnpDxBd8NsyfY8gLyKjYS8+dqMlnoWcB1E1Aja4=;
	b=fWf11O6dzia6JJAEBg40otNkNTnI14qK3dLROVWpVdx0wbLIxT+2q7bjbyojssW1vHQ5
	 CXXvsVeIKSvLj1uW7PeOv0FYeKz8zj0P3ub+ZkOmzUQbccRUlM6U+/O6zxcXAmLAwtGWC
	 AmrXiE4APk+zPcsQKli1FrVvH4x5x+DPWNGLvCKhMBydLEGCuruVpxxjt+4XDIGSFP4mO
	 E7bZzv+jHdXUrABt1FTwdIwLVRMD7y0DrFPOsKaVkPPUMSGDqdUIeq700dK0tKup4/pjo
	 gJhWVbMf/L1COqWIN0wL3iisMai94ap/klaBOpTS6G9Ot8b+50hX2N6qv7aNvy1/uHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v+A4M1Ua;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73205606A330;
	Thu, 19 Nov 2026 02:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v+A4M1Ua
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13D21F000C4;
	Thu, 19 Nov 2026 02:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053649;
	bh=j9RljnpDxBd8NsyfY8gLyKjYS8+dqMlnoWcB1E1Aja4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v+A4M1UaOgroZ1YKmXpWbjm68oa+H35DXRXP2IN1Qi7CCGQiV9HGlh0QupBaZ/HyK
	 mZwh5rdhJJLbkbLGU7Yrjhelg9FFHSWHeD0Lr7ohhw6OQN9t+X65p1wvkUcRBZ9cAi
	 l++6rmrFZoZS/jrC8kxdTCX/OkkjcDkeHO1MAE3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0995/2214] media: meson-ir-tx: Ensure probe error is propagated
Date: Wed, 18 Nov 2026 15:44:31 +0100
Message-ID: <20261118150052.177515279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 2eb8a4cba70f521a8217021e227cfa28ba17724b ]

devm_clk_get_enabled() may return -EPROBE_DEFER which needs to be
propagated else the probe will not be deferred, it will fail instead.

Fixes: 49be1c78d575 ("media: rc: introduce Meson IR TX driver")
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index e050430ffc7b3..d26fbe0b65de1 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -295,7 +295,7 @@ static int meson_irtx_mod_clock_probe(struct meson_irtx *ir,
 
 	clock = devm_clk_get_enabled(ir->dev, "xtal");
 	if (IS_ERR(clock))
-		return -ENODEV;
+		return PTR_ERR(clock);
 
 	ir->clk_rate = clk_get_rate(clock) / 3;
 
@@ -328,7 +328,7 @@ static int __init meson_irtx_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		return -ENODEV;
+		return irq;
 
 	ir->dev = dev;
 	ir->carrier = MIRTX_DEFAULT_CARRIER;
-- 
2.53.0



