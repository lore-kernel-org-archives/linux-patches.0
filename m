Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B5C340DB7;
	Tue, 16 Dec 2025 11:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884763; cv=none; b=ogcZUguEG86lw5jeUdkPZzrMKpOmrBAGQykFl02U8wqUskSeNWIJXV4B8DwsbMpUNPsUIvZ11+7dy4M67ErdHwIrL4cXFMswkhfEO7m0LtPsoKuUJPWzIY0tilQaXnWp/BLz9GflqkoSV9kJ8EUsYEoCuEcRF59mrG73VaHXUQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884763; c=relaxed/simple;
	bh=O3R3/0wjEwqQ2PBqcl7Nxlo2VamNyXSV6+hsWuYj7h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qWzjbmCb76WBFiuqtp1FStECgqfwtaS2hOF8j1g3v9mFopXEEXJnxGIf7dlfc8VC1XMzpeYsgbHYHsrBrspYy0fS9kPLGQQT8ylDi9EBG4/oAyawD1CyCO+fCLc2rrZkEkSgCulBbvTH+Ex9vk+TRooRLGfmLSmICG6WtVv2CZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mL56lVV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mL56lVV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002CDC4CEF1;
	Tue, 16 Dec 2025 11:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884763;
	bh=O3R3/0wjEwqQ2PBqcl7Nxlo2VamNyXSV6+hsWuYj7h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mL56lVV6N//P5O2gA2GmAekX6xS8CthmrXPjWlj55zx7Vcs75ksr4yk/uUPf7kqII
	 8YAiBdWjkA7j5Cgqq7+Vv+y2t2KZjaau3ZTEwgr6GoIfPY5Yx+qXq6jPGFuimC4N2R
	 froQiydZ1zicuQ8o/7sSahiLaznaCQTgdoeh8d1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Xi Pardee <xi.pardee@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 292/354] platform/x86:intel/pmc: Update Arrow Lake telemetry GUID
Date: Tue, 16 Dec 2025 12:14:19 +0100
Message-ID: <20251216111331.490813612@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Pardee <xi.pardee@linux.intel.com>

[ Upstream commit 644ab3bc98ee386f178d5209ae8170b3fac591aa ]

Update ARL_PMT_DMU_GUID value. Arrow Lake PMT DMU GUID has been updated
after it was add to the driver. This updates ensures that the die C6
value is available in the debug filesystem.

Bugzilla Link: https://bugzilla.kernel.org/show_bug.cgi?id=220421
Fixes: 83f168a1a437 ("platform/x86/intel/pmc: Add Arrow Lake S support to intel_pmc_core driver")
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Signed-off-by: Xi Pardee <xi.pardee@linux.intel.com>
Link: https://patch.msgid.link/20251014214548.629023-2-xi.pardee@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmc/core.h b/drivers/platform/x86/intel/pmc/core.h
index b9d3291d0bf2c..afc07427e39ef 100644
--- a/drivers/platform/x86/intel/pmc/core.h
+++ b/drivers/platform/x86/intel/pmc/core.h
@@ -277,7 +277,7 @@ enum ppfear_regs {
 /* Die C6 from PUNIT telemetry */
 #define MTL_PMT_DMU_DIE_C6_OFFSET		15
 #define MTL_PMT_DMU_GUID			0x1A067102
-#define ARL_PMT_DMU_GUID			0x1A06A000
+#define ARL_PMT_DMU_GUID			0x1A06A102
 
 #define LNL_PMC_MMIO_REG_LEN			0x2708
 #define LNL_PMC_LTR_OSSE			0x1B88
-- 
2.51.0



