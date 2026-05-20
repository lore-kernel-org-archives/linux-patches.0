Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBC7359A6F;
	Wed, 20 May 2026 17:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298451; cv=none; b=F8hay8e7Q53+aApduU1hsH8jqw+iai088bhkOum+b2gT11b90+qaluL6+c1UPVDAPAKnkcH30C+aq3y6loVqRqdr7ikawrfAWAWwsKU5t+hhsKuICAGO/HNRfSnS6ZKDRLu4JiCLF8NZbkIuGdU67/CGsnGKMx8dk9N1KxRba50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298451; c=relaxed/simple;
	bh=2blPc1ADinzbRyzHQbUUR5y/vUVCRRRPnTKacpAal/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s46AhHhBfPOeMuyhDVTgCWtezbD5eYXYMASpuPsp5HTIwuO1zOJArBZHgWRV4f2dUwqLpoecWnstHt/5MXOMLt3zz0WKaS4lfNgL3x9BdOV9QH1hGZH86YVdpa4/5S7TXQyxu4QNOi52EBc9MZ7/quGEGrJV4kB8BHYRkcWJK/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCWQs94H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCWQs94H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDBB1F000E9;
	Wed, 20 May 2026 17:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298449;
	bh=1oRK0WZyene+DWcO2IBgQiz7kzGVBfGVRtalEgfqHXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fCWQs94HORqUMe47y50sQGeFg4nXiA5T57IuBzJUi5EVa00b+N/Wjb4lJJrPlseL2
	 PWoT7bJkqbTqUwdNugAihHMIb5CspuBcRR27AyXxuxeq1Izt6D+d9UnJv44h/o9EHZ
	 JY/fHr2CDLLhfob36zzi1D7c5S5Iog5acRtsmnPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 415/957] arm64: dts: ti: k3-am62-verdin: Fix SPI_1 GPIO CS pinctrl label
Date: Wed, 20 May 2026 18:14:58 +0200
Message-ID: <20260520162143.523100887@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 944dffaec1ef0f21c203728de77b5618ed70df6e ]

Fix SPI_1_CS GPIO pinmux label, this is spi1_cs, not qspi1_io4.

There are no user of this label yet, therefore this change does not
create any compatibility issue.

Fixes: fcb335934c51 ("arm64: dts: ti: verdin-am62: Improve spi1 chip-select pinctrl")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260324093705.26730-3-francesco@dolcini.it
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
index 796f2cedf5d62..059ec492a973e 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -278,7 +278,7 @@ AM62X_IOPAD(0x0018, PIN_INPUT, 7) /* (F24) OSPI0_D3.GPIO0_6 */ /* SODIMM 62 */
 	};
 
 	/* Verdin SPI_1 CS as GPIO */
-	pinctrl_qspi1_io4_gpio: main-gpio0-7-default-pins {
+	pinctrl_spi1_cs_gpio: main-gpio0-7-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x001c, PIN_INPUT, 7) /* (J23) OSPI0_D4.GPIO0_7 */ /* SODIMM 202 */
 		>;
-- 
2.53.0



