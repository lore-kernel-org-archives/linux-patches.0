Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030588;
	b=gRyOL/RPHkYdmuHfYO74ZTxRVf6nKM53W4EXiDqBXHBzsTIAHwe4+AXgKwmZVdiJiIJ3
	 3oSaHnUAmw5slLOe4PKUA9pHePKOmPJ0rdqyA1gayWZPSLJTP3hEjxwWVGzRQB1nXj9Il
	 m8Ys3Fu59/1QKZ3Fa6Oe6i5BmjOk5esZj+fJWQuhJmfjMvNZOtLqIvrEUPLfvPX/5ZWW4
	 IbwsgnO/C0Bmg6pp0x0vVAPj9uPL7PnddMRisfwcW88EWWwwSBvWiS1Ys5U5kRRCAzx2C
	 URStFHbIB4Jl8zBBqiTWYmpQw0fzyz4k2ls6yQrpsay/GkwY7E2Vfujmz43o/n4TF1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zLloxc2Wxk8BDI0cHRiU6QbpGjVSlRf9qnPvPgbZxx0=;
	b=BbM1/nTe7x7A3EwuMlpgFeCGn3GtYoKBX7LscIkKfD4TmMTmBzfqwedLcUixX0Noj9XI
	 JojC9y6PtkZwehHQLhnSeQMsOk3KdrmMwlrePkuQSH1j0DRZ6f+4PBtaLxdKVfGHnsGkF
	 P0J6eOEgKj0g246gmtPIv5QIvc5uvILBFV/0ndi2nTuISdlfwPg3nHEKRY/47DGtoaMVj
	 BHcjxQx1Uq8/SFLN+S90Q/IMcQPC667QzjgIdF/w6Us+Hvu77LTEIU6iYEnKQfZpU7Uco
	 nyAR9oOf5SY4KMu69QgQd3MOeWBv4CPl0Vh/BLqwSL4epkEVm+moW4YhgcYcgYkji3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b9QqzOxV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D26460A6F64;
	Wed, 18 Nov 2026 19:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b9QqzOxV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979621F000CD;
	Wed, 18 Nov 2026 19:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030588;
	bh=zLloxc2Wxk8BDI0cHRiU6QbpGjVSlRf9qnPvPgbZxx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b9QqzOxVYVmdUjFOagsym+M4WCCI2PDLPhOd/Pc66TcNd+K/NCgwmnctoZlFGStXZ
	 f/MnVSiA4AnIazW6lpHxTYLn7SMyCm4hcCSGrzr91oIoZbJ3ubyaGPgu7kc3xsuePi
	 fKUyrHOxBMk/tSvkVKf4Fg6Ybn/Iih68BTyosuSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0759/1756] hwrng: intel - return -ENOMEM when ioremap() fails
Date: Wed, 18 Nov 2026 15:48:06 +0100
Message-ID: <20261118150039.838850840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 4c3ca7c8c152278332590bfd3df1b0f086364759 ]

intel_init_hw_struct() incorrectly returns -EBUSY when ioremap() fails.
Return -ENOMEM instead.

Fixes: c24c95a085c6 ("[PATCH] fix Intel RNG detection")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/intel-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 94f7116e96682..789a5c709ba87 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -318,8 +318,8 @@ PFX "RNG, try using the 'no_fwh_detect' option.\n";
 	}
 
 	intel_rng_hw->mem = ioremap(INTEL_FWH_ADDR, INTEL_FWH_ADDR_LEN);
-	if (intel_rng_hw->mem == NULL)
-		return -EBUSY;
+	if (!intel_rng_hw->mem)
+		return -ENOMEM;
 
 	return 0;
 }
-- 
2.53.0



