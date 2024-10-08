Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB6313959D;
	Tue,  8 Oct 2024 13:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394214; cv=none; b=azEpMesJtvswFGsUJPOsgCkYp+NBeIV2m+l/Gup1TYsZbpOsvAdZRJmVToIjKr2cWR+CpzkwMESEFZG9qDlbPHpStdyDI89R3MC02JMSE4AJLWrCc8Ow4uCxLjVrf6EbH9sCPR9YHcWhQkQyWvtQ3s3OmK8J24oFSE/l4EaAJfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394214; c=relaxed/simple;
	bh=EheaDuRlFHhnQEPXj0aXk5Fxep2iIvKu48Fdwc/HP0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNZ0OXdJLho/lWMVQ0Qra2XN2oXR5Fhi7mblpH7SYvEpphgCQS9uXqTtP+Dd0r1wICncsna0Y4n/DVr/DnvODjiEx09Civ88q46tudEEH3kdT/n1f1S/WqkYTaTFTHo+f3+1PHkna0a42JqrRP1KwZ0vl842oOwH8nzCe44vjKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZ5PLABQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZ5PLABQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8EBC4CECC;
	Tue,  8 Oct 2024 13:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394214;
	bh=EheaDuRlFHhnQEPXj0aXk5Fxep2iIvKu48Fdwc/HP0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZ5PLABQTYuVXCLByZmX9HJz0BT0GgPSF7+Y43nVF8ZyhCAnHxBLGFtBt/gw6rNoC
	 5pPepxAZZfLxLI2mUKQzDovPDrxp6Y3OxN1cv+zHQCIh1r3gtuE7p1uJNfOMnCj0hy
	 MBmslHLnZconfYOzxKXdVS6KfE7PVziTOTCW3tFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 381/386] crypto: octeontx* - Select CRYPTO_AUTHENC
Date: Tue,  8 Oct 2024 14:10:26 +0200
Message-ID: <20241008115644.385949750@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/marvell/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
index a48591af12d0..78217577aa54 100644
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
-- 
2.46.2



