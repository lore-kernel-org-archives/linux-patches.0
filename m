Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3632877FA;
	Tue, 22 Jul 2025 13:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192731; cv=none; b=OtRK60dBWnqG2T8a+G0TYl8v/5/mU8nnbRdpYJsMFp6vsdlfYK64LZTtCmA69L04RfyZginPURV9KfVuhENEhAum/U9ZXjemgMCsJ0JZ+XtIdcMOLu66QN4SbZEAqtFOnz/LsjJrk5uvTEx8qe8PS2yfJlBkK+yuMQhxoBrqgZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192731; c=relaxed/simple;
	bh=1sLnQs1gLUBwenA6MIBVDmQ7cg0Yy0aA0gzJOfOlQz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Okvswle8wO0jJWbpMALTUVGVIg7VsISIpfDLC8yXVXsGHHZ3/C2Za/O2w1OhWThp8Qi3uZW20ZX85k4CJNgMY2u1+i3AgRnKt1wW6UZ8fFWD1TOSUiA4Myrf+9tO7WndvqoDEaEtKfWaSd6N5YNE92MNq0+E71o1jok3mYl4ix8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doEUnR8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doEUnR8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41189C4CEEB;
	Tue, 22 Jul 2025 13:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192731;
	bh=1sLnQs1gLUBwenA6MIBVDmQ7cg0Yy0aA0gzJOfOlQz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doEUnR8sv5FMIFIij9O3izQxMXY/KpqxZ5WvLeoQvORVYhPovITXsYUJg5e1NObJE
	 At+NRSZFw9XrILc1qnRccVG+NKqEBmRtAlZy4r6kLATSwjm55dPNFmV1LBlGhTx71q
	 z3BEWj9akOVQoF8nlkXQluoCHbCB5r3mR06No1ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.12 041/158] arm64: dts: imx8mp-venice-gw74xx: fix TPM SPI frequency
Date: Tue, 22 Jul 2025 15:43:45 +0200
Message-ID: <20250722134342.273901847@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Tim Harvey <tharvey@gateworks.com>

commit 0bdaca0922175478ddeadf8e515faa5269f6fae6 upstream.

The IMX8MPDS Table 37 [1] shows that the max SPI master read frequency
depends on the pins the interface is muxed behind with ECSPI2
muxed behind ECSPI2 supporting up to 25MHz.

Adjust the spi-max-frequency based on these findings.

[1] https://www.nxp.com/webapp/Download?colCode=IMX8MPIEC

Fixes: 531936b218d8 ("arm64: dts: imx8mp-venice-gw74xx: update to revB PCB")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
@@ -199,7 +199,7 @@
 	tpm@0 {
 		compatible = "atmel,attpm20p", "tcg,tpm_tis-spi";
 		reg = <0x0>;
-		spi-max-frequency = <36000000>;
+		spi-max-frequency = <25000000>;
 	};
 };
 


