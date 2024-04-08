Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29347E111;
	Mon,  8 Apr 2024 13:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583464; cv=none; b=rUV1PdmFPkQQkYWRc+F2ec/gvwRrFQNH/bMv7Llh/rQ1HCodj2TuCVziUdgYJDOGB3QlT9iYDojvocdrfS7YuK083Re2PYsz6BEIyhGOIrmhf3uMePOfpmneO/tJQRx8J0BLxEHOKp+nNKa2BCbVnjYGtmDl7IdNIxFiEymcUac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583464; c=relaxed/simple;
	bh=1i18xejKdyUni0ljU+IHQuId+CQyub2GKi/vAaJtAHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNlIP5G8Lcy/092eSQ5lqkde6f8PS7zU11GkvCaMNkP62xMyssec+IrD2dzzY5Bc+2XwVjISoLeFJWghaTLT7tEZJ7RcQJTb3ul+GhbFa2MlV83pKN0sWsdcIDDhcWQYogJiJNGyGh7kKJk1QWyZ8fY5jNIoBYSAeYGfzbhhACs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4EHCYET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4EHCYET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BEBC433F1;
	Mon,  8 Apr 2024 13:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583463;
	bh=1i18xejKdyUni0ljU+IHQuId+CQyub2GKi/vAaJtAHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4EHCYETbO71A8KHUqjG6ywRkp5dOyiXhnxjW9s1TyBTDqJm0t9t0ymPHZ0hgSDIU
	 5TPbgZgXTWZXb9eatuXdFkeflxMEmw5EmyCyXpydK4ohAE3iB9WyUDKf0qApNSvqdj
	 BysCqFa5HVdfCkUTKptEouqgZIJ06gvs4fCvod4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 250/690] nfsd: improve stateid access bitmask documentation
Date: Mon,  8 Apr 2024 14:51:56 +0200
Message-ID: <20240408125408.664494430@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 3dcd1d8aab00c5d3a0a3725253c86440b1a0f5a7 ]

The use of the bitmaps is confusing.  Add a cross-reference to make it
easier to find the existing comment.  Add an updated reference with URL
to make it quicker to look up.  And a bit more editorializing about the
value of this.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 14 ++++++++++----
 fs/nfsd/state.h     |  4 ++++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index e14b38d6751d8..f7e2beded6d7f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -360,11 +360,13 @@ static const struct nfsd4_callback_ops nfsd4_cb_notify_lock_ops = {
  * st_{access,deny}_bmap field of the stateid, in order to track not
  * only what share bits are currently in force, but also what
  * combinations of share bits previous opens have used.  This allows us
- * to enforce the recommendation of rfc 3530 14.2.19 that the server
- * return an error if the client attempt to downgrade to a combination
- * of share bits not explicable by closing some of its previous opens.
+ * to enforce the recommendation in
+ * https://datatracker.ietf.org/doc/html/rfc7530#section-16.19.4 that
+ * the server return an error if the client attempt to downgrade to a
+ * combination of share bits not explicable by closing some of its
+ * previous opens.
  *
- * XXX: This enforcement is actually incomplete, since we don't keep
+ * This enforcement is arguably incomplete, since we don't keep
  * track of access/deny bit combinations; so, e.g., we allow:
  *
  *	OPEN allow read, deny write
@@ -372,6 +374,10 @@ static const struct nfsd4_callback_ops nfsd4_cb_notify_lock_ops = {
  *	DOWNGRADE allow read, deny none
  *
  * which we should reject.
+ *
+ * But you could also argue that our current code is already overkill,
+ * since it only exists to return NFS4ERR_INVAL on incorrect client
+ * behavior.
  */
 static unsigned int
 bmap_to_share_mode(unsigned long bmap)
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index e73bdbb1634ab..6eb3c7157214b 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -568,6 +568,10 @@ struct nfs4_ol_stateid {
 	struct list_head		st_locks;
 	struct nfs4_stateowner		*st_stateowner;
 	struct nfs4_clnt_odstate	*st_clnt_odstate;
+/*
+ * These bitmasks use 3 separate bits for READ, ALLOW, and BOTH; see the
+ * comment above bmap_to_share_mode() for explanation:
+ */
 	unsigned char			st_access_bmap;
 	unsigned char			st_deny_bmap;
 	struct nfs4_ol_stateid		*st_openstp;
-- 
2.43.0



