Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030154;
	b=CSAWEumAB7RAh9QJAyPV3uychad56SY+VlhqFg72kcR4fz88cMpNhCsOYvrKsy2jClKq
	 NM5Xv8pzIpEgGhd5PaaQJ/nImXJu62rcBnf7JU0R46w2u8K6Z8H/iyxWiwqKoBQSfuzq5
	 5Zl2MHKDg+dzvEmnBbWUFhPFNz+e1pvGdGrqJdmPR7CjYXIqSIr+mVC9EuyH+zN2hO5lB
	 GbjUVUSbEFOjWXpn2IP4EWZjCKTkwcJn/kAKQ9Q3KRkCD3qb4e1rr1PKeiAzMO3I7bSbU
	 0x9IuEIIeQKxLjgKXrVjG9TgF8Rvs89Mjj9XIdm8gomGedn0GzUqXgrxC6LKfOHDbdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=V52og9Al7xA6xT6UUFp4pjXU3GZ+hf1t23vN8Szq6Ko=;
	b=PiN7kKt34BDVepsAKVgX4xiCM4Q8E8SUkcKA//E2K+kE3F/ugJHQPtpHSPE3cuH58T67
	 r0wVczttgu4RybL8sO/K7KWlE3SdANCcwNyozXamnPOV4huNC8w8ulDi30NxfY2tTnROp
	 MxL8oevNZ0RPQW/9NP2eJzuPXwGvn99CvGPakmU0EK0NxVXVlfO9wuq/wQlJ/gCZk/av+
	 1wJmh9GYBeUyUgjMp9qyZrb1SLGbaLeYYEBxeCGEG2cGOCr2T2DDwiBp5VeeYrgLnxYJC
	 7Uxq/DEkXfQPxiR6hBIeRfASBbDRBdg1+Tzn9Ey5ECphcwIehhtKLVyPt6Sjj1eb4Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C63CszoH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88D8606C42C;
	Wed, 18 Nov 2026 19:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C63CszoH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC391F000C4;
	Wed, 18 Nov 2026 19:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030154;
	bh=V52og9Al7xA6xT6UUFp4pjXU3GZ+hf1t23vN8Szq6Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C63CszoHiVgxO6ZiPx1+e5NGRT3Yn4i5dnpUvhobmNm6tcxG5pHOVdNSHDX+jdy2l
	 VOxN+h9F2gydCpts+YGWbGomo7Npm04FfPBlx3s7OtheWHYlbxbviewyfA6QO+ayNS
	 ScI9nvBtMqwXNfQ8567QpiE7znmdgQqdop18YxEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0562/1756] bpf: Adjust bpf_func to account for CFI offset in bpf_jit_free on riscv
Date: Wed, 18 Nov 2026 15:44:49 +0100
Message-ID: <20261118150031.461751878@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 43cba6b657b72..56921fdf8f52d 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -262,6 +262,7 @@ void bpf_jit_free(struct bpf_prog *prog)
 			kfree(jit_data->ctx.offset);
 			kfree(jit_data);
 		}
+		prog->bpf_func = (void *)prog->bpf_func - cfi_get_offset();
 		hdr = bpf_jit_binary_pack_hdr(prog);
 		bpf_jit_binary_pack_free(hdr, NULL);
 		WARN_ON_ONCE(!bpf_prog_kallsyms_verify_off(prog));
-- 
2.53.0



