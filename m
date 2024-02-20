Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530601509BC;
	Tue, 20 Feb 2024 21:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464018; cv=none; b=Jewt4qm9qm1X8BM4kx/dscunYbZQjsTQqPj1z8VvQ9NDFbzYOb4Rdh4kYI9sTXkW3YAMXNMUBcgpxvkOG9mkTHytUJkzMudaiemud6YMSTKgFHbk2vw2mvN2ZXcbhDv2VUMNgOGJd2rllol+pfaVibNYFB+chO7SQzSN9j5NlvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464018; c=relaxed/simple;
	bh=03j0+RAInSBSDkdErSkaEXjv1UY0KTJgpVs94COq1Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiAX/FfHjcFy4XAcNJqKgFDMWOaknHGrFT87eL37rgg/xzw9MD8UE3QmRXltvlEA7dMkd9h9b6S+eGR3l3IiKASBanfe/WDSkCcPPCFdkrBYf0dnT4zrnvo6VIcMDqok6Con9uc3rp2kLs6eREUvyMuZ4dJV+t5ntOu1cRU0L3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYKVIX+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYKVIX+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAF1C433C7;
	Tue, 20 Feb 2024 21:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464017;
	bh=03j0+RAInSBSDkdErSkaEXjv1UY0KTJgpVs94COq1Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYKVIX+TIlhQvv4GnF6GJLlb57yMOhDQsFCZMp/BNLmqLo2MWMt6EtfmrLRBVbP7O
	 DLV1Thj0XxjQuOiZ6Xo09vRsWCS6LzvU0mhp5tra81tIj1nv8/vQBgjwK13eCtsJi0
	 IFI+qPTZhyKJvAb1VfCQ8iaC6bPm872gqLCqFKkk=
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
Subject: [PATCH 6.6 226/331] tools/rtla: Remove unused sched_getattr() function
Date: Tue, 20 Feb 2024 21:55:42 +0100
Message-ID: <20240220205644.860282898@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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


