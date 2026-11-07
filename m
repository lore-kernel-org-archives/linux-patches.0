Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061042;
	b=VcL5a6itxM23K7fHz++mSc2rprsA3q/rwH0LRYzBBnoZF2Meo12A/ETb+SCj/XGWNonN
	 1LKOHf5XZLFScAZOW8xHcFKtCwY430FsefRz2LtwERi+xdvRHLjlfMZ0n/adQjmjqEX7u
	 nva8QQRFHYWiSrAglrRcaeev1UIJPfMo+lziTzq68orLY+Oi8CljuxztjfgINrDTpEZjJ
	 5T+kEE/LQtpmh02vk4TdYc91dFwRVn1DgJnoYpWha3QREtkIkH1cQRjUwSyP8bA5tpUU7
	 ktarCldWtOJyxoIgPUefnhvC6vvSZzqtpgLHJzxJbyWK0xOi9S7aCSYYKMrzS+IyKwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ft/HLo/GFtGi8tivmMqh8F5AB5gZ1B0d0Di7kSgJVc0=;
	b=5tQ/Cjnu5DbFC2RhFXxedAPmnexS7c9p+ozvaMX4Vp4NEUXAcXAyKgG9rtq33TOAtiSZ
	 SxKWwTLyvx10hl+jUYzKsQY/MqICMYZ0r7PglPHjGGc8tPAK/OOrJ/OIo7vq6T5bOAD0a
	 FhwYLcmRGlG8YdIaDs93CJvm7ZR8X3b/7896mVol7x90J7bcIp3XgifCsKRFX7sNdDex5
	 IbQZRyAzb60Fwc0FHvmaAUD+KxDba3ZUOYNX2+UeDszDPGcXdUpA0trUUZBbSGPG6N/JQ
	 C+CQWFcsejMaHt081UDXofgBcjWy7o10whndKGT95vMfQgGWc1HHAxiLs4K+7qFEOAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cmOEDtAe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494BF606D801;
	Sat,  7 Nov 2026 14:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cmOEDtAe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B466B1F0089F;
	Sat,  7 Nov 2026 14:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061042;
	bh=ft/HLo/GFtGi8tivmMqh8F5AB5gZ1B0d0Di7kSgJVc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmOEDtAenONuY94ChoBgKWQAEXRI8gym4Wg+WiNCJStCVFAMYYbm/ZceJFTAYp06w
	 JZXR0hOjGSWS7w/cBYHQfWtLZ/976bFZsEsNKHJVoFfb2XUYzTZOHjMPe8J7AxbCTR
	 UKUpUofm0aaXyTtmuZ4RxdlJNMUWvxxEX34tG2Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David C.C.M. Gall" <david.ccm.gall@googlemail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0336/1536] crypto: keembay - use crypto_memneq() to compare CCM AEAD tags
Date: Sat,  7 Nov 2026 08:39:12 -0500
Message-ID: <20261107135007.129247276@linuxfoundation.org>
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

[ Upstream commit ff2ac77a034e03b64e2ba34f775097427dfa5547 ]

Use crypto_memneq() for constant-time comparison.

The CCM path in ocs-aes.c verifes the received authentication tag with
memcmp(), which returns early on the first mismatched byte. This leaks
valid-prefix length and allows for valid tag forgery which violates the
INT-CTXT guarantee of AEAD.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/keembay/ocs-aes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/ocs-aes.c b/drivers/crypto/intel/keembay/ocs-aes.c
index be9f32fc8f42a..b159d949d6246 100644
--- a/drivers/crypto/intel/keembay/ocs-aes.c
+++ b/drivers/crypto/intel/keembay/ocs-aes.c
@@ -16,6 +16,7 @@
 
 #include <crypto/aes.h>
 #include <crypto/gcm.h>
+#include <crypto/utils.h>
 
 #include "ocs-aes.h"
 
@@ -1282,7 +1283,7 @@ static inline int ccm_compare_tag_to_yr(struct ocs_aes_dev *aes_dev,
 				 (i * sizeof(u32)));
 	}
 
-	return memcmp(tag, yr, tag_size_bytes) ? -EBADMSG : 0;
+	return crypto_memneq(tag, yr, tag_size_bytes) ? -EBADMSG : 0;
 }
 
 /**
-- 
2.53.0



