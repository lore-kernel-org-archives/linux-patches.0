Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061833;
	b=11gWYKDf4/9BNrZymSzq4bZo8f6Q5exp5V1XVOe6zH3zishmi+kVN8CbF6ot70t6RwW5
	 Vjqxnd+A8YNyDKASeTkZ+7rGhztDvBmEHdkFpMNzzJZ7Rkifdly8UguwGxsL7LcJwgSpQ
	 L1gg3u49QOj0xAZJ2H0jCB4ZbDqVA0IXDOjahLs39IGKJ+q9S/GOFQMlCEdBwmKfCBW40
	 3gYssrpnU04zPC6C8qI3GJNy0x3hqQAmlr1AQ8NzTEI7nffK1CUVT9dTgqf5K96rItE1e
	 wXa1XZxBkqooQJNWV1+5LzSSg/yC1/06HSIFDDLSluVwpEN/t7wJ5+oCoS2wYlbtfkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wdv7PARcfeWox6UqWvZYqucjmeK4MOvNEY5i6bAyCr4=;
	b=ri3Bm/1AGF0iptZoAXeTkV4mZnUu5LZoeug4VJ8qT96i/M8b2+aWYzBVimOMimAxFLiA
	 dtvBrLJIpr2M0jN0wFdtLBO6858BmS94bkTnkTA1hAqUXdMdchMiode8uCPv2zf6FhfmY
	 xOP043WdD1peoC+8dmpom/EEi95KImYlrEfh6pxw/2j9f+H4FYEZVszynhbyutAth6pz0
	 C0q3quCt6zF3SZ3hJY9mGs5A4Hg/93DlAznMC8Q5a3IqCTAQqdpUPbG37EQc4OOjk+rqc
	 /+Hr3YoRAXHpaqMZutoPPCfgYcYvHzVySBxleSI6tk2EeHdyhnLxX7p0DILZGPVoX3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GjUf6JKk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B96D606A32A;
	Thu, 19 Nov 2026 04:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GjUf6JKk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C511F000C4;
	Thu, 19 Nov 2026 04:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061833;
	bh=wdv7PARcfeWox6UqWvZYqucjmeK4MOvNEY5i6bAyCr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GjUf6JKkQyeuYA6VKZbH3nJixBuuwevkk44mMUvQqM9A0pOqt/NEjrHRjrYDh0Zgb
	 D79c+mDD0hZrKqVYUbvUgwJg33y+RphBVNy63oIEu2TIaqgSbdOWczRPJQQbutc5hI
	 24El8UQ8eVgVFkCARD6qLPsWuGOVrqYatcNkmJlQ=
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
Subject: [PATCH 5.10 1695/1848] bpf: Fix verifier WARN on narrow read of bpf_tcp_sock u64 fields
Date: Wed, 18 Nov 2026 16:02:13 +0100
Message-ID: <20261118150030.728593255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 1630692179566..aa3fa288e9026 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6384,8 +6384,8 @@ bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
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



