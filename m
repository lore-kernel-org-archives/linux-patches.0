Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62F826B96C;
	Tue,  8 Apr 2025 12:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116142; cv=none; b=VJoOc5Niu/2C8nCcKUu8Edt4+h6g2mJimvw3V43yWas6tFrr96IrzkcgtjxXW5q0R0Wr/usJw/WxbhhKMb+rw0XOGkgVAwFMUgySeLDahJfmyVanZZW+Qpaag1BVAcdeKTHBImtocAveNU+FTDbsj7xJ9MroBb2kqTssH6ajW6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116142; c=relaxed/simple;
	bh=+kGKin2cV714thwLdBsFU5xmYlMasvrAPAU+CHtGYWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUi5BR86Zwr5N/aRrf2qsT7eonRIv1VCHBcMIJGmgEgy8OZSWPwbKQKAvrQhS260fGbLj93q/u/B1oECCm8rbwR37f3N6XgfaGXk2uCV37b3erW+ci2V/RxVI7UXlObb6EiSXsV44T7c7Q0zzXgwRqo9z1MpT5oHydXEC1kcdL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KyyKEiGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KyyKEiGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E87C4CEE5;
	Tue,  8 Apr 2025 12:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116142;
	bh=+kGKin2cV714thwLdBsFU5xmYlMasvrAPAU+CHtGYWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KyyKEiGdnugG9bPM2vwOSP5ZzlQ4/KotjRcNDX2CSAK85ptiZHgPYuSgaWtWd0cZR
	 jx0PTKHRK/Bcd4if5qVMauOkJbXklefi5ceVOrnV65KrR8wFzx2GfWc9QzS4Qr3lXo
	 TvHSika06/wXF09yt9ZkRU42UPX+qT0Qc8AFfXp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/423] x86/entry: Add __init to ia32_emulation_override_cmdline()
Date: Tue,  8 Apr 2025 12:45:57 +0200
Message-ID: <20250408104846.472846841@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit d55f31e29047f2f987286d55928ae75775111fe7 ]

ia32_emulation_override_cmdline() is an early_param() arg and these
are only needed at boot time. In fact, all other early_param() functions
in arch/x86 seem to have '__init' annotation and
ia32_emulation_override_cmdline() is the only exception.

Fixes: a11e097504ac ("x86: Make IA32_EMULATION boot time configurable")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://lore.kernel.org/all/20241210151650.1746022-1-vkuznets%40redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 94941c5a10ac1..51efd2da4d7fd 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -142,7 +142,7 @@ static __always_inline int syscall_32_enter(struct pt_regs *regs)
 #ifdef CONFIG_IA32_EMULATION
 bool __ia32_enabled __ro_after_init = !IS_ENABLED(CONFIG_IA32_EMULATION_DEFAULT_DISABLED);
 
-static int ia32_emulation_override_cmdline(char *arg)
+static int __init ia32_emulation_override_cmdline(char *arg)
 {
 	return kstrtobool(arg, &__ia32_enabled);
 }
-- 
2.39.5



