Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3961384CC4;
	Tue, 21 Jul 2026 19:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662059; cv=none; b=N9W7V3zXvCZO4cnTPSXEQ+TFC1RKqTTKOBUGI5WUi2YRefD18QR/0vpWDvUjd0sJQRX2u6Nxn6gj70ozLvdZwvPufMYNPTvQgKduxy2Rt1QEuxuqrOR7YRgGB7T0ks05Ds1rEU+92Ic0i973NKUobaEZrD0rCPw5lgvu8v7U15c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662059; c=relaxed/simple;
	bh=qkYpKkwr26Ds6REWSWzNpB0GLFB0i18nyVEDM1E3eGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tZwLBTJbGk+am4oESmqlQHBXObAXYdXQ7A70MZrTQl9sycZ9+0CrOfFW5M3uvSFEI20UczWTLWCfMLfxsxgEya+tyejdR64xamBDK14BM7t8nqvLi4pQ/ojc2l3YgGbQRFBvbICJp+CVjBa4g3Ur7ZuGKkzFVOK+pzTv6h1tXwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iYCXFKI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iYCXFKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9E81F00A3A;
	Tue, 21 Jul 2026 19:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662058;
	bh=V5esT3iBRjt8ptXgMwGRvUMVE3AsgzAbnM9flLnAWzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2iYCXFKIrDGQDdXv+L84M/BE6Ve0CTV8qZvR6gsheVNYiKWAAjxivI82IcPMcV0X1
	 dxaLDbBKlhgvi4LO35sYsMZvd2D+VvORnWbbQ+XTFNUyXmDvS/xauX0t698ea0x9Gp
	 2oDqEJRpYubuiXNbwXCR8DJCMO6J4FL4rXIIcF0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Xie Yongji <xieyongji@bytedance.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0301/1276] vduse: Requeue failed read to send_list head
Date: Tue, 21 Jul 2026 17:12:24 +0200
Message-ID: <20260721152452.831614765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

[ Upstream commit 373ec43ded742b2f3aecf14731ffe1a57f438f38 ]

When copy_to_iter() fails in vduse_dev_read_iter(), put the message back
at the head of send_list to preserve FIFO ordering and retry the oldest
pending request first.

Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
Reported-by: Michael S. Tsirkin <mst@redhat.com>
Suggested-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260226115550.1814-2-zhangtianci.1997@bytedance.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 2430e0d8fbd1d0..bb87a71547329b 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -193,6 +193,12 @@ static void vduse_enqueue_msg(struct list_head *head,
 	list_add_tail(&msg->list, head);
 }
 
+static void vduse_enqueue_msg_head(struct list_head *head,
+				   struct vduse_dev_msg *msg)
+{
+	list_add(&msg->list, head);
+}
+
 static void vduse_dev_broken(struct vduse_dev *dev)
 {
 	struct vduse_dev_msg *msg, *tmp;
@@ -353,7 +359,7 @@ static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	spin_lock(&dev->msg_lock);
 	if (ret != size) {
 		ret = -EFAULT;
-		vduse_enqueue_msg(&dev->send_list, msg);
+		vduse_enqueue_msg_head(&dev->send_list, msg);
 		goto unlock;
 	}
 	vduse_enqueue_msg(&dev->recv_list, msg);
-- 
2.53.0



