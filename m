Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045431;
	b=BL1ZpOpf2intrvAbpOzNKLPZXy6VArgS1WRqMlfwU5/0Sd6dqM+ti+wmNy2UYTVD++Hl
	 epYKhf7Bl+eJdRy0s6AE8vAxrmlrf/FZ0FIm8BBcZmjfBB6+HKEadpIMky2AQqZTUTtU3
	 FcMBwwt3AIedwBjodl4MW+hTC7aZyNWA0rbnxv5sZfeJ6EmfY6pJz++OZEHXSEQNssGTx
	 B3xVlspxq6ejC8qqjf+myZdSl5EBH8G11OwXwv1wDi3CVkLmcSHz50DEaNRpaTmzeTPyp
	 mVXxCitrVci7SayQEvTlwzdMkqvZx+LF6M+HTJVVfoAhKGeSvp0IqPBEgbUddqitiqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fqut/dyoWh+IBBRb55zDSWiXzqND2R8/hsEJr+yvsXc=;
	b=Q2sQbXXmIkJLbZpE60EzxNQ+/M/439hU6ezrzdwHQgcUPrJtukWJRr3agUuZfRWB+3ly
	 6JtMRny/UkMMaxHQ+MLtHdYI3nFpNrF3UyhOl+DlfGXhQRL4Xes4KW/PHQUKFSdMEquml
	 fPegRYlkwsKnSL/+1RnRXzejmhkMUFJ1fkxbZ2wEL+RjZThyuivhs10EaK+H5xNe9TWgU
	 D7B+6KGq28iMD2nGQSHKcgmBhc2j8a+I0/xKPc7VFE7t4Vgl0F9bkpUJoD153W9nu03lA
	 DGe4f77kkafnLBhopoPwx/US4MhVJxD/UdN6VcDSLxuulDqfpa9AdwmYZyZInVSr3wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zsAmpF0A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD16606A32F;
	Wed, 18 Nov 2026 23:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zsAmpF0A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF83D1F000C5;
	Wed, 18 Nov 2026 23:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045431;
	bh=fqut/dyoWh+IBBRb55zDSWiXzqND2R8/hsEJr+yvsXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zsAmpF0A0mUO3P4hvFRL5wBW4op/vVKXFcBAjlxNRILx/xa2RChw8/CIhEnvz6QYk
	 B4LRDVUwk2D1+ZAAa4BFB4dNVhR6zlSfd1UOAIDmuP75Iq7Lp4N/U3p+ncHyP0LlsD
	 vIh6MZTjGGeSwIhtC9DrqFujZwsCSssqhNC9Xu+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0920/2857] mailbox: qcom-ipcc: Guard against NULL con_priv in send_data()
Date: Wed, 18 Nov 2026 15:32:34 +0100
Message-ID: <20261118150234.706460066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



