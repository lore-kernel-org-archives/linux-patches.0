Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30C52690FA;
	Tue,  8 Apr 2025 12:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114306; cv=none; b=I1pMtxP+W1qAYFBFdJhG/9pS/JE99ZZfnXgWITw34RJgwovLakjvoB3YPVy3iEgH2RZJKzLC9rvXwmIO/b3QJbErSx1/Q2kPbUtgFzdANyd1uEEafp9pmiPMFsRZvJvaRKFl8EFt40V4Lcnxuw2acf6I+xFG96WUu7nt2VYivxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114306; c=relaxed/simple;
	bh=qyc7AuEoHI5MpD8OVmODw3E0DEYLVtpIOONWa2rS1hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dz+SCQHMaxWVkiegnntvzd36OIBfWaTUgp67J+rPeIDtzNYfoR55+7mYy/iS9Z4EU3P/6nR6sBDCMvY1wyiL0XclsP2BCykvzmpCeYuRJYjcV5EppllbqbsK0DvsNUGh7nofXYzGl4gbUKeSWl7LmdGu/uw8mTlAffgoD37qLrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVvEPPXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVvEPPXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523BBC4CEE5;
	Tue,  8 Apr 2025 12:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114306;
	bh=qyc7AuEoHI5MpD8OVmODw3E0DEYLVtpIOONWa2rS1hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVvEPPXGZLmt/o+ks9gM8/bEbVzDg6Y11k29RBgYU56mpWWwZEZeI8D4jQUrP9yjl
	 HNRbxsnLaLvVhmsjLxqeQVY2RRpmEEKZlhcykWmpZImhsMhH7SKxfKxEPr09qBq2UU
	 e6StGyWj/tG/o2DVC1iPkQGTJvM55W1As4wFOpkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 041/499] x86/entry: Add __init to ia32_emulation_override_cmdline()
Date: Tue,  8 Apr 2025 12:44:13 +0200
Message-ID: <20250408104852.271678038@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



