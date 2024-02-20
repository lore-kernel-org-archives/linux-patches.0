Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3B5612D7;
	Tue, 20 Feb 2024 21:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465211; cv=none; b=NGWhNKcL0ZrwPcera7mrLzgk5wmmw0Tx3h0Am/D7yyk2pbq+clrUxcV0Pp0N+KscxbSIxsjFiPP67lM+ghpJIhmPMB9G8ttCJBIwgIoanB/ro6yg9xAIDVPJ9BuyNP69MZCBVxfEq0YZhPRCG8MMGbajiI3NoDZR15l2r/M7PGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465211; c=relaxed/simple;
	bh=JHbYm7sd9Y4MFx6XCS8Y0ylte+siRi60YJS8HWBvemI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0EJBf9Ds8UhFWBQYBCaOSPc06tzeolDvijEmUA5Pwu+duILyxzyOKUIWZTnL4qItCMI4RjakBQmBBe75xBZ1PgIilxYGrCnHBzLDznpPO8DsbIeDgPC3wIKGzdksdWVItJ6rwob2s/zLMOdvXSKKawIi1yfeGK92/gLeBCL+1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBWji/A7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBWji/A7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6E3C433C7;
	Tue, 20 Feb 2024 21:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465211;
	bh=JHbYm7sd9Y4MFx6XCS8Y0ylte+siRi60YJS8HWBvemI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBWji/A7S95mQqOZZrDjrDZna7uz0hMoY0Pcber3XksThtbUxGW30JijXb2XtOBTl
	 A0JB931iFIRfv6FoTUR1yRuPL7OlMij2AjOS57mmCqoVGg6VzW9/g9sBZ+NKOUV1xY
	 0O2mD2ilrpp9A2EM9ZpAdNzVB68Q+F38kzdWIEm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Donald Zickus <dzickus@redhat.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [PATCH 6.7 272/309] tools/rtla: Remove unused sched_getattr() function
Date: Tue, 20 Feb 2024 21:57:11 +0100
Message-ID: <20240220205641.645477714@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

From: Daniel Bristot de Oliveira <bristot@kernel.org>

commit 084ce16df0f060efd371092a09a7ae74a536dc11 upstream.

Clang is reporting:

$ make HOSTCC=clang CC=clang LLVM_IAS=1
[...]
clang -O -g -DVERSION=\"6.8.0-rc3\" -flto=auto -fexceptions -fstack-protector-strong -fasynchronous-unwind-tables -fstack-clash-protection  -Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS $(pkg-config --cflags libtracefs)    -c -o src/utils.o src/utils.c
src/utils.c:241:19: warning: unused function 'sched_getattr' [-Wunused-function]
  241 | static inline int sched_getattr(pid_t pid, struct sched_attr *attr,
      |                   ^~~~~~~~~~~~~
1 warning generated.

Which is correct, so remove the unused function.

Link: https://lkml.kernel.org/r/eaed7ba122c4ae88ce71277c824ef41cbf789385.1707217097.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Donald Zickus <dzickus@redhat.com>
Fixes: b1696371d865 ("rtla: Helper functions for rtla")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/utils.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -238,12 +238,6 @@ static inline int sched_setattr(pid_t pi
 	return syscall(__NR_sched_setattr, pid, attr, flags);
 }
 
-static inline int sched_getattr(pid_t pid, struct sched_attr *attr,
-				unsigned int size, unsigned int flags)
-{
-	return syscall(__NR_sched_getattr, pid, attr, size, flags);
-}
-
 int __set_sched_attr(int pid, struct sched_attr *attr)
 {
 	int flags = 0;


