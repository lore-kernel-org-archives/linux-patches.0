Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613F84C74;
	Mon, 23 Jun 2025 22:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716115; cv=none; b=mzBC2kw8FCbReObs6bZm7ijPN3ai6/9u+IKLqfWLes9ZAYTvFmB1FNs63HNYiMFay3My4s/lswdk3HqY2WaTLlMtmZilpUyX99T87PNlzj2034nHijYEY/qls2FqnhAmTyLRUqxMwP7OtIdxOHq0pmmFCIJZynaKvUl4JQD9aLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716115; c=relaxed/simple;
	bh=nWn96qChYQi06BGy8JuRdCRmPnHT5lUbnTnYIIOJeps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INbdmfzeXZcUUudtsdO7HtH6A44CngX+ZpeYg4lNst0Z4LDR3H9zh8PL2tNLn1Y5IG6es27LE2/4rJFTyxiqmJbgHpmjQfIIdZHSUmE+woxBWYvHhHjD4Ud/K9DsSUYQAz/P8O3pJFXsYIkZi3cHKqstWBqT+3oKepOGMjQO+1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1QAJ5Og; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1QAJ5Og"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2A2C4CEEA;
	Mon, 23 Jun 2025 22:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716115;
	bh=nWn96qChYQi06BGy8JuRdCRmPnHT5lUbnTnYIIOJeps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1QAJ5OgzxObIWDTseDOQ3cGOKp6E5wRfBTyzsfdmCyzQUCm7qiMXVNud9J0K2Ly8
	 4dfuOd+0/6ITL6V6NKVC40Q9/i2Y+NUdqW25DDRHoBmRPYTszO8t/FwkuuVEVVQ//s
	 ap+SzISuePDmEEUn7srArCrIQSHc/MEba+xrWmB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Hongbo Li <lihongbo22@huawei.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.6 241/290] erofs: remove unused trace event erofs_destroy_inode
Date: Mon, 23 Jun 2025 15:08:22 +0200
Message-ID: <20250623130634.177232343@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -237,24 +237,6 @@ DEFINE_EVENT(erofs__map_blocks_exit, z_e
 	TP_ARGS(inode, map, flags, ret)
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


