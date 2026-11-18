Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045138;
	b=rvmlyzi1yZyJPLx/kTcj3aAs8WMonG1mr3TOoQ6muyIoFUhsNIa9EFX8+dNpFwP6CkWp
	 l5Cp0rNNsqticgvNkszgIh4vF75yi5jfSVKClqYw4bMXwGMOLcP2ialRp3hTZjxooYTyj
	 QXPBCw3HUQNJWpoqgsTLm6wjGfKRLEqq0AHhFMhhOT3huu0Vcb+dSdzNgsPnYNUJJeXF+
	 j+99YpvB3aZ+wfhf1/UzobwdhoYGCc6xH/gBYn9emIIC8GWW0nkRshcnsPoRpATdXe4MJ
	 52xMUOxibfuYyh3Hmm6PONHicfCWPj6yQ+DD0IX1UVBezjZbmLwwUF5baJ6IZvewXKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QCu8MgPlB1OSN5CnSFtdQPIWE9rqWbK53fsz2//is68=;
	b=DUWU6hTSMS1FN16Gg04Bxca5NDelbOjWCbz+O82XiiK5u/3a7QKzhS5TMcRl1xPR43JF
	 U8TWPuGt7f4rVNx+eVYWbHcmgGcaQM/c0NBRY14AwTUz9XUvVT1f/TZNkXGSqo7CYNagg
	 LX+aWuxnKBbwiKKRSASlyZmiQBEZz8QiQLx7Ur1s+qrVJ9BQ8eTKXCiKD/AWKD+JMlVtz
	 2rMYupcTnL/ce9YPR8eBEwPJhyZO+rn18y2Co+yg8RdkTpMH7FTavxcsIN6h67bbMerwr
	 oqhb6ce5E4Mz8ekI+e3fTNHGsbpuV1Tf0Oqeh1zYsvVnUmsON/o/wC7oT2H9qAKQEMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z66qYLLR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43CE606A31C;
	Wed, 18 Nov 2026 23:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z66qYLLR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3993F1F000C4;
	Wed, 18 Nov 2026 23:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045138;
	bh=QCu8MgPlB1OSN5CnSFtdQPIWE9rqWbK53fsz2//is68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z66qYLLRhBkbZoUjr7lnpBAhgFsm3CV9yHnPwtfxPltMzJ82RWzFGydz6x/WvbTTa
	 vPshL9XNDz7cmV+Z0cOlxTAfqYV7s/hoKt9O/J0owDKn5oOJqKTYCcKyVAiGcda8yB
	 36d/nruz7frQrGVFlhIEdyC1welnUMOd4gBfeRFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0816/2857] nilfs2: fix deadlock between nilfs_evict_inode() and find_inode()
Date: Wed, 18 Nov 2026 15:30:50 +0100
Message-ID: <20261118150230.957199948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1eb6c90fb7f4c..a20d52951f1ef 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -976,13 +976,7 @@ void nilfs_evict_inode(struct inode *inode)
 
 	nilfs_clear_inode(inode);
 
-	if (IS_SYNC(inode))
-		nilfs_set_transaction_flag(NILFS_TI_SYNC);
 	nilfs_transaction_commit(sb);
-	/*
-	 * May construct a logical segment and may fail in sync mode.
-	 * But delete_inode has no return value.
-	 */
 }
 
 int nilfs_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
-- 
2.53.0



