Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B5B3B893F;
	Tue, 21 Jul 2026 20:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666900; cv=none; b=nSjkSEFZ+nenTpGS45XcmoaveNA3y9dLAyKKr4HOXL+3TFqNguIgsXfjmJre96mV7AOD/Qnqjx12DEPD3/uUFO7q2ARVQa6ow8OW9ejySE+4x6ZHY0m9NvS1D/stsfDQhGWwQrAMpt+UJlAS0BZTXlm0urWYT5yy9Jwspu9VleU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666900; c=relaxed/simple;
	bh=dOCj7JtpKss7EFmhvQEq1WKTyLXIViftjxJ3X4QhJJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltMuUQ51kZtmp2a93uN5r5dM+6nFv4N5lVsEsKKKbQr5LGeo9sera7560nrtn7rTpejH1ndujmUWwuyG95JcAzMTjXRzZAlJxSxGOCB3pUxWJDOJdedJHI1IYE0yF9SM5JkkqFypUKOWmPV7ZAlfq/N9OHbrP4Vok9r9Cb4EWwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeZ5Yo6O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeZ5Yo6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCA11F000E9;
	Tue, 21 Jul 2026 20:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666895;
	bh=KnzvVQRbuOPrR7rqk+2V4tTC6udabjikV5acRBbzkyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LeZ5Yo6O43gCV+iSfY8O6d+x+tQ+3nqqBTtX4cRYzAdAO9hhQaR6XHIPlcmG4Kprm
	 nqHSv8QlfJiENS5e6y5TWpXlalH9Cl+9NjCBGGu30oDz118qiFqaJcZ5RPThBElPuA
	 m8ka7QE/63JbMsBePu7sZd/saSDXAOjNTj+f/MQg=
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
Subject: [PATCH 6.6 0829/1266] afs: Fix error code in afs_extract_vl_addrs()
Date: Tue, 21 Jul 2026 17:21:06 +0200
Message-ID: <20260721152500.405366038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index acc48216136aed..631ee7e0629dc1 100644
--- a/fs/afs/vl_list.c
+++ b/fs/afs/vl_list.c
@@ -88,7 +88,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(const u8 **_b, const u8 *end,
 {
 	struct afs_addr_list *alist;
 	const u8 *b = *_b;
-	int ret = -EINVAL;
+	int ret;
 
 	alist = afs_alloc_addrlist(nr_addrs, VL_SERVICE, port);
 	if (!alist)
@@ -106,6 +106,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(const u8 **_b, const u8 *end,
 		case DNS_ADDRESS_IS_IPV4:
 			if (end - b < 4) {
 				_leave(" = -EINVAL [short inet]");
+				ret = -EINVAL;
 				goto error;
 			}
 			memcpy(x, b, 4);
@@ -116,6 +117,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(const u8 **_b, const u8 *end,
 		case DNS_ADDRESS_IS_IPV6:
 			if (end - b < 16) {
 				_leave(" = -EINVAL [short inet6]");
+				ret = -EINVAL;
 				goto error;
 			}
 			memcpy(x, b, 16);
-- 
2.53.0



