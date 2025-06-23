Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8893B22370A;
	Mon, 23 Jun 2025 22:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717609; cv=none; b=Q9IfRsRfukwoMhj8GgQjoUH8eCscWtHQkjkOUafJOfT3a0CGYc2P/g3V2qxhyCBplgorh2AbiUPfS09K80uZczkegpFCn1cJcVfChG3rL6LCJ0s55UKweXsZe7NKHGI2AeChcJZWqfDSghc5r94bX3KahkLQsCVuFtJlRwj/Dqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717609; c=relaxed/simple;
	bh=R7G44ye1t2TaNZxxJiVeZPVXZZFIh/VXAyiClm4Hx2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSgAZeVmdJAdS9Dw/86F+qNQ+tq4byBYmOcmSi5eg2wHbrP5tOUUILzfQEOqJu15QjS47U2qZxTDi3IbO3MdxeuE3LUGWTepNGGqypkjAwRF5GSJZ6SC6XODcii92xLFe5gsN3MK2UVZxvee9VjUyJ64L6D5RF67PUSNVngzDug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRGPVkp7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRGPVkp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2093BC4CEEA;
	Mon, 23 Jun 2025 22:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717609;
	bh=R7G44ye1t2TaNZxxJiVeZPVXZZFIh/VXAyiClm4Hx2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRGPVkp7IJJhVCmzSuNIg1riI281G4vdkf1Yic2I27e9HRyIEhQKqeIjMpawxfWdd
	 A1fUz3Jjiboz+tpFlGUqOxFQ8x0QDBe0Mu6hTiXvBadwh5o4hIa/DfzcPG+9ZlhS9F
	 QqlD+H3u/2xx2mj3y0k8Rt4lnYDe2lGANokyKn/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Hongbo Li <lihongbo22@huawei.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.1 469/508] erofs: remove unused trace event erofs_destroy_inode
Date: Mon, 23 Jun 2025 15:08:34 +0200
Message-ID: <20250623130656.639073656@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -232,24 +232,6 @@ DEFINE_EVENT(erofs__map_blocks_exit, z_e
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


