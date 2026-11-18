Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034325;
	b=IAonWcdsZohNCj2nrLNP/oaKYKYZ4ZOKvpzlaptneCHsXU288M9Hjn9F+ufkMWjGUUn2
	 +IioXi3ck0CbzjdR4/KMUyKYfewZjR+mNY1cMH687ez0u5JeX+1eWqnhNLXi0lDb1cHDu
	 va+XUYTfASrurd7SDNazbK3QUzmsQFzBxhy2dFmpxTUOOwyi3ARu4hZAJvvfGMJz03Ayp
	 m2GWJk7qgNVbhix2sKU7vYlyc83c97CuxGt5lWvZ6HplZP794O5EC/zSL+8JKxILV8e7g
	 2/RCepI/+8tfC1XL9S/LU2+piFuBzBL2idBjVFo95PsMRrLc/yet6JwuclSizqpJXww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ap9cWCGTG9+k9H4CbPVZYnc4t62znK2j9qUAYhR7a2Q=;
	b=4MbAw6Eo7ep4nIulSjYkerRVXYhqQKVw92qPw8QqgPdnO7jXcKsjX07Fnlb0d9L4lXNz
	 1Gr5ngpWWdrp1g5/T0tQNqBLlaipFsqjpsz8hYmYHyW3mbu3BAVeqq9tgfhPzsGQx76aI
	 8mhG1hQtT9ei/v2tgflKQhaWT3BdM2/DBIp3qqJMOOQD0qF0miVoklFxSY7dIk3D08HDX
	 L6/rruuCsZJeMK57jGOSNmrrhi8tsHEd0bQKDqtdH9UEpVfVtCdZ+i1xDxM/j2epvQ868
	 4aTScIIzrRE65EGcvT07d+BhIXx9svMWPj3rGzAA7quvE2gkKwRXbomBnlZUcqIAAEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hq81LJMv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC2F606A320;
	Wed, 18 Nov 2026 20:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hq81LJMv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847331F000C4;
	Wed, 18 Nov 2026 20:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034325;
	bh=ap9cWCGTG9+k9H4CbPVZYnc4t62znK2j9qUAYhR7a2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hq81LJMv/yprb5vln1CLNjsoG6HodQhuZCmaus4Rp3LmfWn1Kon7iMyfnD7S1l88Y
	 r2g4jn+lIovudOqIhVbOMNC3hi0gArP5WqxOCdc6JRsAooUrQd6//Eu0SVwIKoO4yT
	 +6HMBV1sfwIF04tJ7pVmo16CUgjKZI5Q/5V2EFNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0327/3318] tpm: tpm_tis_spi: fix nodef CR50 tpm_tis_spi_resume is null
Date: Wed, 18 Nov 2026 15:15:49 +0100
Message-ID: <20261118150325.708755707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Jun <lijun01@kylinos.cn>

[ Upstream commit b4d1adc70471d0752bba674552d19971ed9fa869 ]

if no define CONFIG_TCG_TIS_SPI_CR50 in config,
the add of tpm_tis_spi_resume is null, this cause the tpm chip to
fail to resume.

Signed-off-by: Li Jun <lijun01@kylinos.cn>
Link: https://lore.kernel.org/r/20260812100914.3540149-1-lijun01@kylinos.cn
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_spi.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_spi.h b/drivers/char/tpm/tpm_tis_spi.h
index d0f66f6f19318..ced416ecd92c2 100644
--- a/drivers/char/tpm/tpm_tis_spi.h
+++ b/drivers/char/tpm/tpm_tis_spi.h
@@ -40,8 +40,12 @@ static inline int cr50_spi_probe(struct spi_device *spi)
 }
 #endif
 
-#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_TCG_TIS_SPI_CR50)
-extern int tpm_tis_spi_resume(struct device *dev);
+#if defined(CONFIG_PM_SLEEP)
+	#if defined(CONFIG_TCG_TIS_SPI_CR50)
+		extern int tpm_tis_spi_resume(struct device *dev);
+	#else
+		#define  tpm_tis_spi_resume tpm_tis_resume
+	#endif
 #else
 #define tpm_tis_spi_resume	NULL
 #endif
-- 
2.53.0



