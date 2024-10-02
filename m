Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE3F1CF5EE;
	Wed,  2 Oct 2024 13:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875226; cv=none; b=ObRjwYqUiqB5PXQhsp4lUNkReCBVUR0fDyBfiysXr9CvideHIoubUqCHzCcVia+2f8ZpONZ4fecjicyFfpufFoKH6c+4LsKNPdlHK94379As3x9m5NBCr6JP85YuzPWbTpRMM/taXzmFYRi8V3p1lXoOXmxRzdVethw42o3W0qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875226; c=relaxed/simple;
	bh=lT+bQC/Y74TKeDiCv3MMH98m/gihHZlPBXq94g6KzTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jz3tCFz3UBISyqkUMTv1QC/wBkGnChSX+l1MKRayG8BMA8Et9SWpWFebCbgVd/dv+vEPdMpO5lKrdWO+48n9e/K0Nrnmfb0mPL8V//yB8xVezTyTe2N6wTtuYxSQjwct7g/TIvwQsldjWemMr8Je6hzVUd1LLNC6VhOkFIwKkBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6HanN8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6HanN8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94ACC4CEC5;
	Wed,  2 Oct 2024 13:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875226;
	bh=lT+bQC/Y74TKeDiCv3MMH98m/gihHZlPBXq94g6KzTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6HanN8e+pSG17qsxzIhJP4F/PmrYfOa50DxMKDJgk1pN7e4rijitY/Z/06WDzfLt
	 LKZpWQydTCkJJd5XqMxWjnx9/YBrHUt3dtyiLKaCvHSmGTy+vjiym+F8T0PShSNQfq
	 /rRvH7noZsWTkg3nRHZseopcRbdaN9ZLQoo3YA3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 016/695] hwrng: cn10k - Enable by default CN10K driver if Thunder SoC is enabled
Date: Wed,  2 Oct 2024 14:50:14 +0200
Message-ID: <20241002125823.140392188@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 9d3a7ff2ce1781a77ad6f8896e1256875c17631e ]

Before commit addea5858b66 ("hwrng: Kconfig - Do not enable by default
CN10K driver") the Marvell CN10K Random Number Generator was always
enabled when HW_RANDOM was enabled.

This was changed with that commit to prevent having this driver being
always enabled on arm64. To prevent introducing regression with some old
defconfig enable the driver when ARCH_THUNDER is enabled.

Fixes: addea5858b66 ("hwrng: Kconfig - Do not enable by default CN10K driver")
Closes: https://lore.kernel.org/all/SN7PR18MB53144B37B82ADEEC5D35AE0CE3AC2@SN7PR18MB5314.namprd18.prod.outlook.com/
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 01e2e1ef82cf9..ae5f3a01f5542 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -555,6 +555,7 @@ config HW_RANDOM_ARM_SMCCC_TRNG
 config HW_RANDOM_CN10K
        tristate "Marvell CN10K Random Number Generator support"
        depends on HW_RANDOM && PCI && (ARM64 || (64BIT && COMPILE_TEST))
+       default HW_RANDOM if ARCH_THUNDER
        help
 	 This driver provides support for the True Random Number
 	 generator available in Marvell CN10K SoCs.
-- 
2.43.0



