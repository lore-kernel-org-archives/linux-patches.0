Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625563;
	b=qc9eWRUBbl8oBxaGFC9WLOBd1Yap0QVNTqWUCmiaqTiFw5OhpYGj6Pf0qquu3jRVGKBL
	 59H7tgBTrorm0ItQqKnwzrZEowV3yl2TCOXGa4AwzdRzY6jUQ0vIo3u15Z6xvjqULRW4m
	 i2h2fI2c7U5XpMXEeDB5/Kacb9z8ybC+w3apuST+JTc6Xboz/FFu/xnp3VMXpo5QrVL0L
	 I5QZKDLGVZbFJ+8sFsKCMdQjj+BXaoEWxB/1sOFVHVZTMMUXOQSeyQctuOlvRzqKAcXAX
	 xkKiEAkQShKy6cn1RaswUqM/yhemqxFNYmODkFsAFbfzduiHQpYl/6OAk6OKMCKuwfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DhpjEzLTjaBLAldTF9y09sm1pSBb1FJz5IcRjRAERcY=;
	b=YnrVcguf5wDeAPrgJ7ACaurwjmK0KjoVfFdmUhthpUjceVnLJEroeDBqN6woO+9zd+av
	 kqpjn2WVr20nDjuo7/OMGFWLbOXmOj1DDnW9nSThgdffWXuQhmpykob0OJhTKXCSPR6j9
	 NVHw1yIws7V1TnSO8LKXt6P4X4VI2Ob/1HFNHpN+lxhaTgn0K59gBRthR2f/pt1be9A9B
	 /kUrzNZc/JI2fJLNUOH9xSeAVuWcfBVXfPuJbMt10hT62MepNYHSXaTHA2EgZZGjOn7lz
	 duaKIv1JXAjY3rwcu+tjiebUAzeRtMKvrvW4CGgtI313bsKWx0ui/I+2D8v8NEHh7xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E9XQrMkI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB8C606A31E;
	Wed, 25 Nov 2026 16:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E9XQrMkI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7071F000C6;
	Wed, 25 Nov 2026 16:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625562;
	bh=DhpjEzLTjaBLAldTF9y09sm1pSBb1FJz5IcRjRAERcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E9XQrMkIOb+Z8Tev0X9rWZCyrO/2EEELMmAhRVGCTQRiI1WHtb+JLUwfOpOvFcFkd
	 7rblCLITnudlnNUQ4tL8tCkp/3Xium0lIiT9Cde0szfuDOW1/TL+y96nPVSH6pV2XQ
	 FpPR7hiNaGO5Ndg0JD4Q9PJjVLE80QBp/LwS+ltI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.12 556/816] tracing/selftests: Fix false bashism in kprobe_non_uniq_symbol.tc
Date: Wed, 25 Nov 2026 15:35:04 +0100
Message-ID: <20261125143902.054975722@linuxfoundation.org>
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
 


