Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058285;
	b=CYBYh16zqN/lofJb5L7XlsOGqFd47C1S0ROwn2Z+xkYVE+aut/DM51GapMVsydtyslrz
	 5axiXf/AKHQ0Y5zA80us0aapustCo1isIu4a2JblPkZ18DCtzyQ40P2rPGw9xDkgdUUP/
	 48BKbcH8BDRUebuWWWe9COzs+XdXOpiaL+Kw8wUXBMVUQMgyqQ2nRStUP/7E0hvm6C/I8
	 SBPlqmzm93gJpoXfeGL7jYUgFor36dDaVBrR19bei0V49hgx91GAEZItcHN8+KZR1GABX
	 lwLDp4rUu5YgQoCC/ZREQeIQYGI+VRHVGQE1PyJVgRAxlwUdwboxgN1aZ+lxV5fnrRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jXFceoL3EJ5fs67pKWQcNm2Ed1M1sxGHqTG+yYivnwQ=;
	b=fvVEZRmfR38nasm6lh2SD0W9wLW9ZvUCVGdZ7C4wRHYC5isbu1htCvp0Z7wqSe3lKrow
	 6wV0/DrGWhKuLHIiym9bLB0BrzIcws4D8w0FjHWWLC7QC+8ww1XodRlhLn+pZLTKXkJ3O
	 VE/tkIt1MXnzVlDOb3q9Ii6h4WeblU8fFPTmMyOZLxhlgst8NatorAZyxSGsYjXlFzVlL
	 nM8LL43iIcNN8NlTDhPi/tebA08CrBi56AhEuQzIIU/k1xapJ4ljs3aED0XZHuLoo/cPV
	 hmlNv3FI5zTFy1A3o7yEsttD7I21n8an6/fIXoos/A7l+UdcdiI69AdKe1gKacsNe1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MoTYpnXr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA31606A31C;
	Thu, 19 Nov 2026 03:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MoTYpnXr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBB61F000C4;
	Thu, 19 Nov 2026 03:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058284;
	bh=jXFceoL3EJ5fs67pKWQcNm2Ed1M1sxGHqTG+yYivnwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MoTYpnXrNZo2+qB0Y68YeW/lxZqroRJO5FqR4GE6yai3XhBUSHX3D0VZ5H+Y9evYD
	 RGOo5goVaQL1Qws9uTDCQNnNo90QLUjFcvsu1Ka+NwbgOtja9Kr5mGCgKAEiwSPoYo
	 9ijIrHJ+iD078fjOsBm90mW2CYHTlQYyrBF/usLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0430/1848] nilfs2: fix deadlock between nilfs_evict_inode() and find_inode()
Date: Wed, 18 Nov 2026 15:41:08 +0100
Message-ID: <20261118145932.172979087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit ff1227f70eead8704ecfec69259fb4c041f92cda ]

Syzbot reported a deadlock between nilfs_evict_inode(), executed via
an asynchronous workqueue (kworker) as:

  process_one_work()
    process_scheduled_works()
      nilfs_iput_work_func()
        nilfs_dispose_list()
          iput()
            iput_final()
              evict()
                s_op->evict_inode()
                  nilfs_evict_inode()

and find_inode(), called via

  nilfs_mkdir()
    nilfs_new_inode()
      nilfs_insert_inode_locked()
        insert_inode_locked4()
          inode_insert5()
            find_inode()

When an inode is deleted (i_nlink == 0), nilfs_evict_inode() clears its
ifile bitmap entry and then synchronously triggers the log writer via
nilfs_transaction_commit() if IS_SYNC(inode) is true.

If a concurrent directory creation via nilfs_new_inode() attempts to
allocate the same newly freed inode number, however, find_inode() called
just before inserting it into the inode hash, blocks waiting for the old
inode's evict() to complete.

Meanwhile, the synchronous log writer invoked from nilfs_evict_inode()
tries to acquire a write lock on 'ns_segctor_sem' which is read locked
by the caller of nilfs_new_inode() (in this case, nilfs_mkdir()),
resulting in a deadlock.

The synchronous log writer invocation from nilfs_evict_inode() is a
legacy artifact; it is no longer necessary because the call itself
(triggered by iput()) is now handled asynchronously with a kworker
if i_nlink == 0.  It merely increases the risk of deadlock.

Fix this deadlock by removing the synchronous log writer trigger from
nilfs_evict_inode().

Reported-by: syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6646318bbcf419411bc5
Fixes: 7ef3ff2fea8b ("nilfs2: fix deadlock of segment constructor over I_SYNC flag")
Tested-by: syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/inode.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 11201919aa446..581ab03442015 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -975,13 +975,7 @@ void nilfs_evict_inode(struct inode *inode)
 
 	nilfs_clear_inode(inode);
 
-	if (IS_SYNC(inode))
-		nilfs_set_transaction_flag(NILFS_TI_SYNC);
 	nilfs_transaction_commit(sb);
-	/*
-	 * May construct a logical segment and may fail in sync mode.
-	 * But delete_inode has no return value.
-	 */
 }
 
 int nilfs_setattr(struct dentry *dentry, struct iattr *iattr)
-- 
2.53.0



