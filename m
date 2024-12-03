Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3991F4283;
	Tue,  3 Dec 2024 14:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237871; cv=none; b=bxk0c1nXIlNIlJ1t/01DlsH47hlusiFbU/U9fo+O+ceT0OMVZOnrgCt5GsxzTkCXbI1aSiNl/Eg2yrrGUh46yRZrKU8TghHVsKPFrsJ6Qe7gTAQ7M1BGfJ0/0j3JI61Dampso/3FFwNscBaRULUQQKxEQug9u/JkgF78OeRhz/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237871; c=relaxed/simple;
	bh=DzkyBjfzY1D0GLhdWadJrm9ljIbkWKkW0Rlh25Uw7lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5uDVV733TSxnElZtpMStz5eLofH0vLjA2kI48vDEIkOFXKMAY3p50rZWHVXhFdt50kfPZuwzqWxkkUuybComG66RVBd0IiV0b5UNhhDju8nCokGcbg2Xsa6l5O+iOy+x5UF8ZSOu56ksPnyrRvNiEct1bRmU/ocheJGxJieJas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDbnnC/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDbnnC/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8931AC4CECF;
	Tue,  3 Dec 2024 14:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237871;
	bh=DzkyBjfzY1D0GLhdWadJrm9ljIbkWKkW0Rlh25Uw7lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDbnnC/6cBpOulGASa7jdj8JPb/+iMPh/fHEcflvaMJpjeCRAJhe+Jlufm+T/9y/8
	 gAQ0liwjcFQJOc2QAoabbaYZNpHZ1xPcxDAmqUpFNdWg3lZ0MC7qdCyIrunIQnXz5p
	 1kPkEdOkTBYijpTGgSYDoUvWe7IPVVN4FPMGpotc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danny Tsen <dtsen@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 092/817] crypto: powerpc/p10-aes-gcm - Add dependency on CRYPTO_SIMDand re-enable CRYPTO_AES_GCM_P10
Date: Tue,  3 Dec 2024 15:34:24 +0100
Message-ID: <20241203143959.293289937@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Danny Tsen <dtsen@linux.ibm.com>

[ Upstream commit 8b6c1e466eecab70c2ed686f636d56eda19f4cd6 ]

Added CRYPTO_SIMD for CRYPTO_AES_GCM_P10.

Fixes: 45a4672b9a6e ("crypto: p10-aes-gcm - Update Kconfig and Makefile")

Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
index 46a4c85e85e24..951a437264611 100644
--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -107,12 +107,12 @@ config CRYPTO_AES_PPC_SPE
 
 config CRYPTO_AES_GCM_P10
 	tristate "Stitched AES/GCM acceleration support on P10 or later CPU (PPC)"
-	depends on BROKEN
 	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
 	select CRYPTO_LIB_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_AEAD
 	select CRYPTO_SKCIPHER
+	select CRYPTO_SIMD
 	help
 	  AEAD cipher: AES cipher algorithms (FIPS-197)
 	  GCM (Galois/Counter Mode) authenticated encryption mode (NIST SP800-38D)
-- 
2.43.0



