Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056046;
	b=PM/HHNF6MWPF7qM/JpywenWTXDQ4ZzFW0SdnwTra8vaP3WkdHj5rqJDQY/eE3lsGN8fQ
	 rbLBP65A47RDx82W9vAAjRe0KpYT+uZ7C7ZzHrJwUmwWrSjWKRz9h9ic3txSmDjUjToE2
	 nesnK3VBK4BQSg11Y4o0uozIiAt7ByvJfdyqBvp5Yswj8p6z5GtFUWaDKkouSS9Zuiyc1
	 GmoAz/NqnokXw9pZzU1TQGjch9qaII6w0NshaGYucLOqCjOS9FvzTuBbEAP7VwrZHOfY1
	 Kc/Dyqe+FnTvg7ZKxY+P4k6tdZogen20n3q7OCNNudkaQCd68OV0CRrylwzAiDTSz+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kz2euboovhJgd+NqKzgsuPGVDGLdTZeOyPbclqTg3qo=;
	b=EYJ3rABeMLGF7V6k+P0wNnQZxHds6DJbAArjsUhKhxnYFOktzs+FWcM9l5pyqZfiIsCw
	 Fkb1aNr5Hc5NmZt/5nNn/Driz6DfqZwrodZk30UjTelNTFpF60EoB7NJGI9azLBRp9Jk2
	 MFiKLs6EpFn9PvaDVx4od+30rZ+REespR9B0YZ2JOBAXo+qCUp3jmZH302hBUkbe6n65Z
	 d829SVLWnyOEjvOYnMRG0mOUGWQxTszFCmx+PX52s0ijcrAK2ArLwCRCaomI1F2LkLECw
	 iARXktzpr0/A+x2nnO8D2215vW08CbiQMR8e9PhUjB9y+4OXDA8y1d9GkRiez83qiPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rSpQcPwc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E8F606A320;
	Thu, 19 Nov 2026 02:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rSpQcPwc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784221F000C4;
	Thu, 19 Nov 2026 02:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056046;
	bh=kz2euboovhJgd+NqKzgsuPGVDGLdTZeOyPbclqTg3qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rSpQcPwcBTVjBofYjXXDJ0qyi89wUznLzb0ISVH2B6nWtY9kyqiwUf+ygAd2TCX1k
	 pZZk7a7SCN1dxgFe52UNRcewZeLtkR+TNu7iBRYBcKYK6v7oEiRvqdo40+UFowfuqJ
	 OSRL0vV6CQjaRjdm0yCZFUyHPM42/kjGZW5O2Xjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	c.f.a@posteo.de,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1847/2214] btrfs: qgroup: do not treat "ret > 0" as error when deleting a qgroup
Date: Wed, 18 Nov 2026 15:58:43 +0100
Message-ID: <20261118150125.283432199@linuxfoundation.org>
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
index 208c6813dc681..ca907ed7d337c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1661,7 +1661,7 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 					struct btrfs_qgroup_list, next_group);
 		ret = __del_qgroup_relation(trans, qgroupid,
 					    list->group->qgroupid);
-		if (ret)
+		if (ret < 0)
 			goto out;
 	}
 
-- 
2.53.0



