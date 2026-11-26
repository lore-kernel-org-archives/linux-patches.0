Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704632;
	b=SncJPlDeHlEo/tjZwxkTssA0E2R4D1yO9mlAb266KBoOHCnoFQO4rUDY5VvNu4GCo2lI
	 3sng+YiVgfzV34OmOidspbCMK/sryd06VNsMpPFUtOWYzvnse1/lq40Zgw8caYmhjRyIc
	 JpvB++Da7ZgovMSIaEAH9kO/vmK+zvaQxk30IpzQeiUIF8qgR93uli6x+x+GGbpzP/rm9
	 ajECbq2Mj8wJezf/ZEehw0C44PybYrDmgWfnTCusrJGbTKELa7gzQJ2GVYCx1Js4jZ/Rq
	 dgJLFX/vHdZtXwsY5h9YYlHaosxXMYuoR87f0dFnmgput7IchBiV6u8NbKzMvJNB+dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8y08Q1ooyG0Rhzeo7Hnmnk6kvZFi9VEzybdQyM7w9Sw=;
	b=D4sezJhDvwM0SQEQj/dHRsgPi+n8wyeu4x8efyOdcjNBNKR/KB0AEJJtoVcUrYuP4tk7
	 fc3lxsB1KuWcb8+D0Ubus3cVdOTCfyyIbgl6za+k2xqMoMA28fhGr5LsWOm+hhZMqUVea
	 94bw4VIQriX4W6kIc6CAuHJu9PsMY1SMT/8ceXxzdrGQQqpn9lHn57l9VpchGlN34xSiE
	 Df1FzYFXiLttTlZwRqlfljmu5xy3vdNrggITiFk8ZrrwPanYsdfq+5bGpzn5yLw65Jzux
	 tRoClIjlCfzNPG+ydk63hbPUlXenqCF7Wq7LNlnCiWdA2eClMaT4lUxZJDD9pxmR3gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTLLJqEw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B25606A680;
	Thu, 26 Nov 2026 14:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTLLJqEw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC541F000C0;
	Thu, 26 Nov 2026 14:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704631;
	bh=8y08Q1ooyG0Rhzeo7Hnmnk6kvZFi9VEzybdQyM7w9Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTLLJqEwCaAEkUc0bKy77U/V09bzPN4yF2bn2Z2yo5y5k4PnUBVMmfIA8oFPY3SfC
	 LuLPfsdDYSJKQSgjeeRPUF/o/4SVFh9wezZKEBOZVgNLHAbKw+Fi7gpAv6DvErd8cm
	 OVKU7zPvAqQhOOGDnMf8eNOKbY1pbHPeW8ula7X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.10 145/265] tracing/selftests: Fix false bashism in kprobe_non_uniq_symbol.tc
Date: Thu, 26 Nov 2026 15:37:55 +0100
Message-ID: <20261126143615.189688840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


