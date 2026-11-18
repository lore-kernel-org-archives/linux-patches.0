Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050417;
	b=LLRRiUfqm9/I2abTSW9MBROyhyRdaUjToEXRR2fIb4Mo32XufFqPJMRLYRJ+YV9Fad6B
	 Aa0nKsCeqLVd6L2tdNVdSq3NDVhWZr2qhMttvQBdnmydOtThOyZNcXgQQNuPsHOJS/X31
	 tQGKHnt+aIR0f9WbpPuns7Rd2KB3PGGO7qI7IjfmX+0jGdrA6NpNd3hg2COBY2mB0qWDC
	 /YWZua6JheJgKNWjtWWrLRsgzWaTg3QNDSWdgEnmf/wOv3SRWlKmIffgGcKLW11EXqueo
	 GG/EhdbNr++zBUFWZV3Xw55KUJKAxnK2Dvrf8c20GFoxd3HzDlcn/CTWrLCHK/zQ8tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n1Xnk5kMI2O0Xv3hdTjkDQFX1M2LgTHPEbA5XimLZSI=;
	b=P3NA+/tVBcfvtfoA+9+D4HmEZ5r/JgZU/LFWeE2Wbcfb2sEJv95V5noDG81EixoLwy4f
	 Z8xXI8mXnhBQF1ZTe1tRK2DCdvbISxa9oZsJ5Cva80bt1UNMONP4LyqYNbyVZUGSqkvRI
	 IhNglYe6C0qAVOg8LfeAl5n6S6fOR/Fst5tFADmv8K6B3RHk5D0V0RlQPXUvbF3ZaDe+N
	 IsGhPGsYxGaodBvr34xSDsaM1QjEB5YPQjYP2E4Wj75GLgjS3foZ+yCINdRBsRhN4aJga
	 oYixMmdFkCz2Tlo8esqLcaPKhgrdhUismOi7nblWT8Q3rW9Jnzpk+4Szjzo1KQ6v/GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=phv+07Ri;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25621606A325;
	Thu, 19 Nov 2026 01:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=phv+07Ri
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1FA1F000C4;
	Thu, 19 Nov 2026 01:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050417;
	bh=n1Xnk5kMI2O0Xv3hdTjkDQFX1M2LgTHPEbA5XimLZSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=phv+07RiI/fEJe6/dbvRMDzg4PYCJvGN+p48buZZKiVqmnEfiIjLOZC/R10batOjV
	 wrcJmorjupUGo79glCOp3xy3p6pjUnySfi66bkZN1VBt8Ui0DeumJE4YCLE3ylJhGM
	 a+ZqfHCT+iq/ctSYDmZDL2JLCEKE+sJIHdU8VQ3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2699/2857] ksmbd: select CRYPTO_AES
Date: Wed, 18 Nov 2026 16:02:13 +0100
Message-ID: <20261118150338.745481622@linuxfoundation.org>
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

From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>

[ Upstream commit 2c36c4a86104d763ee798d4a89e2d3384b4cd626 ]

ksmbd allocates "gcm(aes)" and "ccm(aes)" AEAD transforms for SMB3
encryption, but SMB_SERVER only selects CRYPTO_GCM and CRYPTO_CCM, not
an AES cipher. With a configuration in which nothing else enables
CRYPTO_AES, ksmbd builds but cannot allocate the transforms, and every
session that uses encryption fails:

  ksmbd: Failed to alloc encrypt aead : -2
  ksmbd: crypto alloc failed

Select CRYPTO_AES, as the SMB client already does.

Fixes: a848c4f15ab6 ("cifsd: add Kconfig and Makefile")
Assisted-by: LLM
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index d036ab80fec35..f8973aeb3518a 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -16,6 +16,7 @@ config SMB_SERVER
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
+	select CRYPTO_AES
 	select ASN1
 	select OID_REGISTRY
 	select CRC32
-- 
2.53.0



