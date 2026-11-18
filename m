Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059819;
	b=1JocMfRCMqCFywFKhha9aOqWl8VPjJDP33v6xSw6kVKRsFxh8A7rvJNyZPrKtyMbGqGq
	 HDAGylcs/yFRdhwDfd7BL63E/ujDj6F0ypgcxp6lUs0Mh0VPXJIT/o/Lzic/jscAvBaB1
	 N0rFTpymeBRecL0ltRr7Q6swHMZn9rpBxoQVbPMz4lO4srJGP36N0fHYUsiSm+pB8Oa6l
	 4BuFJ6xiEHgQn5Kx2qrSQXZe14KmN3zdlQXvJwG1lGI5WqSPCtwGTo4zcQHMBX1ZhHMwJ
	 ittv1gDWeaFnabuCvd58HjeKx4DRWh/Js5mKkHX3bdmYgswJfxD86elwfGtzkyLPzTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9VH2JJdVY+6Zz7PwW+zvozqdBqMEtxHheq74y4bwjKM=;
	b=49j3r1F7Shx7XICQ491/wcV77KnJfJkFkb+l8RwL+DyuyRnkHR/43QRD1Hw1Pe6CI2CI
	 H/mQjH4DGbkg1S6U+uboFJJbLnsXzETXC0tJ/xzYWHcCj9/r5UoLOdNMrcvEjgvuvlbxJ
	 9Sh2BQ7t/T9wTtrWbfiABgxSu3V0ZR3Tk32S7g6Q8HBm6pr1OUi8NQAoQVhF+yA/DB4WY
	 kIqcVpudpeo/f3OEscfZOLsUPfRphSqSu+0fiX5/pdfE5lLnAobMI1TTuUqWn7VLHOiiE
	 rZ3cpmRhW8LvEXdk8v3jEDcYBv5/tujmVRfmgQp5zyetTmHgAZnSzQCBrmrKobJnm/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QNburqh9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5677C606A325;
	Thu, 19 Nov 2026 03:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QNburqh9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D461F000C4;
	Thu, 19 Nov 2026 03:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059819;
	bh=9VH2JJdVY+6Zz7PwW+zvozqdBqMEtxHheq74y4bwjKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNburqh93YSt0g++pxA5zPS5qw5S5IYX8l5NKS22aW+1gIVyaZb+BNhbiXFodpWFL
	 oQDrBxl6IPeN9AWEUG65IGaqisGwlHSaJULcvBhHt8JMkCjU8YykCWqNpSEPJmn9Ga
	 TifMbVUca8Uet0Oc+1QE4ziE17L8AA6pZfOwtuZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0937/1848] tpm: tpm2_probe: propagate transport errors
Date: Wed, 18 Nov 2026 15:49:35 +0100
Message-ID: <20261118145956.099528229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted to a stack-allocated buffer, setting rc = 0 instead of returning early to preserve tpm_buf_destroy() cleanup ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm2-cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 0b683d991bedf..5f453b9b2fb5a 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -507,9 +507,10 @@ int tpm2_probe(struct tpm_chip *chip)
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



