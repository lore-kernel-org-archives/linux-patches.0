Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619887;
	b=wl+OBTz6kRYH2G/waYl20+ADRLiTNEOOI7U3rP+XwwwQ83AsZgHDYQiURHysii46Czdh
	 odX5pP/nHYtSpMe1IzzOUyZsbR2KxJ65H/WGLqgiC79/PlB9sdCQWaAmq3f1WbZPcJLau
	 IaX+KF/x4T0EvEPpHayz1FOQMCzZ15w3ddt0zHXAVvvNLDBT3IVd5BleiEjKPdBREiLxy
	 J/QLiUOXxyRm1+DvqyUbFDCM8q/iQRBkbN+M340XuyinJH2eNHpCes1v/36bFJyakVwZY
	 H578NOHO6A74kD82RBhB99oUoRj16f3Yy71+irxOLt5n5WmjPLj/zisoDm0xzfknMig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ts/oAlZ34jaOmyUVh7umUme5hAz2xEhgwIpxwr0QCrU=;
	b=kUVqeT3/kNcmOU6hIlF//ze3aNMr7IvWjHXTVcSHqIJs5h7Gv+O577FnkVixM14zXbtO
	 g8TREE9P7iE6k4U45iqcOLm9HYQWY5O0grPv/FbSpTIukoxdyhuCJpBHPN/tEEjEC+q1e
	 2IzSe3zWgEFHQ/A8KccFf3JL2ggXfcSgjptfKxKeepNsABlJvTvwqsW5na/nNbzKiT2yI
	 O8xpy3RTDhFsKGQStSN0dUpisT8UY/txeKr8CPZRGaKHlj9lLp/NOtG9egGJUBWurzUK/
	 GvynDyAEb7wm7VC1tt/M4ZcSpzD2pmwXEEZxutF8U1INdJNQs+euv6rjRbFhGSjI+Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="achW/jf0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FFE606A323;
	Wed, 25 Nov 2026 15:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=achW/jf0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870AC1F000C4;
	Wed, 25 Nov 2026 15:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619887;
	bh=Ts/oAlZ34jaOmyUVh7umUme5hAz2xEhgwIpxwr0QCrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=achW/jf0Fp6M3FKg+VnJdoiiBeWsAd47oJesVkeTQqhrMLGUv1e/o3fGkXpyAVcto
	 R1S+0l/EULUu3AVWuX9NAQGvX7HZb7ZT5zJAK6mEkPhTLvl/vwmV+/tYrEmKzOhGyo
	 5kJBbYvoMSl6SGv+LDaa7qL3Yy5PKD48709CmqTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Jason Andryuk <jason.andryuk@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 7.3 0737/1005] x86/CPU/AMD: Dont print reset reason in VMs
Date: Wed, 25 Nov 2026 15:34:35 +0100
Message-ID: <20261125143839.022638083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Andryuk <jason.andryuk@amd.com>

commit ea51d1a4c31fc8320c34f897dc5296a0bfc5c7ca upstream.

print_s5_reset_status_mmio() expects to read FCH MMIO on baremetal.  VMs don't
have emulated FCH registers, so there is nothing to check.  Add an early exit
when running on a hypervisor.

The real motivation is Xen PV domUs can't boot on Zen CPUs.  PV domUs PTEs
contain system physical addresses - they don't have the concept of guest
physical addresses.  domUs can only map physical addresses they are assigned, so
a domU fails to map the FCH MMIO addresses.

However set_pte() does not return failure, so ioremap() returns a pointer while
the PTEs are unpopulated.  print_s5_reset_status_mmio() faults when reading
through the pointer, breaking the boot.

Limit the reset reason printing to baremetal only where it actually makes sense.

  [ bp: Massage commit message. ]

Fixes: ab8131028710 ("x86/CPU/AMD: Print the reason for the last reset")
Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261104013026.185392-1-jason.andryuk@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1362,7 +1362,8 @@ static __init int print_s5_reset_status_
 	u32 value;
 	int i;
 
-	if (!cpu_feature_enabled(X86_FEATURE_ZEN))
+	if (!cpu_feature_enabled(X86_FEATURE_ZEN) ||
+	    cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
 		return 0;
 
 	addr = ioremap(FCH_PM_BASE + FCH_PM_S5_RESET_STATUS, sizeof(value));


