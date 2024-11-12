Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC02620E337;
	Tue, 12 Nov 2024 10:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407563; cv=none; b=g7a3pnmNye4Vtkp5IMpm19ZZsHjVw/PEUtJ7dcy/AeFiGtKcwxpI8Wrpb99+hbK9sV2PAAAMIgo0B6VzZGGQUWJ9EDEvvhPweN/FqlVU3nCAAuqEFLpWZTlzFMZ4t0ln65zS88QJZJ3BRWxi7bwlAgJvKwxGJddCjI0upbbwgLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407563; c=relaxed/simple;
	bh=6N9P0w2OczyanDiSJolkHc4M042C0RiKFss54p2VmTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEdGAs6FbHTLo04TlkPggzAnRqs43+zCsIbbZ+RUA2ZK976zN/Z6b4tImRzR8o0EOSpWSOB+3Kr7YD+aH5l2DxKUMN7Bch2ycMXG0aEE16AKc/JghQZi75qB4Fc+79gu1sIGxDNTFm4YAf8XhEsCcDuxDjhoEpf2pxenaApq4Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KD3Rn/ij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KD3Rn/ij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539C9C4CECD;
	Tue, 12 Nov 2024 10:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407562;
	bh=6N9P0w2OczyanDiSJolkHc4M042C0RiKFss54p2VmTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KD3Rn/ijTg1rPP193WzT+Xz4Vj3AP4vQCzgvnYCY8oAIPYTDttySJ+wlO2Ix96zR1
	 rwEZ1DN+6d3+gVnrfFHbuLuDcWNXT3yF2R3CGbFzLdBGiUnOJmu29bwzhJ8KCCZGpV
	 y2SNXsre9HmhRes3uModCs52utxYKmjGQr/d37d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/119] arm64: dts: imx8qxp: Add VPU subsystem file
Date: Tue, 12 Nov 2024 11:20:22 +0100
Message-ID: <20241112101849.258535673@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 6bcd8b2fa2a9826fb6a849a9bfd7bdef145cabb6 ]

imx8qxp re-uses imx8qm VPU subsystem file, but it has different base
addresses. Also imx8qxp has only two VPU cores, delete vpu_vore2 and
mu2_m0 accordingly.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: eed2d8e8d005 ("arm64: dts: imx8-ss-vpu: Fix imx8qm VPU IRQs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8qxp-ss-vpu.dtsi      | 17 +++++++++++++++++
 arch/arm64/boot/dts/freescale/imx8qxp.dtsi      |  2 +-
 2 files changed, 18 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8qxp-ss-vpu.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8qxp-ss-vpu.dtsi b/arch/arm64/boot/dts/freescale/imx8qxp-ss-vpu.dtsi
new file mode 100644
index 0000000000000..7894a3ab26d6b
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-ss-vpu.dtsi
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: (GPL-2.0-or-later OR X11)
+/*
+ * Copyright 2023 TQ-Systems GmbH <linux@ew.tq-group.com>,
+ * D-82229 Seefeld, Germany.
+ * Author: Alexander Stein
+ */
+
+&vpu_core0 {
+	reg = <0x2d040000 0x10000>;
+};
+
+&vpu_core1 {
+	reg = <0x2d050000 0x10000>;
+};
+
+/delete-node/ &mu2_m0;
+/delete-node/ &vpu_core2;
diff --git a/arch/arm64/boot/dts/freescale/imx8qxp.dtsi b/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
index c80c85a4b4059..b155180cc249b 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
@@ -48,7 +48,6 @@
 		serial3 = &lpuart3;
 		vpu-core0 = &vpu_core0;
 		vpu-core1 = &vpu_core1;
-		vpu-core2 = &vpu_core2;
 	};
 
 	cpus {
@@ -317,6 +316,7 @@
 };
 
 #include "imx8qxp-ss-img.dtsi"
+#include "imx8qxp-ss-vpu.dtsi"
 #include "imx8qxp-ss-adma.dtsi"
 #include "imx8qxp-ss-conn.dtsi"
 #include "imx8qxp-ss-lsio.dtsi"
-- 
2.43.0



