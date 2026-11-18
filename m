Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037532;
	b=fdyphrfysHPPwTvPuGPNt6WSY6jT0Jx/b0nIfFWKy3dI2uU0VYxV21uLIUs12tlESmqZ
	 7nWY7nWI2n4ymhc9vmGlt2sNZxbmqQVeFmnW8urL928K6OwiZBDuBiz7jxSQHwypvcWkY
	 rWq8BOEMkuzA9igrEODo0HTqLNpCGMJIWGiS+W52UhER//rXLB5yjwMFaGOZa/TzQ7YBs
	 BgotVKMUJQ/2Ii8ApIkfQWEath4kuBfMAtX5cr5dLbzy4LMzIjw73+UG7kO2I0H/OO4ug
	 Tjhm4aMIKkTIwcy4OMTUSDRoHXu0Y3+Gv7lDjV/Qxta+JuzPJyR3TawUrUSkY0ayQHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DqudE6EUP7znM97aRAhd0SgKhFQyNLkSiCUcVqCnj9Q=;
	b=morEMZxcMBqRKTH7YQOrXr7y5nGfjjlbGjTE3RmDtvUY13xqtSiVYNQtFx/XB2NIZ2ks
	 XpBfiW66IZ7tF57XuazRpvfB/a3yKsW+mrVkQjh3zKp0UP8U8D3KwUlu87dqUZt/nnZZq
	 6hAApIXz//dZoO7YCjX+oDTyT1+CjzA1QnQCnZvSQExQhydtGah/uEaknGsylNh26FMz9
	 kKV842eknWBkCByeH13yu3tB4qQjPv4KMHN96/iL9LF0ceVH0ls1pGREdrhgYquLZgmee
	 xVr9cYvQYCocaq9OVKcUTZ628YJq+/dB74M/UcwIF8OUENgSAxbBH+L0vl4Bmeo5Liw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gn9e2keF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8799606A320;
	Wed, 18 Nov 2026 21:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gn9e2keF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1593B1F000C4;
	Wed, 18 Nov 2026 21:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037532;
	bh=DqudE6EUP7znM97aRAhd0SgKhFQyNLkSiCUcVqCnj9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gn9e2keFBubTazjnv0kuZRU0+3lB6JDSQHz6DPYbeiXJNuE8aVvWKNxDllKAdBGFZ
	 7pPsGZMKrd3mobe5M0mMPhj4ah4KncZ3HjzsSiKemOnFgPG5M84gyO9fXs+rYC9F0V
	 pZRsL8lpyKCAO5FelaY3KtnbNMBJ1rgIJzyurZpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guolingxing <guolingxing@tju.edu.cn>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1423/3318] btrfs: sysfs: restore NOFS context on early return in btrfs_sysfs_add_block_group_type()
Date: Wed, 18 Nov 2026 15:34:05 +0100
Message-ID: <20261118150403.404767765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6f01b89add673..b2332c7e43e4e 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1599,6 +1599,7 @@ void btrfs_sysfs_add_block_group_type(struct btrfs_block_group *cache)
 	if (space_info->block_group_kobjs[index]) {
 		spin_unlock(&space_info->lock);
 		kobject_put(&rkobj->kobj);
+		memalloc_nofs_restore(nofs_flag);
 		return;
 	} else {
 		space_info->block_group_kobjs[index] = &rkobj->kobj;
-- 
2.53.0



