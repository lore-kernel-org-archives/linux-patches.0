Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061761;
	b=hL7bLG0072FuieU1ukKrznZIAn5KGKCQP9XEie4SLw5M6CbjWPuLzS29ojlsq/63YNly
	 pN5ePRD3qLUE/LElaB40YyI96Zprp32Lu5NIdcrR8SbtAjJG06OFkpMLrrn0yAWM4KTQx
	 92nxXF9w//KLwDJFq4rolzA+vUpW+sapL3ONRyAp0cCv+bRvh1hPy8g8NpZOB+s/JPx8V
	 /BdhgTNrwpAQBDlUwaQ5t/ZjQgjCE+LX1D5BcM7bz/G3lhWZJVuz4KhatUp7OIeObFXWZ
	 2NESGHoEAw/ti4fZAXK1w3kQ9l4hkwwFxzLNkVd1axxCxdMqaxIvLFFUtlFCjKgvyAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DHXjAZWaVb40SIbkl7vGPrsVF+1/T3e3L4xszKq1TkM=;
	b=YxFrmzDHi0mDfFf0irwWzwVk21Zpz15ElO/TqSRKG/fc3GmwfrKQv4YJxSCMOBCk3q2f
	 9pjG6isHUrMHxv7CD7V2CAlx47TGA+Rzv0jA8Ed9CYuee5hsVOCuCH6Q6qsJtvjLv1ehn
	 HkfaqRmSCLBz5EL14ZMmq4b9amaaoBMxJnV/jUb0ANfdn9EtOmZJhuDJ0TbHDwbbkvTnv
	 feIi1dJa9IWTUMtga7/8XIq+Jgbas6oxf2zNmLuaK0hxK/2+vOI2JzIhDNJvG0cgaqwRf
	 0sIOCszwbci2RE7Gdc7ZonPL8zaafJ/kWKc6UEzxSFaH2zNuhRNzSNumMH6hs4q2/jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bUImgxm2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A8A606A326;
	Sat,  7 Nov 2026 14:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bUImgxm2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7318B1F0089F;
	Sat,  7 Nov 2026 14:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061760;
	bh=DHXjAZWaVb40SIbkl7vGPrsVF+1/T3e3L4xszKq1TkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bUImgxm2Pn5PWYbMZ3XomwCnPpO7G97SOgPV26eCnC53ycTSZWS7zTPgDFleczOzZ
	 1zG0d30R7s3jqSJV37vYkPw19HS10NLIMq3q7lG+kHLPpw0V3bdH4kToR0BAEp7X6e
	 HQg6A0kX8yuBrTDdbk+KNKjar6vc3tbbkkkiXaKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 0798/1536] KVM: x86/xen: Enforce 4-byte alignment of vcpu_info registration
Date: Sat,  7 Nov 2026 08:46:54 -0500
Message-ID: <20261107135019.961173788@linuxfoundation.org>
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
@@ -878,6 +878,10 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcp
 				break;
 			}
 
+			r = -ENXIO;
+			if (!IS_ALIGNED(data->u.gpa, sizeof(u32)))
+				break;
+
 			r = kvm_gpc_activate(&vcpu->arch.xen.vcpu_info_cache,
 					     data->u.gpa, sizeof(struct vcpu_info));
 		} else {
@@ -887,6 +891,10 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcp
 				break;
 			}
 
+			r = -ENXIO;
+			if (!IS_ALIGNED(data->u.hva, sizeof(u32)))
+				break;
+
 			r = kvm_gpc_activate_hva(&vcpu->arch.xen.vcpu_info_cache,
 						 data->u.hva, sizeof(struct vcpu_info));
 		}


