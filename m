Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619359;
	b=VuT55G4eg8+WJ5d4vNobG3j9V+aBlZjCDXWOADbzw1OHF9QS8pS10HiYmzNWW2gQwoBe
	 LtTqBNPjeEe7uKE4+7ko/7RMuIb2fPkaIkD25jcxCyEdovYzypPVntn0QjNDia/NdWK9M
	 SCqaTZrVceqg/u32zWOZJX5ycAK524KS9n1uOCyMJ+GSFT+FX7jKgoZVfXohnQD1IqRKh
	 cEiU8EeAVPGps3Orn1gGdyptnDFuPKyc3tqW0sYY8Frp5PP0BWhs6RJ9MhCbKaTztfWxi
	 wJlWBcWWH/3tMFe1WPAVpKc3m//8NFEsCjCdhRXWbW55CtErAzkhfw90mbWm8RvuWnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8j0zix3elYeiCygWAlNrYVtgP7G4gy+1B7R34Y8EDN4=;
	b=QMg6ETjzRWCjnJ5ht7hiTpkpk0ctg9SKXOagSIi/fn3z8z2sqXYezsJCj+Km8YX9rR8h
	 loYqfFaYbXLJnDdsLyRAdiariPXJz+adc9WoPOUG4G523mvNQe5yqrlaj/SYs10sUskkz
	 kzMv3VVg3299FbLJsdE83f/DYJoldNmIQxtILVBPCxdAhC8zr2Zec0mPcEDgzilN9IXSo
	 RQ2c/vXmH5B/2o8xJtz7B/RXGLvIbDQ3Iqepv+cLWNJiNqNQD2h2a3lkQ4wtIlv1EjiZB
	 E114BLLYlHhXXjFYHI3qlfNaUgi36cqtLQWmDlIl11bBG6kdPP8PTJcBvfS05yLiuwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pH9/35Ig";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F92606A327;
	Wed, 25 Nov 2026 15:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pH9/35Ig
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116131F000C4;
	Wed, 25 Nov 2026 15:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619358;
	bh=8j0zix3elYeiCygWAlNrYVtgP7G4gy+1B7R34Y8EDN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pH9/35IggmsD7d9GNycoCDsPhDusciRBB90YoLrYDynRWG4HGFYW+TY+h9tbGc8Nv
	 B5Dgkr3KxwQYB0mEbiVmJeZB3D/7lsuLeftPsTx31iboq72rZJYQd6lVbGrIJFbh8H
	 9sszFG/McO44VVYSwJS9NePIzCI/uvo9uNSgURsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaewon Jung <jaewon8868@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 7.3 0571/1005] selftests/ftrace: Add missing spaces after ! in probe syntax tests
Date: Wed, 25 Nov 2026 15:31:49 +0100
Message-ID: <20261125143835.125918513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -33,7 +33,7 @@ check_error 'f vfs_read ^$stack10000'	#
 
 check_error 'f vfs_read ^$arg10000'	# BAD_ARG_NUM
 
-if !grep -q 'kernel return probes support:' README; then
+if ! grep -q 'kernel return probes support:' README; then
 check_error 'f vfs_read $retval ^$arg1' # BAD_VAR
 fi
 check_error 'f vfs_read ^$none_var'	# BAD_VAR
@@ -100,7 +100,7 @@ if grep -q "<argname>" README; then
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


