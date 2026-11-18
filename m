Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035477;
	b=B9FjqJK1qRH1VApMx8QJzmQtlEp05kgr3oJ3lQo5117G4fDfD+h0vuLBHZ7EdBUrilbD
	 OFO6n+WJaEXUxboxh8j7sp/xE3Dbt39Ef9N9ItHN5mkVUKaDcJWYG9TtOlRuKUDt7Wh5X
	 tePowGoSsjV1M0GymmbOM76NE66rmcEKgw5dh+7Llkfa1BYzCnDb1OSiWxVYbaFfu91RY
	 wi4fxUbc+m/khMawJZOVUFL8Jl7K5l4ysA0xs+O13U4S5rSSqwxQidnH8/RzpcXI1aggC
	 qnBp6XHtSHQCn90hALU5n8nR11/iZxg3e3SLZWgp8Qk6nRVupQPWEctBHvAwNb3OH9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hr1kFiiOFxGdpe3rAVsA3TvUMvv6OgCvDwg//QdiyAc=;
	b=aW3SiMse2nHU0+6weMZFRzKboo1KgvLhaFrBktG/u/lMx3RrF9jVMkeGoitdeuMvnfhk
	 F+boQ008nNZklU53NMez05QD+DfPRArScH0AJK6ZUDt7tE7ByzV48sSDpoJjhaGFtZDBg
	 Br7AwOM8s/htJqmPBqSvLvvvujFarqcw9Qyj3X5AstqAG0Np752Sac4Bq7hWAeymrdaNz
	 1GptiKKKUJKxZzdPa/4hLInm5HqWYN2zcH22apwKkf6JS0RnLfkssk4Jfk6sVVEHcEAH9
	 kbajj/RVTjaFI5hGwrUCQBEcdDF010/1z71jtPPR75I1qXEvfg1qZRdSYUZXU3n1ZgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lX73IOe2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2560606A31C;
	Wed, 18 Nov 2026 20:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lX73IOe2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7AD1F000C4;
	Wed, 18 Nov 2026 20:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035476;
	bh=hr1kFiiOFxGdpe3rAVsA3TvUMvv6OgCvDwg//QdiyAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lX73IOe2kqnC/tuyFyMdknpNmfXHvWy+sitUamNWgqv3d/AqCYyf10bE7UdNn3xVE
	 GdnOq48RNjDH/0blSSuHV9wJ7cufCHtbW6tGcYQ6yQ4fg8iMp2/UF9bHgQGq6P1Jxf
	 uK5na4NG9Khin5PiD8sgeh7WXcinYZJal3e2CJWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loc Nguyen <loc@ryzome.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 0718/3318] KVM: x86: Request event processing for exception VM-Exits
Date: Wed, 18 Nov 2026 15:22:20 +0100
Message-ID: <20261118150340.009351734@linuxfoundation.org>
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
@@ -627,6 +627,8 @@ static void kvm_queue_exception_vmexit(s
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception_vmexit;
 
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+
 	ex->vector = vector;
 	ex->injected = false;
 	ex->pending = true;


