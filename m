Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9CB1D0499;
	Wed,  2 Oct 2024 13:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876404; cv=none; b=gbQLzVp6NbfPUfDuKymmbdx9xfvJ86vUFGmDPQ1Qv9Pq4Cn9qMyli0/atzwTVTZ7Vx7d1Qr8L5TvtY5dB3s/DucsYngdaDb03zjCcT1cbtaajyhkMmWjpfzMR8e0zcTcHw8fmoS3uki8AOEKVW5GYEVHoXh4/KcVncJix3htF1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876404; c=relaxed/simple;
	bh=MkhGxguf/GiAySUFRz37FaTjquOyIp+dMWSfVZ1T+oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCFXVseahZZhUkh2bAlhRbroxh40qfUMYH0mv/CdNj/FjC24SNn/M29gtsqHxe6d4z2cutMml1V4rbFmqldy/pQWCc1Gj5hhMkxHsqga2jj4mLfQKVIEKPzSVIEpsWoecfW8+7t2bSzR1q96EgfJRHKcjIqwks5AhosGuS32tX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qH2DaODc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qH2DaODc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B1EC4CEC5;
	Wed,  2 Oct 2024 13:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876403;
	bh=MkhGxguf/GiAySUFRz37FaTjquOyIp+dMWSfVZ1T+oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qH2DaODcFtFLSMLv5Pi2eNhRRfSwCMEAgzUiQbKUslhkSibPFWbW3i/O2TnoCMHSZ
	 0ZEVtpzmVVwZ83z78W5pLyMU3NXSha+UEICRCkUbH3NTF7J8jB6VGYVKQvD+xe0EiU
	 myjifVXqW718EvhrbTfwhCYfTUX++UWfYGw1bYaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danny Tsen <dtsen@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 433/695] crypto: powerpc/p10-aes-gcm - Disable CRYPTO_AES_GCM_P10
Date: Wed,  2 Oct 2024 14:57:11 +0200
Message-ID: <20241002125839.745325213@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

[ Upstream commit 44ac4625ea002deecd0c227336c95b724206c698 ]

Data mismatch found when testing ipsec tunnel with AES/GCM crypto.
Disabling CRYPTO_AES_GCM_P10 in Kconfig for this feature.

Fixes: fd0e9b3e2ee6 ("crypto: p10-aes-gcm - An accelerated AES/GCM stitched implementation")
Fixes: cdcecfd9991f ("crypto: p10-aes-gcm - Glue code for AES/GCM stitched implementation")
Fixes: 45a4672b9a6e2 ("crypto: p10-aes-gcm - Update Kconfig and Makefile")
Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
index 09ebcbdfb34f6..46a4c85e85e24 100644
--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -107,6 +107,7 @@ config CRYPTO_AES_PPC_SPE
 
 config CRYPTO_AES_GCM_P10
 	tristate "Stitched AES/GCM acceleration support on P10 or later CPU (PPC)"
+	depends on BROKEN
 	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
 	select CRYPTO_LIB_AES
 	select CRYPTO_ALGAPI
-- 
2.43.0



