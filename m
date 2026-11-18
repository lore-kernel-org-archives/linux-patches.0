Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053243;
	b=a7wVNfOgeoSMBYFzEMq0NaWLmLXFt+VzJftW9F55nnlRg5i3q0TI0ExmvsQO0pvzJKSn
	 SSprqbZ0t4mDcERwTlCBK68KsPI6W8vcTYayxcoU+nvjuqSUjawTwaEhZ1d57JFvzir7k
	 K8HT2AW19aJlc9mNufuiRzPIHwjkTdLHXHFrj/bjZBXU2JfopFYj55gYEu3RtiqumNZhB
	 twa+UL1O7bQ94QuN0OATar65PUxCtEciHeXHcgxkpGJ63etkug5u58VlJQ+Bs8Xmaif2x
	 crk8HVorNKxvANv7kxQrHWlTEbrvoRAHA2VBZC0f53ibIR79ZXQiYsaZJQ3Q+ZJpcHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O/r/JQ66rGBShqnpkbj8wxpt6kSiOYDQfudrbtI/saY=;
	b=CaMgCwTLG1SBLPyP2B+pfttkPJu5Clw8xfGQJt+Y08aZwyvXkfaGeg4EeoSrCSir/DnC
	 VX3pcOcz6alIwgu4vc+zAp2GCuotnAkFe44mi2Wbc+rHd0aRDTBDxAnfVQ5XeQDnWWKky
	 mU0aFjDcajbqYgCbtoFrbSZtVshGgV1fRJqCe2VsRJlHWubzGcqHYYTNC4tbHx4S28AXG
	 YTOUWDwPn6UhBtwWx9FkmytgSrOjPVwhHtxOSVEM+7rn32MZcg44txlFxhkv6uses926L
	 qH/b+Sb0EiAnf/hZsdWAEcP36ig6UYXjY57JCY+LvQwZEoJ9MqhIbG8QCfzsUDP3FQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uT87ZWq0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8018260A2601;
	Thu, 19 Nov 2026 01:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uT87ZWq0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A81E1F000C5;
	Thu, 19 Nov 2026 01:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053243;
	bh=O/r/JQ66rGBShqnpkbj8wxpt6kSiOYDQfudrbtI/saY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uT87ZWq0oDMALZrXOZqA7vLJ1j/9WR5cvFrbGhM7htvKqVzX0oyl6l98gpwi426dm
	 InJkcpDQghuYZXLkrp80tFFZpNge0oE4b0Dp7uWA2MRMMuXiRLeyLrDGjOzVFzt639
	 t+MZXkMlmqc+3qR/nIgkNhzomkPZwCeOiKlqk+8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guolingxing <guolingxing@tju.edu.cn>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0851/2214] btrfs: sysfs: restore NOFS context on early return in btrfs_sysfs_add_block_group_type()
Date: Wed, 18 Nov 2026 15:42:07 +0100
Message-ID: <20261118150046.203521862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6f7f7231e34a0..c764650640392 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1360,6 +1360,7 @@ void btrfs_sysfs_add_block_group_type(struct btrfs_block_group *cache)
 	if (space_info->block_group_kobjs[index]) {
 		spin_unlock(&space_info->lock);
 		kobject_put(&rkobj->kobj);
+		memalloc_nofs_restore(nofs_flag);
 		return;
 	} else {
 		space_info->block_group_kobjs[index] = &rkobj->kobj;
-- 
2.53.0



