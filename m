Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209427;
	b=dj5/tzmlSQQxXXroMNrR+kel98GLe7Et03Iw/9rPDHdP8K8e+Jrn/k1cBx3j4ZzSfs5t
	 VaB56QIb7nhnNJr4zlQJUkYvbVOHzCJZqS5Gdr2WIq+xMhmHzYXYDgJxKJ1b/xXTqcso4
	 B4G0VKbFyvGKXmePmJzxs4zmn+3aeqI6Xf/jvtYAflAARs8zuIpAM/pLOb7Rc7ztzBmxt
	 RhPOQVIO11MY5gqEpmAAo70B22m9SLiHjNICId8xNamKnGLvtcPsqHrDjYJx3jQSX1Gkd
	 2PiBEIVFiCE6ZnHLKMlYtdsNkboFC+Wv12M9kUFQT2Q8qu5nGHClWMKixIkdCijDzbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MwqmCJ91uEf7XOfxP8CIM00NtOnNX8TSEgxJLedH18Q=;
	b=yGcimXegV4foZm0iv/c/E/gGBi1/tgeW1JMrwnWgBka+kqm3fEVybLFzz046ZjCMPhRR
	 OTv32IZV7gnetw7UaMm5b96mOFS6l07BxiLj7DPhnAMVabfx8QyXYPsAih1TTqL+XCLDL
	 pOh/qZnEW9wb+hCOcBzhUq4S3TNUIv/nEY/+1xX42IA4FWLvTLFizBQhQbt6gd6BsNdpD
	 6yjjsZHg/rJ9C9m/m9zYibRNGKexsDUTRPz9EBfK0GqvOF4Mr/o+qzrSbNXyUY9MLWmYp
	 tDjC2fGekRQ/09xr+FIigTWZO9MyH05/xUr6ZNVhwnvNXKtISBw7bt5MkhJJ1t3G4yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GBqrA/E9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF141606A31A;
	Wed, 28 Oct 2026 17:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GBqrA/E9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7E61F01828;
	Wed, 28 Oct 2026 17:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209426;
	bh=MwqmCJ91uEf7XOfxP8CIM00NtOnNX8TSEgxJLedH18Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBqrA/E9uHa6H/WqXh1nDS2UtkzOq1PWZh9nOgSbcbmofNfshNWJYyukBkdwZx0uf
	 scFb0TpRLgu8Zj/zfu6RrK6Ydf7tJiW19pyKX3RSVtg8MuTAhigUzNc0DVCxYda1aI
	 9Qyy0NQvtze6Aht2BAz3ozbmPpfw+3gZbJtV81jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Johnny Hao <johnny_haocn@sina.com>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 423/516] bpf: Do mark_chain_precision for ARG_CONST_ALLOC_SIZE_OR_ZERO
Date: Wed, 28 Oct 2026 17:59:35 +0100
Message-ID: <20261028170013.508287416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 2fc31465c5373b5ca4edf2e5238558cb62902311 ]

Precision markers need to be propagated whenever we have an ARG_CONST_*
style argument, as the verifier cannot consider imprecise scalars to be
equivalent for the purposes of states_equal check when such arguments
refine the return value (in this case, set mem_size for PTR_TO_MEM). The
resultant mem_size for the R0 is derived from the constant value, and if
the verifier incorrectly prunes states considering them equivalent where
such arguments exist (by seeing that both registers have reg->precise as
false in regsafe), we can end up with invalid programs passing the
verifier which can do access beyond what should have been the correct
mem_size in that explored state.

To show a concrete example of the problem:

0000000000000000 <prog>:
       0:       r2 = *(u32 *)(r1 + 80)
       1:       r1 = *(u32 *)(r1 + 76)
       2:       r3 = r1
       3:       r3 += 4
       4:       if r3 > r2 goto +18 <LBB5_5>
       5:       w2 = 0
       6:       *(u32 *)(r1 + 0) = r2
       7:       r1 = *(u32 *)(r1 + 0)
       8:       r2 = 1
       9:       if w1 == 0 goto +1 <LBB5_3>
      10:       r2 = -1

0000000000000058 <LBB5_3>:
      11:       r1 = 0 ll
      13:       r3 = 0
      14:       call bpf_ringbuf_reserve
      15:       if r0 == 0 goto +7 <LBB5_5>
      16:       r1 = r0
      17:       r1 += 16777215
      18:       w2 = 0
      19:       *(u8 *)(r1 + 0) = r2
      20:       r1 = r0
      21:       r2 = 0
      22:       call bpf_ringbuf_submit

00000000000000b8 <LBB5_5>:
      23:       w0 = 0
      24:       exit

For the first case, the single line execution's exploration will prune
the search at insn 14 for the branch insn 9's second leg as it will be
verified first using r2 = -1 (UINT_MAX), while as w1 at insn 9 will
always be 0 so at runtime we don't get error for being greater than
UINT_MAX/4 from bpf_ringbuf_reserve. The verifier during regsafe just
sees reg->precise as false for both r2 registers in both states, hence
considers them equal for purposes of states_equal.

If we propagated precise markers using the backtracking support, we
would use the precise marking to then ensure that old r2 (UINT_MAX) was
within the new r2 (1) and this would never be true, so the verification
would rightfully fail.

The end result is that the out of bounds access at instruction 19 would
be permitted without this fix.

Note that reg->precise is always set to true when user does not have
CAP_BPF (or when subprog count is greater than 1 (i.e. use of any static
or global functions)), hence this is only a problem when precision marks
need to be explicitly propagated (i.e. privileged users with CAP_BPF).

A simplified test case has been included in the next patch to prevent
future regressions.

[ The context change is due to the commit 8ab4cdcf03d0
("bpf: Tidy up verifier check_func_arg()") in v6.0
which is irrelevant to the logic of this patch. ]

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220823185300.406-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Johnny Hao <johnny_haocn@sina.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e1f571219d16b..50bcf15eaa171 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4896,6 +4896,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			return -EACCES;
 		}
 		meta->mem_size = reg->var_off.value;
+		err = mark_chain_precision(env, regno);
+		if (err)
+			return err;
 	} else if (arg_type_is_int_ptr(arg_type)) {
 		int size = int_ptr_type_to_size(arg_type);
 
-- 
2.53.0



