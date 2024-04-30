Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14C712D1F1;
	Tue, 30 Apr 2024 11:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476163; cv=none; b=tJp12SotwWCHYLWnyWeqEvvqdLGzOZN8GPyPVEkbfnbm1v87TdWIA9qDqnP2SR6GPKZl+KdZYhniZda/GjGjc46pXuo2QgLrMAWUwDXjWfgY/rsUKubCwkxlUWbVkGpv1LCjlYr++fcfm7/8CwRHUOwi8sV8MM9qv/lQrVPsE8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476163; c=relaxed/simple;
	bh=DVRa5K9Fkgn8u7Yae6qheQueBdL7cmUqAZotkhJFqy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwOeV7vUcuE17AwirGPrxX2RZF1GBwKPz7H8P08n+aJSCv+izSPdKyOY/FjdGUK+Z+9/q9n47sHVBjsLfC1x8QE9Lylk/lSPtW4VzoD+Yy6ItDAfAIFZkdiEe4H4EfLDBFJGAjNCsHW6w529MUU5plLRjTA10joQyyLohlgzeQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAiVsNgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAiVsNgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59647C2BBFC;
	Tue, 30 Apr 2024 11:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476162;
	bh=DVRa5K9Fkgn8u7Yae6qheQueBdL7cmUqAZotkhJFqy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAiVsNgB1luFYBU+ZxmOt/PESWG7lmrppG65aW/FFoxnXjLQdyU4PKLF8NxMNHjO1
	 my9UFxuKIM/0BQdJZtcSJe5H6rSy/WBvdTtuiWnMDrnxkB9EF54pUqQQm0fo9WPYxd
	 kUPuBtwiMhIh+SORW6I7DUEp24/uyaSfA+maglt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiyi Lu <weiyi.lu@mediatek.com>,
	Ikjoon Jang <ikjn@chromium.org>,
	Enric Balletbo i Serra <enric.balletbo@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/107] arm64: dts: mediatek: mt8183: Add power-domains properity to mfgcfg
Date: Tue, 30 Apr 2024 12:40:14 +0200
Message-ID: <20240430103046.252128698@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ikjoon Jang <ikjn@chromium.org>

[ Upstream commit 1781f2c461804c0123f59afc7350e520a88edffb ]

mfgcfg clock is under MFG_ASYNC power domain.

Fixes: e526c9bc11f8 ("arm64: dts: Add Mediatek SoC MT8183 and evaluation board dts and Makefile")
Fixes: 37fb78b9aeb7 ("arm64: dts: mediatek: Add mt8183 power domains controller")
Signed-off-by: Weiyi Lu <weiyi.lu@mediatek.com>
Signed-off-by: Ikjoon Jang <ikjn@chromium.org>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20240223091122.2430037-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index 97f84aa9fc6e1..1c93f41bc0880 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -577,6 +577,7 @@
 			compatible = "mediatek,mt8183-mfgcfg", "syscon";
 			reg = <0 0x13000000 0 0x1000>;
 			#clock-cells = <1>;
+			power-domains = <&spm MT8183_POWER_DOMAIN_MFG_ASYNC>;
 		};
 
 		mmsys: syscon@14000000 {
-- 
2.43.0



