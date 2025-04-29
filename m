Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293811A5BBB;
	Tue, 29 Apr 2025 18:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950134; cv=none; b=Rk09Y9W7cR7swujHXRoT9u/lE7lgGiMHQCGlE5Z7FgAbVuG4VhzrhWvMz1W82BNhK5rTa0zme4fO9a5eHqNUn/AD78PTcifwV6FjrIARSANtVoYwEQQ8sSHYb9/0kYq2FjVTxhuRjvhPYLB8AkwYrS7xPpMfGk8kerPoK4+t3Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950134; c=relaxed/simple;
	bh=jWi6o9xs1PEyPCzYzEPgMSksuOXnncqbr/zV1XljZzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6qqg10lur+/kM+8R7xhqp6r+Cbb8pwFauFrkHtp0WUxyi43ynl1oM+Bgbmbt5lxobIT3NruG7GpHaSSb9ghUBzPcIG7KRNcTVSSBTI+1fDlMqRAe7ed9jwi3EIUAnejw+ZLYcw6fabJHExaYE5r9o829Tui93J/5puFxYqNzTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRFOKsEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRFOKsEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FE9C4CEE3;
	Tue, 29 Apr 2025 18:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950133;
	bh=jWi6o9xs1PEyPCzYzEPgMSksuOXnncqbr/zV1XljZzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRFOKsEMcVXWfTl4ZrlJfFdmLbbwOMA9jZJXx1DNFc9Nb2h6FQ6z5SQIBBnf35bgI
	 agPnJj9q8dPsWUYHk3AWiBaEdmbTlx31g/9w2bKGP2p1nXXSDI3iUpd7D8eGYL4Y9r
	 890p/ANQM4kMqPkxjxhBRB/nyDLIbijhwPEe9KVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 167/167] objtool: Silence more KCOV warnings, part 2
Date: Tue, 29 Apr 2025 18:44:35 +0200
Message-ID: <20250429161058.480439491@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -263,7 +263,7 @@ objtool-args-$(CONFIG_SLS)				+= --sls
 objtool-args-$(CONFIG_STACK_VALIDATION)			+= --stackval
 objtool-args-$(CONFIG_HAVE_STATIC_CALL_INLINE)		+= --static-call
 objtool-args-$(CONFIG_HAVE_UACCESS_VALIDATION)		+= --uaccess
-objtool-args-$(CONFIG_GCOV_KERNEL)			+= --no-unreachable
+objtool-args-$(or $(CONFIG_GCOV_KERNEL),$(CONFIG_KCOV))	+= --no-unreachable
 
 objtool-args = $(objtool-args-y)					\
 	$(if $(delay-objtool), --link)					\


