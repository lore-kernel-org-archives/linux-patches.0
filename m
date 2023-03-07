Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276F9BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BC5C433EF;
	Tue,  7 Mar 2023 17:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208917;
	bh=XjvrCQwQamrfGufxM8l94IqEUrbzK7jzjOUTChV4hpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDxqOsHZyBQ4PL/2Av1r9SjfslKC1UmL2VUGlXbB7Oog2ksq5olswqmqZHFC9zByd
	 mGiziTKruRaslWbQN7herjzLPpcG1zhFi2ECl9rrpN4sMkZ94xh5ecJrNO8qlLRyEZ
	 2fpWUbVbQehwEVh0fFBDpIUSL/fzM1ffSGdJfDG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0051/1001] arm64: tegra: Fix duplicate regulator on Jetson TX1
Date: Tue,  7 Mar 2023 17:47:03 +0100
Message-Id: <20230307170024.336548031@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 29bcc1eaca315326d1cc883fbe9b451d1f9e3fa5 ]

When the top-level regulators were renamed, the 1.2V camera regulator
accidentally ended up with the same DT node name as the 1.8V camera
regulator.

Fixes: 097e01c61015 ("arm64: tegra: Rename top-level regulators")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
index dd9a17922fe5c..a87e103f3828d 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
@@ -1667,7 +1667,7 @@ vdd_hdmi: regulator-vdd-hdmi {
 		vin-supply = <&vdd_5v0_sys>;
 	};
 
-	vdd_cam_1v2: regulator-vdd-cam-1v8 {
+	vdd_cam_1v2: regulator-vdd-cam-1v2 {
 		compatible = "regulator-fixed";
 		regulator-name = "vdd-cam-1v2";
 		regulator-min-microvolt = <1200000>;
-- 
2.39.2



