Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402C5314D34;
	Tue, 21 Jul 2026 17:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653479; cv=none; b=JlZfT36HWeBfXKq0/renL25NhEgrvSZogu/v5j3+ifYI5FMn/KN0dC2CEdiw35gCK4pPHqGFIOrry/kPZR7EMFps+j4NrWOTa2HfE5nkik0/KvX1/mgbysXz1ongzg8oLnxcU43/HlgvJyP6m/fDeWxxO9wsc/P+DbG6YQ6rUBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653479; c=relaxed/simple;
	bh=STWDvox20QmSNRec9hOZWkWxZppDJIiACXvtlnO7wtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JUGwuqHUfV4KlGTnu9PSklNRrJRvF5kvg2G2dMg87xpd5LRrgB9Wo69JD6UtJYuuKz5O0LnVJRYmx9vUIRqklrkzHDE9QDb+4RTKrolVQn9SS3UI99aAME1Xeiiown5fZWMHRTtmXXkLg2msfJboNH2e4egvO6PKg5P6QAfX0EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fq1/x8X7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fq1/x8X7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F1A1F000E9;
	Tue, 21 Jul 2026 17:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653478;
	bh=u85SESYFYeG4/oRVGczsKavp/lJaDd3Iju/E5bZLY0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fq1/x8X7Zo9KJ2I4V7V95PSaPRhwKm8Hqtcx4N/bGQYFjVD5RIal+rlsqc6SfOfQC
	 I7c8QENeSoZD7DewYoTeob6K2h1P0PoVMlB40y5Hrk0HYkKO9K0tJqMd9eITHZjnYi
	 HS6W5Y492lLmPEyyrvGJ70s4Ky3VyGUMyKteIEqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20 ?= <Yeking@Red54.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1288/2077] LoongArch: Move struct kimage forward declaration before use
Date: Tue, 21 Jul 2026 17:16:01 +0200
Message-ID: <20260721152623.198868038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



