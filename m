Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8EA26B2D7;
	Wed, 25 Feb 2026 01:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983875; cv=none; b=MpAv0OjiC6iA+yEo5nLTtK8tk95ZGiqH1fth5hLRZqUC0gL6PASb2vIm9tQ8zNqEIuEQq0i3ZL1CtcfN6QEuu1lq7fRFSBLrpQgl3ElKoenH1GSVb7mWD+NiBNq8aT/Lu+YD/YjBKhNNBDDLSiH6paWtbsZUQ9/FHcMB0QD9VzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983875; c=relaxed/simple;
	bh=fqPgeUOB53mIoleIXKx2H7Fb5W0vXH+kStjteHd0crg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgBQSn9yPzu6d3ZNETif53xP4XJVFFCFDpYIbWSP6T41lD6YUc7sN97ZqLVddd3gXdB/3sz8wGCcsrD/kb+uUfLfRdam751hfHs/5OT6VrfRVFu07bex47yLlCN734dont2yjBc0SZ+mf8rIO05vME5lXqKjVkQ8WvOML6T9LUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYwyJ10+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYwyJ10+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A90C116D0;
	Wed, 25 Feb 2026 01:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983875;
	bh=fqPgeUOB53mIoleIXKx2H7Fb5W0vXH+kStjteHd0crg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYwyJ10+CLRedYAJRUSZ/fKJIwjaCLhWZOq2qDsG6/JB2J8HdDhihSzskQaQ5v6D3
	 ID0w0QPna3tCQLU25WWvzdyA0wq3uqHFIGEh4TYOPSVTLnGt/ehkLuhi1659DjtG1X
	 pdbE/XZgkM3bJ4bdjUb+45zwewPNmZpHXsiNX5Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhash Kumar Jha <a-kumar2@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 151/641] arm64: dts: ti: k3-j784s4-main.dtsi: Move c71_3 node to appropriate order
Date: Tue, 24 Feb 2026 17:17:57 -0800
Message-ID: <20260225012352.753243885@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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



