Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035716;
	b=DdLRwM6m5NXz3nXnHYg1ILWlMRy6+loEgQyxuF12vUHdqBzTbOizIjlWqaAUe2x1WaJG
	 Dt/c6tY8iLsIiEXJCQ3x9ePKzlevYMSn0gx+r5kI8j7P+bzKYDPy0NGNiQHYOt5T7WWN9
	 4olRS1cFPphUA5A16A5EES/SKMlwKw5KlM1GsIr3LPVZ8bYY0cyzWHXFp9PRt8qW+wjuF
	 69K/I6CNjH4aXg0nb/vRMFwwldq2Fesxs/fihss5/EGRwAbnCQGljCb1cFz1koFWihEEB
	 xImB5g1pUVEiwEVs35PbrR+KciZyWzSKZxTnFS5zOt/9i3PWFVQGbe3v1zn9xzsP5VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=skYv32UFfSwMc46Nogud62WFULnNXi7WQtCcUNV/6s0=;
	b=17UMq12wnqdYy4mMMyToFXSTbyMaWUheZ0zKK0rGFSyfvjp8BhZr9NARfAiuPiQcdpm5
	 lr7n2xqT8Nn7hijtTTzl2QnWxekKk+eC54JSTjThq3W40IMrLUccfmNzveo7iKj2Tp9pt
	 imaMXRamnbWszvJxoDDVqPRCatwR3HbYhAgGQ14Glgg7FYs20SrJ9LmyscaIFy/gn+1UC
	 tceQpupka/hdmJhnC6eiXNoEQBnLZkutwiyhfCnEbABLcXjJ46lD41aYyfK9nt6WFGYRZ
	 X5PbwKkYrTaxWHL5yronFoPIrTiQXeDxfuLRnNTLTtZPlJOULpyDlq50/bkv3FqJ0RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LfntEGf7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FC5606A33F;
	Wed, 18 Nov 2026 21:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LfntEGf7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160251F000C4;
	Wed, 18 Nov 2026 21:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035716;
	bh=skYv32UFfSwMc46Nogud62WFULnNXi7WQtCcUNV/6s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LfntEGf7Aw+SexDlUeZCDZ+u3+r5Ps/onmaZOiOBaBSEp8OMT0+tm7qcCjIOiS0HV
	 u+pymHqQeegrFUL+/eWKUJ/K7iLWXGu2ZqS449+Cgvcj/U4g11E4aiv9mJLSzFP1U2
	 5tNLslP3oNtlEtoYuO1zv328H1PneClabObFX9/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0803/3318] media: meson-ir-tx: Ensure probe error is propagated
Date: Wed, 18 Nov 2026 15:23:45 +0100
Message-ID: <20261118150343.040443884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2ecf8d320ade7..e15c6835aaa47 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -292,7 +292,7 @@ static int meson_irtx_mod_clock_probe(struct meson_irtx *ir,
 
 	clock = devm_clk_get_enabled(ir->dev, "xtal");
 	if (IS_ERR(clock))
-		return -ENODEV;
+		return PTR_ERR(clock);
 
 	ir->clk_rate = clk_get_rate(clock) / 3;
 
@@ -325,7 +325,7 @@ static int __init meson_irtx_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		return -ENODEV;
+		return irq;
 
 	ir->dev = dev;
 	ir->carrier = MIRTX_DEFAULT_CARRIER;
-- 
2.53.0



