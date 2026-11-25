Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620018;
	b=2dVPgZNCl9jkUSd307S4Yh6jZEPLHYiqxUzKsx6cLHRk6AELuGv579EfRi2EfyhLCqV9
	 ZZj523GM1e6SsCVujzY8ufGWsgAz02RmQdCv16YsNv3ymYdPNTwCqkz4Q4vvjoTAqcTh5
	 ++Np3W5KtfKdMnL/1fIfELyba2ARzQ42Q4gU+5fBXkQEbqwxtYE0pIsZTMmAz9Pg5S/5t
	 PghieXkgU3FtLiNkP2Jl5f/+BEn1mwN9AxYMb3HTRG3GJhQpdYlXU6zAt3K/3eQvc0cX1
	 WeCV+27C1uNjzrYAKnLkREH6dQ+C4OA5R24U5LxZYmBBXY+1pyNsEjRsBsgdlitJppQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VKZM7a/Ea5h6aGDXjJEMU1urGGDma9k/FLj8DizB5hI=;
	b=OQ9ZHBd0+O6vlYSEjrz60G/OB580APS1I8ogSkpjSCEWFecCRUHmJovSnXRUkKyLDc4T
	 koyEfNFk2DThn/pnRBXPh4uL3A5bfvHZ3wLTU1w+qdqpizFKr2w/AaiI1jDQekZhjdGTv
	 Rw+f++xoDstduf2ohLYdott7sTT3Lix84SyHQhSXdpx+w2xBbIpH9fW1umeEubxW7JSbR
	 uiM3m1OpjYcF7h14+WNzyRa+2WrwYEnr1vhIVNly0pnR/nmHTgnVd/XTHKNaM2KCxPscy
	 jb57O0Jx196XBwuUdz3W8bJ01mWuTh6SymGPP6x/2zXslkmb6VlklQtuD09Iilejn5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h7NvQPyy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AD8606A31E;
	Wed, 25 Nov 2026 15:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h7NvQPyy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C401F000C6;
	Wed, 25 Nov 2026 15:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620018;
	bh=VKZM7a/Ea5h6aGDXjJEMU1urGGDma9k/FLj8DizB5hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7NvQPyyC6SEDMmZWwaZvc14w8W7JrC4M3J82VasH4mI0PbXXEToQdQB/SJlsPz8O
	 nSPP0ZNv5UsS+n60Uw6IpUnnOp4vglyHtudLVYWiTgmyc9bBsEOLVNCKtTtyjUSacw
	 TIY9v2mx1lyEY6kAvPdzjZNeIIxvv34e+vbZccDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.3 0780/1005] LoongArch: KVM: Reject repeated PCH-PIC CTRL_INIT
Date: Wed, 25 Nov 2026 15:35:18 +0100
Message-ID: <20261125143840.012733150@linuxfoundation.org>
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
@@ -281,16 +281,25 @@ static int kvm_pch_pic_init(struct kvm_d
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


