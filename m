Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF4C328626;
	Sat, 25 Oct 2025 16:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409763; cv=none; b=qISr2Hy7u9r9S2lkyJzHBYcG9sY8105jJjqgOTvgQV4eAlRPciijxnFr1ySHMukbxTpUZUnisgBNzec4TxyrF2oK96LX9pC7hTSxDOLX6sY9he2vs4J0ALPgYYZ4+psx0KjCe1xKaYHSiQs9OoaDrKXWEC4Tk/4r493+rLgkTv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409763; c=relaxed/simple;
	bh=/UAolvMJLUfF2m2V4CxAk86WOtZuJJbV38PmSc/N+lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I9/rnAOdNPCaJm8CgJ6w4fb7mhTUBHmTEpEB2cy8067KpYKdRLH1+r4BSFmDh4BUiExP4o9r0mgnxIl0iFJuS9OGiMXuL0CXCs93KbjyMSTYlLSRznlqmDTVUcvTTvaty2AlBMg4KupSwMMPXxPHPz76MsWcPdpP/+1Jok7bi3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ndYYJlby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ndYYJlby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74340C4CEF5;
	Sat, 25 Oct 2025 16:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409763;
	bh=/UAolvMJLUfF2m2V4CxAk86WOtZuJJbV38PmSc/N+lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndYYJlbyqx0yxzX1lqO0KR5wVrnz3paDEbLTK1qhujvNDSyWqbFaDmYacaJqzSJsR
	 TLiHEPZb9wZ9jEEZiGdUo1wQgVam6azyu3ITy7hkaHr/S5Im20IH20r+tKGFNbt1r6
	 KZ2Ny7XUxcQlm7ZRwUdl6Lt8PEJ16ga6z1kFgL73jHXc8fPldTGfFgw/gy1DMhwY2N
	 NBbsT3drKjZUYyM6RFXIqMIN/ZTCzV1dnt5OtBSQkqN+vLSBKuALdW+L73zV6wHLSY
	 w/P3YIQXWju1Nz9fLQzxkEBU9ZOAzadf51bWeTLHpjKYN1KwrwbylPHitvkAsNmyz1
	 jzGXDbZE4Sa0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Koakuma <koachan@protonmail.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>,
	nathan@kernel.org,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17-5.4] sparc/module: Add R_SPARC_UA64 relocation handling
Date: Sat, 25 Oct 2025 12:01:24 -0400
Message-ID: <20251025160905.3857885-453-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Koakuma <koachan@protonmail.com>

[ Upstream commit 05457d96175d25c976ab6241c332ae2eb5e07833 ]

This is needed so that the kernel can handle R_SPARC_UA64 relocations,
which is emitted by LLVM's IAS.

Signed-off-by: Koakuma <koachan@protonmail.com>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – this patch fixes a real module-loading bug for sparc64 systems
without touching unrelated code.

- `arch/sparc/include/asm/elf_64.h:61` adds the missing ABI constant
  `R_SPARC_UA64` (value 54), so the loader can even recognise
  relocations that LLVM’s integrated assembler already emits.
- `arch/sparc/kernel/module.c:90` folds `R_SPARC_UA64` into the existing
  `R_SPARC_64` handler, writing the eight relocation bytes individually
  just like the aligned case. Without this case the switch drops into
  the default branch (`module.c:134`) and aborts module loading with
  “Unknown relocation” and `-ENOEXEC`, so clang-built modules simply
  cannot load today.
- Scope and risk stay minimal: the bytes written are identical to the
  long-standing `R_SPARC_64` path, so nothing changes for GCC-produced
  objects; the new code only runs when the UA64 relocation is present,
  avoiding regressions elsewhere.

Given it unbreaks a supported toolchain configuration with a tiny, well-
contained fix, this is an appropriate stable backport.

 arch/sparc/include/asm/elf_64.h | 1 +
 arch/sparc/kernel/module.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/sparc/include/asm/elf_64.h b/arch/sparc/include/asm/elf_64.h
index 8fb09eec8c3e7..694ed081cf8d9 100644
--- a/arch/sparc/include/asm/elf_64.h
+++ b/arch/sparc/include/asm/elf_64.h
@@ -58,6 +58,7 @@
 #define R_SPARC_7		43
 #define R_SPARC_5		44
 #define R_SPARC_6		45
+#define R_SPARC_UA64		54
 
 /* Bits present in AT_HWCAP, primarily for Sparc32.  */
 #define HWCAP_SPARC_FLUSH       0x00000001
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index b8c51cc23d969..6e3d4dde4f9ab 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -87,6 +87,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 			break;
 #ifdef CONFIG_SPARC64
 		case R_SPARC_64:
+		case R_SPARC_UA64:
 			location[0] = v >> 56;
 			location[1] = v >> 48;
 			location[2] = v >> 40;
-- 
2.51.0

