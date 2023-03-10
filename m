Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD64881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F60C433D2;
	Fri, 10 Mar 2023 14:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459464;
	bh=Oil2IFkk6uSlTqtU4ahYJZo8ReqePRMoELYuoES1ab0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omJ3tcWcGrWi7RxcRO+/bofojHFN3uBaCTym6CeeblPUfDCQz7+KWd5AUuav5oFil
	 sqFvdmcI3ui14Ro/8ilGxCDEHVekF/PQqCkRaP73ceBtZiCNj7mleGzWnOSGFW9BSN
	 ZnFPvZFIx+WfCe+MF3F4zWPYgfdpI6/nIp/27wSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/529] arm64: dts: meson-gx: Fix the SCPI DVFS node name and unit address
Date: Fri, 10 Mar 2023 14:32:36 +0100
Message-Id: <20230310133805.631164809@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit f189c869ad92787ddd753558bcbae89d75825bb6 ]

Node names should be generic and use hyphens instead of underscores to
not cause warnings. Also nodes without a reg property should not have a
unit-address. Change the scpi_dvfs node to use clock-controller as node
name without a unit address (since it does not have a reg property).

Fixes: 70db166a2baa ("ARM64: dts: meson-gxbb: Add SCPI with cpufreq & sensors Nodes")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230111211350.1461860-7-martin.blumenstingl@googlemail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index 46018df13cc24..85f4876c509ae 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -243,7 +243,7 @@ scpi {
 		scpi_clocks: clocks {
 			compatible = "arm,scpi-clocks";
 
-			scpi_dvfs: scpi_clocks@0 {
+			scpi_dvfs: clock-controller {
 				compatible = "arm,scpi-dvfs-clocks";
 				#clock-cells = <1>;
 				clock-indices = <0>;
-- 
2.39.2



