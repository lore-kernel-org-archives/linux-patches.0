Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774214;
	b=z0RSWSKFfvBrx/p82wW4Q7Kd48LncPFDGfR3BRGNgim6nOcFP/2TycqTRgVC0N4RtZr/
	 SePAHjoE6x4ORsAEvWJiPwzA1HtHz5102jHrHj/hGt7CiyQWbYOEoZG8RLiKu+ZOPq7MG
	 TNddkcARJYd9dkcC3+ZjCXtgiYWn4JEzzjGY6wOUlRP+u5E0ZpLXscKy0v7Lqd7VE9ZVX
	 u800SeBH1TATNBy9p6P9kHOCIkPNNTIzblW/UeGoo+q+JXNs4RzOidGbZ4Hk+tk2BQjNU
	 iOz/B+L9h9UiAhJZ96QSbTe/QHPNwqLrTclIfkr21Lgc/akJlcr/5imlo5FXe/MdczA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2xz6xWEgTVRls5qZx4DFWGqU5ozFRg/Plf8sOHBRTks=;
	b=GX7Uo+j00U8dIpwH9kXTs+MFctyNF85lO25FSLVz/nKt7K5OQxnywpfoZ8Ke7BadwBcm
	 QY7tpwH/7W3Gp87+bXcfRTtyNI+u12oeapEcwnvEJp6e9M2Niauy7m+vvCWsUSuEdBU6M
	 xEwkUHqUS54403bkF04aqGT/O+/CvQsBNmcTvlWPsedzdY4uKo76Uj4o9xF0qkTsql4O5
	 T3Npzw0C4YoTJyaoLAH93cGhAkaI9pbPOTdHc5OW5lVuEMuT7VWG7J1K3d1nbEZreVNX9
	 F6ySFJ4dAzshMWhjledrxCVm6MIg/SRY+ZQI8hl8eauoM+IgqipSCrIDaeOTMOyxGzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0gIIBINc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E54606A31A;
	Fri, 23 Oct 2026 16:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0gIIBINc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1DE1F01825;
	Fri, 23 Oct 2026 16:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774213;
	bh=2xz6xWEgTVRls5qZx4DFWGqU5ozFRg/Plf8sOHBRTks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0gIIBINc6pcoqM/Ylu3RAh6R7y5pAVZ/9Pup5q1Bo/baclnJrQSWatE7lz8M//8vO
	 rJYnGG85Co4SnPp3XrfUXCGzIyLmPIfRf5P38/PmETXvYJ46L4AJD9na9Cu/Zxe5JO
	 v+9NLkRp33BhXBukdnphctqXvK77HTNwIDnJyJvg=
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
Subject: [PATCH 6.18 159/193] smb: client: fix multiuser mount with krb5
Date: Fri, 23 Oct 2026 18:37:16 +0200
Message-ID: <20261023163717.970325341@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4224,14 +4224,25 @@ cifs_setup_session(const unsigned int xi
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
@@ -4271,7 +4282,7 @@ cifs_construct_tcon(struct cifs_sb_info
 	ctx->dfs_root_ses = master_tcon->ses->dfs_root_ses;
 	ctx->unicode = master_tcon->ses->unicode;
 
-	rc = cifs_set_vol_auth(ctx, master_tcon->ses);
+	rc = set_fs_context_auth(ctx, master_tcon->ses);
 	if (rc) {
 		tcon = ERR_PTR(rc);
 		goto out;


