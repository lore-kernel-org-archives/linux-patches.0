Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831831;
	b=bBBD1gz3LtuH9CVQDSMFNxRlXpnjmvwJ2af5DryPQqUJUt5dXG1D3QfoFtU/2NjUpl78
	 1m6qD7GYfSy2PCaUtgDA1+ckejM4riB9FaSzsMvzdsuqw9XUxHq/1NqGjIBCqRab7njdC
	 zO9bxY0ueTMeu0jT7JK/i1658r+eJArlSWKUyx0bF1zvdLf5M6/cN1ohH3qCAsyZuQQZ5
	 8pIV+VQgFz3R4hA9Xv2uobPt+iEv5swPzG4GrHzxA6IS9EcJH9YFhBG64FFJ4sGlU6mIm
	 CsZ8hGA+ZBuzMCb/rPgb1DadF0gC1rnGspaxX2gxdkqNVAZNaW9WA00AXz55nC4tszA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RF0TOZA4YbQkVxoML64yrKQfinYVkSzcpzs5hDlX8PE=;
	b=SD19eUoQPRPCTlP9Wayhr5oBsKgejVMxK8kD4u8i5CHBEN/B38hJrckZHP2zNNjLamyG
	 MPXzoYOg1N7w8olVW6IFjH57ODfalM+njK0EInKjR3Z4jNZrduwEz4B9epZaDvraBZ6/Y
	 Z4QYHYfA88RDkPx3qn+cDymUejaZX2FWl85RT9ahk9tZYnio42bj+/HG2V3JDNDYGFPpm
	 mrOIg6rcHntz/qUEWF5LU5ZxPuayl/5Lby00PWI7ij1qOmBin02/EGKsyCk0o1MpW4v+4
	 NX0NgHpDJjge1EF5ub+C70PSAmAAiAHBRGqf4C1DWzO5h4bHdJbrCZdOHCB1fO+ACtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l5JkvGbZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DE5606A842;
	Wed,  4 Nov 2026 22:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l5JkvGbZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0BA1F000C1;
	Wed,  4 Nov 2026 22:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831830;
	bh=RF0TOZA4YbQkVxoML64yrKQfinYVkSzcpzs5hDlX8PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5JkvGbZGi6dyL2neaep+VukhNNUZ0iaQEiBybqHKXevHO4oLYYfX0zLMm6/wuE9z
	 09vtPgKx0GFKY0gCPFkh7ZBjC/LNRlL4fOrsbiQ/+ricXje/ja3oYDt/tusKx5Au5G
	 7uAcEzfujPoe6z9ST3LxmjowNFF7RqnJeNydD9KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loc Nguyen <loc@ryzome.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 0937/1005] KVM: x86: Request event processing for exception VM-Exits
Date: Wed,  4 Nov 2026 16:11:10 -0500
Message-ID: <20261104211109.377001330@linuxfoundation.org>
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

From: Loc Nguyen <loc@ryzome.com>

commit 88b23a2e8286b7016c3b58dc10093cf28c22aa3d upstream.

Request event processing whenever kvm_queue_exception_vmexit() queues an
exception VM-Exit.  Most callers reach the helper through
kvm_multiple_exception(), which already sets KVM_REQ_EVENT, but nested
asynchronous page faults call it directly.

Without another event request, vcpu_enter_guest() skips
kvm_check_and_inject_events() and re-enters L2.  A subsequent VM-Exit can
clear the pending exception while reconstructing vectoring state, losing
the synthetic #PF VM-Exit.  The APF reason remains PAGE_NOT_PRESENT and a
later regular #PF can consume the stale value.

Setting KVM_REQ_EVENT in the common helper ensures that L1 receives the
queued VM-Exit before KVM re-enters L2.

Fixes: 7709aba8f716 ("KVM: x86: Morph pending exceptions to pending VM-Exits at queue time")
Cc: stable@vger.kernel.org
Signed-off-by: Loc Nguyen <loc@ryzome.com>
Link: https://patch.msgid.link/20261002053723.3275202-2-loc@ryzome.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -827,6 +827,8 @@ static void kvm_queue_exception_vmexit(s
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception_vmexit;
 
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+
 	ex->vector = vector;
 	ex->injected = false;
 	ex->pending = true;


