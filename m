Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB66A15CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292FCC433C1;
	Tue,  8 Nov 2022 13:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915841;
	bh=ldEUAuVvdo/yl771433SvqfqzQ4Z500g1g3dEa1EBGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFHwoKxCKbfWkC9kW5WbK2JPYmxJoauO8SltAA0R1kEywwVTF+wgZZPrq4byH8KdA
	 adnu/BLFeVzpRBvCwZIuBcu2PatCC9VKMqwUpnw+h/rq6Tq7ztiffRfsg5OiGSz9Qc
	 O7q93mLc9l4wY1IjzDIl1IgzVI5Cmrt6s/r7H/Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 107/118] KVM: x86: Mask off reserved bits in CPUID.8000001AH
Date: Tue,  8 Nov 2022 14:39:45 +0100
Message-Id: <20221108133345.374014211@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jim Mattson <jmattson@google.com>

commit 079f6889818dd07903fb36c252532ab47ebb6d48 upstream.

KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
actually supports. In the case of CPUID.8000001AH, only three bits are
currently defined. The 125 reserved bits should be masked off.

Fixes: 24c82e576b78 ("KVM: Sanitize cpuid")
Signed-off-by: Jim Mattson <jmattson@google.com>
Message-Id: <20220929225203.2234702-4-jmattson@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -860,6 +860,9 @@ static inline int __do_cpuid_func(struct
 		entry->ecx = entry->edx = 0;
 		break;
 	case 0x8000001a:
+		entry->eax &= GENMASK(2, 0);
+		entry->ebx = entry->ecx = entry->edx = 0;
+		break;
 	case 0x8000001e:
 		break;
 	/* Support memory encryption cpuid if host supports it */


