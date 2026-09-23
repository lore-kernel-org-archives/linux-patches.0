Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA175372DB;
	Wed, 23 Sep 2026 14:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174143; cv=none; b=ZxTWGyJsucrp/I8GNsIIEoQ5rIFdVHts2Hn/Ni7RJWSzIKDla/7skop0DJsaE8FbGlUDLkch+a0W3iaJi1CndTMmOgmlEdMUhxT5UoIgf+0bt047IKE8ExnDQVvPDDyJc4eWHE2g1p+VKNeaSGx2EupoyqT62uyZTObl15usqR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174143; c=relaxed/simple;
	bh=GopikfCVhAXdfGv0Ail+ph/jXcmBaDCFVqxz6C7X33c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q17atSoVjWG40iZn64wkIhwnj36nTAto9BKw66xQmiE+LlqpX6SAQdFA7FD0ZSwoO0K6EbJTcL7B2IYNTtktM638PuehKHBZ+Fv281K0ANpy6qcznDLJKmV3QjF/hDC1SgyvjDm1ivv21nZCKZuSsBWODPXAT9ADhzoX31Gn13c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcwbYgd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcwbYgd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860D61F000FF;
	Wed, 23 Sep 2026 14:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174142;
	bh=ezNXcE1W8JJu3ZWitxZhAde60+4XWc2Re/GnzzAx1j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcwbYgd4ADRL8agLNMhiZDr7a6/mRFx2RM2qTmes7conLZSOTI7gJ3DZZeB4BtOCv
	 9gLai3CGzna4SPOr8xs/+Z4ndAB4L4tWUSBdnHxYZvQQ4+nz7yZcCfU4NZoIZ5ZKsc
	 tXrQRSKKtKqEYTDIcoQa7HugcfYhqFp37JEwOJbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 023/398] ARM: socfpga: select the PL310 erratum 753970 workaround
Date: Wed, 23 Sep 2026 16:01:37 +0200
Message-ID: <20260923140644.034560604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit cfc1e9a543e3589ba200795b6e7fd8ef4314efdf ]

ARCH_INTEL_SOCFPGA selects CACHE_L2X0 and several PL310 erratum
workarounds. The 753970 workaround is still conditioned on PL310, but that
Kconfig symbol no longer exists, so this one selection is always disabled.

Select PL310_ERRATA_753970 directly, consistently with the other PL310
workarounds required by the platform.

Fixes: fbc125afdc50 ("ARM: socfpga: Turn on ARM errata for L2 cache")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-socfpga/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-socfpga/Kconfig b/arch/arm/mach-socfpga/Kconfig
index eb72c240c2486..528c5c1368c37 100644
--- a/arch/arm/mach-socfpga/Kconfig
+++ b/arch/arm/mach-socfpga/Kconfig
@@ -16,7 +16,7 @@ menuconfig ARCH_INTEL_SOCFPGA
 	select ARM_ERRATA_775420
 	select PL310_ERRATA_588369
 	select PL310_ERRATA_727915
-	select PL310_ERRATA_753970 if PL310
+	select PL310_ERRATA_753970
 	select PL310_ERRATA_769419
 	select RESET_CONTROLLER
 
-- 
2.53.0



