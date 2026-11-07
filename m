Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061839;
	b=JJtUaOubK7M5JrMUmy2Wes9atEdht+FeFKXCgscCki7W9NSOSSXYHEd//LL+FsQjtwC/
	 ysA3HFWwYOLLDv0UbeA6LNKBiFon9S32UWouxtWwb50ab6dbHrLFtkQ4RhmUr20LjBA8N
	 0Uam04hVHC+bMETPgZNOUJ0mX2PMPpKUUHLLsv2N9g/pfHZQpA+UVIQyqftf3U+lXdw2L
	 pTtPYYkZxQ1DkEFjhSSZCHLhjgOldPzSEYMCHfYKfNxfra/cRFBmnGUOrB+QzdP9URsb2
	 kTAn7eAZjYaWx9BGShXAlgUPC+qSi1xZRErtwdhOCAAUTa/j5QR3TpiYjnh5AIv6EZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aCeBrx6DPW1sOnH742Hvl0yEes2PjnLNmnSS9bKW+Pg=;
	b=NMmJuuER0hdQ8DWslLXuMwjmBV223NJtMSYCZVCl3qJ0Ka21jTLCdrUyT6shho76S3t4
	 bIHnVhZQmZk304YucvEf4OaYPiSK1xqahF41x2w1NzOnxpUnO2W5gTT1bgtxgPyTuhFrb
	 5AoiFKb9xrDTwx4cwxidR4nGpyPdFeC5hRTL0zImZngENIN4jjdRgbwjbFIHYW8iQXYNe
	 onfNYxWBg1F74IHctQVFLWJOPWM9/AP1hsgygcRirT27e1P03yk+1Sf8bvKCVOpTZXg8t
	 VfWSW4GP8U3hUhkdptKYyWFqqceMxXALhJp1Xc5PId1WjXKe+Q/wMM9UUZWK8h3ONxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOM8Fenf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82376606A326;
	Sat,  7 Nov 2026 14:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOM8Fenf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EC91F0089F;
	Sat,  7 Nov 2026 14:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061839;
	bh=aCeBrx6DPW1sOnH742Hvl0yEes2PjnLNmnSS9bKW+Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOM8FenfNGiGauvFlcoz6aQ9BYrPULrRQsvh5O8MIdpaNf945jTaALJOqzzZQ6Cb5
	 aoYs53yd5MKcisrcow20rWydx/7YW8VAoJVCRCP1R5UjoH7FBOL/L2bwiIqBm3GtWF
	 eZLLsDAwe6EeNNZDPAhsttyl4jMISr3TNlqKsp40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0858/1536] KVM: VMX: Formally define KVMs "0xdead" exit reason used for failed VM-Enter
Date: Sat,  7 Nov 2026 08:47:54 -0500
Message-ID: <20261107135021.647585167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit d85f7dc8cf3c91a131946dae4c3aa8d9c97322d7 ]

Add EXIT_REASON_UNDEFINED to track KVM's magic "0xdead" value that's used
to stuff the exit reason on a failed VM-Enter so that the magic can be
reused by TDX, and to make it more obvious that it's an arbitrary, KVM-
defined value (though the whole "dead" thing makes it pretty darn obvious).

Opportunistically add a compile-time assert to ensure the KVM-defined exit
reason never collides with a "real" exit reason.

No functional change intended.

Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://patch.msgid.link/20260921235656.1107929-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/vmx.h | 8 ++++++++
 arch/x86/kvm/vmx/vmx.c     | 4 +++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index f7fd4369b8218..ac2c0665b661f 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -20,6 +20,14 @@
 #include <asm/trapnr.h>
 #include <asm/vmxfeatures.h>
 
+/*
+ * UNDEFINED is a KVM-defined value used to indicate that the basic exit reason
+ * is undefined/invalid, e.g. on VM-Fail or if TDX never attempted VM-Enter.
+ * The value itself is arbitrary, it just needs to not collide with a real exit
+ * reason.
+ */
+#define EXIT_REASON_UNDEFINED			0xdead
+
 #define VMCS_CONTROL_BIT(x)	BIT(VMX_FEATURE_##x & 0x1f)
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b6361df62269f..a36d9f504ba53 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6151,6 +6151,8 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 static const int kvm_vmx_max_exit_handlers =
 	ARRAY_SIZE(kvm_vmx_exit_handlers);
 
+static_assert(EXIT_REASON_UNDEFINED >= ARRAY_SIZE(kvm_vmx_exit_handlers));
+
 void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		       u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
 {
@@ -7314,7 +7316,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	vmx_enable_fb_clear(vmx);
 
 	if (unlikely(vmx->fail)) {
-		vmx->exit_reason.full = 0xdead;
+		vmx->exit_reason.full = EXIT_REASON_UNDEFINED;
 		goto out;
 	}
 
-- 
2.53.0



