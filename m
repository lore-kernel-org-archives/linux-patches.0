Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621946;
	b=to6bfU0g+TKnF3LqoURh7AOPNQfwUDVF/veBo3RvkrfYOF/UW3MbLAGg+QDm4bjC1aOj
	 HB/sLxKc+P6hHTz5Da2nmkP6QK0D2S+wNYV8Xf043HzTxEC0fzzbJq3gnIDzrGtbYolVS
	 vJBaKpIxi08Jwd5p4zdZ302vQyl5UKNn6sfMJQI2jdptf8IQ1k9FEAz2R0gGXjLMhD6yD
	 8wDRxKh08ldw1EZugZ9zOR34nbCia54ixw1FZP/SpUKk3aE0VzRcWY1mvhH7UxAWzJTh1
	 rV8EF7+y22VXn9FROrOmt4VQb/BIGlAVzFdIMkgXHbQeK7Bz8pxiRckecpqf5EXhXbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XuTEi/SNv6XQpd1yeF2D04BahvD79NUkvwUU3k0OGuc=;
	b=2LPCzoq/BqoOfhuyEX6Bqu16/8ndKUK6vCSx99dllLBkbGEmq31kOni8PDAOxVZwi8sj
	 jLC+ifuKCFbGNvFfcPDyOCd/03GSoyWHOxBC0uEmTk3oFS846J3+QJIjxMPKDCkVxqcBN
	 p3DR2bNwUvv/WhJ9zZrm7Mqt0zo8hGgbVonvPIralnHHowv3lEbB18/pRGC1L/Mix1o7e
	 PT6pkx/w4LyixoBoU05qt3e190Q05Vw6lMjGRj0uovsPR1OenJFK5/DIcpSIxP6WZnhHJ
	 Zp6Ma4rxMT+R0NiV1qb1JwPgDu4x1kQc262VE7xqDscQcY+exQCDzIiGUBiB3wxLB/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ohPS9Cmw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BBF606A321;
	Wed, 25 Nov 2026 15:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ohPS9Cmw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C071F000D4;
	Wed, 25 Nov 2026 15:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621946;
	bh=XuTEi/SNv6XQpd1yeF2D04BahvD79NUkvwUU3k0OGuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohPS9CmwYoabaWhmxklzu1ZnKidjV4j4j0mN1/NZF7/xETMojy0AMR/ZFzku4DZ0K
	 hZXZrgETB564kSSe5LKWSVtSBDfi/f+02mhCmeppf1qKoxxDNF3X6/uHyZyy878RDR
	 8HR+kNmw9B4pnNP6mkFS/5HhEL+G+JQSxL+TuahY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 381/990] NFS: update ctime for atime-only UTIME_NOW requests
Date: Wed, 25 Nov 2026 15:29:08 +0100
Message-ID: <20261125143831.018793901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit a38d7cc8c90f0d093550487c2905b51db0be1522 ]

When an NFS client holds a timestamp delegation, utimensat()
with atime set to UTIME_NOW and mtime set to UTIME_OMIT reaches
nfs_setattr() with ATTR_TIMES_SET but without ATTR_ATIME_SET.

There may be other paths that can reach here as well.

The delegated-atime fast path treats this as an implicit atime
update, clears ATTR_ATIME and returns success without updating
ctime.

Add check for ATTR_TIMES_SET along with ATTR_ATIME_SET (OR) so
explicit timestamp requests use the normal SETATTR path while
incidental atime updates can keep using the local shortcut.

Fixes: e12912d94137 ("NFSv4: Add support for delegated atime and mtime attributes")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 1edc11cd286aa..f985bf55a4d51 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -758,7 +758,7 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	} else if (nfs_have_delegated_atime(inode) &&
 		   attr->ia_valid & ATTR_ATIME &&
 		   !(attr->ia_valid & ATTR_MTIME)) {
-		if (!(attr->ia_valid & ATTR_ATIME_SET)) {
+		if (!(attr->ia_valid & (ATTR_ATIME_SET | ATTR_TIMES_SET))) {
 			nfs_update_delegated_atime(inode);
 			attr->ia_valid &= ~ATTR_ATIME;
 		}
-- 
2.53.0



