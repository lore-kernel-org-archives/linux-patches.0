Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91393DD509;
	Tue, 16 Jun 2026 19:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636784; cv=none; b=anGYcQOwC54KP+2Ph6eEgHatSnESIhvZBKP/D5gNOLWWMElcKXDTM7x237UeH0ASbi3WtonEnufZYMw7rHgtRF2Y1CgAmM4jZypSEFJbjxmUR506KJ8emKsqdq+swfE2Xu5ITONaL7s1Bo/oRl51ylZRJinGVOQdATj6HmwC82s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636784; c=relaxed/simple;
	bh=AOUncLR/w6OfoVxNnbiv1p4IcFIRu1oTT5q72+lRHCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3JvlwABnPqExdlHgFNmPrAxMM+mTuX2dORiA+CbFv2SpTcU/OpEFB6EfRHDkWJkx9AKBAyrpUI2tL7SLvJ0vGOVPbfX/KnYz2FhOOI4h5ckITgFb5d+CFfn5Prs98EmejajulcIhvZYIrXnRogt9WSIpoj1Kq4PU2mErubeWWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxu/k6KU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxu/k6KU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F8B1F000E9;
	Tue, 16 Jun 2026 19:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636783;
	bh=iSlrHEWf7l2WfHbOSUwrCqxiUyccM2SVzKQgsZ6y8Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yxu/k6KUN6d/yj97jXMR1LYSoqFuBLedMTHft7D7dMdslI0VkOyqkDemSOqXTyklV
	 HW6b0u4NNQBjnHxo1yHaa/3ka/RJV3Y4OPMf/eOTa0h+yWSLMtEZrXCOUM51gDlv8d
	 q1/hsFwNupaisQnGqQrWiNv6Liyac49ThfG6YUDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 304/342] tty: serial: qcom-geni-serial: remove unused symbols
Date: Tue, 16 Jun 2026 20:30:00 +0530
Message-ID: <20260616145102.606804343@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 68c6bd92c86cbc4937834c79963b27c77ee3bf51 ]

Drop all unused symbols from the driver.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20221229155030.418800-4-brgl@bgdev.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: ca2584d841b6 ("serial: qcom-geni: fix UART_RX_PAR_EN bit position")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -38,20 +38,11 @@
 #define UART_TX_PAR_EN		BIT(0)
 #define UART_CTS_MASK		BIT(1)
 
-/* SE_UART_TX_WORD_LEN */
-#define TX_WORD_LEN_MSK		GENMASK(9, 0)
-
 /* SE_UART_TX_STOP_BIT_LEN */
-#define TX_STOP_BIT_LEN_MSK	GENMASK(23, 0)
 #define TX_STOP_BIT_LEN_1	0
-#define TX_STOP_BIT_LEN_1_5	1
 #define TX_STOP_BIT_LEN_2	2
 
-/* SE_UART_TX_TRANS_LEN */
-#define TX_TRANS_LEN_MSK	GENMASK(23, 0)
-
 /* SE_UART_RX_TRANS_CFG */
-#define UART_RX_INS_STATUS_BIT	BIT(2)
 #define UART_RX_PAR_EN		BIT(3)
 
 /* SE_UART_RX_WORD_LEN */
@@ -62,12 +53,9 @@
 
 /* SE_UART_TX_PARITY_CFG/RX_PARITY_CFG */
 #define PAR_CALC_EN		BIT(0)
-#define PAR_MODE_MSK		GENMASK(2, 1)
-#define PAR_MODE_SHFT		1
 #define PAR_EVEN		0x00
 #define PAR_ODD			0x01
 #define PAR_SPACE		0x10
-#define PAR_MARK		0x11
 
 /* SE_UART_MANUAL_RFR register fields */
 #define UART_MANUAL_RFR_EN	BIT(31)
@@ -76,11 +64,8 @@
 
 /* UART M_CMD OP codes */
 #define UART_START_TX		0x1
-#define UART_START_BREAK	0x4
-#define UART_STOP_BREAK		0x5
 /* UART S_CMD OP codes */
 #define UART_START_READ		0x1
-#define UART_PARAM		0x1
 
 #define UART_OVERSAMPLING	32
 #define STALE_TIMEOUT		16


