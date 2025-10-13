Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3BC308F11;
	Mon, 13 Oct 2025 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367613; cv=none; b=a7SYHq+MOlSXmusR047RMskOGmHNVUf9aXNqNyxYCV3g22AhrUN7jAtukaPOM/t++2uv6tFTyaxhcV8c9jvH+IYcarsdnMa57Bn1GBrDPP2BF4W6gB0uku6rymD69uHFsDuBG0aHB1TY7AUlHluhbRBjcPOM9OvFaHlkvaYP1Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367613; c=relaxed/simple;
	bh=TGEykBH46IFAONrfnOVixLB+AEn0AnIZecAgOPWtOoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhYYVARdNHFsqLSyJyhH74mV1AqFP0M+wincgVhvJssQTX3ubcnQPKbWGQnpktfn2CAUtCzFDM0Uvg7plAaa3A4f8qCkBdI4+Jk3IMBRpsLu/jdh+4iAjITD59UvV5PChDooxbHyec8irxxuMTjNFTJSly37AKIQXgQgIg0zPsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpLuR/5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpLuR/5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1C6C4CEE7;
	Mon, 13 Oct 2025 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367613;
	bh=TGEykBH46IFAONrfnOVixLB+AEn0AnIZecAgOPWtOoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpLuR/5yjRLTCocNsKUmhnaAeBn9+x5nzj2S9o4/T0I/GnF0RexShDHr5qtlbTsKE
	 lDkludgSA+sRl/s00BR4q0LzGUwTd8qhyXtNgOr5iXvZSRzxihBju6lppYUEUR3Cmx
	 8+3tmaDnfivQTnXljWNoo2uhJy+e/WWhQugT+Sm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-I Wu <olvaffe@gmail.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/196] drm/bridge: it6505: select REGMAP_I2C
Date: Mon, 13 Oct 2025 16:44:16 +0200
Message-ID: <20251013144317.547485805@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3e6a4e2044c0e..5a4d574b37b89 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -85,6 +85,7 @@ config DRM_ITE_IT6505
 	select EXTCON
 	select CRYPTO
 	select CRYPTO_HASH
+	select REGMAP_I2C
 	help
 	  ITE IT6505 DisplayPort bridge chip driver.
 
-- 
2.51.0



