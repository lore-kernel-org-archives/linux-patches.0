Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A07287510;
	Sun,  7 Jun 2026 10:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829705; cv=none; b=enn3LfH3QSbg6xOwwLBfKrv5oebnonhoyHm552H9J15cOXRJq3zM7E3fYXdZSoYXSn0jv3eLiwV7clbwAK4TYm6o7lPEditNiG32ZgzftiGzS3rWW496lNvZk7rIqWUEBlFw3vbdPMhjOhKgb5qsC3dII/6llCNO7LJWC5Fh0tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829705; c=relaxed/simple;
	bh=rF7XJTvWTKC5hfMfFvzibXRcL+ZvzwkRW++1vCaY2ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSPZdasdiTaLohi1hlCH/2Rc2NdBAoJ257iO/AqfPUcsfwGJ1jaaQNx/9WTw37YvgR+e2dki/V5Tbpn2/kHSty1upzUl82C+3XN5JgS0aYauEFgqPrtSNXAY6V3WCCg3+BCU6PYt3iBxnolNRUGsdBK3ha6vxdAiF4EHubOSXIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKHvn6fH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKHvn6fH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432831F00893;
	Sun,  7 Jun 2026 10:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829703;
	bh=yxuZPJ2h9tO2Gi05M8TJsY3ss4ht1qMLko4ELEXTuZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKHvn6fHqex7TRbtvH2hNgXzGfN3xRbBv9Cqu99XYnGdfiJoram/frEnrYk6B3bu2
	 IVSwliJCsZaItmr/I1hPNBZbTWfvyBclmIb6ey3ZtuiLYD3qEWVKXKW40UpoJv8MvD
	 HCeZPRCQ7MCGBut+8HthPEH7yS8hLBr4gnzxA2AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prasanna S <prasanna.s@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH 7.0 297/332] serial: qcom-geni: fix UART_RX_PAR_EN bit position
Date: Sun,  7 Jun 2026 12:01:06 +0200
Message-ID: <20260607095738.969670834@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

From: Prasanna S <prasanna.s@oss.qualcomm.com>

commit ca2584d841b69391ffc4144840563d2e1a0018df upstream.

UART_RX_PAR_EN is incorrectly defined as bit 3, which triggers false
framing errors (S_GP_IRQ_1_EN) and causes received data to be dropped
when parity is enabled and the parity bit is 0.

Define UART_RX_PAR_EN as bit 4 of the SE_UART_RX_TRANS_CFG register, as
specified in the reference manual.

Fixes: c4f528795d1a ("tty: serial: msm_geni_serial: Add serial driver support for GENI based QUP")
Cc: stable <stable@kernel.org>
Signed-off-by: Prasanna S <prasanna.s@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260428-serial-bit-correct-v1-1-9131ad5b97d8@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -50,7 +50,7 @@
 #define TX_STOP_BIT_LEN_2		2
 
 /* SE_UART_RX_TRANS_CFG */
-#define UART_RX_PAR_EN			BIT(3)
+#define UART_RX_PAR_EN			BIT(4)
 
 /* SE_UART_RX_WORD_LEN */
 #define RX_WORD_LEN_MASK		GENMASK(9, 0)


