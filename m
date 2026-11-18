Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035460;
	b=uMWxhlXTFT+vwAgvkJwVPIKAQeeu2StGnEoJ4WPz1pDau1GTk+17KdMF2O8KaS+8y6WD
	 rpXY79Hm7sPJ3LYiwH13c2FWv330Jbzo1wQbfZKNCP/RU6LUi4c6SvzyTJvJl6VGYW1mH
	 5t4IPtN0dTrPEsUFFtb07OqonoQmNVvSIyzceTAwckCMfgvlS5UQqGa1XFEkj3m1Vgi+N
	 8p0GpQLYQCYP0Uh9LEkcrjmaRFVUMoOyONoWE0h/LXNOlSYJG1kaWMeWKfusoV5LZCTBr
	 EhVvKHjtu3Ukm8eSvN8alivvjGzIZWyA8lOPJduR/dZiqfNAq2pCovpGo2FH9t0biRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p7dVVTdPpCvYvj8Li9z0erf4jxVm1SuCvW2FQmi0K84=;
	b=tqU/BgxzyXQsme2iFEQgiMNeeH0YkHaWcwY1PgFC3Ifu1RRGq4QfoIqC6hc88vWGF1LO
	 ZiEfx1ipWamkt6PYyg7lB/7et6Coaf3qPqXkW3MMaAUwoUFN2fcX4POyX9wgSTB5f0gi1
	 mgLJaqCkPITvAEcyKBeRJ8rr3Y6eGW0trUmxlKDpPHI6oGPIULTGD9NxONGjibUSeIBZf
	 63CE9td/24zgq0MSTLeyw8KCM27JYPNDTCYAiClf54wpJ2NzMetgSrlFR+sL/u1R4lGSj
	 7hoTZkr6gQJLsaPMzwlrSt7iinS1WZFi2Grs2nvnGTmWHjgAlkrYHxNhzlKROWD5ldg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gKeyvgD5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EE3606A31C;
	Wed, 18 Nov 2026 20:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gKeyvgD5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1591F000C4;
	Wed, 18 Nov 2026 20:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035459;
	bh=p7dVVTdPpCvYvj8Li9z0erf4jxVm1SuCvW2FQmi0K84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gKeyvgD5bRR7Oq6MwDfxaSIPvyr3+WkMXu0W/zQZMhjgt4HNv3XyBIac8PNJ9E5h/
	 dAaEfdzcnbSorYPLx5t2XVjbuaMhikbqGBjrG3Bhhtc4XwQu0wDGWGaB0mFcGBXjA2
	 wius3GhIG0Gd4F068zP244g453S1BDfPM4ynnBHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 0713/3318] KVM: Use goto to handle errors during memslot preparation
Date: Wed, 18 Nov 2026 15:22:15 +0100
Message-ID: <20261118150339.836138829@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 23a205797cec86f391d0be886b9bc741e1262063 upstream.

Use a goto to unwind early memslot changes if preparing for a memslot
operation fails.  This will allow moving the creation of guest_memfd
bindings into kvm_set_memslot() without needing to copy+paste the unwind
logic.

No functional change intended.

Cc: stable@vger.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Link: https://patch.msgid.link/20260922001332.1121266-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1877,21 +1877,8 @@ static int kvm_set_memslot(struct kvm *k
 	}
 
 	r = kvm_prepare_memory_region(kvm, old, new, change);
-	if (r) {
-		/*
-		 * For DELETE/MOVE, revert the above INVALID change.  No
-		 * modifications required since the original slot was preserved
-		 * in the inactive slots.  Changing the active memslots also
-		 * release slots_arch_lock.
-		 */
-		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
-			kvm_activate_memslot(kvm, invalid_slot, old);
-			kfree(invalid_slot);
-		} else {
-			mutex_unlock(&kvm->slots_arch_lock);
-		}
-		return r;
-	}
+	if (r)
+		goto err;
 
 	/*
 	 * For DELETE and MOVE, the working slot is now active as the INVALID
@@ -1923,6 +1910,20 @@ static int kvm_set_memslot(struct kvm *k
 	kvm_commit_memory_region(kvm, old, new, change);
 
 	return 0;
+
+err:
+	/*
+	 * For DELETE/MOVE, revert the above INVALID change.  No modifications
+	 * required since the original slot was preserved in the inactive slots.
+	 * Changing the active memslots also release slots_arch_lock.
+	 */
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
+		kvm_activate_memslot(kvm, invalid_slot, old);
+		kfree(invalid_slot);
+	} else {
+		mutex_unlock(&kvm->slots_arch_lock);
+	}
+	return r;
 }
 
 static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,


