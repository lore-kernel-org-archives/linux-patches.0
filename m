Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53295303A28;
	Wed,  3 Dec 2025 16:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777978; cv=none; b=ngAa8uOs3R1exq8Ch+7+Dwx3Ue77nwWisk8vxEgzixADPdhqHRB5tohy5jcTNUJY0341XbEGuxCYh0BQe0ZDCtrw/4QwymBLbdVUlqJlevV64Guc3yxlWPzkLMs5qjlWr1wkjj9YL2sHsBgH4qQNc3OC3PFET6/4l7o9TuukDqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777978; c=relaxed/simple;
	bh=bpkScj+ZfE6z3rX2oIsUIR7m3SNiH+O05A/EoXSE/bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbKkdEPNEno5+4r5EWyF8K2cWQivqB8yoYb2kQA4VoOOUtmo6Lv5gNO5hFcBypE/9wv8JWZtpVLycM9/qFKPaeQwt9vVovkD9DOaClglOjoZuIUuYmNbi/snN8mkDrw/2bjLLPFtzieAsDh98yhIdu/QrphlG0tCtf95faJjk4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDovb+M0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDovb+M0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4422C4CEF5;
	Wed,  3 Dec 2025 16:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777978;
	bh=bpkScj+ZfE6z3rX2oIsUIR7m3SNiH+O05A/EoXSE/bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDovb+M0XPLnBTMb2nRP1vS8aYUZPVeJ5eiGKBak9QeQbLs+ghXx1EnQXjauToqiz
	 GALorc/wRbrxNop38cibJtf4wuND+FBQIyBQ4ezK6jUeUy7hjpzpShwa3iqVm/sKjq
	 3Y+78F6MrAq/d8Q2PCc7UD0St3kH6ShMMAED1CGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koakuma <koachan@protonmail.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 172/392] sparc/module: Add R_SPARC_UA64 relocation handling
Date: Wed,  3 Dec 2025 16:25:22 +0100
Message-ID: <20251203152420.408209982@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koakuma <koachan@protonmail.com>

[ Upstream commit 05457d96175d25c976ab6241c332ae2eb5e07833 ]

This is needed so that the kernel can handle R_SPARC_UA64 relocations,
which is emitted by LLVM's IAS.

Signed-off-by: Koakuma <koachan@protonmail.com>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
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
index df39580f398d3..737f7a5c28359 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -117,6 +117,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 			break;
 #ifdef CONFIG_SPARC64
 		case R_SPARC_64:
+		case R_SPARC_UA64:
 			location[0] = v >> 56;
 			location[1] = v >> 48;
 			location[2] = v >> 40;
-- 
2.51.0



