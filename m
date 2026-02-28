Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DF0379ED5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301718; cv=none; b=Ze1FUKLgvC5SdawcAlbUVAuI7Vra1/t8938rSXoOXWbzs6Z/szLiyfwvvGCvbCtt1ml28ql7QKjYH6hJsjrQez1fwCnisJBnJ1D1ewln84YZAm/VW/RBZPGnqqxqvujH0S8DmqCzI5mRIYucb1k60krmvlS6r6CDxGvYFIyj344=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301718; c=relaxed/simple;
	bh=fyaCtbOiUtLySfq7ZVti8V/t78JmMyDbNKveZWZ6bLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBLAlhxMKb15eYP9nRPSjBMFnAcfShDKmHTlNiOmEhuZ9txBI0NRwjERtB7X+GwjYkZY8VIWu3lCxFXOQX5skiS2FsxkBP3aStWMGKPNWTPh6Iz/7Gyrwicg9Z1hFfawgYqe7HqL1sFK3rltcXQcPGnBKEnEhELbz/E3x5cKrrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=orf610EJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="orf610EJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701F6C116D0;
	Sat, 28 Feb 2026 18:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301718;
	bh=fyaCtbOiUtLySfq7ZVti8V/t78JmMyDbNKveZWZ6bLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=orf610EJ8uj9dCKl0lirLU+sOO7Khp99WTnwGcT8/WkIqGX3LB2ADO+72nBzRq+Vn
	 uBHoZW4kUSufUSb+paSyL2FYlva9wzQeHRNm/kRzYLxlvbmDbHa0+gvhf7u7klxQQv
	 SGkANc2GgpF5IqoBoFv3jy5Xzl1u5AE3FnEBPZNxZil20yNRXfCF+PTqJFCQLKKvot
	 0cpEMXg0FDHLycuX9bDtBPEjOrAE7EixkpkW5hY9PRcSMjHCjawXV2vtTPFxExaSGE
	 f5VcthZkSQOLtSYvqsC7e1bkiAG4ubEZkbXRBgEB2ju8/qB6S6yJOdMklP5LWtKr45
	 7wsCmN5EtlFcw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Abhash Kumar Jha <a-kumar2@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/385] arm64: dts: ti: k3-j784s4-main.dtsi: Move c71_3 node to appropriate order
Date: Sat, 28 Feb 2026 12:55:36 -0500
Message-ID: <20260228180011.1568201-114-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Abhash Kumar Jha <a-kumar2@ti.com>

[ Upstream commit 24c9d5fb8bbf5e8c9e6fc2beffeb80ac2da83de4 ]

The device tree nodes should be ordered by unit addresses in ascending
order.

Correct the order by moving the c71_3 DSP node at the end as it has a
higher unit address.

Signed-off-by: Abhash Kumar Jha <a-kumar2@ti.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://patch.msgid.link/20260112085113.3476193-2-a-kumar2@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Stable-dep-of: 61acc4428a7f ("arm64: dts: ti: k3-j784s4-j742s2-main-common.dtsi: Refactor watchdog instances for j784s4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi | 26 +++++++++++-----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi b/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi
index 0160fe0da9838..5b7830a3c0975 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi
@@ -6,19 +6,6 @@
  */
 
 &cbass_main {
-	c71_3: dsp@67800000 {
-		compatible = "ti,j721s2-c71-dsp";
-		reg = <0x00 0x67800000 0x00 0x00080000>,
-		      <0x00 0x67e00000 0x00 0x0000c000>;
-		reg-names = "l2sram", "l1dram";
-		resets = <&k3_reset 40 1>;
-		firmware-name = "j784s4-c71_3-fw";
-		ti,sci = <&sms>;
-		ti,sci-dev-id = <40>;
-		ti,sci-proc-ids = <0x33 0xff>;
-		status = "disabled";
-	};
-
 	pcie2_rc: pcie@2920000 {
 		compatible = "ti,j784s4-pcie-host";
 		reg = <0x00 0x02920000 0x00 0x1000>,
@@ -113,6 +100,19 @@ serdes2: serdes@5020000 {
 			status = "disabled";
 		};
 	};
+
+	c71_3: dsp@67800000 {
+		compatible = "ti,j721s2-c71-dsp";
+		reg = <0x00 0x67800000 0x00 0x00080000>,
+		      <0x00 0x67e00000 0x00 0x0000c000>;
+		reg-names = "l2sram", "l1dram";
+		resets = <&k3_reset 40 1>;
+		firmware-name = "j784s4-c71_3-fw";
+		ti,sci = <&sms>;
+		ti,sci-dev-id = <40>;
+		ti,sci-proc-ids = <0x33 0xff>;
+		status = "disabled";
+	};
 };
 
 &scm_conf {
-- 
2.51.0

