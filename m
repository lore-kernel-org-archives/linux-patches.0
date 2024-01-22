Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A3714901A;
	Tue, 23 Jan 2024 01:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972095; cv=none; b=Xd2O9QF5glvqCyH0rc+APVnmlr96Xs7pVJYQ3oOP3MkCwJ+NQBHmNdBzEBD9U6oK0iPUcfyY3u2frAUq8s3PgYCfxwjs0TxfLgqsOwLXhAiFNFksW3jVZSMo3lhPu/yVA5pnrGQKfRKxFMN6kfMT9gXecF6L0h2BlxLyoHP0xoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972095; c=relaxed/simple;
	bh=Ufke1clUGDsFUGtyHVE4P12AflyIoI0r9EGtAo7k33M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYjP92rlfGRCIy7SiQPuYvtnMiTra2hq83ktm3QqocE88DQGzphVEvyLjeu2FkCyXJ0wvTIbMzZG/mfzX9hEVmDXpKFY8FwzGU1gxDEQEG9NEXuRsqudoZHJLVRBD7jh4S3MBrN6axnHZY9T3TcK1XWphfrOjeKCwJKifrOdxzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaytkMb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaytkMb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4019AC433C7;
	Tue, 23 Jan 2024 01:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972095;
	bh=Ufke1clUGDsFUGtyHVE4P12AflyIoI0r9EGtAo7k33M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaytkMb7QuaODW9xJYYt34JyCg2JwrXbF52m+EDwPlp7btIf07bO4VJdRXBlECScU
	 rYCJMkgZh9BJrVWjXB+4RA2FntdFnLkcQ0O39ROX6PSV5TL62brDmFerUprSsfMTTg
	 dZljbMf15i7Po98lnVRn2cHwqrWdUGM/eALFTD14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Yanteng Si <siyanteng@loongson.cn>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/374] MIPS: dts: loongson: drop incorrect dwmac fallback compatible
Date: Mon, 22 Jan 2024 15:54:50 -0800
Message-ID: <20240122235745.838629979@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 4907a3f54b12b8209864572a312cf967befcae80 ]

Device binds to proper PCI ID (LOONGSON, 0x7a03), already listed in DTS,
so checking for some other compatible does not make sense.  It cannot be
bound to unsupported platform.

Drop useless, incorrect (space in between) and undocumented compatible.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Yanteng Si <siyanteng@loongson.cn>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi | 3 +--
 arch/mips/boot/dts/loongson/ls7a-pch.dtsi          | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
index bfc3d3243ee7..d73d8f4fd78e 100644
--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -118,8 +118,7 @@ gmac@3,0 {
 				compatible = "pci0014,7a03.0",
 						   "pci0014,7a03",
 						   "pciclass0c0320",
-						   "pciclass0c03",
-						   "loongson, pci-gmac";
+						   "pciclass0c03";
 
 				reg = <0x1800 0x0 0x0 0x0 0x0>;
 				interrupts = <12 IRQ_TYPE_LEVEL_LOW>,
diff --git a/arch/mips/boot/dts/loongson/ls7a-pch.dtsi b/arch/mips/boot/dts/loongson/ls7a-pch.dtsi
index 2f45fce2cdc4..ed99ee316feb 100644
--- a/arch/mips/boot/dts/loongson/ls7a-pch.dtsi
+++ b/arch/mips/boot/dts/loongson/ls7a-pch.dtsi
@@ -186,8 +186,7 @@ gmac@3,0 {
 				compatible = "pci0014,7a03.0",
 						   "pci0014,7a03",
 						   "pciclass020000",
-						   "pciclass0200",
-						   "loongson, pci-gmac";
+						   "pciclass0200";
 
 				reg = <0x1800 0x0 0x0 0x0 0x0>;
 				interrupts = <12 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.43.0



