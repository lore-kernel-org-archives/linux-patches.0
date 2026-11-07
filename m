Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061764;
	b=mKGfqKkfbq0SmOEef71+0rI69W3QDIHKNVdPF93Iiy+esQOAGABD8SNpgh6GUDiTX5+L
	 evYyqyvXCIu0mlbN4X3sdBBbX7BRgPAAIgW8FXCWAkQrC0Yf2RKzhH5X734J8TET16kM9
	 GOau57BmzXxgX5qIoqmYqUuMl2wXnHM9Ds/AWte2+FL2l/Juqgb8s5qGiCCKzFXM5SU3p
	 xerjSVARNvudK7VPJL15Tv9AexlEIT/PS9YbLL4i9Kibun7pD9ihUk4PvkcMyIihQfTmS
	 GB1MPs7mubrPwgQjPHfcRh0eHRrMfr0o97HTOSwIvkEcz8N+PNYItUOPCg51JQ7wi6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vJ9zib0JwkPdGW+FrVjxOIeYNsJtSxaIiUDDoOpn9wQ=;
	b=el50AyZ4bgxBEnr5DYMaQAv/2CF6qxMIcbLkxa6qcoFhKJf4i1pTpW3VrNqunxr8yXy0
	 pF6DE+6HazbBPKbRF5eoVvGbIUwgucVM5uVDTszNGrjOFgzwbEt8bQtb8UcfgOPYWyara
	 zEw1MOh2gcYQzJw9Q4fU6SfGMXzI9/acYvyaEZzs1liVpqqKBBEBbJjkWuPWB+m0+tQHv
	 ibHbvuwgBSkSruY5QNI6YpkN744HPsSBvbDLbgpRyGhifTHtxfrpJR+AqCMF7q8bP57AQ
	 G4FI+YG7MDwPFFKN8xyFZMVxCDni/U5Nwap/zyfPDTZwQP2BTmj4zZI1uksE/YfJPdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L/4HTl4i";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953E2606A326;
	Sat,  7 Nov 2026 14:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L/4HTl4i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B2A1F0089F;
	Sat,  7 Nov 2026 14:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061764;
	bh=vJ9zib0JwkPdGW+FrVjxOIeYNsJtSxaIiUDDoOpn9wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/4HTl4it/cTYXLrT4WvYExS1yhBTuDkKoobHc17VkbQJ92wX1oFvduKL0HLQLcI7
	 xQ/gXa+6YoDcrFw7oLilDJJHAdM+3uRwFy43/mFhWiXO2Y3gpWp+MgvQ40OSOCuFys
	 wvDxLeqUYswbLu61q81WpEaXurtfgT5DUkBDQKAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loc Nguyen <loc@ryzome.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 0801/1536] KVM: x86: Request event processing for exception VM-Exits
Date: Sat,  7 Nov 2026 08:46:57 -0500
Message-ID: <20261107135020.042976954@linuxfoundation.org>
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
@@ -790,6 +790,8 @@ static void kvm_queue_exception_vmexit(s
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception_vmexit;
 
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+
 	ex->vector = vector;
 	ex->injected = false;
 	ex->pending = true;


