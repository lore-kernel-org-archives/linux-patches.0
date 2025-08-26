Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91BD227EA8;
	Tue, 26 Aug 2025 13:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215660; cv=none; b=X64mxvfgPqkEaJCj9v9xRav/X+yzfFEiIB7T+hxD5B5RqONcUyklvT+yYakGit+Vo5/qFO9PDLgszi7V5o9uQhydASH0JfFv7NGfQe18IBR6wPy21YXqAQ9o97SnZdWVKJH2T++ElimWDjncEP+Qciytv4RRuy3jQCeBeUfEFqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215660; c=relaxed/simple;
	bh=hgK6bz0Mw60fIA1skNvXLRkpsEBxGE1IoTDr680RKyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUt6U+Wn9q7j3qJfILQK5WS1E30heDJbHY8A5aS9DEGQBtWOMvKJbVhIoeO7eMlgAXwyIZFtS7tSjxu2G+z7p966tqhGM7/lJav3sCdV6DxXRihnhFxDgljbFRh2l1/lN8GdtHD7bshucjjy94+KMZi1nT9nfe3cy8LR9hMbj6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxNjCr9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxNjCr9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40282C4CEF1;
	Tue, 26 Aug 2025 13:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215660;
	bh=hgK6bz0Mw60fIA1skNvXLRkpsEBxGE1IoTDr680RKyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxNjCr9hl4IScwgBUIi55Mb3yplyNeG4nfi43gr2y2Zgc0EpjJEjFa8KfrjGH9sJW
	 hJ1VR7Eh0Bfh2c0VXFoik69Ay7rmpDff5VXh2l0erNEASCfjy51OxN2cWwjs7f7inw
	 e5ZL5M2rH1mg6NZLLCjxb6lYKOcNLyWLcuIPf2I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/644] ARM: dts: vfxxx: Correctly use two tuples for timer address
Date: Tue, 26 Aug 2025 13:03:28 +0200
Message-ID: <20250826110949.423919641@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit f3440dcf8b994197c968fbafe047ce27eed226e8 ]

Address and size-cells are 1 and the ftm timer node takes two address
spaces in "reg" property, so this should be in two <> tuples.  Change
has no functional impact, but original code is confusing/less readable.

Fixes: 07513e1330a9 ("ARM: dts: vf610: Add Freescale FlexTimer Module timer node.")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/vfxxx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
index d53f9c9db8bf..eb7973fb4713 100644
--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -617,7 +617,7 @@ usbmisc1: usb@400b4800 {
 
 			ftm: ftm@400b8000 {
 				compatible = "fsl,ftm-timer";
-				reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
+				reg = <0x400b8000 0x1000>, <0x400b9000 0x1000>;
 				interrupts = <44 IRQ_TYPE_LEVEL_HIGH>;
 				clock-names = "ftm-evt", "ftm-src",
 					"ftm-evt-counter-en", "ftm-src-counter-en";
-- 
2.39.5



