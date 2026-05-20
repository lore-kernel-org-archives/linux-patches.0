Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759CD36CE19;
	Wed, 20 May 2026 18:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300760; cv=none; b=E3PUAcvR4sCkqMSFKwZA7X0Prn1T0haY+LFuERFv4B4XAED5AJ5cByyINjX3t2mw6xdo9KZg+hhk6LJS2IIEcGEtIrGCPLTjDZZuLR0DSHKMDJJ/Z+f4sU81qtBHMIE9Ik6j5e3DfNdW7SKNAbRhzU8rwcQb0XOHY3bnicdiQiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300760; c=relaxed/simple;
	bh=Q9hqnZcVpoNl6GFQx7fvFtlPBE76pJyToSK0Fo0DOAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvChZCi1qxKzNapUlAmsDe0EUGUoAGVxpa1nT9NcESllPGzzBUqX8k2E3piG6CtMvDjlDh0L6Pw3v2eWZHdipgWYjnJjqFBsioLN6MXuX0EZoRkYtZa5cH1jvKEw0SlflgEl34r2BBaZNm/uRklbhNqXc+23VXtV07ANgFigs7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVCP9vDC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVCP9vDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE771F000E9;
	Wed, 20 May 2026 18:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300759;
	bh=/2nXaxPmfeN+/buAntvx/yPrW2tDvHVijHdujUUQ9WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KVCP9vDCVl2eNK+r0lO1pBO4s11AtAPFXEBmRR4XeMRYssR+zSBUEDgEcCXqUPdIp
	 ldD37XlySlUvenn/IqfOInZ+Url/D7MmzRlYeKlQNingZyEf5hWvarTsvu34Xl9g3t
	 ekm9NGPiLNeePYBkjEon/D8RIAJTM6fexLm0rHSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/666] arm64: dts: ti: k3-am62-verdin: Fix SPI_1 GPIO CS pinctrl label
Date: Wed, 20 May 2026 18:18:26 +0200
Message-ID: <20260520162117.609089428@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7c90a4e488a4a..893834c8803bf 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -272,7 +272,7 @@ AM62X_IOPAD(0x0018, PIN_INPUT, 7) /* (F24) OSPI0_D3.GPIO0_6 */ /* SODIMM 62 */
 	};
 
 	/* Verdin SPI_1 CS as GPIO */
-	pinctrl_qspi1_io4_gpio: main-gpio0-7-default-pins {
+	pinctrl_spi1_cs_gpio: main-gpio0-7-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x001c, PIN_INPUT, 7) /* (J23) OSPI0_D4.GPIO0_7 */ /* SODIMM 202 */
 		>;
-- 
2.53.0



