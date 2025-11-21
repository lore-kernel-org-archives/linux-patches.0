Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A72431158A;
	Fri, 21 Nov 2025 13:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730899; cv=none; b=aFED7jUUuvv1PUTrsb7Idq6E0iQ+NE4A010MHvDjjWq4G9yBn97zBnG4AQp7EWcQstxbZLj8Qs2DeLYaDaavEnplm/aO/A/+rAb7IESD6q5p63+2z6rQas2IIxKX6AvBgEXJRD90nB0g3TYG0F9CGXkFwp/gNX4Pk3eR5SXDFsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730899; c=relaxed/simple;
	bh=aEHcJxbupDEP+5YAmIB69RKhTXHeVDtNqA54bJe1W4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=im4ThlF1Lh+LlsGrqyYfeZWjlk++8lPOG6wM3GUrAs9UOKEwr9yPVe3HdNd9WnJjgLrsPaX7GlLXGxajTrC4KmhRabQzvD4+oTImDLWFek1di3Hbu2ht1Q3KOVmRyO03kfFW+60wmJSOLW6eIkBPRYAlo+6x4yq67Q1cwCuxeKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z65ku5dP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z65ku5dP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2579BC4CEFB;
	Fri, 21 Nov 2025 13:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730898;
	bh=aEHcJxbupDEP+5YAmIB69RKhTXHeVDtNqA54bJe1W4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z65ku5dPZWhpp32csxU6BBoz8hihAwX4jmtXgaFVr/60WUjDY7D0XhlhGKl5JHeAr
	 bF7Vae0VnzzVeulVQDI75vSmyvOm6hRrE0xMSsAp9205esYiBkc0LPuyKfmLbCeVXB
	 +e94FYY9GgJvgMFY6B+jELjIu5xEI8Cazamx/oBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Jiang <jiangfeng@kylinos.cn>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 021/247] riscv: Build loader.bin exclusively for Canaan K210
Date: Fri, 21 Nov 2025 14:09:28 +0100
Message-ID: <20251121130155.363449989@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Jiang <jiangfeng@kylinos.cn>

[ Upstream commit 3ad1b71fdc5707d14332d9ae710a237de936be9b ]

According to the explanation in commit ef10bdf9c3e6 ("riscv:
Kconfig.socs: Split ARCH_CANAAN and SOC_CANAAN_K210"),
loader.bin is a special feature of the Canaan K210 and
is not applicable to other SoCs.

Fixes: e79dfcbfb902 ("riscv: make image compression configurable")
Signed-off-by: Feng Jiang <jiangfeng@kylinos.cn>
Reviewed-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Link: https://lore.kernel.org/r/20251029094429.553842-1-jiangfeng@kylinos.cn
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index df57654a615e0..c4e394ede6256 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -166,7 +166,7 @@ boot-image-$(CONFIG_KERNEL_LZO)		:= Image.lzo
 boot-image-$(CONFIG_KERNEL_ZSTD)	:= Image.zst
 boot-image-$(CONFIG_KERNEL_XZ)		:= Image.xz
 ifdef CONFIG_RISCV_M_MODE
-boot-image-$(CONFIG_ARCH_CANAAN)	:= loader.bin
+boot-image-$(CONFIG_SOC_CANAAN_K210)	:= loader.bin
 endif
 boot-image-$(CONFIG_EFI_ZBOOT)		:= vmlinuz.efi
 boot-image-$(CONFIG_XIP_KERNEL)		:= xipImage
-- 
2.51.0



