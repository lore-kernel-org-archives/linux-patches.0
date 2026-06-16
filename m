Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787C833A9EB;
	Tue, 16 Jun 2026 16:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628929; cv=none; b=LI4hPAO13GSSb/N3HJgapCZv2tBXkLVF+TzBkQMZxBqDfai3VOc70qtbTDRKiuz3lVYeA3FDLB1IcVwfdqR7kDl0R2Z5OSDXaj4sn2uSPC7Wj7oii7yvUekRIXvkDnF7arPl4H/ZSDDZqXebHuaRxUGfEC9AL0ElzfgdmRCZidY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628929; c=relaxed/simple;
	bh=akuoQxAOaJzmBHENIr75QEzP0eFM2oX7W2TuVpCKO44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZngyNK26iFZ9w+WyYe2pdHiwQ5Q7cL8RMedVqSqFZH6i/TJmzDZPCJAvf1hsZRyJxaK9Q973cnMVSxJ0i6dW5iuiBHNlz5UZFn8ySQnfipRMSO1YawcFxMMCwNAnXbY9uN3YtS/0KFPLCxHLTbNZWGKi0/KlQvJXZX9X/+ktpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+0iK5kH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+0iK5kH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E46D1F000E9;
	Tue, 16 Jun 2026 16:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628928;
	bh=+FajqBbg2jdvwdgWrTQUGG2jCOlvcjgZQGs/ZNa9OTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+0iK5kHpnmECsQNgPUPNPCV6zz+twy8Eqe/YuOwjJ7GBhIg3EXJWnGg/cS8Pk7rK
	 w1As0o1DaHRUx1SKPPHAjmr7RAd1F2ZRClYR+uOAZ04ph0znZFcDnlExn6UDNOxpm+
	 E2Ft/Tej0CDg0sSaqmwHeyawgTlx/lhJPsZf75lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prasanna S <prasanna.s@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH 6.6 181/452] serial: qcom-geni: fix UART_RX_PAR_EN bit position
Date: Tue, 16 Jun 2026 20:26:48 +0530
Message-ID: <20260616145127.361676328@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


