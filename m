Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018199;
	b=NgOmGGact+HWw/lNQXxxpSPIlC42xgAhfCVGtqpEfj2aKj76JXFKA5zsZqe1/nQvs0tD
	 wVCQtGj0G6qLTdqS/wDX6ZmU/XyUcT4cX8N8RnSgAsreJacEomPn6K1lPe697j6lUjwAf
	 jvpua9I49VmCPh5EWChcIM0MmSpP+0qb3lL9Y6kzWL5WBC4jZ8hPfnv6RPSdO2nVQlry3
	 NadT+Jao0qrQu0mnHh85UllcprO+ncgiNdR4UAgt2sWEkDjKdyo4yYZaxVW+voGp6Wb+A
	 03lQhCAoFvH1CmM7Wx1So0gZYWViZCFuuwGjWwOvbGx2p8Y7TVwJHMnAvicV6faxhog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5sudnbnPy/DPr0VqcN8D8KI6EOlX0+ALyj+EHADBfgA=;
	b=YuBJZOpkPunr6N3lPgoKU1MtRzU9WN12zM7/Ify5kqexmMQuC3yyMc6nZja3PEcBhcWz
	 cuwtsNY6A8T2W5IUI007SPlPRgVAnjFUy+axdePgB2+0qX8RQA5bKHHOluPRLF6i5J0Ui
	 JRPRVS9PN6mYtT6+of/AnvJx9vGkCcaA0Zb6yIGjzBfPgBwJjpsUgU2zL0rNzA0NV/XTO
	 8G79gbMmeyClOeizjk8HWEFldU0++kmNu7dya3dW0hfHW+wkIR6ClcRkOugp/AwH7rBaI
	 Z/ibeNxXMaV+BDMPZWiCPF1hwfBsej3L1TOVe6Z9KD+49aV7IAM3dmO04101povQ5RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YAdEt55S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F22606A31C;
	Wed, 18 Nov 2026 16:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YAdEt55S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB8B1F000C4;
	Wed, 18 Nov 2026 16:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018199;
	bh=5sudnbnPy/DPr0VqcN8D8KI6EOlX0+ALyj+EHADBfgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YAdEt55Ssa94b/SgHTHL1b6EhMwlrY0U+YAWoY6Q5OEAD80OU3Bzt3ekqro1JRUyq
	 FX4WTN5l+svqE1NvBNGtm1/CPluJtwQ6K+D1aEK/x6SiNI6V7+SKBUxJeLkUNMbUt1
	 wTY4CpbTP8+duv10AGtHYWPEH2wbnnlDIx+esfrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1155/2651] hwrng: intel - return -ENOMEM when kmalloc_obj() fails
Date: Wed, 18 Nov 2026 15:39:55 +0100
Message-ID: <20261118150329.590085082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit a0590c556cdbf88373d38494a23f1503d39b0ab2 ]

intel_rng_mod_init() incorrectly returns -ENODEV when kmalloc_obj()
fails. Return -ENOMEM instead.

Fixes: ee527cd3a20c ("Use stop_machine_run in the Intel RNG driver")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/intel-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index d24e747203c1f..4aa91ee0e5041 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -349,6 +349,7 @@ static int __init intel_rng_mod_init(void)
 	intel_rng_hw = kmalloc_obj(*intel_rng_hw);
 	if (!intel_rng_hw) {
 		pci_dev_put(dev);
+		err = -ENOMEM;
 		goto out;
 	}
 
-- 
2.53.0



