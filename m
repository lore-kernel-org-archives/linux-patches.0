Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A310F34AAFE;
	Tue, 26 Aug 2025 14:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219060; cv=none; b=AYiLeeSCYptnZZ/y2wGWtAogxooRIsLskPePuYnIphiTR9gGbT5getLHGZnhpADzEGRVCa+aN7YY1UKNrEpSToU6nGaWKcHCcn+mwX2HoS0+ohBWRs7B4KEtFV2N14G6bS8u7VZ0XXWKofEDpRwM/kPPwfhAWpIu3npEe7l2xzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219060; c=relaxed/simple;
	bh=C9ZGHEkOk8Mc0NQK5vx2m/n+Bi5pezH7q5c/TJeNO54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZIjdkvRW5YICeqLqYtb52p1XRS2MgzHxfFUaTVhBaFsZRL63NDq9WghbcIgO7lZRI56k4Lfx4cs2PcAZXn3hT+nT7fSPRkGQ3HFHIGzGUHKNdnpBwih4pucX79kE/kpSWc0ACpHkfe+SKgCBKZMo4L7+Tg5bk4Aa8fHyXKMiwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k12t4zf0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k12t4zf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DB2C113D0;
	Tue, 26 Aug 2025 14:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219060;
	bh=C9ZGHEkOk8Mc0NQK5vx2m/n+Bi5pezH7q5c/TJeNO54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k12t4zf0E/KNsx8kiWt09znp+pTK2POFoH2W7sws4s9Bj7OPIO14+Tj7LSHCwXAJD
	 XuGgt02SGZv88GldbRSogERisK1Vl/v3DPZTSDcxO4r6R9jibOF4sAVziYCCcrtHwl
	 dobxQ+s4W2IUkAe3lnVQLyblQK/EDiIrJhbtknM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 237/403] MIPS: vpe-mt: add missing prototypes for vpe_{alloc,start,stop,free}
Date: Tue, 26 Aug 2025 13:09:23 +0200
Message-ID: <20250826110913.378019655@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 012731546cf6..3de6b0ff1627 100644
--- a/arch/mips/include/asm/vpe.h
+++ b/arch/mips/include/asm/vpe.h
@@ -126,4 +126,12 @@ void cleanup_tc(struct tc *tc);
 
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



