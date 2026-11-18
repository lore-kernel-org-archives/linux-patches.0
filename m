Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060681;
	b=cnZ9/ZPPP9uVvm9tGU/xyJscRvB7crkPWxc9nDJbBHIgVydB00TGndEifAxIGepeiLWy
	 7XY5/j1vbCuWSKZYxTZ+DZyt68BxHhy+CAz3N5XvtroFYo3i2YpEbSBC49gRgP4AACsu+
	 aZ6lWZ87hsiFyfjpbaCePBs0W/vPKIfJpK5sjcZZnkUlkvd/OjWlcKkKTINgKtO8WTzBx
	 LuQarRck5XaTZqzgmSEXEpexDZyGR3aIXxiaLWamo45w7dkwavdGZkhSaDH1a9A5brFWt
	 XGRPcAQ8uojLKrCGGFLfPDaEqJ2tsYb4bgOdIMNZurrbOAoYiDcLaGAHMd7uk55zz6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sKIg35Q+mpgtHumMMQ8xGoArf5lIB2JCO2dyBheeEnw=;
	b=zLO0CAFdUUdxeQSABNo5vJdi1FAtCQS4/N6cLIhZP9e+y2HocaFMPVnmN9rQ4ZI6sazE
	 bE3baStZzjpaBohGlDyiuVAyMtCqzhCtffbP1c+38b4TFLXLd7Sp8kT9mQlHp+/rbTyvF
	 N+GcWrHSHOJfs/MWFnDRSdSMzRU26P/Gl+MAuhbIc7r5tQtERr3KmTc8ynlzMpRPfZYhr
	 YN7oq4ysG5WQpvWfOmo0jklzDHLEgKRYvfFnzWKGdIB0qNz2IafhCh+tlfzYy3REyMWRH
	 Xb3orqPVcSlTFZ2egUQlY3YKOW6JbOAzzMoUP5HQ/KhH66wG+TEVlSSaw6tC9Yaty0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CE/IBJ8M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEC7606A32C;
	Thu, 19 Nov 2026 03:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CE/IBJ8M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33641F000C7;
	Thu, 19 Nov 2026 03:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060681;
	bh=sKIg35Q+mpgtHumMMQ8xGoArf5lIB2JCO2dyBheeEnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CE/IBJ8MBbGsldQBncCcYFFUlXyWwn+r0KS7G10bKOO5q3sDQJqpXivebPwgwEQbc
	 Egrx+ba7fRiiqF7LbajW6/EPmprxyHw2SAAUF3dcR+aNh3sUW3cUqwjqGgUauXBh9O
	 g5CszpJWijzWM9a8GPfR4tJsHqFHNXrNfOM9J8/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1244/1848] gfs2: Fix the return value in gfs2_get_link() kernel-doc
Date: Wed, 18 Nov 2026 15:54:42 +0100
Message-ID: <20261118150011.901606381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f266dec205175..8c96dd6810732 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1771,7 +1771,7 @@ static int gfs2_rename2(struct inode *odir, struct dentry *odentry,
  *
  * This can handle symlinks of any size.
  *
- * Returns: 0 on success or error code
+ * Returns: the link target on success, an ERR_PTR() on failure
  */
 
 static const char *gfs2_get_link(struct dentry *dentry,
-- 
2.53.0



