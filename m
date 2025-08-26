Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AFA1ACEDE;
	Tue, 26 Aug 2025 12:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213127; cv=none; b=emLfWjQPuaUrh+/z+HWAsvWYdron4xVg+J3Yo8jgh4m8P1cOaZMjpr8A9wHOHPK+x1N0E6aE+Y/tu2WY1xJ4PCbQhPiu8vGnRoIa43xRSvNcWXPo2hcXO9HRIMQHCpAZbhECiAfRHVYJLVtravqBazjq3RSwjC+Mo8pbCKbaHcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213127; c=relaxed/simple;
	bh=yzkKohcoCPRZshpGIjWpQMYtN1NdHvUUJ6+oQ+GVDqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQoFnq+WhWb2xaiIddRLByK7NG39w/njcOF6W7Ghhzr8qtgxfbGeMdvP3QKyTfcAJ+8m6lh7C/G71xdowOCmW5A/ZZ+Iw3aLAGiGz6PBaugbTL6vZVmUBghi839J6oAuomvo2D1Aj6BlvHbEvvYKfsnWE0iwCvsg09/X0aV5iUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORgIxemH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORgIxemH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C519AC4CEF1;
	Tue, 26 Aug 2025 12:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213127;
	bh=yzkKohcoCPRZshpGIjWpQMYtN1NdHvUUJ6+oQ+GVDqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORgIxemHA1VTA0sh/K/rts3bnjSrofnYxfFaIOE/zM/f8I/LBry+WxW7QlgSz2oYj
	 bHWOMN2LcG3v4MAM5eVlkgcID/Bm9nHx0nbSzulfutezZM1af45aGwCXN+EqnPwdui
	 9Z936eLW29zTTSBbkUMOU85HzIIs+SDLER/BWE+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 232/587] MIPS: vpe-mt: add missing prototypes for vpe_{alloc,start,stop,free}
Date: Tue, 26 Aug 2025 13:06:21 +0200
Message-ID: <20250826110958.836591761@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



