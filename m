Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20043424641;
	Thu, 16 Jul 2026 13:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209919; cv=none; b=a7zn2zZG5lPBm4jzy0OmlwTCDJIlg0kOdIZclXV12/kIs7j0QSO/ekz2m6yni6r2G08y8qp9ol/7a33r7TWueVPiLK1S54FFH/a6EstxocamP9/DuZVDlN/zITowdvdeF+8pzrKmy/O+AQrVE11NrDnsKKPZrDPTya9XYtS7aok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209919; c=relaxed/simple;
	bh=VZTAt/iYdyUzYJaQ6AlTHVz6sT4H6kY7VetS+7Uf9jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBHHkpTCCKIFleoap135GS+3i992ruZLBNErvXC3dT0meaH/yFPl4hOE6Ur4x4bVeYhw9NDkZnx4ClGyb9M3XscuddIk2aFKBYLc2tS6XKY810VcEm8VTsy6XMszt/pRGMRANi7na9KCNZiy/pBzJsfpxzAsWIvZOFL1AyX+u9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyQNuWiq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyQNuWiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D22B1F000E9;
	Thu, 16 Jul 2026 13:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209917;
	bh=JpWpu0H1VxCnDLZwXtFdPNq/NvtJrYgX5gfE59XIRiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hyQNuWiqsQyeITMesy27xNk3PsVP7lVlZw1SbC5yIbFaawyIUbEII5oIIb64EK7bV
	 MNmnsP51pK3/t0gfdypsgP/+yeiCJ5bjt/+mH+eFJiihinmG6UGAKZyg60iio9lcA4
	 bZDin3AXmybjUREj+eI49mHZZJ5EYZDoMbee8mEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 369/518] crypto: loongson - Select CRYPTO_RNG
Date: Thu, 16 Jul 2026 15:30:37 +0200
Message-ID: <20260716133055.902992689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


