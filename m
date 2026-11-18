Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052579;
	b=Q1bruG11/dMFQZbMLmMHsOQImk4zjKj4Jz1ymQ9f2bG7Q7NWLZf0SaSz5LvxjYsMiwd+
	 H4aZzBvkALZBl9mqeCoSDe8d2unCNQrRBtpLQ/XaclCJ2cUEdTCLRC/Ng7PAxKzqIJ4E3
	 6wmeOQrUcnPSALif18yLsHIb51qnyVrUOwLoAPXc7wnecYiWK6BgMfpxj9KY4gSthLvQd
	 JZYqU8eltYvpTHUCzbJ8Qubhzc8/sx2kLEEQunkVdBh6JPItPIseKynEn+JtDb4W9qewC
	 h16LhSx+/uQEyXSMEOhQXO7EqqBEnIxSUJo0yb6YA6BuE5TIWmEazHRNrN/NAkEa9Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tlq6falsu4p25eF2rHDzfLHqj6CqJX+UtA6BMRCKc90=;
	b=IwL2P2AKQEuciSPReLy7R/3heZEiaM+z8PtFX1aGxbiq9IsdpZfKSvfiYd8AxzMYmYgr
	 mgRb/N6iEnoitm3aYfgmBRCdDd99yC0ia9lbTkorT6NKO0PSOdfnSM2E75KPS9xOZzxa0
	 R9RtECdPMgrTymddqY3llOyFRYNdAqnMJdOUBhd6oMwy6lIRBYcDwmbuUItjtukWYgpmx
	 EIvfS7mbd0o/nX5GnbT8pxuJMana2vFyHd/nUaNIqaVfDmhs+MijXwxM0yNkx2QjtG7xK
	 +mppXpJtyo6p3V7ZLGiOfLwhiLj6wNnSoKSx56yxbvvNADRO8RrojOL75ayGNfXOVNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GskiRwAw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6A9606A32C;
	Thu, 19 Nov 2026 01:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GskiRwAw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2038A1F000C7;
	Thu, 19 Nov 2026 01:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052579;
	bh=Tlq6falsu4p25eF2rHDzfLHqj6CqJX+UtA6BMRCKc90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GskiRwAwcwK/Ygg2/HSzeZ97xsULioiWuFXEq0a7CTSew05qu+ne0nGAvSuPh4mpz
	 2wBPfNebB0RpwwQg+hPQxHGuNInFQlFYHdf3dywOOD1yi8mDYEYTwEM/c9E59MKxsX
	 eYv5sTKYe9hfdnlDXS5S+sWvLaXBSZ9jLrwrkb28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0613/2214] mailbox: qcom-ipcc: Guard against NULL con_priv in send_data()
Date: Wed, 18 Nov 2026 15:38:09 +0100
Message-ID: <20261118150035.904270392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f1d4f4679b17b..06377bc70a742 100644
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



