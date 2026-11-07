Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064675;
	b=LJVgZRQ3ew3d4fk+dgmzXuzen+7rKJ2kfl4uQBkq8l1wzjaNwgIhECW8mzzw1aZF6Z6G
	 WWuHIGhkuKVte1fk/rJgpai730ewcZ0HZPqlUscZd8XlMx+vhlJVzQtwgbH2P0P6Y8Kly
	 9vFZzITQzkegz95dfgqRJqBJHu4KwdAu01aqau4A104ChWJ+mx9JfXlwqH8GzJpsza0aU
	 ofTvKfo7qYM8ukukijhkktojoEWvA6EsMrsu9lmulrekPQvHNowheHhocQNN+ccuPnYm7
	 XnSCnHLTWqXTIvdjd9axYC9sSgkTosAqsCZ7DHMKdEJyUYsl1wjlNNia+TeNhLJYQTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mTyXoW6b1Sas0aRSbPiawRIOnWQBbYbES8AFNDYYk6k=;
	b=Ax4RlT7FFmL/ND6pM/fw6Pgx1ZuWiNQi5bUliK9EX/gUf575OF65UW0N1lMfiW1Tchqu
	 DTHAvy/wFpX6IrVZWt9065Fa68d6Zc69sZ3E67qeGeQohkiyfhQXMx8V0dSY+Nx/K0a5a
	 UDBbxRmsmsaWJ+o2/2Hew0rbK+xtwK/MCv4P29g7EPwqgU27b280Jtppf7hjAXn6rE7N7
	 iuURVKDAMVfVrnNSTVPZLY5MWo7O9hhCJMowOWRVSDrHUfkHVmO6JmmiUX7qUWl/8DZUr
	 rq0MNK5ey2YvrSn/onuF5XGsTyBx8rOYu24e725J/LDIuD9+H+p6FoveNdqieI0AePg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hwts0Qbw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A784606A32F;
	Sat,  7 Nov 2026 15:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hwts0Qbw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDE91F008BD;
	Sat,  7 Nov 2026 15:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064674;
	bh=mTyXoW6b1Sas0aRSbPiawRIOnWQBbYbES8AFNDYYk6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hwts0QbwoXAgKcQSOBrYNhqC9zj3RC/v11sKNXqOhN5sAPI/zrLwrAG97eGhShnBI
	 NygAlApDLC6BysW90GOBhRXhUOdFdQAG09Izaqp4meGyMvZcl3z/k3yD7NHj0vP/hr
	 fk9zaU43g76L8MWixMdOl7bZJgz1F2LqF9YtQtXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Justin Chen <justin.chen@broadcom.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0633/1257] mailbox: bcm74110: Cap rx_svc_init_list growth to prevent PMC-induced OOM
Date: Sat,  7 Nov 2026 08:48:49 -0500
Message-ID: <20261107134956.771257260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit eb2ee504757674450a5e03e36e6b9340f064e599 ]

bcm74110_rx_push_init_msg() allocates a GFP_ATOMIC struct for every
BCM_MSG_SVC_INIT word received from the PMC co-processor and appends it
to rx_svc_init_list with no cap on list length.  The only consumers of
this list (bcm74110_rx_pop_init_msg_block / bcm74110_rx_flush_msg) are
called only during probe and at shutdown respectively; after probe
completes, PMC firmware can continuously inject BCM_MSG_SVC_INIT words,
exhausting GFP_ATOMIC reserves and causing a whole-device denial of
service.

Add BCM74110_INIT_MSG_MAX (16 entries) as the maximum list depth.
bcm74110_rx_push_init_msg() now checks the count under the existing
rx_svc_list_lock before allocating; if the cap is reached the message is
dropped and a rate-limited warning is emitted.  The new rx_svc_init_count
field is decremented by bcm74110_rx_pop_init_msg() on successful dequeue
and reset to zero by bcm74110_rx_flush_msg() on shutdown.

Fixes: 52436007b862 ("mailbox: Add support for bcm74110")
Cc: stable@vger.kernel.org
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Assisted-by: Anthropic:claude-sonnet-4.6 cursor
Signed-off-by: Danesh Petigara <danesh.petigara@broadcom.com>
Acked-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/bcm74110-mailbox.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mailbox/bcm74110-mailbox.c b/drivers/mailbox/bcm74110-mailbox.c
index c8709d5099121..bec138d76914d 100644
--- a/drivers/mailbox/bcm74110-mailbox.c
+++ b/drivers/mailbox/bcm74110-mailbox.c
@@ -97,6 +97,8 @@ struct bcm74110_mbox_chan {
 	int				type;
 };
 
+#define BCM74110_INIT_MSG_MAX		16
+
 struct bcm74110_mbox {
 	struct platform_device		*pdev;
 	void __iomem			*base;
@@ -105,6 +107,7 @@ struct bcm74110_mbox {
 	int				rx_chan;
 	int				rx_irq;
 	struct list_head		rx_svc_init_list;
+	unsigned int			rx_svc_init_count;
 	spinlock_t			rx_svc_list_lock;
 
 	struct mbox_controller		controller;
@@ -148,7 +151,15 @@ static void bcm74110_rx_push_init_msg(struct bcm74110_mbox *mbox, u32 val)
 	msg->msg = val;
 
 	spin_lock(&mbox->rx_svc_list_lock);
+	if (mbox->rx_svc_init_count >= BCM74110_INIT_MSG_MAX) {
+		spin_unlock(&mbox->rx_svc_list_lock);
+		kfree(msg);
+		dev_warn_ratelimited(&mbox->pdev->dev,
+				     "PMC INIT msg list full, dropping message\n");
+		return;
+	}
 	list_add_tail(&msg->list_entry, &mbox->rx_svc_init_list);
+	mbox->rx_svc_init_count++;
 	spin_unlock(&mbox->rx_svc_list_lock);
 }
 
@@ -225,6 +236,7 @@ static int bcm74110_rx_pop_init_msg(struct bcm74110_mbox *mbox, u32 func_type,
 				 list_entry) {
 		if (BCM_MSG_GET_FIELD(msg->msg, FUNC) == func_type) {
 			list_del(&msg->list_entry);
+			mbox->rx_svc_init_count--;
 			found = true;
 			break;
 		}
@@ -248,6 +260,7 @@ static void bcm74110_rx_flush_msg(struct bcm74110_mbox *mbox)
 
 	spin_lock_irqsave(&mbox->rx_svc_list_lock, flags);
 	list_splice_init(&mbox->rx_svc_init_list, &list_temp);
+	mbox->rx_svc_init_count = 0;
 	spin_unlock_irqrestore(&mbox->rx_svc_list_lock, flags);
 
 	list_for_each_entry_safe(msg, msg_tmp, &list_temp, list_entry) {
-- 
2.53.0



