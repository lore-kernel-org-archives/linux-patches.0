Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216648;
	b=AlaNeiDklvExH29cXEyOyXt1LcpR9olY965H45+D/62W+wwrkg9smn9ouNtAqBbuw0kU
	 Z8wk/iOyt9/IyoXsfysiZ7dtgr+O4913pqe23nJ5WsPRPaBjyDw0Do8ZIfIz81HPcNvlV
	 efUMDtNy02mqEgylOvOSPimh714bc8glOYnaopjBwo0tYAoC/VEi30pZC9L2ewjvCUwrz
	 UImgSyR1MMkVc6DbvleOk0L2imuhY/23JJMjLwSV/ROMysIF18SEY85U8ClFmdLgF7/JB
	 i7ziHVHJyaqRMOHhLVowbfmQm3MCYCdP61lLN97hOppJKOtIn4//JQw7rZdDnkjWoVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8FsN2xbgZ2xxsV9tC4CPj0WrLlcBkjGZNd4hXU5bQRE=;
	b=mV+LqaJXMhC24zxuX34lzwP2KQT9uXlnVW/De96vSJ79duDjH0N0Lihcs+fHCzVNSGoI
	 wbFrBPeYdZ9ni84dloFwu7ogGjE0eNJPcY7hBMFoDbVGQ/sVWMtAY4MU2xzF8g8bldkxP
	 J8jcA7CY0qhkChe8YFNBB9WlLHz3DrYMI+xC47pEACOhRk5DShRW9LAKS2eZU3tBupVCt
	 cSVO9mCgUJzRcje4xlXmGOToDIKsJ4KVpTpygEbsQnO6AeaVb8XgeWUsAzcUB0KDydzeo
	 4KD6TWZq0TYlEcQQBK/eKyMp2PPx5auLKFOo4i7hFWHb+MVtj+aifsZNMCjlEjkQ3wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=onMlQ+YB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA01606A31A;
	Wed, 28 Oct 2026 19:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=onMlQ+YB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5071F01825;
	Wed, 28 Oct 2026 19:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216648;
	bh=8FsN2xbgZ2xxsV9tC4CPj0WrLlcBkjGZNd4hXU5bQRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=onMlQ+YBujB0ZChPNHgZqxuLDasPJcGU9Xu7xOjOm8WopaHytG8WmTQGiFJ4NZfDX
	 jJkqQyu+3g/Y14+BXpvqwbAN2KFWGOZI6FKzBAyw0aUaU/6M+Nyc0BpUlbXItFRuEi
	 4Tc6+9euYycUAiRwtA2qDp66CdnYCtj1uOzjXUIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1629/1887] bpf: Reject rdonly/rdwr_buf_size kfunc arguments that exceed u32 max
Date: Wed, 28 Oct 2026 18:02:05 +0100
Message-ID: <20261028170536.536603651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Dudar <main.kalliope@gmail.com>

[ Upstream commit 2aaf67f0516fde29620d0edfc29c01b9ea7ad430 ]

check_kfunc_args() detects a kfunc argument named rdonly_buf_size or
rdwr_buf_size and stores reg->var_off.value into meta->r0_size, a u64,
and does not bound it. check_kfunc_call() later copies that value into
the returned register's mem_size field:

  meta->r0_size = reg->var_off.value;
  ...
  regs[BPF_REG_0].mem_size = meta.r0_size;

regs[BPF_REG_0].mem_size is u32. A constant whose upper 32 bits are set
gets truncated instead of causing a load-time rejection, so the verifier
records a PTR_TO_MEM register with an approximately 4 GiB mem_size for
whatever allocation the kfunc returned. A later access check against
that register uses the truncated, wrong bound.

Reject rdonly_buf_size/rdwr_buf_size values that exceed U32_MAX at the
point meta->r0_size is set.

Fixes: eb1f7f71c126 ("bpf/verifier: allow kfunc to return an allocated mem")
Signed-off-by: Nicholas Dudar <main.kalliope@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20260709155837.1879230-2-main.kalliope@gmail.com
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index e20b4d024a828..850ea69e05fd5 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6345,6 +6345,11 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 					}
 
 					kfunc_meta->r0_size = reg->var_off.value;
+					if (kfunc_meta->r0_size > U32_MAX) {
+						bpf_log(log, "R%d rdonly/rdwr_buf_size exceeds u32 max\n",
+							regno);
+						return -EINVAL;
+					}
 					ret = mark_chain_precision(env, regno);
 					if (ret)
 						return ret;
-- 
2.53.0



