Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591117;
	b=1gW5JlYQIu9tmftjQGD/pUk8/RSg4HFfP1UvIV/H4y8oz0BZXpuVU0BdSlVHlE7TRdqx
	 dXy9s8XwYF0/B4dnE38u5h0/3UF3rvbec2uSqCA/AAP3HN4ONcDA9syv4Iob/HpuPuLzQ
	 Byc0mit5ekPVAFiPaG11gDXAv3+YdPCi4n8DqYzxnXM9F32XwsLSCSxK7Icis41vlQwmO
	 kBPuX6l9xH+HmLZlcp2cBZt/9SqTmDbYg4Ml5LFWHAqD/jDrW+SwMCiSUNQVQhAg9rjY3
	 i8oiO1yz5VcMo5bkCbzwDmjTRIMORtr34JiNO83TdOyF0oHT0cF20nGoYwbMHf2hoOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FICAKMeEJf/uDUFAvmYigfXOba5YBh1G+jGQVVhQ3vg=;
	b=nm7dyfMLQzPbNTzH/W+b46A+Y3Vy5D1SMLxiojTiyoTQ8Q+qXlYFx+zJc1u9AWqHOGeN
	 1MakSbbuUU9lSenGu1SMOxRbiHeGlOGTVl6t8/KiOYX1/qkyhku4jw0qnnUwQCh6gRFRT
	 /YwuGRflBF71qiYBOBdmnmbbPxM4/nHTW+Ms6cywuGk6tzRWMX1rMABldEDTXlmu3uuQZ
	 LgQlL7q9KP4LGlzM5QyriMBLj1iVQSzGcbuRgExRe1x/doK2558QteqxjeTn8rnvv1s2Z
	 VIMIrFwuq9NVd6/1uUp3qdXUKZpWmSRmMggz4L+fwuT0/NzdCNHUix7IK+rvAdUSOYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tuk2pUk1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B56F6074B22;
	Fri, 13 Nov 2026 17:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tuk2pUk1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97531F000C4;
	Fri, 13 Nov 2026 17:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591117;
	bh=FICAKMeEJf/uDUFAvmYigfXOba5YBh1G+jGQVVhQ3vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tuk2pUk1h3+LzOa/zeQ8kpEAG+GZ5muoDkL6B8pZITphJWCP5I36NSOcI6BNKWZJY
	 avq8/eVQmF+X+JTZUyh0DE8Gka0rnmO1tdIDhzh0YtpYpYeh0Fj2Hxf27l8dArKTPq
	 X0eC7fFceiw+yKdV5YbowEhZu0UbKPQBp64+yLjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 267/670] KVM: x86: Conditionally resched when restarting REP string emulation
Date: Fri, 13 Nov 2026 10:47:11 -0500
Message-ID: <20261113153820.925916332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index ea8b6ec561dc4..627b5f53d1684 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8835,10 +8835,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
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



