Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590312;
	b=nFFBlwV5pQ9pvLZKRHdpRNgpWyprChpSKrLv4T02OwQypabStNKLEik9+0Ey4Qm50Eo1
	 3vBtVz5LFtIjhMXhUbw5Sh/ON3izeiBqGsO0VILZqpLSXSV4FNHFgwsedyC7xa/Pxx6Jd
	 Hgu/j+GbgA4migs1hVIe/R6tP5ucWm5A/G226tKE3clcRUP4pwlOrZyvuc5+RwL7yVYUZ
	 2cRVXfOaWZc6YTTn1uVnT7qJlLvhK23LCP1WDPazkKCT/+3bNBLCbZmfrzH63IoNF2zVQ
	 gCrrtTiAnHcdpDmOIQPrBu0DSgpLwIHdJ6Tz38yWQys5Xd84DOf9XHRn1qtCeTJldcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BEoHnxlipzMIHFTaFPbRpvDuPAH4l1fURTzicekbsu0=;
	b=rcOmjtQZU/Ka05aBrgQaYG8LYjfV4fREKbyTpljZHdjH4hxglXwXUMcPLZhQikmwV/6N
	 HeZAMb0ViW4TgoSK1SDeqiOakfui4jYJEhPPeai9aWgiB20qP8Muv3+j1GtFqcsM5kFFX
	 V46ISMSjt2FRRkHCTbUNG8JtLg8Xm8JkqSZ7JU6bJdELBbXQtfHLS+I6QYBU60kc8JxGF
	 hFcPxkHEqIxmm4emVTGPAX04Uk7snNtf8yF3SC/1B1dDd2ksdWmnztO7B3rTuG7zqUx4e
	 3Jf99+6yv2qqmaQq4MtqqtYgVOJFOhmG6I1Hgc5dMW62hbQKxTAFj+s3ZswgM+wEOLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=INuGBbbA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A531B607D2E1;
	Fri, 13 Nov 2026 17:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=INuGBbbA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDD31F000CF;
	Fri, 13 Nov 2026 17:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590312;
	bh=BEoHnxlipzMIHFTaFPbRpvDuPAH4l1fURTzicekbsu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=INuGBbbAAK3piiqJw6WgkB3wYG/KjA92zd8HLLQq9sA/S65s9KTwRnFR6WgUPEGlq
	 BXE0WLw5BBMT8MfQqQtabi9jl7s8Zr8/cF5YDLu8u1zTIqTaulVa/4LHNjRxKkffbD
	 54d6D1STevh/+vERp14v/XTqR4itsX/BGbC8+LCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 296/686] KVM: x86: Conditionally resched when restarting REP string emulation
Date: Fri, 13 Nov 2026 10:47:09 -0500
Message-ID: <20261113153830.990389076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit ae85ac25eb671d174811cc3101549448671fd505 ]

When restarting emulation, e.g. of a REP-prefixed string instruction,
conditionally reschedule as emulating guest writes can be deceptively slow
and expensive, e.g. when shadow paging is in use and each write can trigger
write tracking.

In a perfect world, restarting emulation (or not) would be less arbitrary,
e.g. would honor not only host events (NEED_RESCHED, signals, etc.) but
also guest events (e.g. by checking kvm_vcpu_has_events()).  Unfortunately,
as pointed out by Sashiko, pio_in_emulated()'s read-ahead logic is baked
into the restart logic, as KVM relies on restarting emulation to drain the
cache and avoid duplicate reads from the I/O port.  I.e. re-entering the
guest on kvm_vcpu_has_events() or __xfer_to_guest_mode_work_pending() would
introduce architecturally-incorrect, guest-visible changes.

Fixes: 5cd21917da24 ("KVM: x86 emulator: restart string instruction without going back to a guest.")
Cc: stable@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Reported-by: Stefan Teodorescu <fane@google.com>
Suggested-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20261028173638.1765329-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6576c692a94eb..0a6fb6e08d1bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9218,10 +9218,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	} else if (vcpu->arch.complete_userspace_io) {
 		writeback = false;
 		r = 0;
-	} else if (r == EMULATION_RESTART)
+	} else if (r == EMULATION_RESTART) {
+		cond_resched();
 		goto restart;
-	else
+	} else {
 		r = 1;
+	}
 
 writeback:
 	if (writeback) {
-- 
2.53.0



