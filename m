Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8576296BDF;
	Tue, 26 Aug 2025 11:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207113; cv=none; b=lSzr6MEJJqzOEsYJ2SXOU1kbhHNveo1FIZgZ4D34mkapW2lgmbOAddK5gqtNMY2V73FUQZ6zQVjP8fkn0d+K6PmR+YiLhadzbD8gh2Qzq47bw2tJn59Pog6ZZos6C2xWK1wc3ss7oAdIwVCu3kNWcHnvsaSsvwROomZNE/Axffc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207113; c=relaxed/simple;
	bh=6Moach80SfYFhqa+D3+lVM65WiwKpwIRW5cnqWskXoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7nLystFDmfOY6j7DlX8qJWAgmNYC+d0RrXW6uigCKXa3q0LhaPI/5xn/ROM5RHA9755ZNN2T1ldcTJtJ9+LN/5UYltpdpEJ9WQRO2gMr1mtyiNiEmOb0QotFNsYAN5wefseisBl5o9SZICy2DUY1bAuMyL8ZIGnYssK1WehSc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AE6gNtUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AE6gNtUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375D8C4CEF1;
	Tue, 26 Aug 2025 11:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207113;
	bh=6Moach80SfYFhqa+D3+lVM65WiwKpwIRW5cnqWskXoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AE6gNtUc0stPFF3CJaJ2iuVwhlGjYeETrxNsbxX6dviAq/Iri+edn1ZpKBa/u5TgU
	 D/u9HJaD6708cRaVXCGUyt+Ju0g5fne5djSZvcYzbqpinULf8WacvN2nQvA++qiZdz
	 zb8kInvwV/SSEbW2eTzo0sf2mVxt6fOmYBw185CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hong Guan <hguan@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.16 056/457] arm64: dts: ti: k3-am62a7-sk: fix pinmux for main_uart1
Date: Tue, 26 Aug 2025 13:05:40 +0200
Message-ID: <20250826110938.740031260@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hong Guan <hguan@ti.com>

commit 8e44ac61abaae56fc6eb537a04ed78b458c5b984 upstream.

main_uart1 reserved for TIFS firmware traces is routed to the
onboard FT4232 via a FET switch which is connected to pin A21 and
B21 of the SoC and not E17 and C17. Fix it.

Fixes: cf39ff15cc01a ("arm64: dts: ti: k3-am62a7-sk: Describe main_uart1 and wkup_uart")
Cc: stable@vger.kernel.org
Signed-off-by: Hong Guan <hguan@ti.com>
[bb@ti.com: expanded commit message]
Signed-off-by: Bryan Brattlof <bb@ti.com>
Link: https://lore.kernel.org/r/20250707-uart-fixes-v1-1-8164147218b0@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -301,8 +301,8 @@
 
 	main_uart1_pins_default: main-uart1-default-pins {
 		pinctrl-single,pins = <
-			AM62AX_IOPAD(0x01e8, PIN_INPUT, 1) /* (C17) I2C1_SCL.UART1_RXD */
-			AM62AX_IOPAD(0x01ec, PIN_OUTPUT, 1) /* (E17) I2C1_SDA.UART1_TXD */
+			AM62AX_IOPAD(0x01ac, PIN_INPUT, 2) /* (B21) MCASP0_AFSR.UART1_RXD */
+			AM62AX_IOPAD(0x01b0, PIN_OUTPUT, 2) /* (A21) MCASP0_ACLKR.UART1_TXD */
 			AM62AX_IOPAD(0x0194, PIN_INPUT, 2) /* (C19) MCASP0_AXR3.UART1_CTSn */
 			AM62AX_IOPAD(0x0198, PIN_OUTPUT, 2) /* (B19) MCASP0_AXR2.UART1_RTSn */
 		>;


