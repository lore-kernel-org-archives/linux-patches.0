Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044951;
	b=Qa0mxU+T6AEg6O3KDzmT+obXecvGm2WJmeLqCrnGJJcY5Cnpwt91V5OfKDT2m/R1mR7m
	 ZQWbNWys+fKVqa7CbUyjeiF81pSSe5Y/oS8R/S0UyHylpYM0UoH9J9vR4vRlN28vgPZCj
	 /VSvCOkEMsz9VUDacUVrHDU0DU1oUiRxQi+0fNARvCq1+FBnWJd+gZ8V5MVQARAYRqELf
	 jn4ZT7eH5Lr6v5vqEOK1EGa9FBwrS2HCcDmgHAoiKFEYDMsvlydi48WXOkm7Xf2aPmBSX
	 3HNLjLgaUsi6g1vsavZCwx7p8i6j7SEOi9hEjTWRwMIPCH3FOtp9UUr/SZNSH3mK3Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2bABoM5iGEVPpN/e9gd+kT4nES6NS8Z1ly2WMJGdKdo=;
	b=3HIfoglUq7wLzW1QFPnVnhk27uYxAaDU5vWjZZBnMC6VkqEUwwojG/EKttItSg58sZVO
	 7ivtbMa+Eb85KdrJpXzgTTGdDlOo22bhZWY68HSl3854pixsa+cX7brWsJ9ezMojXZGk6
	 VW3NHRMsT/j1bM3ANYGN0tRmFeznQ8QYvoj11oy6iydRn6XAjPBvu4gOgxn/TdPx7RjSM
	 IOQdVnZ5hCv9/FCpgBPVXAXLoHUBy1Dzmu9AVO+hCjncsIFKVsLwvGNg9Y5k1fFIFdycu
	 ArMVVOrTgZM+pxyecABU8NOsPnq26m2rRthtPSYpCvh9/FPRhPw6+qHwPp+u9Fx95vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+JsnzZW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDC2606A31C;
	Wed, 18 Nov 2026 23:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+JsnzZW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0101F000C4;
	Wed, 18 Nov 2026 23:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044951;
	bh=2bABoM5iGEVPpN/e9gd+kT4nES6NS8Z1ly2WMJGdKdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+JsnzZWdGWX1Fy+snOyPNjkHPHP/Qw2UxKNWNsEFra8nFywPP8IJ3Tj4gxjKJhyQ
	 7mNyNpwxZSjhjUHySqu1OuRbE7C2XFmt5RW+eY/5XUUYGaPI7SwJn2Jh9woeLdqXNj
	 xp/o6mSnNAWc+BifWE9Ocv1UzPN+CIpennI61EWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0750/2857] mtd: rawnand: sunxi: reject ECC maximization on small pages
Date: Wed, 18 Nov 2026 15:29:44 +0100
Message-ID: <20261118150228.557400355@linuxfoundation.org>
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

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit a3c84084a73e170374b7dd493947efdef4ee57bc ]

When nand-ecc-maximize is set, the driver selects a 1024-byte ECC step
and divides the available OOB bytes by the resulting number of steps. A
NAND with a smaller page therefore produces zero steps and a division by
zero.

The older controllers also provide a 512-byte ECC block mode, but the
hardware documentation describes that as an ECC block size within NAND
pages whose supported sizes start at 1024 bytes. It does not document a
512-byte NAND page mode.

Reject pages smaller than 1024 bytes before deriving the step count. This
prevents the division by zero at the point where the incompatible
maximized geometry is selected without changing explicitly configured
512-byte ECC block handling.

Fixes: 4796d8655915 ("mtd: nand: sunxi: Support ECC maximization")
Cc: stable@vger.kernel.org
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/sunxi_nand.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 16231ca93b599..279442fe2f205 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -1642,6 +1642,9 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct nand_chip *nand,
 	if (nanddev->ecc.user_conf.flags & NAND_ECC_MAXIMIZE_STRENGTH) {
 		int bytes;
 
+		if (mtd->writesize < 1024)
+			return -EINVAL;
+
 		ecc->size = 1024;
 		nsectors = mtd->writesize / ecc->size;
 
-- 
2.53.0



