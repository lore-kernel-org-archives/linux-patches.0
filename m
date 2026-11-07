Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061038;
	b=H5wwUGYhh4Dq19/JBLE76EkxJKNKQvuMs7QCZJkBYkm7oj6GuYrdIKws06rF2Y+ASeS+
	 HthtSrYgwx+ye2JwxuagIdFW7GA6O23XpNzJoEAjdudpNWi3VvDF5ZRC/PnOUODn7p01N
	 vh8dmxoeHrDzQ6rE1Bvzn8oXb8Jl+o9/5aMeyFwzARmN1dI9Qy8xKNHd7iijh/AuGw6BG
	 supGQqEPUAmi8kgfo4pVZBEhH9Ah8quQsF4pHw1pwasVZ14lVmMhdGRsMlMUibADJIV1d
	 VlNF4hzRXFIO/57KTl6xPS4UoGeWxhJhgImZwPxHhPhSikf+o5Zo/cQW+SCOhE8nQnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cEa7dy1oYUKAs0ivS5rwcJkW9fy5vs3k9bZ94AxCPcI=;
	b=cTk0ij98Wjqb36famiU0gzbBJ5cvPP/DFp9VB8PdCUAYPmRHEow5l04TGt0GD1jTgC9/
	 xBE0j5q/2F+j5ZriO+vG/OnDO0pr34+Q1gWiLbEVDKoRy0IJJF+twI/JPBoKSar+I8N4Y
	 6UggFD7myaHcg5m+303GPypNUxOPDotVK1kPXR/nVXbwg1tEm5Q9a98QZMBLUl21Wa9dQ
	 +j2dgbUOGbT+eft7psMgnUBkb1TD383B20GVvydqx4z1CHEPHAIFUJnpk7ME24U8guKYc
	 hGpFZW7Dqshq6esQUe1+i6IkwIlXPRSUB6Wn/ncN0z0FhNzkdAIA9ot58E691Z57CDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvmeo2gI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9342D606D816;
	Sat,  7 Nov 2026 14:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvmeo2gI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402D71F008A1;
	Sat,  7 Nov 2026 14:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061038;
	bh=cEa7dy1oYUKAs0ivS5rwcJkW9fy5vs3k9bZ94AxCPcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvmeo2gIcOsi4XLHDv58v//UuiiRBXQzAQVDOFCs2pf0jc3HUusw3kBzyGi6eE4nP
	 e4ZhIqmHJ4ywzgMQMmBERBcI5Z8SRhDGfo5CKeG866K0C5pN4nTt8GKZj5yhrQZZYs
	 shwayCiQtL0E3Rz/4fyPrrrPz9nJ+TxYkNkslaKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David C.C.M. Gall" <david.ccm.gall@googlemail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0334/1536] crypto: sa2ul - use crypto_memneq() to compare AEAD tag
Date: Sat,  7 Nov 2026 08:39:10 -0500
Message-ID: <20261107135007.076543644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David C.C.M. Gall <david.ccm.gall@googlemail.com>

[ Upstream commit 7064af16d2b418d61571dba9bb0116a547ade124 ]

Use crypto_memneq() for a constant-time comparison.

sa_aead_dma_in_callback() compares the computed authentication tag
against the received tag with memcmp(), which short-circuits on the
first differing byte. An attacker who can submit decrypt requests and
observe completion latency could recover the expected tag byte by byte.

Valid tag forgery for AEAD breaks the INT-CTXT guarantee.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index a8f5f475acbe6..4c1fd567e6fd5 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -22,6 +22,7 @@
 
 #include <crypto/aes.h>
 #include <crypto/authenc.h>
+#include <crypto/utils.h>
 #include <crypto/des.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
@@ -1719,7 +1720,7 @@ static void sa_aead_dma_in_callback(void *data)
 		scatterwalk_map_and_copy(auth_tag, req->src, start, authsize,
 					 0);
 
-		err = memcmp(&mdptr[4], auth_tag, authsize) ? -EBADMSG : 0;
+		err = crypto_memneq(&mdptr[4], auth_tag, authsize) ? -EBADMSG : 0;
 	}
 
 	sa_free_sa_rx_data(rxd);
-- 
2.53.0



