Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FAF321452;
	Mon, 18 Aug 2025 13:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524033; cv=none; b=IffLpaE56JGNh7K0Blc9J9hOaq7UAYqcf4H5/aKQzXzR/ZvMjuIuHvv/aBMG3BDnEJgQsuaJJVb6tCsSlQWo/290OP2+h+jVk8X0nvXa5G9uAO9yCyROqOgG+vwfHtIpQByj0Mq8N+CfbQ+eEYerCMiiKG91pq002ft8ulz+8ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524033; c=relaxed/simple;
	bh=y4bJGbdX5PVr3Mu0ZLdcXND54pr12xMl35DRZzLa8ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ae2wVoEA3iuFJWN15zDvogPECQZA6tbgnrHKJ/iBkAdnzWENKpiN1HCIltCqtr2wDwrbhj/nu27qPEfU94O9Iz2gRMywm0iQZkf/ckyQmo6Aii+XSAq5J0/babCYIQFLAow+2pTsfR9KTPxdM1n60Gxl4luuirNuBZnrkGPk/mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1fzFT5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1fzFT5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8F7C4CEEB;
	Mon, 18 Aug 2025 13:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524033;
	bh=y4bJGbdX5PVr3Mu0ZLdcXND54pr12xMl35DRZzLa8ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1fzFT5i9z/n5GaALxQy6UVeh7vZAVoQL7sfZUvTBfUu0xYcbvdb0S37y3UN6N10q
	 wkCCIWYBDregI70EVVoC5LzbovZjcNXEwGaXpBAzKvHUeOqSQc0rdx2SNPivUw/8Bi
	 B1O9nvKPC3PZ7rwDKDT00ncfW9l4MvBWqdSl87Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 347/515] MIPS: vpe-mt: add missing prototypes for vpe_{alloc,start,stop,free}
Date: Mon, 18 Aug 2025 14:45:33 +0200
Message-ID: <20250818124511.791826704@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit 844615dd0f2d95c018ec66b943e08af22b62aff3 ]

These functions are exported but their prototypes are not defined.
This patch adds the missing function prototypes to fix the following
compilation warnings:

arch/mips/kernel/vpe-mt.c:180:7: error: no previous prototype for 'vpe_alloc' [-Werror=missing-prototypes]
  180 | void *vpe_alloc(void)
      |       ^~~~~~~~~
arch/mips/kernel/vpe-mt.c:198:5: error: no previous prototype for 'vpe_start' [-Werror=missing-prototypes]
  198 | int vpe_start(void *vpe, unsigned long start)
      |     ^~~~~~~~~
arch/mips/kernel/vpe-mt.c:208:5: error: no previous prototype for 'vpe_stop' [-Werror=missing-prototypes]
  208 | int vpe_stop(void *vpe)
      |     ^~~~~~~~
arch/mips/kernel/vpe-mt.c:229:5: error: no previous prototype for 'vpe_free' [-Werror=missing-prototypes]
  229 | int vpe_free(void *vpe)
      |     ^~~~~~~~

Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/vpe.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/mips/include/asm/vpe.h b/arch/mips/include/asm/vpe.h
index 61fd4d0aeda4..c0769dc4b853 100644
--- a/arch/mips/include/asm/vpe.h
+++ b/arch/mips/include/asm/vpe.h
@@ -119,4 +119,12 @@ void cleanup_tc(struct tc *tc);
 
 int __init vpe_module_init(void);
 void __exit vpe_module_exit(void);
+
+#ifdef CONFIG_MIPS_VPE_LOADER_MT
+void *vpe_alloc(void);
+int vpe_start(void *vpe, unsigned long start);
+int vpe_stop(void *vpe);
+int vpe_free(void *vpe);
+#endif /* CONFIG_MIPS_VPE_LOADER_MT */
+
 #endif /* _ASM_VPE_H */
-- 
2.39.5



