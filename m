Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0E02E3AF1;
	Sun,  7 Jun 2026 10:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829718; cv=none; b=XSD+oB2dFkzS2maelf0Ol5WW6dqPknUcVZMyiv4QKRTlbTAMscV8A0CD/jFZ7qeiojL8IR+ZTUx36RmH9l2DBpQUsJrv0n2xEvt9Rke6MqBsZVjJ3cvxu5xpB1qqKUvGW/uo5M0OyJ4ff6iJEfIjSChOd+924gMa4Xwi6dEzexE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829718; c=relaxed/simple;
	bh=FivL6qlLbynzZ2aKKoJyurNMCWyB48vIfB7UOcMog90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sETVy5yxPRxK3Grll2h1b1InurcSQtPimC0PLWU+vleQGBomqTsTk3pSViscf41s8tWj27oB3K9zZMGgpXM7l2NN8JI6Zsm+BRdNhLg/i+HkZkyTef6BSQlgIoFnWSCiVoNZMrnmRfgJWDuVsm0t2OjGg68RJAQCu70xXGuZq+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNdyK6hV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNdyK6hV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810AE1F00893;
	Sun,  7 Jun 2026 10:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829717;
	bh=E0qFlOuJMgbDNlddjrF1xhMfloIwpzzKW4JDJ/Dj05o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SNdyK6hVoSNFL/U4FrETdABQ0KXFBq94WLF43IoNhQtIGceByIcTUpaBaVw8tW9Ac
	 cpXD4VTEIG/isYYK5j+O64cO1Ptf2dyrKx6uf+PqVQFytIFHAo7rOymBU81a2iMCm9
	 +l6RUGe1eMzJJxQkDOstp9RL2A7kZeHCeeja0iXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prasanna S <prasanna.s@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH 6.12 248/307] serial: qcom-geni: fix UART_RX_PAR_EN bit position
Date: Sun,  7 Jun 2026 12:00:45 +0200
Message-ID: <20260607095736.803721391@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
@@ -46,7 +46,7 @@
 #define TX_STOP_BIT_LEN_2		2
 
 /* SE_UART_RX_TRANS_CFG */
-#define UART_RX_PAR_EN			BIT(3)
+#define UART_RX_PAR_EN			BIT(4)
 
 /* SE_UART_RX_WORD_LEN */
 #define RX_WORD_LEN_MASK		GENMASK(9, 0)


