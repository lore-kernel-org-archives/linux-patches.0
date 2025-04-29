Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEBD22DF91;
	Tue, 29 Apr 2025 17:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948397; cv=none; b=QeO0Az+/UrH6Y7dPOtTJuJZAj2YOlutxYnVNV+g3cFYqbtJP+jKgs9Fb6+3KB9kS3FgFYj+Ujm7fEfPU1G5Jo4m9HOa0i8vOu6iQ8U63IZ+suDb9ulOTAaa1X61xYDkRgiZGtiCCEvsuvnO5P3HL86+DIPye59nL0uUuuU6pNTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948397; c=relaxed/simple;
	bh=Uq3kOkg5Re6q5tW8zZjdBo0P7jZIey35+v4HMUX8FcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ub5bvbBu2zy7pMhCHUsJd5hqVuG0ot5mtjKg+mV5pFvb7Wbd6fR34M9558kZOON4ebUr1ViH6z5uSPl8p9wFaE2wVgrjHpVLvxJ5p8XnlJooc4YDFDkXpFbFHsZ8CZgs9MV78aMpf1IvTiiZwuHANMPR5mkix5viRBRJ0FmXVt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bf8KfDyS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bf8KfDyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCAEC4CEE3;
	Tue, 29 Apr 2025 17:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948397;
	bh=Uq3kOkg5Re6q5tW8zZjdBo0P7jZIey35+v4HMUX8FcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bf8KfDySnpBsbSw9xKTQPH9NB7x6QqPijPGNfeA+9JCjcA+V4uCyag9LqYikpZ7NM
	 BCad/q9cEAV67aFKQmDT/H66GETosXmVg0HGA91lLBa1Guisemj53Zq03E+r0AskaD
	 O9L65V8bDsLsAk1LG6dXkaGn4InYOj13eM6cspdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 276/280] objtool: Silence more KCOV warnings, part 2
Date: Tue, 29 Apr 2025 18:43:37 +0200
Message-ID: <20250429161126.426116042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 55c78035a1a8dfb05f1472018ce2a651701adb7d upstream.

Similar to GCOV, KCOV can leave behind dead code and undefined behavior.
Warnings related to those should be ignored.

The previous commit:

  6b023c784204 ("objtool: Silence more KCOV warnings")

... only did so for CONFIG_CGOV_KERNEL.  Also do it for CONFIG_KCOV, but
for real this time.

Fixes the following warning:

  vmlinux.o: warning: objtool: synaptics_report_mt_data: unexpected end of section .text.synaptics_report_mt_data

Fixes: 6b023c784204 ("objtool: Silence more KCOV warnings")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/a44ba16e194bcbc52c1cef3d3cd9051a62622723.1743481539.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/oe-kbuild-all/202503282236.UhfRsF3B-lkp@intel.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.lib |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -257,7 +257,7 @@ objtool-args-$(CONFIG_MITIGATION_SLS)
 objtool-args-$(CONFIG_STACK_VALIDATION)			+= --stackval
 objtool-args-$(CONFIG_HAVE_STATIC_CALL_INLINE)		+= --static-call
 objtool-args-$(CONFIG_HAVE_UACCESS_VALIDATION)		+= --uaccess
-objtool-args-$(CONFIG_GCOV_KERNEL)			+= --no-unreachable
+objtool-args-$(or $(CONFIG_GCOV_KERNEL),$(CONFIG_KCOV))	+= --no-unreachable
 objtool-args-$(CONFIG_PREFIX_SYMBOLS)			+= --prefix=$(CONFIG_FUNCTION_PADDING_BYTES)
 
 objtool-args = $(objtool-args-y)					\


