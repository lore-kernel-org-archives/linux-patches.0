Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034545;
	b=ATcxVJZUYdLa9G1g8I3cijYtYT0G4l9+j4El9geY0M2G90Xt3LA3DlQfChfeVsLLfk9R
	 i1B6pGogy6yqafd9dk+ggbsiIznsg4t2KkE/axu6f7Ti3tF9HpyTVRR7nY6A2kQoQlNe7
	 FzagNt7OmLwmacM9A0/m6SmPvwi9o7cuRApLg8TPQb7xpvEm7bfnfdJVkfkYFRQ0/m4ZU
	 P+lLo+vjavY5HW1FAwq2qnigbzbc3B6J2w4ri95vLcGyoKBKGJN7CiFG7DvD6fikWCTcB
	 ElT3el3ho6XAaMIwDxkpUBZ0DBVu1GHM0N69CuVR+UiHNtkfY3R/Z3AxhubdjpYvrwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b7KhUMkVIvJUDJdp6dfXdsUq15bA+/hAJ/Dplair45M=;
	b=4Pcl5c5PKuQ2Im6/eG3UDlruDVU3rGnRZ/IvcOjoiyHGU18OFmksh42u8SMSoQ72vzVk
	 pirI+Mcgfo669ld0+nVxSxuKBqIG6aHXVHXqY8M5RnksrLer8w0HUJAN2Bml8kJ4KR0iV
	 qJ1m7E9qL7Ool2YgAJoW0IGf5/+xW4bBUuZC5PIKxxcJTCRTwhxlmERV5Qqudan0nu7mi
	 EQn5T0pAGGjGTjizjkjjspBIAYGkFyvK4Bt4Pa0R5v0B1e0VJE5KXDaWzCeg/wzL0yDO2
	 5Ht+ShPCQSbE3uORzl3XalCG0HGAuDuQWkoqA/xoFxb+CxZHj8DmrC+j6lKapDT2ouA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="W/1Jzbbz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACC9606A31C;
	Wed, 18 Nov 2026 20:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W/1Jzbbz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6BB1F000C4;
	Wed, 18 Nov 2026 20:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034545;
	bh=b7KhUMkVIvJUDJdp6dfXdsUq15bA+/hAJ/Dplair45M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/1JzbbzQoZdQUTfgX4pUwckBC71ZwCL0npgorjArg93bgR3KsPmpXWzVgzM8hEoE
	 De2I62QHG9s1iSjZAr55Jrt9DbUZnN4NghUTDyuEaCG3nLkvRTzF6qMy9uBDTAcxJR
	 lwzopALMy9AQcpcSBVynoeTRUw5olIUaclgyUIMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0381/3318] KVM: x86: Check EFER validity on KVM_SET_SREGS*
Date: Wed, 18 Nov 2026 15:16:43 +0100
Message-ID: <20261118150327.692299509@linuxfoundation.org>
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

From: Yosry Ahmed <yosry@kernel.org>

[ Upstream commit 184bd464bdb66daa9173670904f24c29c7b7f7d4 ]

When handling userspace SREGS writes, check the validity of EFER (i.e.
allowed bits) before writing the new value of EFER through the
per-vendor set_efer callbacks. This prevents userspace from writing
bogus values (e.g. EFER.SVME=1 with nested=0).

Note: on KVM_SET_MSRS, KVM only checks EFER validity in terms of KVM
caps, not guest caps, so it is possible to set EFER bits that are
supported by KVM but not by the guest CPUID. Potentially allowing
userspace to set msrs before CPUID.

However, for KVM_SET_SREGS*, check the validity of the set bits against
both KVM and guest caps. This is consistent with other validity checks
(e.g. for CR4) that check validity against guest caps, which already
imposes the need to set CPUID before SREGS.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260713180153.2728382-2-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: Applied the one-line kvm_valid_efer() check to kvm_is_valid_sregs() in arch/x86/kvm/x86.c, since the register code has not been split out into a separate regs.c here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 24a19d5d68219..ad9a54302c313 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11624,7 +11624,8 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	}
 
 	return kvm_is_valid_cr4(vcpu, sregs->cr4) &&
-	       kvm_is_valid_cr0(vcpu, sregs->cr0);
+	       kvm_is_valid_cr0(vcpu, sregs->cr0) &&
+	       kvm_valid_efer(vcpu, sregs->efer);
 }
 
 static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
-- 
2.53.0



