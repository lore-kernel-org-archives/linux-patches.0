Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416231C4ED4;
	Tue, 27 Aug 2024 15:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771506; cv=none; b=WsaEFRzslnqkv+2eRX7pqx6z/UJ38djqopytFxEKT80OHEp8xIgl/1eMHmSu50CbFj3yRrQmdRs1UOG4r7C8eQ3XBiXHcTpCF2PHN2IYhT9/7eI6zPICsP5Nd45dxzksZ5v2VU8U19gszbj+nnu+mUy2/7JW+JfjSYnu29Qi/7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771506; c=relaxed/simple;
	bh=K8hD9zw1Dwxm5UdsEnOSSluA1CfEMrms6R9KSH7wnfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giTx+89CCWLozpDmt3EXHs5qfsEyQQ6WukkrEaEz8l5QuViwzqUH/sB0cKk0AeKMsgpL5ih/NGPNiXUP5rCJyCZzvWcd8XZJkrd5CUU5yQSBb+fOt7GkE7hLRfIKgv0fIu/tY+EGSc28zKpbphPc0PUOf28PkjMH0s7lCVepcjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9rGMvAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9rGMvAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5498BC4DDF2;
	Tue, 27 Aug 2024 15:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771505;
	bh=K8hD9zw1Dwxm5UdsEnOSSluA1CfEMrms6R9KSH7wnfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9rGMvAAvzSblCfpi1aoKbJdAje4EYZ1k4eo+vR3ZTsmqRFVEocthmt571nJpHsLh
	 l2gGRkzFm/Qde/+GXnAztW1ms+jqloaRfxxen0a3GZ94MqdpB0S5XySpzGflWT31hw
	 LQo8s8VfY7NRfuTLsZAcr9FBSWYF1/0oQ8SYCx5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 209/273] drm/xe: Fix tile fini sequence
Date: Tue, 27 Aug 2024 16:38:53 +0200
Message-ID: <20240827143841.363115521@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 15939ca77d4424f736e1e4953b4da2351cc9689d ]

Only set tile->mmio.regs to NULL if not the root tile in tile_fini. The
root tile mmio regs is setup ealier in MMIO init thus it should be set
to NULL in mmio_fini.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240809232830.3302251-1-matthew.brost@intel.com
(cherry picked from commit 3396900aa273903639a1792afa4d23dc09bec291)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_mmio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_mmio.c b/drivers/gpu/drm/xe/xe_mmio.c
index 9d8fafdf51453..beb4e276ba845 100644
--- a/drivers/gpu/drm/xe/xe_mmio.c
+++ b/drivers/gpu/drm/xe/xe_mmio.c
@@ -355,7 +355,8 @@ static void tiles_fini(void *arg)
 	int id;
 
 	for_each_tile(tile, xe, id)
-		tile->mmio.regs = NULL;
+		if (tile != xe_device_get_root_tile(xe))
+			tile->mmio.regs = NULL;
 }
 
 int xe_mmio_probe_tiles(struct xe_device *xe)
@@ -416,9 +417,11 @@ int xe_mmio_probe_tiles(struct xe_device *xe)
 static void mmio_fini(void *arg)
 {
 	struct xe_device *xe = arg;
+	struct xe_tile *root_tile = xe_device_get_root_tile(xe);
 
 	pci_iounmap(to_pci_dev(xe->drm.dev), xe->mmio.regs);
 	xe->mmio.regs = NULL;
+	root_tile->mmio.regs = NULL;
 }
 
 int xe_mmio_init(struct xe_device *xe)
-- 
2.43.0



