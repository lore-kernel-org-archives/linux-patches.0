Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE349388890;
	Tue, 21 Jul 2026 19:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663187; cv=none; b=A2xgznGLQrkFakQP8Tqrr6GPhphlkiMOdrTtKjaZEZisvDioBFzyISJ20Jv7lSX2Oca0caAajszPRpu/l51CK8MDgTuwcvSmVffgS0I4tgemvrrlQLfW8pZucuZl8lK7QC1K7Sqow9tqwZNYA2y40SJlN2EL9eTKS3pypoWxgqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663187; c=relaxed/simple;
	bh=IPf87zx/mchPMa9HJChjvMus8c2tK2I1y8QYmW1JrXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6ZRbulI7x7vPC+FtITWK+lcNV+cxJely9pwiGKz52s2z6vXp9dypAcG8azrtgZ4nKspFw8SZMIfEBIGl0/flmEGZ/RqOxO8C5M7xmXhHxPQYB5fLLlxomSF1ju3WYCzWi33bRJB5jsGbcST+iWJNqjUCOk5S2EiLTI93wWd8oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLS30DzX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLS30DzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7FD1F000E9;
	Tue, 21 Jul 2026 19:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663186;
	bh=TbMz/1611oZy/fdir7ke4GTQT6pT6dANCJwCksCrtJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HLS30DzXNC+XvWubZN7DdGRniiIX2klFWgGcf7u/JRksD1cf0iI+L9SQgcga9BbcY
	 PEvRsVwE0hnlP5LFMtF+BfDoaFkzmOAcYuW8yQoMnOeTjPlvWIXsYaX0ugPt87dpMF
	 954k8KEzHG4iLfhdr+UQ+LEnKJr4tTINVbbuMmao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0727/1276] afs: Fix error code in afs_extract_vl_addrs()
Date: Tue, 21 Jul 2026 17:19:30 +0200
Message-ID: <20260721152502.354680640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 4897cb71d4ab1f7e1a214adb1e4b80176702368d ]

The error codes on these paths are only set on the first iteration
through the loop.  Set the correct error code on every iteration.

Fixes: 0a5143f2f89c ("afs: Implement VL server rotation")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-3-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/vl_list.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/afs/vl_list.c b/fs/afs/vl_list.c
index 9b1c20daac53bf..b25830d040da0e 100644
--- a/fs/afs/vl_list.c
+++ b/fs/afs/vl_list.c
@@ -93,7 +93,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(struct afs_net *net,
 {
 	struct afs_addr_list *alist;
 	const u8 *b = *_b;
-	int ret = -EINVAL;
+	int ret;
 
 	alist = afs_alloc_addrlist(nr_addrs);
 	if (!alist)
@@ -111,6 +111,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(struct afs_net *net,
 		case DNS_ADDRESS_IS_IPV4:
 			if (end - b < 4) {
 				_leave(" = -EINVAL [short inet]");
+				ret = -EINVAL;
 				goto error;
 			}
 			memcpy(x, b, 4);
@@ -123,6 +124,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(struct afs_net *net,
 		case DNS_ADDRESS_IS_IPV6:
 			if (end - b < 16) {
 				_leave(" = -EINVAL [short inet6]");
+				ret = -EINVAL;
 				goto error;
 			}
 			memcpy(x, b, 16);
-- 
2.53.0



