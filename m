Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089451DACBB;
	Mon,  6 Jan 2025 15:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178286; cv=none; b=dfHBkv3UpI9KwDuP/z66WzUgNYKi/4SRi2CkXgGC6njzKJ/yUcaMjZ2nfUXx6RVYDi7acwVo82UecwDM/LNiaGDH/U5JfP5Q2zN0ohp8f0GiDhnkvnuLEho0MqnALMLaCuS4J58HmjH9bXA8W9qUnBGAPf4JuIDrf3rD0UoXqIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178286; c=relaxed/simple;
	bh=J5NLRhKGSoDXhIY0vlnudwQwo04NQPhT/bc/T2jlSNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcZGkuFb6pB3FlJO3GXZSmKVO8FcOIC4TsFjc5N9htMEn+hUTZdHQSDq0vxEEwVMk9paGJZo3ELomHXbSVlyskG52WnJznjNvCmVrhYswP40f6BR2QJNDCp5CgyAkIQgg6gqYLteLnccaZAbor3VkDd0KFyzu7ZHc/7jhoE+ODA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PINvQZlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PINvQZlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8601EC4CED2;
	Mon,  6 Jan 2025 15:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178285;
	bh=J5NLRhKGSoDXhIY0vlnudwQwo04NQPhT/bc/T2jlSNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PINvQZlO4GByqFEolFkNdDGt537TW2m00cbBlI1TMmTO+st6ZXtn6zECNe9sSQrjx
	 0XYPfbwnuuF/LvWaT3ogm1yFcLTCRvuY7K0tjo5oa5HHMwU6wUOC3Hk2xmEPSZtw/F
	 BIU8SUi0vxGiKSoUFzGITs3wJXdtY6hs66OWC5kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	WangYuli <wangyuli@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/138] MIPS: Probe toolchain support of -msym32
Date: Mon,  6 Jan 2025 16:16:32 +0100
Message-ID: <20250106151135.808579284@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 18ca63a2e23c5e170d2d7552b64b1f5ad019cd9b ]

msym32 is not supported by LLVM toolchain.
Workaround by probe toolchain support of msym32 for KBUILD_SYM32
feature.

Link: https://github.com/ClangBuiltLinux/linux/issues/1544
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index acab8018ab44..289fb4b88d0e 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -272,7 +272,7 @@ drivers-$(CONFIG_PCI)		+= arch/mips/pci/
 ifdef CONFIG_64BIT
   ifndef KBUILD_SYM32
     ifeq ($(shell expr $(load-y) \< 0xffffffff80000000), 0)
-      KBUILD_SYM32 = y
+      KBUILD_SYM32 = $(call cc-option-yn, -msym32)
     endif
   endif
 
-- 
2.39.5



