Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022F5219A63;
	Tue, 29 Apr 2025 18:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950785; cv=none; b=Tt87zOrMR7Pv+wrplhZ7tJxyZAHBWhxrAK1P6lq7SL6lR2DkKF1zIOz3gq/sHk5+iCVlS7IbyX5+1KkbHrwd7L89x4NnECrMFEMjEUu2+DuUVfJnZ9v5z+Qc9Up9uugFPXMzoEoD7DAaSC2UWagmvfgbz3qNPYixjV/dlKYgMjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950785; c=relaxed/simple;
	bh=Yu0Wcbcl7TdDDYUs4VjFrAUhDu+mYy2qe4RZQ5riTuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXxJ4fHblV1lgmH9BQR4FPYt/xZf/ss62DajUHRyuHehYQgyqAsklvY/A3+8HV6TYe8EqabshOtrd7AU3ZGrS/p7a28mSk1h8gblK2zSbfOFR73DXS9stLHaIOJuWsrD57BZmjrqv80Br0HupJwk1toAjsKnk5L0QRPTprAs6hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=No4dqgzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="No4dqgzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82961C4CEE3;
	Tue, 29 Apr 2025 18:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950784;
	bh=Yu0Wcbcl7TdDDYUs4VjFrAUhDu+mYy2qe4RZQ5riTuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=No4dqgzQHmBQMeKVNUf27K5NZJ5tZ1a8VdXnYRX7yAigqkq8l6eJsyqGo4ql6E/K3
	 /7aBbh0z3zCUrsyDRRfLLvhQjc4YbysnhTb+GgX1pFoJOvwgjGJaMPKWDvqVjmg49E
	 xbMYxcsOhjm+eUT9t5Gn2AgQorGjyn3q8fl0/XSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 204/204] objtool: Silence more KCOV warnings, part 2
Date: Tue, 29 Apr 2025 18:44:52 +0200
Message-ID: <20250429161107.724545617@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -268,7 +268,7 @@ objtool-args-$(CONFIG_SLS)				+= --sls
 objtool-args-$(CONFIG_STACK_VALIDATION)			+= --stackval
 objtool-args-$(CONFIG_HAVE_STATIC_CALL_INLINE)		+= --static-call
 objtool-args-$(CONFIG_HAVE_UACCESS_VALIDATION)		+= --uaccess
-objtool-args-$(CONFIG_GCOV_KERNEL)			+= --no-unreachable
+objtool-args-$(or $(CONFIG_GCOV_KERNEL),$(CONFIG_KCOV))	+= --no-unreachable
 objtool-args-$(CONFIG_PREFIX_SYMBOLS)			+= --prefix=$(CONFIG_FUNCTION_PADDING_BYTES)
 
 objtool-args = $(objtool-args-y)					\


