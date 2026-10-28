Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215384;
	b=UEXXPMefmBJTm1jVzJC4YrCGnjNEfzBqr2hwCwpvQkPzuKUzHmamU7nswnE1NGG8RS/8
	 HCgR9WETfh7fqpYxzbGk3OuKa2bpvZVs577d8GlhEQwcL+r2YLcCRv2yF8Js1t7ZIa280
	 5TAj7LT6YyYNhat4t0jnfznoqcDxuy9YVtpfOStGiNS2XH4RP5adCIuzs78A1902+0sP/
	 Jg9bzLiahGxdM34xPDnf4Ee8okycuKTkIj7nHrjaXsIUOfawBhB7p47DpzWCbz8RV5CWx
	 LyiM1O+NiTT0XGh/KgqeJxdxPeSedyVKV++ubjT0NbW4a+MSi9nwc937dtURSCl+QIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2PLO5NukAz5JxNHb2R9KRAIziz9SkVOZ1qbfBcvc1Js=;
	b=QU9LUIt0pgTroqD5iXb6zlYyT9PAh4bF9e0IsfD4NGCn2honu7EKHsQ7BYGAKNT5Vzjh
	 qK8OhVwcgtcZrK8lW1IN7uftBLsBtX99Bf5Osh1MPpo5zhRD0a7xScnW0Orq/QkZgpOMJ
	 fUdywKp/Dtbcc/uKAk1lxG+FGEyNqesddDiYebQpwoxxdnf7IZ8nZVFAsj+3ZUKJ1E1B6
	 y/2oJUj5M+HnBHMn79yemEm8fwFzrqoqUsl2c3JdmABZF4Yd8IlrgkUQ+0o5RqPHIm73m
	 9hm+Xj8wdf1w2JNRK3N0TwK3AmYlXNKBgRn/r0gDiXyteRLLvbTPLsnKwyabxPJ0Ycg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uRk/L27n";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323AD606A31E;
	Wed, 28 Oct 2026 19:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRk/L27n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814061F01828;
	Wed, 28 Oct 2026 19:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215384;
	bh=2PLO5NukAz5JxNHb2R9KRAIziz9SkVOZ1qbfBcvc1Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRk/L27nsc2e2iPfdMXLPdSmrh4AojGRo6hZduJCCYF9wHMD459gGCUf+ZCt2hHF+
	 bNXANLsJHZjWQKIPHGiilGBmzhFkTlQDGxNl5Bm7N89HAhdEsGGVT7+YdhearDTKBj
	 XpGtfM1xAcvxC+oFeelpvuF2nPzkxQ1WReL5ss6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kexin Liu <liukexin@kylinos.cn>,
	George Guo <guodongtai@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1193/1887] LoongArch: Fix address space mismatch in kexec command line lookup
Date: Wed, 28 Oct 2026 17:54:49 +0100
Message-ID: <20261028170526.554695329@linuxfoundation.org>
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

From: George Guo <guodongtai@kylinos.cn>

[ Upstream commit 485ed44db5694d8d2e5027f63ad608e705286f30 ]

When searching the loaded segments for the "kexec" command line marker,
the kexec_load(2) path (file_mode == 0) passes the user-space segment
buffer straight to strncmp() through a bogus (char __user *) cast. This
dereferences a user pointer in kernel context, which is wrong and is
flagged by sparse:

  arch/loongarch/kernel/machine_kexec.c:84:51: sparse: incorrect type in
  argument 2 (different address spaces) @@ expected char const * @@ got
  char [noderef] __user *

Here copy the marker-sized prefix of each segment into a small on-stack
buffer with copy_from_user() before comparing, and skip segments that
fault. The subsequent copy_from_user() that stages the full command line
into the safe area is left unchanged.

Cc: stable@vger.kernel.org
Fixes: 4a03b2ac06a5 ("LoongArch: Add kexec support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605051639.aEPioXdD-lkp@intel.com/
Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/machine_kexec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/machine_kexec.c b/arch/loongarch/kernel/machine_kexec.c
index ce4e132ac1373..7c93e9d1f020b 100644
--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -62,6 +62,7 @@ static void kexec_image_info(const struct kimage *kimage)
 int machine_kexec_prepare(struct kimage *kimage)
 {
 	int i;
+	char head[8];
 	char *bootloader = "kexec";
 	void *cmdline_ptr = (void *)KEXEC_CMDLINE_ADDR;
 
@@ -72,7 +73,9 @@ int machine_kexec_prepare(struct kimage *kimage)
 
 	/* Find the command line */
 	for (i = 0; i < kimage->nr_segments; i++) {
-		if (!strncmp(bootloader, (char __user *)kimage->segment[i].buf, strlen(bootloader))) {
+		if (copy_from_user(head, kimage->segment[i].buf, strlen(bootloader)))
+			continue;
+		if (!strncmp(bootloader, head, strlen(bootloader))) {
 			if (!copy_from_user(cmdline_ptr, kimage->segment[i].buf, COMMAND_LINE_SIZE))
 				kimage->arch.cmdline_ptr = (unsigned long)cmdline_ptr;
 			break;
-- 
2.53.0



