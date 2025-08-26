Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4507D239573;
	Tue, 26 Aug 2025 11:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208340; cv=none; b=qfnD/tFTGBNJBU38um4tBDEpLvqyKNVXkhEyhDL1rBm68PHy7mGZQn1pThUAyw7wpE/PV6/rUddy2KlWEkR6Qj1QXpNaeHT4jjWSNCxYj0ekDaUE5LS1wLfW2GJNJqHWf+/Ne9UJ7NbA3L+NtuBRUF/ZGxHgKunmcblzSEgHoQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208340; c=relaxed/simple;
	bh=IpqoGeRaEG5cP/IQ9VMQVnmJdTz/F1GUx2SS1r6nCxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bICcGicJxYu9lE9uwf0166Dhy5Br/4zBhxvU39qjKH9Mpg5RJzo8nLx9RqXYbgvtokOSXyehLXVYuRXc2sd1MB73PZR/5QGgmLF8vahQvbJG9JdQGWjAZMTsDKbXDSKe2HS/p65ClwJuDtDj86UgILY3gJ4+DKUJHH1kr/FC/WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5BF3uo+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5BF3uo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF13BC4CEF1;
	Tue, 26 Aug 2025 11:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208340;
	bh=IpqoGeRaEG5cP/IQ9VMQVnmJdTz/F1GUx2SS1r6nCxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5BF3uo+h8yfP0pCItoP+wFcw1K7D8zR8sgpu9RKJ2VTI9jh08zQJzrL3kgE3N0fn
	 fOVXQPtOBj4qBCi/jwn5QHtPhVTBky7chTFwzyKg4heopWMSQFz1ezWy7V48dhUkUD
	 KEvI+a68EJw+naG1/zypbV1RapM0tZSJk2wjeO6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hong Guan <hguan@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.12 042/322] arm64: dts: ti: k3-am62a7-sk: fix pinmux for main_uart1
Date: Tue, 26 Aug 2025 13:07:37 +0200
Message-ID: <20250826110916.414963097@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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
@@ -259,8 +259,8 @@
 
 	main_uart1_pins_default: main-uart1-default-pins {
 		pinctrl-single,pins = <
-			AM62AX_IOPAD(0x01e8, PIN_INPUT, 1) /* (C17) I2C1_SCL.UART1_RXD */
-			AM62AX_IOPAD(0x01ec, PIN_OUTPUT, 1) /* (E17) I2C1_SDA.UART1_TXD */
+			AM62AX_IOPAD(0x01ac, PIN_INPUT, 2) /* (B21) MCASP0_AFSR.UART1_RXD */
+			AM62AX_IOPAD(0x01b0, PIN_OUTPUT, 2) /* (A21) MCASP0_ACLKR.UART1_TXD */
 			AM62AX_IOPAD(0x0194, PIN_INPUT, 2) /* (C19) MCASP0_AXR3.UART1_CTSn */
 			AM62AX_IOPAD(0x0198, PIN_OUTPUT, 2) /* (B19) MCASP0_AXR2.UART1_RTSn */
 		>;


