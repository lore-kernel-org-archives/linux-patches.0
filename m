Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020177;
	b=xhZrcXaGAQPq5mdGhxf7oSSkRBA5vepNxVmioOVoF3GhRoRfyIqWf2VKpciFmcp2S+LZ
	 OnQtbUwvBvpC4SphHN50qte5sxEd9w3qPH638CgvuwbOCxupfPYuw8wMOkQLG4PpBZoaL
	 mhLXn1gePAH4ZbZmuUFsVkGbhprXSSk6NVOSC+3uBBrQytRU+rpWLmmjZSiPQ8PIcw/es
	 Zh3KlhDegb6CXWnmxIpxLrM9W2dvXzv4Syod7BYrW5Y8he6p9DgFaOQn1H2c8x1njGnel
	 dqaS3VAS9XLaSv5vgQRsy6LdX9W31vGLLsxY7sqXG1cJY1wV9aDG34+UK6T6dzCTL0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7RAfAvH9tYCjxG2ZOj/ovNBniTsZDnQACxKQL9aYKUQ=;
	b=u8cLILuItqgQIIt67M9Odj8hsg2wb1JlG5g8VTSrlPBgCBt7cfPgv7gyVgz7qnnm3hK8
	 I4DXVQf8R4853EcOu8vGHEwowYdZSVgRIBy8Q8o16DgQoW+bq7C4NIfHAcIzzNVjadEh+
	 QXUaQmDXR8b86M65Jf76L6HIpOcpY5Q8tME5ZzzXOqt5jAqG23yPM+B/eteZpKXssWuwQ
	 wspLCCuugQQBLo5Wxm+T4gaDbY+b44bXaFkxQuA6tgnLCYe/G9pesaVpGUnTDyXg4Gjpl
	 qYJLXU35uhJCSN4EbL6ngl+8CjoFr7yQ7ICGQv/e+cT7tErj/j/qjhc9vd5JacZW0jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z8l2e9YX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DD1606A32A;
	Wed, 18 Nov 2026 16:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z8l2e9YX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49161F000C6;
	Wed, 18 Nov 2026 16:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020177;
	bh=7RAfAvH9tYCjxG2ZOj/ovNBniTsZDnQACxKQL9aYKUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z8l2e9YX4lkl6XuNyjS+ddr9sVu0HeW3WKqXALyk74rdHw0WqtXzxUU4F+rygLEl4
	 Jrb89JWWEDo9FAZsgImn9NCj4adAZYqbOVV9vmUqTNiIcoUWPdGwNLemZhmqim7SDo
	 MX0Vv6CG/1IRiUnv88NZdfYeEDNFdmmXe3RuTBv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1859/2651] ASoC: codecs: wm8750: Fix definition of ALC Capture NG Type control
Date: Wed, 18 Nov 2026 15:51:39 +0100
Message-ID: <20261118150353.930310403@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 8c299077c787c151c5c88928467d8e8d85cebdb7 ]

The noise gate type is wm8750_enum[7], bit 1 of WM8750_NGATE, not
wm8750_enum[4], which is the 3D upper cut-off.

Fixes: abadfc928a27 ("[ALSA] ASoC codecs: WM8750 support")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/ce530dfb932d9e8def75059ab9d669360adc76e8.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8750.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8750.c b/sound/soc/codecs/wm8750.c
index d3f1178c2d34e..df49d813aa4c5 100644
--- a/sound/soc/codecs/wm8750.c
+++ b/sound/soc/codecs/wm8750.c
@@ -171,7 +171,7 @@ SOC_SINGLE("ALC Capture Hold Time", WM8750_ALC2, 0, 15, 0),
 SOC_SINGLE("ALC Capture Decay Time", WM8750_ALC3, 4, 15, 0),
 SOC_SINGLE("ALC Capture Attack Time", WM8750_ALC3, 0, 15, 0),
 SOC_SINGLE("ALC Capture NG Threshold", WM8750_NGATE, 3, 31, 0),
-SOC_ENUM("ALC Capture NG Type", wm8750_enum[4]),
+SOC_ENUM("ALC Capture NG Type", wm8750_enum[7]),
 SOC_SINGLE("ALC Capture NG Switch", WM8750_NGATE, 0, 1, 0),
 
 SOC_SINGLE("Left ADC Capture Volume", WM8750_LADC, 0, 255, 0),
-- 
2.53.0



