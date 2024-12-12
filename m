Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1D7211493;
	Thu, 12 Dec 2024 17:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025689; cv=none; b=FgAkSiYYBx6CKnNps/ctCfGdRF6pifM1uUWLMXHL//xE8W//SI+zGS7wVzObcEOyy+QRx9e73Q3Dmj8NoRE20tl3i0UQ21xZq+WWoGX0fUDMzd0gUEdsU9j7f8dTEcExeDDbeNMehJ/CUSL9sb26jmYsrJ6s5Iii04AuS1eR17U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025689; c=relaxed/simple;
	bh=LnlGGBA2UaKw/PalTZC4qRXdqZOZTzAz4vheBKX6VTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wx/wcm22DhPEyYIGv2SYWjHK56ub2zsxNP5Z5sNB4ct+bN2sRbhLbTwgx3xXZIo9zmU/wvJ/t198LVlb82vJ8a9G9xB76P1yJiNTAMYM3LCB1byS/ZtPz+XE9rOiIwFdnAo0EYRz2gFGpQIZbkuuh1dkDKVdwvUH6MmIjonMhzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PY0GYnNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PY0GYnNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31083C4CED1;
	Thu, 12 Dec 2024 17:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025689;
	bh=LnlGGBA2UaKw/PalTZC4qRXdqZOZTzAz4vheBKX6VTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PY0GYnNY4r0RUuR4NCAuZvjliKifsKExwiXrgiSPO4Terj2g0w50QO2i+p6MVdCDv
	 NgPEZWi98oAPMZmLABoL0m1nJgyRF3owGNhLcRlR3s6/mj9+fdkiK61cBsAGka8plI
	 GEaSKbKQCQ2Nyy+iaOpFmR329ftRwaVh4RZXQYsE=
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
Subject: [PATCH 5.4 255/321] ocfs2: update seq_file index in ocfs2_dlm_seq_next
Date: Thu, 12 Dec 2024 16:02:53 +0100
Message-ID: <20241212144240.040057008@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3101,6 +3101,7 @@ static void *ocfs2_dlm_seq_next(struct s
 	struct ocfs2_lock_res *iter = v;
 	struct ocfs2_lock_res *dummy = &priv->p_iter_res;
 
+	(*pos)++;
 	spin_lock(&ocfs2_dlm_tracking_lock);
 	iter = ocfs2_dlm_next_res(iter, priv);
 	list_del_init(&dummy->l_debug_list);


