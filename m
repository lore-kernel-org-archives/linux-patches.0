Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047234;
	b=ZSTWv/2sP3CTPQ9Czl28MaOkRreww5isAkhGSYLE2AJJqNzM+h4ZE9PsBYRNy84UWst2
	 AkBBcdklYlNFxKQYNyKDlUwoa5lHwdQDdm9Fdr+F0ennddyx1sf05ygZE/x8sUNDo+QIs
	 HeTQraqbFL2qXnIVFckZF9J3n7rSksYV1X18nE+ydRQ252QHQbzw6TFs4uZkef/rqHt9n
	 cW6mp2xhcaZqzw2VnpTyOTF429Xe7VAGAv/ZM189SifV/Jwy1LvdUiK7z7eyIEchN/KDn
	 s1GTK9R541KWfwVUvPhAGAdUhWnLsikdGgEETz0T3K4lXTfI26Y2fY2pyJpHCPhd0Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q8TL9zNagRK/scHogcHJkACq70kbKkVcd9iHqHcPtaQ=;
	b=IWSv90AZUGxfOemd7K6AOhNPExLnC0FCn6gyoMtF/YJqhRHusi6eJkGvTbVJ8qRTFrc5
	 bonSfca4tet5sNNjPoc1Qst0IA/jSKs51+hHbxiUg1S7S2WkAVSdKSsrix9oW0+M+b1XK
	 zXiej6ZzM+573kQHtX+DIY2ByBxuu7IWIYSSkEqK5RaB40BOYvvua8aR+t0BX90oqY+Kz
	 vSyvkhLgnvNix1g99RsOnXaLYuz8Z87gGT4lXT1o1p3nESNnEMRunt0pYnCRBVSYBpKaK
	 Wqj8i+s1oL+aG+yUnZKJuP5ik9jaoe8B1gb2t5SW0V040/5TagHdrIZGLQ1KLGA0jMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNoFiDyy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F837606A325;
	Thu, 19 Nov 2026 00:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNoFiDyy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770831F000C4;
	Thu, 19 Nov 2026 00:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047234;
	bh=q8TL9zNagRK/scHogcHJkACq70kbKkVcd9iHqHcPtaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jNoFiDyyDTQfmk/7kBmUUMmQbtWFUgXtIedSxLqSbyksi+F12RMkX78LAQ+SBrR16
	 wwRT8dwuHY+OrNCvWFVHh6MhxEtNvzUqO9mxGg4DzWOYvlu/NUuaZNA7xmF5YGhaV9
	 7CeblyrfxvXqgwBxbcCQRVYxBmqdu2uecaZU/vPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1567/2857] nvmet: force reconnect when number of queue changes
Date: Wed, 18 Nov 2026 15:43:21 +0100
Message-ID: <20261118150257.806311575@linuxfoundation.org>
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

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 2be2cd5287152a6284b45244b6e5c2f7e0a218bd ]

In order to test queue number changes we need to make sure that the
host reconnects. Because only when the host disconnects from the
target the number of queues are allowed to change according the spec.

The initial idea was to disable and re-enable the ports and have the
host wait until the KATO timer expires, triggering error
recovery. Though the host would see a DNR reply when trying to
reconnect. Because of the DNR bit the connection is dropped
completely. There is no point in trying to reconnect with the same
parameters according the spec.

We can force to reconnect the host is by deleting all controllers. The
host will observe any newly posted request to fail and thus starts the
error recovery but this time without the DNR bit set.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Chaitanya Kulkarni  <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 9f426f140511 ("nvmet: take subsys->lock while force-reconnecting in nvmet_subsys_attr_qid_max_store()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index c966d1e3a1354..8c12de188e992 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1318,6 +1318,8 @@ static ssize_t nvmet_subsys_attr_qid_max_show(struct config_item *item,
 static ssize_t nvmet_subsys_attr_qid_max_store(struct config_item *item,
 					       const char *page, size_t cnt)
 {
+	struct nvmet_subsys *subsys = to_subsys(item);
+	struct nvmet_ctrl *ctrl;
 	u16 qid_max;
 
 	if (sscanf(page, "%hu\n", &qid_max) != 1)
@@ -1327,8 +1329,13 @@ static ssize_t nvmet_subsys_attr_qid_max_store(struct config_item *item,
 		return -EINVAL;
 
 	down_write(&nvmet_config_sem);
-	to_subsys(item)->max_qid = qid_max;
+	subsys->max_qid = qid_max;
+
+	/* Force reconnect */
+	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry)
+		ctrl->ops->delete_ctrl(ctrl);
 	up_write(&nvmet_config_sem);
+
 	return cnt;
 }
 CONFIGFS_ATTR(nvmet_subsys_, attr_qid_max);
-- 
2.53.0



