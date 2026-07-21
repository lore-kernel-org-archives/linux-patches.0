Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC1E415F09;
	Tue, 21 Jul 2026 18:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658004; cv=none; b=A9g4xxpustrVABHX8gxlFh/0bHzpArF5QNIaumqU5aSH8WYgot89c/ZNrdwT8hfTSE6iE4Dbc/hxMgXbGGUkohA9ao5byV3p21j2fszQxsV4+b7mnGFtFwsY5q+f6eBGi1kq9d5j4eJVvvtiuBU2CZjI4bminepHKgJ+d4moZuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658004; c=relaxed/simple;
	bh=gBL0QvNucG21oQhk+DJyTtgpODZvEYeUfn2Tok+ZUpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lKz+DhfcJcq+qUu+UQMQtLm/aLL4EVUW+ZEkdZXj0sSKLZRs9bzj0M6uz5CCORzD8NIDPP66YgrqD2rLiQXQkIj0CF8jK2A4en8AixgJgh9lRJhx3XlKtnVw6rHAOl6NCsYWH9tAAjSnYpRvSMPPbOY5M6G8dVXN/NlYG8uu5Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3qwXBr8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3qwXBr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7102D1F000E9;
	Tue, 21 Jul 2026 18:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658002;
	bh=fuT5WkIM5ieF17JQwPg5RWOAZOPe+Ql3kZ/q5ZG+vHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p3qwXBr8YxuUZe5aBRYGzA3nb/MpSFAqXvZfuHvVucqOFWlxGoMmMtMMT/p+KpCec
	 xo9Do5moDRxAs8jZYgRlH4asc9lZmOiYj+AnuZ2zWDmbaH4GZzC+sRx0nnI8SW7dRk
	 uBP/OD13gExVWbGB74gQXtm1BaJ8WxKVerI0XtSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20 ?= <Yeking@Red54.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0936/1611] LoongArch: Move struct kimage forward declaration before use
Date: Tue, 21 Jul 2026 17:17:32 +0200
Message-ID: <20260721152536.440559248@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>

[ Upstream commit d4e58d2c21d94282d512979dfa7e045c5034b0be ]

arch_kimage_file_post_load_cleanup() and load_other_segments(), both
inside the CONFIG_KEXEC_FILE block, take a struct kimage pointer before
the forward declaration appears. Move the forward declaration above so
it precedes its first use instead of relying on a transitive include.

Fixes: d162feec6b6e ("LoongArch: Add preparatory infrastructure for kexec_file")
Signed-off-by: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/kexec.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/kexec.h b/arch/loongarch/include/asm/kexec.h
index 209fa43222e1c0..6be136e9f0a06b 100644
--- a/arch/loongarch/include/asm/kexec.h
+++ b/arch/loongarch/include/asm/kexec.h
@@ -41,6 +41,8 @@ struct kimage_arch {
 	unsigned long systable_ptr;
 };
 
+struct kimage;
+
 #ifdef CONFIG_KEXEC_FILE
 extern const struct kexec_file_ops kexec_efi_ops;
 extern const struct kexec_file_ops kexec_elf_ops;
@@ -59,7 +61,6 @@ typedef void (*do_kexec_t)(unsigned long efi_boot,
 			   unsigned long start_addr,
 			   unsigned long first_ind_entry);
 
-struct kimage;
 extern const unsigned char relocate_new_kernel[];
 extern const size_t relocate_new_kernel_size;
 extern void kexec_reboot(void);
-- 
2.53.0



