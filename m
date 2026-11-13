Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585500;
	b=5HQTYQG76v0o4UA8ln/dRV80ky52e4Ox0uqLmPDm+nhN3sKzfkE1skRI9O9twCmd3CKX
	 PDYR9wp5QPGwldQGNmZAkjM5/M2i3CpwjRxbWyVXisFV2jEISr2KhiuConEMxs/I+dhfy
	 lSrAortg5v5TayUnER/cxtvNgdBNJmEJAtjSLuHXR5jBD1ktG61+0wGJ2OeCm2wOwjW94
	 wZv2aAd3ruyYzY42L3OgFJryfHiloGn943yBaHKrSX4J6CZ+1x9GAtvyskrKFyIjZH5Dz
	 VUsP6Waor1OiKXJrMr+ttn5C0AmLfF1WWmPFOhLsgv0/RWT5mBY+Gx0+XuaxXyDRFGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J9vEYe8gKtFB/PNYrZtZQis8XO8bnvFlcV+V7Rc6TY8=;
	b=WisUndQuG08DRAThPrn6W/Bf4NprHIUdDJlnBxi2cvC/ZmBgQxyWw8jn6ftmGOWVU41G
	 3PMn+cSVOKWRgfQHCP8RdAx+3AN7y/bCc8leDLbwTqcmWaCYjKJIExHpk8VotB2wLHPm+
	 DDDpQ1qWQpiOoPG1VPuoRP8ICQsYKIR4+wiapdmOYYk68Kn/RN4QG6yyt6LEZsoI+yy5y
	 hvcCXrNmD7r8GXsh8Do87rVN59vPvLr/pwRX6IzIU0V7/SqsAfepVBlEszh8tivA/NgJ0
	 M5FQGSmipirUXUuZy1Vw5ZFNbTc7SVXyJMZdTd/MKxHfuhxPtk+FXRLRkmLIetTbPBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t7ygDeWi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19354606AE0B;
	Fri, 13 Nov 2026 15:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t7ygDeWi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96121F000C4;
	Fri, 13 Nov 2026 15:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585500;
	bh=J9vEYe8gKtFB/PNYrZtZQis8XO8bnvFlcV+V7Rc6TY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t7ygDeWiI9QqtfFsg4G0YpJ1j7rJ1cC7TRjfh7LUqzgVVLHlvjVxzHkpQpBGU1mH7
	 hqgsGamoLULepLns6AHLTZ+6YMMdCX6UciB8wbb0thDeIXEmQXZmq8vrlCp+s011u2
	 BxnegPZWLULccCH9/ijfta5DIBbIkIlEMQSOtyH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guolingxing <guolingxing@tju.edu.cn>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 096/507] btrfs: sysfs: restore NOFS context on early return in btrfs_sysfs_add_block_group_type()
Date: Fri, 13 Nov 2026 10:46:40 -0500
Message-ID: <20261113153757.388152694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 39cb01ee441ab..71b1ec6c06433 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1857,6 +1857,7 @@ void btrfs_sysfs_add_block_group_type(struct btrfs_block_group *cache)
 	if (space_info->block_group_kobjs[index]) {
 		spin_unlock(&space_info->lock);
 		kobject_put(&rkobj->kobj);
+		memalloc_nofs_restore(nofs_flag);
 		return;
 	} else {
 		space_info->block_group_kobjs[index] = &rkobj->kobj;
-- 
2.53.0



