Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3621422A7FA;
	Thu, 12 Dec 2024 17:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023235; cv=none; b=mq1cg4pykTiWNg3MasliOuRX6mJNx5UyCadSlceExaRJQq0OmMFi+BF8qGLdKIbpX/3K0AiOEDNOx6pr6+J441I/bVUUCBSsUMxP+bhGsojjaxpMhz9A5nx2gLsrLRglFpiMzAr7h81UwLjsBSevJQRGQq9sdJhrgDSvIWM5fGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023235; c=relaxed/simple;
	bh=jVqOU+R72Z/FfK5G0//xhb08Hru5DmBqwec881aW/NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQZSxnEcBR9aZqHMAcNZe/eZqQh8xZhiB7kPlUaEIb3mYcmJxdvC/FDA22gYEjpuBcxkd+kKd/iga4nfcw3ScBdI1384Vg9KGQ6+sSFB88vBypa6gHd2vNZqSODmV5EOHYxvpKrXh7FjCo6MQOMjJzMkRePoWzpnUtOh+MLOAa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4uuzCOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4uuzCOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B06EC4CECE;
	Thu, 12 Dec 2024 17:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023234;
	bh=jVqOU+R72Z/FfK5G0//xhb08Hru5DmBqwec881aW/NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4uuzCORmWRDX1bUst86T9VqMwmOafigv3exLPU28kKk9uXvnE5cfnIevMb/1wYNQ
	 zQeWRmIB+4gnjStgZ7vyImq/QWsuvclSrKBW0xZiZNWl1L3rBoTZKjsV3BTrMxHjzE
	 QoQNdvkiIimtq7KNhvdBfUTyohmm7sozovRC3xRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wengang Wang <wen.gang.wang@oracle.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 467/565] ocfs2: update seq_file index in ocfs2_dlm_seq_next
Date: Thu, 12 Dec 2024 16:01:02 +0100
Message-ID: <20241212144330.196932763@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wengang Wang <wen.gang.wang@oracle.com>

commit 914eec5e980171bc128e7e24f7a22aa1d803570e upstream.

The following INFO level message was seen:

seq_file: buggy .next function ocfs2_dlm_seq_next [ocfs2] did not
update position index

Fix:
Update *pos (so m->index) to make seq_read_iter happy though the index its
self makes no sense to ocfs2_dlm_seq_next.

Link: https://lkml.kernel.org/r/20241119174500.9198-1-wen.gang.wang@oracle.com
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/dlmglue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3108,6 +3108,7 @@ static void *ocfs2_dlm_seq_next(struct s
 	struct ocfs2_lock_res *iter = v;
 	struct ocfs2_lock_res *dummy = &priv->p_iter_res;
 
+	(*pos)++;
 	spin_lock(&ocfs2_dlm_tracking_lock);
 	iter = ocfs2_dlm_next_res(iter, priv);
 	list_del_init(&dummy->l_debug_list);


