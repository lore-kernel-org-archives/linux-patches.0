Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622803;
	b=SdGuYCCRUXLoKOsjZSVgph7opiXe9cXQcYamUV1dQFrFLKpOvcuu+bpiAJ0gWf3elEcz
	 1U1Qe4fSxYEWfgFDP049zdNcPop0svqaJclVlVQ34HqKXVB/YE1Lfkbi4H+D+gm/3UE93
	 rmnj+OIS8eflb9uQ0XRHxlN9yLo8TTld48t9+OdYW4uFQivNC7H1G7QUlFoGg93L2vsA0
	 XkVLwBw8qoaUxT8+qpvxLOmKN9L8bVvK2BHkRwJFV2VAvlpNBQQk9zm8X62lLkhR8RG6M
	 6Bh3WFlMo5WBhNG3sn1hwPX6rsQTtD4OcrZNSIfylG4Wr6zux6pTkRSK/MbDvV7ZYWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RJVLNO7Gyo5s1n6xly/VaY4y4Z49FHiZWiNOGGaml5g=;
	b=OTX6JcDjParJJ40MfyfrDJ+mUNLxSvsLHUNbfne1uUI/gQnz+w+Z0vy9L6ZSNSatvvPK
	 I7+xYpr/+Y8sgRQqRrQJfv4WC6t0v3Euk05S13jSmGkUp6VU3LHjUb/dMOM9NA62vxVJ4
	 7m8Mt2qLhEWAGOh+KTtcJ6TIGzUqx31aA62jUKYDCEB+VsS935FN5WFtPaQFBqmRCgmX0
	 NeKGnhg1sS0ADGp7w1kg53SjlQlvgLqukhzubptDZEsBKqeVFk7dverDilXPPRuLaaitI
	 A6tRVozeVQ4io5kmMuR+dn8thKxOcmX6xdx3GGodiy+AcB9IyZsMZLWj+Hw/Goe78Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rP9KZ4Et;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC050606A33C;
	Wed, 25 Nov 2026 16:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rP9KZ4Et
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3629C1F000C0;
	Wed, 25 Nov 2026 16:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622803;
	bh=RJVLNO7Gyo5s1n6xly/VaY4y4Z49FHiZWiNOGGaml5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rP9KZ4Eta8e0uP4oifV7fpBtc6w5EiZwLTVetmHp15e32CS1T55SRtOpdlCtSk5v9
	 r48hNIfTqbsq6yD3Nh+F31N3UslLH4XvK7sETNh+ilhqZRvr3Qdm3IAuD+jjRcszBZ
	 +zM2z996ezisvFzcbboqRcGp5K3CXY4LCYt0S0aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaewon Jung <jaewon8868@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.18 655/990] selftests/ftrace: Add missing spaces after ! in probe syntax tests
Date: Wed, 25 Nov 2026 15:33:42 +0100
Message-ID: <20261125143837.433466216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


