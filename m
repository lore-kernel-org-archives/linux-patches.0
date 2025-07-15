Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D7F70831;
	Tue, 15 Jul 2025 13:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586261; cv=none; b=nzmpi5wkgQ/luHmF3hgX0ITozaOCnfjwFZWFPC2/feWDpkvHCmxpb4nSRFIvpszzweqWT+XPFUIQFihGcOLUUFiz0HouFApwHYQU875A0I2q3LNGUJ6fvqj3k+FMaR0J1oSc0qONZQFKgqk/FlPk/BTIC+pKs7Vq+bWCxLiZm4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586261; c=relaxed/simple;
	bh=vHA9/itdejVmBjo5GQdAz/9cEqxZB2RYrId7atyRsao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5gHO7jbErxq+ST3WN3I3RWjoRdzE6XYvKZpEnVCniDwUaCqCUEZeKMW3UMKcaErn2ORxsK5OJAWPqUxQRyXrXL0uUzCwy43PoGOuuwPD+t3ukfDwSwHr5YZUqgAZBL0mK6G4DH44RbLUNyBMMcbQ/1zGNMi4/BrIr2AYQddCRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNFzQM6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNFzQM6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC79FC4CEE3;
	Tue, 15 Jul 2025 13:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586261;
	bh=vHA9/itdejVmBjo5GQdAz/9cEqxZB2RYrId7atyRsao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNFzQM6x8ExmDT3M52Dte+Vjm5fCvAOKdtt6iK83QikIOhLacODBpZxtF0a5dNJA+
	 KaRweZNOKOaMFJI8v2q85/knHBs0cbC45MSj7UXnsN6uXuIb8c7clGSJXhn6zGKzTt
	 o2exo5b95MlaySnSfX+T2EMpfYknjvLnovpsX1vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH 5.15 77/77] x86: Fix X86_FEATURE_VERW_CLEAR definition
Date: Tue, 15 Jul 2025 15:14:16 +0200
Message-ID: <20250715130754.820125815@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Wang <jinpu.wang@ionos.com>

This is a mistake during backport.
VERW_CLEAR is on bit 5, not bit 10.

Fixes: f2b75f1368af ("x86/bugs: Add a Transient Scheduler Attacks mitigation")

Cc: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -418,8 +418,8 @@
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
+#define X86_FEATURE_VERW_CLEAR		(20*32+ 5) /* "" The memory form of VERW mitigates TSA */
 #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* "" Automatic IBRS */
-#define X86_FEATURE_VERW_CLEAR		(20*32+ 10) /* "" The memory form of VERW mitigates TSA */
 #define X86_FEATURE_SBPB		(20*32+27) /* "" Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* "" MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* "" CPU is not affected by SRSO */


