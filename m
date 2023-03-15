Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFFE4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523C1C4339B;
	Wed, 15 Mar 2023 12:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883384;
	bh=Hzk9IvwA7y6VQfWSvbFOzDfMXY+1sArz+O0UOp50ojY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/1xWdng1mxhj09+cRSENPjTG+8myHYuE7dKRmJlllzIU4/TQ0C3M6sWIOO0c1wCx
	 yyJdtR7ekJlVpSdQoob6//pVG3Fne7TC1kGlfDIgNbYjgwoy3nkyTzsehcXDeeFCP+
	 TwtOI/ohnx+PapXbJE+vnF4W91nBjBiY6OTP3lEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xurui <xurui@kylinos.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/145] MIPS: Fix a compilation issue
Date: Wed, 15 Mar 2023 13:12:52 +0100
Message-Id: <20230315115742.477534114@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: xurui <xurui@kylinos.cn>

[ Upstream commit 109d587a4b4d7ccca2200ab1f808f43ae23e2585 ]

arch/mips/include/asm/mach-rc32434/pci.h:377:
cc1: error: result of ‘-117440512 << 16’ requires 44 bits to represent, but ‘int’ only has 32 bits [-Werror=shift-overflow=]

All bits in KORINA_STAT are already at the correct position, so there is
no addtional shift needed.

Signed-off-by: xurui <xurui@kylinos.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mach-rc32434/pci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/mach-rc32434/pci.h b/arch/mips/include/asm/mach-rc32434/pci.h
index 9a6eefd127571..3eb767c8a4eec 100644
--- a/arch/mips/include/asm/mach-rc32434/pci.h
+++ b/arch/mips/include/asm/mach-rc32434/pci.h
@@ -374,7 +374,7 @@ struct pci_msu {
 				 PCI_CFG04_STAT_SSE | \
 				 PCI_CFG04_STAT_PE)
 
-#define KORINA_CNFG1		((KORINA_STAT<<16)|KORINA_CMD)
+#define KORINA_CNFG1		(KORINA_STAT | KORINA_CMD)
 
 #define KORINA_REVID		0
 #define KORINA_CLASS_CODE	0
-- 
2.39.2



