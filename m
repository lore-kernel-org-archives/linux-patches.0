Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619362;
	b=CpBVaYhRiwutyBZu+G6eSNsSDQYso33blmPAEiaPjtIhHFKbeAXIsDAyXZ7+VMBroyft
	 wq6vgf3f4UKz/BttFLC4PkfAIN1tz5fuq8c+p12zfsjBvc4uGLE6UkLIikkaNqpr08Da7
	 iWJqdw75rrdRaQM9Z6UrOAxNAVjepmgjq7q0uFUFG8MjLBcSqQbzVoTUhBmTh+e7ILd2P
	 og4UEsd/CCw/XE1t15mj22sOhBZPGDcfod4c676mQ2ovM7/Nzy81sFBSPZ/oCSbRhz2+p
	 ngCYO5Sewt1rfnQ9D7LmcAh3UuRf9nbvDfd2t1iD37uQFhxG+4zcccmUysv/6+BJXug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KZmRzM/K7usL8Cyo+7D5WooPJb3Cl35/rMOFfh3xLgw=;
	b=sVkXWBCy0evgpXaqJMUPIDREJX+KWXEIlXDsSB2kXPyfSZOoqzdSrWyRGSvNSJqrACSk
	 /MzyqAPZioWEOGl6QEhHlWpH9PjprBpd+WiMbB4S5XNZYHxKKYv60EP+IKXiDa9ADATMk
	 APmWgqj95fQz7yBmbFS73RrYce441kSw+Jg2RFBBUgoTXBo8cE5dVOElTTDn5GufsUElZ
	 vrtZlamrMugLOSCQUCquN7xGYGo5j9mIpcX/QCh0168W2KqEAHchgAjpaZQVsgS+vpDkt
	 htUI4JB93rCsQ2BtnnLkEHA/ON/m5fnyUupeJpWc8BoAO81YO2x7QBbuCkL32Pr230A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZDlellVE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE3E606A326;
	Wed, 25 Nov 2026 15:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZDlellVE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824091F000D1;
	Wed, 25 Nov 2026 15:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619362;
	bh=KZmRzM/K7usL8Cyo+7D5WooPJb3Cl35/rMOFfh3xLgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZDlellVERr/fBbo6S+lh1yYdpQxTVxNeAwEN9/v/N+u5TJFE4UvdlOs3E+3DsCXm0
	 VWN8Nz8ffTV72wFOLHLvyocXDP0LIxBDP3THy8/rMEdEQdpeyKEmuZychfXDR/qYgc
	 nLu1xrqI9NbPtF3lEdmxVky9j8VqOUL65OAnrffA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 7.3 0572/1005] tracing/selftests: Fix false bashism in kprobe_non_uniq_symbol.tc
Date: Wed, 25 Nov 2026 15:31:50 +0100
Message-ID: <20261125143835.148806124@linuxfoundation.org>
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
 


