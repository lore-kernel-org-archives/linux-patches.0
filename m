Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7E413A259;
	Tue, 27 Feb 2024 14:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043047; cv=none; b=KL33zLeH2J44PmobiA1mcfzWCd2qJNS3EHLrYX8dwhWULqp9vn8T8aCCpIhPxMZta8+d8auqU28xCemm0oqvX0LXpOp0yTGWOhqACkyGqDMFJUStp/Vkiq01uuc+8UKQdsq93bdzPCxBGu6GwI0xzzRLiJ0H6GD0bATKI9SLYBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043047; c=relaxed/simple;
	bh=+LUwQZ/7D2WYRleohF/twUmiax93TN96cTz6e5ZLMi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDav4xA4nT7jJykKrJTcB6jYf9dnEptVkGH9/diqvhN5ZOwb1T9wNXwyi6n7Jx+SIRtZCjx4iW0BJyJc4tW3DcjQd6OkBQWpx9XnomQ/QQPGV+NEDGnU+XV7ZTAO7p1X3zsKg6OsxYkYanIgJzHGo+6+D0zpxUQdafLFODIyaa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofpgDhMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofpgDhMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77D2C433C7;
	Tue, 27 Feb 2024 14:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043047;
	bh=+LUwQZ/7D2WYRleohF/twUmiax93TN96cTz6e5ZLMi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofpgDhMpaVSm8BWHAz2cVvdJuOCVhjtvuZsA1tHiNE0I+6mNdQRWg9SnS9eWMEovR
	 Thv8fNLzZETxF4bF2btPsiPxyWKvExdUzUyjGLgTHNfo+y6lJN8+TnDLXjFBcvb9N+
	 Oqy2X1L6ohnmF1ZtEmZCH7U0c9XaBw4po81C+hwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 186/245] arm64: dts: rockchip: add SPDIF node for ROCK Pi 4
Date: Tue, 27 Feb 2024 14:26:14 +0100
Message-ID: <20240227131621.246843646@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit 697dd494cb1cf56acfb764214a1e4788e4d1a983 ]

Add a SPDIF audio-graph-card to ROCK Pi 4 device tree.

It's not enabled by default since all dma channels are used by
the (already) enabled i2s0/1/2 and the pin is muxed with GPIO4_C5
which might be in use already.
If enabled SPDIF_TX will be available at pin #15.

Signed-off-by: Alex Bee <knaerzche@gmail.com>
Link: https://lore.kernel.org/r/20210618181256.27992-6-knaerzche@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3399-rock-pi-4.dtsi   | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
index 0af694540c1eb..382bb0734cb74 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
@@ -42,6 +42,23 @@ sound {
 		dais = <&i2s0_p0>;
 	};
 
+	sound-dit {
+		compatible = "audio-graph-card";
+		label = "SPDIF";
+		dais = <&spdif_p0>;
+	};
+
+	spdif-dit {
+		compatible = "linux,spdif-dit";
+		#sound-dai-cells = <0>;
+
+		port {
+			dit_p0_0: endpoint {
+				remote-endpoint = <&spdif_p0_0>;
+			};
+		};
+	};
+
 	vcc12v_dcin: dc-12v {
 		compatible = "regulator-fixed";
 		regulator-name = "vcc12v_dcin";
@@ -631,6 +648,15 @@ &sdhci {
 	status = "okay";
 };
 
+&spdif {
+
+	spdif_p0: port {
+		spdif_p0_0: endpoint {
+			remote-endpoint = <&dit_p0_0>;
+		};
+	};
+};
+
 &tcphy0 {
 	status = "okay";
 };
-- 
2.43.0



