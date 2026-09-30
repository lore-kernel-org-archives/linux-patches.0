Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8398552FE39;
	Wed, 30 Sep 2026 18:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793785; cv=none; b=pBqG4mgZrbFlnuahFxRejGuzZJiXUrrwIv8zeFKViZ8bJj+9IHuKiutBDZF08l3J2zm3sYVXpU5RIhBdxtd3rAaIaP8fvUELxkf136wfm5uvfd8RdUVR6oLIqTMWizuFdHESJxx8+A13qu+1xcGKRKdAfkhvTFfNW0I//7ytDXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793785; c=relaxed/simple;
	bh=olWBMWIpg778x28YxILsIpsdes9r4K2hOYmMbP1tcuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqtQbgJ1xDEqxbrQ7IqAgd0eiL80TrjNTr8FioDiP8Ox25EWzEcgZ8fUt3uYUKl2sEcp6zeOs+ce3XwZz7cGyNxjsnGX+reAbU4DuK5lJmx09HASkruedBbk4ngKXhgkAwDz5t/UjQz1ZchbVAfCnYechyvsXh89UwsNIwkRdoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxU+Apjp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxU+Apjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0BA1F000FF;
	Wed, 30 Sep 2026 18:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793784;
	bh=r7ui+4l7S3vRbpwH5Yh77jNBy5timjDlgLYCKBsSxaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZxU+Apjp3OG0PYhTC15l+TfU3y4P3cUpSE6vVbnTXieMAKoFPzmBaVWXJCxusGo0d
	 BAoU10t4NYrtmSfh65KCLPc+S99N5FAyHakSJcbOrhGoDz9TzBeQOqyHZ5teiPXoj+
	 924n5fdOizvyv8WmP3+YSZnTyDVHuO7edFDnEqWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 378/395] x86/sev: Add internal header guards
Date: Wed, 30 Sep 2026 17:30:40 +0200
Message-ID: <20260930152348.897397265@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Borislav Petkov (AMD)" <bp@alien8.de>

[ Upstream commit f01c6489ad6ceb8d06eae0c5123fc6cf39276ff1 ]

All headers need guards ifdeffery.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20251204124809.31783-3-bp@kernel.org
Stable-dep-of: 6c43c72748ff ("x86/sev: Make vTPM SVSM calls preemption-safe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/sev/internal.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/coco/sev/internal.h
+++ b/arch/x86/coco/sev/internal.h
@@ -1,4 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __X86_COCO_SEV_INTERNAL_H__
+#define __X86_COCO_SEV_INTERNAL_H__
 
 #define DR7_RESET_VALUE        0x400
 
@@ -85,3 +87,4 @@ enum es_result sev_es_ghcb_handle_msr(st
 u64 get_hv_features(void);
 
 const struct snp_cpuid_table *snp_cpuid_get_table(void);
+#endif /* __X86_COCO_SEV_INTERNAL_H__ */


