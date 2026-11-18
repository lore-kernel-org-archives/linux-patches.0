Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036145;
	b=mZtwjqy4sk3scrzJv27DX29daaImY+pYLqeiMUBa+q8nsJaiIYI8SBhJghmvSCm6X0eW
	 5FBDeti7F5uIIsRNil5Cf9yxnHZ40frgdq7bixo1EwSz2nhC4/t84XsNtk6aTwVcFg5//
	 ZP9bXSpuNHBjBPMiiUfyskKoD8wdzpLszX+zMhvPNLhazWXXFA+JViaHMd4RqXFuEPrvQ
	 +puano9FBMXsE9qIXhYGBJjIIGkTS+/bTjE4PEGEFzfLU+Yf1e1hOt2n+rTLDoJzkxM30
	 Sc5/CeHn2OSqd2gh+olxrbRbt92ziOZjZAHlPjkNXGtldQjfzb1RCOuybQiDfxs8RGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KQeq9bV809htXLKckWc0kgNviOYjIBo7EZ7jMRNb4QU=;
	b=kThVeoy4E9BHBZlihXFY1Vpdu+MFtAZIeYfs6tyyT/pHPAl9YnWMWmwxG6U0t+rkqHeS
	 lzWsF69DSdeiAZW4IuvikqwUY3keLh7bN5dDgBTd/D6V0OmRr5xL3WD8kddgw5P5CUJXO
	 9CtT1OqYkzckGE0jXFCojqVXWPeDYq2WJmzXgtxCvQ5BDjvI5RtsXi+1E8wT3OddS/G5a
	 29MEjnwYKhl6WWvUt4r/yxXuEnN9HrnGKQmGcLDrdEg6zAGfR3m5r4Ta7XJ1KYSNLINeR
	 3EFmzJMPUpYcC9/0h8/MH8oEoUlx6FzC+oAeAz0YbajprKct8hrmtVmjBOnmrustMQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ebX+bZzs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6137E606A320;
	Wed, 18 Nov 2026 21:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ebX+bZzs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67D01F000C4;
	Wed, 18 Nov 2026 21:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036145;
	bh=KQeq9bV809htXLKckWc0kgNviOYjIBo7EZ7jMRNb4QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ebX+bZzsLdOoZwJ27/zHYXBiwzf1IUIe3XzMD4vkOHKtBas7PktT3CiqWmjYgtVK6
	 SJPke/KJi/HGNYcaZFpo142ezgSBbRn0yH/qhc5HuNdopVn69jTeVrTaU83hxXv2/Z
	 y6s5Z7/GE4MznPxdLdG2VInSiqsgZntjGlIBhNjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0954/3318] ASoC: codecs: wcd9335: Fix SLIM interface device leak in wcd9335_slim_status()
Date: Wed, 18 Nov 2026 15:26:16 +0100
Message-ID: <20261118150348.243424094@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 082723fee626532f176727b6438b666a96d5246c ]

of_slim_get_device() returns a device with an elevated reference count,
and wcd->slim_ifc_dev is intentionally kept for the codec lifetime on
success. However, all the failure paths of wcd9335_slim_status() return
without dropping that reference, leaking the SLIM interface device
whenever the register maps cannot be created or the codec fails to come
up.

Put the device on each of those error paths.

Fixes: 20aedafdf492 ("ASoC: wcd9335: add support to wcd9335 codec")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917164853.2163184-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index d805d971979e3..59e50a665eb60 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -5194,25 +5194,32 @@ static int wcd9335_slim_status(struct slim_device *sdev,
 	slim_get_logical_addr(wcd->slim_ifc_dev);
 
 	wcd->regmap = regmap_init_slimbus(sdev, &wcd9335_regmap_config);
-	if (IS_ERR(wcd->regmap))
+	if (IS_ERR(wcd->regmap)) {
+		put_device(&wcd->slim_ifc_dev->dev);
 		return dev_err_probe(dev, PTR_ERR(wcd->regmap),
 				     "Failed to allocate slim register map\n");
+	}
 
 	wcd->if_regmap = regmap_init_slimbus(wcd->slim_ifc_dev,
 						  &wcd9335_ifc_regmap_config);
-	if (IS_ERR(wcd->if_regmap))
+	if (IS_ERR(wcd->if_regmap)) {
+		put_device(&wcd->slim_ifc_dev->dev);
 		return dev_err_probe(dev, PTR_ERR(wcd->if_regmap),
 				     "Failed to allocate ifc register map\n");
+	}
 
 	ret = wcd9335_bring_up(wcd);
 	if (ret) {
 		dev_err(dev, "Failed to bringup WCD9335\n");
+		put_device(&wcd->slim_ifc_dev->dev);
 		return ret;
 	}
 
 	ret = wcd9335_irq_init(wcd);
-	if (ret)
+	if (ret) {
+		put_device(&wcd->slim_ifc_dev->dev);
 		return ret;
+	}
 
 	wcd9335_probe(wcd);
 
-- 
2.53.0



