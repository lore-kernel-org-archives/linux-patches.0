Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799461B424F;
	Sun,  7 Sep 2025 20:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276003; cv=none; b=SQtOjpwf9tHEnP4GE8hVyTayF7GONrULJPu0hHA1c3xpy9DzYlspo7K6Fla2qP9Jfqe+EDmWprSNg6Ycb1tkLNZDGbLvfUjz+QCYgeusMOQi+SxOb8yTWbxR3xvF6SFl4JIkKQrQffT5XJ12FnnO8bRgIN+QAmuOzzE8wAqZULM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276003; c=relaxed/simple;
	bh=nYfzOBun+qLydD+timVj7tyIvjiqxFppRKmShQqS7SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfcVE9niWLUigdA1CPJWVDmAm4Bl+pMQGMEv2e2RHvrXTDW8sAsNj/qZxGSckVku/iSBvV8ajYdKWm5ydMR+e/+eIxjDgJG//KipFygqOWV4YxQfkQEiDXT2LZpOnemZE3muKcFr4pxFEgadeICsD3y9TLW+iY9wPwBnQjAEaVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XF5XB/Vb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XF5XB/Vb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2803C4CEF0;
	Sun,  7 Sep 2025 20:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276003;
	bh=nYfzOBun+qLydD+timVj7tyIvjiqxFppRKmShQqS7SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XF5XB/VbueVM9b2b6w2I+/Gs2qj1D+RyLUW85yGAFraqNLjqTA4mCpbRqeNZiTpVy
	 KT/CqIhFlW1qRM5LrPXoK0T0mwoxgU4vPDTwl9oKCjw5FYl4r5dFfLEjQDkLlYm0E1
	 cM2O5Q2e/5y0mx1wiKyY7nOGGkeu4FnHskHGf5Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 08/64] arm64: dts: rockchip: Add vcc-supply to SPI flash on rk3399-pinebook-pro
Date: Sun,  7 Sep 2025 21:57:50 +0200
Message-ID: <20250907195603.634917672@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit d1f9c497618dece06a00e0b2995ed6b38fafe6b5 ]

As described in the pinebookpro_v2.1_mainboard_schematic.pdf page 10,
he SPI Flash's VCC connector is connected to VCC_3V0 power source.

This fixes the following warning:

  spi-nor spi1.0: supply vcc not found, using dummy regulator

Fixes: 5a65505a69884 ("arm64: dts: rockchip: Add initial support for Pinebook Pro")
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/20250730102129.224468-1-pbrobinson@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
index 60a909a100eeb..ab2e2ee4ce6fe 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -978,6 +978,7 @@ spiflash: flash@0 {
 		reg = <0>;
 		m25p,fast-read;
 		spi-max-frequency = <10000000>;
+		vcc-supply = <&vcc_3v0>;
 	};
 };
 
-- 
2.50.1



