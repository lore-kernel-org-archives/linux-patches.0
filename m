Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064291;
	b=sbuQFJa2HRC96MjuRdJ7S/DVEfMYc58Cm7o2ccoIavilHGFEhdddr+ZwRZdnWiEEg4Fg
	 XSjjEZL3PFmN29diSGD424HbHCb+KszLGlLYxWJ6MF5Rp1hMHKueY4wBrFTCwgo5b3gaS
	 qDXx6w//UzFDLRHsiRkKnYu0CrgO1DKESQQm3WwoB0JECBurlSUYmcDRLzqm9WAaFN+cD
	 7R/DR09HsOIa0aKFvpyfXACGZXHewWlkfVTahKBKeY7JpFpLC1cGjKuUjY0Mt37Q/pKiX
	 CI5zDmkWKpu4L1vLqD/T9R3FXSQanBLfEGOsTqfg9SNR+RgqKEkUgS/OPrn5VY4G/Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z1k3I8ckO4x8njv6A4H55MVOrJG71WkIP2qSC51Hj1M=;
	b=sUKSafpgrTnRgUdmEC7K/UZCChsWVw+kFZnWUF8oeUCKBcM9ytBcnuoJA04Vs3vYGMqR
	 bXTIG4H8zVka2aS/HBIMJSJAdgN9RE8fRK2NNyfUNeJxQ3YMYT9uIBkOVlYyiEWHfHYhR
	 nCUo+VABcdfEwRe93DNQU0G5i6Y3TfJg5JK9p9Y6pBw1Byp2IUTsG/wbtv+hcO5SEYMUQ
	 a9+LAUV8E9s9Ej1i6AUFPuFhOFSdUJQ8JLh+t9t1V2evloFGZCKv9XEK5gnQW5QVzsRbO
	 mMVt7I/YHw62he3qlL1J9WC9QZQr8GW4ZqJoDyI7i2kJg7qzuPWN7mgbhDBzXyB1Gdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rNo4LrYz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E176606A9E6;
	Sat,  7 Nov 2026 15:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rNo4LrYz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9601F0089F;
	Sat,  7 Nov 2026 15:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064291;
	bh=z1k3I8ckO4x8njv6A4H55MVOrJG71WkIP2qSC51Hj1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rNo4LrYz28+Y/fMWh45oKU+5w6jECQCTFOYuRR7qNaGZQbx5I+GOtjzXy2V25CnL/
	 YCdGhOdm+2Gh++Z01ee5zIsFEsJXV9kGZ435q11zVbPOpBxAqGwPcAs5Zlqw4OkEHT
	 S/wUhspC0RbABWHMkismj3ZO+0pSsQFnLfI87+z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0386/1257] ASoC: pcm6240: do not free an unrequested IRQ
Date: Sat,  7 Nov 2026 08:44:42 -0500
Message-ID: <20261107134950.210546318@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 995b96380ba5d98131acc162608da3538e1395d8 ]

The driver obtains an IRQ number from device tree but never requests an
IRQ handler for the PCM6240 device.  Removing the device must not pass
that number to free_irq().

Leave IRQ ownership to a matching request path if one is added later.

Fixes: 1324eafd37aa ("ASoc: PCM6240: Create PCM6240 Family driver code")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260929095920.2092147-1-runyu.xiao@seu.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm6240.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/soc/codecs/pcm6240.c b/sound/soc/codecs/pcm6240.c
index db85ae2f8aed0..7a8c8f53f04c5 100644
--- a/sound/soc/codecs/pcm6240.c
+++ b/sound/soc/codecs/pcm6240.c
@@ -2019,8 +2019,6 @@ static const struct regmap_config pcmdevice_i2c_regmap = {
 
 static void pcmdevice_remove(struct pcmdevice_priv *pcm_dev)
 {
-	if (pcm_dev->irq)
-		free_irq(pcm_dev->irq, pcm_dev);
 	mutex_destroy(&pcm_dev->codec_lock);
 }
 
-- 
2.53.0



