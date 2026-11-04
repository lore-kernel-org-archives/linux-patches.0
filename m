Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831823;
	b=M07qC90Z4bK+x6rhLuGN6TPh6gjt/4H8Psa1F1646N8zoeoD+/eRevrcEx0hSh6P4yrv
	 OiJvNhh+Mbvd8YudkC+KFdlrjY7FjaaL3JAfwr28Qf+AmOA3x/nEnBNJyiuq8P+EiQMhl
	 MFruYSRhgDs72VcSsKJmi9KB7a3WNd+gnnE7ADrACaEu2NorQGCTRchJsqb/hSfOmku5R
	 XGTY68PJlXO1dpLH4cGXMunVtxOCUPMYwUrnemHVY+kBH0nmNk1TZVvEw0PhwRoX9uvIC
	 PO3qXHSP1UAqu8eQWdJm6j7Nhets8eu7492N5kWbEhJlLkJzHRasTSPiicp/geD0OBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5/hQFq3fYpaqb9UYsZ/cWyfcZNHxh0s4IXFVrGiVWXo=;
	b=GHOc9ugvO0Xd7bvfPcZSrXQmVQciH7OwJJW8JDGJCcUemBI3QQtX++Bmflt+iWatDmOp
	 VD3ke8rWWQcBAXHTQXvyuiLZcmcCGOsl8tKm19f4MpNXvRDs27QJsOyOHbgiVgxAUjZV+
	 Yi2ORxstMWojwlBUHoof8NRdBMpkUA/lSzczcpWzZuUY+ijapvQd57QM1C1iop0eCRMmz
	 NX599JXEeM23xQLlJwrFwJlOO8WD9E1eVbI1KON0wZYgtuqncfQD5UsjLYj7IHsT/mVY8
	 6E+fibWOMF2OLSlgatOraYMfBq3o60quDUqz6lcagBe4lif4KPlGu3Wj4M05DeQWgEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R214D/OZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2A0606A852;
	Wed,  4 Nov 2026 22:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R214D/OZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478901F000C1;
	Wed,  4 Nov 2026 22:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831822;
	bh=5/hQFq3fYpaqb9UYsZ/cWyfcZNHxh0s4IXFVrGiVWXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R214D/OZIQsKMdh1GQONpRoJH3x6SPKT50Cz/V5R5/8T24qI1NT9ABvUgumYCvGEF
	 F1A7dcWCgeNAIOROV2C4jwZbXviMH1hycWnu2jIxOu3J0EViIdqXdUrPUNK1v8L8iU
	 GmYh5TJNY3LD54I1JWHt2TpecvGR3I358XWMF33w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 0933/1005] KVM: x86/xen: Enforce 4-byte alignment of vcpu_info registration
Date: Wed,  4 Nov 2026 16:11:06 -0500
Message-ID: <20261104211109.265445840@linuxfoundation.org>
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

From: David Woodhouse <dwmw@amazon.co.uk>

commit eacdb76c5f04956035c5d7f7e1973028f30684a2 upstream.

Xen's map_guest_area() enforces that vcpu_info is aligned to
sizeof(xen_ulong_t). KVM has no such check, allowing a guest to
register vcpu_info at an arbitrary byte alignment.

Enforce unconditional 4-byte alignment regardless of the current
shinfo mode. This is sufficient because subsequent commits ensure
that all locked atomic operations on vcpu_info fields use at most
32-bit accesses. Return -ENXIO on failure, matching Xen's
map_guest_area() behaviour for unaligned requests.

Originally observed in review of an unrelated patch:
https://lore.kernel.org/all/20260604193554.1BA311F00893@smtp.kernel.org/

Cc: stable@vger.kernel.org
Fixes: 73e69a86347a ("KVM: x86/xen: register vcpu info")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260604193554.1BA311F00893@smtp.kernel.org
Assisted-by: Kiro:claude-opus-4.6-1m
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
Link: https://patch.msgid.link/20260831213632.81023-7-dwmw2@infradead.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/xen.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -926,6 +926,10 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcp
 				break;
 			}
 
+			r = -ENXIO;
+			if (!IS_ALIGNED(data->u.gpa, sizeof(u32)))
+				break;
+
 			r = kvm_gpc_activate(&vcpu->arch.xen.vcpu_info_cache,
 					     data->u.gpa, sizeof(struct vcpu_info));
 		} else {
@@ -935,6 +939,10 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcp
 				break;
 			}
 
+			r = -ENXIO;
+			if (!IS_ALIGNED(data->u.hva, sizeof(u32)))
+				break;
+
 			r = kvm_gpc_activate_hva(&vcpu->arch.xen.vcpu_info_cache,
 						 data->u.hva, sizeof(struct vcpu_info));
 		}


