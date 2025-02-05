Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B1915198D;
	Wed,  5 Feb 2025 14:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764677; cv=none; b=Z5N6XfHR77yVZ58ZrUm43fw/QlIjuIQdKksKWuETgqE/+IQqD60NvHCJ4X8anUrNs9Zm/RtefyJ1yWo9pqhgnt6hQoxUjUcvDVbjDDpEJ4momlEV2Wlqoa5+Bx/mg9AqRSB3AW5nBBKHddhLo+ux6f1rYlkgkECOi9fn65mK+PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764677; c=relaxed/simple;
	bh=vbJCSLmJqQ3rtPvUCqMGNHsEi0n4CvqMRkDbrWEbeSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgJPWQXUuClHYfccweSOXhlkRHqQKJ0ehs1Sx+YRfvXhxnwlxvILOKt9h0juj+cRkOV3VnQR8GUyx2wFlCfK87jO31LHrd5jlLyqqtgG6pw8KbcWb5CrobbNIgNn7cnYLJ4Wx/7GGFVsqPdnuNQspjc/W6MAoKFgsOp7OBURNhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvit0hlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvit0hlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB14C4CEE3;
	Wed,  5 Feb 2025 14:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764677;
	bh=vbJCSLmJqQ3rtPvUCqMGNHsEi0n4CvqMRkDbrWEbeSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvit0hlZAipDiZFdVX2LUOPsRhvvSioqQDN7aZZUltbH65htox1ssSvNuxc1gfWcz
	 T5Q88enBRlOQdUBU2fnS0qhTeakihTjqL2s0co4a5IdrXwPUSk3HxKUp2mKDytBwqK
	 H+feG6s/zFSSQBFlnrrKjC3qunpAVY6gnf145Qec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Vasily Khoruzhick <anarsoul@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Frank Oltmanns <frank@oltmanns.dev>,
	Stuart Gathman <stuart@gathman.org>
Subject: [PATCH 6.12 130/590] dt-bindings: clock: sunxi: Export PLL_VIDEO_2X and PLL_MIPI
Date: Wed,  5 Feb 2025 14:38:05 +0100
Message-ID: <20250205134500.234814028@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Khoruzhick <anarsoul@gmail.com>

[ Upstream commit 9897831de614f1d8d5184547f0e7bf7665eed436 ]

Export PLL_VIDEO_2X and PLL_MIPI, these will be used to explicitly
select TCON0 clock parent in dts

Fixes: ca1170b69968 ("clk: sunxi-ng: a64: force select PLL_MIPI in TCON0 mux")
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Tested-by: Frank Oltmanns <frank@oltmanns.dev> # on PinePhone
Tested-by: Stuart Gathman <stuart@gathman.org> # on OG Pinebook
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://patch.msgid.link/20250104074035.1611136-2-anarsoul@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Stable-dep-of: 0f368cb7ef10 ("clk: sunxi-ng: a64: drop redundant CLK_PLL_VIDEO0_2X and CLK_PLL_MIPI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/sun50i-a64-ccu.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/dt-bindings/clock/sun50i-a64-ccu.h b/include/dt-bindings/clock/sun50i-a64-ccu.h
index 175892189e9dc..4f220ea7a23cc 100644
--- a/include/dt-bindings/clock/sun50i-a64-ccu.h
+++ b/include/dt-bindings/clock/sun50i-a64-ccu.h
@@ -44,7 +44,9 @@
 #define _DT_BINDINGS_CLK_SUN50I_A64_H_
 
 #define CLK_PLL_VIDEO0		7
+#define CLK_PLL_VIDEO0_2X	8
 #define CLK_PLL_PERIPH0		11
+#define CLK_PLL_MIPI		17
 
 #define CLK_CPUX		21
 #define CLK_BUS_MIPI_DSI	28
-- 
2.39.5



