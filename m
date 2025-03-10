Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69BE2327AE;
	Mon, 10 Mar 2025 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626503; cv=none; b=Ymvksgv0Oth+D8dbjZ1+qev2FeTACd8c+PhW61oAgxK4KHIddknPZXZsU8Yma8Xzbtjp1qobpEDZaskbtMNT7TmyYZ4rk4DiOrGaAApKcO383klVFefRSoSXtEt9h3Sw0ukwVI3YP4SU58oZYWL2heVzuAhGy60HiDy6o3w9BIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626503; c=relaxed/simple;
	bh=FzBrZ7hES62Bpzp9qtMmWl09m/7R4iPxK/20sKLM47A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPKbz5MedqIKXoE2AGgpsDnJ4Zkm/rkW20nvS+p7bUEzpDn1rsXuCCbMtTscr16c3Q+3uvrR2VQJ0ffV2GHMjTk4m9YRHHmUYmpY289NEWo+okNUwREpIJmIYs+7QsE/NseBk+pH87fkturN6hpPlaSijjmA0vcCSgvESE9THeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQfuwVbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQfuwVbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1498C4CEEE;
	Mon, 10 Mar 2025 17:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626503;
	bh=FzBrZ7hES62Bpzp9qtMmWl09m/7R4iPxK/20sKLM47A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQfuwVbtPQb2TcVUhrAQQMVf3500yczYmguCIgdjxX48e6kP4X7yWg53h/XF8A3pq
	 4Zhq3wuzgQtNjmDoPaQFRcgS1Y5l+q6rWZdDHaqMlrXzURT+MRkNXI+vOSaa4r0+MS
	 iAlVc6QKaQmkUJxudjddvyurAY2j4UvAw9slirfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.13 015/207] LoongArch: KVM: Add interrupt checking for AVEC
Date: Mon, 10 Mar 2025 18:03:28 +0100
Message-ID: <20250310170448.375709234@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


