Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036522;
	b=fRf+L2+kGm0d6ElT3uvZFa5uUT4eY0CYB/lt8h14w4WAh3B/K3J1dpXYHgBEicx49IF0
	 VtGerX9nzaKuRrwDe24c1404LGsP0PgkpR4u1Vsz5dVEBKtIfv1VFYEucz9q9+DZcM+up
	 zARVCdW7iLiJ1wPW+HYcCuuwvq6o1UGc7ZjVM++al8S4+jH/WaRwgjuEd7E0jdp8f2RMr
	 sXOLReIZgi7B+N8XNDrd+TxaGbkfH8xmD0/eVMGqCO7XQFJdX7CNXvXy/H8juwYcmPNp5
	 XYfeZ8nfibEoYkfEVyCkYnOSf0Jvn1+3/PobPVJMIUYbpbS27G69pWp3Hghvo0g2WFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OU4CrfPCTqb5f9W3Ul91wRmvggACK/YhpOEbSimTNkw=;
	b=pLrc5i0SOfinRZ194IOLJ7BZe5ARptgPuyrch5WuFE7GXYqapOXQhIwqRvERygWd54ky
	 n53/IZqqVdvw/xwFmNUESdUT3a2L4XP/8vvy1C6J0tibJKKK4MH1nixxqYs39t+b0DFE0
	 GK6C0Z61JYdA3XuX2rChDKJavaddEx5E0rIhdp4l18e7zFmWapUZOBKXYCg8WlKqiU9aq
	 EEBNuio5e7LQOO4SFdZh0KsrDaHTue7kMevVOXI+a7/lY8QRgIMbOLqfCfCXrF8VV3CSw
	 OYM2sAQSMSbnj76N+A0CsNt938CWx8VlHewhbOK+sGJIz4zARHYG+S4KLdhzLOPd68A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OfPo8IQ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB28E60A2630;
	Wed, 18 Nov 2026 21:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OfPo8IQ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FCE1F000CA;
	Wed, 18 Nov 2026 21:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036522;
	bh=OU4CrfPCTqb5f9W3Ul91wRmvggACK/YhpOEbSimTNkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OfPo8IQ87oowzzl3dKjUaG/R7EXkzFKw8R3ZCw+9uSDTZV2wjIZfMQLkzSPWKkoMU
	 Kkke6RgJ9xrm5JhYj/vzUou7SW5XPRb7Z5jzrsDO9dJMSyncNuzwNvejzH0+zhT26N
	 qH328zVtARPTFTKuq9eZpQmZeAH3jKTASyhFMuLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1063/3318] mailbox: qcom-ipcc: Guard against NULL con_priv in send_data()
Date: Wed, 18 Nov 2026 15:28:05 +0100
Message-ID: <20261118150351.849047273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>

[ Upstream commit 7b3cc361b5942ac600f38e5dff7aed009be34964 ]

qcom_ipcc_mbox_shutdown() clears chan->con_priv with no locking.
qcom_ipcc_mbox_send_data() dereferences the same field without
checking for NULL first, so a send racing a concurrent shutdown can
crash:

  mchan = chan->con_priv;
  ...
  hwirq = qcom_ipcc_get_hwirq(mchan->client_id, mchan->signal_id);

Add the same NULL guard mbox_send_message() already uses for
chan->cl, and bail out before dereferencing a cleared con_priv.

To close the remaining race where send_data() reads con_priv a moment
before a concurrent shutdown clears it, acquire the spinlock in
qcom_ipcc_mbox_shutdown() using the modern guard(spinlock_irqsave)
primitive before setting con_priv to NULL.

Fixes: d6fbfdbc1274 ("mailbox: qcom-ipcc: Fix IPCC mbox channel exhaustion")
Cc: stable@vger.kernel.org
Signed-off-by: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/qcom-ipcc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mailbox/qcom-ipcc.c b/drivers/mailbox/qcom-ipcc.c
index 6fbf98ddb73e4..c1e0d7ef0053c 100644
--- a/drivers/mailbox/qcom-ipcc.c
+++ b/drivers/mailbox/qcom-ipcc.c
@@ -10,6 +10,7 @@
 #include <linux/mailbox_controller.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/spinlock.h>
 
 #include <dt-bindings/mailbox/qcom-ipcc.h>
 
@@ -149,6 +150,9 @@ static int qcom_ipcc_mbox_send_data(struct mbox_chan *chan, void *data)
 	struct qcom_ipcc_chan_info *mchan = chan->con_priv;
 	u32 hwirq;
 
+	if (!mchan)
+		return -EINVAL;
+
 	hwirq = qcom_ipcc_get_hwirq(mchan->client_id, mchan->signal_id);
 	writel(hwirq, ipcc->base + IPCC_REG_SEND_ID);
 
@@ -157,6 +161,8 @@ static int qcom_ipcc_mbox_send_data(struct mbox_chan *chan, void *data)
 
 static void qcom_ipcc_mbox_shutdown(struct mbox_chan *chan)
 {
+	guard(spinlock_irqsave)(&chan->lock);
+
 	chan->con_priv = NULL;
 }
 
-- 
2.53.0



