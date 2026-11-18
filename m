Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019663;
	b=B7rAl6kOEbLS0LuotA1LWaejq0U+FysBI8QZ4gqTyasvVpWDQ5jt3vuvHDsmuVAYlCIp
	 Qi94vWKuf26CIdLHWxVawOXELcYtCFtnN8ere8PwWEoR7nX6ikOBNN0Qs2Hk3iUbu0jkK
	 exoZRIvyrusmEJamM/u/eIbvrrCksEzMXfNOVF7ZLCRtywi49wMQuMfEI7kzrE0In5Y+S
	 7BHU1wXV5/DBN2FhvoiTVA5t6SQgDqSZoYmzFkVLt9l6VvSjkoaXsGYYogWZJzXqfhwLv
	 v/iO7YsbV3+dDueWIwKkUMwJ/SzDYvYC5c5rUwD0OqAPOP6ah54M0inPW9VJ7fQQLhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T5xT08Hwt6RY4vS3AU3qLAC5fL3nYCtNOZaWttLO+yM=;
	b=ib8XrhU54MNBkHq+LQ/a1mSLxZ/IhclnisMKZC+55aIFo4Tl1JRXH+LArpSssrcjdWr9
	 GtuC1IfGXtY/aIQbQhQzJ0vK4H20+o10XNVPbLPOejp5CYDasxoiHBfxwjk0myfxACLMo
	 Rth2yDu3qHmo9uvnILVIA58VgucLKKYz/Sl+IL5zwnt5C28fkNQjAV11AQERk6kAKZqY0
	 W+TO0/NPDLmmyqpEXw4/8Q71vXU7kCxIHBI4bNNB52VcKhIYsG4hpyDrwCZSjFxv1imB/
	 oaqb0s0K1VZtabncal3wWbkuS+/CK/crRUKZPpE6y9Zr5GaDTN1lla0kqCuMjWjKZbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vEZqgbKb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7963A606A325;
	Wed, 18 Nov 2026 16:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vEZqgbKb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E421F000C4;
	Wed, 18 Nov 2026 16:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019663;
	bh=T5xT08Hwt6RY4vS3AU3qLAC5fL3nYCtNOZaWttLO+yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vEZqgbKbbDzqh0aX9mbwiqvKgNT+n7eq/twMwqQy4N5HdfW8Drb1RvMrOq9By7n2k
	 WFTK70Hmplp6xNGh+60e3sai2nyFLYsnIuP8RY1rPmr1kbRJQfeWhHOyFzgzwZ7BGC
	 wMFbittk70tw1pLj9dlYNwzqVB/xuMXSH5phhxSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	c.f.a@posteo.de,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1659/2651] btrfs: qgroup: do not treat "ret > 0" as error when deleting a qgroup
Date: Wed, 18 Nov 2026 15:48:19 +0100
Message-ID: <20261118150347.469703492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit dd906477cc2c33c82ec17e6301bd4be4ea588565 ]

[BUG]
There is a bug report that when removing a child qgroup, if removing the
qgroup requires a rescan, it will delete the on-disk relation and qgroup
items but not the in-memory qgroup rb entry.

This makes all later qgroup rescan to fail.

[CAUSE]
The call chain looks like the following:

 btrfs_remove_qgroup()
 |- __del_qgroup_relation()
 |  |- quick_update_accounting()
 |     Which returns 1, showing this operation will require
 |     a qgroup rescan
 |- if (ret) goto out;
    Which skips the del_qgroup_rb() call, leaving the in-memory qgroup
    rb entry still intact.

Then later qgroup rescan/update will always fail and mark qgroup
inconsistent:

 btrfs_run_qgroups()
 |- update_qgroup_info_item()
 |  |- btrfs_search_slot()
 |     Which returns -ENOENT, as the qgroup info item is already
 |     deleted.
 |- qgroup_mark_inconsistent()
 |- return -ENOENT;

[FIX]
Do not treat "ret > 0" as an error.

Reported-by: c.f.a@posteo.de
Link: https://lore.kernel.org/linux-btrfs/14846642-85d3-4afb-ad99-1b74b22f5f90@posteo.de/
Fixes: 9c8b35b1ba21 ("btrfs: quota: Automatically update related qgroups or mark INCONSISTENT flags when assigning/deleting a qgroup relations.")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f68b696b4bf72..df8a0aa662478 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1845,7 +1845,7 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 					struct btrfs_qgroup_list, next_group);
 		ret = __del_qgroup_relation(trans, qgroupid,
 					    list->group->qgroupid);
-		if (ret)
+		if (ret < 0)
 			goto out;
 	}
 
-- 
2.53.0



