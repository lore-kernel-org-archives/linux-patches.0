Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624130;
	b=Rhvy+JbUpyPiCmjnQV87pIZFmRYt65IXt6RCZi2zXeKb8t1J4N1ZUX8smWUuBThaZbAQ
	 LM46u/2IY3SEnvIXgDFvmw6KnJxmiokBfil0y8sKCL4AnOyFw/atE5qIenWoACuCguGER
	 Am0biGesFcdNjGb59DUe7TMBM+r2u9uXrWHzpFSW/Jh8wWOtqaQACWcxpv06wUCM66xRq
	 0umrmCd7ZU672davjj47aw+MkrlcdWhMtXIN90kIy9ieohobTllUKK5TeUDkADBgRk5RV
	 7qIfk9m7v8OQXld8vUcttiDLaZbCDyoBfD8ugMpAPw+H5/CfXYDcoYqwby9IjCfG+Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d1vzy3ST7twEJjdBbEG3lIcMbIRglIl7/8pqeAcJpSs=;
	b=T63woG8En0xqI/Fln+EYv7EodrFFipf3K9Un7gpqQcZRWaerqQvxoO4+50TgNHk2+EhG
	 zfSI6RKw0xgeoVARuJs3ZN7mIWzwcxBKhfeFkJRYheoTK+Y4VO/ZcdE0GglyZEpJZxgos
	 pSzPsc2JNs9bndKI7aI6/xLMekxQ9ptKmUHlaiYjXYqrewRoiClX7dx8mCqga6q5HqbP5
	 gMHRDYgxDCJUNdl+zVpZOnZrb1EcVmwp2YZ0uTHOr+GSBpOBJQLqbgbIUh6MOTj9jLTPW
	 3dnWqSWeGMwV0oGQpqGa64sgj9s0/tRRVptm0Sj69JpuZ0Yf+7eMkGdmIUFopdPcz4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qemqXw4J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAB4606A32C;
	Wed, 25 Nov 2026 16:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qemqXw4J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4796F1F01803;
	Wed, 25 Nov 2026 16:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624129;
	bh=d1vzy3ST7twEJjdBbEG3lIcMbIRglIl7/8pqeAcJpSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qemqXw4JgaS2Lj1X265Vq4RKLejK4ZYe+kTkildgwUkvicsG+sS2Fvh16UrgH4e7K
	 KLLBl/w6eU1zOolPQQDMSoL5vykDu7gOdkc/xioCtV4PJ9PINswpXN84pQSnyhengZ
	 VYxs7NUwFED3gBYhnHfe2L4D5WNCPGlQVGhPOnvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/816] bpf: Refuse to map an arena at address 0
Date: Wed, 25 Nov 2026 15:27:24 +0100
Message-ID: <20261125143851.441800970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit ca580b034380fa9a69cc973637d1859ec4f5b344 ]

The first mmap() of an arena sets user_vm_start and user_vm_end. Each
subsequent mmap() must use the same range. The value 0 in user_vm_start
means that the range is not set, but a mapping can start at address 0. Then
arena_map_mmap() does not check vm_start and sets user_vm_start again. The
range tree counts pages from user_vm_start. With a new user_vm_start it
reports allocated pages as free, and apply_range_set_cb() fails with
-EBUSY.

An arena at address 0 is not useful, because the verifier rejects all progs
that refer to it. Return -EINVAL from arena_get_unmapped_area(). It runs
before mmap() removes the old mappings in the range.

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-4-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index c62c6f261ca07..598920ac256dc 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -341,6 +341,9 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
 	ret = mm_get_unmapped_area(current->mm, filp, addr, len * 2, 0, flags);
 	if (IS_ERR_VALUE(ret))
 		return ret;
+	if (!ret)
+		/* user_vm_start == 0 means that the user range is not set yet */
+		return -EINVAL;
 	if ((ret >> 32) == ((ret + len - 1) >> 32))
 		return ret;
 	if (WARN_ON_ONCE(arena->user_vm_start))
-- 
2.53.0



