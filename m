Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061506;
	b=DvhGzMsaVpTfy6/20JGPFIszVmVrAbnDJ6gDNAwqe516VoKSXTK7RYa6Mykc8EX0+MN2
	 oL4ntksEQ9bfyCNqaMoCqDjzxYOgfPSuhAzBtxOhuIVcFwnNzo5zjVykIJoXK9l4l7VaF
	 FZgeWb3jOc1oKVrDdnv9He7p0hO/V8UHsdNxPoWGI8kBZ72i9P2fx6vJIfuwqTkEgC9aw
	 9AKz+f2cKjFPLHBqTY5Ao3PUlmeHTFISbnj61FgKvEC1aKAJsUNe18L/BHNB7A+nyNNjB
	 upunSlUeLKJKO5Xy3lJtx3ZPF0rGLIgJ3Luxu5Byd+Nnn/GleOTjKqHsFvkVBpmIvxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lxHat8jNkyfqyGiJg+aguwIj+SPrsSJP3vblgPvcuB8=;
	b=0KDWlpea+/je5/hzpHMZ1aaNqrpQbNhcEWGE2wD85HgTwu4DO5H7mJ8NYuzn8G9+RNNg
	 BCNaDuW6ap6eyJ+oU6IcN7+y1PlR/4Y0OAiABufS4mVWuMnR6SIVnMimvFiklwpOSz3Da
	 a+MJ16SA6aDiOJWEgUWLZKFRtkcafFXCKwhfnpuLaeYI/SVMAR3RvDmXpG305E99Lx2cI
	 4E4GSECrIS5pjsDRLPIbYnk8auaFNX42xGU4TzeXXpAdPROeMksoS+mfkbdqz5Up99dSU
	 oH/yaZvLkwmiZF4yo06gPPQ9YcDCyzdtm16Hyuk4vT3pz4oj/SUKn/p1G0V0gOXlGRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eO+TaQNU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90961606A33D;
	Thu, 19 Nov 2026 04:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eO+TaQNU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E362B1F000C4;
	Thu, 19 Nov 2026 04:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061506;
	bh=lxHat8jNkyfqyGiJg+aguwIj+SPrsSJP3vblgPvcuB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eO+TaQNUr6Oj8hdpESoDqj1lJJ8M3Jf2ZJAm1S1jHX/HfVtfGef5HLN4T9MHlLkYG
	 lJx6gIpR2205ZH+h6KiywEvszMrw5487tIQgAQWUI/poOJJ9Q1JTZhK3vA76aCDKsF
	 xAqn3jc07Xy2cCKWBoVB+RFrGBDn9vQ6KrDSR8Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1577/1848] calipso: hash the cache key, not the option start, in calipso_cache_add()
Date: Wed, 18 Nov 2026 16:00:15 +0100
Message-ID: <20261118150025.607385095@linuxfoundation.org>
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

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit d538cc3ec0bc4cb7b40981b3213a6c6671959ed5 ]

calipso_cache_add() stores calipso_ptr + 2 as the cache key, but
computes entry->hash over calipso_ptr, i.e. starting two bytes earlier
at the option type and length.  calipso_opt_getattr() looks entries up
with calipso_cache_check(calipso + 2, calipso[1], ...), which hashes the
key itself.

The two hashes only match on a jhash collision, so the CALIPSO label
cache never hits and every labelled packet takes the full DOI lookup and
category conversion path.  The memcmp() on the key keeps lookups
correct, so this is a performance bug only.

Hash the stored key, as cipso_v4_cache_add() does for CIPSO.

Fixes: 4fee5242bf41 ("calipso: Add a label cache.")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/179138670045.80227.16155454353416856947@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/calipso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index c2e716601ed3e..717ae49ab6480 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -284,7 +284,7 @@ static int calipso_cache_add(const unsigned char *calipso_ptr,
 		goto cache_add_failure;
 	}
 	entry->key_len = calipso_ptr_len;
-	entry->hash = calipso_map_cache_hash(calipso_ptr, calipso_ptr_len);
+	entry->hash = calipso_map_cache_hash(entry->key, calipso_ptr_len);
 	refcount_inc(&secattr->cache->refcount);
 	entry->lsm_data = secattr->cache;
 
-- 
2.53.0



