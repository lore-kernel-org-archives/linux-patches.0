Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C5A268688;
	Tue,  8 Apr 2025 12:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114567; cv=none; b=EDiXOUXqeQf0QCSF3jVuGdrOANhDIkmnKorAXeom1OaL1lCKhvRKejIBU5Sf7gxPUTWzTdrsnsJcOmZnYy1yRfCnaf+5rftJW5lOUs5SjZ0FwMSWC9Q05fFDp/gZLz+/VW089sqK2zxn4fsNLr0pil6c88jTJ1j9J9UaBKViiVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114567; c=relaxed/simple;
	bh=Ywu+Lg/f//3fanT9dwu2QelGiUstkMotIB8jIuYVURE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUx151EKIqDX97jLKdroeJTcej7e2yPE8a0oAkQRFix7z10QVz4AAUkpEd5e5g5XdRrBwlzfnIu0czviXgxG7WiH/i66Mqb8SWmSB7E+2rPFJB2xj4KL+xcSKmOaYm8eboBUl4G/1BF9o+4o5gb7TLa0EK3gjdQMcxDrLxhHLDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wex9koSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wex9koSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0414EC4CEE5;
	Tue,  8 Apr 2025 12:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114567;
	bh=Ywu+Lg/f//3fanT9dwu2QelGiUstkMotIB8jIuYVURE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wex9koSFITQzyRsU5N5oPk1mGH0imqBCdr16prfJnTMv1fVRzrn1AulluUuaFoCl7
	 03dvYdkXH52pW2gVsqF7a2vMnjzR8z+GzYV+QRbDkqW46y4pau/JW/2O04/nMLOVeD
	 pVn0JGMjXCZ6udlB8B4hhzLWrMHptbHMMfQFywWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 127/499] crypto: bpf - Add MODULE_DESCRIPTION for skcipher
Date: Tue,  8 Apr 2025 12:45:39 +0200
Message-ID: <20250408104854.364227717@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit f307c87ea06c64b87fcd3221a682cd713cde51e9 ]

All modules should have a description, building with extra warnings
enabled prints this outfor the for bpf_crypto_skcipher module:

WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/bpf_crypto_skcipher.o

Add a description line.

Fixes: fda4f71282b2 ("bpf: crypto: add skcipher to bpf crypto")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/bpf_crypto_skcipher.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/bpf_crypto_skcipher.c b/crypto/bpf_crypto_skcipher.c
index b5e657415770a..a88798d3e8c87 100644
--- a/crypto/bpf_crypto_skcipher.c
+++ b/crypto/bpf_crypto_skcipher.c
@@ -80,3 +80,4 @@ static void __exit bpf_crypto_skcipher_exit(void)
 module_init(bpf_crypto_skcipher_init);
 module_exit(bpf_crypto_skcipher_exit);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Symmetric key cipher support for BPF");
-- 
2.39.5



