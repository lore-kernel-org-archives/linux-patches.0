Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062290;
	b=VHnACiLL+jAsfG2hPhZAJebMbWQWayJ6qOPrvHsl/wt2hqqBJVrFM9CqL5FfM2KJ0mjw
	 nOR4BqSbc9/pbBKjpQgyLGCrorBLckAap3k/oVIVyIM2xqZvpBo/WE19mhwILk9JXAkYP
	 OgLGORvHQdDX0c+/YteCcVopEhTwr6Uhxa02Y+fAvOzMuvhkPCH4jfwjL3K3EcjlrGP7H
	 6LwpcL8R4uSDhYppKatdLIrSGcwrB31EX7AHvRXMrl0Ry5onOmxWA5ncbeasTc0khPgs9
	 wMVBPUMs4Z2SeuxuvGzX5469LMJP9XXkOMY16XaJmkOCLTtAovybvqcMEcQeXvdUKFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FOK+AW0w6rZ0bo9sI61LUWH+fOaNsztd4YU0VgrW8HM=;
	b=pM6FwdvIElDgSv0AxZIN0YCQlMRbhWzgrrHCcEwybqtu0XN5db7mWQbYL/W7EFjpfuN2
	 cO58FbbcfhwhNVO9kjpoN/olmDdwvzHMPq3bw/6COs2ISDLg0jViTujPMr7N+YdWHV1DG
	 6cTykQrv4184LGJtBTj5Nw/9wUy01/mA2XgbBLSESnN7ZdefPha1+7b9VnaxSFYoIF6Hs
	 uXRCHr+ITGoOhnpDDvz6LLv/c1/F0TFCg1WCkhpSRqCnTLx/JpiYfXlg+eI+vn+p8Jd5/
	 h41O91e1whgzL0CIOUI/OxKJrfcwG5p8tbEf04xnlLMGy23V/SAceCL3WIS+t/OPkFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=subJqXBO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD9E606D816;
	Sat,  7 Nov 2026 14:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=subJqXBO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7021F0089F;
	Sat,  7 Nov 2026 14:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062290;
	bh=FOK+AW0w6rZ0bo9sI61LUWH+fOaNsztd4YU0VgrW8HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=subJqXBO5s6J+74iCIPPjad21npoETLmCdf+LHL2XvYKgq7MJXM4Y+xxbZgg9S2Zf
	 gyTRr25UfARQVgjkonJCa49yKxJUaU09u/U+f3QYpFgX0UI1TTqFNFkuvNNvKGnmXm
	 NpjDJl7zanRrxC/pJIO8zRE0zhapM+41n2bkZWIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1227/1536] mailbox: qcom-ipcc: Guard against NULL con_priv in send_data()
Date: Sat,  7 Nov 2026 08:54:03 -0500
Message-ID: <20261107135032.220652775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6465c444dfd3d..9e7c82c7af0a4 100644
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



