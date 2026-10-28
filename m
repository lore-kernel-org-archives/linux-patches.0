Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216368;
	b=CUKdRXBwPb9Hlul+1vZCXbFRi1d4FMS5vTKKNTU7pdR7m5PSxEoNH1xQk7peTfZKfDza
	 jQnZI/olged8eWMcO60Ua9buIGECA8SRzO4WuGnBUK+fl4F9gW7wK4/6p9M+47wqVIDlI
	 PAp0nOwWi/6UlYOzpaFsPPzp1PWuL4t/IbNGqmMNUMUWrJII8TUW4KldI3Oq14y4DF+fr
	 Et5oLdR7gCxjtiS5E8woJJBj+Df4s7UwuMxXXzwp5xmBB/y2ccxJvtp+fw+b7ypDqPFY4
	 bI2n1FGWxg7bmjzLKrUw7Oo7MZyHrDbD0qfrugux9NISvTgwSMGLGZLFrQOh+gSc7AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XDqnWBhh3NW+gpycZTgAWpoujpH1kDxjPRh0gWoHqEE=;
	b=no3aUFFSPGJ0T1qOjoM2nRDk7BvqvyOwTuuDau1a0tiBr+XlWA6gXSOLg+hZdJdRaEy9
	 iiO+rhrOrNm6966HiFkcpGX56wR5w1TZwAIiLpP3oJ9DfL+jwcsyd1DbSygiFKC85Dt5b
	 bDll4TlUC4MRCwApOYywXaFd4CbeOhbdH3cELE9oBdhnCIOo+kojqloAYRnKCLMGm7UPG
	 bbfcCI0+IAppgUU7Vo2EqQuyjhrnYQD9/1aX1QIfaqE/Ha3dQObTCxlMPwbsoBHTJoFAO
	 9jwqGWqU2IghJFxIAqTdePVSgYhdtevzezZqMtZhrHizjKv86/KmODgYJ6NMOSuAygQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XBi2BHsQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22728606A31A;
	Wed, 28 Oct 2026 19:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XBi2BHsQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9381F01825;
	Wed, 28 Oct 2026 19:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216368;
	bh=XDqnWBhh3NW+gpycZTgAWpoujpH1kDxjPRh0gWoHqEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XBi2BHsQ8DnnlGWOqHvgW/hPWz5wBXg76v9sAijxv5rvqAOMbYLs/uAl0HH9GU0H5
	 JS1y/KBWxeebEZqQN5oplZg9mS7Vga7Y4V7qW625bZ2xwDrLzcKDcM12L7Mf6lMrOt
	 NAcE6XdMm58kKr28uia7liIkrxdgnu2Ew4vW0Aus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeuk Kim <jeuk20.kim@samsung.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1533/1887] NFSv4/flexfiles: fix NULL dereference for NFSv4.0 data servers
Date: Wed, 28 Oct 2026 18:00:29 +0100
Message-ID: <20261028170534.349895926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jeuk Kim <jeuk20.kim@gmail.com>

[ Upstream commit 2b03ebbf8d5e8f6af4ecd6c65375232dd1ec32cc ]

flexfiles accepts NFSv4.0 data servers, but two NFSv4 code paths assume
the data server client has a session. Unlike NFSv4.1+, an NFSv4.0 client
has no session (clp->cl_session is NULL; it uses clp->cl_slot_tbl), so
I/O to a v4.0 flexfiles DS oopses:

  - nfs4_init_ds_session() dereferences clp->cl_session->session_state
    while seeding the DS lease. It also only seeds cl_lease_time when
    NFS4_SESSION_INITING is set; without a session that never happens, so
    cl_lease_time stays 0 and nfs4_renew_state() busy-loops, requeuing
    every 5 seconds. Seed the lease whenever there is no session and
    return before touching session state.

  - ff_layout_async_handle_error_v4() dereferences
    clp->cl_session->fc_slot_table on every DS I/O error. Fall back to the
    v4.0 transport slot table (clp->cl_slot_tbl) when there is no session.

Fixes: a7878ca14008 ("nfs: flexfilelayout: remove v3-only data server limitation")
Signed-off-by: Jeuk Kim <jeuk20.kim@samsung.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c |  3 ++-
 fs/nfs/nfs4session.c                   | 16 +++++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index a5f69d1fce3fb..88140175a445f 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1127,7 +1127,8 @@ static int ff_layout_async_handle_error_v4(struct rpc_task *task,
 	struct pnfs_layout_hdr *lo = lseg->pls_layout;
 	struct inode *inode = lo->plh_inode;
 	struct nfs4_deviceid_node *devid = FF_LAYOUT_DEVID_NODE(lseg, idx);
-	struct nfs4_slot_table *tbl = &clp->cl_session->fc_slot_table;
+	struct nfs4_slot_table *tbl = nfs4_has_session(clp) ?
+		&clp->cl_session->fc_slot_table : clp->cl_slot_tbl;
 
 	switch (op_status) {
 	case NFS4_OK:
diff --git a/fs/nfs/nfs4session.c b/fs/nfs/nfs4session.c
index 5db460476bf2a..c59e710eb7ccc 100644
--- a/fs/nfs/nfs4session.c
+++ b/fs/nfs/nfs4session.c
@@ -634,16 +634,22 @@ int nfs4_init_ds_session(struct nfs_client *clp, unsigned long lease_time)
 	int ret;
 
 	spin_lock(&clp->cl_lock);
-	if (test_and_clear_bit(NFS4_SESSION_INITING, &session->session_state)) {
-		/*
-		 * Do not set NFS_CS_CHECK_LEASE_TIME instead set the
-		 * DS lease to be equal to the MDS lease.
-		 */
+	/*
+	 * Do not set NFS_CS_CHECK_LEASE_TIME instead set the
+	 * DS lease to be equal to the MDS lease.
+	 *
+	 * A v4.0 DS has no session, so seed the lease every time.
+	 */
+	if (!session ||
+	    test_and_clear_bit(NFS4_SESSION_INITING, &session->session_state)) {
 		clp->cl_lease_time = lease_time;
 		clp->cl_last_renewal = jiffies;
 	}
 	spin_unlock(&clp->cl_lock);
 
+	if (!session)
+		return 0;
+
 	ret = nfs41_check_session_ready(clp);
 	if (ret)
 		return ret;
-- 
2.53.0



