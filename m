Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042002;
	b=upQ61UEfy+1tfwdtYnHajX4V75pe5N+dGDNhj6+/93CpD6V8Qbs8GwVmwV93ngP+BWeB
	 HvQ87vI/OgyH0zoCzMOdZgEleT9LErhXubHF3yEA9fOWOHupHm5KE+hwJhyPrZJ6fAQSX
	 2i4JZBgwc7jdoCGtQWMyzFfKFzpvXV57dN6G8+rzkFdgi6ic+0np+vdz5SaJst3klSTTO
	 tKjXzXgToBVPwDDHCL199CIrF6Uc1KoN63x7L9wqt4pL2AfWdxuH8JPPt1JGk/6vd7p0M
	 7F/Nv/IuLH0N+nCoTr7/FbDWCQ48TXC7Sb5sD4OlJ1F0HUGAE9r8DplFOo3WvBTcBag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jJBwVr9G0IamsqY8b61Yd8fY4Kp4WJeBf21U3pstlqs=;
	b=BqkBSX2hydLnfKSMljaewaMxAXwzsHtyH0b/oyelLe1khQB+nBklEOL5HBaj8MDONjzf
	 TsSz7djSTBWnZR37TmFA5GbHA2rA5adWvR27Na/RBFRIHZICSQdXnyJxXRp1VGhc3/fu6
	 9aErYpvkqXH4qZp5PM/YBaI/bM0lgFKfDTgen4SJfF8l4SNnfQgZzxBAc8aEo/GfHUAas
	 QOHKa8jY4cL8ZefsV7gzbHFcVIDk8eyhIT6a6E+6Tn5tYjcLWKXtlVb3pXkh4oK64Do9S
	 +rPyPXdPGqC/5lQzC7Y2D5twnDh6l6R8Oh3hPPTDgoLjeFszC3qnoUsL0Fcy5cQVZ9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dGd0NfqY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4DF606A31C;
	Wed, 18 Nov 2026 22:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dGd0NfqY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1157B1F000C4;
	Wed, 18 Nov 2026 22:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042002;
	bh=jJBwVr9G0IamsqY8b61Yd8fY4Kp4WJeBf21U3pstlqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGd0NfqY1v+xts4tc7mQkqJIlk9OaN4lZTvsfXwcza79o+49yv6uljn14Z2zlAYP4
	 03ttNsW3O2cOmdJSWr2pLXsYhgDbGq+EsP6BjhulzIYI4VK3WTlZJjanLe1BTlqvKM
	 S0NIVV5lqFMBBrNgx8YH2qSZbB5HjAgdDc1h/gcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3014/3318] bpf: fix cgroup_skb prog test run direct packet access
Date: Wed, 18 Nov 2026 16:00:36 +0100
Message-ID: <20261118150450.645806734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahe Tardy <mahe.tardy@gmail.com>

[ Upstream commit ed3e469d021cba343a3b32f0876f8f28b1d9bfdd ]

This is needed in the context of Tetragon to test cgroup_skb programs
using BPF_PROG_TEST_RUN with direct packet access.

Commit b39b5f411dcf ("bpf: add cg_skb_is_valid_access for
BPF_PROG_TYPE_CGROUP_SKB") added direct packet access for cgroup_skb
programs and following commit 2cb494a36c98 ("bpf: add tests for direct
packet access from CGROUP_SKB") added tests to the verifier to ensure
that access to skb fields was possible and also fixed
bpf_prog_test_run_skb. However, is_direct_pkt_access was never set to
true for this program type, so data pointers were not computed when
using prog_test_run, making data_end always equal to zero (data_meta is
not accessible for cgroup_skb).

Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
Link: https://lore.kernel.org/r/20241125152603.375898-1-mahe.tardy@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 6aff0129f327 ("bpf: Use the socket of a sk_lookup test run under RCU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index b7e84ad5c73a3..d70543fb6849b 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -993,6 +993,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	case BPF_PROG_TYPE_LWT_IN:
 	case BPF_PROG_TYPE_LWT_OUT:
 	case BPF_PROG_TYPE_LWT_XMIT:
+	case BPF_PROG_TYPE_CGROUP_SKB:
 		is_direct_pkt_access = true;
 		break;
 	default:
-- 
2.53.0



