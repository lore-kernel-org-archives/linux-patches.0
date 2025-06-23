Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57F64409;
	Mon, 23 Jun 2025 22:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716041; cv=none; b=Vt6//qauLn/tsAGO5VN8uW/djfdrFd7Z2pegrwN0wpt2BimEG+bXxneRDM9SKnKwYiBCIVLi1W7DVTTn3RazCM+zozWTgU3i1WT4VOUH8Tf/bHnWFpfOAVpZzlGbLXtCdQT8TVP7Wv98xx7ElsJ7iCW02wcdpXarKPCA9J6N+sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716041; c=relaxed/simple;
	bh=PDAHWpl6tmUJZnW+NufPRCFDn7a1DRLZEXj5lQykQiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V89J9q6vBk4a46nBq/As2lcLUHsNPCRBK8Vux23a+dQzMkjsg5lMJ/GtRsP1bc/Bp5LMtSzrBF7KdEkv9OojkkKMVC/t9M/lTgo8YmVS9qmUFtpSTxI+FM/sRb0hMUZWCn3UgndWCxlUfxn48tAMkzU13tlOQs4/wftwK64gV8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Nnj601e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Nnj601e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C435C4CEED;
	Mon, 23 Jun 2025 22:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716041;
	bh=PDAHWpl6tmUJZnW+NufPRCFDn7a1DRLZEXj5lQykQiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Nnj601eiQjXTFPpyJ7A8Mp+jwP2FtFBnaLtqHyzlDULyz5X+CEnl4ArBIrkNgMqN
	 Mj8QzJ3Vs+Sup6dMsc7sly/3PI3Xd+ZqDzgaB8xJpGefd2NI5LagSTyyRx2kleb9QI
	 ycFop7Xpb84dEmh227Fq+uSzGm7dJKYDJOjJvZno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Hongbo Li <lihongbo22@huawei.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.15 498/592] erofs: remove unused trace event erofs_destroy_inode
Date: Mon, 23 Jun 2025 15:07:36 +0200
Message-ID: <20250623130712.278004445@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 30b58444807c93bffeaba7d776110f2a909d2f9a upstream.

The trace event `erofs_destroy_inode` was added but remains unused. This
unused event contributes approximately 5KB to the kernel module size.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Closes: https://lore.kernel.org/r/20250612224906.15000244@batman.local.home
Fixes: 13f06f48f7bf ("staging: erofs: support tracepoint")
Cc: stable@vger.kernel.org
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250617054056.3232365-1-hsiangkao@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/erofs.h |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/include/trace/events/erofs.h
+++ b/include/trace/events/erofs.h
@@ -211,24 +211,6 @@ TRACE_EVENT(erofs_map_blocks_exit,
 		  show_mflags(__entry->mflags), __entry->ret)
 );
 
-TRACE_EVENT(erofs_destroy_inode,
-	TP_PROTO(struct inode *inode),
-
-	TP_ARGS(inode),
-
-	TP_STRUCT__entry(
-		__field(	dev_t,		dev		)
-		__field(	erofs_nid_t,	nid		)
-	),
-
-	TP_fast_assign(
-		__entry->dev	= inode->i_sb->s_dev;
-		__entry->nid	= EROFS_I(inode)->nid;
-	),
-
-	TP_printk("dev = (%d,%d), nid = %llu", show_dev_nid(__entry))
-);
-
 #endif /* _TRACE_EROFS_H */
 
  /* This part must be outside protection */


