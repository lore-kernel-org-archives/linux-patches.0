Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CB246D2B3;
	Tue, 21 Jul 2026 17:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655608; cv=none; b=qK4/czLnmT7faCSATZLbF0zEMwyCsPultRhGP4siZ5YgTWi2Q/ewI61v5Y2VMSmzIpGjjCyCitkkASZPqnLQfN5ZP1HoXlKCJfwYnluKU2fYT21tRswId0m8aUbqvRDkcTuOX46LGrz9rqkXQOrHkjpuFJ/1+FAGOBAkDzR8de0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655608; c=relaxed/simple;
	bh=b9VDzJYJDOIc2dA+FMfClUMHcOSsBrXK/C34ATa0v8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3BHcamt54Qi+NUgyXt5DnZkrPdUKrj+1Eo5jGHz2EIemXj3SaELEaORkPhaz7pR7vXbouhfWhCNkSgKNGAEnhpavGCoor13Gb76nH4irYSP6vKn6WhNCS440uEHwFUW5FiqlcEK0M3H7nFwGD1GzrLC6is5F+tMHgk2BIqDBbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBm0SkDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBm0SkDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0393C1F000E9;
	Tue, 21 Jul 2026 17:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655607;
	bh=9vgHdZx+ZOSmPyDvuvLfeeH/106yBf/k/J+8JeS+lU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XBm0SkDydMHDscxxEzfbXpKsHRUjVjzC+LsmAT1xEfMFWwJv16lvgPKsKnldBDFpI
	 +Vmdc+vnQuuW40otZxScHenCSWtYDYVzueM6U6SQDIfp3fXwIKCjGjQQP/bJQCisHo
	 9a1vU//DpgaCi3xiFhCCEachBd4Sc/D0iOlg8Y20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Bell <grbell@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0073/1611] selftests/bpf: Use local type for flow_offload_tuple_rhash in xdp_flowtable
Date: Tue, 21 Jul 2026 17:03:09 +0200
Message-ID: <20260721152516.478120319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Bell <grbell@redhat.com>

[ Upstream commit ac985e7bf840e34a8dafe0808cc571fd85896c30 ]

Define flow_offload_tuple_rhash___local and use it in place of the
forward-declared kernel type for the bpf_xdp_flow_lookup kfunc return
type and tuplehash variable. This is consistent with how
bpf_flowtable_opts___local is already handled in the same file and
avoids relying on a forward declaration of the struct.

Fixes: eeb23b54e447 ("selftests/bpf: fix compilation failure when CONFIG_NF_FLOW_TABLE=m")
Signed-off-by: Gregory Bell <grbell@redhat.com>
Link: https://lore.kernel.org/r/20260417154122.2558890-2-grbell@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/xdp_flowtable.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_flowtable.c b/tools/testing/selftests/bpf/progs/xdp_flowtable.c
index 7fdc7b23ee7498..e67daa02749d54 100644
--- a/tools/testing/selftests/bpf/progs/xdp_flowtable.c
+++ b/tools/testing/selftests/bpf/progs/xdp_flowtable.c
@@ -15,7 +15,10 @@ struct bpf_flowtable_opts___local {
 	s32 error;
 };
 
-struct flow_offload_tuple_rhash *
+struct flow_offload_tuple_rhash___local {
+};
+
+struct flow_offload_tuple_rhash___local *
 bpf_xdp_flow_lookup(struct xdp_md *, struct bpf_fib_lookup *,
 		    struct bpf_flowtable_opts___local *, u32) __ksym;
 
@@ -67,7 +70,7 @@ int xdp_flowtable_do_lookup(struct xdp_md *ctx)
 {
 	void *data_end = (void *)(long)ctx->data_end;
 	struct bpf_flowtable_opts___local opts = {};
-	struct flow_offload_tuple_rhash *tuplehash;
+	struct flow_offload_tuple_rhash___local *tuplehash;
 	struct bpf_fib_lookup tuple = {
 		.ifindex = ctx->ingress_ifindex,
 	};
-- 
2.53.0



