Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6291446C4CD;
	Tue, 21 Jul 2026 15:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648538; cv=none; b=pDteXPq2qNr7q6ZXCR3oI3MDNBxJl7O4BLZS2GKeZmmccjfuGowE32/+69WFpUQ/QP3NWypsm4T8fgONT7pMPoy0juFKyXc1pKq+8r4G4hQEpPmfyrTuEcBnD2FeFZDntZStgYGrvIlw6oTr9yyLEPlHLmqIFloqZ5pnKSpkFOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648538; c=relaxed/simple;
	bh=c5S8tu2WAzgF2RTQTSMINnCfavnN0EHgUTQBzche4hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncPNtwJQSv73SZTBsaWR2SGsV+Incw2WPZX3FBHXYbHAFUv3LeDHpxrY46eCjz4KM8LAxIiigq7aSWKJpsiromYH4NlZ0dqPMLBoEzBpYchvQx3O2RhhmaDRxxDcacd/P02L3gF3F4fBSgGvR6Ucq08rCCSGu0RfpV/sqDa8Cxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LjoM8TQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LjoM8TQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5831F000E9;
	Tue, 21 Jul 2026 15:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648537;
	bh=M1/hglKthV5YuD7/1FN3p7kvOg5CqLv9H6kW1aJNcZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LjoM8TQ6MHbFx+oaTj6n1EjClIvKZUom1KfSsOamG4f3WZsFljbIItvhYoqClX1p
	 te2zQLFmdOC6OFVLNY/qqaARw/TzYWIGuxg5/WgPTf9eV38+re47c2W2Ayp5qDki/b
	 lDB5SMqFNxsskEvkeIGcEY/s5wDmacTfJcjiTiS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0238/2077] arm64: dts: freescale: imx95-verdin-ivy: fix RS485 RTS polarity
Date: Tue, 21 Jul 2026 16:58:31 +0200
Message-ID: <20260721152558.290552360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 9f004f2afded2870838c0ae4906c2fa9307286bb ]

Fix the RS485 functionality, the RS485 RTS signal is active high on Ivy.

Fixes: f33a1f9a942c ("arm64: dts: freescale: imx95-verdin: Add Ivy carrier board")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95-verdin-ivy.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95-verdin-ivy.dtsi b/arch/arm64/boot/dts/freescale/imx95-verdin-ivy.dtsi
index 8337c8b25f050a..ff31f7c48cfb42 100644
--- a/arch/arm64/boot/dts/freescale/imx95-verdin-ivy.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95-verdin-ivy.dtsi
@@ -452,7 +452,6 @@ &lpuart7 {
 
 /* Verdin UART_2, through RS485 transceiver */
 &lpuart8 {
-	rs485-rts-active-low;
 	rs485-rx-during-tx;
 	linux,rs485-enabled-at-boot-time;
 
-- 
2.53.0



