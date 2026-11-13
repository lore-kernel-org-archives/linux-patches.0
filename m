Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585359;
	b=XWUFiWYDCxgNXpNnZtp8N0fvPvTDnCh8fDLbrd7XQVkZfhc9bO2vcyvb9UFwQDUrpbxn
	 SPwZ5DDc3D5NwdXZ+lhCziyu9YRR8XRbZGcJ9154vcxJZYLGsZIz+dsSRvFdI3MmEfD1f
	 qJl5e1kCdNaUwwLz/Zy7xOlQGQO1pxfSCkAFy4lJFtFUdgOurQWdSm0NXCvv91pFe/KgW
	 FqsbCNTK0uKFYYjDDwAttPOSAaoslChZQZ/AldNWO+bGipIxbJQAFZPq2QwOOvzV1wcLs
	 VHj2mNXwmLlYxPlEUVelTzUdQYjUjHlUW3ulwtLuuzawfwMSL/TOcIBrFjm/5EROVnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qvYR8J7rPBRAN2ft75Cz2B1XomIr0075+1wJFMK1uNQ=;
	b=XFJtBM+KK2mmHPP7S42n4ndrhTbIab4ERzojogG8VFvCU3s1pI9kZ2r21bhGX1Nlzv5O
	 r2A9W29MwVmnFaLcU4vkTSju5sGgOQzaZiNz+4HMYBvL7TC2hlNM0IIDPkxkZsNHOyGyV
	 QuA6+X51GcF4i90n6poutD3Kx0j4vM23IGhn76EnW74/Xkouw4oXo1hi6UBwpjzCssM2P
	 SwsuzFND4xNnsewKnsW97yUv+axjorvOn4YtNzEI3LZtLyzCQ3Yg8hIsPctMHtzQjZIct
	 exBDU8LwNExWADc/3jmJgpu6/cDrk6Jg8d+hC1B/QHt03m85fzJ2uonRdYwbAnZYNXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jcZm61w6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3650560A5BFC;
	Fri, 13 Nov 2026 15:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jcZm61w6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57A31F00925;
	Fri, 13 Nov 2026 15:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585359;
	bh=qvYR8J7rPBRAN2ft75Cz2B1XomIr0075+1wJFMK1uNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jcZm61w6AkDikbg/uvbGnmFoqBoIgGKIDaPOnvmDAaTZiMgmrya9fiXSqKvpzREGe
	 ZJbEuWtAtJmgqT0dS4njjSRNfIp+ubW9AFIP9++2/bJzz9HXLJQifID7eUs9PruYIO
	 xHNaZh87FiV5LtPFXqPQSSEsPJ/wnYHVDsHn8buM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 038/507] nfsd: shorten extack string returned with dodgy listener
Date: Fri, 13 Nov 2026 10:45:42 -0500
Message-ID: <20261113153754.840634262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 8d7859d165dbdf6e8d77b76500fc990f26c8310d ]

The kernel test robot reports:

>> fs/nfsd/nfsctl.c:2253:4: warning: 'snprintf' will always be truncated; specified size is 80, but format string expands to at least 94 [-Wformat-truncation]

Shorten the extack string in this case so that it will fit in 80 chars.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260904-nfsd-nl-hang-v1-1-8c8035b6294d@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index d5effeae4b792..3a5d0f5cc0fc9 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -2248,7 +2248,7 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
 					   bad_xprt);
 		else if (skipped_rpcb)
 			NL_SET_ERR_MSG_FMT(info->extack,
-					   "cannot create %s listener; rpcbind did not answer earlier, so some listeners are not registered",
+					   "cannot create %s listener; rpcbind did not answer earlier",
 					   bad_xprt);
 		else
 			NL_SET_ERR_MSG_FMT(info->extack,
-- 
2.53.0



