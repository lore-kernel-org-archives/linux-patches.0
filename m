Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207807;
	b=V81I9clx8A/dDEDGyYdzkFLu4XMYUnVbm0ol9Qae1HXcaCG3hfhZs7usYFPoRNPyFGAO
	 MXkszbI/FY+QizlotN8f7GTcqkvogkR1DpzayOctqKgI1tgdQa7JyE5zdeGmu98XZv6bV
	 bmvStq9XxsqLJrz17mLZIbRqDCrGss5K7B4linPhRGLqZ6TjmJd3aEoIH+C33QV09/I0Y
	 y3KaIGdmXjIAlc+5rKeINW6f/T9/9HS75ty3nJa4j+HQURIEwbfTyroeEqv1JdnAaZAID
	 kojMBWr/Ql+0eWTQWtGZIT4/R9ftDTydMCLQfkx0aTJBUDoRTEKbHz9yQWiphP29gOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GNDGkzf/yyLxUwC12Jc5OId9kCSj7k6CowNcI6xA5lY=;
	b=dEAbo/kyE8Gex7PmseN2i58Xbs9dIPcZADepvcICimnh//1fl2tGJ3JSb4Yk3lqKmVoQ
	 9I4ttXQuGw6Raggz66j6FLOUtA2D3C7Gz96aAF90SXDmp2U/JTtA51KYQMnVWQFOZZxJj
	 M56FNHk9rRpfIl8U1xm4kCCmcObL7j6rOmW7P6ifLkYhweaUw7wLgW4MCyKos/owu8Wu/
	 WbLEfQukdRv0d+izWr88FvwWK4at3oLICL8A4D3HseuliUb90ocg6zrl1RXmUo1E27Dw6
	 jh5hz/dPx+0QXlHGdYgZ5y1PO28R88jWT013DJ+7P6b741K0YL44VkE0vr1w19S8hFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RwrRm4Ti;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43E5606A31A;
	Wed, 28 Oct 2026 17:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RwrRm4Ti
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483E21F01825;
	Wed, 28 Oct 2026 17:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207806;
	bh=GNDGkzf/yyLxUwC12Jc5OId9kCSj7k6CowNcI6xA5lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RwrRm4TizP8ZY+8pjqcMYZI+3WCIhSKcx2nYIy14DJSKeTJBpo2wwod+LvYGRapRw
	 GEbFttJPcmds0PmdyMJhcftG/VbQx4uNFzE4QXb4BfZEHAdJkxLyJMWhTShlbWUTpK
	 pjgUlZFSJA+pCawnG8rvGc+5mizv/k3lLbR/R4/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Shivers <jshivers@redhat.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 129/247] smb: client: fix multiuser mount with krb5
Date: Wed, 28 Oct 2026 17:58:52 +0100
Message-ID: <20261028165950.459310896@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 69499395867332364ed4ac8b546537eb3bab6ebb upstream.

Customer reported that they could no longer mount their SMB shares
with multiuser mount option and krb5.  Turned out that the client
wasn't duplicating username option when creating multiuser
connections, therefore failing to retrieve credentials as
cifs.upcall(8) couldn't find them in keytab.

Fix this by duplicating username option (if set) from original fs
context before creating multiuser connections with krb5.

Reproducer:

  ```
  $ ktutil
  ktutil:  add_entry -password -p testuser -k 1 -e aes256-cts
  Password for testuser@ZELDA.TEST:
  ktutil:  write_kt /etc/krb5.keytab
  ktutil:  quit
  $ klist -ke
  Keytab name: FILE:/etc/krb5.keytab
  KVNO Principal
   ---- ----------------------------------------------------------------
     1 testuser@ZELDA.TEST (aes256-cts-hmac-sha1-96)
  $ mount.cifs //w22-root2/scratch /mnt/1 -o \
      	uid=1000,sec=krb5,username=testuser@ZELDA.TEST,multiuser
  mount error(13): Permission denied
  Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and
  kernel log messages (dmesg)
  ```

Reported-by: Jacob Shivers <jshivers@redhat.com>
Fixes: 12b4c5d98cd7 ("smb: client: fix krb5 mount with username option")
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4151,14 +4151,25 @@ cifs_setup_session(const unsigned int xi
 	return rc;
 }
 
-static int
-cifs_set_vol_auth(struct smb3_fs_context *ctx, struct cifs_ses *ses)
+static int set_fs_context_auth(struct smb3_fs_context *ctx,
+			       struct cifs_ses *ses)
 {
 	ctx->sectype = ses->sectype;
 
-	/* krb5 is special, since we don't need username or pw */
-	if (ctx->sectype == Kerberos)
+	/*
+	 * krb5 is special as we might need to pass username (passwordless) down
+	 * to cifs.upcall(8) for keytab.
+	 */
+	if (ctx->sectype == Kerberos) {
+		if (ses->user_name && ses->user_name[0]) {
+			ctx->username = kstrndup(ses->user_name,
+						 CIFS_MAX_USERNAME_LEN,
+						 GFP_KERNEL);
+			if (!ctx->username)
+				return -ENOMEM;
+		}
 		return 0;
+	}
 
 	return cifs_set_cifscreds(ctx, ses);
 }
@@ -4197,7 +4208,7 @@ cifs_construct_tcon(struct cifs_sb_info
 	ctx->witness = master_tcon->use_witness;
 	ctx->dfs_root_ses = master_tcon->ses->dfs_root_ses;
 
-	rc = cifs_set_vol_auth(ctx, master_tcon->ses);
+	rc = set_fs_context_auth(ctx, master_tcon->ses);
 	if (rc) {
 		tcon = ERR_PTR(rc);
 		goto out;


