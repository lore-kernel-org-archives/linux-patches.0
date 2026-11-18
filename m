Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044851;
	b=DFCy7Nz81afF0HevtVVDxTaM10tkEUhBDu3t/fl8bQ0mM2vXS2TCR/Ygn5mXw0fIR0qc
	 axlmSicR87i1Cm6KD/+mdXEVnVxPIpqDKSUUEQe8iXgw0SZthT1pBku/A+aXz4vD+JRqm
	 ya4x4x1eLmpyqZtskJza27E3PVKriZQa1rqSrEOr8ndKdwMF/AD2Om14jj823P6zm14MH
	 MIxY1bIe7oCf3A+1JdQeR8QUF/dxVYNnXsU5XE4wbVcn11JK+uQaNxRenLrpqoZSYzypO
	 ECQ8X4SsaRMMXJ3QyQSsdSnjgi1u7v4TUCJWDkAp1Y5ktTZZYyfpbIXrPWYBndsnnJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p8+3/q3dxwz0Ful1alFX8TMOtmh1+hmhlNli2YcVFWM=;
	b=ItEGU0sN/tIy2HbMW9ZNzEVaULLGmDH0QQI4286OY6h1tK34MtsBgb3KArZe7uguxZxw
	 2OZ93UTA2MV+7quNd8TFkb+JAFjoLllMv5pCVyIhSUhc7g6f7O0/bQ5/MhTmmYFgB/mn8
	 vaFsCsKTq5ANYC7v1knw3d3aMXITO51YkPf6/RmYUbN7WVbXOINhG7FJOmcdcP0ImDC0J
	 8pEvOeHokp45M1w+BrxbBK9zu5kcccf6lY38s61zDhd2FhgwXAWfmdgKOKgyVhHjGr8IK
	 6inF6QnL/nXNRrn9sjZVztsFLW6MCCPU1JFIRA3NNRErujoeU49RiOu6ckmOatZqYWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zhkIvwi6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7393606A9D5;
	Wed, 18 Nov 2026 23:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zhkIvwi6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11F31F000C4;
	Wed, 18 Nov 2026 23:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044850;
	bh=p8+3/q3dxwz0Ful1alFX8TMOtmh1+hmhlNli2YcVFWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zhkIvwi6fypjC5GYFgHcKm64LxresoktpBgpYERqGogTgEM96paVTVTTx88u6M2nb
	 5HM/Wmi0s3KfsPiFHr9O7QgrzIJughbVKxple7GwU93rz74kBABnu5JFLwKFKsK9fL
	 KOM+ZkF4ycYw54mHbraNThoUMT2eGJZs2+rR3EKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0713/2857] media: meson-ir-tx: Ensure probe error is propagated
Date: Wed, 18 Nov 2026 15:29:07 +0100
Message-ID: <20261118150227.219782938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5808f65aa8353..ff89956562f7d 100644
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



