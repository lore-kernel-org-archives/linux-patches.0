Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061158;
	b=Uz82P7v/DpUPImcLYUdvOV1Yd1uZNbYok6zDvULneB8le/RtYqphYg3GIH7lFKYPxdNj
	 VIMlC9WMrXvkfP0MV7Tg5PecMIw0UfsTP9La9oSg2fPLp0VsCz/grVHiUmJA/9JTaAXwh
	 WDSRDwK0KkwOgQ8+V1X5u4py074iqtq+b4CkpaoxXqXAQR5pweOYkOZZorW29jQ2+FKzB
	 /Qkv66la2KoYf5e7+7Wgx/8ldVBUWD8hQmb44vpZoisqk2QQ1TqHvd6stVGo3Q2YO7Lu2
	 7usEHUIVww+5t/61N/b3/cDUyXltj1sNPihRE8GlmlrrI/OTanq2DsZioGQYeZxTmVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=THKk+QW7jPZeLE5EdoMlG6dMjeqFyQJ3RQiPh/bd80c=;
	b=eppi3S3h1oKRoysE2uEO64pFr9ZRKqr2MdTu2EkDL8OXczOiExFzS6b7p1twP2DGcADp
	 wwixPmDNvciq0qrqOvnk1oCX4e/5cbBTOYzQkiKCmzDvI9+G4HobaZPogu8x14KOLIVsc
	 knOGrKid2iMaul42k/OFDnkBDrhKCAnINlwYC98lscKBL30YigStDpuCzpVC7+s1e071U
	 ak1XTybf0SpU78pya8nOJXlgTcqtImSe3dtmFQZvZtZ2/D966p2RI0/44m8D4x7WtYw1y
	 U3zjd9cwOSkTyPMewLE3PofED1ALoVL+1UJ4VZsmKdej8KAfso60+rigHFG69YleNYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ond2Yswd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64714606D805;
	Sat,  7 Nov 2026 14:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ond2Yswd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135371F0089F;
	Sat,  7 Nov 2026 14:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061158;
	bh=THKk+QW7jPZeLE5EdoMlG6dMjeqFyQJ3RQiPh/bd80c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ond2Yswd/jxov/5l+77D8jVoQGiUyT1672gM1+b/Aj9mIbaLq6XNrPF4kcwDojPz6
	 IhJL7oAp98+okaGoZL94DeA+500Rt5/tBHK52Gjevy/Fe8gUrBxIo779RYfVq7+n2o
	 tykkSiMbigbl4HOGsVyUrYO421Rj8YuH+mVejl8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0465/1536] module/kallsyms: fix nextval for data symbol lookup
Date: Sat,  7 Nov 2026 08:41:21 -0500
Message-ID: <20261107135010.575422421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 18931db1369da..f92317d3796aa 100644
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



