Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063270;
	b=rNCuZ80MKiB3YYthkGYn0RawN9bM0SEj4cLRnh8/Azpq6ygNS7FN7vNwHcIyiiQ1eoCA
	 pJZquteUbxrltJyeEzpS8BupedK92kmTWhDejkhPg9X9jFSnZw6/J+6wtks28V4oR9sDe
	 rLJJ8oL3vJbuLP2BRp+BICRIiEQXX11vdj65JxrEa7xDYSSikan1fR7ys7ssLVUy5V+YK
	 mO73BpFB8Xp7d0zJ7UWmhH9g/uf7c9PA7I2zDLKm+r9ob8w8PykpOp+6Xe77XzJgfay98
	 RkeKGa/vOUFU0HMRG9QzVQ8tC0rqrLEjWN3EcR8wwEHtg8Yli5UyNIA7UjyHoyg/2+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Satmh9fhl1p82OefBhEEqvRUVMxS2O58VB86XLzgcs=;
	b=nAti4dSOZkzCXUvZnMrCmLfybo7NmPznC5N61OOsmm8rM9GQETsHWiKYTY4l5WTqi+Xw
	 yd7tGSBOYQMOXl2PKM2xtHTclpn4HNpVJxk0mdJOZqOAKXrs9PAbpsQHNtYUAwRCBL5Xs
	 GmvQcYq4hRNpKYmif48yP0DAJfBBj6DN4/Ipb5N4JExBvJYRWQhbytyh4iqeyKJQiBeFo
	 Zm48cAc2BfbAmKvQPVhNcslsNfBF3sB3keshbR/NdNRjPlbBznpFBDUu4V0rDzZxGpf1W
	 O/rUVsOVpbWwDLdjFknctBiw2PuPpaascqMZg16b5q/+3mMIQVgWERxyIjTyu0tFYaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mokR9tju;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D62A606A332;
	Sat,  7 Nov 2026 14:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mokR9tju
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3DA1F0089F;
	Sat,  7 Nov 2026 14:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063270;
	bh=1Satmh9fhl1p82OefBhEEqvRUVMxS2O58VB86XLzgcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mokR9tju+gAtu1gCqRVZpGlO7rOeZ5g03fmU0iT8Uw7fUjjQquE9Mv2PXXnOBp5lA
	 QIM3sIYXx1MOUr4wmEcv6EJCVfganflfkxmogLGp83n7vdO5drs+BX1RRzEVoVmY5u
	 mQWCcqLszV997TgYsOFTk4EN1RIjBs48nfpBqWMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 467/869] mailbox: qcom-ipcc: Guard against NULL con_priv in send_data()
Date: Sat,  7 Nov 2026 08:52:29 -0500
Message-ID: <20261107134909.483795648@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dead907aa7a28..b0b4e40d9202a 100644
--- a/drivers/mailbox/qcom-ipcc.c
+++ b/drivers/mailbox/qcom-ipcc.c
@@ -10,6 +10,7 @@
 #include <linux/mailbox_controller.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/spinlock.h>
 
 #include <dt-bindings/mailbox/qcom-ipcc.h>
 
@@ -151,6 +152,9 @@ static int qcom_ipcc_mbox_send_data(struct mbox_chan *chan, void *data)
 	struct qcom_ipcc_chan_info *mchan = chan->con_priv;
 	u32 hwirq;
 
+	if (!mchan)
+		return -EINVAL;
+
 	hwirq = qcom_ipcc_get_hwirq(mchan->client_id, mchan->signal_id);
 	writel(hwirq, ipcc->base + IPCC_REG_SEND_ID);
 
@@ -159,6 +163,8 @@ static int qcom_ipcc_mbox_send_data(struct mbox_chan *chan, void *data)
 
 static void qcom_ipcc_mbox_shutdown(struct mbox_chan *chan)
 {
+	guard(spinlock_irqsave)(&chan->lock);
+
 	chan->con_priv = NULL;
 }
 
-- 
2.53.0



