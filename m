Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48A23176E1;
	Fri, 21 Nov 2025 13:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731610; cv=none; b=bvoEJSz8z2xLJ5LwYNF8WV2vKNmBxcXKlz+FvmkT9uqZ7Ny+o7LwQNSXlJWstqM/2VKmKKYCC0ZjDXrRoJrbXlFAaxNoVBsEdRojCpZzoiG8cuyrVjwxYLo50DOKlhNqBUjc5UFgh+Ohr6S6czbzyPveDjTjTJtTj0N1Gw88VPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731610; c=relaxed/simple;
	bh=tVsSLODa4rPRuru1/JV5thRiYT3YDKVMhcma6YvPLFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vcp69vipHTkfard3jTg8iGrLGUv5goE4u2YcvQ1vmBduUIjhwp2QgOo2h1r7fcCu4j0mQh5B/jO4aszjHAwOxNTvzGdjC+mK7/lpBE2z2E//SqKul/QgoSYYBf0l1ldVqdrFQZeZDqINaXVLR/0HJHckgN4VJrrTAPf9Ziu+2Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qh43eiDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qh43eiDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CC6C4CEF1;
	Fri, 21 Nov 2025 13:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731609;
	bh=tVsSLODa4rPRuru1/JV5thRiYT3YDKVMhcma6YvPLFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qh43eiDqbiDWREkOnXJQLS28+jimoZ4UIvwrjrDrIhiUOaOIjjSxmdjB8TfzONYPC
	 dbbBx9FNBKRjzAi7ZtOyGyvl73s9WIHgkYRc2C2wk69w9ny/eJjMNnVL1Cuv+6ibXn
	 7Ntsq/HisA33x1KqzkiAe+NG/RXMIm6mqyp6E5e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Jiang <jiangfeng@kylinos.cn>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/185] riscv: Build loader.bin exclusively for Canaan K210
Date: Fri, 21 Nov 2025 14:10:39 +0100
Message-ID: <20251121130144.318852479@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d469db9f46f42..3df2111673601 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -161,7 +161,7 @@ boot-image-$(CONFIG_KERNEL_LZO)		:= Image.lzo
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



