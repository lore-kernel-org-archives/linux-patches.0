Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214757;
	b=DOhZTUaAVGQ0vD4UsZXLXel6oG6aq+CWjgQU0NrBtuGmv9fcVMOLq7N9N/EFV/9ldfpo
	 eZRz5FJVe7Sz+9+vwNVtJNdUgufjwWcAfgFdTk4Q7c8Bvti04oDVZqLChiwH2/g8LItDN
	 /+txi2hcVY9Cz5mKJRgiGBH6VnTniMS3pbCOVEqoq5I+JvSYKTWEFm0VWblJtfe+jzlps
	 BKrRqfmdJyY7h7ulCvP5MqegaZweqYBMtZo9yQ34b8cqIlEaeeQIRx2mn6NgBJxmccx6v
	 U6exBEvRKub6otJ+ouFGID9GbCqjcSz20pg9rA1S+N0I4KdaOIl6TJjF7etzlkM1Q8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ut8sd8PGwrJy4dsT7DpWI0tFvAJZnf3Fhh+4u1Vxv7w=;
	b=ecxVSdciLb8pWPUkAiGI7nR3IObDcZe3PlTj8nN/S7f5Me8zjg5M3UJ8x0xrOgZnGTvv
	 +bmVo6KDB1cm21iCcZSecn4UfnDqq9FKYPq2BrrcG0VF7hDISJPKf2ps1URKTYVRScCUz
	 KmCYdGce2OGXR3SYtX2f291rXrzbZ14FQb903bA7vDYvHEVmaPFaN0VV554wiwI1cwav0
	 qFb0tDXiJDzzYpBYYz+Z/q7cQh0KxrY118q+6o6rxWblkjK1BgtoLF+LcgP20JlHANtgq
	 VewnaEGqOPMOE0tKSZmKZ9epRQT1JONu2edlniwDLGaL8JKmYrpK2ekRuahZzFYsGyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGe4ukkM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5D8606A321;
	Wed, 28 Oct 2026 19:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGe4ukkM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C34F1F01828;
	Wed, 28 Oct 2026 19:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214756;
	bh=Ut8sd8PGwrJy4dsT7DpWI0tFvAJZnf3Fhh+4u1Vxv7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGe4ukkMJFS9sj26/4CiCyYWy+jrkeBE8xmtk4hIuor60vi/GEjhepUWbyuOaa47/
	 nG8QQMSYZE7pWkEQOMJbEe0n3hBEIUNpbOqiL1pXO3d60GZztCfqvsECH3RGJfB+cQ
	 6SjdwB9eFZliCL3bZASHSVcJK3ApTdbeLpizWGrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varun R Mallya <varunrmallya@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0971/1887] bpf: Reject sleepable kprobe_multi programs at attach time
Date: Wed, 28 Oct 2026 17:51:07 +0100
Message-ID: <20261028170521.507882138@linuxfoundation.org>
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

From: Varun R Mallya <varunrmallya@gmail.com>

[ Upstream commit eb7024bfcc5f68ed11ed9dd4891a3073c15f04a8 ]

kprobe.multi programs run in atomic/RCU context and cannot sleep.
However, bpf_kprobe_multi_link_attach() did not validate whether the
program being attached had the sleepable flag set, allowing sleepable
helpers such as bpf_copy_from_user() to be invoked from a non-sleepable
context.

This causes a "sleeping function called from invalid context" splat:

  BUG: sleeping function called from invalid context at ./include/linux/uaccess.h:169
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1787, name: sudo
  preempt_count: 1, expected: 0
  RCU nest depth: 2, expected: 0

Fix this by rejecting sleepable programs early in
bpf_kprobe_multi_link_attach(), before any further processing.

Fixes: 0dcac2725406 ("bpf: Add multi kprobe link")
Signed-off-by: Varun R Mallya <varunrmallya@gmail.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20260401191126.440683-1-varunrmallya@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 5342e0574b9d9..db5484a1dbd31 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2730,6 +2730,10 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (prog->expected_attach_type != BPF_TRACE_KPROBE_MULTI)
 		return -EINVAL;
 
+	/* kprobe_multi is not allowed to be sleepable. */
+	if (prog->aux->sleepable)
+		return -EINVAL;
+
 	flags = attr->link_create.kprobe_multi.flags;
 	if (flags & ~BPF_F_KPROBE_MULTI_RETURN)
 		return -EINVAL;
-- 
2.53.0



