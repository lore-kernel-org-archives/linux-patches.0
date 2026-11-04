Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831818;
	b=vd/5zL3C2FuxIkHxhghoFbwzSYOMzknYZKWI0ZrR4JzbH4jyQvmkmdSmTUN9AjgRp3td
	 kcycKzGz/CIfrQ1DW8nZ+Nl2RokgSDHheqoudL+LDURMtHHoCvxS4Gr6i4MbZmD6vCAFt
	 d/P84CZ7ND/ujwo9YkwCU4YOJUvC7kDel0eDY5CoCRaCoZQTSBBovRuEY1FxQb3Fq3MxW
	 umnqNqOuWcJn+eK4HidAn+Cu82f7kOrEq0/97SqNGeXLN39Mh3mSr/BkGN3jnVyooW4Kq
	 tuonPlPVBE/NdFGQIphZ0yXX3jDYRIbDpmoE8CWg0rFWMFm6iMd3SZJKuzWBs73b2Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gQ+7PTFtlwuyeD2IeiHcqSrUS4IPm42Z+kWdCoG+HaI=;
	b=Mf+hXu+VbtgVUXvmsmVFtbc4TnMgf6bJeNUS6tx/+IuJE4vgxfPPdF2OHGsDPINNaBPX
	 321aPgGDBZ8V0FMiqj/M7szQKKfiWbnt6GRoyKmwQ2St5ucYcGV9erTyB+LiiWYC/H+gI
	 C0ZMS2k86xpJe5+HspEQ6TioPKjMTI9lyyt6pfBKLfDGBmCoC7DsHVVMy7XnnJJ+qz2wT
	 PIcZgr5PnIx8LSBf9oFpRTv4QL61pHSDlcJ15EUzzbYZxSCC+3Tb7kSynsxnY16UG4NSr
	 LqOdNHiIy1LUzpsLtcgOAFwDqjLYzOQW4elFWPaug4CL1mHFkOw4TUbhS0BixWRfX0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XcQEiqe1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F326E606A847;
	Wed,  4 Nov 2026 22:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XcQEiqe1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A621F000C1;
	Wed,  4 Nov 2026 22:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831817;
	bh=gQ+7PTFtlwuyeD2IeiHcqSrUS4IPm42Z+kWdCoG+HaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XcQEiqe1mBELFgJnkNx+SK2QhFmO5daJvVEB/3a7t/4QhY1wRasiZPPdIyNOJzDN6
	 TQGVlT70TqB0sg1E7JiUc+6XM6elsnxmbgzU9JXj8dUSx51+IstsGjx7iPq3/nIFeU
	 SAZ04aPYqDWMqOs/pBgBHMu/8NMZeRIMmNwAoRdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 0930/1005] KVM: VMX: Preserve negative return value in vmx_handle_exit() with bus lock detected
Date: Wed,  4 Nov 2026 16:11:03 -0500
Message-ID: <20261104211109.187691607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

commit cef48693da1e964e9f192bfc16cd0ed287c48337 upstream.

Preserve the negative return value from __vmx_handle_exit() when a bus
lock is detected, instead of always overwriting it with 0.

The purpose of bus_lock_detected handling is to force a userspace exit to
inform userspace that a bus lock happened. The negative return value can
achieve this purpose, and changing the negative value to 0 fails to return
an error to userspace. So, preserve the negative return value.

Fixes: fe6b6bc802b4 ("KVM: VMX: Enable bus lock VM exit")
Cc: stable@vger.kernel.org
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260805034602.5B2BB1F000E9@smtp.kernel.org/
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://patch.msgid.link/20260819094903.3060020-7-xiaoyao.li@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6645,11 +6645,12 @@ int vmx_handle_exit(struct kvm_vcpu *vcp
 	 * a bus lock in guest.
 	 */
 	if (vmx_get_exit_reason(vcpu).bus_lock_detected) {
-		if (ret > 0)
+		if (ret > 0) {
 			vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
+			ret = 0;
+		}
 
 		vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
-		return 0;
 	}
 	return ret;
 }


