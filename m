Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDC01DED79;
	Tue,  8 Oct 2024 12:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391061; cv=none; b=Rok9MwNtQIk/G2lJ8DxWQuxMfdESL49G7HIYKq71sdltXxrjjodny40IQLKBM0oJrepP3IS2Gvbq6Ovs9gzCTng3bmLV7bhiN1dc2UHbGyaa9wAQw+3uxLQSe8kRrCFi49AH4SHeiM9KdpDu6C0wDdpBOcNZ1znyuLLw5EAtcqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391061; c=relaxed/simple;
	bh=9JJxbPhhY5hVq3ndOT+LP5l0WFhKDhSlGy9hAHcko9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnJxPTxn+IQrKj/VfmcYQX3x4J93tO6xT0PjTuac39v+9+fGkCY7KN0Q0/MIgezVPWJrJvZi4vvSMw+DtF6I8FyXBpUe3tk0NPh721IxIiYrVnY8JkUgaBJ4P6sx0YYeShNYoxy9ty1DzSLPH3oz6Ov4M8/nMAZoCGcwM+evTFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gM0GIVX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gM0GIVX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF879C4CECC;
	Tue,  8 Oct 2024 12:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391061;
	bh=9JJxbPhhY5hVq3ndOT+LP5l0WFhKDhSlGy9hAHcko9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gM0GIVX5Em3Z8zbefzgbAMWwaA6l7Alvhal3cb6KksoQUqePxAEDK//vEeD8E4LFx
	 y65FDxeobFu8/klivzZI6R1UVMnUol6ClifbKpXbh/zoAuNjA0PE+ai3upYGjCrIK/
	 6i57nytsE0aVDHCZNZR8z3xEmQgYRHoGB2KE6qAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.10 479/482] crypto: octeontx* - Select CRYPTO_AUTHENC
Date: Tue,  8 Oct 2024 14:09:02 +0200
Message-ID: <20241008115707.359587482@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


