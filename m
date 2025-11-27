Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4756E28C84D;
	Thu, 27 Nov 2025 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255158; cv=none; b=EfUHDeDaepVqn9iHA7zz/p7xBQ1F/Mb2ZfJaIsFQMAAZ4V85LtvW29fm8GVIAVL9rRaKaCQfre5okopnVSuguwxMfnx2uHvOixnVI5BSKK/DEBYBBdHKfuTbqDsfTiLN8If5is+oHDNI83SnDMUrHsI+azCNZQpnFGSqRHd7KA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255158; c=relaxed/simple;
	bh=VR2dG8rlRXZGAvV0COHY/ioBmIuwM1OK+2lBs55Quos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDVuHtWDlyRpbTa9Ml+SkRzuaBWcas6mxmHtiwKfreZDQ4BcIqS99vrjFbgP4VsJHMi3iO5vnBgyi2btgntVcx4s9H0I/8eq88eDv6cIyiIFYEM4zR2HwruFHi73ycOek/oE+3aem0PMSfN+JFkd1w+Wl6kuweBZLlGCOLNXUBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGwYsz7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGwYsz7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7892BC4CEF8;
	Thu, 27 Nov 2025 14:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255157;
	bh=VR2dG8rlRXZGAvV0COHY/ioBmIuwM1OK+2lBs55Quos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGwYsz7H6kON89upc8ZkZrBsY3Mtwrrx8Sihg3GshmWO6pkgBOyerQkS3kDlwSf84
	 AaCA41DfUk8F+goHtxLsFFMbSTAf5YORG8Q7HPPfz66Z4wpjVZq6AYjHnWS43Yw9/B
	 OSDTXbMve0xW31gTYbkT7Cj0TqVRGPJTj5/z9B3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 007/112] arm64: dts: rockchip: include rk3399-base instead of rk3399 in rk3399-op1
Date: Thu, 27 Nov 2025 15:45:09 +0100
Message-ID: <20251127144032.984191239@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm64/boot/dts/rockchip/rk3399-op1.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-op1.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-op1.dtsi
index c4f4f1ff6117..9da6fd82e46b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-op1.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-op1.dtsi
@@ -3,7 +3,7 @@
  * Copyright (c) 2016-2017 Fuzhou Rockchip Electronics Co., Ltd
  */
 
-#include "rk3399.dtsi"
+#include "rk3399-base.dtsi"
 
 / {
 	cluster0_opp: opp-table-0 {
-- 
2.52.0



