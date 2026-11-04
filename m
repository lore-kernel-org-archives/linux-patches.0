Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829007;
	b=izQQ2hgbNgDZXtKLadFWzSCgzrj1P+dJu47MBIsjVd4Hlp+2XR5NK8JyJ4l7BOtAoKMJ
	 4k1IpRWClsu8H+qzI0sdIvTnXaozmUde2GC3gdnCbMFyrRVqYdSs/8U25ZhRK7ZPXj9kw
	 hqQMtXKAiToLyRbpqVfrbSQ3jqVK6rx7wGuqbJA1q5nIUAUjZDms1r1NqRd8yE+G8w8dj
	 CjObqrKhA9eFfcyUiytznWl/LyZkC2iECrcXUYEYBUvjnNxZBRK/DXSJekx3K+GjVUeSE
	 b7g+he3Ky61tTyJDIcS83SixGaSAUbkA+QgMIJKtW9wKssplmesPJzaQ7BK71/dJHbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tx49FmGV+NvJDKS3otuN6SIzZe9E0EUV9tDUHOd1Nb4=;
	b=wrUoiQ+PKLwyuyFWQg6we7BdLMG8tDcsLgy9S5pUAfp06YjS8KltqreJoj7D+zIP0cTt
	 nF3sjlbisemAX7dYDUmcdM9ytpq60LbuFbbJ0A6MUOBXD8Lsh78/GbZX4AYVskI6vp2tl
	 byg69xX/00AqNBoHTBGT7IS/WVk/RLUTFpINsJZYRtkC6VYY91PXyA3LenPMpGT/UIQPf
	 jiZwAZxelwdpp2lnCpu4lpqnjY3iGzdnVuMwMUUG6+X1swCNxloprl4Wtr6ORtEIGGm/6
	 rr0yqo1WR6gwIYihtCAsEhMbnu/nTZ41ocWKSHv6F6wwP58umbOClAHVHV6mDWqbOEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N6tjhV58;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657A36070332;
	Wed,  4 Nov 2026 21:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N6tjhV58
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0968D1F000C1;
	Wed,  4 Nov 2026 21:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829007;
	bh=Tx49FmGV+NvJDKS3otuN6SIzZe9E0EUV9tDUHOd1Nb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6tjhV58vzOpCa/GmoxNDSXHBqCBO2W5O5yucb6JnwmZ4r4MP++k8uGYIgYzVNKIX
	 YmAuOysTfzIJUwuKeUMJ+g7XiREV9rtdDP+3vyK3dzsPUFo9AhczGQkP7Lu++0Je1u
	 JtkGVJx57pJWwIGbTuyVHokZUF+oNS+u3kstif8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.3 384/547] smb: client: reclaim credits for decrypted reads with no matching mid
Date: Wed,  4 Nov 2026 16:09:28 -0500
Message-ID: <20261104211049.206111775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 78f73985846465a25a7bd1d89904053661f3ca92 upstream.

When a decrypted SMB2 READ response carries a MessageId that matches no
outstanding request, both the inline receive_encrypted_read() and the
offloaded smb2_decrypt_offload() paths drop the frame without accounting
the credits the server granted in it.  The plaintext unknown-frame path in
cifs_demultiplex_thread() already reclaims them with
smb2_add_credits_from_hdr(), so encrypted reads leak credits that the
plaintext path would not.

This also happens for legitimate frames - e.g. a reply that arrives after
the client has timed out and dropped the mid - so over a long-lived
connection the client's credit count drifts down and can eventually starve
it of the ability to issue requests.  The frame is AEAD-authenticated, so
the granted credits in the decrypted header come from the real server and
are safe to apply.

Reclaim the credits from the decrypted header before dropping the frame,
and export smb2_add_credits_from_hdr() so the SMB2 receive paths can use it.

Fixes: c42a6abe3012 ("CIFS: Add capability to decrypt big read responses")
Fixes: 35cf94a39728 ("smb3: allow parallelizing decryption of reads")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsproto.h |    1 +
 fs/smb/client/connect.c   |    3 +--
 fs/smb/client/smb2ops.c   |    6 ++++--
 3 files changed, 6 insertions(+), 4 deletions(-)

--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -131,6 +131,7 @@ void cifs_signal_cifsd_for_reconnect(str
 void cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 					   bool mark_smb_session);
 int cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session);
+void smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server);
 bool backup_cred(struct cifs_sb_info *cifs_sb);
 bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file,
 			    bool from_readdir);
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1238,8 +1238,7 @@ cifs_handle_standard(struct TCP_Server_I
 	return 0;
 }
 
-static void
-smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
+void smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
 {
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buffer;
 	int scredits, in_flight;
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5288,9 +5288,10 @@ static void smb2_decrypt_offload(struct
 
 	dw->server->lstrp = jiffies;
 	mid = smb2_find_dequeue_mid(dw->server, dw->buf);
-	if (mid == NULL)
+	if (mid == NULL) {
 		cifs_dbg(FYI, "mid not found\n");
-	else {
+		smb2_add_credits_from_hdr(dw->buf, dw->server);
+	} else {
 		mid->decrypted = true;
 		rc = handle_read_data(dw->server, mid, dw->buf,
 				      dw->server->vals->read_rsp_size,
@@ -5421,6 +5422,7 @@ receive_encrypted_read(struct TCP_Server
 	*mid = smb2_find_mid(server, buf);
 	if (*mid == NULL) {
 		cifs_dbg(FYI, "mid not found\n");
+		smb2_add_credits_from_hdr(buf, server);
 		rc = -1;
 	} else {
 		cifs_dbg(FYI, "mid found\n");


