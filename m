Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042849;
	b=2ijQQ5IGxKU3kp3WkntiEC5Jiq5RskDnhlEE/Pr6RNw6+yrWIGwLyyHYhbdF75P2e3Lc
	 GG4OL5fD5He9GrQWvpY54dEBqr8cxcTvOM2W8enMl8bQgGfo5VxK45I8HE9krBdZmRF9R
	 NseyJd28FTakZzJEpWB+mBpCq6Ln+uhNuR1eboRMyaFGdPLJnAIQtBrG9n+p1FvcshsPV
	 HJ9GIbk/5rYFa53QlyM8k3rFMAKyMp7ocVkt3l2mdJaoHY0cP/85LMJ7ZAqfIMOc2lP5M
	 Zawz6fze9YWsnjuFbS6AupWBATEsfIs9Ax5p8bdGfZl8pHQqPs+CWDEQpO2Uxyit0Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v+3natxy8gh4p3BMsYcMCG4ndykVTzX5jTYABFdVc3M=;
	b=emMCn01pNuGipgZwMWn4bPIZ0Bnf5tvHHr8KeC3gA0pbmd0DQDZodf8dVjQssuSKLAlD
	 xL3sRCr5PETL6eZX1uO1Tl5xQd+bo3/hvPVIKThjwzdQ4VZmMFBfMVIMvIFIPY0ddCPyU
	 UmPKk5AjT25mWOYC3fcFGamw3+xWdp+KXZSl2aRsi65yE3dHOMHILgf09Leggw5f0N2a1
	 n4tv6I/k/fsZNoi7g5hr7eoFXFk3+3Khq2etEq8ckD0585i0bDsO1rX+rrjbiqlhDM9qs
	 35YwfamiANUsqBOnXJGZDL7UkdCD8fhq0awLQUyDaGOH47uLNLmlhu+SxLH0mLdD+Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SNRhf+Go;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DE9606A31C;
	Wed, 18 Nov 2026 23:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SNRhf+Go
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E19D1F000C4;
	Wed, 18 Nov 2026 23:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042849;
	bh=v+3natxy8gh4p3BMsYcMCG4ndykVTzX5jTYABFdVc3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SNRhf+GoOinir9K56yhiKMnzQcy7ElZ7Hn6h99N9+gHRV4uyPCsp1Ea3VKfcyjIpF
	 jKXbaTLOMNWDpwGPDaRib1Wvz4HLsaSZxTz5tR1DiPzUtOmB9ddH0QyWk4SqCR9Hmz
	 xv5BhnNs3AZ9lqwGWtxgYpXkkct9/9Ok0vBOdMMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.6 3316/3318] clk: samsung: Revert "clk: Use device_get_match_data()"
Date: Wed, 18 Nov 2026 16:05:38 +0100
Message-ID: <20261118150459.049878585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit aacb99de1099346244d488bdf7df489a44278574 upstream.

device_get_match_data() function should not be used on the device other
than the one matched to the given driver, because it always returns the
match_data of the matched driver. In case of exynos-clkout driver, the
original code matches the OF IDs on the PARENT device, so replacing it
with of_device_get_match_data() broke the driver.

This has been already pointed once in commit 2bc5febd05ab ("clk: samsung:
Revert "clk: samsung: exynos-clkout: Use of_device_get_match_data()"").
To avoid further confusion, add a comment about this special case, which
requires direct of_match_device() call to pass custom IDs array.

This partially reverts commit 409c39ec92a35e3708f5b5798c78eae78512cd71.

Cc: <stable@vger.kernel.org>
Fixes: 409c39ec92a3 ("clk: Use device_get_match_data()")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20240425075628.838497-1-m.szyprowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240430184656.357805-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/samsung/clk-exynos-clkout.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/clk/samsung/clk-exynos-clkout.c
+++ b/drivers/clk/samsung/clk-exynos-clkout.c
@@ -13,9 +13,9 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
-#include <linux/property.h>
 
 #define EXYNOS_CLKOUT_NR_CLKS		1
 #define EXYNOS_CLKOUT_PARENTS		32
@@ -84,17 +84,24 @@ MODULE_DEVICE_TABLE(of, exynos_clkout_id
 static int exynos_clkout_match_parent_dev(struct device *dev, u32 *mux_mask)
 {
 	const struct exynos_clkout_variant *variant;
+	const struct of_device_id *match;
 
 	if (!dev->parent) {
 		dev_err(dev, "not instantiated from MFD\n");
 		return -EINVAL;
 	}
 
-	variant = device_get_match_data(dev->parent);
-	if (!variant) {
+	/*
+	 * 'exynos_clkout_ids' arrays is not the ids array matched by
+	 * the dev->parent driver, so of_device_get_match_data() or
+	 * device_get_match_data() cannot be used here.
+	 */
+	match = of_match_device(exynos_clkout_ids, dev->parent);
+	if (!match) {
 		dev_err(dev, "cannot match parent device\n");
 		return -EINVAL;
 	}
+	variant = match->data;
 
 	*mux_mask = variant->mux_mask;
 


