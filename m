Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591544;
	b=yB3t+nACuujtoOzU9i4FbsFbq3ciJGo2/V50Hh6BIsi8Gaes9uU+LQO0L+tJt+ONJOuL
	 YB81JauSo1gqJXh2a2imszUOuR5RNQTalSrBSFIq6nIlyEBf+zi8CpBns84aMmXLC3LzX
	 HnU3Kl/144DTXHCQwAdwVBx/0JwfXIsbsXCNXYoFAPqUV5yd/hyVEmRJSbutoxi/VnJ1y
	 082DckzeRPRtHpARGHfosw2mnopkE6yPKoTE32NQwJZOStbSxHnomYTACNhH7IS6cWCOa
	 Iu06GVuj2oiFZUAIxOZg4cDpQrwQ+CmRVV2L1seIj0yz0xPvNezlO7glj5PNJYvWS/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ApQYW4scgj+PGgM58fGGk945eKxuFj7m2+iaQzbWEY=;
	b=euHzRHyN1f1B19lN2kKgxOsC9VaPs8Zm4q/WIxD6SseQNYDQvdVkRRD3jqGcVRxXJ3s5
	 RKEFjm61HV4rw1J5qLD+o5v84pZpWOkqieyBuOeYX8fmA6A/jtvPa4D0/jGIZBHZ/8SUj
	 1K7yImXkt16P25qoDRIog0YmSxysmP7vwZXktgWHF8AD6j1urVWjUiIFxwVEjai/4RusK
	 lCbFfDwPSVpxk/pNkWg03aoormbKEnKB1+PYsV3oRV5QkJXVQe5gg9MXM9mfxdpJyp8xw
	 3wzvRcqf43F8W6JtI9Uo/83KmZYhd38RDzvI9HOoixbklM06MvUjMymQ6Bf3p9U35Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w3Vj1/Nx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4CA606D4BF;
	Fri, 13 Nov 2026 17:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3Vj1/Nx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC8F1F000C4;
	Fri, 13 Nov 2026 17:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591544;
	bh=4ApQYW4scgj+PGgM58fGGk945eKxuFj7m2+iaQzbWEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3Vj1/Nx6EGqx7CG39crgbhD7MBaE+Mj2jeZXwwTsUIulChyAZHGroDAQsYNZGC9L
	 IbRR36K7Ao6DzGxKYTWP4CrbBQvmnHwPwF8o8N3W/7CWi/L+4ednGWG/bqGXo7u2PF
	 glTuWejoUb1lRDDKjebe52HorQedGG3f+/l1qNMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 597/670] tpm: tpm2_probe: propagate transport errors
Date: Fri, 13 Nov 2026 10:52:41 -0500
Message-ID: <20261113153832.055462389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: Replaced the early return with rc = 0 to preserve the existing tpm_buf_destroy() cleanup. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm2-cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 63d26aebf55db..2e4652d43bca7 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -551,9 +551,10 @@ int tpm2_probe(struct tpm_chip *chip)
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



