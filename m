Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB6535A39F;
	Thu,  2 Jul 2026 16:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010812; cv=none; b=j1NeKbwOxSwLrDdrrHfU75F1FRyEQ6QcXkGoAh/aSR0LNpqXbRQtdXwWgo3WWYhCWct736FZO8AlbcBVTNW2GwB1Ethi+kf4LQlrTCqujOjv0LQaumn6cSQwNvqUc+i6m/8d0YgHWTSTlMsYiapXw0+dkPR6kHtKioT4X0j+Zvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010812; c=relaxed/simple;
	bh=FHY1M+RTpbNepNFhMySfaHeGp6lqzkePiK179qjf7Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQ2eO86qbkGommOilAN/x3FhBOwhWR0U5Fi/B68MqpoqdTNTXDqYRsgSvWFFANj89hBuNv/uxEAONpYEvbN4+mmXYhP25eHGFxts4eDjO2BJF+MVMsHZJCB4xvlPDygNFNZ67khVqVAQNUbD0WGJsld8RIzP3jEyMep8wKNlyOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoEkEvam; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoEkEvam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374F81F000E9;
	Thu,  2 Jul 2026 16:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010810;
	bh=dQMETyitjS71P+aJl1nGf6sBOOVChUihqWZypAztXQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DoEkEvamRhUiUK5A08WxzdTCtAMVkBF17gCHocgSYV9skc8BJFT3Zoo4rtThEKlri
	 EVLdXn8/NII6OQ2upDZS2oKuZYS+ksBXC+11EKs5Fkdq7E25IZhDsSXaFE/hpRTaQP
	 J3HGtlj8GuxyjPeIZOO4YtTbjgsYLnM2tKTx4ZW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bpf <bpf@vger.kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Martin Kelly <martin.kelly@crowdstrike.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Subject: [PATCH 6.6 044/175] scripts/sorttable: Remove unused macro defines
Date: Thu,  2 Jul 2026 18:19:05 +0200
Message-ID: <20260702155116.725351737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 28b24394c6e9a3166fcb4480cba054562526657c ]

The code of sorttable.h was copied from the recordmcount.h  which defined
a bunch of Elf MACROs so that they could be used between 32bit and 64bit
functions. But there's several MACROs that sorttable.h does not use but
was copied over. Remove them to clean up the code.

Cc: bpf <bpf@vger.kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Zheng Yejian <zhengyejian1@huawei.com>
Cc: Martin  Kelly <martin.kelly@crowdstrike.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/20250105162344.128870118@goodmis.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.h |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/scripts/sorttable.h
+++ b/scripts/sorttable.h
@@ -27,19 +27,10 @@
 #undef Elf_Ehdr
 #undef Elf_Shdr
 #undef Elf_Rel
-#undef Elf_Rela
 #undef Elf_Sym
-#undef ELF_R_SYM
-#undef Elf_r_sym
-#undef ELF_R_INFO
-#undef Elf_r_info
-#undef ELF_ST_BIND
 #undef ELF_ST_TYPE
-#undef fn_ELF_R_SYM
-#undef fn_ELF_R_INFO
 #undef uint_t
 #undef _r
-#undef _w
 
 #ifdef SORTTABLE_64
 # define extable_ent_size	16
@@ -52,19 +43,10 @@
 # define Elf_Ehdr		Elf64_Ehdr
 # define Elf_Shdr		Elf64_Shdr
 # define Elf_Rel		Elf64_Rel
-# define Elf_Rela		Elf64_Rela
 # define Elf_Sym		Elf64_Sym
-# define ELF_R_SYM		ELF64_R_SYM
-# define Elf_r_sym		Elf64_r_sym
-# define ELF_R_INFO		ELF64_R_INFO
-# define Elf_r_info		Elf64_r_info
-# define ELF_ST_BIND		ELF64_ST_BIND
 # define ELF_ST_TYPE		ELF64_ST_TYPE
-# define fn_ELF_R_SYM		fn_ELF64_R_SYM
-# define fn_ELF_R_INFO		fn_ELF64_R_INFO
 # define uint_t			uint64_t
 # define _r			r8
-# define _w			w8
 #else
 # define extable_ent_size	8
 # define compare_extable	compare_extable_32
@@ -76,19 +58,10 @@
 # define Elf_Ehdr		Elf32_Ehdr
 # define Elf_Shdr		Elf32_Shdr
 # define Elf_Rel		Elf32_Rel
-# define Elf_Rela		Elf32_Rela
 # define Elf_Sym		Elf32_Sym
-# define ELF_R_SYM		ELF32_R_SYM
-# define Elf_r_sym		Elf32_r_sym
-# define ELF_R_INFO		ELF32_R_INFO
-# define Elf_r_info		Elf32_r_info
-# define ELF_ST_BIND		ELF32_ST_BIND
 # define ELF_ST_TYPE		ELF32_ST_TYPE
-# define fn_ELF_R_SYM		fn_ELF32_R_SYM
-# define fn_ELF_R_INFO		fn_ELF32_R_INFO
 # define uint_t			uint32_t
 # define _r			r
-# define _w			w
 #endif
 
 #if defined(SORTTABLE_64) && defined(UNWINDER_ORC_ENABLED)


