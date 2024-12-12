Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A638621E0BC;
	Thu, 12 Dec 2024 15:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018040; cv=none; b=kGO6Jm6va9vMoW5EgfJDkFbByYZJNCtFLZ3pEwet5S6Hk3mf/QlNC9/IKdzDvcs6KaBc8yGn5XdnrEG1kBwcn60PTma6D3SCplTxvMyjSpV5ClDkntLDizSDP225nVbtOC4ifVZjmmS04r5Cc/gTWtc5hX7xP+qzrEuMHQrlRaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018040; c=relaxed/simple;
	bh=cD3cyBqrGP9uTZ8A/PxTAF25RmyB1ZfxaT2X6IupUC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8hwVoC+54Gz80VGPmfZSPbYQpeh/rKV03yQx6wqnceuecUs6LdlmyPfsPSsVUN9lpCodq0jhATnzcQR04fvFGv42kjXM2CZOqBxNFTw0fT6WlNo0VU2Wtm1W3qMZVnr7l/7pNuXRBARocU/hViJPzH1bm8B7irEYjn23f+mTTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJmTX8VB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJmTX8VB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DA1C4CED4;
	Thu, 12 Dec 2024 15:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018040;
	bh=cD3cyBqrGP9uTZ8A/PxTAF25RmyB1ZfxaT2X6IupUC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJmTX8VBirzHYGzrQ7Rec6jVbNYQFfHyH6ukKi699VNdRZ8IYrV4zXVyDhjMYSXXd
	 fI/mU3JcOqd06lMhFCIMmXIs4E9QqUl7BVOLi5Ct3rqUz6iP7oa68YsOjHtX9CyNV9
	 5fDQ71w80yvH1XVaWkVlTNX/GOM2kRSH95LGBTXc=
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
Subject: [PATCH 6.6 180/356] ocfs2: update seq_file index in ocfs2_dlm_seq_next
Date: Thu, 12 Dec 2024 15:58:19 +0100
Message-ID: <20241212144251.742854427@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3110,6 +3110,7 @@ static void *ocfs2_dlm_seq_next(struct s
 	struct ocfs2_lock_res *iter = v;
 	struct ocfs2_lock_res *dummy = &priv->p_iter_res;
 
+	(*pos)++;
 	spin_lock(&ocfs2_dlm_tracking_lock);
 	iter = ocfs2_dlm_next_res(iter, priv);
 	list_del_init(&dummy->l_debug_list);


