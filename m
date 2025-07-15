Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FDC84A35;
	Tue, 15 Jul 2025 13:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587398; cv=none; b=C9yskLZDjRChVByERCqdEHe+dpV85uA2iCostGAyhqdOP6kxXWYsc55+EnDsbnBwR2yi5HX+a9G2Gw3T+Bk/8a74/ewoWFyS7rpIwI9+0LkvQ4mT/u80tcObH5phJ2MqlakqKCqH0RCHo2ylo5V89vG/mquoLADzuHEgqX6rFDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587398; c=relaxed/simple;
	bh=gojUl8xaDuh9LY97mGlpMB7eTaL9m+vWzMVD2cS2Afk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLOlHvMbvASiKHe1twGQWowWq4LBOxQx3pLo3Sl/F8NY4ofCBbeilv8VQ9E2A/aGbwamN8v4oq8DEeIGDTfgmmxLi2IPYugELduBrPf/1DcsCMBVEZwoLM2SqlfI/VmWd8dLcJTeCuEm4dhP4AlbMFFAep/opT3Pts0g3ab6RNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0L69Ongl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0L69Ongl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CAFC4CEE3;
	Tue, 15 Jul 2025 13:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587397;
	bh=gojUl8xaDuh9LY97mGlpMB7eTaL9m+vWzMVD2cS2Afk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0L69OnglIROmEo4+36fF5ZBGkXlj4BNfJdvtfBqYZwq6JbfPDvBFdaA8hZiul59/n
	 uPfYQGVNuhQ6yuouna5oveaJOmQZ3YWjkvW45PpKgB6teSCnsAF3ZeVR8l1Un1N5I0
	 jqjvtMFYQaygysiWvM+8tU/DKg776OzRT196CWfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH 6.1 86/88] x86: Fix X86_FEATURE_VERW_CLEAR definition
Date: Tue, 15 Jul 2025 15:15:02 +0200
Message-ID: <20250715130758.020374948@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Wang <jinpu.wang@ionos.com>

This is a mistake during backport.
VERW_CLEAR is on bit 5, not bit 10.

Fixes: d12145e8454f ("x86/bugs: Add a Transient Scheduler Attacks mitigation")

Cc: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -429,8 +429,8 @@
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
+#define X86_FEATURE_VERW_CLEAR		(20*32+ 5) /* "" The memory form of VERW mitigates TSA */
 #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* "" Automatic IBRS */
-#define X86_FEATURE_VERW_CLEAR		(20*32+ 10) /* "" The memory form of VERW mitigates TSA */
 #define X86_FEATURE_SBPB		(20*32+27) /* "" Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* "" MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* "" CPU is not affected by SRSO */


