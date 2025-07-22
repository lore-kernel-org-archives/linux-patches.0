Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949A52EAD00;
	Tue, 22 Jul 2025 14:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193292; cv=none; b=ifrsvnwjybs7Z6Ua4QTmJkMPQrD7Djxt4z0mkZ6xBsrTbYN3SvYsGrrccjVjHxJ6/SKwbUcg74HKGzyhtvxzZgreeixDDJq7fN1wcwgliZwYcEK/oXQY53t8k6y00oV0+z3AmeSYKB2xb17NaFLnf7dFUf/gMl2oNbL84hEogSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193292; c=relaxed/simple;
	bh=IkGSHj86oSO6frxM06PIZQxr2J93LG5sQjWhPUzDNAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2xvWdAAO03ElK+4vEZJVYv/iSfFB+7wkIfLfq3yuQlYDVbuN5ht9vXDRPbL4fXBZ0j0wTXvuHaV3NB3AYwl6vYhB6RrmAf6G95V21RwoQ1zqqUltDcRVC577m1i4NqbOBZkdDDi327iD2smhkSGqqXEhYZnmz76nyXBea+5Sgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8x2WdlB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8x2WdlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135A7C4CEEB;
	Tue, 22 Jul 2025 14:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193292;
	bh=IkGSHj86oSO6frxM06PIZQxr2J93LG5sQjWhPUzDNAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8x2WdlB8HtsNFwc2jhyNVgkfpd+/C8/2Z4r64Ncfz0EXYk36/lLg3MdyhkgFuuOx
	 +pqVgjuZLyRuTUFXCGK3sEJo6xb7+7WZ3oB7BDGol0pHQU3CwkJVLl+9yTgaBb+Mqo
	 DwCqdxFmh7TrZAy3ThxQoSpSki4sPvFzgD8p500w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.15 049/187] arm64: dts: imx8mp-venice-gw74xx: fix TPM SPI frequency
Date: Tue, 22 Jul 2025 15:43:39 +0200
Message-ID: <20250722134347.586062892@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -201,7 +201,7 @@
 	tpm@0 {
 		compatible = "atmel,attpm20p", "tcg,tpm_tis-spi";
 		reg = <0x0>;
-		spi-max-frequency = <36000000>;
+		spi-max-frequency = <25000000>;
 	};
 };
 


