Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034504;
	b=SviuEA43RtH0bSOxAh7ChCq3yn98qDrYorX7y7yVPgNbkz7G0CbRoMyZkEnl+6B0yEMv
	 FlNnbrWF8j1rD+5eR/+W+nR7OvAxM+TluvpeMPaPgeYGNIwdVfwSgZTzFWoOoAribPIrW
	 SZUtOkOHHnzDKY8SL2lBaYeyqMP6fIqlJzj8+6DSX46VyKIC/pbYDthXcL2kxGV8Er4Bd
	 SeFKbSRxijEPxGl0ChBQkfJ9zIdcyBqh2FE877mioyXrBqevc17eqER3mwgdQokYWoO/r
	 A2fwzr285jECiBtx80gNvCK+wtzOhxXJUKmUlKN/z/g62bykuQdR9cQ0KaPRuhuVwZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bwnAh/PXgjEs5M+MXrc2hFgkgEq4QhupZVf2nSGZlyI=;
	b=CessCswNjygAomwP94S2Cn8ba+I4W7bXLpRdySbSHCdXS99znbHSS1HXuUgY8zh36QP6
	 ySuu6F57LoW3nDpFKo8WPRMFC4mgXmTRrAiPzR+aIrim21Zhy20dN4/4n2MLsRZ5Cufnl
	 Pd4XQUbQsJ2ULDBsX0gAWAPMWIlJ3RdjE9gWiZvRoiqd3GWos9wvkh/a90B4OzSrzOSAC
	 Z8VoIXg9hMQobneG/FwBp+Rlaz6oOOYv0GKMogBPqwaN4vs5Y6jBxtPeHIxzlXutmhBNj
	 BnJAcwoP96ZWdFTAqoamX9No4IySHBtm3bAyDy/8r+e2Ve++AW2GnjStJl2yFpmKDIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LdaLzw4X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1182606A32A;
	Wed, 18 Nov 2026 20:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LdaLzw4X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B44C1F000C4;
	Wed, 18 Nov 2026 20:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034504;
	bh=bwnAh/PXgjEs5M+MXrc2hFgkgEq4QhupZVf2nSGZlyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LdaLzw4XwAaN3OQuZboroiy66XXckdrpDsxPqDb9VAAdGbkWF1w0DlMEWPFHcNYIL
	 Vwbq4zR9dB892vljIvU6HMOKIAcIjUaAVZVRilKujWOPHbpDGKSS52+4/pH464gSls
	 0VZwBFKCETNaSUIuVWzYIRy6hzS23ctYWPER1IpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0394/3318] module/kallsyms: fix nextval for data symbol lookup
Date: Wed, 18 Nov 2026 15:16:56 +0100
Message-ID: <20261118150328.192107983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stf_xl@wp.pl>

[ Upstream commit 0e9f090a4e9bfae5a190ccf89eab3bf14f6b0f96 ]

The symbol lookup code assumes the queried address resides in either
MOD_TEXT or MOD_INIT_TEXT. This breaks for addresses in other module
memory regions (e.g. rodata or data), resulting in incorrect upper
bounds and wrong symbol size.

Select the module memory region the address belongs to instead of
hardcoding text sections. Also initialize the lower bound to the start
of that region, as searching from address 0 is unnecessary.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/kallsyms.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
index 5b7783d33fb93..677e4e5b6fb9e 100644
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -261,17 +261,25 @@ static const char *find_kallsyms_symbol(struct module *mod,
 	unsigned int i, best = 0;
 	unsigned long nextval, bestval;
 	struct mod_kallsyms *kallsyms = rcu_dereference(mod->kallsyms);
-	struct module_memory *mod_mem;
+	struct module_memory *mod_mem = NULL;
 
-	/* At worse, next value is at end of module */
-	if (within_module_init(addr, mod))
-		mod_mem = &mod->mem[MOD_INIT_TEXT];
-	else
-		mod_mem = &mod->mem[MOD_TEXT];
+	for_each_mod_mem_type(type) {
+#ifndef CONFIG_KALLSYMS_ALL
+		if (!mod_mem_type_is_text(type))
+			continue;
+#endif
+		if (within_module_mem_type(addr, mod, type)) {
+			mod_mem = &mod->mem[type];
+			break;
+		}
+	}
 
-	nextval = (unsigned long)mod_mem->base + mod_mem->size;
+	if (!mod_mem)
+		return NULL;
 
-	bestval = kallsyms_symbol_value(&kallsyms->symtab[best]);
+	/* Initialize bounds within memory region the address belongs to. */
+	nextval = (unsigned long)mod_mem->base + mod_mem->size;
+	bestval = (unsigned long)mod_mem->base - 1;
 
 	/*
 	 * Scan for closest preceding symbol, and next symbol. (ELF
-- 
2.53.0



