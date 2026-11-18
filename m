Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021106;
	b=pOb+7bNSU2YzzGUOKJiOD8q3F6fQHUDFcgTAgyvbBb1BkXbzACM1hJiWwJGWO48bbCGZ
	 XgtGg+KQ8dDDQzlAdvKZVdxgNCCx1qqaXm0kESRLWOPKO0Qn3tj6dr+ccuIn08zNlN4Sz
	 HJQRyE+P175Y2Geozq2I8YHeai9f4TcRoKgN7qNALI1Z+YzX27LsjcltEluOFXYpbybwk
	 8RG0V0y0ZgPLGWpVEXb/gJTHF7mogS5vO7aDLCKuV4e9seJnP/QgiE2RcSn7+WlhfipyS
	 m9eOC6kYEP/yZPO2KFhMxO2TRZG3NTG96n9veEpEPcqdg4pk+w3T8ZXHmxGLyWOlYmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EwUz4ACb6pkfZQYWUpgpxZwlQBZIHfB7CoNCJPMvMaE=;
	b=2M/rJ/PlRDfR1g4elHVCHDK3FWwMnJOitniOCPnAFS66fDjPWAZh20K09xXDcew+IC5s
	 gFzPvKl5sDnqeAS3b5pAcnlFtfNaYaWTwzmUrjB7Fcma+jd2vkgzWmECc5F8nnm39VcK7
	 /xny821KHajbVt7ju4oDQvjDvCMRBvSKRUpqfV+MwoTusQ3KWDzHNYRvTfOTvnABzuG2f
	 fytdN3u7w5pNlWDurJkvsN19vXkbu3+Xrrfi61D5XizGovLC37Y2av7LKB0501lN64i6N
	 aGTU/hSbUVGzcYFVIjrcaMvKOQ0YViQDwgffcS86NRDzbclrMYukxK2Oya8CRARxP/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0JijM/0N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B05606A31C;
	Wed, 18 Nov 2026 16:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0JijM/0N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2E51F000C7;
	Wed, 18 Nov 2026 16:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021106;
	bh=EwUz4ACb6pkfZQYWUpgpxZwlQBZIHfB7CoNCJPMvMaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0JijM/0Nk9mMthUC16aDDIq/vNGZf9+q4HtV1kzzoj+gb/pK3Yyqpqzv5eb6nkx/T
	 DuHkj5NcdywWr2EMtSF9mlyjSkQvDzlxgDJ1ezzOB+J5gbQu1MgNikE4E1+JvjvEv3
	 WX7g26zxzdqdWZKD4QM0YjmgD1Qe9b/lx8bGpl74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KaFai Wan <kafai.wan@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2148/2651] selftests/bpf: Fix stack arg pruning test JOIN log expectation
Date: Wed, 18 Nov 2026 15:56:28 +0100
Message-ID: <20261118150403.172028405@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: KaFai Wan <kafai.wan@linux.dev>

[ Upstream commit 8342d47ad791d70a42ab9cf262bd477fb41fdff2 ]

Commit f414d20879ae ("bpf: Save DFS postorder numbers for program
instructions") changed bpf_compute_postorder() to use a real DFS, which
changes the postorder of this test's instructions and thus the insn edge
the arg track join at insn 10 is reported on:

  arg JOIN insn 8 -> 10 r1: _ + fp0-8 => fp0-8|fp0+0
  arg JOIN insn 8 -> 10 sa0: _ + fp0-8 => fp0-8|fp0+0

Update the r1 and sa0 expectations to the new output.

Fixes: f414d20879ae ("bpf: Save DFS postorder numbers for program instructions")
Signed-off-by: KaFai Wan <kafai.wan@linux.dev>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261018005348.2195130-4-kafai.wan@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/verifier_stack_arg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/verifier_stack_arg.c b/tools/testing/selftests/bpf/progs/verifier_stack_arg.c
index 7e0ce5db28a0d..14152dae2a8f0 100644
--- a/tools/testing/selftests/bpf/progs/verifier_stack_arg.c
+++ b/tools/testing/selftests/bpf/progs/verifier_stack_arg.c
@@ -116,8 +116,8 @@ SEC("tc")
 __description("stack_arg: pruning with different stack arg types")
 __failure __log_level(2)
 __flag(BPF_F_TEST_STATE_FREQ)
-__msg("arg JOIN insn 9 -> 10 r1: fp0-8 + _ => fp0-8|fp0+0")
-__msg("arg JOIN insn 9 -> 10 sa0: fp0-8 + _ => fp0-8|fp0+0")
+__msg("arg JOIN insn 8 -> 10 r1: _ + fp0-8 => fp0-8|fp0+0")
+__msg("arg JOIN insn 8 -> 10 sa0: _ + fp0-8 => fp0-8|fp0+0")
 __msg("R{{[0-9]}} invalid mem access 'scalar'")
 __naked void stack_arg_pruning_type_mismatch(void)
 {
-- 
2.53.0



