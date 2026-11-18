Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027216;
	b=IGUuBK1/TQ5krjzC5kRRaP6OlTfPFqpn9aOCtgYA/2dS7XHMA22TSes/n3RpEv0KHt0V
	 HrIXeKt63bzdaoajfIc9QGk6PJJtv7l0Oa6Mbhkg1xPtbzKY2IC4qxUZmuHoxXd/eGoAw
	 u1KFav6+56TkmogtQLTU0nQ0jxm/7TUlIwUBJljB6KXKvJIvNeeKeVcLAwA3n29qFExhf
	 L7y7DqHUD14OPf8HSjftUifpzMz4jTB5Z3YCOS9Sfq1ZvCLS2AbKSbayzofNzN/LZnuLQ
	 Lo00kDzfSHljfLyMYtBLtmIRwCSsE/25jj4yhSp3+//8FyHxx+c9181OTZnmM44/o0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xOHI8477SkQ5M6XfvkCuI8eG486QvKaUKXpVOEfb4l8=;
	b=xtdivy/qOWO1Ni6AjaltQyHDUeNBhxaCEHB9e9h/2TRNsMB2kVCpp/l/W2U5Jz8o1vFs
	 3L63u4JT8jJVPjM+kfzn+5T+JJ7/77MAl+yIWSpCGA1JETq66VuPPbh/VF7Wkw1c6kpPZ
	 fVcBRVGLtuNJF8ty7m/lmGrR3io4Rp4GUhUiGxsNCpqv1wvRB+7Ct62xinsoLOKNo/1KW
	 noUilw1EyFhoJ+maeyimnuwRQhQFWNT1Gm0o6jvxaKtKJ0xnu/coSmP4CnlvS+TUqd29g
	 ylHMmWeWZwOjMRYPck+MsRniNR6Iumiy1skt4y25EcvcNGBUuiPeDUP9Jd9RCh8cJEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f0pzfCGn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED5C606A320;
	Wed, 18 Nov 2026 18:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f0pzfCGn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AF61F000C6;
	Wed, 18 Nov 2026 18:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027215;
	bh=xOHI8477SkQ5M6XfvkCuI8eG486QvKaUKXpVOEfb4l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0pzfCGneVCEjov5MexkcfEUs+0+r9eL1dWn8DSpxWCHN45iOEXdonZCtahXPwHDZ
	 EMtQraFcjd7617xz6Ih7JkrJhmzuRUmMpAt4OZpPrYtOwA/DfWksGAre1TAKp4fwDi
	 dWFCwESCyRx0LH2bdWRpXkBD/muuQ/gEb0LdsoR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Monnet <qmo@kernel.org>,
	Tianyi Chen <hi@tychen.cc>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1711/2151] bpf: Dont echo user-supplied map info fields back to userspace
Date: Wed, 18 Nov 2026 15:57:26 +0100
Message-ID: <20261118150224.150125290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 458575e1f2ddea944d679fe778c92e370a9b61a4 ]

Commit ea2e6467ac36 ("bpf: Return hashes of maps in BPF_OBJ_GET_INFO_BY_FD")
started copying struct bpf_map_info in from userspace in order to read
the new hash and hash_size input fields. Before that, the kernel ignored
the contents of the user buffer and returned a zeroed structure with only
the output fields filled in.

Some output fields are only set for certain maps: btf_id, btf_key_type_id
and btf_value_type_id when the map has BTF (and btf_vmlinux_id for
struct_ops maps, ifindex, netns_dev and netns_ino when the map is
offloaded). For all other maps, these fields now return whatever
userspace passed in before.

This breaks userspace which reuses one bpf_map_info for several queries.
Restore the original behavior by zeroing the structure and copying in
only hash and hash_size from userspace before the output fields are
filled in.

Fixes: ea2e6467ac36 ("bpf: Return hashes of maps in BPF_OBJ_GET_INFO_BY_FD")
Reported-by: Quentin Monnet <qmo@kernel.org>
Reported-by: Tianyi Chen <hi@tychen.cc>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261016191635.662690-1-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f5eeaa0090875..8e4689034b422 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5301,7 +5301,11 @@ static int bpf_map_get_info_by_fd(struct file *file,
 	info_len = min_t(u32, sizeof(info), info_len);
 
 	memset(&info, 0, sizeof(info));
-	if (copy_from_user(&info, uinfo, info_len))
+	if (info_len >= offsetofend(struct bpf_map_info, hash) &&
+	    get_user(info.hash, &uinfo->hash))
+		return -EFAULT;
+	if (info_len >= offsetofend(struct bpf_map_info, hash_size) &&
+	    get_user(info.hash_size, &uinfo->hash_size))
 		return -EFAULT;
 
 	info.type = map->map_type;
-- 
2.53.0



