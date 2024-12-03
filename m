Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6371F1FE461;
	Tue,  3 Dec 2024 15:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240160; cv=none; b=Yx+NQuugMvFL13gAnS6WOzgz6AELKBn6wumPOD+fTcLZY70d1jf/YEUVb9q3JSOTH5Rm6b2kAzyXYzhg+PC6ySh2ibAE0fyRHYeDEA/Bu5oVAnO5HAtCAOToqD4ow0X4M3DBB3JCc9T3/gUo/kkoS/YqS2fdbXajgPPQATLBgBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240160; c=relaxed/simple;
	bh=a402RMWg1/Wj7+tfc3y2q72FMjaufjo3WjFvCEmhtJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEqsjIPWKbTgyUSqNMQsTdDsqjF2dPB7LS8DdafrT43waaBt+hV8OxtP9GffMAGY/ZxJ/SyJcsw5D2+qgjXkMW6hbBO4H8xspJRmt9ZSCOfY9vdSXkx85m1K+aIPkIm4bWH1rDFxxvpRSAE6TiXzdcYpFjBfrS+5ELlY+q9lEfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foDsTPsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foDsTPsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D99C4CECF;
	Tue,  3 Dec 2024 15:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240160;
	bh=a402RMWg1/Wj7+tfc3y2q72FMjaufjo3WjFvCEmhtJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foDsTPsFADUbDoYUn4G/YRIwywlGEiD+eopYHcz6nkFFzG0BFPlsi7s+c8WS99NpA
	 iDQFU3dGkGtd+nUe6kh5bACl5BDsXHtH04w/Aas49r3goAaCf522rO2ZnfPLX8TzTo
	 VL6etp5ppzZNQJVgKGB85EXTByH1AnOSbAdejPWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danny Tsen <dtsen@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/826] crypto: powerpc/p10-aes-gcm - Add dependency on CRYPTO_SIMDand re-enable CRYPTO_AES_GCM_P10
Date: Tue,  3 Dec 2024 15:36:11 +0100
Message-ID: <20241203144745.183876034@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



