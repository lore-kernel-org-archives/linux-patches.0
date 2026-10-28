Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216151;
	b=uPcynJM1a5xiX7jybPl/NCaKa4LO98v4QsiPAGt5uRNG+1FZpqBC0xvLXHvyPI+tOsTD
	 1AwTYloKB6qhKk0tOLxoytiMRfWD3irXfzJWk7hp5xn4R1Y+a/OdP7W7Uzft2kLYfxvhe
	 nO8XQWOaVHEbZ4IqaufG7mxwAT3OewCGC34V5e6gJfUhnmjtQQJgmfIQWQn4TVf1aMuK4
	 mtUiRHOJW1bijhaTyCkM1bd7nFw+NaQxTweURGIdp+uwXijJML/8/VTuj7xQqyCAYchAn
	 XFq089bKSa5yYIx0rsMWOMNcbK6knY0FfFdgpvnrIWQXEsUJ7FXpGe9/MNz7HZv6HGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9LPQ0jY+DVvfEiKJmLBmNuKWAF8PCKNqy6oyytzE2JI=;
	b=O+Z+hwTbZNATJ8aC3HFZGbwSGzGsI7zaFqxd8WUe2gul85VLNDrlrQSBH8ueuV0kRYdV
	 8Jz8WMg6paI7fO+68/ogBOVmjdmZVfph+qHbi3aU9OvUclcbw+Awx4As04aVxp7kHBEKq
	 pIEtV0MSyAiKEektSULIba5Cubxaapnq5TCLLh0sGNi0ONr1yZ8A5XPDpjLzpvl16fB8O
	 XkEIBpxBPd2HWFqwdX7a5ibdTK8L/JkCAeolIr0vtZV1I1q0FDfUm4RWx1f6J++C646nw
	 1QJA1CVWKNP5ve01h7fUY0ok73/s+MquG23xrGF8162KQ3OJJHEwUtTPEhYO+KsVY6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jxh1VV1T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC265606A31D;
	Wed, 28 Oct 2026 19:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jxh1VV1T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2614D1F01825;
	Wed, 28 Oct 2026 19:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216150;
	bh=9LPQ0jY+DVvfEiKJmLBmNuKWAF8PCKNqy6oyytzE2JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jxh1VV1T5jJO5R4K9IHNxKCP4LHZmGsG7QlBdA+hoFaYIlAPzrruXejqMv5swGdFW
	 TG26UiUO5xbJlDTxXRbS5rs9aS8xSRiZZFsOtInraI1kaG+SDg3XbGj0ZOCMnKpGtv
	 kGnZE3CIZD+PMI00M85MAuU5LshPIQdKbRuvg4VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanglong Wang <wangkanglong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1456/1887] LoongArch: Move jump_label_init() before parse_early_param()
Date: Wed, 28 Oct 2026 17:59:12 +0100
Message-ID: <20261028170532.593784622@linuxfoundation.org>
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

From: Kanglong Wang <wangkanglong@loongson.cn>

[ Upstream commit ea68d444a658783234a06f05414e41cf93a18fb2 ]

When enabling both CONFIG_MEM_ALLOC_PROFILING=y and
CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=y, then diabling memory
profiling by adding the boot parameter 'sysctl.vm.mem_profiling=0' will
cause the kernel failed to boot.

After analysis, this is because jump_label_init() must be called before
parse_early_param(), the early param handlers may modify static keys by
static_branch_enable/disable().

Fix this by moving jump_label_init() to before parse_early_param(). The
solution is similar to other architectures.

Cc: <stable@vger.kernel.org>
Signed-off-by: Kanglong Wang <wangkanglong@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index ed47cf6714dfe..439658695f7b3 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -428,6 +428,7 @@ void __init setup_arch(char **cmdline_p)
 	efi_init();
 	memblock_init();
 	pagetable_init();
+	jump_label_init(); /* Initialise the static keys for early params */
 	parse_early_param();
 	reserve_initrd_mem();
 
-- 
2.53.0



