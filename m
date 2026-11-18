Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020784;
	b=ajWjIAEY6Lqv0IfKAR81BYepcJtIaHiAnOlTmmJnbkGRFSPx4II0ifxm1L+1fdQZgmnC
	 doBbwgtfHAZVfrHjpDwzF8Ct9uCrW2m5JcywtS8yspyoOzC00+WBDjscFMmSZt2lLlpYw
	 iHaxYa/VfGer1sm5DvDYYDTw8aSYYsW38lqfEtRjx3CXk0Pa6JLOBZl72chwWB5qDhOwY
	 e/5sIyTF+AQU2V9LSQm5csxaZA9mC1xV9U2HWyLQulWJFLUQ3b30QT47Xi5j2jYOefUDS
	 2zNylprZt/uTsnt+7X8VDs2vApFcQ9QPPihPcA8C6jpcDEIEm0QUMhIUXx9wQHRmR9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nf13rMP/Rn0DAG7khStzzdrHPhWpftl7HSVGKRyuJwM=;
	b=AGPOGdoF+QVP9iHQtodQfa+qXnPhrq7Dh2oGT904f7VaAchwOhfgohWis+buYFE1A3rK
	 5SS22pyOsPhr5mEULvpJrMN4VqHZ+JSi4Vv1F7JJj+NzOImp2MU8V+astNUPRbN5Yz5xK
	 L0sgw+oHGx5Sy6wb0gUlepeJ2fxcU00LFxQgvMTsw1YNWpKl3Z3w6/y6J18TO0J9etpdi
	 K7/0Qo3E0QV32v0Dl1NCB3u+9UiTKU8CNxh0oniaejfWDbF1q4Hg4U2WH3S7a9dU69Rum
	 LoyaoMzY1WoSKUXUmIdy1BZsJ89Wv9UO0kIcnC/gbwgoeTpfLSzE3Ppy6FcVt0hYgAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6NlolqL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4B860A6F74;
	Wed, 18 Nov 2026 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6NlolqL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863291F000C8;
	Wed, 18 Nov 2026 16:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020784;
	bh=nf13rMP/Rn0DAG7khStzzdrHPhWpftl7HSVGKRyuJwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6NlolqLJ4YnzFa48wAR/1+W98vh2Y4eno5+hYPnmKeGTVq3IXetBUQXuRmVfyNn8
	 XMM/IPS8g5WoAZ829a4vHtR3kRvH7zLlT3pv/UggncR8BbF+t3mbE+pRKsdl51fOgX
	 QF0EnK5U7nocYt1LsWaTxAcWG8wvGjMQw+rRVU60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Monnet <qmo@kernel.org>,
	Tianyi Chen <hi@tychen.cc>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2075/2651] bpf: Dont echo user-supplied map info fields back to userspace
Date: Wed, 18 Nov 2026 15:55:15 +0100
Message-ID: <20261118150400.739579890@linuxfoundation.org>
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
index a353e3d4e7d8c..e7b461f33b588 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5427,7 +5427,11 @@ static int bpf_map_get_info_by_fd(struct file *file,
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



