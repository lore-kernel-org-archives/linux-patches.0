Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051988;
	b=OGnVaLqakTCjwdo7FtYuXP16TJZdAaKdj/LaEOnMyBHNxVVb7pwmEkzsbyHcgmtivUys
	 RPulHub8kIWoeU90J4+AftimSmynzwTr6ZW7Rg7BSntVg3Yy+ZT45590xoDBmUo4FpqRe
	 QV6i/JsgXYu1md6xW7DpmExnIpXoA2/N4RvLLtLfiLul0H0B5cP5WIoE4mZjHzNax/qE2
	 Q3GhkhclGIJwErg/wPTFgVKfej7UQT3W4QS6YuHQAYQAFc/5/BxJGMZGKhyXeaX9m9hL9
	 9PRgiJ0I//hlDs3NmlmqJdzOplr/J9kJA8FJDOGN9M3vUC0y77as78JcIx9SkNBsPvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i+wHzePhihEb13Rpfcg2ZtZQqn0HEahQVfOVpsLPrXs=;
	b=Oz6puleHDXcIOm45OF6vYR69Ev0xFnZfq1bd+u9GsfMjbvYJocDB54UWQUB43i9Pbn5s
	 eT5awRNJUezIpOdwtRhr8k24EMG0TOUOUyHlLgcQCSvja1QmEJDRI21poFcx6kbwd3kE2
	 RbbVEUSz39zW0+cmuCdaZxvOQJ4qwWzwqxOiEeLRJtv29zxYjucXNE6v0T//+5VXw0XYu
	 XjaZNMUN2WejQzO5pVPhp8ElFbhmJhOHtGunpU4trqxQeZYg3aZDq9mR8oVMob6a7ULzO
	 mgW4peI7HVU+Nz7+ipkRIN8ezeSgIfF42X+kHYmcR45I26LhRKT2hAjnC9E2EVIIMZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QNiQabli;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E70606A320;
	Thu, 19 Nov 2026 01:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QNiQabli
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCA91F000C4;
	Thu, 19 Nov 2026 01:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051988;
	bh=i+wHzePhihEb13Rpfcg2ZtZQqn0HEahQVfOVpsLPrXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNiQabliQfMB0tp0IUwagXXdcKA2EnH8YXGv+pMEogGdncUGEFnH82nU6hdpsbjoY
	 kyo4f8ooA/3OsIXc2UpYKmDQSXMxCnuZDDQfREw1k970db/U+lMsGcVJE7tSfPQNj2
	 dJWte0hsaE0BnmoCh+I/VBxQJE/GTEajDEM7Cw44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0402/2214] KVM: VMX: Preserve negative return value in vmx_handle_exit() with bus lock detected
Date: Wed, 18 Nov 2026 15:34:38 +0100
Message-ID: <20261118150026.840208061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaoyao Li <xiaoyao.li@intel.com>

[ Upstream commit cef48693da1e964e9f192bfc16cd0ed287c48337 ]

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
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 244b67601bce7..77b1161e36e74 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6192,11 +6192,12 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	 * a bus lock in guest.
 	 */
 	if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
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
-- 
2.53.0



