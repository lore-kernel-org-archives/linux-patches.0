Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA88424C07D;
	Wed,  5 Mar 2025 18:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197777; cv=none; b=j/USgODjudWSdLaI5i70LmehBBRFpRF8HHpxauV2KqU7IoSO0w8G09DCTfTi+yM3/lCIS8A6naqj86O87YjDVR1uAAhFLag5s2lrAGTm3RZY86AbHLB9bC+ynaJkDf3aBElak6AQT//hr6N70eN7gpR0GIIznzshtMpiMmlGli4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197777; c=relaxed/simple;
	bh=CANcjSlNqJwqQuD4YMXgtWhVnBdfPz7GQ6JfYlVgPGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RYbJkp69wNznFDErELEAR/VK85vyIqXHcjRrZ15nx3Yh8RlX7PadEkQd7AxWey/2hvuVwe+taUS6jB3cRm6V1vjtpTvU1CnRV3n7bMsuJVU1rHI1f67fy2BGV0ADZPxymfInVDmjbaq0GsoicdvKeKT97l+73z77zQwGza8Pd6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pP8Rzi/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pP8Rzi/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DD5C4CED1;
	Wed,  5 Mar 2025 18:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197776;
	bh=CANcjSlNqJwqQuD4YMXgtWhVnBdfPz7GQ6JfYlVgPGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pP8Rzi/Aotivq7jTAJPUAmMIEEuwZii5HufTTZnPXKAdxyKGZ4Ou1HKQtcuwLpWLr
	 Ce5raA8QQGXR7IA6phpU2gTdqBgK+jcx3zOkSUyUz2zm6pL8sHHE7+BvIKZ2fN4YQ/
	 SjEjP4tahdm+2sVY+LRAhkUU8X8uCmyY6OUew0U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Lukasz Czechowski <lukasz.czechowski@thaumatec.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.6 096/142] arm64: dts: rockchip: Disable DMA for uart5 on px30-ringneck
Date: Wed,  5 Mar 2025 18:48:35 +0100
Message-ID: <20250305174504.190725123@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Czechowski <lukasz.czechowski@thaumatec.com>

commit 5ae4dca718eacd0a56173a687a3736eb7e627c77 upstream.

UART controllers without flow control seem to behave unstable
in case DMA is enabled. The issues were indicated in the message:
https://lore.kernel.org/linux-arm-kernel/CAMdYzYpXtMocCtCpZLU_xuWmOp2Ja_v0Aj0e6YFNRA-yV7u14g@mail.gmail.com/
In case of PX30-uQ7 Ringneck SoM, it was noticed that after couple
of hours of UART communication, the CPU stall was occurring,
leading to the system becoming unresponsive.
After disabling the DMA, extensive UART communication tests for
up to two weeks were performed, and no issues were further
observed.
The flow control pins for uart5 are not available on PX30-uQ7
Ringneck, as configured by pinctrl-0, so the DMA nodes were
removed on SoM dtsi.

Cc: stable@vger.kernel.org
Fixes: c484cf93f61b ("arm64: dts: rockchip: add PX30-µQ7 (Ringneck) SoM with Haikou baseboard")
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
Link: https://lore.kernel.org/r/20250121125604.3115235-3-lukasz.czechowski@thaumatec.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
[ conflict resolution due to missing (cosmetic) backport of
  4eee627ea59304cdd66c5d4194ef13486a6c44fc]
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
@@ -367,6 +367,11 @@
 	status = "okay";
 };
 
+&uart5 {
+	/delete-property/ dmas;
+	/delete-property/ dma-names;
+};
+
 /* Mule UCAN */
 &usb_host0_ehci {
 	status = "okay";


