Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016382;
	b=ITaEBR+FfeCYRW0tV6GKWyiq+/fV7xR2lEat5we5/NdqJYifbvqo3i982brwXdqtSFH5
	 dQd5ruinqHf4RZlhkoQhCXmkK9HtePZu46krlIOoMY89WP1vVU1ODUqfzF9tXZD0M/Liy
	 CVnLYAFEC3EvtSJ33Wq9XwhdTp3uLKw2jDAELH+0dQnWSfok9Zgla+KyBWafYBCNN1QKK
	 aUOsUj+c7FIDQ+Rk4gCpI22zTAkjCGhvXIq/K17ux1eGw84N9NIPRSpLq21r3Q2pNFrLz
	 m3jSJp/9B+680bIQVBi4Q8lzAnS06o52Rqq+mByv9EtVb56heJo4B0xcEf9Qakj/JSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=irAkffL0rhFgaXlH0nHUA33X6UvyYH/qEMq3+18cUjU=;
	b=ysOu3zagO7lCmzZ7EL77+G1UMF2Dt9D9XamnAj69PnnkjHHWKSD92wm1i5HLIiKrGMLS
	 0gIyLus2dET84mWi8rhQ8JlFRXprcP5p3BB2kbO4L2hHewQ+qo/WERq38pQFbGcLZjAZi
	 uBth1IY1paKiCRqBqscDjGqeHBqHBs79GCNJPZKiTVIs5lj9455Q1xScDlkXfa+zLD62X
	 5RzT/9j0STuXMLU2WxYHLKQB/JL1eSamlyYj1OShxfRxKgKsVYpIIOsPoUBP/CE0gTVfF
	 Xc5VFZVLyNaBgTQTVpGQzJY4uKfQXWzFoxLY1ZW/d2wufrr3ynSNP9ifWcmB5CBHCjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yg9hOEEi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4735D60A2610;
	Wed, 18 Nov 2026 15:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yg9hOEEi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD391F000C8;
	Wed, 18 Nov 2026 15:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016382;
	bh=irAkffL0rhFgaXlH0nHUA33X6UvyYH/qEMq3+18cUjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yg9hOEEiL3TQBZ3a48uijy8Ea2ih+9S0hbIQXnSs6Jg5+7sItuySAEjDWMgYrdIsE
	 8p9rgbkeCfjSEX8bwHzo5cjLxaO9T+Khe3uT+mNlFNgzcUfX7mtrf587iD49zzId6i
	 I7ISFgOOQKRrMNkwgKflHqq6bZ0RKtJMtF01xRKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0508/2651] x86/cpu: Dont transiently clear the boot CPUs capabilities
Date: Wed, 18 Nov 2026 15:29:08 +0100
Message-ID: <20261118150306.044937267@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Ihor Solodrai <ihor.solodrai@linux.dev>

[ Upstream commit 2711d67bc3a776abcfc651ad87be5d29ada19166 ]

On the boot CPU, identify_cpu() runs from arch_cpu_finalize_init(), with
interrupts enabled and before alternatives are patched. So
cpu_feature_enabled() still evaluates against boot_cpu_data.

identify_cpu() rebuilds c->x86_capability from scratch: the reset zeroes the
array and the CPUID rescan fills it in again. An interrupt delivered in that
window finds X86_FEATURE_LA57 clear in boot_cpu_data, so pgtable_l5_enabled()
is false and KASAN checks a 5-level address against the 4-level addressability
limit. The result is a bogus "wild-memory-access" report, and under
kasan_multi_shot a report storm that wedges the boot.

The boot CPU has already been scanned by early_identify_cpu(), with interrupts
disabled, and its capabilities cannot have changed since. Reset only the CPUs
which have not been scanned yet.

The window is as old as identify_cpu() rebuilding the capabilities.  Commit

  39b9552281ab ("x86/mm: Optimize boot-time paging mode switching cost")

merely let KASAN notice it by making pgtable_l5_enabled() read the feature
bit. So no Fixes: tag.

Closes: https://lore.kernel.org/bpf/20260610175651.647515-1-ihor.solodrai@linux.dev/
Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20260916195203.1099646-6-ihor.solodrai@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index de07688c8711a..a81c1a367f5e9 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2000,8 +2000,6 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 
 	c->loops_per_jiffy = loops_per_jiffy;
 
-	init_cpu_info(c);
-
 	if (!cpuid_feature())
 		identify_cpu_without_cpuid(c);
 
@@ -2186,6 +2184,7 @@ void identify_secondary_cpu(unsigned int cpu)
 		*c = boot_cpu_data;
 	c->cpu_index = cpu;
 
+	init_cpu_info(c);
 	identify_cpu(c);
 #ifdef CONFIG_X86_32
 	enable_sep_cpu();
-- 
2.53.0



