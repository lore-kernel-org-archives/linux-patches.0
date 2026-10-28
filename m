Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214873;
	b=aMZMiKxpRO12ZFiDrOk30x3yRtE1EWP0SDYFKDWCpZ/szXaCjU6LfAutiZw1D3ndV2fJ
	 tAgEs0729T26ugW/cAxb2J/8NPEdh6PpLhNv+kdtYYN2o+F5gCfZQCK1BTfokA810Thof
	 VTVNz7880Zn99T5RByT2maXbbVAvVDq0PPixMgQsu4djfXkItGk0NEmmTjgsm/6pHCyWk
	 tpZQWfOw9Y45tKa+n/WPRrOe4PSzOcZnSip/8WFcY3yzRhrN5WgGbnGBphoYqWIoTW5yp
	 2CgmLY10b8Vbk5ypOi6VZPVzv4CHfROs3Y4H6RqZCAB7VL/oDZXjT7MdkyDxMq4N/VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K0NZt925vCsn43K2ha9rQMmx2VE3rovR5+r5FHlgldc=;
	b=i4XEff4uJ12l2y2EQz9BzxKypdVvGqCH+ye8bBPcjP+h7s42wlygQ89vsHOs8WiZkWPI
	 9UrM3iJt609Rzk0O0xNaxB+Hd5jYxCX1QtS+j0/VMezJtyjtDCTYisBInl8bZGPL1yP/B
	 rpbrJRRNQQd8PXjs3N7ssuBkllGyQv7yqDZ0LorI2KmmP7SoksxCct0BA3nqziOBuE0Dy
	 rE/ScNM8XGWCCKW716GVEoAcy3sHcXt+ULkxJqvwqlJCYbyD6cqb5sdB74ckQjY83Zkcn
	 TPgqKizSuL4k1CA1AhOIwM1LI2WwEgEQLdIyfIHoCQNx1wcaYIB6mkc7jWV76cvkJbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJYqKPyT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23CD606A32A;
	Wed, 28 Oct 2026 19:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJYqKPyT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F240C1F01825;
	Wed, 28 Oct 2026 19:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214872;
	bh=K0NZt925vCsn43K2ha9rQMmx2VE3rovR5+r5FHlgldc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xJYqKPyTT+BX9vmBuLW3G2cDVcqTWzXRVZQyC6UyVHn3Ui+UlXg59jOMtQvMYIJq6
	 iYk6ZkNcnMHRUpatsZQauZKYsLeMiIGwrRO4G1h2NxTU1Em/TiHcCrclQBftZo3GIA
	 hjAdwC7oYHdO5/dzC+mTILzAf4tvFpCzVYeP0YGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0995/1887] cifs: Fix locking usage for tcon fields
Date: Wed, 28 Oct 2026 17:51:31 +0100
Message-ID: <20261028170522.056695225@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 96c4af418586ee9a6aab61738644366426e05316 ]

We used to use the cifs_tcp_ses_lock to protect a lot of objects
that are not just the server, ses or tcon lists. We later introduced
srv_lock, ses_lock and tc_lock to protect fields within the
corresponding structs. This was done to provide a more granular
protection and avoid unnecessary serialization.

There were still a couple of uses of cifs_tcp_ses_lock to provide
tcon fields. In this patch, I've replaced them with tc_lock.

Cc: stable@vger.kernel.org
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2misc.c |  6 +++---
 fs/smb/client/smb2ops.c  | 10 +++-------
 fs/smb/client/smb2pdu.c  |  2 ++
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index ecab56c00f627..27d0fc56cd825 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -847,14 +847,14 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 	int rc;
 
 	cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&tcon->tc_lock);
 	if (tcon->tc_count <= 0) {
 		struct TCP_Server_Info *server = NULL;
 
 		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 				    netfs_trace_tcon_ref_see_cancelled_close);
 		WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative");
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&tcon->tc_lock);
 
 		if (tcon->ses) {
 			server = tcon->ses->server;
@@ -868,7 +868,7 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 	tcon->tc_count++;
 	trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 			    netfs_trace_tcon_ref_get_cancelled_close);
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&tcon->tc_lock);
 
 	rc = __smb2_handle_cancelled_cmd(tcon, SMB2_CLOSE_HE, 0,
 					 persistent_fid, volatile_fid, false);
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ef61a60a082ef..a59df97b55282 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2863,7 +2863,9 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 						struct cifs_tcon,
 						tcon_list);
 		if (tcon) {
+			spin_lock(&tcon->tc_lock);
 			tcon->tc_count++;
+			spin_unlock(&tcon->tc_lock);
 			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 					    netfs_trace_tcon_ref_get_dfs_refer);
 		}
@@ -2928,13 +2930,7 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
  out:
 	if (tcon && !tcon->ipc) {
 		/* ipc tcons are not refcounted */
-		spin_lock(&cifs_tcp_ses_lock);
-		tcon->tc_count--;
-		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
-				    netfs_trace_tcon_ref_dec_dfs_refer);
-		/* tc_count can never go negative */
-		WARN_ON(tcon->tc_count < 0);
-		spin_unlock(&cifs_tcp_ses_lock);
+		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_dfs_refer);
 	}
 	kfree(utf16_path);
 	kfree(dfs_req);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c50881cf4c8d7..8f23b8968beb4 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4025,7 +4025,9 @@ void smb2_reconnect_server(struct work_struct *work)
 
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->need_reconnect || tcon->need_reopen_files) {
+				spin_lock(&tcon->tc_lock);
 				tcon->tc_count++;
+				spin_unlock(&tcon->tc_lock);
 				trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 						    netfs_trace_tcon_ref_get_reconnect_server);
 				list_add_tail(&tcon->rlist, &tmp_list);
-- 
2.53.0



