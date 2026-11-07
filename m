Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061757;
	b=tJqQM3adSN6UzQHU+jrm4DBXA7zZvNpt/AjWZJpHCcRsxhQSUaLRFvI45FhmdUy0t/Co
	 Aq2ZGR5HqhbhZE9+pj3PapTc9EQDP/JVnWDrNybmV5GGsMt5ayt/ZQ8VUURN5a6olRgmu
	 72ATD0BX0AwRAYOIZDzxwwaMnvvQ+O6oxP3jBJs2A2cMS+8uETyiiw4pHBwektZzcYLnF
	 4oo74BijJYmTw4XeRoEYhMVXpqv1otoTgkR6Awm4M5WNTPurK5n2qwwuT/M7+Cgr6Nd9V
	 aYbPfa/pnqTLfy59zOrKMF8pIbJxfKe/0YQY+EnM1g1E5ptiw1pk+SAWubmwFgJwMcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XrHsdnHZc64WifmKHhqXWSQp6sBnlHTMZqCy74e8fpM=;
	b=3MKE2moSIwDo93RST7lBKq9LAunZR4JA666YR0UXyw/lQed9jfVjYFhAONhqIv2VTiYY
	 jmiPLATfXAPYEPudnpMo1pHRFSo91rJcLIl7YpKrT7Gogm2W7OMtI3kln6Q0iTgYGQ5Cl
	 yUBiNLLeszeprxSd59RpXt5kyL88nGlTQNxyk3ciGjNSxHJfkIeFYF17liHy1QxeabF9E
	 RFkCdtBlAuxrjfLJmLTLILtauub3rl2Sp5oAys/qJVSw0Y6NkbRR/1xDkm7/YIYd/Z/J+
	 SeTkNnrYsOunlP0eOofsDzvfu52CI7lblcQdM8hzu1PXtabYbeQxl01t4VQ1a93D+HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qS8jlI+T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16528606A32C;
	Sat,  7 Nov 2026 14:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qS8jlI+T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88531F008A1;
	Sat,  7 Nov 2026 14:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061756;
	bh=XrHsdnHZc64WifmKHhqXWSQp6sBnlHTMZqCy74e8fpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qS8jlI+TEdkvTC9HXuVMcz6wTxFVTyy7YuoA5HDTcxQrZl9KGd2CFlMm6Uw4a5HOu
	 rCKRLItC72Mq28TY11lvi3Xl1JEPNdIpBnSIeg2OBmQt2dgdPvC4v8IZa+Vk+erRbZ
	 j58YNXA6VvppvcHYnpZsyeuOqDmP12jL5K6gAFBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 0795/1536] KVM: Use goto to handle errors during memslot preparation
Date: Sat,  7 Nov 2026 08:46:51 -0500
Message-ID: <20261107135019.879108056@linuxfoundation.org>
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
@@ -1914,21 +1914,8 @@ static int kvm_set_memslot(struct kvm *k
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
@@ -1960,6 +1947,20 @@ static int kvm_set_memslot(struct kvm *k
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


