Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD27531281E;
	Thu, 27 Nov 2025 14:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255546; cv=none; b=AhmJfg8FmGecJ6w360LdcfLeeAuJhSEBEVdieZz9HQAICSA2sDig/d6omROnqkUCXn52VQz5/gbZ0sMM+U+fPkwPH/SQ4yfk+IjZZijd7Khc5JFaxHBmG2sq6wqzLQniQddLk5ezMEmLiSdoRb2pW4xM0vBPVv1zKdyunEmvPSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255546; c=relaxed/simple;
	bh=+x7qne16A5nBEZjpxToRS9iv+lMywp5UT6pxxzoc0Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eS2zu/VINBFC7EmGbOvGH5eSNawqHmk4kfmhktnGFgt6QGntzzgfDrglQmTwrqEgCqwodAEt+pbhSKLlBaK4ppj8m+KEpqUYgbGXZ4+u0YC+YoHkPOQVkQxLZTyuSY3yUpScgWgdanCjFpNDc2xy/mdVdfGqIxScweI9bYpuvI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/tWOI4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/tWOI4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E0DC4CEF8;
	Thu, 27 Nov 2025 14:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255546;
	bh=+x7qne16A5nBEZjpxToRS9iv+lMywp5UT6pxxzoc0Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/tWOI4gjblig1jzHydsopHtznqO+T1b36SVFQGdhmcNOzKw8aJP3VaFKE7qDgil1
	 b2uwTv3NkStDKDFvGd+8lf7Ssj0IUlLEThSXqp4r4Ks/ji1KUZd5Rs+8mbCv30JZte
	 ubliK7cVuPBLGPLA3FXAUby57CY/VKtGA87TUNHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.17 009/175] arm64: dts: rockchip: include rk3399-base instead of rk3399 in rk3399-op1
Date: Thu, 27 Nov 2025 15:44:22 +0100
Message-ID: <20251127144043.297326799@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

From: Quentin Schulz <quentin.schulz@cherry.de>

commit 08d70143e3033d267507deb98a5fd187df3e6640 upstream.

In commit 296602b8e5f7 ("arm64: dts: rockchip: Move RK3399 OPPs to dtsi
files for SoC variants"), everything shared between variants of RK3399
was put into rk3399-base.dtsi and the rest in variant-specific DTSI,
such as rk3399-t, rk3399-op1, rk3399, etc.
Therefore, the variant-specific DTSI should include rk3399-base.dtsi and
not another variant's DTSI.

rk3399-op1 wrongly includes rk3399 (a variant) DTSI instead of
rk3399-base DTSI, let's fix this oversight by including the intended
DTSI.

Fortunately, this had no impact on the resulting DTB since all nodes
were named the same and all node properties were overridden in
rk3399-op1.dtsi. This was checked by doing a checksum of rk3399-op1 DTBs
before and after this commit.

No intended change in behavior.

Fixes: 296602b8e5f7 ("arm64: dts: rockchip: Move RK3399 OPPs to dtsi files for SoC variants")
Cc: stable@vger.kernel.org
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Link: https://patch.msgid.link/20251029-rk3399-op1-include-v1-1-2472ee60e7f8@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-op1.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-op1.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-op1.dtsi
@@ -3,7 +3,7 @@
  * Copyright (c) 2016-2017 Fuzhou Rockchip Electronics Co., Ltd
  */
 
-#include "rk3399.dtsi"
+#include "rk3399-base.dtsi"
 
 / {
 	cluster0_opp: opp-table-0 {


