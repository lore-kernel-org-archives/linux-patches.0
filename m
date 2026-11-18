Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032431;
	b=RUZkaKUrGjs7AB7yu52kK3rjGYpHwGj+6GzPXs9/fTofqaJdpm3eFmvkt0qTkBxew8a7
	 bNcFVmAN1ccRSvuIplOOi1+v2XHt7Cl0vCcxqNXmGB2JgqU3p8Bwm81WP9otd2FIlAS1u
	 InK1FdHvb69gGtNxArYP0cSU/qM4tuYCuYf20KQcR/7DXz3BG6BkrRz+dr4QbCp2/jmsK
	 qWKiqYa0j1J1EvNJMiveOjBJDs0A8pLqZvE0qxyyKp2zWEogFITU73hmJQ5s2lQW0yv2W
	 hpYrKPicpd+EaIMf3gkj5Cb05JizZnUgDgZvrcIPl+G2LzKizaZfPevEV3P5rqXuyLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZrJjgPXE680YF0xq/o2sD3VgTy4bPcWhQdF/W+DqJKM=;
	b=cvK22Ju99czQUW0ezutg70n+IwEjGPhNtNj31YC/LtUJpzsPo/4eO9+4hRa8XpEZDmvn
	 +LLvmMM81xnxzbEkHlM9keJ31NlewD7bi//Gj+6mzXQ31LSRO2OcHv/j7LiuvlkBSSixN
	 o8eEV9P95UdXvin7VUjzuj9F9RMDEQ3IxQIjxXyvg6SS9jTCQht8IdQevhKDYR5ZDrzux
	 U9UiVKbc0VemdSgCFlK7EyiP34HErVhH1gcXWQoCwsN3QdzlyZQQFXrxCQkDBKAzd1Kgm
	 HPSqerRhMBedfgumdi8nGJM76o3xoUidADLHemdeLhI0RL5wuvw24Ps6ynwAOpGD1GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p1WnDTQw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB5C606CB21;
	Wed, 18 Nov 2026 20:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p1WnDTQw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015241F000C4;
	Wed, 18 Nov 2026 20:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032431;
	bh=ZrJjgPXE680YF0xq/o2sD3VgTy4bPcWhQdF/W+DqJKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p1WnDTQwQJ7TkldyOFSXoBczzvXR3nRzUQ1GG9jfo3Dx2knlJVw1SYmL5jzFoad/t
	 MEW2tRxSSAkKDQzrY0I++aLt2MzvT2Xf+38jxiqG7u2ukmPWVelZZYB7nNJEQ9n4ln
	 7lHhnI2t8yTYQjMYErBvHNOykh1H89sSW29MXIdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1373/1756] bpf: Dont take an extension for a writable raw tracepoint program
Date: Wed, 18 Nov 2026 15:58:20 +0100
Message-ID: <20261118150103.884067714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 71d6f14cc1cf8..e6e31bddb56a6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -22630,6 +22630,15 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
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



