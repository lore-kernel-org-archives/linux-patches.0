Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6846118;
	Wed,  7 Jun 2023 18:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF79C433EF;
	Wed,  7 Jun 2023 18:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686163300;
	bh=FMIrMDkkbrc7ewKcGZQ+8+8zBkRdDfwj755JEnjZJxY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=M29dsddKgVo2OUsqtVT9PEx58laR+B4qKPt2B5C4KwVSLpc/3VojfB+gWwAxTFy52
	 kGbn7XOnXcT2I4nWUn12Qgp9R8PP/bd2Z+oGGIou0LZE1RTqBIz/kpQlY/o/AM7D8W
	 F2ylryYOYZl6Vp9y1I6aPzl+P0QMeB5uRvQ8z0G0=
Subject: Patch "riscv: vmlinux.lds.S: Explicitly handle '.got' section" has been added to the 6.3-stable tree
To: aou@eecs.berkeley.edu,conor.dooley@microchip.com,conor@kernel.org,gregkh@linuxfoundation.org,linux-riscv@lists.infradead.org,llvm@lists.linux.dev,nathan@kernel.org,ndesaulniers@google.com,palmer@dabbelt.com,patches@lists.linux.dev,paul.walmsley@sifive.com,sashal@kernel.org,trix@redhat.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Wed, 07 Jun 2023 20:41:28 +0200
In-Reply-To: <20230605-6-3-riscv-got-orphan-warning-llvm-17-v1-1-72c4f11e020f@kernel.org>
Message-ID: <2023060727-sphinx-obtain-935a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    riscv: vmlinux.lds.S: Explicitly handle '.got' section

to the 6.3-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     riscv-vmlinux.lds.s-explicitly-handle-.got-section.patch
and it can be found in the queue-6.3 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From nathan@kernel.org  Wed Jun  7 20:32:10 2023
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 05 Jun 2023 14:15:08 -0700
Subject: riscv: vmlinux.lds.S: Explicitly handle '.got' section
To: gregkh@linuxfoundation.org, sashal@kernel.org, palmer@dabbelt.com, conor@kernel.org
Cc: paul.walmsley@sifive.com, aou@eecs.berkeley.edu, ndesaulniers@google.com, trix@redhat.com, stable@vger.kernel.org, linux-riscv@lists.infradead.org, llvm@lists.linux.dev, patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
Message-ID: <20230605-6-3-riscv-got-orphan-warning-llvm-17-v1-1-72c4f11e020f@kernel.org>

From: Nathan Chancellor <nathan@kernel.org>

This patch is for linux-6.3.y only, it has no direct mainline
equivalent.

LLVM 17 will now use the GOT for extern weak symbols when using the
medany model, which causes a linker orphan section warning on
linux-6.3.y:

  ld.lld: warning: <internal>:(.got) is being placed in '.got'

This is not an issue in mainline because handling of the .got section
was added by commit 39b33072941f ("riscv: Introduce CONFIG_RELOCATABLE")
and further extended by commit 26e7aacb83df ("riscv: Allow to downgrade
paging mode from the command line") in 6.4-rc1. Neither of these changes
are suitable for stable, so add explicit handling of the .got section in
a standalone change to align 6.3 and mainline, which addresses the
warning.

This is only an issue for 6.3 because commit f4b71bff8d85 ("riscv:
select ARCH_WANT_LD_ORPHAN_WARN for !XIP_KERNEL") landed in 6.3-rc1, so
earlier releases will not see this warning because it will not be
enabled.

Closes: https://github.com/ClangBuiltLinux/linux/issues/1865
Link: https://github.com/llvm/llvm-project/commit/a178ba9fbd0a27057dc2fa4cb53c76caa013caac
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/vmlinux.lds.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/riscv/kernel/vmlinux.lds.S
+++ b/arch/riscv/kernel/vmlinux.lds.S
@@ -129,6 +129,8 @@ SECTIONS
 		*(.sdata*)
 	}
 
+	.got : { *(.got*) }
+
 #ifdef CONFIG_EFI
 	.pecoff_edata_padding : { BYTE(0); . = ALIGN(PECOFF_FILE_ALIGNMENT); }
 	__pecoff_data_raw_size = ABSOLUTE(. - __pecoff_text_end);


Patches currently in stable-queue which might be from nathan@kernel.org are

queue-6.3/riscv-vmlinux.lds.s-explicitly-handle-.got-section.patch
