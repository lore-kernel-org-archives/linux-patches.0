Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058482;
	b=0XwZ+2vF3BXoYPuC1SgJXTcgYwGT2CC7+cCopzus365vJw9nU3wWCsohymL3YUQ9UQeM
	 8N5hSKa+5+KHkTqLwF8jhHJEav23NYgzght59Q9bUvqIz6ZGhaHuhvDdU9PsuVOOCTzg6
	 63R5FAnMrltuRT6DndZtucvj0b3SOIXuOgby+FTUjAZolzCNySWQ9o13gf3uTjDi3gC69
	 XEGVmWQ3pJ6OdFSzzr0Hqjr08u6MYN/mFrBPgS+u95FbUg9nP9xF6VfdVj7bIPk6BciLy
	 +zeMlLUET2t/K0VmgmBc8pkDjgwn2ySWqP+Oc//H7Bwk1Un6lhKlfDBt1IbPy2/qO1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6WeObIYHOxHvLqu0IzHI8elt7qu9/VzEqbo6YRZp5b0=;
	b=Bi5IeLzCFSMtBg7JufE4fLKDH/a0wWW8h+cq44CWvVW22cEGXPgypd3qxNRWRQBDRN9a
	 XuhnAUpbUsBRbRA2yGCLBbL4C50BwVslzm2IT17M96mkXvenZ2YZwUZEn22pN/cClc/0F
	 BnL4sfYsT6Q4E0hOZP2ngK/xXXVNtZjixOVS+ZK02RiDsnGNNxgqXiSQGlRJDbe/aytHt
	 Bu01LZ+v/zULzIHzAk/z0eCIATZlHbdcvYQFlMve5KzJKdexbjPA6n8fiaPPg8u+D9dIq
	 Y/kIr3aIDBkBwdUXA/vWSEuXsAyiHET2RLJIQlYobjQilEhL8v3ImAFo264grIV5HbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ODuzqUF0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EB4606A326;
	Thu, 19 Nov 2026 03:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ODuzqUF0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D8C1F000C4;
	Thu, 19 Nov 2026 03:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058482;
	bh=6WeObIYHOxHvLqu0IzHI8elt7qu9/VzEqbo6YRZp5b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODuzqUF0lJmhJ+IAiuXdVyR+ACb8Y0/P47XMNilOiadQ0MRdClvYqdTcGuB9hIpdC
	 veR2w4GHxbL+xa6snRReIFtGCQEkdU+94HsXKok9NOgKgNH4Im7ZpIGHxnOvjz7Oux
	 9vV31DbcXdQM/waTKrrncdJw09KjKCjEcJbDyLJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0502/1848] mailbox: qcom-ipcc: Guard against NULL con_priv in send_data()
Date: Wed, 18 Nov 2026 15:42:20 +0100
Message-ID: <20261118145935.835161525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 584700cd15855..2b048ea1afcff 100644
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



