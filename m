Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF38F7E110;
	Tue, 29 Apr 2025 17:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946030; cv=none; b=lQqpFvYPv6f9eYmyWFKIYRGlf/GXu4vTL/EtLZuzLRXxdyOGoF1IblWMRdB3G8nJnRMcgLY7ZpHP0tUY8Q9pIhbZCyshDFLg1sHBPmkmVkkrdh8Noly0wSaNWExi+kODYSoZf+5YT/KP2WQeyCHEclal/h+UtlTFBjgu0KPi/8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946030; c=relaxed/simple;
	bh=YMcI3uh8Hko4qzcyqgKdiDHqrsR22X5X0c4QozvM7qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLdqtW1vdmfgM9KmJBJrKtP+1gaFX1TyO8vAXC1yfZGMoVEbhx+cNGDwgJlysSF4mM9cNqKeSWgTnMl7dFjMrUBJ3w8iE4WQKnPca3bvo5Sejh3c/1SrAS1g6GWYJzxbVYTIgKVo3ALMAtmVbeLlvf4wCZ+e4OvAA5AW1BwONnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=raKYPL60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="raKYPL60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9449C4CEEA;
	Tue, 29 Apr 2025 17:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946029;
	bh=YMcI3uh8Hko4qzcyqgKdiDHqrsR22X5X0c4QozvM7qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=raKYPL60qrlvT11/upHdFz/uVex5JlsDaYTlGflpBEqy/qDxxndLGcvhwLTMlg6GJ
	 bI4926RFs19qiSai0Ghl9otGmYs3q6X0t8IyycqQx9zFTpEF95EWHBPBh4y5YC7HIL
	 4m9cIpyzN1U+94544OsGe3Og8MmMRht4jQmRIKdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuli Wang <wangyuli@uniontech.com>,
	Bibo Mao <maobibo@loongson.cn>,
	Yulong Han <wheatfox17@icloud.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.14 131/311] LoongArch: KVM: Fix multiple typos of KVM code
Date: Tue, 29 Apr 2025 18:39:28 +0200
Message-ID: <20250429161126.408529487@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yulong Han <wheatfox17@icloud.com>

commit 8b2d01fec800081dd68271c01e4d239ef4d7115e upstream.

Fix multiple typos inside arch/loongarch/kvm.

Cc: stable@vger.kernel.org
Reviewed-by: Yuli Wang <wangyuli@uniontech.com>
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Yulong Han <wheatfox17@icloud.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/ipi.c |    4 ++--
 arch/loongarch/kvm/main.c     |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -111,7 +111,7 @@ static int send_ipi_data(struct kvm_vcpu
 		ret = kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		if (unlikely(ret)) {
-			kvm_err("%s: : read date from addr %llx failed\n", __func__, addr);
+			kvm_err("%s: : read data from addr %llx failed\n", __func__, addr);
 			return ret;
 		}
 		/* Construct the mask by scanning the bit 27-30 */
@@ -127,7 +127,7 @@ static int send_ipi_data(struct kvm_vcpu
 	ret = kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	if (unlikely(ret))
-		kvm_err("%s: : write date to addr %llx failed\n", __func__, addr);
+		kvm_err("%s: : write data to addr %llx failed\n", __func__, addr);
 
 	return ret;
 }
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -296,10 +296,10 @@ int kvm_arch_enable_virtualization_cpu(v
 	/*
 	 * Enable virtualization features granting guest direct control of
 	 * certain features:
-	 * GCI=2:       Trap on init or unimplement cache instruction.
+	 * GCI=2:       Trap on init or unimplemented cache instruction.
 	 * TORU=0:      Trap on Root Unimplement.
 	 * CACTRL=1:    Root control cache.
-	 * TOP=0:       Trap on Previlege.
+	 * TOP=0:       Trap on Privilege.
 	 * TOE=0:       Trap on Exception.
 	 * TIT=0:       Trap on Timer.
 	 */


