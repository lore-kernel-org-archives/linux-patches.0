Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063815;
	b=3U0KDXyspBpp8RKbJuWr3RG1vtTb9jmIIUWXCBx2IlgQ+oiruV4jF6w5wtjiXUNo9TPF
	 Uiq6u6xEqIMTR5B3USMSY1Z5HwBlVHn8DxSnweeSAAtWTN93MJMLcMItvQi09SCzuCIdi
	 evq14MCndSflYbuAtuvHkVvj/9bLK7cuSyWjByiO6ffqhLswHg8D1ZFxCdm3R/1LKneaz
	 UKI8slZIeTktfDz/6u9pEFtkpIDsErxMbxJWiZUClC3R/9ghbH8EUzT9ax/u+3nseh1z5
	 bgT/PQ7sW/W1oa4AynQCWROHXliVD8mxiuiqfGoqicpXHb9DYvjBX14yMnRdjfZntaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G3yCcqVq1WH4qZ4Hq2HGx+eInYAAUDuxDj+VCH5XcpQ=;
	b=uqWF0oOL40kqQgn/o84KS980V/AZhl7P3hhJ/vnzPxF7j7RRGBiFgX9CTgBRU9uC1TWF
	 5R5PWofL3uzL5vwRQtWi+obJ0CvQe+PTsg2u43BFjn0TgoMx97igb9HpzdKUJacaNq5J7
	 7t22Y5SKNDoYhQCiuFmm6Fpl1LKveTbff0xI0tzJOK3tZOEMUr6LEWe2oL9FDCzSO8wUI
	 bjTP/PFA8UMTOrWL/7lrA1Xmlem9IAI7NbiTJBAyyo96CrwgG3rkcAq0AWSSFN5l3qNyj
	 4Mut/msqEzzrez26waQwwbNoRX6qOyU8fi3bna3oeiN2NisxbFzKNsZole3YCkOw15Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xiaF9fd/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B5B606D831;
	Sat,  7 Nov 2026 15:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xiaF9fd/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40DA1F008A3;
	Sat,  7 Nov 2026 15:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063815;
	bh=G3yCcqVq1WH4qZ4Hq2HGx+eInYAAUDuxDj+VCH5XcpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xiaF9fd/d1WPQQVkYxZneY3ANqRpJ3mNomGKH6OtxW/+QM3PfeVbcnRqOzP/54rxt
	 xTl9ldHtoJjUIO6mfcB1FpWKl6BGTeVDiJlpe7FUTjuMSAqgmbMNUsDz0t/KIfzuof
	 E2pG7VoMUNYwtHVyforuB+GODSSalWaaTJsxEvM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0032/1257] media: meson-ir-tx: Ensure probe error is propagated
Date: Sat,  7 Nov 2026 08:38:48 -0500
Message-ID: <20261107134940.296086401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index e8e3c1a303279..1ab898069e67f 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -292,7 +292,7 @@ static int meson_irtx_mod_clock_probe(struct meson_irtx *ir,
 
 	clock = devm_clk_get_enabled(ir->dev, "xtal");
 	if (IS_ERR(clock))
-		return -ENODEV;
+		return PTR_ERR(clock);
 
 	ir->clk_rate = clk_get_rate(clock) / 3;
 
@@ -325,7 +325,7 @@ static int meson_irtx_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		return -ENODEV;
+		return irq;
 
 	ir->dev = dev;
 	ir->carrier = MIRTX_DEFAULT_CARRIER;
-- 
2.53.0



