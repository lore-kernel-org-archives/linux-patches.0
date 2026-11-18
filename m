Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044103;
	b=AzvSZ9OPOgWwaM7pDaTL6G9XVgLRp3vOUtZC1H8ATAWzxLlk4cvZx3JqkdROIpeh1q6r
	 tgikh0G3s9daXwCgCGFw6SiZPTR6NaQpnktEnz7mBBrkPe+hgncJECK8dFXLHl8LFLnXb
	 eSY97VhWjZtVTQRN2xqJb63qv8w/TVAFnTUwZyrnwIJGj8bhkf/g4QnoqXFQcd3CLMO4Z
	 TBsLCr6DZV8lBZS7RViDenB6c3R9+jc7/cQlT9+I/aM3rMvyONU/nS7nDDtwOUC3NiOPm
	 8D5mOdQMVspkP0TyDw0Woa1UA+XzozCUEj35x6AfgVz4hBVtk5ZjgO2lzSXF63QLd+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qb72L4vec3wYo5zIOUMODj8N8qPXlisqnruFTjisIw8=;
	b=mZrklgQmkhgR+lRjiu0vccUJHQ9fGL5scWgUGaQ14p4jaU7OyucK+M4W/tGflq6+uiv4
	 wZAw5Kna7u8gYoDmmzvb45+Fo0lGV5kMbK1hdpxFU/R47FpMDNDdrHfusqhg1n5qQPXr5
	 ZBmk+4z5E6EL8DdcHuzVwQSA/mCWQoYidOe6saA0Fi/rzifZ0/BVBiXZMjfGcFhlMRi+s
	 XJajzZYup0rPMTmI+4RmjC0cuTuLJJToi58cHovyu/FIJyFG7Xoom1qSELv8nRcFIUtX0
	 EUP+IViNr5BKkAMnGG/OBG3wtm5mb8EOALUx0OTU3hQaSyI67knZuoRqrOML+5HLsZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cbwvm90s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61E3606A31C;
	Wed, 18 Nov 2026 23:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cbwvm90s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDBB1F000C4;
	Wed, 18 Nov 2026 23:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044102;
	bh=qb72L4vec3wYo5zIOUMODj8N8qPXlisqnruFTjisIw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cbwvm90sxLFC2oQFe6Pi1krCQPNt6brqfp/5OK0DRyEReuTZKGb90lUEFl7SCtRGX
	 N6hhfbbtBoh8yrwlCi/bZbcgThYJ3TxWoqu45JQjdvQd7jy6h84SzlxvrNXXQUn1gB
	 6oBmvVOOC6xz+MHhVpeq3KmNLfQkJ2HzyFULwgdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0447/2857] smb: client: clean up failed cached directory opens
Date: Wed, 18 Nov 2026 15:24:41 +0100
Message-ID: <20261118150217.473114721@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

[ Upstream commit d2ff5fb93ea83034025850266b5eed391f96b825 ]

open_cached_dir() sends CREATE and QUERY_INFO as a compound request. If
the CREATE succeeds but a later command returns an error, the function
must retain the CREATE FID so common cleanup can issue SMB2_close(). It
also must not treat a response error as a valid CREATE.

Validate the CREATE response before using its fields, record the FIDs, and
mark the handle open before handling errors from later compound commands.
Move the -EREMCHG reconnect handling before response validation so a
missing response does not hide the reconnect request. Count the handle
when it is marked open; confirmed close responses decrement the counter,
while existing close retry behavior remains best effort on transport
failures.

Fixes: b0f6df737a1c ("cifs: cache FILE_ALL_INFO for the shared root handle")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Tested-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: Kept rc = -EINVAL; before the non-lease oplock check and changed the smb2status.h include to the local header path, since this tree lacks the earlier cleanup and the common/ header location. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 3ff56321b7a1e..f770615418b8f 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -8,6 +8,7 @@
 #include <linux/namei.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
+#include "smb2status.h"
 #include "cifs_debug.h"
 #include "smb2proto.h"
 #include "cached_dir.h"
@@ -277,24 +278,37 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	rc = compound_send_recv(xid, ses, server,
 				flags, 2, rqst,
 				resp_buftype, rsp_iov);
-	if (rc) {
-		if (rc == -EREMCHG) {
-			tcon->need_reconnect = true;
-			pr_warn_once("server share %s deleted\n",
-				     tcon->tree_name);
-		}
-		goto oshr_free;
+	if (rc == -EREMCHG) {
+		tcon->need_reconnect = true;
+		pr_warn_once("server share %s deleted\n",
+			     tcon->tree_name);
 	}
-	cfid->is_open = true;
 
-	spin_lock(&cfids->cfid_list_lock);
+	if (!rsp_iov[0].iov_base || rsp_iov[0].iov_len < sizeof(*o_rsp)) {
+		if (!rc)
+			rc = -EIO;
+		goto oshr_free;
+	}
 
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
+	if (o_rsp->hdr.Status != STATUS_SUCCESS) {
+		if (!rc)
+			rc = -EIO;
+		goto oshr_free;
+	}
+
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
 	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
 #ifdef CONFIG_CIFS_DEBUG2
 	oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
+	cfid->is_open = true;
+	atomic_inc(&tcon->num_remote_opens);
+
+	if (rc)
+		goto oshr_free;
+
+	spin_lock(&cfids->cfid_list_lock);
 
 	rc = -EINVAL;
 	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
@@ -367,7 +381,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		free_cached_dir(cfid);
 	} else {
 		*ret_cfid = cfid;
-		atomic_inc(&tcon->num_remote_opens);
 	}
 	kfree(utf16_path);
 	return rc;
-- 
2.53.0



