Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063204;
	b=YTQWGg+hbk/sor4A7VYy04Eflcw6qaSRafZHC6QgkRk2hm495F8TM2U1DkKmzmSuIhDy
	 MmpKIN8UNPZG2fmaS4yOINfxa01T0STtI6X2PJ8WoFxg2v5TjB49+cbls5qxaG2ZNW2BT
	 afVVVDQ/x1otQTsuBBirhXUeeEsmAtQAMOClGCNY+1EozsUTG5yZs6ZaRoBR5xe1o9XP6
	 B3sC4bXLmPshzgWByngMAr3WDZ+pme/Wlj0zKgKg1kf/D1gxwR7lwiBt9xub5ewdj+vmV
	 AzvwBjm/NhmVsLQBkIxioIe6VQSt4RS/5JNGgrGo2GMnMRAO/Zh0mAEr+N0wZUJwFhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MibQEn1g5YesCei+nVYJlkwCFH6bjV7vDs5se/HjOlk=;
	b=CSgU0ks9M5wDHb67HQQ8H5Mikw+kVKqfkz8KUfUvySZNZJVylfGgU/4/bL9enKGMrQz5
	 YtqGSXkct9kV+X/WZ47QZengNh30jNosVdTYq4qESWDTS2SQ78AMqdKDeUhtJyLHCG6SW
	 ryo7FQDkM0fLy1OMmE4Ll1/Y08n7OVL1MJTvnN1KSSF1JYqh7QY8YhTmN2KwYvnCfromk
	 Z7V/q4jJEoaJq3ydeH7Q+NymLWSfS6g0MwSfEqhmQ1iud1IJcehzkoWW5sYNJy1mRSYWw
	 9Hyt+AII0AG40yd5wFfD6YLUK/rDyrC0vmexh+kq8byIZOiPeM4eVxcrYJsKxMlbDzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDdvX368;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58DB606A33B;
	Sat,  7 Nov 2026 14:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDdvX368
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B2A1F008A1;
	Sat,  7 Nov 2026 14:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063203;
	bh=MibQEn1g5YesCei+nVYJlkwCFH6bjV7vDs5se/HjOlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDdvX368p0Sfb52/cyXCWinuCN82OJ1NpXaMLAikNB0JQkPtV1k6UQdLzpAyYPbrV
	 4GFACbl8EhVM/X1ZZfkijjziddcXWQQynAlD4jkbx3VnbfxVObnC9GeE5SQCk7ofbq
	 6pM3Xy0gkxLO0H+U4/C5zUEwDqZFCObM5cOioMtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	guzebing <guzebing1612@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 416/869] ext4: only update tune mount options when requested
Date: Sat,  7 Nov 2026 08:51:38 -0500
Message-ID: <20261107134907.514867239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: guzebing <guzebing1612@gmail.com>

[ Upstream commit 981eec6c300bd4e84ffac8f3c28b762d00f13e9c ]

EXT4_IOC_SET_TUNE_SB_PARAM uses set_flags to indicate which superblock
fields the caller wants to update. ext4_sb_setparams() checks set_flags
before updating the other supported fields, but always copied mount_opts
into the on-disk s_mount_opts field.

As a result, callers that do not set EXT4_TUNE_FL_MOUNT_OPTS can still
clear or alter the on-disk default mount options through their unused
mount_opts buffer. This can affect subsequent mounts by changing the
filesystem's stored default mount options.

Only copy mount_opts into s_mount_opts when EXT4_TUNE_FL_MOUNT_OPTS is set,
matching the set_flags semantics used by the other tuneable superblock
fields.

Cc: stable@kernel.org
Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock parameters")
Signed-off-by: guzebing <guzebing1612@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Link: https://patch.msgid.link/20260810151200.1405562-1-guzebing1612@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 9aec4ee780a7e..cc85786be2704 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1360,7 +1360,8 @@ static void ext4_sb_setparams(struct ext4_sb_info *sbi,
 		es->s_encoding = cpu_to_le16(params->encoding);
 	if (params->set_flags & EXT4_TUNE_FL_ENCODING_FLAGS)
 		es->s_encoding_flags = cpu_to_le16(params->encoding_flags);
-	strscpy_pad(es->s_mount_opts, params->mount_opts);
+	if (params->set_flags & EXT4_TUNE_FL_MOUNT_OPTS)
+		strscpy_pad(es->s_mount_opts, params->mount_opts);
 	if (params->set_flags & EXT4_TUNE_FL_EDIT_FEATURES) {
 		es->s_feature_compat |=
 			cpu_to_le32(params->set_feature_compat_mask);
-- 
2.53.0



