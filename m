Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047095;
	b=ZoITdsarFs+8mw0vvSs8WeaPTUKYIqVkMGw3/3sHAF1IhdP1rosOEbBi4XB0NgXi2/wT
	 MA5IXaDbiejk0sF7sbsJqjp896HQyMRfRLUWmJBQqT1S032koLGc9GSvtyIqdir1k4n4y
	 cy6zVSNeVg5vfqgSAM8iOEvQaXxS7mDPc+NJAKGCVzR0IU7CxugOtI4mLG50KLcVgnvpG
	 s9d33C+8DYNU0dXhBrrVWpd8u4hPM06jEvTbog6LtZ7zsIrrRxmeLMdTWFc1eNGYpFPnh
	 WPDmXuBGfk6ViJycZ7s8IRNgHT0qnwCb1rHp4zvvIxeD/FE1jCGT6mgHWu2JETVw5JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JjtIIfY+aCHQDRDPt9kyiTu1TV1AX4mRbs2tTjpD0xA=;
	b=QCJh89DOckJwL8eypG0WgehDhMRx0x+gppk3JDImp+68dAvHPg5wJSSgUJS170T2VVjT
	 09s6vgDfikW0fdcHROCDqKhec+IaLSwUhwxXrqEEAu+CikmMQ0CzIRGAp6ahM8hjrSrcT
	 k/kRhI+2a5UatrDZgkUtvTH6GLMVLOmyXLKT2xsrlbsA+6M4DcS5tDptflicIcgTAdQPL
	 7NHDV4YQTQ0Ut6209edbwlTahvyQQoFQx/QCKlOjjYIaKqUv+7ZX33v4aXXXg6Hw+UK8m
	 7FC8Cd8TDaigZLRJS14G2tbtuoo3XHZOdZnpZydQWBwzKzMe6rkclPnPmqTQ5uCmMuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LC+5BZ+O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB3D606A320;
	Thu, 19 Nov 2026 00:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LC+5BZ+O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DDF1F000C4;
	Thu, 19 Nov 2026 00:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047095;
	bh=JjtIIfY+aCHQDRDPt9kyiTu1TV1AX4mRbs2tTjpD0xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LC+5BZ+Oula1PaUSDjX9lVXxGXr6gTQMqQLSd3Y/XmYk0b9uxGmndFuxnG5nP9T7V
	 F1pZ/RovitlPnuYRxehGkKsWm09dfeMnvJ+rgTGcxKqGrhWfHWn+uE6D70Z4Snvcim
	 n9cSwY1YRB68LiyDi1XLRrxfI/RIlUqAkQDjb2Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1517/2857] tpm: tpm2_probe: propagate transport errors
Date: Wed, 18 Nov 2026 15:42:31 +0100
Message-ID: <20261118150255.947564333@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced the early return with rc = 0 to preserve tpm_buf_destroy() cleanup ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm2-cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index ac8246153c242..1485224b98af5 100644
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



