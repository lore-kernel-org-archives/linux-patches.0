Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045818;
	b=D4c5e1vW/FPbIGwULRJ6a90pPm7/gLX48LSyenpP528Br1j+JvKsRvlX3TBrtWS/n68U
	 mFWFu6qiIYLz34kJG4U1LfPxiZ0HUlEGCVGJFn6q1Ub/VJVPzCU/7LQ0XRO4R8A53hX4C
	 O2KEtTetukJhJNwI1GLnpNxnSDyJ1qvG6WbxKzXQVVziWDK+PUIzxGpSHDqU0ZoEHwerZ
	 gCCFT4ctsKUu6Yow+tRoxJOlENMtbp6qNb/FofIpvWRe7VF25WdVyIYJAG1DNlLYis4yZ
	 mW4C9K6Ed0ZhIZrCquLj3L8Xg2CpDB42H0VWDH48roG48ol+CFLYcbfNDckGhDWIaOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YjVNqbfT7Jd/fKCzR5qHgqKQ39jTOnn6LBdrF4TpaVo=;
	b=b4HxdO3cgS/IgWUup5aRcDTU5uBcUulbRJAzeA5TXdtreq/m3G8a9Gwxs6hUgKxEVOSO
	 GNClBNbsgyMRWxyR8XuC0g6J380qPij24EA3aJ8lyrsvyG/ARs8G0Uri79lmVTlF4hR05
	 OCMpwvQbNIae6PDn9x+IUVeaRW4K8bkIdiO5Or9H0ZdGk9f3QPocYBJVN/DWzYP7phucw
	 MTDiEmYHzLRID0oC+rywm9BKYBSEQQ2b4YJB2D4yC5Q7wsLiG4jECS+J0Dt7DtUDV0ZxE
	 o9naPox6hrKn377RPR37jeZjz9hDnLs2ADfKMo2q68vMSFGoaBWtupQLyZX+vsePxRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhfD1WhQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20D7606A330;
	Wed, 18 Nov 2026 23:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhfD1WhQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB55F1F000C4;
	Wed, 18 Nov 2026 23:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045818;
	bh=YjVNqbfT7Jd/fKCzR5qHgqKQ39jTOnn6LBdrF4TpaVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhfD1WhQxN0CQE8pr/jol8HbpwtNzf5baPx75LOGsi5uvcO7Hi5fAZk89p98Gs6j2
	 5Ui7iclFmtYEdOTRp23MurkrtoWdGD0/3/SkpWlbAsP3yjJG7GAQpnt3QVyc0qXVKS
	 5ojzDuMiNz4j87zyCUa+F6A+7sv5480Kb3+L5q1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venky Shankar <vshankar@redhat.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1058/2857] ceph: dont fail write_begin with -EAGAIN after flushing old snapc
Date: Wed, 18 Nov 2026 15:34:52 +0100
Message-ID: <20261118150239.681641355@linuxfoundation.org>
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

From: Venky Shankar <vshankar@redhat.com>

[ Upstream commit 6ff7920ca78f6edcabc26c63d20f681d938027c7 ]

When ceph_netfs_check_write_begin() finds the folio dirty in an older
snap context, it drops the folio, waits for that snap context to be
flushed and then returns -EAGAIN so that the write is retried.

However, since commit fac47b43c760 ("netfs: do not unlock and put the
folio twice"), netfs_write_begin() retries only when ->check_write_begin()
returns 0 with *foliop cleared -- every error, -EAGAIN included, is
returned as is. The -EAGAIN thus propagates up to write(2), which fails
with "Resource temporarily unavailable" once the dirty data has been
flushed, rather than being retried.

This is easily hit by buffered writers rewriting dirty pages while
snapshots are being taken, e.g. a kernel build linking vmlinux into a
directory under a snapshot schedule:

  ld: final link failed: Resource temporarily unavailable

Return the wait_event_killable() result as is so that netfs re-gets the
folio and retries on success.

Cc: stable@vger.kernel.org
Fixes: fac47b43c760 ("netfs: do not unlock and put the folio twice")
Link: https://tracker.ceph.com/issues/57656
Signed-off-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 823462f07fc3a..aed58cc4b0f9c 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1369,7 +1369,12 @@ static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned
 		r = wait_event_killable(ci->i_cap_wq,
 					context_is_writeable_or_written(inode, snapc));
 		ceph_put_snap_context(snapc);
-		return r == 0 ? -EAGAIN : r;
+		/*
+		 * *foliop is cleared, so a return of 0 makes
+		 * netfs_write_begin() grab the folio again and call us again
+		 * to recheck it. Any error (fatal signal) fails the write.
+		 */
+		return r;
 	}
 	return 0;
 }
-- 
2.53.0



