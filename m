Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2E229CE7;
	Wed,  2 Oct 2024 13:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877192; cv=none; b=X+UynydR/fqXhFHBwgeCfgQj2cOvf95CKiCpkUDrUFvURmEglFnwyRrw5csVr4nq8CXYEBAzNc8tVKTUOWXXLxmbypm4is1Cru7lk5SCKy4+q/qB9OVbsYeMzhpLQ6MS3T5x8u62uhr2LADI+pZoYYg8WqApxX+OZDUE6rq9zrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877192; c=relaxed/simple;
	bh=4JKkBdW+y9YJdX69YZRKAP7w6DdPz1lZZ3bU5sC+iu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KY+TaMTUw68e4FtOetZuuvaQYhkcuN3kdDH94zmQIp4KvA5DYf9nsvaPnXeom9QuVLVIFyNiH1tVlAUv7aI9AUW3qKjCOYq6RhOAOF1GIGRchd+bJS1XnE+I/HCZnJHZDmraFeIDq8cwfOyRIxW+vCvaqqzOWDfqZPZzAyWCl3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5eDVA4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5eDVA4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4B5C4CEC2;
	Wed,  2 Oct 2024 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877191;
	bh=4JKkBdW+y9YJdX69YZRKAP7w6DdPz1lZZ3bU5sC+iu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5eDVA4g4Vc4uLkL028/bgCLypXOPWIp0f3PBperci4fwyLHz/fcqbfzHTyHvv8N7
	 tNCOSrDEI1D4bRVw76G9VHIWyt71s0d3tGvCRaCyI/OmGSfHF5DSX2MqH8ct0pStJy
	 MSrq7hvYX2CfL6L4I6JIo8fOngqF98C9SMghBxP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 665/695] soc: qcom: geni-se: add GP_LENGTH/IRQ_EN_SET/IRQ_EN_CLEAR registers
Date: Wed,  2 Oct 2024 15:01:03 +0200
Message-ID: <20241002125849.054115248@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit b03ffc76b83c1a7d058454efbcf1bf0e345ef1c2 ]

For UART devices the M_GP_LENGTH is the TX word count. For other
devices this is the transaction word count.

For UART devices the S_GP_LENGTH is the RX word count.

The IRQ_EN set/clear registers allow you to set or clear bits in the
IRQ_EN register without needing a read-modify-write.

Acked-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240610152420.v4.1.Ife7ced506aef1be3158712aa3ff34a006b973559@changeid
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240906131336.23625-4-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: cc4a0e5754a1 ("serial: qcom-geni: fix console corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/soc/qcom/geni-se.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/soc/qcom/geni-se.h b/include/linux/soc/qcom/geni-se.h
index 0f038a1a03309..c3bca9c0bf2cf 100644
--- a/include/linux/soc/qcom/geni-se.h
+++ b/include/linux/soc/qcom/geni-se.h
@@ -88,11 +88,15 @@ struct geni_se {
 #define SE_GENI_M_IRQ_STATUS		0x610
 #define SE_GENI_M_IRQ_EN		0x614
 #define SE_GENI_M_IRQ_CLEAR		0x618
+#define SE_GENI_M_IRQ_EN_SET		0x61c
+#define SE_GENI_M_IRQ_EN_CLEAR		0x620
 #define SE_GENI_S_CMD0			0x630
 #define SE_GENI_S_CMD_CTRL_REG		0x634
 #define SE_GENI_S_IRQ_STATUS		0x640
 #define SE_GENI_S_IRQ_EN		0x644
 #define SE_GENI_S_IRQ_CLEAR		0x648
+#define SE_GENI_S_IRQ_EN_SET		0x64c
+#define SE_GENI_S_IRQ_EN_CLEAR		0x650
 #define SE_GENI_TX_FIFOn		0x700
 #define SE_GENI_RX_FIFOn		0x780
 #define SE_GENI_TX_FIFO_STATUS		0x800
@@ -101,6 +105,8 @@ struct geni_se {
 #define SE_GENI_RX_WATERMARK_REG	0x810
 #define SE_GENI_RX_RFR_WATERMARK_REG	0x814
 #define SE_GENI_IOS			0x908
+#define SE_GENI_M_GP_LENGTH		0x910
+#define SE_GENI_S_GP_LENGTH		0x914
 #define SE_DMA_TX_IRQ_STAT		0xc40
 #define SE_DMA_TX_IRQ_CLR		0xc44
 #define SE_DMA_TX_FSM_RST		0xc58
@@ -234,6 +240,9 @@ struct geni_se {
 #define IO2_DATA_IN			BIT(1)
 #define RX_DATA_IN			BIT(0)
 
+/* SE_GENI_M_GP_LENGTH and SE_GENI_S_GP_LENGTH fields */
+#define GP_LENGTH			GENMASK(31, 0)
+
 /* SE_DMA_TX_IRQ_STAT Register fields */
 #define TX_DMA_DONE			BIT(0)
 #define TX_EOT				BIT(1)
-- 
2.43.0



