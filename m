Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035407;
	b=yrAEH/mtj3Hrn3PMhRXsdd7EGTzeOInTK0ETDfg8EBvUxbHCFfETMPqVaTdv1JAwVu4a
	 JRxb2JGi31C3nMJfjSDq3sfOY4ha2ecBNyamC8R8aFYyK2vgKFhmuLz7bEJmq6epsNIi3
	 Reb3L1Lb2r2EUbGCLddaIay1restJA4tBrx13mWcJk8XryH9mU+slcCzcZ7PY9/rmi9M/
	 7VE9x0LUPQxL84eB4imKLFjeGo4H7dv//oO8mWq0virPpDIO/+TiD3nwL+6uMU0tT0nio
	 v1ivZr32wR6ld/dgyk5fQxDBRJD+q9ndJLVVGyN/Q6sDjjaiMAdUJMkBQNlZ5ITC1hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kJijNBTp6H64kTvWsJp/IbRdo53WTpMn4/H6IQf6Avs=;
	b=SIeeE+gSZbpicWSKHPHgJRG1vkKwe2n69l9Yw4Bsr6V1YOM71Fsa5760W7/JhSHkeg6s
	 1XwoXK7eTWP3QJ9x6oqy37M5bU46PfF84oQx9NlPxHxdaA1DXXbyrLBPzyAcIeqKM4kCr
	 1wK83t3WrmW58z+ptmTa3ceXq5Lk7oJjKIafvIJcv1Uy0LLNKkJp/N6e40FIoUqvV125+
	 S9C9aoM8/hAS/xI8bWNMLU7AJ/GCQf/zkGu7KIEpB02qIOzAmSOBraUmKx734NmHlCe+k
	 s2Sw4wrKdzfVdSWr7QzAaTUXcZrTjlNc/v+iH4qEra4qgRTsUkIymZUAgL4sDtIMDzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MJVfBGUL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF97606A31C;
	Wed, 18 Nov 2026 20:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MJVfBGUL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF461F000C4;
	Wed, 18 Nov 2026 20:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035407;
	bh=kJijNBTp6H64kTvWsJp/IbRdo53WTpMn4/H6IQf6Avs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MJVfBGULsgtoIDw4yv4JWglupRD7rfaJOFMp1PEXtE7MwasqgIi9GmnjdgfdYx6Vo
	 WvbxMxqc4LLUGqXt/zueRr3OF2UZFgRljga2DdvoN6nNF/zhNRpVzzSntLmc+//9mg
	 ZQ+goaxsz6owjmglT8q3dUxy+kUDsiVOk1gYEABk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0691/3318] nfsd: Fix id-to-name cache entry leak in idtoname_parse()
Date: Wed, 18 Nov 2026 15:21:53 +0100
Message-ID: <20261118150338.994848954@linuxfoundation.org>
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


