Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750C222A81D;
	Tue, 29 Apr 2025 17:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946595; cv=none; b=GIte3OLEBwDYrNnN/bAjfJ97xcjZgY9ZD7qs1mgfm3x/ghb7pzH1n3ELuHFDieEA+8nazCix1zZyXbfSh+DhIRVN1Inq7Oy/pGCY0NUk+VdYpM3LHKooAMCWVfVpKDv5waKDNUMm3ACbSH7bfA6XJgB7GnrGhNuII9F2JfE95io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946595; c=relaxed/simple;
	bh=dR9eVEHnys1vpJppULb1+Wmdwlh35JxDFjRaINSwJ0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHrU7FSt7GGWjBbLSXawcRg331yWz+/4To4SCmUOtsBVHagV1udBkkhBjTHws9JdDjWbo5RTwLe+zBz7v8DP6/q4LKqrXM2kHRCWdxKclA1m95qZ1GNUN/tSvzZLlg1qKT1tvEHVbrI9w/CTU/obOzndsGGL/SmX9qQlzGRa4po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fty/GdgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fty/GdgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D92C4CEE3;
	Tue, 29 Apr 2025 17:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946594;
	bh=dR9eVEHnys1vpJppULb1+Wmdwlh35JxDFjRaINSwJ0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fty/GdgDC03W9O2bwRHZss5NBYL65pessvOvgCllxt/VXceU/nJGjplEi5OMQAAiV
	 j2JAzkMbsge9skmY9rYWZXwQTFE0oVjgV3pI8vL2KQOUblkKkNvfV/hiWFU+RwegQv
	 7YVi7/AqXFzypZ1rw7lEM8e78PYiDuIHcQWzxU/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.14 311/311] crypto: Kconfig - Select LIB generic option
Date: Tue, 29 Apr 2025 18:42:28 +0200
Message-ID: <20250429161133.731791691@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -317,6 +317,7 @@ config CRYPTO_ECRDSA
 config CRYPTO_CURVE25519
 	tristate "Curve25519"
 	select CRYPTO_KPP
+	select CRYPTO_LIB_CURVE25519_GENERIC
 	select CRYPTO_LIB_CURVE25519_INTERNAL
 	help
 	  Curve25519 elliptic curve (RFC7748)
@@ -615,6 +616,7 @@ config CRYPTO_ARC4
 
 config CRYPTO_CHACHA20
 	tristate "ChaCha"
+	select CRYPTO_LIB_CHACHA_GENERIC
 	select CRYPTO_LIB_CHACHA_INTERNAL
 	select CRYPTO_SKCIPHER
 	help
@@ -936,6 +938,7 @@ config CRYPTO_POLYVAL
 config CRYPTO_POLY1305
 	tristate "Poly1305"
 	select CRYPTO_HASH
+	select CRYPTO_LIB_POLY1305_GENERIC
 	select CRYPTO_LIB_POLY1305_INTERNAL
 	help
 	  Poly1305 authenticator algorithm (RFC7539)


