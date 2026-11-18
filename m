Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019845;
	b=yJscz8zasoWqQ5s1A8BLcjyQ11yFrkK2uMqgrdM4B6P7h7PwrhzxBdu2NqPteng9L204
	 rrR2kPM5cmsxQqxW/wB7Jv+Qr55S4lVFrWJaLthZkCss2fEJv776VJdXrRmGXs9YOhtYd
	 gI19tmsQqTZQVvUjOwHO3+Q2b6HRJgVM8i28wXSx6kakIVnzZ3y5sH1ub1wvC56ebQ0Nj
	 ihYvr0wX++pDBbdAyNjHgCSvKxTUXvO9ug+NFFDMuup/9AkC+8VDNc/Ouzzc1k9UARyV0
	 oVtLRWx4NzqBr9GhWBZpHtss81JFHQcNw1xaq/zitPVv5iiAUdqwjmNUliJELjFcy0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U5yPeh+fqA12p+Rr5RtRQE5ab2u0F6lomdrKvZvVTCE=;
	b=ug8FFc8lp5gkgepCec+z3x0UdItcT3tvJURQvJVVImoRKyiqM1lWR1eefsZQrGwfQgvu
	 s5NpPBq7on/H0jdx8NXpTP8xyhjQ9qhKgpyNxMHyuZoEa/mS7kM2Y7GkfTFmF77koyJaA
	 utOKO8cjVCAF4brHc2rNlcqHfhuovGZFMUxqvMb0oEbIEw3YkoMCRcW+q+K1EUsFhVQnq
	 pvIgX0PP5BGo0Mzly3FOIETZva8dyOyHkrFnYDCzPKTL0L+oRPcoPszvijf0wHw8aCdfW
	 agi2XIgXMVQ2biWahc05YFDOXks0NEaS3FcwGU/3bBlM4I88bg0OQHrlPc25iT+S6UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1ZumzrG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D916060A3804;
	Wed, 18 Nov 2026 16:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1ZumzrG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65AC1F000CB;
	Wed, 18 Nov 2026 16:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019845;
	bh=U5yPeh+fqA12p+Rr5RtRQE5ab2u0F6lomdrKvZvVTCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1ZumzrGyPMklbLe+6x15vjbfcaSbSLVJ2vE2YGGcHRr+hXqKm1y08rAJx3nJNmjb
	 Wf/fKS8rziwqj/g8QmcoTnvBiBVIgGOEsTF+t4FP7wjrQT1pjY1Ns3hbWXlkBL23wS
	 sOm1PRw7XLfkHfmnCO5FQHjhJ2I4jg+fqX2T8Hv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1704/2651] calipso: hash the cache key, not the option start, in calipso_cache_add()
Date: Wed, 18 Nov 2026 15:49:04 +0100
Message-ID: <20261118150348.992132959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index a0192b4fef334..3017a456d289a 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -283,7 +283,7 @@ static int calipso_cache_add(const unsigned char *calipso_ptr,
 		goto cache_add_failure;
 	}
 	entry->key_len = calipso_ptr_len;
-	entry->hash = calipso_map_cache_hash(calipso_ptr, calipso_ptr_len);
+	entry->hash = calipso_map_cache_hash(entry->key, calipso_ptr_len);
 	refcount_inc(&secattr->cache->refcount);
 	entry->lsm_data = secattr->cache;
 
-- 
2.53.0



