Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850F33CA486;
	Tue, 13 Oct 2026 12:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894506; cv=none; b=fX+NJSfDM07FiqB7rmuZP0FZdoKULbPlh3s7DMY4YQD22ZQ/peXqdgzcdH1kw0ICaV7uvd0wHyxrlc6u2Uq+ygV0D6+FeEoFDlhFFP1uSU0aSC5XdDTfkH4Iq/XVl9NSKSibdjl+4mmXpFi2KyvFhExUuwSb1OQHAfSxo9cNxWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894506; c=relaxed/simple;
	bh=2DFkgEsDqTqLkyuK5f8cqAkAj0Z1pt0mcU883M/UpX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugZk58HbUhGZmkHFG6zHJtYr03EJ3cSbk04/WIO/r8/UIIRre/9hh6P1YhpZ/VOH5x7sPuezA4WFGD7IAPWPRssXX9lO/LXE1tXFhhi1YMY+/vWNv0EjJiP7SqvE5/ryiRynaVf6Az+o4FKTDvD65JrY3gcfrBEsphNaUxvRzEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEKHxBfq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEKHxBfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5EB1F000FF;
	Tue, 13 Oct 2026 12:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894505;
	bh=YiNJiq0eKu8LRM+lbmWdRxo/CqpA4Inzq9NrTrQgQnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qEKHxBfq0yE9nzwbE+Eu8DJLfmFSGzScxjcCbTkhrV7HbTPKDpEthKJpRJmkrlNKP
	 3LUsAzo00wtTv0sAxmVsimMfrLyqqngied6FGYtNEzx5kIghT3oZsd1r2cntr+s6hA
	 BaqOUo4CblYrQl3SbY8lfzEijIz2xwcE1ehFlJZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thibaut Collet <thbt.cllt@gmail.com>,
	Josua Mayer <josua@solid-run.com>,
	Vincent Jardin <vjardin@free.fr>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 529/621] arm64: dts: lx2160a: fix incorrect pinmux
Date: Tue, 13 Oct 2026 13:38:44 +0200
Message-ID: <20261013112933.373575598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index f7fb0a0562ec7..b0150b18ffcaa 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1799,7 +1799,7 @@ fspi_data74_pins: xspi1-data74-pins {
 			};
 
 			gpio1_31_28_pins: xspi1-data74-gpio-pins {
-				pinctrl-single,bits = <0x0 0x1 (0x7 << 15)>;
+				pinctrl-single,bits = <0x0 (0x1 << 15) (0x7 << 15)>;
 			};
 
 			fspi_data30_pins: xspi1-data30-pins {
@@ -1807,7 +1807,7 @@ fspi_data30_pins: xspi1-data30-pins {
 			};
 
 			gpio1_27_24_pins: xspi1-data30-gpio-pins {
-				pinctrl-single,bits = <0x0 0x1 (0x7 << 18)>;
+				pinctrl-single,bits = <0x0 (0x1 << 18) (0x7 << 18)>;
 			};
 
 			fspi_dqs_sck_cs10_pins: xspi1-base-pins {
@@ -1815,7 +1815,7 @@ fspi_dqs_sck_cs10_pins: xspi1-base-pins {
 			};
 
 			gpio1_23_20_pins: xspi1-base-gpio-pins {
-				pinctrl-single,bits = <0x0 0x1 (0x7 << 21)>;
+				pinctrl-single,bits = <0x0 (0x1 << 21) (0x7 << 21)>;
 			};
 
 			esdhc0_cmd_data30_clk_vsel_pins: sdhc1-base-sdhc-vsel-pins {
-- 
2.53.0



