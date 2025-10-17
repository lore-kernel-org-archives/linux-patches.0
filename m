Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40D9330B18;
	Fri, 17 Oct 2025 15:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715293; cv=none; b=GmRRc87QNwWV3w2KplcPUh8JJx+OlUZd2FoiDpxF3PLWnz0VoP+Ukn/dooR6taz+XUpg/FcZwwebKZZwLJakk3iGZRmaanetQTC1kTuPzGh7nKIONds9nyXxj38bJSgoUgx/0fluh7KgV1993RSx18ue6aMleeKlXXvgOqj5aRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715293; c=relaxed/simple;
	bh=BvXKYQ3z1FQ8ccm1BspOZPEEl9fLa7p+hViOc5QD2Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNzy2N3Cl/l60KPj5Y4b1BDFkKdFtvVeLmW6hCr0dNXJah3mZUDWe7xQCdJEk2/DnS0FgFLbIlnxBF/4cBLehgf9UksMhs+qhCUmemQE37R2ukQtvaQeq+tnMyNHHTDT19Tzth+FkFGJgO5k08lsujRCk/x9l0ip/lSP1ksyurw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/Lnjw54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/Lnjw54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C552C4CEE7;
	Fri, 17 Oct 2025 15:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715292;
	bh=BvXKYQ3z1FQ8ccm1BspOZPEEl9fLa7p+hViOc5QD2Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/Lnjw54LPJQ8kCBB7/V1iLqfOKYEdeWUV169WLOswHvzFaETJsH7mnNjpBq9f2ps
	 VXBMgERusnjYyBQEOHHBVHAP5LY9jM6JM88RdWGlzinClfMTR5ERu21bfF2x5mhiOz
	 W+fPJpGIIMvBgdiYKyqRwm/fZohx1lBSropcd5rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Alexey Gladkov <legion@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 132/371] kbuild: Restore pattern to avoid stripping .rela.dyn from vmlinux
Date: Fri, 17 Oct 2025 16:51:47 +0200
Message-ID: <20251017145206.705974245@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 4b47a3aefb29c523ca66f0d28de8db15a10f9352 ]

Commit 0ce5139fd96e ("kbuild: always create intermediate
vmlinux.unstripped") removed the pattern to avoid stripping .rela.dyn
sections added by commit e9d86b8e17e7 ("scripts: Do not strip .rela.dyn
section"). Restore it so that .rela.dyn sections remain in the final
vmlinux.

Fixes: 0ce5139fd96e ("kbuild: always create intermediate vmlinux.unstripped")
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Alexey Gladkov <legion@kernel.org>
Acked-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20251008-kbuild-fix-modinfo-regressions-v1-1-9fc776c5887c@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Stable-dep-of: 8ec3af916fe3 ("kbuild: Add '.rel.*' strip pattern for vmlinux")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.vmlinux | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
index 70856dab0f541..7c6f0e882eabb 100644
--- a/scripts/Makefile.vmlinux
+++ b/scripts/Makefile.vmlinux
@@ -87,7 +87,7 @@ endif
 # ---------------------------------------------------------------------------
 
 remove-section-y                                   := .modinfo
-remove-section-$(CONFIG_ARCH_VMLINUX_NEEDS_RELOCS) += '.rel*'
+remove-section-$(CONFIG_ARCH_VMLINUX_NEEDS_RELOCS) += '.rel*' '!.rel*.dyn'
 
 # To avoid warnings: "empty loadable segment detected at ..." from GNU objcopy,
 # it is necessary to remove the PT_LOAD flag from the segment.
-- 
2.51.0



