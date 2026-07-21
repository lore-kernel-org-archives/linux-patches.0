Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C4B46AA70;
	Tue, 21 Jul 2026 15:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648104; cv=none; b=fEHl8R2Ss2D2mzVwHKuzGS1Kz0JgNFQqtgDisjDXD2mCywMod0puGx3bPoBxMTzb8fa/VqJYkZByVM5EOM49wjEC8vSCbv4nOkzbnlz8agw/vqH3SFuGEFrq/aupCmLXgrbaWvQuQZS7KUOqV4k6WNa/XGsVz7vxljSk3ruczE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648104; c=relaxed/simple;
	bh=qH1EvN/it2TYqynxSN5Y7phks0uFX6SZvcWInl/toVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1+qYCLVfDgGzw3nq2yNeudnAq+85hRR5jmICLSM5CuVyJhluNHOhraJ6FT2TLKObm7lh9vCJwGq8XqTLEzJgiWoGa47KZ+82wOgyRg3oCRlyj/UxFBybuZp9Q1F4QuF5m3zRresGc0jBhI2CRAlbnUkvArqisrrCf9Zp6lXNzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXhZAbiX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXhZAbiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5859E1F00A3E;
	Tue, 21 Jul 2026 15:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648102;
	bh=4bm9bLsipAjr19FodOL1/0Z3NV+S+xizsW6V0YJTNP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXhZAbiXUWqSzX1MmqBBZa3KcELhQiI8BnEaG1xDNOQJnU5DGNj57kQc3vL/XF+2x
	 5xI3RIGJBqoRcLXLxHj9gLgjLJNfDrAN4Z3CqMxJAwwqIh4VP8BjUQBIC1qESrqDeW
	 drV6aRGZyQAKeBw4smWPgOIctv2WUxbIyGT+dOCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Bell <grbell@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0072/2077] selftests/bpf: Use local type for flow_offload_tuple_rhash in xdp_flowtable
Date: Tue, 21 Jul 2026 16:55:45 +0200
Message-ID: <20260721152554.389959981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



