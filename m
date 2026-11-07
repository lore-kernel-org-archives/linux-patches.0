Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061900;
	b=F/JQPKVMJgLJNKxLtTOxbO+z54GktLIOYZgIHoN6WaZ5o19xCUs9nScM47P1l+jbZ/qo
	 nvu0iAJz8W/HlAs9y2xxqOEQXn38SWK4HBnwwUCmMfxc9iBlJ1P1XkTLmMURexY4n4p0R
	 MsmCADKm5CmFIkUcSmcFiAfpp9G0996ZsLNrah6jiVpDDdXXYYAz5Zx253mJhrdcfetK+
	 KIafiIQSewtMaD+LIf+XfbQLB0qz73D/J27RhwJERswYH9D8KTxs/chbNvU9vhyR8Q24O
	 MTB7UjC2E6ao8dT3ZorXyFuPm4mPZJ3sOLyo0eLpzsRG0WYCfuum816esgw3ae9xMEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5mDgGQFvvOUcFnwwFvalYrDllgNZS+vXQEK9wwrL4PE=;
	b=w0tkJPIzLhBZE8tkSqW9685Ylay62IgDc0lXz9So6QguCE9XwBa+UHulPFgvZtd7gO08
	 1tDPIkED/XrC5YUkAGV5S18TN96vI84THAUsWvJiz7F+g6bIeaIcSL2Di60Azxw25sw4j
	 NwN09MwHiAPhrJxRZIox+ENjp1ANfy81p1OxSLvXeWROQaDDYnbqOwT1ARbJtjrJRQ5Sv
	 KXeglvufEfp9pUdTf/mP/nG9w6S0bt2Uf8vWBx0+R5DFwDbjJ04ou2/kEmuC5PUR5HtK2
	 y24CJN/FL7bVRi7ymIwkcHh/SXVXDajwSKDIshOYBbI1bVXGQJ91+B2yVMVYnIJRbJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Hmj/YHk8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6350B606A326;
	Sat,  7 Nov 2026 14:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hmj/YHk8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126761F0089F;
	Sat,  7 Nov 2026 14:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061900;
	bh=5mDgGQFvvOUcFnwwFvalYrDllgNZS+vXQEK9wwrL4PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hmj/YHk8HBb2ESWW8RsWuW5nTtc4QWSehFO7papctiwX7HaIYOHr9sF2/CVz6jC1+
	 e67FRC0vfpwQa1sq3x2hnLclToAVtvIKOwj29Ss9VrSjbK1wSGlhOHfDw4zeZy7nWw
	 01nWX8LdntZzoQ+3VhPsv9KhKKcJLJrdHvNOJ66Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Dennis Tighe <dtighe@google.com>,
	Sashiko Bot <sashiko-bot@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0872/1536] KVM: guest_memfd: Gracefully handle xarray errors when binding a memslot
Date: Sat,  7 Nov 2026 08:48:08 -0500
Message-ID: <20261107135022.036511832@linuxfoundation.org>
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

[ Upstream commit e6ecb88711d93b9e014532f17d3d29b57e80932c ]

If inserting a memslot into a guest_memfd's bindings xarray fails,
propagate the error back to the caller, i.e. fail memslot creation as well.
Signalling success and continuing on with memslot creation results in
use-after-free, as the guest_memfd instance will remain reachable via the
memslot after the file is freed (kvm_gmem_release() won't nullify the file
pointer due to lack of a valid binding).

Opportunistically WARN and reject binding if KVM_MEMSLOT_GMEM_ONLY is
already set, partly to guard against goofs elsewhere, but mostly so that
KVM doesn't need to worry about clobbering flags when unwinding on failure.

Regarding the unwind, the slot must be fully prepared before inserting it
into the bindings, at which point the slot becomes reachable.  I.e. waiting
to update the slot in order to avoid the ugly unwind isn't an option.  And
as part of the unwind, explicitly nullify the relevant bindings, as xarray
can store a subset of entries when populating a range.

Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Reported-by: Dennis Tighe <dtighe@google.com>
Reported-by: Sashiko Bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260823135031.4F6DC1F000E9%40smtp.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Link: https://patch.msgid.link/20260922001332.1121266-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: Used gmem instead of f and omitted the guard and rollback cleanup for the unavailable KVM_MEMSLOT_GMEM_ONLY flag. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/guest_memfd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 71afb0ca0cc94..2e9b5129b5a22 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -520,7 +520,12 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	WRITE_ONCE(slot->gmem.file, file);
 	slot->gmem.pgoff = start;
 
-	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
+	r = xa_err(xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL));
+	if (r) {
+		xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
+		slot->gmem.file = NULL;
+		slot->gmem.pgoff = 0;
+	}
 	filemap_invalidate_unlock(inode->i_mapping);
 
 	/*
@@ -528,7 +533,6 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 * not the other way 'round.  Active bindings are invalidated if the
 	 * file is closed before memslots are destroyed.
 	 */
-	r = 0;
 err:
 	fput(file);
 	return r;
-- 
2.53.0



