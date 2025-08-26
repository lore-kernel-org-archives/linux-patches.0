Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A2C2BE7DD;
	Tue, 26 Aug 2025 11:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208681; cv=none; b=l2hUXd9WuFdGpDZ9Utr9ATkCPXKZCiMU2bCxEVVY1Ei/SJTQOjBHxe+ANW61Leusn/8dmOXmLMGdJaj+8TiuyaBFhCxwEgysAiDY+xDkN+ifagkMlFhMhgPLRh4YmeT73KJEpclY/yd1Pi2gZ3cPODEYgDVT8SvVXuhlse9FcXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208681; c=relaxed/simple;
	bh=QFDhdVeG7Ui3P+uAQTuQ6Xl693d0V60w5XqBDS8IpS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dw5ZtWtcH86SiZ6JyubPaY2SpSGXD0QQ8oHftF1FZyLcGpfEXxTaHS1yNIePOYQmz1hUaY3kcecNzAM4mulV+q6pVGYoKiVw6W9vsRYZpeGMZxPB6S7/K190pkvoRMb8lTBTBi4fU94vphUFS8Z4QeSyKRs+J1c5d8W+fzFNpKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAFLWvKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAFLWvKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC4CC4CEF1;
	Tue, 26 Aug 2025 11:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208681;
	bh=QFDhdVeG7Ui3P+uAQTuQ6Xl693d0V60w5XqBDS8IpS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAFLWvKWmzlT8xyVMaJTMM5TXefa2Cu5lmHAhE2ud7Bc5fu6CZ2ZMQzXBBPPQNShf
	 AGAt0ZF3nNSPUGCQ+1Rc7R8tKamAwYgtW4Ur6OsdhT0lzAaEyJ9W6aWbBsm5DZluG7
	 nXpOWFWn24yhkiagCpr/tO+I+QW2HUYImUUwPKN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 203/322] arm64: dts: ti: k3-am62*: Add non-removable flag for eMMC
Date: Tue, 26 Aug 2025 13:10:18 +0200
Message-ID: <20250826110920.881015785@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit d16e7d34352c4107a81888e9aab4ea4748076e70 ]

EMMC device is non-removable so add 'non-removable' DT
property to avoid having to redetect the eMMC after
suspend/resume.

Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://lore.kernel.org/r/20250429151454.4160506-3-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Stable-dep-of: a0b8da04153e ("arm64: dts: ti: k3-am62*: Move eMMC pinmux to top level board file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts |    1 +
 arch/arm64/boot/dts/ti/k3-am62p5-sk.dts        |    1 +
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi |    1 +
 3 files changed, 3 insertions(+)

--- a/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
+++ b/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
@@ -818,6 +818,7 @@
 
 &sdhci0 {
 	bootph-all;
+	non-removable;
 	pinctrl-names = "default";
 	pinctrl-0 = <&emmc_pins_default>;
 	disable-wp;
--- a/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
@@ -444,6 +444,7 @@
 
 &sdhci0 {
 	status = "okay";
+	non-removable;
 	ti,driver-strength-ohm = <50>;
 	disable-wp;
 	bootph-all;
--- a/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
@@ -416,6 +416,7 @@
 &sdhci0 {
 	bootph-all;
 	status = "okay";
+	non-removable;
 	pinctrl-names = "default";
 	pinctrl-0 = <&main_mmc0_pins_default>;
 	disable-wp;


