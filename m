Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020934;
	b=c3obT1fFDSU2jDFvi0VfxcT7uxa46alqJWwDzBeO3sOq1FwJXT5Lomayjzr4bRL6Be/S
	 MI8eHxDe5vGlaGjennbOGRusOScnLD1JDyA3gFYaocvfMkWMrwYhfaEqlZPnYgdxmlCSM
	 /Zu/OpKrl/AZSAo/nequxKjUB9h5mLlBcFDfeA1fKVY/gjeVfro7KzghwrmNW+OPs7sXM
	 ARCvKbrBX6nSpuM4NOTCBf7RsscHJFozpwbsP3Lco0y064frvDiqaYC6F1GxBUuEKXqWT
	 rKfsq8VOIE0gLqDvz+4keCyyUFgjnB9rYJCgYGobyP4eB8Z0YfrPzQ20zC3R2+h/U6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cNF/NjHMZmvAQdRdEzf9/OsZ2moTQSev5pI9OWOrj/g=;
	b=bV3YZ4UQ4TAzwlmWPljFve+B7rFLIMaSFzkniftkBqTpWwP3+sGRbcOK+qaEWoaS2uUo
	 CvEyLg85Ko0w9BCFJ+85VsEKDEm5QjSMVtF2f2oaqL8g7Z3XfxaeTZvG7yL0XhBpkIvoI
	 IpsU3mh+bO2Wkf2ABRZWEjJgPhvYOK/XO+p0IjiWuRD7/3xzxz3blt3w5N0++E0C7BqS0
	 vsi93v2AvLsbmv48Bjw5Z0iExcSyhY8YLyMuU6wdIUKONYt+HaVY/zfDk/uaIvLl4N6XP
	 Y8a5QUmS8o5B0RoyInvoyRTwmYpVbz8TN7kX4GmU3346r/27yQW6c4NdJ8VPkivAp2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sa8ymq0l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACE0606B59A;
	Wed, 18 Nov 2026 16:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sa8ymq0l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8991F000CA;
	Wed, 18 Nov 2026 16:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020934;
	bh=cNF/NjHMZmvAQdRdEzf9/OsZ2moTQSev5pI9OWOrj/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sa8ymq0laetHIClBD3ULJsZKMUuqqA72fuIP4PW1TzzuiBsXp6cliIVbVVXBrl9LJ
	 de/d4tI0WW3Ukq/2zQnmG2q9hmkuCQKONnDr0nVxpygoHtcRhT0T5F+NTlRuv6UMb6
	 sLTU3oUyfVCGBf21DGjmdMlNh5KEtSS9h+dZXEdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2127/2651] bpf: Let bpf_dynptr_write() mark a global function
Date: Wed, 18 Nov 2026 15:56:07 +0100
Message-ID: <20261118150402.472911044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 589998616e0f9190ba6f6644a19532c5b2ba66d0 ]

The caller of a global function loses its packet pointers if the function
may change packet data. That is found out by a scan for calls of the
helpers which bpf_helper_changes_pkt_data() lists.

bpf_dynptr_write() is not on the list, because it depends on the type of
the dynptr: check_helper_call() looks at it. The scan cannot do that, and
so a global function which makes a dynptr from the skb, or gets one as an
argument, and writes through it counts as harmless. The write can
reallocate the head of the skb, and the caller goes on with pointers into
the old one, which has been freed.

Let every call of bpf_dynptr_write() mark the function, as a tail call
does. The same mark decides whether a program may replace a function.

Fixes: 51081a3f25c7 ("bpf: track changes_pkt_data property for global functions")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-10-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cfg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/cfg.c b/kernel/bpf/cfg.c
index c4c3badde6c9c..5501ccc6649f8 100644
--- a/kernel/bpf/cfg.c
+++ b/kernel/bpf/cfg.c
@@ -529,7 +529,9 @@ static int visit_insn(int t, struct bpf_verifier_env *env)
 			 */
 			if (ret == 0 && fp->might_sleep)
 				mark_subprog_might_sleep(env, t);
-			if (bpf_helper_changes_pkt_data(insn->imm))
+			/* nobody knows yet whether the dynptr is that of an skb */
+			if (bpf_helper_changes_pkt_data(insn->imm) ||
+			    insn->imm == BPF_FUNC_dynptr_write)
 				mark_subprog_changes_pkt_data(env, t);
 			if (insn->imm == BPF_FUNC_tail_call) {
 				ret = visit_abnormal_return_insn(env, t);
-- 
2.53.0



