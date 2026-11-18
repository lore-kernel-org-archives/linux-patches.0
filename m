Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034193;
	b=fwAW8f7RucEp+cqei1R/8iqoGtcejRs1yhM7sO1h46ODvFlEYOD1EoI9LF8TnwPB3HBG
	 JfdI75dW3LrwMaf25twke+wlEG+4itkvD0WyoWwJMDrSqAB3GcupO91oWt/mIpSQGTsXp
	 tT/hLFSeujWTbuLicy4MO7P2Bgp6eCQuz3Hz7zZsn0tIr5JOJMFZlbdksZdR+4/VS/KX/
	 yikswj2pUB9MufUsZZ1/zFezpUvvVwbmFYnY34z7Y/7xhDjcJojVHRFVsktPvtpMtknkX
	 2Yk+nNKSxOezq7kNYl1RmP7TCDRmkne+9XyTQMilUnURCt7TNWCr6SJJtZrJzplQNSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WR/Z+7RaAamzuwdzKQMKAW08t94Owb3iIsQ19ab4NeI=;
	b=pb4fAiE0NDjTneAKl2J/k3EKOY6af1UdTX8nt5dGnY6VJn3dCUgO0sTWQyLKhgVyFnLe
	 iUei1tvba6/c6NdHH49TvtW1HkG3OUNt9seGuR4Pb6id35+htd67Le9Ouf2EIQm19dYWB
	 /+YGN0m+yI3T3oHbHy3/UjiSf7eJvreetT7rvXa39yAh1u+4h568UNquI1o03AAUBClKT
	 zuzxV7LejCPbaQ4kkjKUfNgHp4Sv3zgP2jpdz8qKJtRGcdHQj8GruDDNzJK6pB/Jww4Fl
	 qmN8W9nBzivctoSnEbReuishoookQ5CmDrRK7ZoOP++jMKFg5va/as4TiZaD6FsK6Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wqt5gbqM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A87606A338;
	Wed, 18 Nov 2026 20:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wqt5gbqM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014CC1F000C5;
	Wed, 18 Nov 2026 20:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034193;
	bh=WR/Z+7RaAamzuwdzKQMKAW08t94Owb3iIsQ19ab4NeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wqt5gbqMOt5fClpVGSfQ8sK9l2K9PsdrFv3mdNLNVbB1mQwqEhPTVWTYAHYWsplnu
	 qF5aYcOKoNrOJ4GafDtU0Rg3j35F7JUuEoGTFI68bs1oIpmdlnzPDoJVFmjxkZELPR
	 +iG+v/pzsomLXo+vn2588prxKIGOYrFs6J1x5sK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David C.C.M. Gall" <david.ccm.gall@googlemail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0282/3318] crypto: sa2ul - use crypto_memneq() to compare AEAD tag
Date: Wed, 18 Nov 2026 15:15:04 +0100
Message-ID: <20261118150323.993085060@linuxfoundation.org>
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
index f1a1eb9f7d070..0b9feea86142d 100644
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



