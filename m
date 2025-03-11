Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04E125EF8F;
	Tue, 11 Mar 2025 15:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706511; cv=none; b=g41XNaDILKQq3E3uR4MtFyVoqp8CClM1QM6E194qiikk3d3PtmszMuR1AVN92ZUbNC0lcuMnyJf1gU41+LSCVborZbkbKQIWikBBa0wzCNSrm3ZY8dAsuVqrFibEkKarwPXHidgKhkw3WZ7O7UmwdWSa2D8CN7dP8AyrzQJbAoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706511; c=relaxed/simple;
	bh=7Ts2eW6yNRaNHMDZLouQp7e8ieNB6hVmC86BeEfvozA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l56Dtc9G0YHGtHLxsd/6yDAxHVlttybGs+uej+gvFdawwjJdYp0ptqu+Iw6Opj376Dqy0lAc3J1fxASyGpXdVSrlk3GW9PgPQ3sfItAB/F2GOTVLsxIxVL7w8u78Zr9zuSOjy9CMuRsBlsyHPJAxFi7Ss8qLC3oJAhtJ1J8PbpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tusziCyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tusziCyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37251C4CEED;
	Tue, 11 Mar 2025 15:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706511;
	bh=7Ts2eW6yNRaNHMDZLouQp7e8ieNB6hVmC86BeEfvozA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tusziCyxI5mIdsm9j8+1pgb6PTGXu6SfxcBfyLkJYTN2OKJyDYy1EF9T/RfLW4e7I
	 EHClX2CJ+nsNZHrkxARiWKI79QI2uXLZm+jfAS779qq0Q68imoeUqHlClz0et4I2xX
	 pO3i8vGDLqSGSsfokjv0msIbFUUjA5lwvsy7W4SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/462] arm64: dts: mediatek: mt8173-elm: Fix MT6397 PMIC sub-node names
Date: Tue, 11 Mar 2025 15:55:38 +0100
Message-ID: <20250311145801.195266019@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit beb06b727194f68b0a4b5183e50c88265ce185af ]

The MT6397 PMIC bindings specify exact names for its sub-nodes. The
names used in the current dts don't match, causing a validation error.

Fix up the names. Also drop the label for the regulators node, since
any reference should be against the individual regulator sub-nodes.

Fixes: 689b937bedde ("arm64: dts: mediatek: add mt8173 elm and hana board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20241210092614.3951748-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi b/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
index 908b87735819e..3eeeb1b8dbad1 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
@@ -905,7 +905,7 @@
 		interrupt-controller;
 		#interrupt-cells = <2>;
 
-		clock: mt6397clock {
+		clock: clocks {
 			compatible = "mediatek,mt6397-clk";
 			#clock-cells = <1>;
 		};
@@ -917,7 +917,7 @@
 			#gpio-cells = <2>;
 		};
 
-		regulator: mt6397regulator {
+		regulators {
 			compatible = "mediatek,mt6397-regulator";
 
 			mt6397_vpca15_reg: buck_vpca15 {
@@ -1083,7 +1083,7 @@
 			};
 		};
 
-		rtc: mt6397rtc {
+		rtc: rtc {
 			compatible = "mediatek,mt6397-rtc";
 		};
 
-- 
2.39.5



