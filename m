Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B6146C4B0;
	Fri,  7 Aug 2026 15:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117020; cv=none; b=bNECCHK1z25tZMiyavOqJdDhc19MY2OIbOAZ4ctFdZZUF32rejWBjhq3GKdBZkc7tfWQe792ZW0wgUoXm+ncWycBrIEkT8oXxhME9cvPFaYuvuc3VhWNTkygVguNGPOZMr/c61HesFUhOi/S4+1k6u+gFm1NSCRxZzJNPU0bluA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117020; c=relaxed/simple;
	bh=7nSBiFoueI1IaMHIkDi4wB05h9dXZyQrJfS9JKu/Q1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FCSNs4AZxjasqTjWOZkKPQ0rxm+XCW9EjDodXuN7IbC78Ahi1zv7AmPVHonntrfq3L9XZd0aFR9NIpUe6uItuRNQ8fu4OA1YybTpq02J7bd9xHGFxtGMcocO08Hdqbr8q7aoA8uR57AZVlUHZgn6rpBNa1APUWQ2irAfU+jtw+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEVMKNjt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEVMKNjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4B31F000E9;
	Fri,  7 Aug 2026 15:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117019;
	bh=1gv5U5Kf24p8YeOsf6jCalmixQkvbLNvsjsCGOIiJ9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pEVMKNjtYCS3nt+oZguBT9MNyntzl0w5b2eWtpXEYZXkKII1V+7Nt3Uwg6vwcpXj1
	 oKBqewgsafGSB2PxFyYSepkZToYkZJf7BfFSgaKM+/bPqjF5bmUe6hDfE0qEh0QLVK
	 3021RT8OznK4007x6BM+6atChTlMnCfiGx1VZmTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 173/438] riscv: vdso: Only try to install vDSO when present
Date: Fri,  7 Aug 2026 16:36:09 +0200
Message-ID: <20260807143431.723205206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit c052927905710de1ab7364bf1925efbd12517ea3 ]

vdso.so.dbg is only built with CONFIG_MMU.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607090258.iSAUYlO1-lkp@intel.com/
Fixes: f157d411a9eb ("riscv: add missing vdso_install target")
Fixes: 3edf39916977 ("vDSO, kbuild: Provide vDSO debug variants at runtime")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20260709-riscv-install-vdso-v1-1-0ba4345419ca@linutronix.de
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index ce0cc737f8709..1363e5bef35cd 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -168,7 +168,7 @@ vdso_prepare: prepare0
 endif
 endif
 
-vdso-install-y			+= arch/riscv/kernel/vdso/vdso.so.dbg
+vdso-install-$(CONFIG_MMU)		+= arch/riscv/kernel/vdso/vdso.so.dbg
 vdso-install-$(CONFIG_RISCV_USER_CFI)	+= arch/riscv/kernel/vdso_cfi/vdso-cfi.so.dbg
 vdso-install-$(CONFIG_COMPAT)	+= arch/riscv/kernel/compat_vdso/compat_vdso.so.dbg
 
-- 
2.53.0



