Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585416;
	b=xTcEMgntYgUIGHVjqS7AETYbQkjWQOSsSqCJiuPq4jn15+LaqaK0bX/VoNTJGrpXJfWS
	 ELbezhKshJcKnhX1uIDLEH5+YSLRDaSE3ZpSTX+5fqnERIVoBujA6FOd5u+8cl5cLqsBS
	 im38PvOVOJ1NLvmMkj81ZaivtnxKceb6Uu40g9OP4S9otMtZqs1bK2Kciv7psIk6NSfSe
	 SOmr6wLEaMEwdGUCZZNyHaMH/SsH6Ocqut7/qs19/3HFiliLsD1PHWmcy60mhWTUTwQgb
	 bdXcDl+vydIIchsjUYgQS6LjKgNeA7dJrAzekOsMINFxacXPfTt44D68eJQ3fROYGKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OuJcI0tmUn8NkneothG+bXBiZF9oLCg3wfXglk840eM=;
	b=eHiN5uAivYE3JQteeL15BKepfDuJTYVrP6BoJZnvsNGOhcEqT74/hbd0GCpmfK7YnFJR
	 I8rd+rx3ONc74KhHL6vHS3VvOMO2KxY/QjP2JYzrKiVxtTYgSweu3VcJE/hkeEu7RMapN
	 6VEmuJRaPZNBKejVDaJGhlYV1ozYIwnXKO8EszaSmweGR5vn/Yj7edZNGIpGGQdapxnR1
	 eGn0JU6pLeR0/yj/UsP/bFVGKwRHaM2841WTsRXSpLC51NVLpmqkSX6OdvIYlVXUe6k0w
	 tfndBngGg+XVSGy1LidpxP1Sa0sQvlDbUsWCuT0P/NUVdJxvzfvqgl2v/1+yKucofZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ez8SLaPm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456D360A3828;
	Fri, 13 Nov 2026 15:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ez8SLaPm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91641F000C4;
	Fri, 13 Nov 2026 15:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585415;
	bh=OuJcI0tmUn8NkneothG+bXBiZF9oLCg3wfXglk840eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ez8SLaPm6kYlTUx/2xWf2SmEYJymyaNQgVir6yVdWb/o+DoexIQF3+FspajZ+WiNp
	 FirQQLQQTLvnW1owRjg0IccnrpaJM+mzLfjWuiwqxCW0s832kO8inAuAo4oR5z3I2I
	 ABHbp+o2bTgQQb4ZY4098YXetPtz5PVggU/sTPak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 081/507] lib/crypto: mldsa: Add __must_check to mldsa_verify()
Date: Fri, 13 Nov 2026 10:46:25 -0500
Message-ID: <20261113153756.514545889@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit 01ad209f122b7c173477bd60c7997564f9c65961 ]

Signature verification status always must be checked.  Add __must_check,
for consistency with e.g. the AES-GCM and ChaCha20Poly1305 functions.

No effect on current callers, who always check the return value.

Fixes: 64edccea594c ("lib/crypto: Add ML-DSA verification support")
Cc: stable@vger.kernel.org
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://patch.msgid.link/20261029054534.68481-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/crypto/mldsa.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/crypto/mldsa.h b/include/crypto/mldsa.h
index e0754879e7452..b156f166a1413 100644
--- a/include/crypto/mldsa.h
+++ b/include/crypto/mldsa.h
@@ -52,8 +52,9 @@ enum mldsa_alg {
  * * -EKEYREJECTED if the signature is invalid but otherwise well-formed
  * * -ENOMEM if out of memory so the validity of the signature is unknown
  */
-int mldsa_verify(enum mldsa_alg alg, const u8 *sig, size_t sig_len,
-		 const u8 *msg, size_t msg_len, const u8 *pk, size_t pk_len);
+int __must_check mldsa_verify(enum mldsa_alg alg, const u8 *sig, size_t sig_len,
+			      const u8 *msg, size_t msg_len, const u8 *pk,
+			      size_t pk_len);
 
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_MLDSA_KUNIT_TEST)
 /* Internal function, exposed only for unit testing */
-- 
2.53.0



