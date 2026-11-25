Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624755;
	b=Er0vBVGkhwHUD+ynD+/3VticIWj12KycC4vVFZGSZ25jGYDMRyhrWdaT6Jt4eRFebXlY
	 /BS/kTtq32NWvjR7DEM3E+xsDxLQqpfQJtSNCKbSoBJBYjSUCDaMryc0PV1gh1QLquN0L
	 holYjBgNs8r305PqtPZFHmCx7AE6lvIdWnf3MKUKKnYME64ufwQSlPPYDTdD36U2zP4yS
	 4sn30f28pRkbK7+VzXHl4zYsFF6hQrjTpV9arMPWOYoNJI0kJ+kEw7dnQmSym6DwDvKr2
	 CnFR7T+jS8aMab7QZ00AvO0g34wTj+L5iOvSPazj/qzfVooUm49P/2h3Uen9jwFF+BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V4yVAmtcbvTA0Gg9mksEGB4OX8BRNgc2tCVWcl3Lh5E=;
	b=AhGbIXYPJqz04l3GXyS5JP7eyZn6k/0GhQKmzsJggAkgqKzPdVzuv3UhJUwaQOivG3bk
	 95u7h7x6oNCEwrKvdxjl5wAIuOZpauqIfYJSn8Ye96h5IpHiVSHq8gtlzGeWDPgO3YWLZ
	 RWusN+65pVgBEGdq4ygNKNcmZEZ8iXpY82cBXudz9eexrguUdteFLr9TNzq/rf5jZs1Wm
	 7kCk8tlWq3YOfwIqkzQOQsp8/mm4j0bAJaI/oumG1k7xumnjqRruq1MTSqlLtQzeErasW
	 CsoqTouTcH1Nhtt7VzlBsxRuMlOMpQpZBE7WjqjmV+xQnCcZiDKmo0n0wmb/pPdFX+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gHWPON7c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525DE606A33C;
	Wed, 25 Nov 2026 16:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gHWPON7c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DC91F000C4;
	Wed, 25 Nov 2026 16:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624755;
	bh=V4yVAmtcbvTA0Gg9mksEGB4OX8BRNgc2tCVWcl3Lh5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHWPON7c9Pheed8DhqvZGqco5tcnFPJUceSo22wNFgiaH75a5lSrvWgY0ukykczT+
	 jfyU6hWi+U8uQ2x0tjAMHAqEDop6dtkZg4DdBTF5rs0yHisko1hDPPSD/eXjKxp9xC
	 jIH/mzIoxpXZWqxsbXatTskHpIsFD435eQe6UFsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 297/816] NFS: update ctime for atime-only UTIME_NOW requests
Date: Wed, 25 Nov 2026 15:30:45 +0100
Message-ID: <20261125143856.080991458@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index f29c4ff16b29f..016c19906bf1e 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -747,7 +747,7 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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



