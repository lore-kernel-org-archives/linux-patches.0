Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEE1268690;
	Tue,  8 Apr 2025 11:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110412; cv=none; b=KBnsof4sC4gEzUQnrxoDCguZXPf0vNGeox429Dlgvx+u3Nso/2DmQLJFq3P40NFD0Crp6Knb7kCk2CyGeWNBuh7kUwz+eiS7Vl/KL62ucURhETB05wsJWkeVU9zw1nhoAvoAa2q7FansK9psgqQOxYrjEi8t2MViXN91ky/EN/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110412; c=relaxed/simple;
	bh=FpAojxV9qvpkpG3tS2pCec+4bjyvvPSRSN7rvXh8n84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNEXLLJZ9OMojTcsSCb2ptVxOeBnC6WzxEMHz0lFI08+cCn64sRqyfhEwl37dDmFYQLawVhbnNXj/ibin9oySIb6a5M77TSDjVpk7p12lTkEh6yzhOc9CHbAY0xN3RTaWGuBbLXFPoMaHnm8g3TP93faRiB0cSpukfD8CfLs5vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghtszj6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghtszj6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7E4C4CEE5;
	Tue,  8 Apr 2025 11:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110412;
	bh=FpAojxV9qvpkpG3tS2pCec+4bjyvvPSRSN7rvXh8n84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghtszj6IKNJZ7Qdsl9aUw+shtNCXngLjwtESeEysAxPey5Ah2wGVvNIrP1hMd5ALc
	 P3isXnSrC67lPA23FIbWpU+H7h/H7mmxC8mtZx730LFLGD+8dYXJJaYKVSMqXt906C
	 gfV8FXfHyMtAY8yZpvgXNUm+bC0/LGMS/ZokVBf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 055/731] x86/entry: Add __init to ia32_emulation_override_cmdline()
Date: Tue,  8 Apr 2025 12:39:12 +0200
Message-ID: <20250408104915.552920564@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 14db5b85114c1..3514bf2978eed 100644
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



