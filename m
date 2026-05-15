Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AFD3F926E;
	Fri, 15 May 2026 16:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862168; cv=none; b=eJfuskleN+RDBx6CGwOw6Gma4w3SM0yBjUUqVFfa95B3HSSCh0WDaqVue5qmJZQ56a5m+jSA3j0vWR52Mq+++oQmRJ53XhVNc4Iehrb+NLr+CRmU3AGSWV24LZ9u6GRFfpSoBZoVuZmHECHRwQsoc8x/GM41qeAYK9hbWq5wpKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862168; c=relaxed/simple;
	bh=YsrxYZMRXPK+Ryn6yjo63W42sg/TzEfumVi/hqHyxsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSWVIR6JSJajBgeFEYYE1KI+zGQbd42k0QDFKu1lsjeTtSwrtYlNB/WtB7OqERVDfeYVRIsKhNi/TWlwCP/xMIoDECzz76savcNUZM1XBy6viCJCWFy5PcLranxdL7Ne6rZUnluzVrO7L+s5ZhtuwnunswxSwP6zVy1gW8Q+fjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6MIZ1qG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6MIZ1qG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7611BC2BCB0;
	Fri, 15 May 2026 16:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862167;
	bh=YsrxYZMRXPK+Ryn6yjo63W42sg/TzEfumVi/hqHyxsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w6MIZ1qGE6zeSm5ESWuaJAg/TfQVQl1yef2IMoC8yTyzCZjqd8c4yHlo9IuyUY/iu
	 PzXaGp/ToLcEAS/DAg97oH2y6IZNlenSlzvZRkiZyug9oJjNvAKb4vEy6QUYVMIOzK
	 57Zv+oJylX7Z9o7+NxWuVZIrP1FuWOThpZhLxof8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Andrew Davis <afd@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.18 134/188] arm64: dts: ti: k3-am62a7-sk: Fix pin name in comment from M19 to N22
Date: Fri, 15 May 2026 17:49:11 +0200
Message-ID: <20260515154700.236594780@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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
@@ -394,7 +394,7 @@
 
 	vddshv_sdio_pins_default: vddshv-sdio-default-pins {
 		pinctrl-single,pins = <
-			AM62AX_IOPAD(0x07c, PIN_OUTPUT, 7) /* (M19) GPMC0_CLK.GPIO0_31 */
+			AM62AX_IOPAD(0x07c, PIN_OUTPUT, 7) /* (N22) GPMC0_CLK.GPIO0_31 */
 		>;
 	};
 


