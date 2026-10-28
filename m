Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213762;
	b=evDmV0HBOeIAxBp2Jv+1Aw4DRqnS+96iXjFmEU+Sl6l9SFK4MMJFKLXFTQj+xatR3b53
	 ik87kmQ5WJmCd2kZlbvUl5OgU1ZYVo5fO1MVOTO0pjSmkr7n4GD0O8rLWEw2tPNAQsIlX
	 0WQgdg7uFbZyqxZnZDf/f/oLu50soZWlxVKnMQfaEZcrsDu/2WJHuUOAh3P96aWxD0sgk
	 WwdN/oCCnx53bsN/e5B2EQvd7BEMquGK+8Nm/PrFLoiscnVoJDDSwdYeLJQkcP3wgFYqx
	 eLNiAxXwmSxeOsc+KKHpcEwjzTxnO6lLE61kyWwrxmmqUWooViaBv//rcLQlao8moUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Eu9G+yGVcQTdAcc5oJKiCKPcMyR34oLIX42fuyRQdE=;
	b=ALhRCddOwuYlFhIZPg+BCH75SR66cuheD7xGy5aD0JuTBirhrgy2UvjG1pAbSyKMcUJU
	 BlbOC2yPc4Xm8dlUIbfo8JMKxeh+nj2ydsF32sBUGbEC5wY/7Xv3Ul1XzLGnKjiqN2ovV
	 LjtAsVlhwyJdcueoAw0A5y+fGW/DzDFNiugCcvGcsL5c5RGrRqW2MD0lqNVRnr9MDyuUp
	 UcLCj4JRe5PtllpOx28zJB2RPSwlByOPKEEkvNzoZik4x6FcuCp3A5QUuCg5O9jqI5Pz/
	 5Mn21ETOBHppFNzX6ATd3o5Gkfg40hry+qHUvv8FjoqGd9HFvl2HT/I4Oy9nBuEye/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIuBCy2a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028BA606A31C;
	Wed, 28 Oct 2026 18:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIuBCy2a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540BC1F01825;
	Wed, 28 Oct 2026 18:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213761;
	bh=7Eu9G+yGVcQTdAcc5oJKiCKPcMyR34oLIX42fuyRQdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIuBCy2aFwx2rtBbUo4/SyNEHGuFVj+G3u4wgUQyLxUvt4fWkjoNpK4xtji1MWLgg
	 UFkL+pFYQiKrJN3YjY2C1t+IWQuglCBMfRlzekHS0uZ5iZ9SWOgL0EEItnp+wpUnIM
	 yNmsziPPfsXOMD5l3iBzwMDCV/qM6YFTF4Z7sS4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+838346b979830606c854@syzkaller.appspotmail.com,
	Stanislav Fomichev <sdf@google.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0618/1887] bpf: Add BPF_PROG_TYPE_CGROUP_SKB attach type enforcement in BPF_LINK_CREATE
Date: Wed, 28 Oct 2026 17:45:14 +0100
Message-ID: <20261028170513.473957661@linuxfoundation.org>
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

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit 543576ec15b17c0c93301ac8297333c7b6e84ac7 ]

bpf_prog_attach uses attach_type_to_prog_type to enforce proper
attach type for BPF_PROG_TYPE_CGROUP_SKB. link_create uses
bpf_prog_get and relies on bpf_prog_attach_check_attach_type
to properly verify prog_type <> attach_type association.

Add missing attach_type enforcement for the link_create case.
Otherwise, it's currently possible to attach cgroup_skb prog
types to other cgroup hooks.

Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
Link: https://lore.kernel.org/bpf/0000000000004792a90615a1dde0@google.com/
Reported-by: syzbot+838346b979830606c854@syzkaller.appspotmail.com
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240426231621.2716876-2-sdf@google.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ec1e0c1a6dd87..e997f7594c975 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3456,9 +3456,14 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 	return fd;
 }
 
+static enum bpf_prog_type
+attach_type_to_prog_type(enum bpf_attach_type attach_type);
+
 static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
 					     enum bpf_attach_type attach_type)
 {
+	enum bpf_prog_type ptype;
+
 	switch (prog->type) {
 	case BPF_PROG_TYPE_CGROUP_SOCK:
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
@@ -3471,6 +3476,11 @@ static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
 			 * check permissions at attach time.
 			 */
 			return -EPERM;
+
+		ptype = attach_type_to_prog_type(attach_type);
+		if (prog->type != ptype)
+			return -EINVAL;
+
 		return prog->enforce_expected_attach_type &&
 			prog->expected_attach_type != attach_type ?
 			-EINVAL : 0;
-- 
2.53.0



