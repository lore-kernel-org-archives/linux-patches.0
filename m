Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623250;
	b=AGOABi9GlJv9K60MWGD4b4XHpqPksUrVldk8mMVwa3tDwR+1bThBUM4t4CGfOxdHcWS8
	 zl3axiZpwLG3AEbi66oCagtWU0/d3nBSXX1OD91aq8kH9N4yEIAkQU8F4raiAKbgUkAsH
	 mgJTZS99wfR1gQ4B6G0OwC9VuQMDjV2h0ZNacNoZC017+NfbatYaraDsoCCUGtqUnqwrn
	 ti3Z9tl2HzIleKCyKyclqwmdo1jlxn0d76Fwvmcfikq6Bm7AT9Jgv7MxTPqyv5LCZCLkX
	 WY/nlB/XfYicb3vRKrEBfQgca6+pIkQ2kBsDio9Kq5IltWuALvMDsK/v1yRPcuhbliQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=icMzqrq/a38eWzZ3zJGd1onK7M2FMj4yew+1KB6wDW8=;
	b=tUBkwHZdNkUmc3YaJuAqcl0GqErpaIcu7rKeZh/S4lsk62Oc4OeP7F81EwK9Tcx/zhcy
	 KITqrUed2/j+l937nGlJc/lsJ94rxdQM/5+4nIf9uNqcwuzL87OxIL5nyz2S3f2BA1YQO
	 W9WOa17Xf3bLp8tefxrKPyBm+nHFDd4+AwAEMgcVotPfdxNGSfrv2pImhUcn1txmSMoMl
	 hHW3keCNHJ0QZ46nj2UHVxoc8yitg3sNzKnOByQQdK9m532tHCWFntYJFn/QBdVI5ThYi
	 tUTsgSyFxPcz8+Da5+83YlnXgwSlyN2/6+bANolEYwZa17uwa//ahBRTVrxEAKyOISg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bo8OwTXt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB595606A31E;
	Wed, 25 Nov 2026 16:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bo8OwTXt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D834E1F000C4;
	Wed, 25 Nov 2026 16:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623249;
	bh=icMzqrq/a38eWzZ3zJGd1onK7M2FMj4yew+1KB6wDW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bo8OwTXtEA6WURBIUveMzz6rDfkPzwnod1qA5ApCNMgPUx/k+8HXoxECIGpIk78f8
	 E1RI02T9KRcII9Nxb9rEhi4KkkKyVJzt2sjlnuvgHaeF5E4/2EfJWVpKrBc6kbC9bz
	 fHZMzFstNyhLrNiv88xpOkxKGmV7X56+6w/sY3KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 799/990] LoongArch: KVM: Reject repeated PCH-PIC CTRL_INIT
Date: Wed, 25 Nov 2026 15:36:06 +0100
Message-ID: <20261125143840.761291328@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

commit 422e532809572ba1043192bf6a0c653bc68b3140 upstream.

KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT has no guard against repeated
invocation: every call overwrites pch_pic_base and registers the same
kvm_io_device on the MMIO bus at the new base address, while the
kvm_pch_pic_destroy() unregisters only one bus range. After a repeated
init, MMIO to the stale ranges computes its register offset against the
new base address and silently reads 0 / drops writes, and the leftover
bus entries persist until the VM is destroyed.

Reject repeated initialization with -EEXIST, using the initialized
state of the kvm_io_device as the indicator. The check, the MMIO base
update and the bus registration are serialized by slots_lock, and the
real registration error is propagated instead of being replaced with
-EFAULT. On a registration failure the base addr and the device state
are rolled back so that a retry can start over.

Cc: stable@vger.kernel.org
Fixes: d206d9514873 ("LoongArch: KVM: Add PCHPIC user mode read and write functions")
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/pch_pic.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -273,16 +273,25 @@ static int kvm_pch_pic_init(struct kvm_d
 	struct kvm_io_device *device;
 	struct loongarch_pch_pic *s = dev->kvm->arch.pch_pic;
 
-	s->pch_pic_base = addr;
 	device = &s->device;
+	mutex_lock(&kvm->slots_lock);
+	if (s->device.ops) {
+		ret = -EEXIST;
+		goto out;
+	}
+	s->pch_pic_base = addr;
 	/* init device by pch pic writing and reading ops */
 	kvm_iodevice_init(device, &kvm_pch_pic_ops);
-	mutex_lock(&kvm->slots_lock);
 	/* register pch pic device */
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, addr, PCH_PIC_SIZE, device);
+	if (ret) {
+		s->pch_pic_base = 0;
+		s->device.ops = NULL;
+	}
+out:
 	mutex_unlock(&kvm->slots_lock);
 
-	return (ret < 0) ? -EFAULT : 0;
+	return ret;
 }
 
 /* used by user space to get or set pch pic registers */


