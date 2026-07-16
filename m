Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B736400982;
	Thu, 16 Jul 2026 14:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211250; cv=none; b=qChjKZBsEHhgx/h/jAry9EjM1G2r13mpUhhE4WYDMMXhnXJNlHBTD+/KoCRL1Su8JeB5IW+5SsbwTRfwCKq2g+gBnZ7fUQVkhbgQ17J32pKA3m9r3S/2SzLoyLf0LO0vKGDtvwd/F6T8Zf8oO+v0ONf6M/o/pf26nkfj21rLA8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211250; c=relaxed/simple;
	bh=4aUvLiUy+m41VvezhYhc9gzqMuA7RV/WjVSIpedY/Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0UxWG2IojM4ApOted16kUvzBxPqnWk4E25YGfzmgb6QFBrZ1m+9eXm+hB9Y2V0T10afduLNkayiLavQKIEyX9d30nKGN9hy2P0whKrr+15K7FHKhajTw33L1rh7twrL1A32VAKeGxrxFJeO5x4jC9vcwla3Wtz73MusQAKNAZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKEWci78; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKEWci78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CB81F000E9;
	Thu, 16 Jul 2026 14:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211248;
	bh=fD/lKpkDPASd2zpoR5OOl7ABLNl42ZNQWdxlLxn5rDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKEWci78pG+wle1Hb12Wn1NSeVLVWAoLS5WeRU4b6zOzdb8+IF9RS0EHJS6Cf/OC5
	 N3c8nJ3DkJ9+JwAf2xWmygy19Cfv/d0cSaskNCFfe7LjodhJtIPv/tpXrR9M3sjC0I
	 MM4Bv0DzgsyhYuedh1s7ZiKYCiMsTOnI9RQ/Fh/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 355/480] crypto: loongson - Select CRYPTO_RNG
Date: Thu, 16 Jul 2026 15:31:42 +0200
Message-ID: <20260716133052.484400037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 4c600ab0d8cfc9d75b92f3426dbcb2ad85eac91d upstream.

This driver registers a rng_alg, so it requires CRYPTO_RNG.

Fixes: 766b2d724c8d ("crypto: loongson - add Loongson RNG driver support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605201622.qWOiiZTV-lkp@intel.com/
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/loongson/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/crypto/loongson/Kconfig
+++ b/drivers/crypto/loongson/Kconfig
@@ -1,5 +1,6 @@
 config CRYPTO_DEV_LOONGSON_RNG
 	tristate "Support for Loongson RNG Driver"
 	depends on MFD_LOONGSON_SE
+	select CRYPTO_RNG
 	help
 	  Support for Loongson RNG Driver.


