Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B331C5D72;
	Mon,  2 Jun 2025 13:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872787; cv=none; b=BLOdvkVGIyToF6r9J2a9vRy65F8vVhWgAJwyQC8EsV29uDBXiqBfkXIouqZt9awbPvoxaE8C89ICThBzW+p5h52+pPyuRUapF1yuCsnQvJrUPVDrWADumWspTdAx4CDMyxxKJRIBJjBjMBrE4BRq/VpMmQL2IG5l6JRvT46Wzxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872787; c=relaxed/simple;
	bh=JwVoz33uOdhkYSiAzx6hvv0+PLHLCj5JagRCCzCOz78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mk0WBxMQpdcUYiQgYHSlR7U8rIllvRpifc87ivpaCkIuC1iLPeHinDtNXUkjkT3oMfQgI2ayxhbfMgd7TwhGrGcH262GpjfVpaoI51Cf1Octbr/+rksetSSDbzFWNasPnILK9mNFeVpTKIupN0sgdXwFnvx1F/PrWq0R4A5THSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wEvvTG8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEvvTG8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B44C4CEEB;
	Mon,  2 Jun 2025 13:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872787;
	bh=JwVoz33uOdhkYSiAzx6hvv0+PLHLCj5JagRCCzCOz78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEvvTG8JedYJc68/RQQN6ACap3UXXr2f1rcsSxE+4wMTwn6B+zxoTGt1b0qIO0x3H
	 A876s+s8HCzHelhOMo6aE7u1cgTNTzK3ECoAiDRPJJLrEwl6Vg5KFU8qsjCK7MGvcq
	 bJcf3xlFu0YNpfiyHzRHUzf3FbCx5DugoABkl/BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.14 38/73] arm64: dts: ti: k3-j722s-evm: Enable "serdes_wiz0" and "serdes_wiz1"
Date: Mon,  2 Jun 2025 15:47:24 +0200
Message-ID: <20250602134243.197893404@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 9d76be5828be44ed7a104cc21b4f875be4a63322 upstream.

In preparation for disabling "serdes_wiz0" and "serdes_wiz1" device-tree
nodes in the SoC file, enable them in the board file. The motivation for
this change is that of following the existing convention of disabling
nodes in the SoC file and only enabling the required ones in the board
file.

Fixes: 485705df5d5f ("arm64: dts: ti: k3-j722s: Enable PCIe and USB support on J722S-EVM")
Cc: stable@vger.kernel.org
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://lore.kernel.org/r/20250417123246.2733923-2-s-vadapalli@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-j722s-evm.dts |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
@@ -815,6 +815,10 @@
 		      <J722S_SERDES1_LANE0_PCIE0_LANE0>;
 };
 
+&serdes_wiz0 {
+	status = "okay";
+};
+
 &serdes0 {
 	status = "okay";
 	serdes0_usb_link: phy@0 {
@@ -826,6 +830,10 @@
 	};
 };
 
+&serdes_wiz1 {
+	status = "okay";
+};
+
 &serdes1 {
 	status = "okay";
 	serdes1_pcie_link: phy@0 {


