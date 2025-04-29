Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609FE242D68;
	Tue, 29 Apr 2025 17:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948404; cv=none; b=Ssq8bfyPZCaBbiqTfQi+r+vgNU+vPNTVrcABRLFBM/sgtt8P9r9WK9hQ825uon5R3XA4QeHJBXSA9Nfnhc55SqJz/509y/i9lh5ClfO51+Z1AP4ctYDhjzkNWp/9F1E1E9C9Vjuvt77ROHi/3An+IVhwPYpPXVMswBSPnxlr3gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948404; c=relaxed/simple;
	bh=rCJjrf5ApUhG4LSPxd6/Xo7zIeAe6GuKvaqdy3HHD3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y52xwKJkWCjhF/g0Z4+axc9F9iBQpz0EcroRwlsA11P/vF2un8F6vhgtWLlc6kRvD/zYe860LMtyKDGwhAYsxiyJ0Owmh761OsSZsRlDPqGQoWX4JWDslVLqbPgFqoeXXgdEH7MUDmsDaRC9GoGkZSio+qtAl10hXdAo/cA8Oxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEiS27fm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEiS27fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB83C4CEE3;
	Tue, 29 Apr 2025 17:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948404;
	bh=rCJjrf5ApUhG4LSPxd6/Xo7zIeAe6GuKvaqdy3HHD3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEiS27fmiTK5pmaAArvS78OLJuq8Inqk5FA28HLomaZ7gW+eeCoAbrgDDlG8L/MjO
	 QYfO1HV5GLnPNKJ+Qlqehu34v1Gr5ZT5ahw0/MxN6JX1prTnBHgD6bRoZKytvSoxCc
	 Pop0m7cwQ5EzyoaXuJCVK5RyqYuXS/FF8Dc+iYTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 278/280] crypto: Kconfig - Select LIB generic option
Date: Tue, 29 Apr 2025 18:43:39 +0200
Message-ID: <20250429161126.507624175@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 98330b9a61506de7df0d1725122111909c157864 upstream.

Select the generic LIB options if the Crypto API algorithm is
enabled.  Otherwise this may lead to a build failure as the Crypto
API algorithm always uses the generic implementation.

Fixes: 17ec3e71ba79 ("crypto: lib/Kconfig - Hide arch options from user")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202503022113.79uEtUuy-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202503022115.9OOyDR5A-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -316,6 +316,7 @@ config CRYPTO_ECRDSA
 config CRYPTO_CURVE25519
 	tristate "Curve25519"
 	select CRYPTO_KPP
+	select CRYPTO_LIB_CURVE25519_GENERIC
 	select CRYPTO_LIB_CURVE25519_INTERNAL
 	help
 	  Curve25519 elliptic curve (RFC7748)
@@ -614,6 +615,7 @@ config CRYPTO_ARC4
 
 config CRYPTO_CHACHA20
 	tristate "ChaCha"
+	select CRYPTO_LIB_CHACHA_GENERIC
 	select CRYPTO_LIB_CHACHA_INTERNAL
 	select CRYPTO_SKCIPHER
 	help
@@ -943,6 +945,7 @@ config CRYPTO_POLYVAL
 config CRYPTO_POLY1305
 	tristate "Poly1305"
 	select CRYPTO_HASH
+	select CRYPTO_LIB_POLY1305_GENERIC
 	select CRYPTO_LIB_POLY1305_INTERNAL
 	help
 	  Poly1305 authenticator algorithm (RFC7539)


