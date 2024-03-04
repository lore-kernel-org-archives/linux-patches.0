Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B4146BA0;
	Mon,  4 Mar 2024 21:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588418; cv=none; b=Huy0nGuvzcqHoNKNsl6QPeR+6QIJrQ2e+xctTP48lVv3f93Bap/jQ/ndSjpy+eha4Xttsxjj5nwSFXnRaOb6NXOAv1gSKOKYg11cWmoL+HB9WSo1SNFwbjAu5FhSf+RC96PUqS6ROTdkbgEJcQN3smHjIKEBuj3xCpYhI5U1kxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588418; c=relaxed/simple;
	bh=tTN2LMswi9DtaiV/YI3ThWz7nxgMFMtQKYDkpaIt//k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3Yx1e1yaNGedXm2wgJRUVk106+o2uX8Sa+q12vJcXRh7gAii8WoH3AxCEdagk71TdoIBiGxm+los6DfbFz+F75UGJj4Kl+FhAm3j3NAlh6ffgUgt04hzM7dgH8H32opQH3XSr5I5YieYg7xSOYDAvZ1dxyeFxxHpnFZtK70o70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+KSuyjQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+KSuyjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE92C433F1;
	Mon,  4 Mar 2024 21:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588418;
	bh=tTN2LMswi9DtaiV/YI3ThWz7nxgMFMtQKYDkpaIt//k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+KSuyjQHXUGnnP/84sbzofmCuKz3hPw+y1/RTjQfdFarWtIiiq252pgXPOj4afmR
	 QFYc7mWEGPpK95iIPr+LwCXmaME+wL/OCW8UbvNf2uTFrl22cEuBmvN56XYwro4+0S
	 S07GnC1Sme5rkFsS6lrY6mWYZe+FoJZMeGFiSNb8=
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
Subject: [PATCH 6.6 099/143] kbuild: Add -Wa,--fatal-warnings to as-instr invocation
Date: Mon,  4 Mar 2024 21:23:39 +0000
Message-ID: <20240304211553.078275708@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


