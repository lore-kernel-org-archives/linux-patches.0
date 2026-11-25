Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620010;
	b=kQif0bkkUb81JF+l6Bx87uoDiM2+SCK3oUrxZLAqEe8UcYf8KhzgC9N/T1NFKshmPpNT
	 ThlenqQ6hwzfbkRVFIyitVJrCCG7msI0zoi5f26g8YeVbt+wlAkzbWRMv+42suXSAeOLT
	 Yj3RyYHBtiEk2YBNCQe0jkaO3bQ7FHeFbJLl21pgvF+WtpgULJzlf/XMJb2RqClnAxuY2
	 vt3fneW3zcfj6QITen1wWCxf5Hf/HPCMJbq92++fW6B35FIfr7b86Ft3UZXOF88KyTJP7
	 BzwIDsjISRL932RuFX775D8TvlPqNZRc9VPJ4J9JYAn6gJkAlicTv3KydSDSBC9GZDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z0nOLLchb9z3e+hSQNhdKJboZ/PjqT5Oi5zTXQpL9ss=;
	b=o4TCmmwn4Gg2z2C1DygX7uVChQAKXsUb8RSLgXW1BszEAo6+qJUdR0A24uMFjm9k2bVO
	 +vz/Rhd0CFJ8uf0m74J7L+W72W/wgyDoiZl7EF1G/IZJ1zKxnTfsA0fyMAgZYwsqftnny
	 wz/VybkmnTNihENdbVB5wkISaTRnFgORjN5UTGNvRy+3yF0Lh93zT8E+/WC4Ij6nCe+xv
	 REhVxCCfxVMDDdBW7Qcsk0SpZkSKV7O1Lkcu/P2UzQVkdQvxiHbgotYmmvgaxdc2AWwBr
	 f2H+HQBDRhVB1eW2GhNOOWoZTeZiL4Qi9ojxM0qiaSQB4FlZ1nNA2+pU4m3/QpydBaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uHmwNbF/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ABC606A323;
	Wed, 25 Nov 2026 15:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uHmwNbF/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585101F000C6;
	Wed, 25 Nov 2026 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620009;
	bh=Z0nOLLchb9z3e+hSQNhdKJboZ/PjqT5Oi5zTXQpL9ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uHmwNbF/xAHJZRKwj9Mxsv9bKOzTuOdrdJmfISvqymWXt/sj+c38kH4mS+Ugm17w0
	 4InIoDmADJxyhA9rKm4X3AmfK9MW0c7su5U7hM/lrjsMs4qlTAYvwopXx9t/1IYKfM
	 BoAvhLIOrKWU8ini51pXhrXa6oMs2+JKSftzWYW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.3 0778/1005] LoongArch: KVM: Clear device pointer in irqchip destroy callbacks
Date: Wed, 25 Nov 2026 15:35:16 +0100
Message-ID: <20261125143839.965828444@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Tao Cui <cuitao@kylinos.cn>

commit a9ce1a00afb0402668877d37c04ffd0e53d48832 upstream.

The destroy callbacks of the four irqchip devices free the device
structure without clearing kvm->arch.{ipi,eiointc,pch_pic,dmsintc},
leaving a dangling pointer. ops->destroy() is not only called at VM
teardown but also when KVM_CREATE_DEVICE succeeds and the following
anon_inode_getfd() fails (e.g. under RLIMIT_NOFILE); the VM stays
alive, kvm_arch_irqchip_in_kernel() still reports true, and interrupt
injection dereferences the freed device.

Clear the pointer when destroying.

Cc: stable@vger.kernel.org
Fixes: c532de5a67a7 ("LoongArch: KVM: Add IPI device support")
Fixes: 2e8b9df82631 ("LoongArch: KVM: Add EIOINTC device support")
Fixes: e785dfacf7e7 ("LoongArch: KVM: Add PCHPIC device support")
Fixes: 229132c309d6 ("LoongArch: KVM: Add DMSINTC device support")
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/dmsintc.c |    1 +
 arch/loongarch/kvm/intc/eiointc.c |    1 +
 arch/loongarch/kvm/intc/ipi.c     |    1 +
 arch/loongarch/kvm/intc/pch_pic.c |    1 +
 4 files changed, 4 insertions(+)

--- a/arch/loongarch/kvm/intc/dmsintc.c
+++ b/arch/loongarch/kvm/intc/dmsintc.c
@@ -166,6 +166,7 @@ static void kvm_dmsintc_destroy(struct k
 		return;
 
 	kfree(dev->kvm->arch.dmsintc);
+	dev->kvm->arch.dmsintc = NULL;
 	kfree(dev);
 }
 
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -675,6 +675,7 @@ static void kvm_eiointc_destroy(struct k
 
 	kvm = dev->kvm;
 	eiointc = kvm->arch.eiointc;
+	kvm->arch.eiointc = NULL;
 	mutex_lock(&kvm->slots_lock);
 	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device);
 	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device_vext);
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -444,6 +444,7 @@ static void kvm_ipi_destroy(struct kvm_d
 
 	kvm = dev->kvm;
 	ipi = kvm->arch.ipi;
+	kvm->arch.ipi = NULL;
 	mutex_lock(&kvm->slots_lock);
 	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &ipi->device);
 	mutex_unlock(&kvm->slots_lock);
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -483,6 +483,7 @@ static void kvm_pch_pic_destroy(struct k
 
 	kvm = dev->kvm;
 	s = kvm->arch.pch_pic;
+	kvm->arch.pch_pic = NULL;
 	/* unregister pch pic device and free it's memory */
 	mutex_lock(&kvm->slots_lock);
 	kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &s->device);


