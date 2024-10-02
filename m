Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3AA1D14E5;
	Wed,  2 Oct 2024 14:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878385; cv=none; b=uMR6tMJO/2XiYECbRV5KnL5zcy/B4fu1xQGUMV5gVxAhGYXPdr2cLIaoGs6sD4QCNDdIKGUvRQzcC2MtFvFU11rLlMIGFBUP6mTu/SqGfyhtXcpqI39kvdhQMfG22cV9Z705Y4BsVZVYbUIkjWSuKXTf8O91IanNN22dsBX7J9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878385; c=relaxed/simple;
	bh=w3AzHHK+TM/LzW6+7OlUC9wbRtah86zvaYQaUxsFHfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKiD3tuU/7R+IRvfksJZouc3U0gQG/ijosSrZVDvPElBqWRgqvkIV4+g05dIeloN4T8QjMBqaXVZt3rXLvYWm1AVA6Ju5ZyItnT5q1AEdOeFsXHmwUCyHlmmc1vJ7enNoYqOyyt6AWfw7OKDHCRt8YZGd0i/17A2zYwz3k+sFZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwJuIDym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwJuIDym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C4EC4CEC5;
	Wed,  2 Oct 2024 14:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878385;
	bh=w3AzHHK+TM/LzW6+7OlUC9wbRtah86zvaYQaUxsFHfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwJuIDymxC+PTZTlvOQ0wB1YHxigT41LyMQD5khd5MuSXMAFqdx5iH6VKMY4mJR2D
	 bszDMM62oxjrN8VZzk6PZ0LtWzhchnTpla4ohe90BtDs/UYeBMD4BbBvTONwT3VWnM
	 mgWP3I2FgDc8RDKrKtnnZhtfSmWPe53/2qZLy0fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danny Tsen <dtsen@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 395/634] crypto: powerpc/p10-aes-gcm - Disable CRYPTO_AES_GCM_P10
Date: Wed,  2 Oct 2024 14:58:15 +0200
Message-ID: <20241002125826.695014223@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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
index 1e201b7ae2fc6..bd9d77b0c92ec 100644
--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -96,6 +96,7 @@ config CRYPTO_AES_PPC_SPE
 
 config CRYPTO_AES_GCM_P10
 	tristate "Stitched AES/GCM acceleration support on P10 or later CPU (PPC)"
+	depends on BROKEN
 	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
 	select CRYPTO_LIB_AES
 	select CRYPTO_ALGAPI
-- 
2.43.0



