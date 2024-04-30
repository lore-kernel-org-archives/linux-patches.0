Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA2317592;
	Tue, 30 Apr 2024 11:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476422; cv=none; b=NYeu4T2K9Ik9MVYf8wT6dlWFc+4okXXTGYicMVRWpqat/Pg+NM0yiQeoyNBBDO+3bYIKyy5p7iSYIYm3yBUvdsHZKIff5H/g331bFcCvFJRUacUCvFIkx9taaUIpo7kfTB5jCtaHj+c8MYkO4ZTIyu88aYFM2JL6hKVPsvyDeXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476422; c=relaxed/simple;
	bh=i6q1u6WhYHlStZ6XNz5nthnmfv9hZQntGw6YQ4if2Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbWjnSK/8hZxQAfCr4H4RDJWkkfB0om6S7YphpC4ATYo1N0O/Lr/rjrI8xMb7+3oyDiS1LPSULQc5SdWxjrXZJsKdSrr8K50OzIUYKjEh6Y/PFX2gHw2fAWJlHyR6eideUisKdLWLnbsg55SsY+Y3GyH4LSmtWVwn/BtVQfjcOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiv2Tt8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiv2Tt8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1686C2BBFC;
	Tue, 30 Apr 2024 11:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476422;
	bh=i6q1u6WhYHlStZ6XNz5nthnmfv9hZQntGw6YQ4if2Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiv2Tt8FsTFp3e+8p8JjV+eTiOfzNjZ5ImhWTo8FenE+O2W4pi0fBvzQ6ehbrzIBF
	 QUr+g3Ccvp0j0jvzNER3uj/jAMVS3dFSQSUW5slNo3gU574H8t8yCLyMMNPmRrf3du
	 TwExXUtpDCAhmFR52U17kwhN7i/UOutkGu2bLm2Q=
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
Subject: [PATCH 6.1 010/110] arm64: dts: mediatek: mt8183: Add power-domains properity to mfgcfg
Date: Tue, 30 Apr 2024 12:39:39 +0200
Message-ID: <20240430103047.873706537@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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
index d5d9b954c449a..2147e152683bf 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1554,6 +1554,7 @@
 			compatible = "mediatek,mt8183-mfgcfg", "syscon";
 			reg = <0 0x13000000 0 0x1000>;
 			#clock-cells = <1>;
+			power-domains = <&spm MT8183_POWER_DOMAIN_MFG_ASYNC>;
 		};
 
 		gpu: gpu@13040000 {
-- 
2.43.0



