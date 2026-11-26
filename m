Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705442;
	b=t8pqeADDzHUAUuYdv5loKMtBdo65aq6GMp1MorzYlAPYmYmZhJAO7KdXKw3eObA4VTxE
	 jhK0WVVZImMZZiydT5DMVbgIaulHESkWEN/9P5+WM5AJBjz4e5T3ixCFkm/gJFJCGwe+T
	 8tr3Lud0Kzxp1XMXQYhBKbRwYRsPx07hTnIU3xAs6Wm3Qc2gt0QdCZOzars2dmqRdyFA8
	 lXcltzePEs3ItYy1Er7zfyJnzh70Y/xRy5ZOQvJu0C9nQSGTjabCW8MqW013HWuZLaDb9
	 dEIl6bSpJeSInFzKGUWGYHuSnL8VPoJzr8pP5qaeNf72bslKdIRJHldtChmh8MllBtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1rfCN+NHQEnoHRqUii0RSzzEGzzlGn0Obq5z9tzf/aM=;
	b=z9f7HI03xL2DtvPD39FMSlZRdmIggC2qzEXviShRZF3wVlWACB01effDhZcf5N33wAsY
	 WIWLppamz5x0SUQ5GnnDLeni/vFrrv82K6mTomvTxGDX2ic/yPj4rN2bO5JE8cj5Ix/40
	 mIpPnEg17Dp1mqYsQ4e89ruC6Z0inh66G5w+WhOG3/Ml0KcDmnaQ1FC/hjVdAGS/T+zRa
	 VGQJCwRwE5l+oLh8LlyLdLyjxb1vdVYdVhN7qwwwPb2IrZbqt8shJmQHDUYHA+do1ph2z
	 q4fmSxam44MKwczDpjsqWgv+AUly8SBIv46I53i8wq3zXEUdnrNenYZvoF3hVHjb1ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhycOBQb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB192606A321;
	Thu, 26 Nov 2026 15:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhycOBQb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5441F000D0;
	Thu, 26 Nov 2026 15:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705442;
	bh=1rfCN+NHQEnoHRqUii0RSzzEGzzlGn0Obq5z9tzf/aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhycOBQbA0nllRT5HXnpEB49iK05+BfpVk4HWQ4Vjp3mgQcsDS74DmgF9lNtUVBZK
	 fZt3BAmXxYzUMep7XmAry39Dczi3ZHC2hwHX5r60IpInxoN96Wfail9SI2lE/iJzdj
	 J5fRu55oQvFzyTq9YBGUuChD4it4gUWhLhs68TGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.15 173/319] tracing/selftests: Fix false bashism in kprobe_non_uniq_symbol.tc
Date: Thu, 26 Nov 2026 15:39:01 +0100
Message-ID: <20261126144010.651365746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 88d5f8cb8a6276194ac8c1de44f3ed77d7e938ce upstream.

The checkbashism is giving a false positive to the kprobe test of:

  ($"foo" should be eval_gettext "foo"):
  if [ "$(grep -c -E "[[:alnum:]]+ t ${SYMBOL}$" /proc/kallsyms)" -le '1' ]; then

This is because it sees the $" at the end of the grep as a bash symbol.
Instead, escape the '$' with a backslash as it is within quotes and that
'$' is for grep to process an end of line character and not a bash
variable.

Link: https://lore.kernel.org/r/20261029211218.3749963a@fedora
Cc: stable@vger.kernel.org
Fixes: d22c3e0088e85 ("selftests/ftrace: Fix unique symbol check in kprobe_non_uniq_symbol.tc")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc
@@ -6,7 +6,7 @@
 SYMBOL='name_show'
 
 # We skip this test on kernel where SYMBOL is unique or does not exist.
-if [ "$(grep -c -E "[[:alnum:]]+ t ${SYMBOL}$" /proc/kallsyms)" -le '1' ]; then
+if [ "$(grep -c -E "[[:alnum:]]+ t ${SYMBOL}\$" /proc/kallsyms)" -le '1' ]; then
 	exit_unsupported
 fi
 


