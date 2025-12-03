Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12154350D7B;
	Wed,  3 Dec 2025 16:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778584; cv=none; b=iGEUrenGq+ctKuHeuMHk64gFW2rWrdrKaH2rcTlgAjwlUrIaxHau4vSVhbkN605ljoZfuF9QiCirrZRue9iOpBRgvUYeerDtMwmQFSy48uTAgJzdJeHIPu+FY+SlHAOaF/Ycw7zfKYm7Pbmv0jZc1bxCRXBoPZTSnGGmAjegsRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778584; c=relaxed/simple;
	bh=wuUILEwP68v4MoOJnV3abwvdWjWdzsgSTENpffwC1fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfxcE0tzQOnskyRF5/vdr1p5Bc3aFWtI6Rrdy+qsMAoVTlmeRvalccjyffgk+tNFc9omL6Ucayf/flN9RP6OeeCNkOX0zuTCXBCtj5H0WrBg+Vww431EdAEnAnZkKKClD7Us6YeetXrMCKDG/DJmywSmOsV/m/tMhdBVwBblGvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ReR6ciha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ReR6ciha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34127C4CEF5;
	Wed,  3 Dec 2025 16:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778582;
	bh=wuUILEwP68v4MoOJnV3abwvdWjWdzsgSTENpffwC1fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ReR6cihaMkXgyjWGDztGCdlai3IO60cFtXwq4h+TmC2b+jX6NBuD4V3mt1cw6lznr
	 LasWti0FlcsxbcZAH7OZWhT8jDCNqVru6UCfWvLHDI2TIeAWEmE3DFvCvG7+ut8N9S
	 HeXmVA7s1P0w7F30qw36vEg6U3Y9YGTh5E2t5jNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 5.15 390/392] libbpf: Fix riscv register names
Date: Wed,  3 Dec 2025 16:29:00 +0100
Message-ID: <20251203152428.544978843@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit 5c101153bfd67387ba159b7864176217a40757da upstream.

riscv registers are accessed via struct user_regs_struct, not struct
pt_regs. The program counter member in this struct is called pc, not
epc. The frame pointer is called s0, not fp.

Fixes: 3cc31d794097 ("libbpf: Normalize PT_REGS_xxx() macro definitions")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220209021745.2215452-6-iii@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/bpf_tracing.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -206,10 +206,10 @@
 #define __PT_PARM4_REG a3
 #define __PT_PARM5_REG a4
 #define __PT_RET_REG ra
-#define __PT_FP_REG fp
+#define __PT_FP_REG s0
 #define __PT_RC_REG a5
 #define __PT_SP_REG sp
-#define __PT_IP_REG epc
+#define __PT_IP_REG pc
 
 #endif
 


