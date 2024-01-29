Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE1476058;
	Mon, 29 Jan 2024 17:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548637; cv=none; b=KqMUsNGO6FJMa2ijptTdHcxxBOwQ8lZ6p+rUBKelsXAs8ob4+kmTNHRBLiP2Oe7wgaeiAKt3l+cfl5rG8T2hPwxReUC7EiYBt4rMnKBUCBbQldFqEWvGAqxPwNnZaj9iRMezf1KoLLRndz7M6MqHtOpUQVYRR4K0invLniLKggQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548637; c=relaxed/simple;
	bh=YbIURZAeyFbKpkJYkFE7T2ZaObFAD6qsbrL8rZZ4GJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5F+wXnETNnymvDYrAdrIBcsepYPsDi5fT1pT01IvNhRt7Eh7oyLqEor/W5b3axd1DHOyMydir16kxTZZc4yyin8v7Cn9VEza/zS7Is+n2mBbJrgJIOlVxRlC9wPRx7QgJ7Q87PHgfijIPF26GWM7qN0gZxD+qEAEQHtzCG3NdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NZX8P8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NZX8P8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BC0C43394;
	Mon, 29 Jan 2024 17:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548637;
	bh=YbIURZAeyFbKpkJYkFE7T2ZaObFAD6qsbrL8rZZ4GJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NZX8P8jKkoxJTitMGdONN+tRXURCOX0Xzx6mEcpVz9BeL9QkEwOEaVQFdfRqhvSd
	 UNpy6ntpyZoAbLGJu2YR1L8uHiamTB/KYkv0D456vu+BBwi1m0FSGe76UjYCwe8JHE
	 NZGor5y3LiE7AxFppgh384G834KkzISSMbVNTcDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Weber <aweber.kernel@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 313/331] ARM: dts: exynos4212-tab3: add samsung,invert-vclk flag to fimd
Date: Mon, 29 Jan 2024 09:06:17 -0800
Message-ID: <20240129170024.042847286@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Artur Weber <aweber.kernel@gmail.com>

[ Upstream commit eab4f56d3e75dad697acf8dc2c8be3c341d6c63e ]

After more investigation, I've found that it's not the panel driver
config that needs to be modified to invert the data polarity, but
the FIMD config.

Add the missing invert-vclk option that is required to get the display
to work correctly.

Fixes: ee37a457af1d ("ARM: dts: exynos: Add Samsung Galaxy Tab 3 8.0 boards")
Signed-off-by: Artur Weber <aweber.kernel@gmail.com>
Link: https://lore.kernel.org/r/20240105-tab3-display-fixes-v2-1-904d1207bf6f@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/samsung/exynos4212-tab3.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/samsung/exynos4212-tab3.dtsi b/arch/arm/boot/dts/samsung/exynos4212-tab3.dtsi
index ce81e42bf5eb..39469b708f91 100644
--- a/arch/arm/boot/dts/samsung/exynos4212-tab3.dtsi
+++ b/arch/arm/boot/dts/samsung/exynos4212-tab3.dtsi
@@ -435,6 +435,7 @@ &exynos_usbphy {
 };
 
 &fimd {
+	samsung,invert-vclk;
 	status = "okay";
 };
 
-- 
2.43.0



