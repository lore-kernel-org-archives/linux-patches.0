Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0EA311592;
	Fri, 15 May 2026 16:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862760; cv=none; b=CpomnyV9ocTdEdB88WqUxMlj3gLEFmOTm/GlVTUdcDFTcGvlzIimzxYqbXxz4dgqhmsGN0Fn47g406Aoba3QLV29O3TSU5xjt1cm33aevXMyEaRx2jKoAzZL06VAELXhN7X3stV3dJ/zcXan9N8UME1a+Ezm/RgopCKPUK3IY3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862760; c=relaxed/simple;
	bh=R2OX45BZaRCUH3Ei8BnvHUo+PM7+qit4+xcXAEp+5Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKS27yvfYu7WAaAUeDg636sUKPUjHU25KTX2F8ay5zwoazdigpO1C+kaeRHlH5RUbAjDSIoyMAiNLSJNCjNlfwfCOnlRBlkPHsYq4oR0Ms5X0nguXctAzpGCiFdc+6LC6nVcyz5N9efdu1cx31ibyIyzqnm7IETQhS4IoLTYHoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Xr2YaTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Xr2YaTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0570C2BCB0;
	Fri, 15 May 2026 16:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862760;
	bh=R2OX45BZaRCUH3Ei8BnvHUo+PM7+qit4+xcXAEp+5Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Xr2YaTMSgH2JgWykP8FMMtQLoU9DQnfmes3+pZebaL7ELXskeHpJZobjJdZl51tb
	 qG5p2ch2jw61sREhaJEMBlr035hOOaTqTDmaHCaBAwCQM14OTnboB7ZjJ0RukjgxWW
	 HLYyjCOuQmFdHPh5M9XZJ5XJ4o8LnS2n+eY8q070=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Andrew Davis <afd@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 7.0 170/201] arm64: dts: ti: k3-am62a7-sk: Fix pin name in comment from M19 to N22
Date: Fri, 15 May 2026 17:49:48 +0200
Message-ID: <20260515154702.256924775@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 6ee0792d83d5c690205c350825a4c30746c0e0a2 upstream.

The pin for GPMC0_CLK.GPIO0_31 at address 0x000F407C is N22 and not M19.
Hence, fix the pin name in the comment to avoid confusion.

Fixes: 8f023012eb4a ("arm64: dts: ti: k3-am62a: Enable UHS mode support for SD cards")
Cc: stable@vger.kernel.org
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Andrew Davis <afd@ti.com>
Reviewed-by: Bryan Brattlof <bb@ti.com>
Link: https://patch.msgid.link/20260309045539.2070793-1-s-vadapalli@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -398,7 +398,7 @@
 
 	vddshv_sdio_pins_default: vddshv-sdio-default-pins {
 		pinctrl-single,pins = <
-			AM62AX_IOPAD(0x07c, PIN_OUTPUT, 7) /* (M19) GPMC0_CLK.GPIO0_31 */
+			AM62AX_IOPAD(0x07c, PIN_OUTPUT, 7) /* (N22) GPMC0_CLK.GPIO0_31 */
 		>;
 	};
 


