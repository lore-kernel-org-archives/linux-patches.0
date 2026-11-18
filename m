Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050205;
	b=gkVoFWFO6Cnh3+5rE+eXCVo0Te2CStFg7+ASjoD7SpWSNapTJW/N8VXZNLwuzNSouLoo
	 qLAexnckcdHZxCn8xZckpI8WAPMvxXOndG/zPD6VtGq+FqlUQ+6zHlY3CgOXiD7F2LZcq
	 zFGRFjGmLjLOgZyUFtf75MSkQZFyVWe9RpM+xEzRRMDI4WYrN4dYcQzTEB7dogLtuFo1F
	 oPHSIio3qEEpqEuHPkHsoTfvelLm/p9RqBwG+o4ZIxn2IDnCZ4apXyqL2JCRgf93vEsHQ
	 uhB29RvDkaIFonRi7/Q1XSQF9UVtONs3Eoc1SE5K5pnAA268ICA7XbQySroOv0GQ54g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y0jXxdtuQR5Rft5PFhvVfAIikxxGDWAHORc8JIYEEg4=;
	b=KwSgNoh3UWIRwjysp7aa6B7juOnrQhbTmlLIK+qA8WV0NiG7e1LNUN9Ix9RzEmF7ru0v
	 3unvEpVEBtS7Rn9NRIPxNDIaJUAyEOKXy3TXRMeJu+WGsyKvmS0EpPj7JkjeeYMgCc3Xe
	 ozySjkJlnku0DwALxBOrmhSoN7TnROEYu89R/+CDZ37WaxSU8M/YOyn58qJPH6ZFA9SMd
	 c4gRsdHKP4q/GcJQtx4maxVJYriE/Dp5mi79/b+n25bhotTgYJQFcPvHnmA+RttpSfoWM
	 yUhx52Dr6kpggvvtZit+G4soOmEboVN7oxmHqDTCQh9D4swcVOmBBSSIVloP+rjCiFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJPuFjoW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7265E606A33B;
	Thu, 19 Nov 2026 01:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJPuFjoW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06CE1F000C4;
	Thu, 19 Nov 2026 01:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050205;
	bh=y0jXxdtuQR5Rft5PFhvVfAIikxxGDWAHORc8JIYEEg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJPuFjoW7MuTPrFlWWGczyJOHUMWYBntaqvAdZFC414/9UQlkkGH5cKTsSvgpTPpd
	 hrKkv049jT8Or+c2arAOYp3eFSL8J2PkRwNVhjUy80K9FB0JKOIPq3lvqTtFA2NEZi
	 RTQNghUD1O4ybsDHzXkD7gKSnlOC7zhGh66jBcBc=
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
Subject: [PATCH 6.1 2584/2857] bpf: Fix verifier WARN on narrow read of bpf_tcp_sock u64 fields
Date: Wed, 18 Nov 2026 16:00:18 +0100
Message-ID: <20261118150334.547308688@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 73c64a1a57064..cce48847d931d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7094,8 +7094,8 @@ bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
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



