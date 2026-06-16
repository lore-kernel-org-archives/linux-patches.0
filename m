Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1808318EDA;
	Tue, 16 Jun 2026 19:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636795; cv=none; b=O5PwfQM/dhFV0pZYDJe0Qgxit/fRtmh/IDFeX/t+KQYekUL34Nl++Op+7YsMC0IBzLp//8J3toXoNtYBq9ZQeBVioDRyxm9vVz+3GrKSF20q9Xjl/RBYzauukdCB7QNs7p/ODHC10SujdAbtQamWbfEvVK1ugvvFpQyMlIQ4ukc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636795; c=relaxed/simple;
	bh=dznjdTaXvRjQHgsk3lvUKscWT/E65AOSA1Hc2BAHrVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aS3OQT96XlKwoUV/h/4HqH4vAyaPTBf18HtoTG1saG328h4fBrH2Hy20EsYCt9sU3ldKncDISiXC7Indy9G/RaNKhbJIS+EM0bchhhDT/6aSFEsp7sUTy5hXi18d/eFQwnZ9jnZBKxv8bgpYLKEegiRk982qLcJGjjtf3b4aAkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeG28oln; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeG28oln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747D11F000E9;
	Tue, 16 Jun 2026 19:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636794;
	bh=O1NCyZls8LahDNZp8nbrd8deLxrjJwwjKCpRrOasBiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jeG28olnCi79GRF4QCojZLkNUCT420snZSA7I5U+zf+zbC4bYAX7zGosG4F6rTDx7
	 lNvb2KPxIu78V2WPek1M3+99arFmGUKq0g+9aHx+0HDUeTV1TNn96OA1rDlW75kZPm
	 AmDCcHpsA/DQYsvSRM2uil2BG/yj72hn+n+SYRmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prasanna S <prasanna.s@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 306/342] serial: qcom-geni: fix UART_RX_PAR_EN bit position
Date: Tue, 16 Jun 2026 20:30:02 +0530
Message-ID: <20260616145102.705725575@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prasanna S <prasanna.s@oss.qualcomm.com>

[ Upstream commit ca2584d841b69391ffc4144840563d2e1a0018df ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -43,7 +43,7 @@
 #define TX_STOP_BIT_LEN_2		2
 
 /* SE_UART_RX_TRANS_CFG */
-#define UART_RX_PAR_EN			BIT(3)
+#define UART_RX_PAR_EN			BIT(4)
 
 /* SE_UART_RX_WORD_LEN */
 #define RX_WORD_LEN_MASK		GENMASK(9, 0)


