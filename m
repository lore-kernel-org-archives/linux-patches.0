Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024422;
	b=07l8j5jW2KL8LfYpubzKONrE3XkycfwlGZEQZW57RREdlE90Ff8NIwLV3VgYwpR0GPnM
	 kkEg5gJ0rpq4Ij3RBmiMzNAaQt5YK/koBQyu5DXTtIYkMwSS6rusBbHCw1TG+THV2seJd
	 CnhWRe70cMGUgUiQHcmqdt7WugWP6w1Ma86co7IPRKqi4vanN9Dia2cToMvrLLdmwLYLd
	 cYO2oa64CZCc2UPZNQyHFG+OqUhhUiE5BjJiMzr6URVZOMsOL6GEjj4O5Puk2q9VqcEe+
	 K2S3gwiKXuhfXJcwhyxfla6ASUk5fT03IwQgAw/5ToxvexZymvTDY7qMdsWSgDkAhrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mn36G13DqmGRBvbzrmrgjUORRCxhq02sZtZPsvTzzVU=;
	b=fgXE8PHpktSIEQqEEWuI6+UdtSkNWbrI2/7Tu7AVmAp4lrF91Cc0/Mx5geSUvAw1ryHx
	 IvhFMVgfG8Vv4Q4YV01ZmtxCxyxMOtS0jEzmndUE+KYG1wbcTO+Z2EdqL0OUku7jO1MGM
	 xQHyrTRMyR6nG8oyGml/Q8jzQYTFl1eDmFUxm2uiZOozHK7lLcs9bqmcgIhF/i6LB4MaU
	 HkM0W6/G+ElKRoX9lzYTEVZRNcWeV9v5y41Jpr9zybOrKmagxwWaugfheTeKMVhS/mTcB
	 zPu2u2gF7cnY9kpwUC+t8eNqcSFVMYIP2QObn70kDkfV3DtwcVWDR6IxN3Wab5y8P4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUZhc8xP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA373606A31C;
	Wed, 18 Nov 2026 17:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUZhc8xP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A5D1F000C4;
	Wed, 18 Nov 2026 17:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024422;
	bh=mn36G13DqmGRBvbzrmrgjUORRCxhq02sZtZPsvTzzVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUZhc8xPH2LrFFVr8ql45Ya8Scza9A+OQrbf8mLd1uk+hbyQ2ewX/+iS4b1MdiwFb
	 DmOJBCOsNfPI01EoFpzcj/3STUt4c5da3PIWRhvJb2jMH9t6NzA5aeakHnzMZ6cNwQ
	 ipipA5ivrsihk7bZkQf+1vR52kqDzwgy/1xzAs1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0693/2151] bpf: Adjust bpf_func to account for CFI offset in bpf_jit_free on riscv
Date: Wed, 18 Nov 2026 15:40:28 +0100
Message-ID: <20261118150147.027448572@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 93df8ae3267f19bf0c1135d26a0e21145dd0ea1c ]

When CFI is enabled, the actual BPF program entry point is shifted
forward by a CFI preamble. During bpf_jit_free(), this shifted pointer
causes the wrong ro_header to be fetched, leading to a potential invalid
memory free.

Fix this by subtracting cfi_get_offset() from prog->bpf_func to
correctly restore the original JITed allocation address before freeing.

Fixes: e63985ecd226 ("bpf, riscv64/cfi: Support kCFI + BPF on riscv64")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://patch.msgid.link/20260923144216.934701-1-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index 09bd4eaac63e8..034b5204f73b2 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -254,6 +254,7 @@ void bpf_jit_free(struct bpf_prog *prog)
 			kfree(jit_data->ctx.offset);
 			kfree(jit_data);
 		}
+		prog->bpf_func = (void *)prog->bpf_func - cfi_get_offset();
 		hdr = bpf_jit_binary_pack_hdr(prog);
 		bpf_jit_binary_pack_free(hdr, NULL);
 		WARN_ON_ONCE(!bpf_prog_kallsyms_verify_off(prog));
-- 
2.53.0



