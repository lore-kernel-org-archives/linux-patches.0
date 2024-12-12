Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7612223E71;
	Thu, 12 Dec 2024 16:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021075; cv=none; b=mHXFERBqHOQGQXmUN48LoeTxWPDg8uTRN1K1j64CyhSCkgLSDn0c8Vr3LxH0kZSaUKyM3BQ+oexSuvJNkQU+69g2NF+HaqxfT9izAPOdyA1ZlDM1D0aIuoWDPS9vTSsu3xycE1MUQWC7HariH1XkXwhVTxRLiqvUFoUfOevaPpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021075; c=relaxed/simple;
	bh=6tQBPdLnzLEVE3OtmmEnh4AoyOh3rncfnA4SlkhFrsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YePVQtOi0FBjrOD3I65uqVq4YQU1hX3eJjNNo53Xx1XTqAxkZ7BEvbKk2Px9J6SxM6wvP7MeAEE2HirM7CMtwGik78HICZWjIser14uvK5Sdw0VK5DVCB4VCR0mEDGKifAYU6k4Cfh9xvdack7HC1EH1qrdfESBvSVExAie9p/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3NHK7w+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3NHK7w+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454E4C4CECE;
	Thu, 12 Dec 2024 16:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021075;
	bh=6tQBPdLnzLEVE3OtmmEnh4AoyOh3rncfnA4SlkhFrsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3NHK7w+fEB7Q3cukDBwJT+l5A8iCmgrEndHwwAPWqma0lpiqjvAigW/4U+FPTeZS
	 vX+xncrsjeb3h03NUCPxUf314bmM7LX7aEsyOZy1DAS5DjG8rfmAZPd6VEHb9VJzOC
	 Q6ONhPyMm8TqJonJIcWrKAvmzoQjHjkzMk/wyRfo=
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
Subject: [PATCH 6.1 638/772] ocfs2: update seq_file index in ocfs2_dlm_seq_next
Date: Thu, 12 Dec 2024 15:59:43 +0100
Message-ID: <20241212144416.296465704@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


