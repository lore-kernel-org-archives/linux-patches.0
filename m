Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0BD157A4F;
	Tue, 23 Jul 2024 18:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759246; cv=none; b=uGZ0OWhgLJKRbjeZnkKWlLls0OsWNSyJZ6o/EyH2ajDPWvrJvMernc2pzDLl2S6/FJSDOWlvqd6llxP7m9IU+z/K2Duk6VIiTBjPDllD56EIf26lp+F0/CQ+sgMySg7T/XpR8w/LA+6rzj3WmcnfY899wEamrGS+OhZ8w0bMo8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759246; c=relaxed/simple;
	bh=VQSB0icKnjqhPGt1TI/Dv9WgKvwymvl9z3OjhsT5WbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewBNQ2RcLt9zAGpDzADCu0miieeTZabHsPYJvyDej/HDoOVE6EcSQRKxaXstxzuwQtpgBQQdMhp5ka1hc4peRiNxDYp3WT8JM25ItnS7Abffu9Jiv8Ii96a6HeLbYthPsNO9DshkvEmo+6tQl7Hs7dCpJ2+opKCtLDvzL0bPIQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Ek1vnic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Ek1vnic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507DDC4AF0A;
	Tue, 23 Jul 2024 18:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759246;
	bh=VQSB0icKnjqhPGt1TI/Dv9WgKvwymvl9z3OjhsT5WbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Ek1vnicHZNqd4NzSLqKniAxNyQAG+dF0L4Pa13Wf9PnXsZNMBfcMqg9wIhw+siOC
	 H85Ln7MfY9z1ASpY/B5eA9BFZTnBg3OHgNfdXvQ9QGdo1G2kMsHC6u4zXGA+TrbcJI
	 g0KkHeXVBvHOq45zWwoZb3rT6wbOn0prO8id2C/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/105] drm/vmwgfx: Fix missing HYPERVISOR_GUEST dependency
Date: Tue, 23 Jul 2024 20:23:28 +0200
Message-ID: <20240723180405.218022159@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexey Makhalov <alexey.makhalov@broadcom.com>

[ Upstream commit 8c4d6945fe5bd04ff847c3c788abd34ca354ecee ]

VMWARE_HYPERCALL alternative will not work as intended without VMware guest code
initialization.

  [ bp: note that this doesn't reproduce with newer gccs so it must be
    something gcc-9-specific. ]

Closes: https://lore.kernel.org/oe-kbuild-all/202406152104.FxakP1MB-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alexey Makhalov <alexey.makhalov@broadcom.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240616012511.198243-1-alexey.makhalov@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/Kconfig b/drivers/gpu/drm/vmwgfx/Kconfig
index faddae3d6ac2e..6f1ac940cbae7 100644
--- a/drivers/gpu/drm/vmwgfx/Kconfig
+++ b/drivers/gpu/drm/vmwgfx/Kconfig
@@ -2,7 +2,7 @@
 config DRM_VMWGFX
 	tristate "DRM driver for VMware Virtual GPU"
 	depends on DRM && PCI && MMU
-	depends on X86 || ARM64
+	depends on (X86 && HYPERVISOR_GUEST) || ARM64
 	select DRM_TTM
 	select DRM_TTM_HELPER
 	select MAPPING_DIRTY_HELPERS
-- 
2.43.0



