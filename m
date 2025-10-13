Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464863126D8;
	Mon, 13 Oct 2025 15:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368243; cv=none; b=ate4R04N77JgHgd7KMwkJ4mbZ8LVwG+fqjeDzEZ60TextdlSNmoAmVzw7giy6dsBpFKKlXhfiDlUY2zXrgQRfBaT5FE3Uoko6KjDNJvDpA9VdtSWTuVlu9u3ZNC3yybdLbkti+RVueSrc9m9ZirlbGpZhH3u2fuRAgpKdZIkPw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368243; c=relaxed/simple;
	bh=X0Fh2sh9svPZIHXq1Pwc66uiF7XOBKajSg39d7xLA2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSnZSyzchApt7qwTe1sceKcH/bODf3cP2mb+h1KuQ6ISmrqh2Ype4Hr3srH9k1gu1gtxoV8STRtpoKBsefHh3AI/VT+PJU4yxlz6xiQ17BjSlHDGlAil6NBT35vvYP857iuJx619ExxB2IA9Yzs3TEM+Yoqdg8sIbWgVXTOsUUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mp/Otj68; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mp/Otj68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3521C4CEFE;
	Mon, 13 Oct 2025 15:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368243;
	bh=X0Fh2sh9svPZIHXq1Pwc66uiF7XOBKajSg39d7xLA2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mp/Otj68XEyUiDfaKmkRVohUerYCPsM2FgG9yLbudiYfz2RgkKeiu3EHkuvZPs6OB
	 iio9Jm0VFMWduUYkvqlWhEdmBJ+58IG7c/AMPOVtMLj601QFmEQBqLQUp0d4RBlGdO
	 7m8YbNkcp0lJUR3cB5dVw4uNp3JmRDsLOWzrQe8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-I Wu <olvaffe@gmail.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/262] drm/bridge: it6505: select REGMAP_I2C
Date: Mon, 13 Oct 2025 16:43:55 +0200
Message-ID: <20251013144329.478028725@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-I Wu <olvaffe@gmail.com>

[ Upstream commit 21b137f651cf9d981e22d2c60a2a8105f50a6361 ]

Fix

  aarch64-linux-gnu-ld: drivers/gpu/drm/bridge/ite-it6505.o: in function `it6505_i2c_probe':
  ite-it6505.c:(.text+0x754): undefined reference to `__devm_regmap_init_i2c'

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Fixes: b5c84a9edcd4 ("drm/bridge: add it6505 driver")
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://patch.msgid.link/20250610235825.3113075-1-olvaffe@gmail.com
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 3eb955333c809..66369b6a023f0 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -101,6 +101,7 @@ config DRM_ITE_IT6505
 	select EXTCON
 	select CRYPTO
 	select CRYPTO_HASH
+	select REGMAP_I2C
 	help
 	  ITE IT6505 DisplayPort bridge chip driver.
 
-- 
2.51.0



