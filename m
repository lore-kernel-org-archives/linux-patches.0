Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051850;
	b=kfEKxnCPg7jBYua/BpeRJqNh8epW5nkv8mvT91tZTKMLV1N2gZVBDzLMdnoxYzUY1NfD
	 HGJXZiWRpUSK+LnZpc3P4Vy4AMDiD+1jcyhptmwOrx5wCvJoYbAhqTuKJAnUBWbSSxYts
	 XPyGjO3d9MH2BwJnjM9WSqeJwPB2k0gY1aT1BVNv60Dl97EhgHCWdWYrX+z2GVvqSPjSm
	 85cmx5MBMLogaVVAtFdiMrqcLlOL9lO5mioh+f2MYYN4ZEJrO48S/pY0x8oVIfMf6hWh7
	 YaO9qiz2l+vlaOX+XMcDu1fq6Kh1zlANTtawBGFBy/y0rBXNLITRm8JAozs/Gyu9G2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xaFm5upgrru5WnxHTIDlitUBClOw3XIT8IWolQ80+vM=;
	b=0HxnxFvjPnYi596dMcyuet4inhra1TroNaGgVf0684OrV5UOHdlcUDeZ2Zr7hEIbyO0M
	 OyYvbxXLsHXFNfNnTh34VpniCV7yaE+UhdbCf6x9/cEA+JRdUe5rY9MZjIITrql8Qaqmo
	 KnFiDnKt5hh0e6cQjlvhQTGg2rLwAQSb+O/AvZ/UAddmDQpVMGD5B1gyBu+asicH/iG/C
	 YPBiR0kWwOKauKf6Zkax94rx+yX6BJKJHScI7ImSJ0YcLjPA1HXRedx4SYsEwaM9Vx0r9
	 BVaFVaS+9CrSb5OedUEeXdPmzA6oSim/z8TUm4RciY/xngAZ1I0ZJfu8+QU7/z4qkgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TK3I1h+e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD01606A32A;
	Thu, 19 Nov 2026 01:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TK3I1h+e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952761F000C4;
	Thu, 19 Nov 2026 01:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051850;
	bh=xaFm5upgrru5WnxHTIDlitUBClOw3XIT8IWolQ80+vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TK3I1h+eRV6izZ3lyivEn62GxUPQu7+LOKtdo4EYjnR2T5/HJwdAzZS315d1Ec8Xk
	 tBTzYA+CjjB6t99m6H2g7LkZm0nhiI/Qi8uPMWkO6g9Y3uycaQcuHyHKmQpnxIVy0P
	 q+uNJOTWmSaWvww0tZQ5wLDsvXsiFLqZKZFrfnXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 0353/2214] nfsd: Fix id-to-name cache entry leak in idtoname_parse()
Date: Wed, 18 Nov 2026 15:33:49 +0100
Message-ID: <20261118150024.824688956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 8ca3b74c0c447af17d0e27e76658a3d4cae3c5ba upstream.

idtoname_lookup() returns the id-to-name cache entry with a new
reference. The name is parsed between the lookup and the update call,
and when the parsed name is malformed (negative length or longer than
IDMAP_NAMESZ), idtoname_parse() jumps to the error label without
dropping the reference returned by idtoname_lookup(), leaking the cache
entry.

Release the reference with cache_put() before taking the error exit.

Fixes: f9ecc921b5b5 ("[PATCH] knfsd: Use new cache code for name/id lookup caches")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260917163154.2162438-1-vulab@iscas.ac.cn
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4idmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -252,8 +252,10 @@ idtoname_parse(struct cache_detail *cd,
 	/* Name */
 	error = -EINVAL;
 	len = qword_get(&buf, buf1, PAGE_SIZE);
-	if (len < 0 || len >= IDMAP_NAMESZ)
+	if (len < 0 || len >= IDMAP_NAMESZ) {
+		cache_put(&res->h, cd);
 		goto out;
+	}
 	if (len == 0)
 		set_bit(CACHE_NEGATIVE, &ent.h.flags);
 	else


