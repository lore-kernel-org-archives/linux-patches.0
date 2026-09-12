Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C5525393E;
	Sat, 12 Sep 2026 07:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199215; cv=none; b=ci13hKXOoqVhjMr/ZSjmdvE1oEGG+a7w9PVZTnoeaefwXW3fAixFJ4+6tayxUpqbKgp7WlaNAGP2Elx3MCEZwKMMFGXaxNAPCN3I6Oy4C/kep3tsCpZTeDCAlxxa8Ey0RkkxXDTjkRkS2mqNiCZbvTAYuYvVutBf0/gMC38dWUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199215; c=relaxed/simple;
	bh=CgKz6PMfljSH7p8yDXur6EFLY2awEQhimSR1FhmycF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7J/W/tEFgG11AfvtPxtxA/xDWKPQVX9hWsXZVBf5l9CnozH4YUphqaFUiRnyDga1qb7QzUQlC0hI6hNRk0C2R1dgx9UbblgHY1M+CxDQR2/FM5TsKPsfoxbZVU3Oht8BFOWIoj6MiucY5NsgTrrPA9dxS65wlLk4N2UcAgAenY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5ii8Yav; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5ii8Yav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFAF1F000FF;
	Sat, 12 Sep 2026 07:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199213;
	bh=kGIzg4LDL7u/wtmBL5YdkgEsBazffXlbRh0l7x72O1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5ii8YavEqbohym8+WjUmVOCeeW3wE/MXsirX9sqkEhO+pBqimqNT13AiKAZVmF36
	 /40vmI4DU+Z/HsV+DV1ME6GgPX2yQG2Yl+lSzsov3k5eBCXGfNl69S907W6UpVOT4n
	 nRnkuWbLlIdjXNaFWjvCVFBhHXRtJJSIXoRPLIpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yan <jerrysteve1101@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0538/1815] arm64: dts: amlogic: meson-axg: Add missing nand_rb0 pin to nand_all_pins
Date: Sat, 12 Sep 2026 08:38:08 +0200
Message-ID: <20260912065701.510298997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun Yan <jerrysteve1101@gmail.com>

[ Upstream commit 45eb76f9ab6854f79690d56d04df227429a536b8 ]

The nand_all_pins pinctrl node was missing the nand_rb0 (ready/busy)
pin description, which is required for NAND controller operation.

Add it to the pinmux list.

Fixes: be18d53c32b2 ("arm64: dts: amlogic: meson-axg: pinctrl node for NAND")
Signed-off-by: Jun Yan <jerrysteve1101@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://patch.msgid.link/20260624135650.727077-3-jerrysteve1101@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index f1f53fd98ae25..b7a7f4fae7dc2 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -481,7 +481,8 @@ mux {
 							 "nand_ale",
 							 "nand_cle",
 							 "nand_wen_clk",
-							 "nand_ren_wr";
+							 "nand_ren_wr",
+							 "nand_rb0";
 						function = "nand";
 						input-enable;
 						bias-pull-up;
-- 
2.53.0



