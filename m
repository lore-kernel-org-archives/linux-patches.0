Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622806;
	b=IHZgtaMbQ2x+ktzHno6RJo3VSnGESNfKUUMCtjq8xCsu3Rjn934ggaSDAzhsTxID9mAV
	 WpJLLTfu6cgM7i9r5D5UEOofqH0RT074g2lZN+RdZHZaIrl1hsw0R+W17KgnS8ZDVy/HK
	 lV+jN3TdtdW+4CSP8Ut9W+0IW1ea14rIJwYAgd5QvnC5NLdgTf1sfOIuJqQH5aGYeOzKx
	 X9jYdRqaj3F8QhD3CG56OvCrqhJEpOlMEuIgbdlVkL3gaI3MQMK/r64UXUHU7grN4VzWc
	 32kVDnDukgV2A9YalMV5KtEwfo8ADUDnrLnamjZLgBOtjKaIHPckd9rl8hzNnKOcE/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tG1FIwvddJZNH0DjxFIOy8F56bvoqTaQ12GeJrlGXzQ=;
	b=F5xbj67vPlj1WARU9gQg1VhDNgNahktYwhBzI7tG1kg1ocwelImwb0zWEZT2Opu1YUzn
	 YH5TLCF9Q+MgfEi43CKWSlx2/w76L/5oIAUTsZ74GjPabRnwY8rjyrNjW5AjKsmRoz7CW
	 75x7XJWYgWgcsi/tIZvWR61H1IR0hAWfxhYBN1ygooEBHdODMbJWiqnxib2knMaghYrH7
	 q5szEmopBKJsRYBZsGGc8FRNcwgDGrZQtwtZr6anjDDBOX9QBoU+E9AKCxOA7toGMaqTY
	 J/4CzJZOaoqvmCP7kkTHjh40s5ZkPAZzy0FWIjqkgoVmq52M46e8AWSLLer+7tXf/vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="C6uG/n61";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60D0606A33C;
	Wed, 25 Nov 2026 16:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C6uG/n61
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129B11F000C0;
	Wed, 25 Nov 2026 16:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622806;
	bh=tG1FIwvddJZNH0DjxFIOy8F56bvoqTaQ12GeJrlGXzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6uG/n61QIqr2WemoyHLndc0HI82dJJKrUFoPK73/S6J3nzT4DV6pyg4KtD4IVgRI
	 RdYEPdvK1worBWjTjCDx+IOY+EsHWmH4VQgvzeQoj1tp9Ig1Ceaf9Tc840wFmPdaeq
	 7pWyalBT2H+wsi/acZGO7L9OLUXZBFxaSUPW3GRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.18 656/990] tracing/selftests: Fix false bashism in kprobe_non_uniq_symbol.tc
Date: Wed, 25 Nov 2026 15:33:43 +0100
Message-ID: <20261125143837.456303060@linuxfoundation.org>
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
 


