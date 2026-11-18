Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027279;
	b=Yd2PDT3udonJoqDw8n4HemkB/OicMjaKHEKETJnwQfBXt3Q42CahkV0nb5YnCgU9vhVb
	 3GvDqPIMnvqQ+COkfljMMX5wBprl4Y7fiDmUnGL4EHFnPpHZNTKsF+re7HCRXUwBZuVIW
	 uElavzLvAXCoEjNxU645bDRaiRjtGPDhF4oUpKmD9cUyNSPWeRsqk4poOhD0eIsPKIgDP
	 GpQ4QM/lmP1+Sb7YqZmKM+CjO24PYXA1Y4/lblXyHuE7iyx09FAm6Bry0xQcwTv7e3OB2
	 H5gwtx8tOobjiHdIoqpte2dY+RMBQsrY744T5z8zIKPd0RDn5s3ZHn8WhnwGayRrX6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sFEshw1Kke5T7MjjwI6KaRcOVxBI50YaRRUrBxnXPBE=;
	b=FLETYdwBb3ujZv1DzlubbZrCkJOVWon6mCwJ3gPuYIUWTahOcJI+yHhYkWv+PLGiFwDe
	 hSjVquIWkQ0+Y2EnP3chA55AkL3/qDScbLDf9qBbHrviO9dyHPv6M0pf09ag/hfSFc28Q
	 JKHCJjO8iel2Be2X+Lh+vY0TLZ7GjGlSS6TgaiEZPpHk9SiSJun69YzUNSr+Z4+vBmhFW
	 2U3hH6Bf+nproTgWRSB5Z9lnyi4DDGrDisTC6h/hRZZJgFg9te4uWclqZmyrQcF04vOky
	 Y18huuoO6QfhFqBkOhi1siZDeyE4Y0vCP8rdHO65nhXrI6OV1ilzLDg+bbBNWiM3Q8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F6GRcGty;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22426606A31C;
	Wed, 18 Nov 2026 18:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F6GRcGty
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787401F000C5;
	Wed, 18 Nov 2026 18:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027279;
	bh=sFEshw1Kke5T7MjjwI6KaRcOVxBI50YaRRUrBxnXPBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6GRcGtyevCrq3sFb8UTTR6sA2TaUJP9YnvVuZkzQfJtCjz45vwznjKeGNr5ALGS+
	 grJuPalXw/ckdYwW/49rv+/N8a99n5iCI2xDLoMWsZb4iP9/j78wuYMwUbUsd9vR1I
	 tv9HR+dQmoQiOh4pweopjjgvkGEQLFfqnJ4vBYMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1731/2151] bpf: Dont take an extension for a writable raw tracepoint program
Date: Wed, 18 Nov 2026 15:57:46 +0100
Message-ID: <20261118150224.922288671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 7fe348f18b37b3f4c8beb981ef3f84564047380a ]

bpf_probe_register() compares max_tp_access of the program that is
attached with the size of the buffer that the tracepoint lets programs
write to.  An extension of that program, or of one of its global
functions, gets the same context and the same pointer to the buffer.  What
it accesses is noted in its own max_tp_access, which nobody looks at.  So
it reads and writes behind the buffer, of a tracepoint that may have none:

  BUG: KASAN: stack-out-of-bounds in bpf_prog_5843f2b820eb4929_tr26_ext_far+0xf4/0x10c
  Write of size 4 at addr ffffc90000d8f894 by task wext/103

Refuse such extensions.

Fixes: be8704ff07d2 ("bpf: Introduce dynamic program extensions")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-29-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f747197b36a68..139671b393a05 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -24297,6 +24297,15 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 					"Extension programs should be JITed\n");
 				return -EINVAL;
 			}
+			/*
+			 * How much of the buffer of the tracepoint is used
+			 * is checked for the program that is attached to it.
+			 */
+			if (tgt_prog->type == BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE) {
+				bpf_log(log,
+					"Cannot extend a writable raw tracepoint program\n");
+				return -EINVAL;
+			}
 			tgt_changes_pkt_data = aux->func
 					       ? aux->func[subprog]->aux->changes_pkt_data
 					       : aux->changes_pkt_data;
-- 
2.53.0



