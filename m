Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039698;
	b=p5NQIvjVjKr1Uzs+LEPUNd9T7bGnckT7ffY1sNReQeaHwv4OXAHslsIPQUe0puCndLNX
	 tQjMyFI/vQGLBvs5CmwkLc8kmZXvw02Yx3wTrf/TDFMy1GDzs7SpRoKrV5Hw31QsjYQeF
	 gw4cWAivAEKEt7roOnm51pOIarmaFml2GW92NHkvjer3y+mQH0JqulnUiXH+5/FXqMA5I
	 rAcMigk8DfckmUS9yy9jhwEQ2ZvAQ7oHOeMJFH9bCQNDE18HObtl5QaFs8G36FSsquOV3
	 2qMLIVMzvmGkP3WUWVWtTYHsJ0PAYWxowdXj6lUTYKsj2NMEeHCOR4xF8WzShNjxnRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GgNqgaAd/reLAzZc27CNr4X2F/XFvlEDPgT3eQkn4aA=;
	b=JiJzr1aEZ+PfB9IBY3tEHSPUtZJmcBFArQwlsrDLr9lo1A0oSZo79QQRTsmeJt/jbpx+
	 6TVUNnUd9ntfTyy1eyZ7o9x405cUGUpA7OOG/imqqydx37302zaNOZW8Ahmu/JRvBahTV
	 wojT/g/KTE85trHtcGAY27PrSBTcnurVWP4EicvDcT5vU8vTyZdzkOGtP1vzyltoIdtFw
	 17IN+cKPuNpK7FYYmH6cDs0k1/5gRZYUxIJ4n3RpkW9uEKrpEtiC5pnSUwsjd2IFQ6Kep
	 pXbFbwFzQmHXMeNZ7aFKBVv4mLm83lH4J5CNCgYgMLb6//wKBt1H4bggG4jc8DKgT4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uBZWX2k6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDE1606A31C;
	Wed, 18 Nov 2026 22:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uBZWX2k6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7541F000C4;
	Wed, 18 Nov 2026 22:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039698;
	bh=GgNqgaAd/reLAzZc27CNr4X2F/XFvlEDPgT3eQkn4aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uBZWX2k6ipdx7fXRBK32PZac+IzknFZBdHF9us4WucX0uvcD3CizLMEFCOJksdxko
	 uqyVId/l8PbFE7f3NmTqHHKD1eSQZN6WtOVXiAYeEc3Ekpzyv2OYY2lpdSe+rXWnZ1
	 qsaXg2y8h3ySrtZa7J9Eu9qk8zOVVSeIQCBZeKjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2194/3318] gfs2: Fix the return value in gfs2_get_link() kernel-doc
Date: Wed, 18 Nov 2026 15:46:56 +0100
Message-ID: <20261118150427.763926186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 700a0a6892f7c0c541d5d23837cfab98cc744d17 ]

gfs2_get_link() returns the link target or an error pointer, but its
kernel-doc still describes an integer status. The mismatch dates back to
when gfs2_readlink() was replaced by generic_readlink() and persisted
across the removal of nd_set_link().

Describe the returned pointer and error value.

Fixes: c177c2ac8c5a ("Switch gfs2 to nd_set_link()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 4eb5716ad0284..5a90a75562b9b 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1826,7 +1826,7 @@ static int gfs2_rename2(struct mnt_idmap *idmap, struct inode *odir,
  *
  * This can handle symlinks of any size.
  *
- * Returns: 0 on success or error code
+ * Returns: the link target on success, an ERR_PTR() on failure
  */
 
 static const char *gfs2_get_link(struct dentry *dentry,
-- 
2.53.0



