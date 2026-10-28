Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216489;
	b=5kv7+3xZ+72ayvCcO/+64jlJ5KQZFMmwcfoO5G13I0/UzhFDeNdmT142sj3JT+lwF7f7
	 L/TWLt46EmpW1wvp96NKP9jly/3CTWh6Q+QJlhZ3/YkwMHEfwBczlk9kRNHVxrHFIr2c/
	 wUjAD1WEcj6mWaTtKC+2kAu/2u38SHnrIGEHy0FLku5NHS8TbeTgHfn7a7iE1CmUX2Jbb
	 KbItvbQxnAjeTtBhinBZl/I/6S+wEbaXR0T1htTiqjGSsDTfMwYfp7wQ+7qIUlbQl8dZt
	 eB4o6kvQnG5r7CxYNd8u0yaM9gNY4fSp6iXzwfBjyriT1kz+HRRkU/FXdnEZrQA0lng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X8ncn5L/x6Q/dvdkhYHzLElt1PV59I6qRGYDJDgKOjs=;
	b=y5GyjwNG1YbWmrU4ydLHYjz6h8qIlzRDddPaFF03f91K6rj5PKL9qQWODJvYo5jGW+kO
	 5cQ3ggz6O94OvDET1KL5b0dhLADZqpjzVzsCo1ukwlUcldphQqUYOp+5QXXx/S1haiyv7
	 yK8Pbi9l3qz9m8p5fsec99lS9J09wgl3U7G/4L160KBeuqu5E0Wj8VFYoI6yttJia/04g
	 O8lOmhUMKy5Kpm8IX3JbyHDjZp19v1hvD1WeqrzHykpTAYaArc9NR/seUf/J1k9X1PUb+
	 1JkbOcX/g8zkfOP4brV2Rgpi0yMU7iuaS+Yqxza/V84aA+V5UDSBk5ttAh3ThuKKBfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N5Q2CXRK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722F5606A31F;
	Wed, 28 Oct 2026 19:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N5Q2CXRK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDADC1F01825;
	Wed, 28 Oct 2026 19:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216489;
	bh=X8ncn5L/x6Q/dvdkhYHzLElt1PV59I6qRGYDJDgKOjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5Q2CXRKDMSoOqnxv1dBuku0NWCbGZnEvCgoLh3jW2aT2E/WR1Q8SluYSiDoU0gNH
	 7UAL3iBuk+RTniJ0DJRNkUTlgR0CmxVFqXer9ql1779jjqHWwLc8b3jzQRmWVOXK0P
	 KPgALs1vcZTmjWQXpYLfPnPl6fHCbBEFXNz1MJ3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1574/1887] bpf: Clear buf on error in __bpf_get_task_stack
Date: Wed, 28 Oct 2026 18:01:10 +0100
Message-ID: <20261028170535.285099933@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit f5d242825ca417bb6afe35fde6e8880f97ca43fb ]

Both bpf_get_task_stack and bpf_get_task_stack_sleepable helpers that
use __bpf_get_task_stack have buf defined as ARG_PTR_TO_UNINIT_MEM
argument and we should initialize the buf on every return path.

Adding missing buf memset for __bpf_get_task_stack fail paths. This
provides deterministic buffer contents, which is useful when the buffer
is used directly as a map key.

Fixes: 06ab134ce8ec ("bpf: Refcount task stack in bpf_get_task_stack")
Fixes: b992f01e6615 ("bpf: Guard against accessing NULL pt_regs in bpf_get_task_stack()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260803210149.296496-10-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index b8df42496f4fe..3de70a1578ca1 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -504,14 +504,17 @@ BPF_CALL_4(bpf_get_task_stack, struct task_struct *, task, void *, buf,
 	struct pt_regs *regs;
 	long res = -EINVAL;
 
-	if (!try_get_task_stack(task))
+	if (!try_get_task_stack(task)) {
+		memset(buf, 0, size);
 		return -EFAULT;
+	}
 
 	regs = task_pt_regs(task);
 	if (regs)
 		res = __bpf_get_stack(regs, task, NULL, buf, size, flags);
+	else
+		memset(buf, 0, size);
 	put_task_stack(task);
-
 	return res;
 }
 
-- 
2.53.0



