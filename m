Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F226520C00A;
	Fri, 17 Oct 2025 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714711; cv=none; b=fBfMURqTwevMVBqZoSE9fEtBs+fnXWdnekX5b0SRQ/Ms0q5na16LMi9S7qvSUch41nV01Kd7CjTKl+fCwE9Ye3dx+w20omm041Mzf5hRA6giup4MSpKm7yuVe5u0nCGdcMYZ8PlpzICpWtUo6C49sAq77EXhOXqE8HJjeArQ66c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714711; c=relaxed/simple;
	bh=fJCLxE255BPNnpZJST0VdkcP1I/EmBrUTPDGQqG+M7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s036Fp9p9KxyTW87laiO/7lIeP8YPLjFADDZGbfYwlSnlTbOsc9+avqn8B4pMH/YM6MH8tKFTr+YPTVlrvxCPvbBLXBnPMaagN2oFxbhY+9RYnkXmjckieHp+IU+YyklEV68iocgHdDK6mEaVlZq2/TRtmol4cxKyskFtRF42gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a63jTBl5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a63jTBl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB69C4CEE7;
	Fri, 17 Oct 2025 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714710;
	bh=fJCLxE255BPNnpZJST0VdkcP1I/EmBrUTPDGQqG+M7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a63jTBl5A4hinjJf0cQEBB9RboJRI3brCPZ5Srn1gf8EHgl7EQDffHVI2smVDlen6
	 8yqthpTo2ErY1rqLVTjhvy3E+A7/iYJ1tG4dXwz12nU6600Cc0l22twq4xM5PV4IQ0
	 Nl9k5h9gOCMVJkeVmxqsXWFS3qSoIypGv2wLo43k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 238/277] KVM: x86: Advertise SRSO_USER_KERNEL_NO to userspace
Date: Fri, 17 Oct 2025 16:54:05 +0200
Message-ID: <20251017145155.829311022@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Borislav Petkov (AMD)" <bp@alien8.de>

[ Upstream commit 716f86b523d8ec3c17015ee0b03135c7aa6f2f08 ]

SRSO_USER_KERNEL_NO denotes whether the CPU is affected by SRSO across
user/kernel boundaries. Advertise it to guest userspace.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://lore.kernel.org/r/20241202120416.6054-3-bp@kernel.org
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Boris Ostrovsky suggested that we backport this commit to 6.12.y as we
have commit: 6f0f23ef76be ("KVM: x86: Add IBPB_BRTYPE support") in 6.12.y

Hi borislav: Can you please ACK before stable maintainers pick this ?
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -816,7 +816,7 @@ void kvm_set_cpu_caps(void)
 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
 		F(VERW_CLEAR) |
 		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
-		F(WRMSR_XX_BASE_NS)
+		F(WRMSR_XX_BASE_NS) | F(SRSO_USER_KERNEL_NO)
 	);
 
 	kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);


