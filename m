Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059057;
	b=W/t3CQK2hdsCAuQNbbRdtrdOk2BwQ5t1aizYuJdauem2Kz+9XxfqrSYayTIU7hZXghAM
	 v4+CMfenIbLOb73yNczs25qwaoJJfb54XjIEJvZLPkIot8FiMVQGa5V0TEDmtRqWwS432
	 /cj1C1p1ztaaKZ4RaIrUIyK6QNNQ0ldwt6Fs1x2I6fpsab3uVzTY1q3JSQLStHprhX7Vl
	 pADyU14PkdCY9YUDuh8G+UGZCTB72jyGT9E4oBYEqzsbOWRNrmsyD1rksIw1WfukdOSMa
	 d5uFL8YgTf4D1rq0m6+RAIm0JLc/WEf5ilxO90IoG3TNQQgMIf66iAn636G2O99Aa+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t62+bzUw6zC7vkMkGDAj1Kx+GbUPlhNHKCLRSDPU1kk=;
	b=yBLUWNRNnFWx9uTnFsyEJPcYz8IVzjZknAJrIAVjruKIXWNcJiVKVFmNL/BX5nFHcNpz
	 r3M2zu3e9skZClNhOjobZhLgQZiTa3hlMLvuWPlTbp/vnYd7Rj8qcN62T88nj0XmTQ4Z0
	 I4eoj0uYgenQXt94BgEHlVy8apSjHANnRQ+DRAKB+pIBKHVfWfRGquFCcnXI3emTkiplD
	 HyV3+NX2hCkrUcemco7QpTCaF2GGCmBmk1G2xiwz4O5ALVzsUPe6mgipNB61OaDlL+nVO
	 6OzXDMScR54kuOgmfDZpB7mKoIRlSxsqH+WRktXFc+SocmlgSMmW+Etl1RXIqz1UqlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bqaT8Jxo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F8A606A320;
	Thu, 19 Nov 2026 03:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bqaT8Jxo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E361F000C4;
	Thu, 19 Nov 2026 03:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059057;
	bh=t62+bzUw6zC7vkMkGDAj1Kx+GbUPlhNHKCLRSDPU1kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bqaT8JxoOkgErxVqY+EwIEOmAe6CFS1qKir0vhyrKaYiRML4fRM4gGsg5jKpGo4hp
	 kefiR2SKGTeTQLR+C0xYgcS0/76gSJTuirKxKMnhh1nX5PsaRpHevzz9awik+JAMIy
	 QwXiUewfm8f34O70/d0SiX6c3RuZi+1HKRBZneQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0704/1848] KVM: nVMX: Process each host MSR entry at most once when unwinding failed VM-Entry
Date: Wed, 18 Nov 2026 15:45:42 +0100
Message-ID: <20261118145945.342549342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7c861d34f9c56..477d69bcd52aa 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4498,6 +4498,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 					__func__, j, h.index, h.value);
 				goto vmabort;
 			}
+			break;
 		}
 	}
 
-- 
2.53.0



