Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065287;
	b=05R8bYKFbU9CX3rGQOBY+eSgv8TVi2iaiBsAiZpbKRs35H0fdmoux3lOoPay1HLi7g7j
	 ATe90GwN8HMY2qlnRr1q66GDsSVkocHl01UyXqebEgx5KZmZzXnBnoNyCI9YMYECc4tnx
	 Ou/JMdxdRevaQSPDrXFKiRd4soL+fB38tJEF1cJWghDM545qEDqNCdHUEij7G9zv2jKtn
	 MBPcHzRVYATTUrlp/aEFhjVQeqlj6ARi/kolURMmdpAS0Pg0PHrbD1jpkpNM0bNQdsY9o
	 fnlBDfvXj1GgCiSEV6vipeQbLboByRKUMhRJL+ruh43F0u5cKhvFWSwRDr/ot32Xmrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p30YaA2hM2IWfo2eztuyKWGtMudwdnDUqvkvSVsBJHk=;
	b=jlQicmLdktUaBXBS8dksQXdD4o2wlB7IuJ5qXEMLLpgwWxLAkvxh/R0ng1HGuh56i19X
	 b3UX7PEY15wKFyjQ6VscMlRUzrzaTqWZa9CPXFBk2d7chlTIhIefKUiJaVPOW+92iF2of
	 wu9o7NpvzvUF/M+noSk0VA3UNGMQB94ziCSsZKCShgwlk3i9yXvWtkSvrimNFW3DxYFjo
	 4x3OBOd0oiaXjT9W1jpypB+y8IyCAX8LabhS44aIYa53aI9HPY9lTtDiOeUGwT43cjaqI
	 I8dHtjcgJ4/QBBu0Tvd4DCcbSwYpPT58rqopnChmkN/hi+jkHhi2Y5bEC0xi+y+Flyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J9vG/n3b";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A69606A331;
	Sat,  7 Nov 2026 15:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J9vG/n3b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E2C1F008A2;
	Sat,  7 Nov 2026 15:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065287;
	bh=p30YaA2hM2IWfo2eztuyKWGtMudwdnDUqvkvSVsBJHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9vG/n3bNQbBvBAYTNHvSYo3Rlmo3v+ttxRBlMPwBZBG0/oghskAbpyRo0E7CWQ4D
	 cQzUokdPesrVON8Y39BSYYONYMnf+HpQGgZmyGkcLrKbQnsvBbXs4qnTaMoNYRs/eB
	 UXEjXCV6zsWCGIkuepN9Y2JUUySj12Q9Em8Mx51k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1029/1257] tpm: tpm2_probe: propagate transport errors
Date: Sat,  7 Nov 2026 08:55:25 -0500
Message-ID: <20261107135007.743175564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm2-cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index ae22295df7981..119c73a603e65 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -483,8 +483,9 @@ int tpm2_probe(struct tpm_chip *chip)
 		out = (struct tpm_header *)buf->data;
 		if (be16_to_cpu(out->tag) == TPM2_ST_NO_SESSIONS)
 			chip->flags |= TPM_CHIP_FLAG_TPM2;
+		return 0;
 	}
-	return 0;
+	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm2_probe);
 
-- 
2.53.0



