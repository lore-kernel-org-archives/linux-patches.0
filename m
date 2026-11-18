Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053315;
	b=QCjpIL4fEfGtEPYEHb3r78IAdYpoDNB8Jf+3/zoFcuzgxHeEttRLnLuhgr019MTUWUQU
	 k6IEGAPG7QGB6Xupf8ez7rywhHJ7O34sBXmach36/LpDC77VbqD8uwM/5xF8rN0/c6Hg0
	 UAIJi4n0f27MfNXDxwo88bNLvEEl8RwACJ1A1LWXPrWiZNRFaFGOahrGuQn5IpBcHEmdZ
	 3+NgtuhkKKjAySpbjQck/exZbeqwZ0cpInPERP9H2XOkTuGgShxDvX+1VrtU8EEI2XPNz
	 7qNuZclLbF5dN/DB3SYJqNoa2+E+jjAZvQ3yY6kALnUJqqPn2lWo/PPJJiatizdMlzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qmtn9vaB38GSWggzHDeHsQk7o41EI02hBPSoFI9KkY0=;
	b=Nhg6SouXIcF96Bi64j5VajTQWiMPJLEryomtHYVlvqAZEd5REWo+Hjip/HYrWz1OzhN6
	 eN57dnNRoQ9Rte4PEqr+PXzog3GHvk8jRV9/mvBuDwDXu8HZNvcEdKPWAaGrbch2UwG6x
	 RGAS1jGxq9WFOnSmLsfeSi+MIOz2fDBLKlNBa5hNfeFYWgEeVyifqE83+UGpq85nh7Z9b
	 s5b+ZbK35JD5jKAJUIqWcfO6/NtJ7qUbNw4EKaU4Vy7MjRVVKnmr2TOupfLqrW8C7gF/Z
	 cgkJVIRmFdOK3KJhfCYRhSNT6LHwm/HUGU0d6z4w1VHwHDW8YvQ9tINEm18wnE4QhmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KOo0fV5z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6209606A32A;
	Thu, 19 Nov 2026 01:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KOo0fV5z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064111F000C5;
	Thu, 19 Nov 2026 01:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053315;
	bh=qmtn9vaB38GSWggzHDeHsQk7o41EI02hBPSoFI9KkY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KOo0fV5zP0q2xeZJQ/R1qVoCzrYMcEEq7I708dxPOANz8I8ErwniRhxS0j54jH0TG
	 ERDYXLmR5MhAR4xcrDHMLYQ86qBOEpXtlUHTB/sLXeEQB9sTOhKzwlMAmdu2gCIdG1
	 JDrEk4hr8CUDGD3wv8Owx7BlTJCMByGCJpwOCYuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0875/2214] KVM: nVMX: Process each host MSR entry at most once when unwinding failed VM-Entry
Date: Wed, 18 Nov 2026 15:42:31 +0100
Message-ID: <20261118150047.137837509@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit c33ef9d334059f7cb167569ed7b4779752fe4425 ]

Add a missing "break" in the inner for-loop of the open coded mess that
unwinds MSRs back to the pre-VM-Enter state when VMLAUNCH/VMRESUME VM-Fails
due to a consistency check that is caught by hardware but missed by KVM.
I.e. move on to the next MSR in the VM-Entry load list after performing a
write using a value found in the VM-Exit load list.  Processing *every*
matching entry in the VM-Exit load list makes the processing quadratic,
which is problematic if the load lists are full of MSRs that are expensive
to emulate.  E.g. writing APIC_BASE triggers kvm_recalculate_apic_map() and
a whole pile of unnecessary work.

Functionally, arbitrarily restoring the value of the first matching entry
is "fine", because none of this is architecturally correct: the load lists
are never supposed to have been used in the first place.  In practice, it's
likely a moot point as no well-behaved VMM will have multiple, diverging
entries in the load lists.

Fixes: bd18bffca353 ("KVM: nVMX: restore host state in nested_vmx_vmexit for VMFail")
Cc: stable@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Reported-by: Stefan Teodorescu <fane@google.com>
Suggested-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20261027185917.1478906-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 82aa349e33aff..2ea93059ad713 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4568,6 +4568,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 					__func__, j, h.index, h.value);
 				goto vmabort;
 			}
+			break;
 		}
 	}
 
-- 
2.53.0



