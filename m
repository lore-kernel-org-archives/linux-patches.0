Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956B5BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE84FC433EF;
	Tue,  7 Mar 2023 18:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214745;
	bh=PKHxsyUf3Ta0SBx/iqiBFsEy+z8atpjOVWwWgRI2OFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZak8O75TvLWB7+qVNz9MXRhpSyopjhVaOHO25LjS/AVWGIr76oTvlgYvjTSMbNla
	 n4tVLM757DO5Fu87RtJFqAuR/gax5wMmaukm8/EF+Ab0w7D3ZW/JyNrGsPh7KNeoI5
	 +JLqUC4Wlwb857/+eJkjUVovvELHqQvPTpPnO2WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/567] arm64: dts: amlogic: meson-axg: fix SCPI clock dvfs node name
Date: Tue,  7 Mar 2023 17:56:12 +0100
Message-Id: <20230307165907.476260930@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 5b7069d72f03c92a0ab919725017394ebce03a81 ]

Fixes:
scpi: clocks: 'clock-controller' does not match any of the regexes: '^clocks-[0-9a-f]+$', 'pinctrl-[0-9]+'

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-2-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index e2ab338adb3c1..03e2c5d0bb9c1 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -152,7 +152,7 @@ scpi {
 		scpi_clocks: clocks {
 			compatible = "arm,scpi-clocks";
 
-			scpi_dvfs: clock-controller {
+			scpi_dvfs: clocks-0 {
 				compatible = "arm,scpi-dvfs-clocks";
 				#clock-cells = <1>;
 				clock-indices = <0>;
-- 
2.39.2



