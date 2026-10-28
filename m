Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213405;
	b=Jb6x79NLw3yUFUDFJZ6u9Do4IzAGmA+/Lpv2E3ci92aBqY3IWZrz9/axGd132BSvURuK
	 VpuJpW/TFv5Y4XqkQ03RoA9Hd6j7cuebrTU/ZN2Z+aICi1rNJYTFfFiTnBzU1M0ArZ+IM
	 7mxLav5Fb8KYtfNHy098xumoxcFSNtbGB3YWSAOACdb2wVy52MbwLiH+uyYNRnWUzyvwC
	 zG/N4oWZKO9dBO0PbpE+VtXOhSF5hv2ZS2TvX+HH6hjo5hZCbbVOPRXkhQnuFFQPAchEe
	 Oo2+smcDGRI7N29hM6sAboOhklM2GvLKGZkpPVNBr0DjquGJQ7fJLnJ+CHOWxpRrpEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iPCWe/EaqOisZm/ioJCYGCmshGUO+ysgYSTfccXqU4g=;
	b=T2v3YKzW9IIZOdqPpxcEwNT88F7saFujCo5z+w0ptnPC6FzNFUs871WMTuwpiBtvKGFW
	 XcpUfDgdpRJNPWAjWX2Cvdb/IMQOWOh4nbTVyhKEMvZPzierhnIxdPO/vmJ8BqtePIiwc
	 +kCK7frrxaCITCCOOp8utz9dwgJ06BnLLMrl34BcVvE5Q5j2Yc15aWK/s1hg2E0eUlW08
	 OKuR6+QN3+V0d8UZhLZhqNvgTX20IE46BaNy2p2xwqEGwggoHf038tsWws5LBJk4qC3x/
	 OnO8h28rDGoIukBBlpMVFP6HhJUIaFDpdOy7M2dcpIt4payMmvzUGCfAadb907ZP0CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2m5Z2K8m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5815F606A31A;
	Wed, 28 Oct 2026 18:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2m5Z2K8m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92771F01828;
	Wed, 28 Oct 2026 18:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213405;
	bh=iPCWe/EaqOisZm/ioJCYGCmshGUO+ysgYSTfccXqU4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2m5Z2K8mfz/m/QYxuRj8y2wDhE4YJjHOS+sE2NOtFN+RwB+zfjaC5VI0IjQz8g3Bd
	 dcaJ4lm/LRJ6ZUvfm9WxaWUqNx4ZZ5S/Oa4hirnhZypEkboG7Z/41r4/nA3X1Zmmar
	 f/1GlFoBSk5uPbFs9vBQqvkYCb7RI26IDosLLJ+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0495/1887] flow_dissector: avoid u16 truncation of hlen in bpf_flow_dissect()
Date: Wed, 28 Oct 2026 17:43:11 +0100
Message-ID: <20261028170510.546192752@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit f202578efc738b883cfa04889eb97328914265a7 ]

bpf_flow_dissect() sanitizes the offsets returned by the BPF program
with clamp_t(u16, ..., hlen).

If hlen is bigger than 65535, the upper bound is truncated before
the comparison. For instance, with hlen == 65536, both nhoff and
thoff are forced to zero, even if the program returned sane values.

This is the same class of bug as the one fixed in commit 99bda1ecbd56
("flow_dissector: avoid u16 truncation of skb->len when computing
thoff"). That fix does not cover the BPF path, because
__skb_flow_dissect() returns early when a BPF flow dissector
handles the packet.

struct bpf_flow_keys stores nhoff and thoff as u16, so cap hlen
to U16_MAX before clamping.

Found by sashiko while reviewing the commit above.

Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261007045616.445596-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index a51c8930f6d0d..511335741d687 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -921,6 +921,8 @@ u32 bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 
 	result = bpf_prog_run_pin_on_cpu(prog, ctx);
 
+	/* bpf_flow_keys offsets are u16: do not let @hlen be truncated. */
+	hlen = min_t(int, hlen, U16_MAX);
 	flow_keys->nhoff = clamp_t(u16, flow_keys->nhoff, nhoff, hlen);
 	flow_keys->thoff = clamp_t(u16, flow_keys->thoff,
 				   flow_keys->nhoff, hlen);
-- 
2.53.0



