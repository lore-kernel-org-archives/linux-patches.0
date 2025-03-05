Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B8719C542;
	Wed,  5 Mar 2025 18:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198807; cv=none; b=RqKVXg2/6i9lpwrRHeC1ZFtEWZGiC4L+IyElVgZ5tb5Wbvi6wzUu/xdi3bOEdiRSBtttMXb7reV2kMXoB2VV5G45XjNXyBCHZhxVnIIYjpAnM/7IJ5k1gI7p7yH79qtf8uOujfzoeVwAYyUMOfuzZTakiYOXHNaC1GzwGufdZuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198807; c=relaxed/simple;
	bh=bBCvfX3h1fDmUkmXwGcRZUwCifzEDSpKYZr6AA5S1yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJI8GCjym4knSRiCQzw2dCTrMclL2tBHYvyZQnxe+jTy6QNWvne5OLiqHhYJYzYpluryI/LDLPNYfx6MJ0kwJ0LrfXq7Q/ybReN2NlseMMu+Y8oQNWE90TeXooZLYyN4yH/QDjM0vKJjMxwEY5gXl0rk6i6dX0vUwTM93QA1Mh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jm7GWQje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jm7GWQje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60DFC4CED1;
	Wed,  5 Mar 2025 18:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198807;
	bh=bBCvfX3h1fDmUkmXwGcRZUwCifzEDSpKYZr6AA5S1yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jm7GWQje3iStPBX7ITV75D06G82PgHF5V9IYu5F83GhymmI434fsrdcNk+ZMbuUf3
	 sJFYWOZ4CHMFkt/Q1qClwz/W9SNq7Mir6dpOAKa91aaTHp+QWzRnnmIgzw2OVx050J
	 Lgm/sMaa7lvTJ18JP5Z7Zjv+VIhLFa8YDEQLK+qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.13 153/157] x86/microcode/AMD: Remove unused save_microcode_in_initrd_amd() declarations
Date: Wed,  5 Mar 2025 18:49:49 +0100
Message-ID: <20250305174511.437498837@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

From: "Borislav Petkov (AMD)" <bp@alien8.de>

commit 3ef0740d10b005a45e8ae5b4b7b5d37bfddf63c0 upstream.

Commit

  a7939f016720 ("x86/microcode/amd: Cache builtin/initrd microcode early")

renamed it to save_microcode_in_initrd() and made it static. Zap the
forgotten declarations.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20250211163648.30531-3-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c      |    2 +-
 arch/x86/kernel/cpu/microcode/internal.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -517,7 +517,7 @@ static bool __apply_microcode_amd(struct
  * patch container file in initrd, traverse equivalent cpu table, look for a
  * matching microcode patch, and update, all in initrd memory in place.
  * When vmalloc() is available for use later -- on 64-bit during first AP load,
- * and on 32-bit during save_microcode_in_initrd_amd() -- we can call
+ * and on 32-bit during save_microcode_in_initrd() -- we can call
  * load_microcode_amd() to save equivalent cpu table and microcode patches in
  * kernel heap memory.
  *
--- a/arch/x86/kernel/cpu/microcode/internal.h
+++ b/arch/x86/kernel/cpu/microcode/internal.h
@@ -100,14 +100,12 @@ extern bool force_minrev;
 #ifdef CONFIG_CPU_SUP_AMD
 void load_ucode_amd_bsp(struct early_load_data *ed, unsigned int family);
 void load_ucode_amd_ap(unsigned int family);
-int save_microcode_in_initrd_amd(unsigned int family);
 void reload_ucode_amd(unsigned int cpu);
 struct microcode_ops *init_amd_microcode(void);
 void exit_amd_microcode(void);
 #else /* CONFIG_CPU_SUP_AMD */
 static inline void load_ucode_amd_bsp(struct early_load_data *ed, unsigned int family) { }
 static inline void load_ucode_amd_ap(unsigned int family) { }
-static inline int save_microcode_in_initrd_amd(unsigned int family) { return -EINVAL; }
 static inline void reload_ucode_amd(unsigned int cpu) { }
 static inline struct microcode_ops *init_amd_microcode(void) { return NULL; }
 static inline void exit_amd_microcode(void) { }


