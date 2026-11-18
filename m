Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023578;
	b=4XWb3STwUXHO8UN//0RLn//eXhrEv1+O/Am1+Uzc9VGT5Qv4zyBvf/v8SYVT/zvg1I9g
	 abNGd4gerePy8C4ZUm7uOjN23t/82UXZ6+hNEvGLNlhxxdV3STzIH2kE7/ayN99ArTDvv
	 3joAhVmrNqjI2TLvf9N2r6WSR3+kgisNbQJmw2flifPb228/IKxqfrwovcGzFA04+Z3f+
	 yvB6K4msbqZevE87/CmxTRuVxaf7Zc8VaJaBCQTfmP+oMljfs1HQgQ+HLSeH2pPKU9476
	 DlKBNG/Romqh5veWiRby0qGQ3w8NJWEB1yefaE3KRspBh1WPLLTOabKjQ9ufwXNZqRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZI/4/gs1hdeE0QPOrmec0GQYod0B6rxgY/E+0Rx2A4s=;
	b=RRA2p/UVlRG2MwzSI30OTjaubrsK2sSqx+XZd2aZVk0p+ffS0xz9kS7qXtsofivamP7w
	 pVlr6v5lh9HTJZvEK7q9U7s+rzbFtIMO8MVZImHVXvjZtDiJJhViHi0hvlP+r5GB4fH/F
	 e9HeIJ/GOVCh185M7WHS6dQ0IdcUlDT5Ad4VDv1vQFszoLj0+/rEU3nTegTGe2JmGep+S
	 OABgOcOAvblkFduH9fxbv+JzEUZ3tEVnS1PjXUZZFzHaWXzuurXH4RNPEJtvjEqUNMMLY
	 dyT3BQ4PdGVDT1BVde8xqU9AaRsgE5e1CS7bj/N9DzfafFnMr0/xuoFSHzzg4w8X3Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hqSbyB3r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BDC606A320;
	Wed, 18 Nov 2026 17:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hqSbyB3r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E909D1F000C4;
	Wed, 18 Nov 2026 17:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023578;
	bh=ZI/4/gs1hdeE0QPOrmec0GQYod0B6rxgY/E+0Rx2A4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hqSbyB3rCRYXZIoPAsBECzRj6SZ4k64TuqEfk0caSHdxCIjN73Gv1lqO3n+u0L3/X
	 LQyxCoZn0rOG7ZMzU/rVExhOVg2Yp23GHkEfzXSvAVMfKyOvAWgXsbFVkuw6cAFuqT
	 kdfq7Ci+oa6oTrCwZq//b7xQvfZZEvKCsT/7y8Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0418/2151] gfs2: Fix the return value in gfs2_get_link() kernel-doc
Date: Wed, 18 Nov 2026 15:35:53 +0100
Message-ID: <20261118150137.282375489@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 12e5792190650..3a91900545528 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1898,7 +1898,7 @@ static int gfs2_rename2(struct mnt_idmap *idmap, struct inode *odir,
  *
  * This can handle symlinks of any size.
  *
- * Returns: 0 on success or error code
+ * Returns: the link target on success, an ERR_PTR() on failure
  */
 
 static const char *gfs2_get_link(struct dentry *dentry,
-- 
2.53.0



