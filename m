Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E80847CA69;
	Tue, 13 Oct 2026 11:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892456; cv=none; b=GvVj984BRT1+lztmmIL/o8nrTWOnxElB2ucNx0pelGQ/izx+O8fdRWmqCSqkUAb6rw0G0Zqm6sZasSkvKOUI/LaEBz1wW6vKvxU7x+R+4XlcmSyjUiUWvos5n9+osqy+H4n4v+jzXkf1L9R98Cymb43EgTrurWYfO4XKA51vO1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892456; c=relaxed/simple;
	bh=ntgztTBO/7sQZ6+vqEuGWesh//FMy+5yR33k8cmSoj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGtvdsoqNbCFuBiwKZT/yfm//r/jjD+3rilLiWAdSFC2fHkd8ZI65plDXqoFjABJ4XOa3adQqK1t+B4Zj+9s76hPx6qR1VqTaxqlQIWEMOnN14P+BCyIY8Z1P3yzFSJqSGR8lNaAw5NCz/CO/Zw791Y38aoIb/KnpSNCnFzRpjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ENtWd7dv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ENtWd7dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D840C1F000FF;
	Tue, 13 Oct 2026 11:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892455;
	bh=BbhJkhS7rhqB2UWRpmXTlpa/DUBN2NdGk2V57Ih5yP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ENtWd7dvd5W0oS1aWdYAqYJh4FxDTlYbYDV1lfhZ7Sb5shVyKzINHzBe6wH/rrjZ3
	 tqrr8qqGPhyxhkEYFc43H99cpqIWCHP0ug2G5eBMOxUj+fnygPXP95i3/VinP2IR5O
	 HKwYF1eqJTLfg8vMQFABLqgw7ibzYQ/tnEk5QY2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thibaut Collet <thbt.cllt@gmail.com>,
	Josua Mayer <josua@solid-run.com>,
	Vincent Jardin <vjardin@free.fr>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 180/281] arm64: dts: lx2160a: fix incorrect pinmux
Date: Tue, 13 Oct 2026 13:38:16 +0200
Message-ID: <20261013112859.533570675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Jardin <vjardin@free.fr>

[ Upstream commit 8188a59dd6782786556b18f515090b79cb701c45 ]

For gpio1 value set for pinctrl is outside the mask and so will do
nothing.

Add the missing offset for value field to be the same as the mask as
expected.

Fixes: 284ad7064aaa ("arm64: dts: lx2160a: complete pinmux for rcwsr12 configuration word")
Suggested-by: Thibaut Collet <thbt.cllt@gmail.com>
Reviewed-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Vincent Jardin <vjardin@free.fr>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 1d73abffa6b72..b9f079c49e193 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1803,7 +1803,7 @@ fspi_data74_pins: xspi1-data74-pins {
 			};
 
 			gpio1_31_28_pins: xspi1-data74-gpio-pins {
-				pinctrl-single,bits = <0x0 0x1 (0x7 << 15)>;
+				pinctrl-single,bits = <0x0 (0x1 << 15) (0x7 << 15)>;
 			};
 
 			fspi_data30_pins: xspi1-data30-pins {
@@ -1811,7 +1811,7 @@ fspi_data30_pins: xspi1-data30-pins {
 			};
 
 			gpio1_27_24_pins: xspi1-data30-gpio-pins {
-				pinctrl-single,bits = <0x0 0x1 (0x7 << 18)>;
+				pinctrl-single,bits = <0x0 (0x1 << 18) (0x7 << 18)>;
 			};
 
 			fspi_dqs_sck_cs10_pins: xspi1-base-pins {
@@ -1819,7 +1819,7 @@ fspi_dqs_sck_cs10_pins: xspi1-base-pins {
 			};
 
 			gpio1_23_20_pins: xspi1-base-gpio-pins {
-				pinctrl-single,bits = <0x0 0x1 (0x7 << 21)>;
+				pinctrl-single,bits = <0x0 (0x1 << 21) (0x7 << 21)>;
 			};
 
 			esdhc0_cmd_data30_clk_vsel_pins: sdhc1-base-sdhc-vsel-pins {
-- 
2.53.0



