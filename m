Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020678;
	b=qbvdY8i2tkUtdvS3JcvEAG2npt28f/QCkwiIJbO5rkyQ4ovXwVUUz7rXQanlzlKLs5q+
	 VpFY3ox6h5cpdCJ+g6CmzXXXpvYS2/VrlLXYoNjvSDLbtquVw1W+B2gbVR3UOAZYSXxBi
	 X+pDwYC04SWq8crfx4WR/aOX+MyZ7G4EvIwhFOhnbh6ZKkJiqyJP1gvUCR8+6cnagBgq4
	 Ws75YbesJq2/P2gyqVSeBeMbTAU0aY8pWERE2mTNlI1PoUeASnwSE3n8uJnlLS8OU5Ehf
	 ti9UCKtigVPE8Qf7RrBiOtiOQ54PwEA8Sn8rZoPEN/u4ObZCY7Ik2Dfmnyj0IsNipQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=23hkEOZlghuiR6gpritghZ9vYZkJY9yW6ztOCX/F3AM=;
	b=pFC/sw4vNg27qjcZS7IQhD6a1IeOpYbhj2LjyLvxRKqYZqsJu2vdKnSqnmzOwBcJL2su
	 Aqh03zOlyi4niyGsn79J/y37EyqRaz6L3/8Q112SndIHRXlypSnfi5QEaLxRCENbXmoey
	 mwQNU20lY5yGqaqkVE+7C1yuslXQi+JXr/w3XSJTYcqUkSU1HjeCRsW679JuntQvIGWw+
	 foSQUNrXiOY1V7oh+SnGYR1U4CInvq7+n7q0vlrMmcAqsxjetRrMOdjJQ/EJMMwJcE1VY
	 uqiSPZYyKkIy19LstdQGcvl12uEfPaBO3q1ZmQEfdB/s88nWXlnd1RDVBBc0RxUH/eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zyE+FK3I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCBB60A2619;
	Wed, 18 Nov 2026 16:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zyE+FK3I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2581F000C9;
	Wed, 18 Nov 2026 16:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020678;
	bh=23hkEOZlghuiR6gpritghZ9vYZkJY9yW6ztOCX/F3AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyE+FK3IkL0oVzG51ov45vJnZE87/3sbXrGdRVx5FeWno1d+tqV9OgzBZBHtcaEkZ
	 1xpU7H0bhlmKHxRTpnnKgkDiaj9Iy/hfjvG0M2tJ33SEHnG6qj9uLwXrNW4SH4rWLz
	 cFmbjR7kyDHvBAsvo8a0awwVxxp9SlKd4sCd1Jt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	=?UTF-8?q?=E9=A9=AC=E4=BA=91=E9=BE=99?= <yunlong_ma@buaa.edu.cn>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2037/2651] fuse: fix NULL pointer dereference in fuse_request_find
Date: Wed, 18 Nov 2026 15:54:37 +0100
Message-ID: <20261118150359.446433056@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit f8cef5c74d8b5a982f49cc40d13cd5c3ea2eacf6 ]

fuse_dev_install_with_pq() publishes fud->chan before it stores
fud->pq.processing. The write/splice_write and read paths treat a non-NULL
fud->chan as "installed" and then walk fpq->processing[] without taking
fch->lock, so they can see the new chan while processing is still NULL and
oops in fuse_request_find().

Fix by taking fpq->lock around the cmpxchg + fud->pq.processing assignment.
This protects all call sites that dereference fpq->processing, since these
have fpq->lock held.

Fixes: 48649c0603bd ("fuse: alloc pqueue before installing fch in fuse_dev")
Reported-by: Cen Zhang <zzzccc427@gmail.com>
Closes: https://lore.kernel.org/fuse-devel/pm-fuse-full-objects-candidate-0002-v2-17d6013e5066de33396c@gmail.com/
Reported-by: 马云龙 <yunlong_ma@buaa.edu.cn>
Closes: https://lore.kernel.org/all/5ddc8efe.1e6d2.1a11fbec860.Coremail.yunlong_ma@buaa.edu.cn/
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 660323040576f..6e565d668e066 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -466,24 +466,27 @@ static bool fuse_dev_install_with_pq(struct fuse_dev *fud, struct fuse_chan *fch
 	struct fuse_chan *old_fch;
 
 	guard(spinlock)(&fch->lock);
-	/*
-	 * Pairs with:
-	 *  - xchg() in fuse_dev_release()
-	 *  - smp_load_acquire() in fuse_dev_fc_get()
-	 */
-	old_fch = cmpxchg(&fud->chan, NULL, fch);
-	if (old_fch) {
+	/* protect fud->pq.processing assignment */
+	scoped_guard(spinlock, &fud->pq.lock) {
 		/*
-		 * failed to set fud->chan because
-		 *  - it was already set to a different fc
-		 *  - it was set to disconneted
+		 * Pairs with:
+		 *  - xchg() in fuse_dev_release()
+		 *  - smp_load_acquire() in fuse_dev_fc_get()
 		 */
-		kfree(pq);
-		return false;
-	}
-	if (pq) {
-		WARN_ON(fud->pq.processing);
-		fud->pq.processing = pq;
+		old_fch = cmpxchg(&fud->chan, NULL, fch);
+		if (old_fch) {
+			/*
+			 * failed to set fud->chan because
+			 *  - it was already set to a different fc
+			 *  - it was set to disconneted
+			 */
+			kfree(pq);
+			return false;
+		}
+		if (pq) {
+			WARN_ON(fud->pq.processing);
+			fud->pq.processing = pq;
+		}
 	}
 	list_add_tail(&fud->entry, &fch->devices);
 	fuse_conn_get(fch->conn);
-- 
2.53.0



