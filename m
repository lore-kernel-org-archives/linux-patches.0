Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCD621766D;
	Thu, 12 Dec 2024 15:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016531; cv=none; b=DsZ1gXTYKExoVA8StVT4Hi3nGzc1ojXSSybaQyYJHocYJpa8PWMOaB8ZxguLNWWSwXBL1BMHXhHss2VtyagFpSwoRdmCMirLqrrz4KiAVBWmfKRV46mSS5EbH2YFeO4QVVHoHWiVpowey5nTbJs+kNg01PK+N2etGC2BewBusX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016531; c=relaxed/simple;
	bh=6n7Ckx8U0DHzePhIjlpIdBCzie84j9ldr3eDvEL2T7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmDI9WWwUyu2YD/1QdOEyD1BVfUMnNOhZyrCxuWNYlLzuKR0oIpfWkWjKRs3foDswRcLrwQb0MlomszXE7KDBN0lRCyfiV5U5U7f3Y57VloeB+WM/rQ9SHE46XDyh0ngAhOyN8o3lsgrImbc1q/5nprtnWEpQzOX/NZTn2xSvDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/eDr63A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/eDr63A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947E8C4CECE;
	Thu, 12 Dec 2024 15:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016531;
	bh=6n7Ckx8U0DHzePhIjlpIdBCzie84j9ldr3eDvEL2T7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/eDr63A63Jt8h3kFqyaZ5XQkTECyr04vendWhhYDFDmkjCCWr7rirBZDxde5I2hw
	 fajXDcwW708AJfTAC8MQAJeI1xdK6hSl1b0ui+2Xha5cPaCIdnhSVTRVF0fAkzujFs
	 ydprWjRPUIWiUlQgh3JeMWnKGl+ugkZRC2CqoekY=
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
Subject: [PATCH 6.12 194/466] ocfs2: update seq_file index in ocfs2_dlm_seq_next
Date: Thu, 12 Dec 2024 15:56:03 +0100
Message-ID: <20241212144314.459361308@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


