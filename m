Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB751DF974;
	Wed,  6 Nov 2024 12:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896457; cv=none; b=Cg8UoSSr8fmIsJU3YdW6llJapA+5BAR/OEORrxOQ+zic5b2o9Px0YaRyct4bxWQCtWAmPiS85g4VsJ/culVv/YXtrcFlh7Nvv16EmaV+4xR9jOLalD6WFXCUHY2YIRVwufVdHSZ5CSKS0N/YAz3xnVlWNs9/TR8WXsHh+slRVZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896457; c=relaxed/simple;
	bh=8bQuBepsDmv6FkRue6ATJ2udTf79nY8eeJtoPR/V+Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTH4VzXMTnQzGdlukDEl0LyIc6DsuD92JLwNTu8xZqN6m5sGLAtzkOrj7M2F2krojoZRC9joQvqhj0/cLAwPZDq/F5v65Nk0Qc4ge0fwL+n+5twWGYZf45677x9g7xD+XtXt6Z8jnhGkMcHeIZktYUPtGxuUwCOt2mGkTZzs76A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iuxHd4K9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iuxHd4K9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7010EC4CECD;
	Wed,  6 Nov 2024 12:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896456;
	bh=8bQuBepsDmv6FkRue6ATJ2udTf79nY8eeJtoPR/V+Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iuxHd4K9k6+Y3S02kU09CIX13OZyl2BADNFKUS63maq1v4VMbHWT2OTPvCgbfaNfc
	 R80eU401zv5wjMzKdq/1XU2DAfpPbMMyr2sk/PGnPdcud1fl0AtSvcSyti/HpfcXxo
	 9KhetCfGfNrimPGA9+Ns8odMbBJBu7XFVLP/1y5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	E Shattow <e@freeshell.de>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.11 209/245] riscv: dts: starfive: Update ethernet phy0 delay parameter values for Star64
Date: Wed,  6 Nov 2024 13:04:22 +0100
Message-ID: <20241106120324.397627867@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: E Shattow <e@freeshell.de>

commit 825bb69228c8ab85637d21cdf4d44207937130b6 upstream.

Improve function of Star64 bottom network port phy0 with updated delay values.
Initial upstream patches supporting Star64 use the same vendor board support
package parameters known to result in an unreliable bottom network port.

Success acquiring DHCP lease and no dropped packets to ping LAN address:
rx  900: tx 1500 1650 1800 1950
rx  750: tx      1650 1800 1950
rx  600: tx           1800 1950
rx 1050: tx      1650 1800 1950
rx 1200: tx 1500 1650 1800 1950
rx 1350: tx 1500 1650 1800 1950
rx 1500: tx 1500 1650 1800 1950
rx 1650: tx 1500 1650 1800 1950
rx 1800: tx 1500 1650 1800 1950
rx 1900: tx                1950
rx 1950: tx                1950

Failure acquiring DHCP lease or many dropped packets:
rx  450: tx                1500      1800 1950
rx  600: tx      1200 1350      1650
rx  750: tx           1350 1500
rx  900: tx      1200 1350
rx 1050: tx 1050 1200 1350 1500
rx 1200: tx           1350
rx 1350: tx           1350
rx 1500: tx      1200 1350
rx 1650: tx 1050 1200 1350
rx 1800: tx 1050 1200 1350
rx 1900: tx                1500 1650 1800
rx 1950: tx      1200 1350

Non-functional:
rx    0: tx 0  150  300  450  600  750  900 1050 1200 1350 1500 1650 1800 1950
rx  150: tx 0  150  300  450  600  750  900 1050 1200 1350 1500 1650 1800 1950
rx  300: tx 0  150  300  450  600  750  900 1050 1200 1350 1500 1650 1800 1950
rx  450: tx 0  150  300  450  600  750  900 1050 1200 1350      1650
rx  600: tx 0  150  300  450  600  750  900 1050
rx  750: tx 0  150  300  450  600  750  900 1050 1200
rx  900: tx 0  150  300  450  600  750  900 1050
rx 1050: tx 0  150  300  450  600  750  900
rx 1200: tx 0  150  300  450  600  750  900 1050 1200
rx 1350: tx 0  150  300  450  600  750  900 1050 1200
rx 1500: tx 0  150  300  450  600  750  900 1050
rx 1650: tx 0  150  300  450  600  750  900
rx 1800: tx 0  150  300  450  600  750  900
rx 1900: tx 0  150  300  450  600  750  900 1050 1200 1350
rx 1950: tx 0  150  300  450  600  750  900 1050

Selecting the median of all working rx delay values 1500 combined with tx delay
values 1500, 1650, 1800, and 1950 only the tx delay value of 1950 (default) is
reliable as tested in both Linux 6.11.2 and U-Boot v2024.10

Signed-off-by: E Shattow <e@freeshell.de>
CC: stable@vger.kernel.org
Fixes: 2606bf583b962 ("riscv: dts: starfive: add Star64 board devicetree")
Acked-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/starfive/jh7110-pine64-star64.dts |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/riscv/boot/dts/starfive/jh7110-pine64-star64.dts
+++ b/arch/riscv/boot/dts/starfive/jh7110-pine64-star64.dts
@@ -44,8 +44,7 @@
 };
 
 &phy0 {
-	rx-internal-delay-ps = <1900>;
-	tx-internal-delay-ps = <1500>;
+	rx-internal-delay-ps = <1500>;
 	motorcomm,rx-clk-drv-microamp = <2910>;
 	motorcomm,rx-data-drv-microamp = <2910>;
 	motorcomm,tx-clk-adj-enabled;


