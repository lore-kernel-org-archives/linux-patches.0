Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D1F29CE9;
	Tue, 21 Jul 2026 21:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669072; cv=none; b=kZj2QL5Oi6CQzyueouvqfQ/Z0rD8LmNIufsbR7TDMGwdY09Pi0yzNki0I2Qum1xmLvw1MzueXE41/oVmEhfPvbpbGyT5kvPLzJ66KCmZAJwuznGIoZqQHFiozrhmmDU+T7B1bbw4C3c0T4T2wnwuds682UE3kjCHN+QRN9LfEKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669072; c=relaxed/simple;
	bh=9PkN98+gTQR4Xf9zG1Wz3BLJ9XYmkI5rQy62SvNA/Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j40lZMO5SpVjgxKLP+FWujoOS6AAhE/ETztD3ureQ83p2/jMlcbxIwwZQEM8lPzFij2Zg20shrgtHZqP7d+YyAFgdwMTTLyOVBgTPVrfilEEYqLzexHQsxwR5tzA0AIgjev4nUeMi4JXbYV0o5aZNYaN9n9x21hEPOrQdlNsMDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4Hi6R9s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4Hi6R9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5D21F000E9;
	Tue, 21 Jul 2026 21:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669071;
	bh=nU4QSCUJ073ed8ajYbwMbGHtgNeAbfvaXKujPx71OBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m4Hi6R9sWGwK79OTa9adgFopfHhVMpcI0pDiS9O8vxK3opl7bIFohT7oFo7Qa4h4X
	 hJhLfhc1AOQHR2a8CrQ1+ulzupRVJnHGxrwLAzz8RWVw3boYpd6/agwi98Rs7yN4rK
	 CbVTWwN70Qi1qYpJMtHh2aMyop5LY5tLwS7t/FFg=
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
Subject: [PATCH 6.1 0415/1067] vduse: Requeue failed read to send_list head
Date: Tue, 21 Jul 2026 17:16:56 +0200
Message-ID: <20260721152433.909512614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index abc35be6e0df9e..075f5853bb4d7d 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -182,6 +182,12 @@ static void vduse_enqueue_msg(struct list_head *head,
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
@@ -342,7 +348,7 @@ static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_iter *to)
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



