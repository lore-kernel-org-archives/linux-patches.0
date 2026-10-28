Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215201;
	b=Q1bzBmw9E+01TfH5bsKdmrNxhicuu6K0I3pNYgI4XliF7J/6QR80zEVrJ+kwFTxGeHEQ
	 vsjWODBid3+Dxa/h7zKRVROHi+8xrFrC0Ayf2W3THDqK9RmyP9QSgQyPMDOZybpRRBbMq
	 1wZDy7qLju0ZWA8vGEPxcFoubzpkbvFNRajFaPpJgpkPWad6J1YrD48mxgwQN0mV4zaEp
	 1x7VOzNQm9xly7C2H6/p4eavjXWQzoV8HTQ+CYIyvCk/C0tXPMJOgu2tqMCcQUhOKxQE+
	 ARot6jqmkA93b9bls2Cfe3DiRUryvPKuG+i+vTx65SEZqzQ/jqQXQzAuZSP8IF5GbcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gAj/rhIXHAFpyuTVIIxjHeuTmKwISQg9QfrwURNQ1sw=;
	b=JPjan52hkjPOf12c1B1AqDQIGdmRLyFjjUIMYfAr27CKf0dr9oDHiPSl80+Jhuukz8Ov
	 VttJbs6sQw6GKEaIB8Z/Sm9VJcU3qX+ZMSQLJUahmO244cgbyA+EPemyKgFUAJ3ifaViw
	 WjytDEvVRViZFbSGrSzNce7egZ4FJ72GuGfwhQ7mt19g58RmMF9+wyUkC/WMG9yDO3ARJ
	 UiJaJzwN5jxU+Ia6B7LX49ho9CjAJldRIrBrJMoN9ZeJ2SMVCMzCgeP+ygz2CdQfGga2X
	 m/eUJiNP3wiOBcqDnS+2hWyRDthHkUON0XqhRgskEK/YuDx/qKYkI1NEI+4a3/SMnMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYBRHvhQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505E8606A31A;
	Wed, 28 Oct 2026 19:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYBRHvhQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F30F1F01825;
	Wed, 28 Oct 2026 19:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215201;
	bh=gAj/rhIXHAFpyuTVIIxjHeuTmKwISQg9QfrwURNQ1sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYBRHvhQ00NWpR5HcPwBo9we6NJ2lr2W99S0qpB/LSE4m72K76cq9eXEicd5p7iP2
	 9qi9sxS4j2E+vVqNTlqiMBaO69h/SdvNG4YJiwN11+13JfvkbMuKOKDq+JhEhE9h3Q
	 w0wKfU+Iz6SJMkwRPGYhiBF/QWFM3R5UJpwTATz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1126/1887] KVM: SEV: Ignore Port I/O requests of length 0
Date: Wed, 28 Oct 2026 17:53:42 +0100
Message-ID: <20261028170525.024816101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 3988bd2723de407ae90fa7a6f6029b4e60238c58 ]

Explicitly ignore Port I/O requests of length '0' (or count '0'), so that
setting up the software scratch area (and other code) doesn't have to
worry about underflowing the length, and to allow for WARNing on trying
to configure the scratch area with len==0.

Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ad23c5f47efb5..0c182fd09fa60 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2952,6 +2952,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 			    control->exit_info_1, control->exit_info_2);
 		ret = -EINVAL;
 		break;
+	case SVM_EXIT_IOIO:
+		if (!((control->exit_info_1 & SVM_IOIO_SIZE_MASK) >> SVM_IOIO_SIZE_SHIFT))
+			return 1;
+
+		fallthrough;
 	default:
 		ret = svm_invoke_exit_handler(vcpu, exit_code);
 	}
@@ -2972,6 +2977,9 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 	if (unlikely(check_mul_overflow(count, size, &bytes)))
 		return -EINVAL;
 
+	if (!bytes)
+		return 1;
+
 	r = setup_vmgexit_scratch(svm, in, bytes);
 	if (r)
 		return r;
-- 
2.53.0



