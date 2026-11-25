Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617899;
	b=udCPojp3kb5b0sKqXxFdNffQu2q0Ofjf56vi8dj4BomzlwTQjjgfpLU6hYgL+AwsHaoT
	 ruzvQaP73MmIKWBSpW3ptfo0MM0sHDw+bnP2WFOO8YkTDSB69attpnyPGAWE0SulWGc7f
	 PUKnED6U1YR1LqCP7YagQOtgpZX5XZWtfOEG6ms3DJL1o7viiSMAiPqmL0IB9Ql3lofEY
	 puW3uyUDRR6vPipLgk+8tAhRNRaPYhCySS7tZetgYTTHLLfhRpeD8MCeVscVd2+xChVYL
	 ishhxVmiB3VWFllqk+EJ80gpboONyu91crNA0btDXb2WsxLhlm8v1JQ14Knlu/lZOiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vy0geyjgLdc8QtJYK6Lu5icg03P0jj8Ss2jVOK+gqPw=;
	b=J9CtCF/pAZYZgQFLE/ZAHck4CPXySMWOx8WYkJpEpw/Cb02AMjdzDeM2X9E00vNCyHpo
	 M+5ycAVb6QHrKlNZbE/GjmPZhMqOZ30MydNcg2/3FvQthZ9rJl4+mdHIgM53kKtfOboyu
	 ayLgFde4A4HpuJZAtafudBCghiyJj0iDTy5mzqtEdZxKuYlRqGMy5Ih2E5mmhbUvpEb8T
	 IrvMOYSji5ypRhynoRsDDWwvQ5Oyx8cVe2035S/jNIQgUgkWCUBgy9voVELg5Cji7W8Qh
	 svEAeHmJVD2IuSY+Uf7GC/GSHg9P1Pq+ta84SRYcGMsf9X7XVhTqEqyvBx/ScPMYtkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BzKHJnn9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CACB606A32D;
	Wed, 25 Nov 2026 14:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BzKHJnn9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14A91F000D3;
	Wed, 25 Nov 2026 14:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617898;
	bh=vy0geyjgLdc8QtJYK6Lu5icg03P0jj8Ss2jVOK+gqPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BzKHJnn9Vr5d7ujJXhfLmaX44L4k7nZUvYgZ53SD1TyntXYV+YUNEt96P37vQqeuM
	 sjhskD2S0yu5zSxmJ9btm4e5qRvziy1tIOb26hldVJbvg+RYHQ5LP3MN2+ZZSXRynM
	 IcDzHA5RRChofmdmi08+CKaYSaN5VItj6zoyQHss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0108/1005] bpf: Set a dst for test runs of lwt_in progs
Date: Wed, 25 Nov 2026 15:24:06 +0100
Message-ID: <20261125143824.276356817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit c1ca06e48e8848743fd876a1dc6b0f57bc76d23e ]

When an lwt prog runs on a route, the skb always has a dst. To push an SRH,
bpf_lwt_push_encap() reads the device from this dst. But
bpf_prog_test_run_skb() sets a dst for lwt_xmit progs only. Thus the helper
dereferences a NULL dst in a test run of an lwt_in prog.

Set the same dst, ip6_null_entry, for lwt_in progs. When IPv6 is disabled
or not built, their test run now fails with -EOPNOTSUPP too. An lwt_out
prog cannot call this helper.

Fixes: fe94cc290f53 ("bpf: Add IPv6 Segment Routing helpers")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-18-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 3043a7393c29c..d6c9dc62182ee 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1210,7 +1210,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 		skb->ip_summed = CHECKSUM_COMPLETE;
 	}
 
-	if (prog->type == BPF_PROG_TYPE_LWT_XMIT) {
+	if (prog->type == BPF_PROG_TYPE_LWT_IN ||
+	    prog->type == BPF_PROG_TYPE_LWT_XMIT) {
 		if (!ipv6_mod_enabled()) {
 			pr_warn_once("Please test this program with IPv6 enabled kernel\n");
 			ret = -EOPNOTSUPP;
-- 
2.53.0



