Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DA02264A3;
	Tue, 26 Aug 2025 11:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207052; cv=none; b=TiYoEPsj2i/KUjbQ+n7r/nDeXdQtgnL6unKrf5wTMG0NpPJQYpJyD678mm8rNEidtK/rUvBH7GvtEqhO33TOkVqanY6QzIR8gQ7I2LcB69j2xi7LdzYaup6QOM/SJwyMCCFQnlSwNKjZpoo9NdvwOA1aQ/s/9i6RASThyu6+9rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207052; c=relaxed/simple;
	bh=kRMhd/EPPFSdVvvp4QWnGLdTNgrddedEk7A03524TgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzxWqlEshsvz/GOkluRSpa/tBaxOhpaCDl6OLB0rJ35wJPMZW709mL++D0ly44Ve0W8RhkALV9AZY4H/5u/qAcf5UIkx7kE0tbhHJbNW9rF+s1P8MYyOLGQ13zQh/XmffEXJBwd9xLl1PqSK+OYmqfbKm5fHBpAjzt1cqnyf0bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxjNnXFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxjNnXFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3594DC113CF;
	Tue, 26 Aug 2025 11:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207052;
	bh=kRMhd/EPPFSdVvvp4QWnGLdTNgrddedEk7A03524TgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxjNnXFzJdMAyqX1GmRXAyg4gfiusKtUJJsEikNTGGRJqAhigtgM30XnFGLxYRQJx
	 V5EYM1gZakUvQ+cPNEcRrIXC4x43RP9Imf9CtXxx6L1di27F0Q+s1DcMecAIaqSv+4
	 84wNzptt/bvzwnXzB8AGDsUrDZF99YBqQFQWr46s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.16 032/457] crypto: hash - Increase HASH_MAX_DESCSIZE for hmac(sha3-224-s390)
Date: Tue, 26 Aug 2025 13:05:16 +0200
Message-ID: <20250826110938.132866111@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 9d9b193ed73a65ec47cf1fd39925b09da8216461 upstream.

The value of HASH_MAX_DESCSIZE is off by one for hmac(sha3-224-s390).
Fix this so that hmac(sha3-224-s390) can be registered.

Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Reported-by: Eric Biggers <ebiggers@kernel.org>
Fixes: 6f90ba706551 ("crypto: s390/sha3 - Use API partial block handling")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/crypto/hash.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 6f6b9de12cd3..ed63b904837d 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -184,7 +184,7 @@ struct shash_desc {
  * Worst case is hmac(sha3-224-s390).  Its context is a nested 'shash_desc'
  * containing a 'struct s390_sha_ctx'.
  */
-#define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 360)
+#define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 361)
 #define MAX_SYNC_HASH_REQSIZE	(sizeof(struct ahash_request) + \
 				 HASH_MAX_DESCSIZE)
 
-- 
2.50.1



