Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031201;
	b=M5dAe/mPprW2bGfFeFDTyRpsn0QHL3d2V5vRpIC149VvQt0RjFTsFjcxjJy8Fw5hQMki
	 Q1VkEyIuCdYOk9rDBXHgTYgI+qmZH2q1LVDH/y56PZOOEh4aHqFtwKiuQFJDiJxT//jdy
	 HttifxqIKTBGco6VPvot34rHO7G/xacYyqY9q6T+Wu06Xrb+njQtOJ40heu2dzOFMXyM1
	 OMpvXwyj8RTK91ZinmUgqOHaZI2w4J7klcs9ws1wPzvwtNSssi8JlKFcdGnXnGb6iLjcW
	 zWpvip78yB0VfXNjqdMJn1rGlzvOPEnZnue68lUlRUBxzz+CGtKUYiytyDuCdt0O/0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1wDIxyhice7/CtwZ7LXJGnU7ZOuIlFI/9QYoUQ1U+wE=;
	b=kd5HfAU9XzXojXt1WJMSWgAn6Lf8ul1oNn5vOtPhHEGRHQE99At76mYpEyFPl1gjxaSK
	 BJF3PvE/4yvhysTj/udks41HP9j74FJn0fP+GvLs1WXwBB4BjSFyEl9l5VjcSShAC7uEx
	 vdLBL2fblMzC17I7/OCnPRDpzBi/QrO/2YZJsch6NlNWTScaou+Eu8riYEYTR83obgINp
	 55hbeeIM7m/+ugBgO1pce1ZNCi2nk32LGBzgKOSzjjPNyVx7SS8XVTibW8f5R08h1yv2G
	 iaFKARuDookxnb5pTbVR9oMyfjWwRyMFca9G+ABdMXGvYWGjjYqWMzWCd+Fmrt4wUrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t/Xt1E/6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C054660A2609;
	Wed, 18 Nov 2026 19:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t/Xt1E/6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279281F000D2;
	Wed, 18 Nov 2026 19:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031201;
	bh=1wDIxyhice7/CtwZ7LXJGnU7ZOuIlFI/9QYoUQ1U+wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/Xt1E/6h4MrOu0TofEpT1bLO+MBRYjogNzXMIz1cRspXkmliJgwlpk1APzYInru+
	 KGPVf9CH006voUJNlGL7sDcLqLji4ngWfb6uxBGdUKjo3mF3MRIBY1Jd2p0DymOJYv
	 0qwyP75lRWDXqdaklBP4kK4l7xBHpeyMRd01sBxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0976/1756] ASoC: rockchip: rockchip_i2s: Handle runtime PM resume failures in set_fmt
Date: Wed, 18 Nov 2026 15:51:43 +0100
Message-ID: <20261118150048.997177639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit e9eb1854d16136006c6fe94c927b54b2b264b429 ]

rockchip_i2s_set_fmt() calls pm_runtime_get_sync() before accessing
hardware registers, but ignores its return value.
If the runtime resume fails, the function continues to perform register
accesses while the device state is undefined.
Replace pm_runtime_get_sync() with pm_runtime_resume_and_get() and
return early on failure to avoid unpowered register accesses.

Fixes: 53ca9b9777b9 ("ASoC: rockchip: i2s: Fix regmap_ops hang")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903112739.373621-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index 4315da4a47c15..358caa5d1544b 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -244,7 +244,9 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 	unsigned int mask = 0, val = 0;
 	int ret = 0;
 
-	pm_runtime_get_sync(cpu_dai->dev);
+	ret = pm_runtime_resume_and_get(cpu_dai->dev);
+	if (ret)
+		return ret;
 	mask = I2S_CKR_MSS_MASK;
 	switch (fmt & SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK) {
 	case SND_SOC_DAIFMT_BP_FP:
-- 
2.53.0



