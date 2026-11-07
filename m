Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063790;
	b=HHjJtig7ghXGgeM0hziLhNlduUuKEtkT53kccND29OoZ1CdTvQccKWdTFRyYtrXF4nRE
	 sGka4pmqCyhLdqnVZRj33Mgkw1Tk83cTGmMxkh70SIVDW+0iOP8gv+UbydcQlOiwzG1ci
	 gh2IaSJ6rJuak8zCoD1UX7KMIH58UqXLALzW44rypQP983emBRhe4PfqZ9y9FkSMYwkTO
	 ApbmAJYRduEBqVr9lsHopEW7A+yY9C5uIV3FAVHAzQdJXqMZG5flgok6W/jyBDzE4O8MM
	 +m/zaTjPkUKQW0E0aM/Yq5d0xS7nVj+N1GPxjvKh9+p7dkBxzz4RljxSLLlEV+FfckQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FDNgGLa+C89OpMOjFF0qOLbMqMRQT6mQuu8/FbqZ1og=;
	b=me5bi1fJ45kMta9v7BFVLKkE3DbrrY0Cw4lCmwhA1FChH/jf4n1mgcC3SGJq7okhuZcr
	 8NfvlJTBSi3T5hXsSs2z9kTiu/b7npY0ku8ya9psheu7vA17oZCyqqxecjW36jh4VSl8/
	 6qyVPpiuwUnKpQuzx5FO39twPZO6qD6OagxQWpy9nGCP2KlxDHiS7p5TrVXzcDxMWOqnM
	 B1e4YKhmhrAzOPxQhvKJyb0lkhslNo3WFyLlYTe9Y2au8NMLUWfxYEB6KQ0S/hyxX5udp
	 ql1o8LONY7oJGIFYEfZ0ePTVPJlwattlOQDiAuYC1DGlHizGiWmY1IEipNJtQoCyBiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ewyYOq6u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2328E60A3810;
	Sat,  7 Nov 2026 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ewyYOq6u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC14D1F0089F;
	Sat,  7 Nov 2026 15:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063790;
	bh=FDNgGLa+C89OpMOjFF0qOLbMqMRQT6mQuu8/FbqZ1og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewyYOq6unyFLjv1/T3x+yZc6ZfCalFTsLfaTbxM1lp/o3rY8h50pxjLX7wVMkgRFm
	 zwBjLMiDr/KeR6cj+/DICxxF0nauko6mW685jQ1ZqgtvBg/EyxYU4DgFt7DbDMBtYi
	 GpcBlHJtZEBDBG7Oz06ibYx85XG8ay4hlWTkGJ2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Eric Dumazet <edumazet@kernel.org>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 852/869] tcp: check congestion control restriction first
Date: Sat,  7 Nov 2026 08:58:54 -0500
Message-ID: <20261107134921.674950223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit dda51b73721684637ab8e9bd97c78228b99c4bd2 ]

tcp_set_default_congestion_control() takes a reference to an algorithm
before checking whether a non-init network namespace may select it. A
rejected request returns -EPERM without dropping the reference.

This affects module-backed algorithms too; BPF is not required. For
example, after root loads tcp_bbr, a user with CAP_NET_ADMIN in a
non-init network namespace can repeatedly request it as the default
although it is not in tcp_allowed_congestion_control. Each rejected
write leaks a module reference. Since module->refcnt is an atomic_t,
2^31 such writes can make it negative; later module_put() calls warn,
and rmmod can hit the BUG_ON() in try_release_module_ref().

Check the namespace restriction before acquiring the reference, as
tcp_set_congestion_control() already does.

Fixes: 8d432592f30f ("net: Only allow init netns to set default tcp cong to a restricted algo")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/71c142b2d45af6a2fe7fc6cd4a5ca52c53afbe23.1793075984.git.zhilinz@nebusec.ai
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_cong.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index 8e83ef81fc187..e3f462f161dd6 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -288,12 +288,12 @@ int tcp_set_default_congestion_control(struct net *net, const char *name)
 	ca = tcp_ca_find_autoload(name);
 	if (!ca) {
 		ret = -ENOENT;
-	} else if (!bpf_try_module_get(ca, ca->owner)) {
-		ret = -EBUSY;
 	} else if (!net_eq(net, &init_net) &&
 			!(ca->flags & TCP_CONG_NON_RESTRICTED)) {
 		/* Only init netns can set default to a restricted algorithm */
 		ret = -EPERM;
+	} else if (!bpf_try_module_get(ca, ca->owner)) {
+		ret = -EBUSY;
 	} else {
 		prev = xchg(&net->ipv4.tcp_congestion_control, ca);
 		if (prev)
-- 
2.53.0



