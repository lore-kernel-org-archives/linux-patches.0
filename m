Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E1828C014;
	Mon, 18 Aug 2025 13:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524727; cv=none; b=iH0a3XY4AzbwNSFaWhY5HkVRh0+cJU2V+ESNDBd9JuPbRf3xu/ha0AgbVqM6GsHJgb59UktToxRxXWCSueozF4vDNaowlthtVdsEchi3auvzN8OdsHhnlGBCCjCdreesx5rR9xqULQyH5WDFt/Dc1oczSlDYGlebfbHR5AXn9Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524727; c=relaxed/simple;
	bh=+fbMYYzNvXZ366E0xAHsX/9iJxkM93HF+s4ggVo7EjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hA+KsxAc9ZUeOJX70Fq5Rl4SbYDSigCoV7GnCgfD5kawg0QEmKl/W92F+vkuKLxAjUNoQKoIef5QRCIYk+Xg5agTbfE/8wqzm3VEAvdSXjw2cHVVXqWp9gOzbVxHPnaLls/7MybJobzNSsFEpHxOu16EJk0MPrqA4R0mLx/kC0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2QBkYGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2QBkYGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA54C4CEF1;
	Mon, 18 Aug 2025 13:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524726;
	bh=+fbMYYzNvXZ366E0xAHsX/9iJxkM93HF+s4ggVo7EjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2QBkYGneEljaZFHqfKjx40qZYdUvLCfidVF02ujZHEeCAhbTufqUQWmmu1hufAPU
	 KToF1Q1WH5egNKHsrnQaLmOqx81vHKsDAg6WQZSC4AGdkQXx1KSaal3N9xOla8Xgbo
	 +5626vpWtw2Ws2+4gjsKkG94fEEUM8MvpnI6Zwhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.16 044/570] clk: samsung: gs101: fix alternate mout_hsi0_usb20_ref parent clock
Date: Mon, 18 Aug 2025 14:40:31 +0200
Message-ID: <20250818124507.516913990@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit ca243e653f71d8c4724a68c9033923f945b1084d upstream.

The alternate parent clock for this mux is mout_pll_usb, not the pll
itself.

Fixes: 1891e4d48755 ("clk: samsung: gs101: add support for cmu_hsi0")
Cc: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/20250603-samsung-clk-fixes-v1-2-49daf1ff4592@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/samsung/clk-gs101.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/samsung/clk-gs101.c
+++ b/drivers/clk/samsung/clk-gs101.c
@@ -2129,7 +2129,7 @@ PNAME(mout_hsi0_usbdpdbg_user_p)	= { "os
 					    "dout_cmu_hsi0_usbdpdbg" };
 PNAME(mout_hsi0_bus_p)			= { "mout_hsi0_bus_user",
 					    "mout_hsi0_alt_user" };
-PNAME(mout_hsi0_usb20_ref_p)		= { "fout_usb_pll",
+PNAME(mout_hsi0_usb20_ref_p)		= { "mout_pll_usb",
 					    "mout_hsi0_tcxo_user" };
 PNAME(mout_hsi0_usb31drd_p)		= { "fout_usb_pll",
 					    "mout_hsi0_usb31drd_user",


