Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB514F88C;
	Tue, 14 May 2024 10:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683878; cv=none; b=MKDjC09XwupK1L3vv6kxMymVlysQ81VQZhE4hk0cshd6c0vdnd9U84m4CRtiX/V6Ogx1L32MneYebGoMXCWzw1Qti0UcnOxVo61VzVrlEpbMIotBeQT585iHVux7G5S4hcI8DSpXlrIZSUQj6Nd1Kfb+f6RcAemEs358LEmji+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683878; c=relaxed/simple;
	bh=UFEQVNNIHgIph5B26xb4qgkXps8eboKAGAnUGtOZqH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itKAXdeclzzt7EGic3eS3yFA1AUFFbqzllA67Pl7u8R6RBu1h+vhG9uY2zRWDlf7TbLehJCesVqIJeUbPtwbevV/wNNCVPfKFgJlj+nnXBjeAYaH+n5iGKvISn9anyPqEGHzyTjwFAR9LNrm5QxiYmwTXgGvhhNvd445ikajmQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoNaza7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoNaza7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8E7C2BD10;
	Tue, 14 May 2024 10:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683878;
	bh=UFEQVNNIHgIph5B26xb4qgkXps8eboKAGAnUGtOZqH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YoNaza7rfmoEaaqB76B+0DInRqHFAOGXMJIPEC6QDpu4x6M9ncS6E5eUgDfHVCYG5
	 CZeJE//hL5dVrInabjuCgk/1McMNWKnNVl9oq0jEs0VwBWujLVbrl+JEhIjvZiTqCP
	 hkBA+1Cw/MwaCiG7Xi4Ldtd7jZAD8c+kqb7leTKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.8 289/336] clk: samsung: Revert "clk: Use device_get_match_data()"
Date: Tue, 14 May 2024 12:18:13 +0200
Message-ID: <20240514101049.527481172@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/clk/samsung/clk-exynos-clkout.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos-clkout.c b/drivers/clk/samsung/clk-exynos-clkout.c
index 3484e6cc80ad..503c6f5b20d5 100644
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
@@ -84,17 +84,24 @@ MODULE_DEVICE_TABLE(of, exynos_clkout_ids);
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
 
-- 
2.45.0



