Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033826;
	b=sg/MObLorIsjuLCZB0VvLEzP6hhU6COGteEycqu/Rcw6Ad5u4rGdHEzwNJuQhavkOE44
	 2WZxMKsuVSGHP3r4IeLEhNqlKB5Q0KW5fomN77R6CgwRz7vF8Tt9VICAiduWMUDZw75wo
	 E6LWdej0EAn80Lr4muRes9rbjcOhj9iHvAW7MVebyeBpq61F62WsBe1OgqjxJVa8VIqAm
	 sjKD1SuBjr4Rh/7aPBAp6kLcIItkVvOolmckf7MYZmacOVUZNYoUpjNbdA1ayfxF1tIMq
	 uDjeMvrNw37alRe1Qxh5403SMrTrOxG7T6posGBBr8AMLdOz63SNECh9xL6Ci1dM8DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YuErk976MncQrp26b3TfohrVzpexnTdfhxBy/E3264g=;
	b=Km7RGai9/7r1E6ySCyGrmVocqmQjRV07YNCe1SJwihYNTk55ddYd9/DhtrdaLHwmGnyA
	 sjcaixj26d9UXASGx8OHSzs0KC4fP54ORGf4Docnd2qyGgFzB3xF2DnXJEE6gDN222MSC
	 lveMHKUBgDUPooPGnGVgZTw7USeeIeecp5i3p9Nu650wZoAMackCxLiurFzgQVKeeqp8P
	 6lotgAIGOFzO3LLBmKebRT9FzxB4mHoxahR3vanPQMNPrqlhzVhTRZjisojUbbXKwyOL/
	 1cHETkiUvxlYzi4mQ6HYy6dNnJjEOIora8eEyDr3BZtOvEhnJOPrQpAAj21DSIGPb0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ya5gnKkV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E942606A325;
	Wed, 18 Nov 2026 20:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ya5gnKkV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFE71F000C4;
	Wed, 18 Nov 2026 20:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033826;
	bh=YuErk976MncQrp26b3TfohrVzpexnTdfhxBy/E3264g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ya5gnKkVpAOgqZ2V9EAhifJqlb9p8hrwwnGXRkvkzsjFJxA2DQM0IOc3uGX0FHkZB
	 by9KBXxTaJB9Kk91JsM+jOfquMETJflZ1dOPxcRYQUVtq1creG1Npi4VXIrS+TlANX
	 hGhEydyfkFqQ2tjnn6A9M0srQ4eM/CA+1n4JsR0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0151/3318] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
Date: Wed, 18 Nov 2026 15:12:53 +0100
Message-ID: <20261118150319.048718430@linuxfoundation.org>
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

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 2c0e4fb511f97467dafc91b6afb3414100289081 ]

An inode being evicted will never need its extra isize expanded.  Set
EXT4_STATE_NO_EXPAND before ext4_mark_inode_dirty() in ext4_evict_inode()
to make this explicit and prevent any unnecessary work in
ext4_try_to_expand_extra_isize().

This also provides defense-in-depth for the s_writepages_rwsem deadlock
during mount-time orphan cleanup, ensuring the expand path is blocked
for inodes under eviction regardless of how they are reached.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260623061903.2148767-2-yun.zhou@windriver.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4253c9a757e98..b7fda0c0bd6a3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -251,6 +251,7 @@ void ext4_evict_inode(struct inode *inode)
 	if (ext4_inode_is_fast_symlink(inode))
 		memset(EXT4_I(inode)->i_data, 0, sizeof(EXT4_I(inode)->i_data));
 	inode->i_size = 0;
+	ext4_set_inode_state(inode, EXT4_STATE_NO_EXPAND);
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err) {
 		ext4_warning(inode->i_sb,
-- 
2.53.0



