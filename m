Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590717;
	b=WJr/WQ/MXmuwy5QGcv7726Jr7PlNkT1NDtPxgmWbzxb6AOtWNST96IGF+i/IHTnuTHVk
	 PDZTbzcI5aqf5ljcV1J8NLukkQjuRiah10dPbnqPA72G3LwyMsYN5yzarYOhLnsFdC8Qx
	 D4RAk1EeSeDPJ/VBVV6W+GWRfv4D6YtacFSau3amhURY3b1L/aD1NWEBgv18WS7uE6e/W
	 fdddfoH4erouWZ3dzkjN4qrmQv709eaAmrJN4mCFcutHTD3a38oZuCVGF/qtTy1TwGj/6
	 BKCOW8M2DQnNQr10Xo3r5Hq0tmx3D+zt9XQe/fx6AVdAwP6VQL7ddDLRWTMJyg1EXIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n5btFGkPUkfBm/LJ8XOcQAHQEwIrMMTb3lOTNiWz4BY=;
	b=IwvFt47KJLBTZdDfTcrho2SrZoXEWg2UvPjizJnTZdz6guqd9ewT2oXhsIpUGoNaK/UG
	 6PqMU+zMX6/7zpZ1D2t8i+IbZ4z+4VRUsg7tnEOd7JdmIgue4f/iiYNbaP6bPfmox8jy9
	 dIHy2nOsvyk88XE1XGvmRLvG5foCgEE3aZ7V4L1t/HGQr6SE1BVyt4EZbAdnTfcK7t7kw
	 q9/wOL7//6s8b8iuKxMmaw41QhbZ8E+rMaTH9wjrbeHlSDpEKlfQleVWaF3ZlncHmiu+z
	 /fOPJuDdE202s2WrCeJTyATE3Ro7KHmwUNpz8NJPGDqUWl60E0kkfYSYfvorVwUOMcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O0JVaksF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F60A606B237;
	Fri, 13 Nov 2026 17:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O0JVaksF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6541F000C4;
	Fri, 13 Nov 2026 17:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590717;
	bh=n5btFGkPUkfBm/LJ8XOcQAHQEwIrMMTb3lOTNiWz4BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0JVaksF4UzCsdCKkm1nlC+oX6luJsAgnel+uJTPSCPb/YF0P8c3ZpSaWL/3dEFJX
	 XVcOk1fVepN6GoZMnl9mHTo6kUpa+3VgC6FMbjqDxShrfpP/nUmWiO3O0VY6LRkvBo
	 EGwBwduURCqh20fB3DObSTLTTgqF662h3oFF8Lgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 624/686] tpm: tpm2_probe: propagate transport errors
Date: Fri, 13 Nov 2026 10:52:37 -0500
Message-ID: <20261113153843.002363957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit 7d4f1cbfe063af5581dac66abe9e9c965e1031cc ]

tpm2_probe() reads the protocol version from the response tag and is
documented to return -errno on failure, but it always returns 0.  A
transport error (tpm_transmit_cmd() < 0) is thus swallowed together with
the intentionally ignored TPM response code, leaving TPM_CHIP_FLAG_TPM2
unset. A transient bus failure on the first command then misdetects a
TPM 2.0 as a 1.2 and the probe fails on the TPM 1.2 path:

  tpm_tis_i2c 0-002e: 1.2 TPM (device-id 0x1C, rev-id 22)
  tpm tpm0: A TPM error (-62) occurred attempting to determine the timeouts

Return the transport error instead; rc >= 0 still means a valid header was
received and the TPM's own response code is still ignored.

Fixes: 94e266ba1fa3 ("tpm: migrate tpm2_probe() to use struct tpm_buf")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20261001060114.1582092-1-alexander.sverdlin@siemens.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
[ sashal: Replaced the early return with rc = 0 so explicit tpm_buf_destroy() cleanup still runs. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm2-cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index c5465834396af..85496fc5306b3 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -487,9 +487,10 @@ int tpm2_probe(struct tpm_chip *chip)
 		out = (struct tpm_header *)buf.data;
 		if (be16_to_cpu(out->tag) == TPM2_ST_NO_SESSIONS)
 			chip->flags |= TPM_CHIP_FLAG_TPM2;
+		rc = 0;
 	}
 	tpm_buf_destroy(&buf);
-	return 0;
+	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm2_probe);
 
-- 
2.53.0



