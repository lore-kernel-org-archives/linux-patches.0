Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793CD37881B;
	Mon,  4 May 2026 14:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903354; cv=none; b=Gl/nTkZS+0HmGDN7LN/h79D013bgMxJ2BPCI8MjgETgX+X/BiB4L/7F1y75EI0RTgfsSyKH0VG1xWguazAepl9cpKPtidJy7lJM24AGQJHtwuED0wG2L9RAW09XMBx5O2qyOJDpbo4jz3Nsd4j3nqt2yd5Sx9rrSQ+ROUkzLQMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903354; c=relaxed/simple;
	bh=JQV1H79JvouDNdizm9gJjeqYf1bnu8SlIEWmA++nGY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ly2uvHFPZlXQy9rzY2Ng+6yFGpQvq+gcQMz7EgiupH5X4b9fn8i3FRrs4jEmwDFetK3yx8S0p66J+oQrsPp+4aFYkbKTWC2CMvnNcspCl/K/p2qjXC8xz2IX4QfQaTGYWKkyHyRufY8cZnpoVPSpVBWyja8HHPBu2RKSF/92KtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NEwyh5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NEwyh5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F587C2BCB8;
	Mon,  4 May 2026 14:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903354;
	bh=JQV1H79JvouDNdizm9gJjeqYf1bnu8SlIEWmA++nGY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NEwyh5W+NiVrrL9PXIMtT7Za0w6xhENlhpxjUlZnuoKnaI0/IP7vANGyTd0/1dBe
	 gVaXptGTF3jGGpYvpKLHM1Cujyyy2JPx4mYqg6xAZJKDUQ2CBrnUk4ugg8e3rPiw+1
	 jGhnzpfT+rLrkY8PXQXXrGQv1rAfTWs9Lr8bfda4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.0 200/307] LoongArch: KVM: Use CSR_CRMD_PLV in kvm_arch_vcpu_in_kernel()
Date: Mon,  4 May 2026 15:51:25 +0200
Message-ID: <20260504135150.409037179@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

commit da773ea3f59032f659bfc4c450ca86e384786168 upstream.

The function reads LOONGARCH_CSR_CRMD but uses CSR_PRMD_PPLV to
extract the privilege level. While both masks have the same value
(0x3), CSR_CRMD_PLV is the semantically correct constant for CRMD.

Cc: stable@vger.kernel.org
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vcpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -402,7 +402,7 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_
 	val = gcsr_read(LOONGARCH_CSR_CRMD);
 	preempt_enable();
 
-	return (val & CSR_PRMD_PPLV) == PLV_KERN;
+	return (val & CSR_CRMD_PLV) == PLV_KERN;
 }
 
 #ifdef CONFIG_GUEST_PERF_EVENTS


