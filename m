Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DF2FC19;
	Thu, 25 Jul 2024 14:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919233; cv=none; b=b9Wu6f5+gxO3Px7C99xmc4KigCTwqH/X567gDOMMbaZs4sxVVx6H+g71YUdVq1Gt9Rb+ZzW/bOcoQ7Tp8UXMktttfIUA/vjeqBcxn+XT11Uf7H8LWTxH288HUW85RM90LxSasXoLYK7sfpFHgvFUpx+d86qKVW6Ovj9OT6grgfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919233; c=relaxed/simple;
	bh=RMo/uWZz0TO4dr1igDrXYcp+V06JvPxdXTlXW1f5VGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WP1pOq8E8iTz5DB1TkU1mrvu8zPSe6ZXHGk91RjM+G/zuSxFWOvdGbd0iXM9oaG9kHjVvhmm8Lk7Rh54ZeBxPcFgV1kTGLDKAJeT9APTp7e1sS90oO5lrBbodHirSOvLrAX+7WvQBa4ar7BdHATSpJAaKLNEiiD9LnsP2tqiQ7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9b278VP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9b278VP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CFCC116B1;
	Thu, 25 Jul 2024 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919233;
	bh=RMo/uWZz0TO4dr1igDrXYcp+V06JvPxdXTlXW1f5VGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9b278VPWinbb8oQ1kODJwqLspC9iBnA1Zia4sk0i0M4KObCbSqX4j8lB1YcaachM
	 W6TfPyzIexqy/faiVRJjhRtX6CgzTl/7Mok82FXg3tvWiUeX/P/rO9k11oE1eQxfSY
	 BFVluT4Nfe9ae8TepHtRxZBUXJ5fc9NisQtFyIRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/87] drm/vmwgfx: Fix missing HYPERVISOR_GUEST dependency
Date: Thu, 25 Jul 2024 16:37:06 +0200
Message-ID: <20240725142739.684918070@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c9ce47c448e03..5b9a9fba85421 100644
--- a/drivers/gpu/drm/vmwgfx/Kconfig
+++ b/drivers/gpu/drm/vmwgfx/Kconfig
@@ -2,7 +2,7 @@
 config DRM_VMWGFX
 	tristate "DRM driver for VMware Virtual GPU"
 	depends on DRM && PCI && MMU
-	depends on X86 || ARM64
+	depends on (X86 && HYPERVISOR_GUEST) || ARM64
 	select DRM_TTM
 	select MAPPING_DIRTY_HELPERS
 	# Only needed for the transitional use of drm_crtc_init - can be removed
-- 
2.43.0



