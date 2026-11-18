Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043566;
	b=imRjPqdH+4plCVbHkBpphp3HSHRrXDjVDtFlhy1x8kkeUdZ74SZMNDgFBlFFhMqRYiiZ
	 h7vDAY02GNsfoyDvSpTUXbj4earXRGFNaA5aKHLwuh8k9Fs0TIVRrO0zJ7ExuW1zIycLz
	 Ljy0q+cgp3DBv5wKy3tIPT7qOncWvkq3Yo3S3TdsR2DNKa/mqOg4xF5XXUW5ZRO3mSxvX
	 1/fYUttSp8MbAIC5xfEQ8pQvx/VyFpOpbuEhtYv718eafCH9K64DUC9j3rd63U/7Yj/3q
	 5HgO9wQY3wDzTHza4anXerELyjKWY7YphtR9ejcIuYHESC1zU5abgpt3MkN6ILsrplg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rL7uVgaM/xJCFqUqsYRlOxUEnKpSrDdUPx2KqCQ4k3Y=;
	b=ErgDPAURKnDOdweDm8PYKZZQ0JGALRoo17ADOtauKSTzpgKdWlt/3VUCUHAZClFHnxsA
	 xXqd/VJ1gkoM1bX9H3b5A+mS4/KA9f1xzOxI68CirvEOZuIkCsdIHtUYXZiFHatW63o7h
	 6BuXB7mymIydCC+ijZr2OWoRKx3o/OuDqq7IHDz0/eqEAxEgPbWx3pGUwsp/U9i6HNUcY
	 08wJF0XKCDL8VMrFNuZBOuJ6OCK11zZXA+AKFAA+AZyRjt+Eh9jngrht+GUq9AHr00a/Q
	 mxtYbpwRfsRnVv+lz9SM/88cUISvMBbWFnlcDWLNL+LK0Xn4XJH64rBNmEtnmYGmjAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zgb+MrNb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F83606A320;
	Wed, 18 Nov 2026 23:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zgb+MrNb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25951F000C4;
	Wed, 18 Nov 2026 23:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043566;
	bh=rL7uVgaM/xJCFqUqsYRlOxUEnKpSrDdUPx2KqCQ4k3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zgb+MrNba6hVLptYOzfCL4c6E4kNtK1xwI0qTEXtdZtT/XJuCbTDSxcrlA+jbR3+V
	 WANPsAQ6JYv8zedkI3Zwal0rIs9oepQF9N3F+WFzVHYX7B9AKIVpdr+XgbZjVEpcWA
	 eLblricRAT6xK08T6KBqncyreEXdjMhJF3bDQ5Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0256/2857] ksmbd: notify parent directory leases on child create
Date: Wed, 18 Nov 2026 15:21:30 +0100
Message-ID: <20261118150210.651512667@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit abe5acb34282206c2a6303d0e09b3165b1addf0e ]

BVT_DirectoryLeasing_ReadWriteHandleCaching requires a parent directory
lease break notification when another client creates a child in the
leased directory. A child CREATE without a lease context did not notify
the parent lease holders because the notification path expected a
non-NULL lease context.

Allow the parent lease notification helper to handle a NULL child lease
context and notify matching parent leases. Invoke it after a child is
created without a lease context while preserving the existing lease-key
filtering for requests that provide one.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c  | 9 +++++----
 fs/smb/server/smb2pdu.c | 3 +++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 932e31a20216e..325d9a55ca657 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1175,7 +1175,7 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 	struct oplock_info *opinfo;
 	struct ksmbd_inode *p_ci = NULL;
 
-	if (lctx->version != 2)
+	if (lctx && lctx->version != 2)
 		return;
 
 	p_ci = ksmbd_inode_lookup_lock(fp->filp->f_path.dentry->d_parent);
@@ -1188,9 +1188,10 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 			continue;
 
 		if (opinfo->o_lease->state != SMB2_OPLOCK_LEVEL_NONE &&
-		    (!(lctx->flags & SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE) ||
-		     !compare_guid_key(opinfo, fp->conn->ClientGUID,
-				      lctx->parent_lease_key))) {
+		    (!lctx ||
+		     (!(lctx->flags & SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE) ||
+		      !compare_guid_key(opinfo, fp->conn->ClientGUID,
+			       lctx->parent_lease_key)))) {
 			if (!atomic_inc_not_zero(&opinfo->refcount))
 				continue;
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 33e0316fe9182..1c13f359ac0cf 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3315,6 +3315,9 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 		}
 	} else {
+		if (created && !lc)
+			smb_send_parent_lease_break_noti(fp, NULL);
+
 		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE && lc) {
 			/*
 			 * Compare parent lease using parent key. If there is no
-- 
2.53.0



