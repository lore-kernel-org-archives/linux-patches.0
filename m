Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041490;
	b=eLT+6ZLdeftKx7zpSsRsAeXuyXMHGUhMPcLMoUsIA6j3D9oOqIGwnb4ezQyOxC5TseSg
	 NR0USoV/dWOom43WXCy9ZVCoIzrZQ8LZGPqonUVw7R7GmZNfiwbE4tbJhjCgvx+UOpykJ
	 SUBV9yxpa/7bv5oFDfSaE2CCgL1wQXFdLUTS1J3Vl7BuRNUJCv68zRAfprpnf0zSou+vj
	 rNXswWrg95p5wEmqSYZ9ZZTz8QFpTnnqNTlw8FTao7N/Pfj/bsYoeVN4PQSgRXacNJCAE
	 46isUvMurMRVyW56gjoXklWP6FnCWM9E/aUpjwEAaAuqjlqZYWOYKd2mdtY9zI5ApXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JdDv6dL0+Ui/Xikn0ktd0Rj+RBNZoDHW0yarmnT+t2c=;
	b=mhtgGAX/zHJssq5qKr5eZhp3YqTaYf0xPw1iMh7tkri4PJ570F/bxCVmU+ya/EomR9Nt
	 D33PFRKw1fVlDytdc4l1CUu/gdQoqJu8otNT8JZBMkzbaiRyw3wdjZlYrYQO4qMdADz7M
	 gLK5iDoGcREu+D2+eqjfOj2xX6HrUCK7sWfQ19v77R4Vp2KwSiM4WNt/jBx+lxfnK7Lcs
	 VeD3GYvMb58XM5ZWW7ffdAMRZP3YA6HJx9gFA1gH0e180CNEx9/YLFWDdGYwmjm9pte3K
	 UgpHuX6mnWJ/9n4u6qbIVIxxdiZ/jedC6vOc/ddE+mKHF6QpGfN9Z92cUMd269m9M0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qIELXuPo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E7960A2627;
	Wed, 18 Nov 2026 22:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qIELXuPo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BAC1F000C8;
	Wed, 18 Nov 2026 22:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041490;
	bh=JdDv6dL0+Ui/Xikn0ktd0Rj+RBNZoDHW0yarmnT+t2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qIELXuPoXgzDfUXUGLK3eSRUBmg55ErireO7F4Z/MtmTkDV1wK9a9wt/iWUqMcXlO
	 pty4G8iabLlJaJq3te6RH/gInPOLun97Rkw6mYP7g5mIWSkYWM9pM1JwUHHRd4t4Al
	 uSgW5Xyyd7D32pn/Q8UVYFChoAzYlbjvai6guj5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2831/3318] ASoC: atmel-i2s: use optional API for muxclk
Date: Wed, 18 Nov 2026 15:57:33 +0100
Message-ID: <20261118150445.562116687@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit be952abd69c1f2c845e42e72147751e4c910cd81 ]

The muxclk is an optional clock according to the device tree
binding.

Use devm_clk_get_optional() to handle the optional muxclk instead of
handling the missing clock explicitly.

When muxclk is not available, devm_clk_get_optional() returns NULL.
clk_set_parent() returns 0 when passed NULL, preserving the existing
behavior.

Unlike the existing code, errors other than -EPROBE_DEFER are now
returned instead of being silently ignored.

Fixes: b543e467d1a9 ("ASoC: atmel-i2s: add driver for the new Atmel I2S controller")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261002043856.97295-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-i2s.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/sound/soc/atmel/atmel-i2s.c b/sound/soc/atmel/atmel-i2s.c
index e26d6cf864dec..d6ac5a2d067b6 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -585,21 +585,15 @@ static int atmel_i2s_sama5d2_mck_init(struct atmel_i2s_dev *dev,
 				      struct device_node *np)
 {
 	struct clk *muxclk;
-	int err;
 
 	if (!dev->gclk)
 		return 0;
 
-	/* muxclk is optional, so we return error for probe defer only */
-	muxclk = devm_clk_get(dev->dev, "muxclk");
-	if (IS_ERR(muxclk)) {
-		err = PTR_ERR(muxclk);
-		if (err == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
-		dev_dbg(dev->dev,
-			"failed to get the I2S clock control: %d\n", err);
-		return 0;
-	}
+	/* muxclk is optional */
+	muxclk = devm_clk_get_optional(dev->dev, "muxclk");
+	if (IS_ERR(muxclk))
+		return dev_err_probe(dev->dev, PTR_ERR(muxclk),
+				     "failed to get the I2S clock control\n");
 
 	return clk_set_parent(muxclk, dev->gclk);
 }
-- 
2.53.0



