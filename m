Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C642EA739;
	Tue, 22 Jul 2025 13:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192316; cv=none; b=tAXELGeUKNIEzbhXcbCvp8PAElf/cXWGKhqZ/wWJK7A9SFFR3WKYfD4G/ZbkQkERyrfB2zfeZWu0LYx/G0e3s5yrOaFJZ4cdbrPo9bTXypH7Vj+2uB1WZBuk7SzaXLxRRoR4CPkJ+HEj89zDaDqDJDwBpZOgyBZd9pqYT2KBWJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192316; c=relaxed/simple;
	bh=d0yMQ6oug9muCsJg+fpuAuPZrgufsAKX5iUnS6EvM+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dy0RamYuvM7vTu+K5TLPb8nBfbVFJhrp1kVZg46msQpDGJUFAZ58baA1OsxW95X7ISYam2pTDU9yiYlKvDJP5xlQCCCNgYUTtOUPnD5nC/v7h4ZV2IfdLqXx+4ejSoSHtBnoon5/etEXOtdmnD9Tzju3s+pMoMe5teE663MYCYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoHqVWYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoHqVWYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80555C4CEEB;
	Tue, 22 Jul 2025 13:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192316;
	bh=d0yMQ6oug9muCsJg+fpuAuPZrgufsAKX5iUnS6EvM+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoHqVWYa+V2dJK2J+6QpDXJvpVoTgJ9kutwkwi8mwtYxxzp1mTD5D6FuR95DABbl0
	 N0GpQ6bPpio1RltWXIc/mEDL0522jG6ye2ni+qOsrLFp2nXzVeiGjlmW+AcDdYwTfL
	 qZdoVbSHT42hfqqES8RoEXHVJ+pILZXYfttW3+uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 029/111] arm64: dts: freescale: imx8mm-verdin: Keep LDO5 always on
Date: Tue, 22 Jul 2025 15:44:04 +0200
Message-ID: <20250722134334.478671329@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit fbe94be09fa81343d623a86ec64a742759b669b3 upstream.

LDO5 regulator is used to power the i.MX8MM NVCC_SD2 I/O supply, that is
used for the SD2 card interface and also for some GPIOs.

When the SD card interface is not enabled the regulator subsystem could
turn off this supply, since it is not used anywhere else, however this
will also remove the power to some other GPIOs, for example one I/O that
is used to power the ethernet phy, leading to a non working ethernet
interface.

[   31.820515] On-module +V3.3_1.8_SD (LDO5): disabling
[   31.821761] PMIC_USDHC_VSELECT: disabling
[   32.764949] fec 30be0000.ethernet end0: Link is Down

Fix this keeping the LDO5 supply always on.

Cc: stable@vger.kernel.org
Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Fixes: f5aab0438ef1 ("regulator: pca9450: Fix enable register for LDO5")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -470,6 +470,7 @@
 			};
 
 			reg_nvcc_sd: LDO5 {
+				regulator-always-on;
 				regulator-max-microvolt = <3300000>;
 				regulator-min-microvolt = <1800000>;
 				regulator-name = "On-module +V3.3_1.8_SD (LDO5)";


