Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060369;
	b=F/Ysu+uHoAI1b+V7V7JZrb0VZd8yziTOclczPQCQ6uaisA2NgZT9izQWVhsciPL2JgA1
	 VD2ZuqysrTJTSKxsOn8axnkL/1LOmcusRkSAvS36RscrxyIdpTQtI/ppHrS08ml/PCgT6
	 JPgsf6mrDGIHsppKCj0hZHzjUlxdFqFiKAzJdEgqpGoZ4oZsuMBrzoJ1R3Z2hZ7La6I2l
	 7M+2kKvBNtE59H+8kRsNO+uP/LeT3LBz+zxVZA0gn9SuCnrQLFiKpq8YHjA92WqKBy6wv
	 bRGs9ZsCeFeIluvSye3E9QhjGHtL7JKgMWYM09OB0Wapaz5amkNnSssHI7RWwuxOJDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WtG6vhte5VWEUpNlX21mycBpChJHDHbrLUc0rs6J4mw=;
	b=WY3Wcz5xNf6zZPivf6XJui28N7S9l3MrT95R3RXDk8dNGNUdus39S0EAvHLrsSup7ihL
	 O8IQ4FDbnUh0tkUdQd87yQaq+EMh7YPHvtVmiuk/Hhn26vPd3B5x2/8dTj1iMrQzJyRvz
	 +pJTmCYTdSLJo6Qd79Eyr5pfv3CKjhfNXrUh1/1qJLhZEjY5bLXOFY9FOuIVFuMHWQZh6
	 n5VUq0dRj6HSZ38CmdelSh9BJAibGkHx5AKJdXgr+6eXq6o6+olOfXrV/VfWdPANQa0at
	 aWOjzEj9ILR1YWr4CtV9txx8Ck6H8NanAxMwQxRXGEh84fARk+XJlsUgqaGDevaWukg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nJ/P41dZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06F4606A330;
	Sat,  7 Nov 2026 14:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJ/P41dZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5701F008A1;
	Sat,  7 Nov 2026 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060368;
	bh=WtG6vhte5VWEUpNlX21mycBpChJHDHbrLUc0rs6J4mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJ/P41dZx6Pa/5qS1shLabGLvP9xMQiIr1FWq/tRmAsX+XlztbbEHiHf24H+oppwd
	 dDCBp+Zrwseg9EpdcS+gIaIBbUPRjWnb7YtIdfbKaPoyM28d0TtuEb85bRdBYEpEMJ
	 0eItZZZ5lggVKo6T2YiWQvA1FI/TwsTOipWIyp6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0005/1257] x86/mm/pat: Use pr_warn() for early W^X warnings
Date: Sat,  7 Nov 2026 08:38:21 -0500
Message-ID: <20261107134939.585484475@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit ea6fd393cb9e6811a748c7551de0dd3090f9dcde ]

Nathan Chancellor reports the following warning:

  CPA detected W^X violation: 8000000000000123 -> 0000000000000123 range: 0xffffffffc0400000 - 0xffffffffc0400fff PFN 100e00

from its_alloc() doing set_memory_x() during early retpoline setup.

The warning is not factually wrong but it is unproductive. First, the RWX
permission is temporary and fixed up by execmem_restore_rox(). Second,
at the time of the warning, all kernel text is mapped RWX. So there is not
even a transient actual security issue.

The right way to fix this up is to relax RWX detection during boot but
make a final verification pass over all kernel page tables before running
userspace.  There is code to do that today (debug_checkwx()) but it
must be enabled explicitly in Kconfig.

For now, retain the warning even if it's unproductive, but make it
scream less loudly: use pr_warn_once() rather than WARN_ONCE().

Remove the warning once debug_checkwx() behavior becomes unconditional.

Closes: https://lore.kernel.org/all/20260905044253.GA3816371@ax162
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://patch.msgid.link/20260913-fixes-verify-rwx-v3-1-5e1d6a08bd02@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 226660973d515..c71f6774a2f32 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -719,6 +719,21 @@ static inline pgprot_t verify_rwx(pgprot_t old, pgprot_t new, unsigned long star
 		return new;
 
 	end = start + npg * PAGE_SIZE - 1;
+
+	/*
+	 * If the kernel text is still RWX, gently complain, this could be a
+	 * false positive.
+	 * Once debug_checkwx() becomes mandatory for CONFIG_STRICT_KERNEL_RWX,
+	 * the warning can be removed completely.
+	 */
+	if (!kernel_set_to_readonly) {
+		pr_warn_once("CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
+		  (unsigned long long)pgprot_val(old),
+		  (unsigned long long)pgprot_val(new),
+		  start, end, pfn);
+		return new;
+	}
+
 	WARN_ONCE(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
 		  (unsigned long long)pgprot_val(old),
 		  (unsigned long long)pgprot_val(new),
-- 
2.53.0



