Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1678801;
	Tue, 30 Apr 2024 11:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475839; cv=none; b=j+bB18UdUHus4X0BcLQWtpu8KzhUSV/889j3vChxtlMcukwY8inwSFr+yUOL9WhWXVqr6nL195cpMiHiEj7OtVUgbHfjJAKZZTVPWBFK70C6FLFfwOT09pE95hyq8Eoj+26K9p7hgpOCd1w8Emx6uCZE/P3+4THwvwF5dgud3ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475839; c=relaxed/simple;
	bh=AiqYEJOU2YZCAr87x3dxMM+4UaLbEHdKCGEEkNKZEZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5dZukIr406SehXVgFngOQnMiv2r0ucS/VxzeiWgaLMT0UMd3tODWhg1JCp5ePuD0hDTxBU+T+IAPbKYyQ2cgqBs8Rap/UOtrVPF9Q1VsrIhbW3B1wIrSmdFbDSv/WpUTa3Vp4VcdelvI/nDf6bgomhbPgmjDpEh8jRr44PYBS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULZ+rbVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULZ+rbVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFADC4AF19;
	Tue, 30 Apr 2024 11:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475839;
	bh=AiqYEJOU2YZCAr87x3dxMM+4UaLbEHdKCGEEkNKZEZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULZ+rbVfVqQjZBG3uCKpEce1Nv9YtyGHUmze3NTiWP5Uvd8waVguKvJ2nTS7i71HE
	 oY1Gghi08v8Nq+aPzHjVyK+szUfBwWgvsVP48MXo8ixQxs7FYeBU4l5BPc+4TODR+1
	 UBoLqhDibnMg1dry59ITz7J88VhYE6gm3N+EB3N4=
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
Subject: [PATCH 5.15 09/80] arm64: dts: mediatek: mt8183: Add power-domains properity to mfgcfg
Date: Tue, 30 Apr 2024 12:39:41 +0200
Message-ID: <20240430103043.685474909@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2d33f4a583b48..712ac1826d686 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1088,6 +1088,7 @@
 			compatible = "mediatek,mt8183-mfgcfg", "syscon";
 			reg = <0 0x13000000 0 0x1000>;
 			#clock-cells = <1>;
+			power-domains = <&spm MT8183_POWER_DOMAIN_MFG_ASYNC>;
 		};
 
 		gpu: gpu@13040000 {
-- 
2.43.0



