Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2882EC574;
	Mon, 13 Oct 2025 15:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369388; cv=none; b=fX9f8qQqehLlrXME8Bh48xrq02xW1vAesqphwDshIJJib0klWmnIBL86vTKy58OfzZBXx5kzHXhbhe06uXGVMB45LBAn09TLDoU8mHTMy464CuzJCumvKn1W+fNZhUsPx1NRGVxlBRb4X5gBEdt0sp87SEkuWBQY09Mv1K3geps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369388; c=relaxed/simple;
	bh=xC5sy1ovZOx3Nv71FEQXjAf1RHBZILqDA7YidY28gpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Onl0uzpGnsqUgPg/IVS5l6dVI0aUftQfwbeIE/kE0rjIXg89yTYNmrzJUZnoGzYWlht2YgKoT4F9lgPoGUeqfxDMwj48K5qthJUajohrL/YznbAj9JYCyD4eW9XhP4YmUrHGQRwkw5w5UoSjxLT8UUvW1a3k9bOXbqg6LWxvRNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swbanb4C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swbanb4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C746C4CEE7;
	Mon, 13 Oct 2025 15:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369387;
	bh=xC5sy1ovZOx3Nv71FEQXjAf1RHBZILqDA7YidY28gpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swbanb4CvV3AqlJ/6wdW4ZyvZRnkGg2FsTJT2U1LzcA9HSOIsMruKNCxrh8VHO6w9
	 eLdUucG0bFcq0uyDwf8cCyF2VSyW55LHmyS0/KItwSdvgWYKQMa506sbuhHvJF35y/
	 f2EQSwqDDf3Lh1oBtwV0z+bB3b4DJP9CAjQb7IxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-I Wu <olvaffe@gmail.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 227/563] drm/bridge: it6505: select REGMAP_I2C
Date: Mon, 13 Oct 2025 16:41:28 +0200
Message-ID: <20251013144419.505329977@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index b9e0ca85226a6..a6d6e62071a0e 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -122,6 +122,7 @@ config DRM_ITE_IT6505
 	select EXTCON
 	select CRYPTO
 	select CRYPTO_HASH
+	select REGMAP_I2C
 	help
 	  ITE IT6505 DisplayPort bridge chip driver.
 
-- 
2.51.0



