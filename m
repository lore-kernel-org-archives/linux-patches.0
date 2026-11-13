Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585461;
	b=t3pc7UsTtqzRTJ4uQ/VrcGFGl0pdYNrGOr6ZW9667FYeUAcsxdOrGwjZ1gci+C3s7f82
	 0BjkIaCi8dQzPOvA3SKVwECS5Re7zrLYPVA7PDfQPmG6U7Rv4TE85GhSAth6am7Cy1j44
	 xzZgjmM8dqWKAQ0cL/AkovZMmB00q/HKTVvaBTVh3iiUho4Z8qhvFIGcwG/r6s/mZh1Yu
	 iI46QrGHWK/9NNj+hciK+uJfVyhzYOUST3H5DreePwtMHW5KKaV4ODFbfAYQZ0OASr87k
	 JchHp9jdkIE1qNbEZR8nRXJkS5rpX33rKU9EzaCHHI+M+SsSeX0wYaDedvIlnMbjimw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B1woB9tZ0xhRn7bZcSs+4n4/NgI+1esnUjqPiTYgszs=;
	b=P59MtxUBBwGBCFKhBqQbBUr0uclQEMxWCh0EOeAlNJx1J80tmixBFeeF5h/TmmDbHq5H
	 /CRGhw6njhS033jjCMshClN151qL/6XwEhOw826aTs1z/n8SUJjA7gINoRfWv0wQLYzhJ
	 QyHZT82QOGfZN5MTKs1HHYfL7BtjlB1TpB86OM+0sOPiMXaEesJT9n1t44Yc7wRHJgw9A
	 saC7puSTB2YfGi3M1tI02vbVIXfrrILxzZ+ZAYb4sT+LUTScdD2+iU1fmaYy9IR6owgH7
	 /Y+pKj9vzjB1Yb0jf3TGhJ1csmv9YI4Eh/dp2oUDv2ADWyzTrI8UUtHSndZi+mAK6pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NYOa1vnU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100A360A6F71;
	Fri, 13 Nov 2026 15:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NYOa1vnU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4521F000C4;
	Fri, 13 Nov 2026 15:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585460;
	bh=B1woB9tZ0xhRn7bZcSs+4n4/NgI+1esnUjqPiTYgszs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NYOa1vnUPL3QcNXjNhwTb3r5ErM14n5WnQaP3QiwJhDLnK1kLHnEEQ0KvybYmg9Y0
	 pM4fmbry2ciu8sNopBg8HBXIFMC3+zuRERBeDrojSaAITBVuL0z2502PO82LTm622f
	 YD4XVZtWFn4i6mN8GnQm1D8pmsTBgs+MY0k/jxRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	David Kaplan <david.kaplan@amd.com>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 117/507] x86/bugs: Select the BHI mitigation based on the attack vector properly
Date: Fri, 13 Nov 2026 10:47:01 -0500
Message-ID: <20261113153758.309112375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 3457b3bcd344005af894876cab4e634cabdcbb62 ]

The BHI mitigation selection is inconsistent with the documentation
(attack_vector_controls.rst), which lists BHI under both the
user->kernel and guest->host attack vectors. bhi_select_mitigation()
only enables it when CPU_MITIGATE_GUEST_HOST is set; otherwise it
selects BHI_MITIGATION_OFF, even if CPU_MITIGATE_USER_KERNEL is set.

As a result, a kernel compiled with KVM disabled gets BHI automatically
disabled, since CPU_MITIGATE_GUEST_HOST defaults to off without KVM.
This is a bug, given that CPU_MITIGATE_USER_KERNEL still needs it: on
affected Intel CPUs these kernels lose BHI_DIS_S or the BHB clearing
loop by default. Booting with mitigations=auto,no_guest_host has the
same effect.

Select BHI_MITIGATION_ON whenever user->kernel is mitigated, and keep
BHI_MITIGATION_VMEXIT_ONLY for the guest->host-only case.

  [ bp: Clarify commit title. ]

Fixes: ddcd4d3cb37c ("x86/bugs: Add attack vector controls for BHI")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: David Kaplan <david.kaplan@amd.com>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20261029-bhi-attack-vector-v1-1-29cfa697efb6@debian.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 000ebee2d247b..4ced10c6ba0db 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2088,14 +2088,12 @@ static void __init bhi_select_mitigation(void)
 	if (bhi_mitigation != BHI_MITIGATION_AUTO)
 		return;
 
-	if (cpu_attack_vector_mitigated(CPU_MITIGATE_GUEST_HOST)) {
-		if (cpu_attack_vector_mitigated(CPU_MITIGATE_USER_KERNEL))
-			bhi_mitigation = BHI_MITIGATION_ON;
-		else
-			bhi_mitigation = BHI_MITIGATION_VMEXIT_ONLY;
-	} else {
+	if (cpu_attack_vector_mitigated(CPU_MITIGATE_USER_KERNEL))
+		bhi_mitigation = BHI_MITIGATION_ON;
+	else if (cpu_attack_vector_mitigated(CPU_MITIGATE_GUEST_HOST))
+		bhi_mitigation = BHI_MITIGATION_VMEXIT_ONLY;
+	else
 		bhi_mitigation = BHI_MITIGATION_OFF;
-	}
 }
 
 static void __init bhi_update_mitigation(void)
-- 
2.53.0



