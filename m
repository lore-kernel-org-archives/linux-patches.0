Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623159;
	b=hLfWZANcnl3Acrt+HstAysQl0jnQ8c2tnKQqBsrQ7akNUX9DFiQ/QUJOhuyH6DpcOQyw
	 tAxqNnQzgVTOFbCwR4glTIQaO64x1IonM5DqccSFK5n/0y1085EoBz7etaYPfXoojlMP8
	 NuSx/FfvqA0rH+XZGkB1+iiSMKNTFshgzbE228nOlNOypiE6cYd2zQY+lYd9W523dwF81
	 45CWGuH/nv1+pHExZ1AZ9YMBZctLtFOffilYM3nF5pvjwNtciwUn1Pb1mh1miJCRFpdfv
	 3ueNdl46NDMcRMot8AKYjOdSHUFgAPP6omXvVnlFwCF0mW+2N5zqbQmxKAfTzB93ABA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lt3pRZsadrcv04MtrTl2r5ck0bdB4JWs8EbZThyE/Ac=;
	b=nQql3v31g8zkwTok9R4kkb8hPPuSAr0aS/BpxpE98v5buIzm3ojkfOk6zXq4Q1m94R4X
	 WHOXfK2h61+UZSZTskdcvJZ+9PFfa5O0fBODjKjXfjalcVVHhTF2tjfJzyihqZpaI9tMD
	 13rjEY5IGR+OLdsRyX5taQKiYpxJ4oPO9JNgnxCeUa2G5U94RhquWs/7vl3fx9wfVONza
	 +XmWvxf1G5ABc6IdPYK8SdKR4BbeE1A6NcqyOnR9cUP+nSJdopz5PrsPMTEiompbY/qyS
	 2BBi/YmD0Cv57Z+yzkTck/Q/nu19u/cftJNU7TvlvMNIw6bZCEvHOXrfiUvFAc2R75g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMSQAYw3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98256606A32D;
	Wed, 25 Nov 2026 16:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMSQAYw3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDE41F000C0;
	Wed, 25 Nov 2026 16:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623158;
	bh=Lt3pRZsadrcv04MtrTl2r5ck0bdB4JWs8EbZThyE/Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMSQAYw38EdEVTEkav5NPbIPHAd2DVdB2boKTalE/UFEsZyTIeTQcdwwzHJ7fHBsB
	 6W78CTIgaaY4f9vihTdPkHK8l2wRri8H9NIljPDuZzeYFbLQSWdjktO/t1bKeUPtbM
	 Qiv9fHKnuBM+L3jTyJwVApHHC4UXI5M8azoLxJQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Jason Andryuk <jason.andryuk@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.18 769/990] x86/CPU/AMD: Dont print reset reason in VMs
Date: Wed, 25 Nov 2026 15:35:36 +0100
Message-ID: <20261125143840.067721551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -1370,7 +1370,8 @@ static __init int print_s5_reset_status_
 	u32 value;
 	int i;
 
-	if (!cpu_feature_enabled(X86_FEATURE_ZEN))
+	if (!cpu_feature_enabled(X86_FEATURE_ZEN) ||
+	    cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
 		return 0;
 
 	addr = ioremap(FCH_PM_BASE + FCH_PM_S5_RESET_STATUS, sizeof(value));


