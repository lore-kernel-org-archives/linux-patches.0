Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830920;
	b=wT/L/gcV9bkja5tmgtUFEFWlC1ICsBDeuEkJ2c2Fwx2fmnus7pVa6jpCmbYe3B6jw6lh
	 0Kazvd9CMCrqS3ztSw7vxpofewfXey5kdAGu7ABVSWuD+B4UrvjS/KhedXLKll/CsBuTB
	 RexX7b8VjG9rSQVJbQPOY/pwesLJvDl23ouxsRVpOdrgRFqyrwXqIj0KAO7xUM8XXj3bJ
	 svlQD1LWd5p0gJGX37RNOOEzdFqU+vRqngn2gzEdRw+sOJERGYw9nTpi0Xkv6gNtUd5ee
	 KZNS8oJ95oa+frtSM9pKvPZwaHQuFL+x6IWlcBrGXdcM6TuqQW2lT4wVoyT8p96Y0xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gJK7HxWx4eVSkPtnLiUAEmcKb6UztJOC6Loqx4YSh8Q=;
	b=dOMsIhDhzBcqUqkrWRPe8jWLkV/hcT1Q4d3LXNhrVyXS3FBrP5JHRVxdqQapHrlWZB3k
	 xZJAcrftDzfS41Oi5my0AmM5kMp7wk/xR87Id2jLGaNJXlNK7NFhvr7slAPQ+HQpw1jIV
	 9H43W0GUDojzRQggdQfOFLe2HXqZjfuLZlvDarmjjZ+5Pxsa6pwv/lCDq0rUDjpI7QNxi
	 kavUlOFjVdgCdX0+LqlZqXevS9CZRojwlieqDICj3+J5LsR8VKHE5j+JjualJ5QstRt5c
	 Rlc/LLtMrjxfb5qvjJS3KSWqbF6t5hJOEXrb4udutGa5d39v5WthN8RqgAOrV+pqGUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dUNIFI5+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB54C606A841;
	Wed,  4 Nov 2026 22:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dUNIFI5+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632051F00A02;
	Wed,  4 Nov 2026 22:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830919;
	bh=gJK7HxWx4eVSkPtnLiUAEmcKb6UztJOC6Loqx4YSh8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dUNIFI5+TidCs5MVlPudQ5mD0/KgJULiNmeKLTKpHvOdkSHxpjOuyI7hYgbqKWPch
	 aqG4FOLbBxFCFhLsWj3vSxxFeKKxLF0xP/jcfhbuvBjiaSu4SG4bz/681vIAAizriN
	 jcJgtNqqEuM0LWm91AIlGdWJwtFvc3esrlA5FWZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David C.C.M. Gall" <david.ccm.gall@googlemail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0402/1005] crypto: keembay - use crypto_memneq() to compare CCM AEAD tags
Date: Wed,  4 Nov 2026 16:02:15 -0500
Message-ID: <20261104211055.334895329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index bb6f33f6b4d39..13ba7573617fe 100644
--- a/drivers/crypto/intel/keembay/ocs-aes.c
+++ b/drivers/crypto/intel/keembay/ocs-aes.c
@@ -17,6 +17,7 @@
 
 #include <crypto/aes.h>
 #include <crypto/gcm.h>
+#include <crypto/utils.h>
 
 #include "ocs-aes.h"
 
@@ -1283,7 +1284,7 @@ static inline int ccm_compare_tag_to_yr(struct ocs_aes_dev *aes_dev,
 				 (i * sizeof(u32)));
 	}
 
-	return memcmp(tag, yr, tag_size_bytes) ? -EBADMSG : 0;
+	return crypto_memneq(tag, yr, tag_size_bytes) ? -EBADMSG : 0;
 }
 
 /**
-- 
2.53.0



