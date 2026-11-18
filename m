Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016648;
	b=Tkk3QN8BBxL9f8Mf/9CqFs5eb6DHPS8IoN39KuoepiLsWKrwAS4eRcVRVHWxpI6yigoz
	 YPxMVennuuwi1JrIU/Z40ddR59b4KTA8072d80H7I0WUnk2N6SU21Q7B8xX4X/rN+GL0+
	 R3vNMJzTfZITRAGm2h/DYjmygOKD8p9F5VkDyvkDjvQ69zSWmyzdP2BP7xq5H1ssif2pG
	 Cg6a/U25a815CDpyr06zSPsy+XwSQPaRJ2hHIRTAv0NiRrLGiHpr85GkJHL5MrBeLcX0Q
	 tICdhp4HIm2RCN6xDbt5f0kgVW89yDTgo3vQW3BTow1b1udF8g++IgXEmXiEg8bVGqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HWFX7dJqup1cSl6cKZbi8tPQGvxOAj7c96Atnku8FKQ=;
	b=XvTmv9qTIGXjPcrQpdK/i0pcSXoul7LY6ts1+55Zt9093S71dY3g5V4UtjlhhTEMnGZo
	 Kl2SRI61a569590d134vkAqMOH5ClTXuAeMea85TXihj4c9AeY6oGCE/k0StlfjsZ9hiv
	 YHYgN9Ejxd6bgo2dHcV/NzTh2TrYvA0VpYpWbV/DKMmsQ45NQhQ+80ZJ/t+180bfWLnW9
	 tmw6oT/1eP72B33a4MXEnJeNcXFMGrYCGRTlr67XtvjUfnR8dtQU6Yz1Z4RokhvCwYKAF
	 ijgO8Xr9jPAOe77tC8+0zDvDkMNMiac9tdK4krnwzXAANBcSjMSxUtaOTKj1kc7MVcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ufBCkowR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B77606A325;
	Wed, 18 Nov 2026 15:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ufBCkowR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA531F000CA;
	Wed, 18 Nov 2026 15:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016648;
	bh=HWFX7dJqup1cSl6cKZbi8tPQGvxOAj7c96Atnku8FKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ufBCkowRovKMxWgbs8Z19vWydg/WavM4kwbEgHMVO6HstGLdZl137nQSOv642IkEp
	 9hYobTT3/W9msNQEbMNtDdu5bp0q3hu0dM0ypVh5JqW48CORtc1ifxKlvyYNMxQ2Gl
	 SoSn9xyHDxjvpoPn2Q39JVyV4JNs4yQqf60OpAYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0601/2651] bpf, lsm: Reject writes into the BPF LSM program context
Date: Wed, 18 Nov 2026 15:30:41 +0100
Message-ID: <20261118150309.360010501@linuxfoundation.org>
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
index 82c5988417a0c..2660a89fc8d71 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -414,8 +414,8 @@ const struct bpf_prog_ops lsm_prog_ops = {
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



