Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8030D36E475
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300956; cv=none; b=Xa+Jbj2xeYbWchjKa55wnQN8T3cXxsAshRRvuH4le+pTTTgY73l2C3CczvQBMtY1uvqFvtc2EkeXH9hvYY3gwRuwjEKuzupdO4CcJ/Kcr4y/uSqpy2jPBjEWgyKaaHCeWnxP9UV1cOf5MPlpn8jtJpN+p7EFNCwVB2e0oOjeEZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300956; c=relaxed/simple;
	bh=zz3M9mpjhNOrmlHz15hpQTc3IFIDCq+wlZspWI8Z17g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iJmHgFX7nmiSqC40fbBQZ+/kOZM0P2ihlYSPgSq3sZ9xX3OPvPp2758vX3Z+FZcMjtee3+V8II8+twvXM2aL+y8GB/nlt+DhUPbfItAvv4w/pGiPnuzzdY3buwSOCQTXmEreoAVvPTQlTA6h6vdT7RB9i6rmuydW+I2lcFt81KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mB6R3x6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mB6R3x6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3280C19425;
	Sat, 28 Feb 2026 17:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300956;
	bh=zz3M9mpjhNOrmlHz15hpQTc3IFIDCq+wlZspWI8Z17g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mB6R3x6cRBG+ZabDlK9Qv9jP40QWd2PDuupNXhDkt0zwu8xJKqxYUYghP3Ti7fet0
	 BZi7zfUTU5pHc+gX6ITjkFvmSi/cSmhwJvX0DTJK3TO5DWJBQRTV4lr1ocVtC2Nfs2
	 flz3rgdocMSyJ38/y12PU8LlzQEUig0pVd6bR1djGFF2W1galsUOjrNvDFxT3dRxyr
	 kMysL/0zAi5gRZTn1JKg291ixSpXqfN4eFTMxXdztbpNtFZ7yE2CJYwnuv071zzrzH
	 HYFXvMWeHZkCl9STTeLnSLG2bY+vEn7nIIQavypQZocQfNOKqYIczwLrBoEy7xlwZk
	 NpSYHD5c/krOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sami Tolvanen <samitolvanen@google.com>,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 080/752] gendwarfksyms: Fix build on 32-bit hosts
Date: Sat, 28 Feb 2026 12:36:31 -0500
Message-ID: <20260228174750.1542406-80-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit ddc54f912a551f6eb0bbcfc3880f45fe27a252cb ]

We have interchangeably used unsigned long for some of the types
defined in elfutils, assuming they're always 64-bit. This obviously
fails when building gendwarfksyms on 32-bit hosts. Fix the types.

Reported-by: Michal Suchánek <msuchanek@suse.de>
Closes: https://lore.kernel.org/linux-modules/aRcxzPxtJblVSh1y@kitsune.suse.cz/
Tested-by: Michal Suchánek <msuchanek@suse.de>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gendwarfksyms/dwarf.c   | 4 +++-
 scripts/gendwarfksyms/symbols.c | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/scripts/gendwarfksyms/dwarf.c b/scripts/gendwarfksyms/dwarf.c
index 3538a7d9cb070..e76d732f5f602 100644
--- a/scripts/gendwarfksyms/dwarf.c
+++ b/scripts/gendwarfksyms/dwarf.c
@@ -750,6 +750,7 @@ static void process_enumerator_type(struct state *state, struct die *cache,
 				    Dwarf_Die *die)
 {
 	bool overridden = false;
+	unsigned long override;
 	Dwarf_Word value;
 
 	if (stable) {
@@ -761,7 +762,8 @@ static void process_enumerator_type(struct state *state, struct die *cache,
 			return;
 
 		overridden = kabi_get_enumerator_value(
-			state->expand.current_fqn, cache->fqn, &value);
+			state->expand.current_fqn, cache->fqn, &override);
+		value = override;
 	}
 
 	process_list_comma(state, cache);
diff --git a/scripts/gendwarfksyms/symbols.c b/scripts/gendwarfksyms/symbols.c
index ecddcb5ffcdfb..42cd27c9cec4f 100644
--- a/scripts/gendwarfksyms/symbols.c
+++ b/scripts/gendwarfksyms/symbols.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2024 Google LLC
  */
 
+#include <inttypes.h>
 #include "gendwarfksyms.h"
 
 #define SYMBOL_HASH_BITS 12
@@ -242,7 +243,7 @@ static void elf_for_each_global(int fd, elf_symbol_callback_t func, void *arg)
 				error("elf_getdata failed: %s", elf_errmsg(-1));
 
 			if (shdr->sh_entsize != sym_size)
-				error("expected sh_entsize (%lu) to be %zu",
+				error("expected sh_entsize (%" PRIu64 ") to be %zu",
 				      shdr->sh_entsize, sym_size);
 
 			nsyms = shdr->sh_size / shdr->sh_entsize;
@@ -292,7 +293,7 @@ static void set_symbol_addr(struct symbol *sym, void *arg)
 		hash_add(symbol_addrs, &sym->addr_hash,
 			 symbol_addr_hash(&sym->addr));
 
-		debug("%s -> { %u, %lx }", sym->name, sym->addr.section,
+		debug("%s -> { %u, %" PRIx64 " }", sym->name, sym->addr.section,
 		      sym->addr.address);
 	} else if (sym->addr.section != addr->section ||
 		   sym->addr.address != addr->address) {
-- 
2.51.0

