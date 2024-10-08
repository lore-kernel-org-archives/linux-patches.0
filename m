Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1261DE8A0;
	Tue,  8 Oct 2024 13:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392907; cv=none; b=KCPMUiin72ICnPZXsUOZT+bThPUmoSPcZusnL5S+zYHfClfNh+ix5VMTRi6eubH1/hp+X0XNo0+Bvn6EKfmgdd7vqCV09ro6iHZrTyXywuOYwFUIXy8odDnEwBsQCG8UssVJPvc9RJKfLSc6NL098SVxc1iw634hHmgB9xn/m28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392907; c=relaxed/simple;
	bh=qj6QxzpS6UzOqeBFvwMERb00yGjHR7HnGC24QTVtvEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQm0oodcKrDGWzdaiiFtzhrl+30vo2sLLHh+x/XEJ5MSfmR5bc/FM3KZfhwDgFSPCNT2tqsrJvNGx4khTDljM3XttHmy1XvXgkrbTniUrcGNDsjC/xQBZDIEkiN3/BpG9CLZVO+agGwYLHN8QO5NjxdzvMmXaADwmjDyREWr4vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0db9KQ1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0db9KQ1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D2AC4CEC7;
	Tue,  8 Oct 2024 13:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392907;
	bh=qj6QxzpS6UzOqeBFvwMERb00yGjHR7HnGC24QTVtvEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0db9KQ1qCvsR+0N9UxWeRUHswKyfX0a4b+g/heYGQ+drxolF7qjVgXToulBjsNjBk
	 j+p/fvDVWKIKZFXITUhMBNBzYqQAKkLs5rphoR+R+sjTC56gXzFrt2fXX20G4yzyQ4
	 lDv1vlZwdBY2sEGbs/7jAsh6u0d571HwV2ATJxpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.11 555/558] crypto: octeontx* - Select CRYPTO_AUTHENC
Date: Tue,  8 Oct 2024 14:09:45 +0200
Message-ID: <20241008115724.072532220@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit c398cb8eb0a263a1b7a18892d9f244751689675c upstream.

Select CRYPTO_AUTHENC as the function crypto_authenec_extractkeys
may not be available without it.

Fixes: 311eea7e37c4 ("crypto: octeontx - Fix authenc setkey")
Fixes: 7ccb750dcac8 ("crypto: octeontx2 - Fix authenc setkey")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202409042013.gT2ZI4wR-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/marvell/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/crypto/marvell/Kconfig
+++ b/drivers/crypto/marvell/Kconfig
@@ -28,6 +28,7 @@ config CRYPTO_DEV_OCTEONTX_CPT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_HASH
 	select CRYPTO_AEAD
+	select CRYPTO_AUTHENC
 	select CRYPTO_DEV_MARVELL
 	help
 		This driver allows you to utilize the Marvell Cryptographic
@@ -47,6 +48,7 @@ config CRYPTO_DEV_OCTEONTX2_CPT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_HASH
 	select CRYPTO_AEAD
+	select CRYPTO_AUTHENC
 	select NET_DEVLINK
 	help
 		This driver allows you to utilize the Marvell Cryptographic


