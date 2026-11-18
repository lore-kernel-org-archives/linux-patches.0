Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061794;
	b=W2SQlReckezgZTy+D/prjTh6R/CyIciFHs4sDOjiPq4t1frrE/pg4mxG7dcQeY1EoiA6
	 3s/7RgZu95k3J/8LfWUZz8Nekb2h3okeX9t+u+b0MMOAWC02qcbA90RWGzGmuLIPmNGid
	 BzLyCoQ4IGv9PiBatwRLc0Z0tTydfu893NAKbV0RUse3rJIy7/k/SvSXLv6tAthPyWbD7
	 Ak6jN4WFyyc5bFEvKsBgWjyYVIsFXsg2tnEpzjsl4WllgngWlzP8GzM0+JcnxCIbMEC2Y
	 5Xn+yUdS9y87hRIxLP4xmUz4SeMfu6tCKVxEbXnuQra2Lfv82zB1zjNzlhFjndH97Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DOB/dhBE+BLEkFa8p1Qbl4eIDIMCco9apcPgKz562Hg=;
	b=EuConfImwrQQ+7dAW1ntgiwftjt4QPVKT7bxmRFENGhclSwarI2SgO6SKfcTwqBxXP8w
	 9MZ3PkKa9u4U3PRca1lqlfL7cOA4EzQsOfyCtkVqcd/FZP2okCkgPMurI7fqsfJX/TJmU
	 V8pNNKtc33jMipKOKS1x4qtjchnKPaMmaOm/Q/NKi4eWOXTzJsL9oVP+xL+N5rVodslJo
	 XViJrdhMI0w2D3oy/GCs+vR+CHkc2ZX2Dyf5Z3iPx2aesdzGWGRby8OLA2BHK0bjtomtL
	 z4OSyvkBNnUg4It3k11kUPCtezQxxc0ya0m3ene4Ey1NeADtAh5n8NnWLfmGM5sDivA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RxV0JXHD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D3B606A325;
	Thu, 19 Nov 2026 04:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RxV0JXHD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B071F000C4;
	Thu, 19 Nov 2026 04:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061794;
	bh=DOB/dhBE+BLEkFa8p1Qbl4eIDIMCco9apcPgKz562Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RxV0JXHD57LAChVHs2W+w4SZtQ2wYGAQsVSapKUYYImDqYUd/nD16OgV7xj/pJT1v
	 u6b2RN25KWZWGGwouyaNNX2hZtZz7jkFITLxDNy/V9sppY9diqTC1elJod6Vva0Oc8
	 2YOCwx+9GS+zOo9uyPaNKICutIuqeutnB/9JdWz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1643/1848] ASoC: codecs: wm8750: Fix definition of ALC Capture NG Type control
Date: Wed, 18 Nov 2026 16:01:21 +0100
Message-ID: <20261118150028.469597064@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9491817020d85..8ea0c039af2cd 100644
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



