Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAA41DB125;
	Mon, 29 Dec 2025 16:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025608; cv=none; b=t1EHR4Ggy1ZifviM5MIbtLeO6t72JsZ4SWkKcbPH3mBXmZ8PUvif321yhT22SjlDBnmDCDcgCA1NpgpXLea2U63A3LioNhevVsqKuQcnw6q4ulo5ySBGnEVbqMj7X1x8mKl0Q31oCRD7eoQdhiUlB+2QQmk27WHVTJLJILvpJEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025608; c=relaxed/simple;
	bh=EXQdiKr83pF/nMfyDUz80i3d3iYsKBRicxM2hkQrhNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ptcjYuApWbMnIJLUdXIoBLmeZognoH22yfEvbRwoqYlAFfuRrFGMP1FyJ14eJYXJiVvf6eYzHGvS+EgGGe/PNGa6JxcORS6I2JG3SA/rFDuP1YGRUkSO5gAkV9q+9VQl0SAgjrbXYUX6ksyeoj5dRH5YoERIe9VLxIVQEA9cEwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUcw17vl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUcw17vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8454C4CEF7;
	Mon, 29 Dec 2025 16:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025608;
	bh=EXQdiKr83pF/nMfyDUz80i3d3iYsKBRicxM2hkQrhNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUcw17vlMSnAJ9BQykWO4iVl7iFKfCHiudmYM+vOGQcQML5bYJc3TT/h5PLSBGQAB
	 /kjmfOqdGjeaZ7rly6StXcSbwZOqWox5/hWeU6uYpt1LH0ZGGrnufklSKDQa/4NR1n
	 4vwpTwwO8b2U7agZ2INRpc0Y3EdxtRSFowpGmJUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 240/430] phy: exynos5-usbdrd: fix clock prepare imbalance
Date: Mon, 29 Dec 2025 17:10:42 +0100
Message-ID: <20251229160733.188103555@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit 5e428e45bf17a8f3784099ca5ded16e3b5d59766 upstream.

Commit f4fb9c4d7f94 ("phy: exynos5-usbdrd: allow DWC3 runtime suspend
with UDC bound (E850+)") incorrectly added clk_bulk_disable() as the
inverse of clk_bulk_prepare_enable() while it should have of course
used clk_bulk_disable_unprepare(). This means incorrect reference
counts to the CMU driver remain.

Update the code accordingly.

Fixes: f4fb9c4d7f94 ("phy: exynos5-usbdrd: allow DWC3 runtime suspend with UDC bound (E850+)")
CC: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://patch.msgid.link/20251006-gs101-usb-phy-clk-imbalance-v1-1-205b206126cf@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/samsung/phy-exynos5-usbdrd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/samsung/phy-exynos5-usbdrd.c
+++ b/drivers/phy/samsung/phy-exynos5-usbdrd.c
@@ -1823,7 +1823,7 @@ static int exynos5_usbdrd_orien_sw_set(s
 		phy_drd->orientation = orientation;
 	}
 
-	clk_bulk_disable(phy_drd->drv_data->n_clks, phy_drd->clks);
+	clk_bulk_disable_unprepare(phy_drd->drv_data->n_clks, phy_drd->clks);
 
 	return 0;
 }


