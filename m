Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC797C0A0;
	Mon,  4 Mar 2024 21:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587842; cv=none; b=Txx5H6swFzdErG/N1UAGt2fHEnX2EidWEHAf2ZqiotlMGRu75StcYRUBpEoxPVhl1yQbgkxwPOk8F0iL7X3OUv1GJSWn0u/RLJ0PpKWdl6giP5Loo+kIzqyVL80dyka6U/oGuLY2MW+OW+piFgirC4mPQhyjgCVlkCZq4/44slk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587842; c=relaxed/simple;
	bh=UmUPL4AiO8kQvLGymU/OFaXnd7KWVYIHAvw+SC2shBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1Y6San1VI1Its1naV9mztKkqws96/sAD6sDSyksXw9TueTUFXqSjnwfrq9GVOYXPxJ9S5tJhYIwdWlihqDZaLpR2YXNCwbPhzI14lbKMthb4nix806gYt5Fke0QENejhlWfLTEkuMR6Vfc7lPkDKyuWJPNNWfs+WmWIizx+fRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6qGQk4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6qGQk4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8663C433C7;
	Mon,  4 Mar 2024 21:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587842;
	bh=UmUPL4AiO8kQvLGymU/OFaXnd7KWVYIHAvw+SC2shBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6qGQk4YKlIXr34ByFYjyNIs9VPW9mpHlZXE4/RmIGTGzNG362yzfq8t3OeYYQK+O
	 jGAZV8ePZE2KPlM4HYKd59cvfsuuz33NlyofUMOsCdarQcMbA2R9vUxvFToJRe0bAb
	 HDV80624sqv7HRuUHuPGyIcrwpgpyVfIbnWCK0mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Andy Chiu <andybnac@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.7 110/162] kbuild: Add -Wa,--fatal-warnings to as-instr invocation
Date: Mon,  4 Mar 2024 21:22:55 +0000
Message-ID: <20240304211555.301711741@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 0ee695a471a750cad4fff22286d91e038b1ef62f upstream.

Certain assembler instruction tests may only induce warnings from the
assembler on an unsupported instruction or option, which causes as-instr
to succeed when it was expected to fail. Some tests workaround this
limitation by additionally testing that invalid input fails as expected.
However, this is fragile if the assembler is changed to accept the
invalid input, as it will cause the instruction/option to be unavailable
like it was unsupported even when it is.

Use '-Wa,--fatal-warnings' in the as-instr macro to turn these warnings
into hard errors, which avoids this fragility and makes tests more
robust and well formed.

Cc: stable@vger.kernel.org
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Eric Biggers <ebiggers@google.com>
Tested-by: Andy Chiu <andybnac@gmail.com>
Reviewed-by: Andy Chiu <andybnac@gmail.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20240125-fix-riscv-option-arch-llvm-18-v1-1-390ac9cc3cd0@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Kconfig.include   |    2 +-
 scripts/Makefile.compiler |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/Kconfig.include
+++ b/scripts/Kconfig.include
@@ -33,7 +33,7 @@ ld-option = $(success,$(LD) -v $(1))
 
 # $(as-instr,<instr>)
 # Return y if the assembler supports <instr>, n otherwise
-as-instr = $(success,printf "%b\n" "$(1)" | $(CC) $(CLANG_FLAGS) -c -x assembler-with-cpp -o /dev/null -)
+as-instr = $(success,printf "%b\n" "$(1)" | $(CC) $(CLANG_FLAGS) -Wa$(comma)--fatal-warnings -c -x assembler-with-cpp -o /dev/null -)
 
 # check if $(CC) and $(LD) exist
 $(error-if,$(failure,command -v $(CC)),C compiler '$(CC)' not found)
--- a/scripts/Makefile.compiler
+++ b/scripts/Makefile.compiler
@@ -38,7 +38,7 @@ as-option = $(call try-run,\
 # Usage: aflags-y += $(call as-instr,instr,option1,option2)
 
 as-instr = $(call try-run,\
-	printf "%b\n" "$(1)" | $(CC) -Werror $(CLANG_FLAGS) $(KBUILD_AFLAGS) -c -x assembler-with-cpp -o "$$TMP" -,$(2),$(3))
+	printf "%b\n" "$(1)" | $(CC) -Werror $(CLANG_FLAGS) $(KBUILD_AFLAGS) -Wa$(comma)--fatal-warnings -c -x assembler-with-cpp -o "$$TMP" -,$(2),$(3))
 
 # __cc-option
 # Usage: MY_CFLAGS += $(call __cc-option,$(CC),$(MY_CFLAGS),-march=winchip-c6,-march=i586)


