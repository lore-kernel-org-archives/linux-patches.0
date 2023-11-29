Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733B24CB3D;
	Wed, 29 Nov 2023 23:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMheO98f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D53C433C7;
	Wed, 29 Nov 2023 23:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701300603;
	bh=SkLsMu3Rty3isSC0Z5GyFZX6XuqhUs1znj+pThA/4jw=;
	h=From:Subject:Date:To:Cc:From;
	b=OMheO98fL0KVjOHUecQQmELTMVNw+EZNbXgDquWeoCUgyK9h2zXfXFoDC+l5hLgjw
	 H40ExQ2yBouWEwBOhT9F0BuLOxGEm66S8AMrxe6x79MOKTw8VWIkdX9WuKTVsNIB+7
	 kHOWkwpuAnhPyKQ8ulBq4zaEoMYiK5F5G7QwCOCp2AhDrLhrV4J9Z8N1qD/2bxyI8P
	 7xnzDCGDua7HkWlWOo9seEcALqEBjuW6R5Alirr1nlvqZIZVvN2EflBHVRNW6IXXSb
	 f9Mw3vayyXtDbq17FGmX+TKrVF8nV8SXkjvQAqeP26bd2+91mtP8r8C9WfKFICsjo6
	 2oLXwwU5U3Ouw==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/2] RISC-V: Disable DWARF5 with known broken LLVM versions
Date: Wed, 29 Nov 2023 16:29:46 -0700
Message-Id: <20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGvJZ2UC/x3MwQqDMAwA0F+RnA3YTtH6K7JDW6MGnJOkdAPx3
 1d2fJd3gZIwKYzVBUKZld9HgakriJs/VkKei8E29mGMdSisMaOQJuGYcP54WTrc9/xC7wbbhuD
 6NgYowSm08PefT8/7/gERRGEWbAAAAA==
To: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
 conor@kernel.org
Cc: maskray@google.com, ndesaulniers@google.com, 
 linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=961; i=nathan@kernel.org;
 h=from:subject:message-id; bh=SkLsMu3Rty3isSC0Z5GyFZX6XuqhUs1znj+pThA/4jw=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKnpJ6v09+0p3xu/XT/22JnnEYEzDYrOT152wehtquXU6
 ONVc/l6O0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEzAwYGZb+4jwmsVHPMfxQ
 40btU45xqj12k5btMVXa2L8r5/Z0ByOGf9p73m976b5wUabbBWbl9zsP6AtEaj2dpakSuUzwu92
 fSk4A
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Hi all,

This series disables DWARF5 for LLVM versions where it is known to be
broken due to linker relaxation:

https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db16f649fc21dd18e5b0918f6

If I understand correctly, it sounds like GNU binutils has a similar
issue but I am not sure of the status of the fixes and such, so I did
not bother with checking for it but it should be easy to add if so
desired.

Cheers,
Nathan

---
Nathan Chancellor (2):
      riscv: Hoist linker relaxation disabling logic into Kconfig
      riscv: Restrict DWARF5 when building with LLVM to known working versions

 arch/riscv/Kconfig  | 14 ++++++++++++++
 arch/riscv/Makefile |  4 +---
 lib/Kconfig.debug   |  1 +
 3 files changed, 16 insertions(+), 3 deletions(-)
---
base-commit: 2cc14f52aeb78ce3f29677c2de1f06c0e91471ab
change-id: 20231129-riscv-restrict-dwarf5-llvm-a9824bb974cb

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

