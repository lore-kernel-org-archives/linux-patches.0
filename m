Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021674;
	b=CMQ118kS6fD3RWW8YFUCqdqjY5f2DJCPpPOmQt4fbR65iwGOsP6SGNoHVOruDjgaoWGP
	 +Oo7MzTg8YdIWnv7loaNACulOTHx5ViV3i6kIjOwWYLBZjTpg5AErotJXmDT63USNUZBv
	 wGAoVpiOnmhDLrGStyDkUDEKe2iswP/5lAwUQs/JECJchEl+8OUoNM973c/mwoHCW++vs
	 zcQLSiN2IkUcY6QCnEpSmzpdv5/P14D7qGBl2g3HFDXhdEBTqe2WDi9CiFkWaEh2UiOOT
	 2n9h74b51pOeOJWEKExu6fzFA6hcxW37UnXa9zO9qNis3936Wu3iW3xrV4FMA9EubAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h0gx1ChTGjMBd/zm7ZQWsMHyuq1YGJ1yF1sDHPi++Js=;
	b=EYXPdje8ZxctUKc89iqgN7Et4VBZTrZXTxkgPec4TtJNSPH0ChP4gumfbqIc67U22U1I
	 fi7SmlUuzrciunEnV2NZiMetQ/0F5hwyKGa0XHYM+3MD6gF1BydFQjkgtYsPFG5ouOXge
	 wbE2AAzQ6YfqjNzpmmWDVlpteRnowSs8F6LGQc7VDxbghSus8kiBclpE0oFPDHcxVw0Hv
	 d7lfv5JcYpHZ9zF1VxrJtbzDJlsIzqlbDeyl+X5iL+KV4vD2EBmezaG8ZJEnGlEythaEM
	 01XR2MzCFWlmNVa8bbJed9WCMl4Bt9DAldL1884ckGUTieJtzPf4r4ShbvHEddvZlNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGVeemqi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D78606A320;
	Wed, 18 Nov 2026 17:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGVeemqi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EA61F000C4;
	Wed, 18 Nov 2026 17:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021673;
	bh=h0gx1ChTGjMBd/zm7ZQWsMHyuq1YGJ1yF1sDHPi++Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGVeemqi9lwVhO2nZ1CyN89KIZocE14Z21Fr2q8seH+nKGfp3F4om6qhC+JAxJ4gz
	 3iqlGZa1hKo6R6PuVv99vGdHFF7hiM0PZXYy4j1BJSd7en/5qWGVzsDD2+x1mm9fA1
	 g6jabJ4WvBUHvHRjALbYSbrAwTpTcrpoRsgwNAYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2390/2651] selftests/bpf: Wait for the struct_ops map to be freed in assoc_in_timer
Date: Wed, 18 Nov 2026 16:00:30 +0100
Message-ID: <20261118150411.448320829@linuxfoundation.org>
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

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit ac3df711a428a9ff4277100ee26c6765e8f80a3b ]

st_ops_assoc_in_timer_no_uref runs .test_1, which starts a timer to
call it again 500ms later, drops every reference to the struct_ops map,
and expects the timer callback to find no struct_ops associated with
its program anymore.

The association goes away only when the last reference to the map is
dropped. syscall_prog holds one through its own association and drops
it only when it is freed, in a work item after an RCU tasks trace grace
period. With other tests running in parallel, that can take longer than
500ms, and the callback still reaches the struct_ops and gets MAP_MAGIC
instead of -1.

Have the timer callback restart the timer until the map is gone, as it
does for st_ops_assoc_in_timer_free. Calling the struct_ops through the
association until then is safe, as the map is freed only after a grace
period that follows clearing the association.

st_ops_assoc_in_timer_no_uref run 100 times with test_progs -j32 running
in the background, on a KASAN kernel with the fix, x86_64 VM with 32
vCPUs, before and after this patch:

              before                       after
  outcome     2 of 100 failed (MAP_MAGIC)  0 of 100 failed (MAP_MAGIC)

Fixes: 0e841d19263a ("selftests/bpf: Test getting associated struct_ops in timer callback")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261022-selftests-bpf-struct-ops-assoc-timer-v6-4-2c0f18e82582@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/test_struct_ops_assoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_struct_ops_assoc.c b/tools/testing/selftests/bpf/prog_tests/test_struct_ops_assoc.c
index 6c85d368bf167..9b646d134a45e 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_struct_ops_assoc.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_struct_ops_assoc.c
@@ -188,7 +188,7 @@ static void run_st_ops_assoc_in_timer_no_uref(int timer_ns, int wait_map_free,
 
 static void test_st_ops_assoc_in_timer_no_uref(void)
 {
-	run_st_ops_assoc_in_timer_no_uref(500000000, 0, 0);
+	run_st_ops_assoc_in_timer_no_uref(500000000, 1, 0);
 }
 
 /*
-- 
2.53.0



