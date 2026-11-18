Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032283;
	b=aOEQHHzKl4to/hqAaRl07qumShNjcCbVgU66TZwjJ27YvWBqupS4Bb+mkmM+EW9Zc90J
	 joJXlhET3Q6aZJ4+l/D6dtTlPthZaxooeBErHjfe62+kSKGgbAmHYGvfaVIiej7FDkdNI
	 hY8gEPYEYvcMgUYTi8lts+g6nnLY9kAUqVFhRmRzR5FCFEw7Nz+7XCMJErDGVtiPKgGQa
	 hgtfuYFCB1X/SiA9eailjUVNGB6ytLSlhrViJ9A2sjQAS0SMYEIoeGIc9hpU7HVR1FFu6
	 Yvg+thCGuw0v4pJUE57Td0K8lLkS8RWip2VP2ZEYpgaGw1Vh3yjO0AmhdoUKwUQjuRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WpiXPo50LAZs6/eS5TtZHWKLzWpAxGL/G0qAdjZzwYY=;
	b=0n3IXfW98jqFvICoHNKKst+LX4r4ChcQeJ9XA4kh6ecwweulGk8pUJftYJ9xf8oqhgXC
	 uIhtaPqqyysZZlUrypRD6Vphe/E4IoSbH4sirINMO2/J8BMhGseqqSvQGnHQajZ9kPTVX
	 N8g+VCNhaxX+DFjUEpAilEzcZo+YfH6Zt3jvb/0zMRPouQnh1j9Xkc1OeJ+v7MOjXliGE
	 XQ+WBc/anqJ4yL8DafMdDrZlLz9rlgm3c7Sz/A47kx71f6IoarxWgjbhv/jBxjdUYJuZh
	 63DW2zVHaG4dPm1SMzoudOm/e7fYam7r5H2YXQaX0pRDZ0WIyg2KFd7D+rrs3lC3upw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sUElZvip;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3119B606A31C;
	Wed, 18 Nov 2026 20:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sUElZvip
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D2D1F000C4;
	Wed, 18 Nov 2026 20:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032283;
	bh=WpiXPo50LAZs6/eS5TtZHWKLzWpAxGL/G0qAdjZzwYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUElZvipRfBBttXGF9NfEOa/Zzm5SwFzSKAlodSygWnKecvY2jwV4Xx3EvHzndlzo
	 QeNg9MQybxj6hxh+KvMjci2VVViQEDEtTZOqNXL5iBFd4owD/+egOu1w+HSxFnSEkJ
	 9WdLwB3gg3grqJCFn2cBTt9pBhj9PgemKVkcn4Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1356/1756] bpf: Fix verifier WARN on narrow read of bpf_tcp_sock u64 fields
Date: Wed, 18 Nov 2026 15:58:03 +0100
Message-ID: <20261118150103.276339238@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit af873495cbcb066ab029f7f63b94410d4db47628 ]

A BPF program can read the middle of a u64 field in struct bpf_tcp_sock:

	tp = bpf_tcp_sock(listener);
	/* +0x54 is in the middle of the u64 bytes_received */
	unsigned hi = *(unsigned *)((char *)tp + 0x54);

bpf_tcp_sock_is_valid_access() allows this 4-byte read (the default case
only checks size == 4), but bpf_tcp_sock_convert_ctx_access() only knows
the field starts and has no idea how to handle such an offset. It emits
no instruction, cnt stays 0 and the fixup pass trips verifier_bug():

	verifier bug: error during ctx access conversion (0)

Just disallow the narrower access by matching the whole u64 range of the
two fields, so it is turned down at check time:

	invalid tcp_sock access off=84 size=4

Fixes: 655a51e536c0 ("bpf: Add struct bpf_tcp_sock and BPF_FUNC_tcp_sock")
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
Reported-by: Dongliang Mu <dzm91@hust.edu.cn>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017143819.209510-1-jiayuan.chen@linux.dev
Closes: https://lore.kernel.org/bpf/7a8ff335.1024c.1a14395f3e5.Coremail.kaiyanm@hust.edu.cn/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2d6e2f772a600..c1e4825bba4dd 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7238,8 +7238,8 @@ bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 		return false;
 
 	switch (off) {
-	case offsetof(struct bpf_tcp_sock, bytes_received):
-	case offsetof(struct bpf_tcp_sock, bytes_acked):
+	case bpf_ctx_range(struct bpf_tcp_sock, bytes_received):
+	case bpf_ctx_range(struct bpf_tcp_sock, bytes_acked):
 		return size == sizeof(__u64);
 	default:
 		return size == sizeof(__u32);
-- 
2.53.0



