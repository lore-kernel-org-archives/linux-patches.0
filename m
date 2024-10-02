Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46816405FB;
	Wed,  2 Oct 2024 14:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880164; cv=none; b=pcef0rYRVeF1ORH4rFjLW08VSa+iNXgVv8fdEwT9NM7iM5A0xhD9Evs2vSpBPFyQPyGKcLBYf0ewUBNBQeO+NsCgthKFdl2p2zEMTJvTQC1tO2ZWhpZUULG6rt1aIuYqMQPkX0bWSHwnKVFANSux8pGLt2s5qTHslCreg5UzWXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880164; c=relaxed/simple;
	bh=9IFDWR0JXnMYiP74i/K6IRbtu4qY31ThpFyYMZHO1go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tz+SJx5+eMgZ4mXRTgaHgXXEqAHO75n+ru1CiWHknYSNrw2k67sy5T4aWMMard+TpgVoVQTeOjXmPXr1EuHL/LfV5j+tcAtsVCwoxlmRtXaj39ouYVsMcAgTxHORBeisy0YpDux/t4oczM7KA9dt6Cbk8Ckup0CGEK3KBLsh4bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LmoXZVxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LmoXZVxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4434C4CEC2;
	Wed,  2 Oct 2024 14:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880164;
	bh=9IFDWR0JXnMYiP74i/K6IRbtu4qY31ThpFyYMZHO1go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmoXZVxB+gkKnt/Cz6i2xf5PEu6HPEzzkCDL8IhhjnigH9u/DppykMwSz/JsIHonK
	 DTMWT28tcaNy0V5hDv1AiaMxGSxxTk5PugGNRr8W5cO8Oqa1CCwAvs+3nvP3aCNjNy
	 Ro21XgEbENtM/i7DwiA97tsWaZ7KTmZooL1yLBFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danny Tsen <dtsen@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 333/538] crypto: powerpc/p10-aes-gcm - Disable CRYPTO_AES_GCM_P10
Date: Wed,  2 Oct 2024 14:59:32 +0200
Message-ID: <20241002125805.575927873@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 6fc2248ca5616..fccf742c55c2c 100644
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



