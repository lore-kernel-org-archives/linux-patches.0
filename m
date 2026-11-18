Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035611;
	b=gHRln7E4b9KriZxvJDCX4NrSc1ZfZ/Q95qEVgdqOtCCsesCuddOmGunl3ghqevfRxjDh
	 krbIMyRcD+brSaWzeuoqMUUzYsdkonDgx5h/yqSF5ezTCg4mVwxdMAsK1vftMDUM8rkp/
	 laX93pjLvaRZB4PrS2+6QY9oIm9EzE9lknBMXpJ6ttWqbSbk6foy6JxBhFWQPcKpmPcWt
	 W9BU0YkayHBXG8jwa42hObVeuZ/QPkP45lnoc/q+UOYeCvM1kKyE6u/utDVVjceyEUvhh
	 ixzS+nsDxUY8EPjetznrN9Fw5ttY5KJdvC3EBuc6uj4+ql4GYpptTK8VolmCLLCAtZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ubyt2Z6oNk20cbfheAMRP5JvriugTKOoX0av5PiLSqs=;
	b=te+IjZv75HfGgXAOozkJa4TABe9S+FcC9yI9uUhP9Bl9wEuRcAA0OhD7CCQ8Jyw3fZw/
	 pAmUTzLajI/8EeIt2xAQjPSFRjHgR9uKTFdlATXdhPJ+bAwhabqRVtCfQ7IAplLBJZJlJ
	 Yf7KAOvNL3rcqs8uzJ3VVtz5/ggectkC9KfYRoYT0WXr+txE7FfzVT7HgmvkyJ+wk23G0
	 8U2fgWXXZIdoDhqWF2lddH4xISvLeZDMH5SxoypAp+96mxOuQVK3ZuNESPfEoe+oSdfhl
	 mbyxKHuGWNonHTg4jljx6Cn52ARBmBG6JDop1ZLWwKfENeMgw9ldF5TSr4N8DE0aRbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="n/ra+Aqm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1D4606A320;
	Wed, 18 Nov 2026 21:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n/ra+Aqm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCDF1F000C4;
	Wed, 18 Nov 2026 21:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035611;
	bh=ubyt2Z6oNk20cbfheAMRP5JvriugTKOoX0av5PiLSqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n/ra+AqmqW3yJKkeFRdwMA6wL72lCOOi4bhO4/XwIMB3UyZ+TC/kAW/5zdUNCBwGI
	 5zNnP266QCOUBed5QQj2vaN8DO6/BR2PZC4mD6DjEhhUd/Udl4SQliEWf4z7xHo7hy
	 aTxsXo2ot57UIDECEiaDa3KuEcIale27vmDMBKWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0765/3318] KVM: VMX: Preserve negative return value in vmx_handle_exit() with bus lock detected
Date: Wed, 18 Nov 2026 15:23:07 +0100
Message-ID: <20261118150341.680635821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a744ab98440e8..498549e823874 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6622,11 +6622,12 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
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



