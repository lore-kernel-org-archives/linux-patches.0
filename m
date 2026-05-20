Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE55931F9BE;
	Wed, 20 May 2026 16:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295744; cv=none; b=jwSouqb22LJc2Pk6T+bNNjGOLCnsNT3Nc1Wp2VxdZ7d9AAKWNrzHX133xJ1NOtVxZvjtIvV6b9eD4y3KF0b5rJVpkDuDVw0ZTrFG+v1hnylXqtmiOjf6jCUD2eUlQvb934qDiEVeVj9K9AXyvxYK0y5eyGf5Sid4D7uDoYN826E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295744; c=relaxed/simple;
	bh=Gh4gz/jwq/PlYIPSR6RnazzlegeDrGgEFsoivgt/kbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVQF8QahL9Eh+aDgE7qiX5dO0pLtPU2jJJjovBaKc49/HbBl475nkTSRzBmT/Nd/bnzpiKW+RkbwYBy56oXqKk7zqmjmBHeRBPSTtqz47uPQxcRnHj+gRXdf1c+39bofuRdF3HdrBKP0fPcRIUD9K+h1cfA1a5bTUFtToy8+UiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPV0rHBJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPV0rHBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AB51F000E9;
	Wed, 20 May 2026 16:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295742;
	bh=3UccQxQEWTyNBJmIRvHZMBEg5gKYiPmqUcnfLPm2noo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JPV0rHBJPeocT0NyW/fOWpm7uvfaau+Jhq10t90AU+3D3VTdK2QWuRCtm5NNYa/Sh
	 BJVvcRdJ3nhpUPm5/0v03eY9piyOMIG/Iv239rK46usWlKL3uHd1IXOJ+3M+UcSXcB
	 P7aWoFyFUd+M/KFvVHi4zeJHZqnSLcQPg304qsGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0535/1146] arm64: dts: ti: k3-am62-verdin: Fix SPI_1 GPIO CS pinctrl label
Date: Wed, 20 May 2026 18:13:05 +0200
Message-ID: <20260520162200.288619027@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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
index 09840a3b9fe75..20dbfa3001eac 100644
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



