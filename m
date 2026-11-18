Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023943;
	b=PNZhnZu3R8izjHKtKZ6VgOKdOPFdG4tJL+QiTmvGIyQA1DSF1/6hgDA4Xx3FPsWbsz8T
	 4peYsEX0rGExB9l2cBUH/OMkdXLKA4x3FTAJdmmQtpe/V4dDNE/1LXWKmyytaSG3vikl1
	 k0ibZ/9VaAy8Gj6Mzbcm70SLyrMWcxr6ewown4kxldosTqpodQH64LMl/WjrhtRPAgPCO
	 O/vKUUia1WEXcIdekCUq4EFyubqqrFLd5M88pdcMLAvAuWvqFmGdayuX9DqfiCbW1IM/r
	 y7RbqdPBxvwbgOrSJeGmCIp/QljrR4GB+wM+isaM9mhDpy08ymAn+UUgIdnB/M+xYbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TZQTimAtSHy3j2G+E9F5/RyPzRUPB2NsKkA1aUH465c=;
	b=o7ny04R9JOiSzUnGqJi2w6nfoQ3YfVlOGrhpS+jZbTihmscYlnWm3DnmJs5mJa1pIC0p
	 UFEgX0wn2Of6WjJXe/m02si8qKkNIFb73pTjEhHQ17yFCAoqBXErnp1JUiW3+pYZXVetN
	 28gdAuGi/GMlFm/0NqLwXEKGdacwUW4D+AcpomUQYCwczFexU0jIrn8tbKXiKyfUDx1iP
	 TLCVQpjJ6F6VkdhKcA9r1ptu15iOBIxD+83dthdhGdjY004JXDEs8MIAtyf5Fy9TgDQ7J
	 1ivqprnQhQUegEC9JrDvyty6SzlnLFYot/CAEMjDOKxFeyv+6Pd7drqwDaOBYNgOoQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+W1Sy27;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A48606A31C;
	Wed, 18 Nov 2026 17:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+W1Sy27
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182261F000C4;
	Wed, 18 Nov 2026 17:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023943;
	bh=TZQTimAtSHy3j2G+E9F5/RyPzRUPB2NsKkA1aUH465c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+W1Sy27F0PtYIQGAWRAARRI6OwI6dDm5hCGXBjd1C4/wyyLBTJRvA8ygFLfIsw7/
	 uyE3E+STbMRKsNZr72tVQExGxHpydu9vheOQURJlp3NGdKEVtZOh3/47jK/+dNa+xf
	 5MTw5j+C/ca16GAesI0+HHk6IWxnZXBfEWK6a2wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0548/2151] bpf, lsm: Reject writes into the BPF LSM program context
Date: Wed, 18 Nov 2026 15:38:03 +0100
Message-ID: <20261118150141.932284552@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit c42da1d3ba9d5067cf3f0676b98bcb3f5f9e3ce1 ]

The verifier types a load from a tracing-style context by its offset
alone: btf_ctx_access() looks the offset up in the attach hook's
prototype, and check_mem_access() stamps the resulting type onto the
destination register. Nothing tracks what the slot actually holds.
That is sound only as long as the context is read-only, and for BPF LSM
it is not. lsm_verifier_ops wires ->is_valid_access() straight to
btf_ctx_access(), which never looks at enum bpf_access_type, so a store
into the context passes verification. Every other user of the helper
either goes through bpf_tracing_btf_ctx_access() or open-codes the same
type != BPF_READ test first; BPF LSM is the only one that does neither.

A program can therefore store a scalar of its choosing into a context
slot, read the slot back, and get a register the verifier believes is a
trusted pointer of the hook's argument type. Handing that to a kfunc or
helper which dereferences a trusted argument turns it into an arbitrary
kernel access. Route BPF LSM through bpf_tracing_btf_ctx_access() like
everyone else.

Fixes: fc611f47f218 ("bpf: Introduce BPF_PROG_TYPE_LSM")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260915150739.284189-3-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 48876fe838ab9..116c91680cc7a 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -408,8 +408,8 @@ const struct bpf_prog_ops lsm_prog_ops = {
 };
 
 const struct bpf_verifier_ops lsm_verifier_ops = {
-	.get_func_proto = bpf_lsm_func_proto,
-	.is_valid_access = btf_ctx_access,
+	.get_func_proto		= bpf_lsm_func_proto,
+	.is_valid_access	= bpf_tracing_btf_ctx_access,
 };
 
 /* hooks return 0 or 1 */
-- 
2.53.0



