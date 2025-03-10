Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0A11B3927;
	Mon, 10 Mar 2025 17:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627370; cv=none; b=Jo/xQXkiWnFR1ULJG8pozXgreTjRISJ9liauj19xuXJJERCQ/zdTacBHBfU38lexQAoNS74SPZE7NHMqYS9Y2Qypj5Oabfjz8qI94NPE1kklw9K35GaCCah6ES89Rte/F4Z0YbCNGYsBzutnFSJLFKfx5Tr2ALheZHKWx8PWneg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627370; c=relaxed/simple;
	bh=ebxCIWjKDHQScFBHatsCHIpyumYca0o3K/bHLqus8Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCYaGWMiLvjoOzSUFxE75vA0O/1lzcZrL0hj4BUx5Bpz8suzqu3pXtjASEdztIOagV8bnId47Jlyoq+1ZBm3rPcB0EkCCBabOk6ThvMZEBxYgd9DZmaA74NSt+Rqc9S3ePnQ6x/kVx42TmT112mxrDjval9epAT/JKvxQsM9kb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/swsmh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/swsmh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7594C4CEE5;
	Mon, 10 Mar 2025 17:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627370;
	bh=ebxCIWjKDHQScFBHatsCHIpyumYca0o3K/bHLqus8Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/swsmh3SXuiqOadZdZmO0VtgXnj5xhckobPRSunHSJTl1LVGG6+8Y70sJ7d+pcxJ
	 XekNaxN2soVa8s+72IhFv5F7VDYp+NuEwFXJ2xkCxswG3m7mlNaD8092r3kYGrddp8
	 CQA5GhAsJe/VRJ2zs2Kfz4OMDKuDOnEux6gIJNnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 079/269] LoongArch: KVM: Add interrupt checking for AVEC
Date: Mon, 10 Mar 2025 18:03:52 +0100
Message-ID: <20250310170500.875785132@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 6fb1867d5a44b0a061cf39d2492d23d314bcb8ce upstream.

There is a newly added macro INT_AVEC with CSR ESTAT register, which is
bit 14 used for LoongArch AVEC support. AVEC interrupt status bit 14 is
supported with macro CSR_ESTAT_IS, so here replace the hard-coded value
0x1fff with macro CSR_ESTAT_IS so that the AVEC interrupt status is also
supported by KVM.

Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vcpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -311,7 +311,7 @@ static int kvm_handle_exit(struct kvm_ru
 {
 	int ret = RESUME_GUEST;
 	unsigned long estat = vcpu->arch.host_estat;
-	u32 intr = estat & 0x1fff; /* Ignore NMI */
+	u32 intr = estat & CSR_ESTAT_IS;
 	u32 ecode = (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
 
 	vcpu->mode = OUTSIDE_GUEST_MODE;


