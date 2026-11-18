Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044796;
	b=w+jOeinzsEovWBYF6fiQpcIx5KsvwVt1ZPjH4S6TQHTmYTH8CGLoVxOKA2Wt9QuqjBIC
	 DPITL/XyX+7PhHeLpMeeT3TrV0CZQdwa1XjSXpkjBrYLxYhHOs4qQWufQWaCViV0+93tj
	 bWvktIbgvClEYjwgjd5Cin1wDQj6L9rQLsvuMiH9YC0jtfB0IhO9Jq1n8+gUNQpZgALbY
	 uaKer77fbKJ1XKaSMm+howCEw8xRjHT69OjmYaKNt4ZgvKAGcbh1hFmnWZzKDrc5SnwJC
	 Gef3wUxWSD+M6QOaCb93j4gpVne3u9uWv9RXUk/sOqXVfumyPTFqzWwgyBPEMQRShoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=//FBhDqcJQrfOnCGt2k2fuOYj69zqkyl9j1+rIScAnI=;
	b=J769Nnf4qAM3f4h3RZJKp3hUuHWr9WTYoxOSNHvCPEpFT8kJgjY6JAIM6+7J309xwbmL
	 1r0c+grNX+GqfPFYUAbjpY155Fp06M3LVotdY3btHThJISjGot8XwdZgvhQGFBuE3ve5l
	 3WZHR1rx0N+UqIqO3Hap0HSw+cBw/SeB+ad2nYS3hE/IKC4VF7c9y32ittmxku8Q9g6Mj
	 Rd03He1GL+TJLBTP4AD8AwNMz2E1gvHfBMDSVQQY1jLADHupzpmWJO5s/wdplkErYf+/R
	 nyHDl3CNWZ7rLf/CvvyJSptD4EVaMvyK3K1hJgMELRN1BCwwEU44Ivwpm4o81f6M9Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Fh/NWBMv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8490060A381F;
	Wed, 18 Nov 2026 23:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fh/NWBMv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FAE1F000C5;
	Wed, 18 Nov 2026 23:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044796;
	bh=//FBhDqcJQrfOnCGt2k2fuOYj69zqkyl9j1+rIScAnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fh/NWBMvQG/2nEPAf0HcDzYAaiE3K76xDPIFgnvLrtUmZyQALPBDZ/JTHd8pakCWI
	 l5My2XkO5mLOVcirBvcQeUgSk1/Q6LaocChODTUTcsh9pNNPxMlxDhxYLf+wdflvGC
	 jwbi9Tiw2sqUAj74t0zdyGTGSTMeXSS/NVVuVrBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0678/2857] KVM: VMX: Preserve negative return value in vmx_handle_exit() with bus lock detected
Date: Wed, 18 Nov 2026 15:28:32 +0100
Message-ID: <20261118150225.974230671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cc10bde20d451..16b95732ba9e6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6539,11 +6539,12 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
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



