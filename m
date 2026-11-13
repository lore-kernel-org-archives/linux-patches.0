Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590220;
	b=iDcXADvoP7O+MD2sWkvrMfddtikI4i3Lgd9ATOvBHaLdsj9M6Mw0cHQ+6K9VDGZ6NbCX
	 qXEWc3GPvoSetYuxISpOdpwfS0J8YRHe5OxG4H0smKYbNEmW/8JEY/OLtQRWxav63tc7G
	 6QYwXs6aOqnIaXsY4+u5M0WBX+USR8YOpllE6wD6UCOx4YE8pxAUi2gFfkOnVsgHMoW00
	 LI1sx1DBI/lDFu/Kh6CD5N8JWVHOPRwboBJbdIb9MrntKVA8ZQ6+Y3Sgo8wGU1Akgi44G
	 aWg4W2I0YkttC3Z4zOBpnM+6IpcEOvaDxJmjuq0Q8rU0pdV1VLdFzxxqAm8QdxQLSEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OH8L1u9qhvEhrJZ+AXPEGtdmJK09gbHOKeACCmiqzP0=;
	b=k0KZECWGALXeb50za0DG7/UYs7Y/N8p8ry7PyBqBAq2sR70L3wzlB7QGy5Hej5SryGg7
	 CeEJeVERL/T0TgM6HDLI486WcHqRXsEWHqtW3VVVhop3CHFV5fZe8BL0UwcUT3uct7ais
	 +JlKRnWyOdLcNI8nciDaU7PEHPM6OsDBKv3TdBCbdp3ktFtOS3FNVk7Ka5hLpVrN7A6mQ
	 PbPwrO632tviI43svNIyxIPnAFrT22q97mASXeoLCfL5PKC4O5IC8OQaFmgPRoAuaztuP
	 NPgLJ4dE8mOBPPQ0Qwe/04Jx6jxZ6S61IYka2s3/w+lXY2Bp87bGQJTaIrpj3WpnJ6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wqX0saNo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97C3606C089;
	Fri, 13 Nov 2026 17:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wqX0saNo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7775D1F000C4;
	Fri, 13 Nov 2026 17:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590220;
	bh=OH8L1u9qhvEhrJZ+AXPEGtdmJK09gbHOKeACCmiqzP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wqX0saNo+BCUUluG5RQakFTuPTd/V8yBr2ebgRPNE6uVraGJHlQX4w5ehc134kHCW
	 N4hUPCsRJguIdiHwVW18BvAkSaNgGNaaHWKaHlLHKV+mkkskE26myJNHwrqDPjg+Iy
	 NoQ+YRpUemGYsMMMT99fRqFshHKQx1puckvEfvGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guolingxing <guolingxing@tju.edu.cn>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 221/686] btrfs: sysfs: restore NOFS context on early return in btrfs_sysfs_add_block_group_type()
Date: Fri, 13 Nov 2026 10:45:54 -0500
Message-ID: <20261113153828.519957935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: guolingxing <guolingxing@tju.edu.cn>

[ Upstream commit 4172be965c2ce887ebfb1117c634a68555be8c11 ]

btrfs_sysfs_add_block_group_type() sets up a NOFS context with
memalloc_nofs_save() because kobject_add() performs GFP_KERNEL
allocations deep in its call chain, and the function may be called
while holding a transaction handle or a lock required for a
transaction commit, where reclaim could deadlock.

Every other return path of this function calls memalloc_nofs_restore()
except the early return taken when another thread has already created
the kobject for the same raid index (this can happen when restriping).
Taking that path leaves PF_MEMALLOC_NOFS set on the calling task, so
all subsequent memory allocations performed by that task remain
restricted to the NOFS scope, which may lead to unexpected allocation
failures or deadlocks later on.

Restore the NOFS context before returning from that path.

Fixes: 49ea112da0e6 ("btrfs: do not create raid sysfs entries under any locks")
CC: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index d66681ce2b3da..204edb659304b 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1899,6 +1899,7 @@ void btrfs_sysfs_add_block_group_type(struct btrfs_block_group *cache)
 	if (space_info->block_group_kobjs[index]) {
 		spin_unlock(&space_info->lock);
 		kobject_put(&rkobj->kobj);
+		memalloc_nofs_restore(nofs_flag);
 		return;
 	} else {
 		space_info->block_group_kobjs[index] = &rkobj->kobj;
-- 
2.53.0



