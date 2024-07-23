Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948A913D600;
	Tue, 23 Jul 2024 18:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760107; cv=none; b=q2PO2CVHo0gQJ/MexCHxAVHn8mPRd8iJd5rIDOHFQ6KvfSv8Uvs57EcLeT7T74I/weC+IgzE0mW5UDgIsnKe8SUGjEdFjw8dpAS2SYTdf4vglkzx5kxum51iND1XJuURfmWB+VHxZ1QOyYAu6lePTJ9TbT2tpxN99F6dFCg1sPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760107; c=relaxed/simple;
	bh=oBZ4aUZXWXOa80R3zclCA2t7Pg23iDplEHeEivaB1Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RF1hJU+ao5FOJXbk7wMVVjWEKzJ5cwLksm34915VOCBF5eyva37caXWDuUGhjAosRnW6vlscLBA8qiY2t1h+IDApd8HH4tSpuUAEJgBPqbtKieLXFZbxkTlyLpQL1B40x/U8qnfgg/EvRxxFWAX9fQGSinwQcuyIjZVt9AZ7yW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKK28Vx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKK28Vx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E86C4AF0A;
	Tue, 23 Jul 2024 18:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760107;
	bh=oBZ4aUZXWXOa80R3zclCA2t7Pg23iDplEHeEivaB1Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKK28Vx9k+AfWJW6dvIBQ60sI1Rd6KHEsbj1ifqN1lClaZZa1dZNU2elJCN6dfJw4
	 4qTwPG/CugzIiQOFGUBhmBhIzRKgQ+XIUqGQcFEWTaG9scFLHSLnPRZOxVE1dM20+y
	 90unmaJ5XZOW9lueCma/Q7mo1On7or9U+bM635c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 074/163] drm/vmwgfx: Fix missing HYPERVISOR_GUEST dependency
Date: Tue, 23 Jul 2024 20:23:23 +0200
Message-ID: <20240723180146.329095098@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



