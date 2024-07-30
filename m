Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302DD1A616E;
	Tue, 30 Jul 2024 16:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355913; cv=none; b=GCt1DD11Q6GDV4iviIYOidj+7ssfn6DOeHmVwGoS020z7HBBIfKivepi3YIsfRS+B6UlfmML3x5mx8C77EvFSd3czrkBEUAPUjo2TewXRT3OjZlWFKqrfmIVKx4SDVpJGXtJNhz6+lDGcuRKQ1y1m8++7gL/xUOTe2fv36D+FRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355913; c=relaxed/simple;
	bh=5dK47b86etXWUAcwYsXyFStD+KvEQeZmhdA9gbcNNLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p2WgkPpQY/c1Rx+PrDJs8gbFWdBDHzzbQUXjEzL1VGW4fG2ffFpm+lstXBx0CBntKhmdb0DqduOCVYcl9gXybyXt862FBEF+MCD/nXIU/OiBxm81d6tky84kbi3pse87m0IiuKuT0GWWW27ZG8sNRBmHoegggJPsZvPmu1gtzKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuQAPQT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuQAPQT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD11BC32782;
	Tue, 30 Jul 2024 16:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355913;
	bh=5dK47b86etXWUAcwYsXyFStD+KvEQeZmhdA9gbcNNLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuQAPQT81ID9aEVtiJc29QwL1A/GnPP8cfuEZBKAoF4MjBrH76kNZe/BqzL+sRo7x
	 O2REH2pWmqe2qJmw8JOODrghrStJfGi28rNV346ztngNuNQqAVhoT2SiQPTyI86XsT
	 thLehc8tgujbPZM4JLJza//J8m/T4q1Di/9J8uuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 104/809] arm64: dts: mediatek: mt7981: fix code alignment for PWM clocks
Date: Tue, 30 Jul 2024 17:39:40 +0200
Message-ID: <20240730151728.736430612@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit f80cfe9616b7448eca709a3e87ca57201cd5787c ]

Align "clocks" array entries to start at the same column.

Fixes: cf29427573cc ("arm64: dts: mediatek: Add initial MT7981B and Xiaomi AX3000T")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20240405105030.24559-1-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7981b.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7981b.dtsi b/arch/arm64/boot/dts/mediatek/mt7981b.dtsi
index 4feff3d1c5f4e..178e1e96c3a49 100644
--- a/arch/arm64/boot/dts/mediatek/mt7981b.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7981b.dtsi
@@ -78,10 +78,10 @@ pwm@10048000 {
 			compatible = "mediatek,mt7981-pwm";
 			reg = <0 0x10048000 0 0x1000>;
 			clocks = <&infracfg CLK_INFRA_PWM_STA>,
-				<&infracfg CLK_INFRA_PWM_HCK>,
-				<&infracfg CLK_INFRA_PWM1_CK>,
-				<&infracfg CLK_INFRA_PWM2_CK>,
-				<&infracfg CLK_INFRA_PWM3_CK>;
+				 <&infracfg CLK_INFRA_PWM_HCK>,
+				 <&infracfg CLK_INFRA_PWM1_CK>,
+				 <&infracfg CLK_INFRA_PWM2_CK>,
+				 <&infracfg CLK_INFRA_PWM3_CK>;
 			clock-names = "top", "main", "pwm1", "pwm2", "pwm3";
 			#pwm-cells = <2>;
 		};
-- 
2.43.0



