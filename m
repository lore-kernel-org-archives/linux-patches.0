Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32460143C4B;
	Thu, 13 Jun 2024 11:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279399; cv=none; b=RxZ0kjvAREKcwLK50cxTbqoKsi2+oIfulKD4Rls4+z/AokiQybR+JevmFMEietGdWI9iZLF4YMvH2Jk/Rn+mlFjohz+GMz0NXsfQgc/Rp4VPfv+kwU9ZldJ4miy7LfI9f2j0hJTpH71u8SGZ+W3fJ1W43e2slZOzH/DMn3KIsZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279399; c=relaxed/simple;
	bh=uX8T5PtCkgOGRvqMNg6BXFxOf8JdI4vIUEndm1Ll890=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKlAouwZstNkZNNWMBWWzJvzQtMfeLnQqkxKNt8F/Yrvn/oF7D1MsjHPwGOaTS7pf6baZ3GOkb439PNq9IW7UluQTMfb12QpniQbdwVJnF9rn1aze8iWXIReH6CJH/AAh4/7MemIEfZH+g7T/PPK3ddIScLp7zM72iGX3sgZrgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdqefEIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdqefEIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F907C32786;
	Thu, 13 Jun 2024 11:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279399;
	bh=uX8T5PtCkgOGRvqMNg6BXFxOf8JdI4vIUEndm1Ll890=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdqefEIAWGVQU1/hyk1wTk1wrXyTPUe9Ig/8CUBRuh+Y7Zr/gad2FyYTQonmEOcTb
	 YmyjSN8KGSPIsnBgvHb8H4/cmsyYu/qN9dhQZLv/RFWBm4J/igbSJk4GNWUpAXywBP
	 HfzMswvSJ06BEWlJpgn4ksYlnveBGDJukXVvTzRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.9 022/157] arm64: tegra: Correct Tegra132 I2C alias
Date: Thu, 13 Jun 2024 13:32:27 +0200
Message-ID: <20240613113228.268342956@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzk@kernel.org>

commit 2633c58e1354d7de2c8e7be8bdb6f68a0a01bad7 upstream.

There is no such device as "as3722@40", because its name is "pmic".  Use
phandles for aliases to fix relying on full node path.  This corrects
aliases for RTC devices and also fixes dtc W=1 warning:

  tegra132-norrin.dts:12.3-36: Warning (alias_paths): /aliases:rtc0: aliases property is not a valid node (/i2c@7000d000/as3722@40)

Fixes: 0f279ebdf3ce ("arm64: tegra: Add NVIDIA Tegra132 Norrin support")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/nvidia/tegra132-norrin.dts |    4 ++--
 arch/arm64/boot/dts/nvidia/tegra132.dtsi       |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/nvidia/tegra132-norrin.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra132-norrin.dts
@@ -9,8 +9,8 @@
 	compatible = "nvidia,norrin", "nvidia,tegra132", "nvidia,tegra124";
 
 	aliases {
-		rtc0 = "/i2c@7000d000/as3722@40";
-		rtc1 = "/rtc@7000e000";
+		rtc0 = &as3722;
+		rtc1 = &tegra_rtc;
 		serial0 = &uarta;
 	};
 
--- a/arch/arm64/boot/dts/nvidia/tegra132.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra132.dtsi
@@ -572,7 +572,7 @@
 		status = "disabled";
 	};
 
-	rtc@7000e000 {
+	tegra_rtc: rtc@7000e000 {
 		compatible = "nvidia,tegra124-rtc", "nvidia,tegra20-rtc";
 		reg = <0x0 0x7000e000 0x0 0x100>;
 		interrupts = <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>;


