Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD89A1BF7E8;
	Mon, 14 Oct 2024 14:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917589; cv=none; b=Nzbqy/gFMl6r1rGeHqyoOQYwUbEfSEKFMmxkw3ScXHql56BjJnjuVNclS9RwVyX+TQ/6WHhS9WpExNy5GUiJT4ISSBH1IAJrew4Oz/IJoXD1TqHXs3zzBQegkQU1pNCoy9tV0hxn3ancjb4h5/OGW7M5xJY2ApaP7PkTllsBPvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917589; c=relaxed/simple;
	bh=ChzfbgcYaJBF8FMyJInrKdfvBvsmjxiZsG6plF18hC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BH/XCAUzfqFt48YGtZK2f+/1QgglX5swd9ZLKU/djEdblfBMN95QHPjjE4YzU6Mw0FEuPlavq9PK591J8Fk0VlWIVWmU8okrk0AxpKgAGGvb0/1R7zYh/GPVWYK+FY4nf95KKqIV1Gn9LSZ/Rg+dw8U/n6k/W+seKexqpzkJJ8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whTd9hY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whTd9hY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315B3C4CEC3;
	Mon, 14 Oct 2024 14:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917589;
	bh=ChzfbgcYaJBF8FMyJInrKdfvBvsmjxiZsG6plF18hC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=whTd9hY0T6zUcySAip31oEJlGb1pTgtmropvv0JI6xmHmegm3NGWdkCtrgfZUqYmY
	 M2NZlKytb9W5+pnsYYUagNYEUwV0PEg34HWYpYRsgc6wfjFpRQ2dx/LzfhZIvJccud
	 xy9ONGgcF/eIsLNJGEfgtvcDr7KAfxP3fuq+y724=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/798] arm64: dts: renesas: r9a07g044: Correct GICD and GICR sizes
Date: Mon, 14 Oct 2024 16:10:29 +0200
Message-ID: <20241014141220.884371372@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 833948fb2b63155847ab691a54800f801555429b ]

The RZ/G2L(C) SoC is equipped with the GIC-600. The GICD is 64KiB +
64KiB for the MBI alias (in total 128KiB), and the GICR is 128KiB per
CPU.

Fixes: 68a45525297b2 ("arm64: dts: renesas: Add initial DTSI for RZ/G2{L,LC} SoC's")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/20240730122436.350013-5-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a07g044.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
index 4703fbc9a8e0a..d65f8840ccd88 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
@@ -788,8 +788,8 @@ gic: interrupt-controller@11900000 {
 			#interrupt-cells = <3>;
 			#address-cells = <0>;
 			interrupt-controller;
-			reg = <0x0 0x11900000 0 0x40000>,
-			      <0x0 0x11940000 0 0x60000>;
+			reg = <0x0 0x11900000 0 0x20000>,
+			      <0x0 0x11940000 0 0x40000>;
 			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_LOW>;
 		};
 
-- 
2.43.0



