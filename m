Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625559;
	b=h4+GzZh44bwdNimCF9Mis/CCUzShSB1NRbFiWGnSjxeI9Vu4E1wSaxnSlm+7oNe8rO/k
	 fT0hFNyk/ORK737GngyVXTnBsZUzF5jRHBmnkmLxGJR5raIU1mk7xRMPX/pXw3tkdX/hj
	 7pdMSIVSJ3i03o1/dYB9Jm+bLZVWbY9dpU9pLScXRMeIr5UzUC52RD1yQ6KHYKPnPYW0z
	 AQ06Q3BgFjqlg6hUagd7R4LTWezsq7tvVyFWjjBsGRI019zPH1jTLIrc6QUc/p5s04zKc
	 pnRHou8UHu10Y4vSiV91GtB7wwI/NRu+SPolyNeXKHHnpdePD8UOrd3eHgwy5w2BPhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dIuiRY3aXv2faCd9nQnL2bYgjmgYT7wVv63jCDfAXPQ=;
	b=ysXEjL87IYiJzcN5KYUAZDaykI0oQC1IoXeB76ws7Pi9NnpYIpj/UY6D/6IOLMyOBhJN
	 QHiqMkGeQCYfO1uBdpOgUOBxPDrbj6WbGddTgEyz9yOYl2ZtU3lDFxKRhbnd82CTDdibI
	 UMtgd7aUgJu0HmaaAW/HvanCWM3/xl81sBGOUSWJ22+iSR4D7HWIw0xIdKvaTAOdkeoXO
	 +hduQhc90rnU4DRaRVj4ZIfCgphg6Cxum2FwP+jzLgg0Ywwf9RkXEisK2lnH0JBsm6Ca+
	 iCtgY/PYTd+3Evxln4JpUQsHpVWZoKfJA6PdluhkBLFG3lZBcaciWGMsBH0ZcbHh5Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IeEKSD76;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99CC606A323;
	Wed, 25 Nov 2026 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IeEKSD76
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE45C1F000C4;
	Wed, 25 Nov 2026 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625559;
	bh=dIuiRY3aXv2faCd9nQnL2bYgjmgYT7wVv63jCDfAXPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IeEKSD76G+wdTbzos8kWBknQunfl5JwBgT/agu2/dmaYv9RhJk80N3p1tQdJ/PZ1u
	 KVu8Vo23XCvGJCrNLspf2R/h4Bu+C9JNd56r+S/gZz9/sNn6OJGSW7qnkueuTs/+W6
	 kxJYQ4rNecpLndJA1SFd4dmwbQGzeLfIHKCDCbAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaewon Jung <jaewon8868@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.12 555/816] selftests/ftrace: Add missing spaces after ! in probe syntax tests
Date: Wed, 25 Nov 2026 15:35:03 +0100
Message-ID: <20261125143902.031057575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaewon Jung <jaewon8868@gmail.com>

commit 36990c8fda77d918b1e52d5d6df3a144b552d86e upstream.

Add the missing space between ! and grep. Otherwise, the shell tries
to run !grep and reports "!grep: not found". This always skips the
conditional checks without checking for kernel return probe argument
support.

Link: https://lore.kernel.org/r/20261025075044.1750113-1-jaewon8868@gmail.com
Fixes: 25f00e40ce79 ("tracing/probes: Support $argN in return probe (kprobe and fprobe)")
Cc: stable@vger.kernel.org
Signed-off-by: Jaewon Jung <jaewon8868@gmail.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc |    4 ++--
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc
@@ -34,7 +34,7 @@ check_error 'f vfs_read ^$stack10000'	#
 
 check_error 'f vfs_read ^$arg10000'	# BAD_ARG_NUM
 
-if !grep -q 'kernel return probes support:' README; then
+if ! grep -q 'kernel return probes support:' README; then
 check_error 'f vfs_read $retval ^$arg1' # BAD_VAR
 fi
 check_error 'f vfs_read ^$none_var'	# BAD_VAR
@@ -101,7 +101,7 @@ if grep -q "<argname>" README; then
 check_error 'f vfs_read args=^$arg*'		# BAD_VAR_ARGS
 check_error 'f vfs_read +0(^$arg*)'		# BAD_VAR_ARGS
 check_error 'f vfs_read $arg* ^$arg*'		# DOUBLE_ARGS
-if !grep -q 'kernel return probes support:' README; then
+if ! grep -q 'kernel return probes support:' README; then
 check_error 'f vfs_read%return ^$arg*'		# NOFENTRY_ARGS
 fi
 check_error 'f vfs_read ^hoge'			# NO_BTFARG
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
@@ -108,7 +108,7 @@ if grep -q "<argname>" README; then
 check_error 'p vfs_read args=^$arg*'		# BAD_VAR_ARGS
 check_error 'p vfs_read +0(^$arg*)'		# BAD_VAR_ARGS
 check_error 'p vfs_read $arg* ^$arg*'		# DOUBLE_ARGS
-if !grep -q 'kernel return probes support:' README; then
+if ! grep -q 'kernel return probes support:' README; then
 check_error 'r vfs_read ^$arg*'			# NOFENTRY_ARGS
 fi
 check_error 'p vfs_read+20 ^$arg*'		# NOFENTRY_ARGS


