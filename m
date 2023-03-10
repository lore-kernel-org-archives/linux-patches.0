Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21792848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FD8C433D2;
	Fri, 10 Mar 2023 14:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458528;
	bh=bnzylntJPGUE2VYLEKv/n97taFtKh9yqv1oYNTrudjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5Fv05M2Xf9hp5Plin72sKMms198s4LYieEoLv75zgpUN0znulEuZDGKoMSNd8+zX
	 loF59zaev1G9uZFk3mDYWL7cd72x5QR8di54wAv53kSrVUVEX2bBInrKYkGKgZoUGh
	 AVB0Z813l439efI2gwnYYRXXTIdw2FuUC2TyEfwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/357] arm64: dts: amlogic: meson-gx: add missing SCPI sensors compatible
Date: Fri, 10 Mar 2023 14:35:05 +0100
Message-Id: <20230310133734.709687118@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

[ Upstream commit 2ff650051493d5bdb6dd09d4c2850bb37db6be31 ]

Fixes:
scpi: sensors:compatible: 'oneOf' conditional failed, one must be fixed:
	['amlogic,meson-gxbb-scpi-sensors'] is too short
	'arm,scpi-sensors' was expected

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-3-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index 7b2be0942c3bb..72255898081c8 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -159,7 +159,7 @@ scpi_dvfs: clocks-0 {
 		};
 
 		scpi_sensors: sensors {
-			compatible = "amlogic,meson-gxbb-scpi-sensors";
+			compatible = "amlogic,meson-gxbb-scpi-sensors", "arm,scpi-sensors";
 			#thermal-sensor-cells = <1>;
 		};
 	};
-- 
2.39.2



