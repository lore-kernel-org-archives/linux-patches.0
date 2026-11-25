Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618810;
	b=RzM+WzAEPhQ7eQieTU0/UlvBJZcJHAb4lM5493TeInKWA+7SfyPJ0DC0o3l/yud22mm0
	 so0w2s0K0TSmjeDis/kzLJXWwqG6x/2Jq3Z5DRrZqcw5okUx3OD8cC+nj9MsTLOIvhNuL
	 rxDhZKRbWnvYZHvVD48f6edtTrgGu5v+yfI6SJkPIOyMD356apDrRInhQj+4ZfF/SRwHI
	 /hB1QIlZYF4jn8XZ2FCutcyZyw1JNAu4QniSkfiJly4nC3slR/ToH7rTGPCnXp1kWgTEl
	 RwMKpa0u4dsPNKyOQEyVGaK8NoBoRCfYnIvbvUzMKfdDe2kEgyAuHuEFFrQLu2c7onA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h03Fp9/9ltkLHzlDfGT5W12L3/gOmZ9Nl9RZsMpPxzE=;
	b=p2eCOjtmqWuOIYwi+uRvlQDtcrZxfkXvotpGVi1diOFUyBWdsIiURu5JQtTIkeESuC3l
	 uHCW8DW7QJaeun/82vRhcUk/PtCb0sRDsukNODD73u33gLkbrrpp9TjfCi/PWc6X1O77X
	 gp9JcBRYrRcyCXgjB5SkRPiowWM5Sfcinim1f9zapxgjslHAmfy73rVkk81fWlvWsbXU3
	 QgGw18ExjP+Jc9JdabXYnSObdwNLCwaFehlIg4bVsJzjHlmmV8i2RYbfUSTphhl5Ehu/L
	 rTE88hC2c8Z0p+/3YAbYqpKCye5XKuQSwjY9gXRZ/LlIKvR2sdd3F+BidF6C5qCD8+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sN/0suus";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825B6606A323;
	Wed, 25 Nov 2026 15:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sN/0suus
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E171F000C6;
	Wed, 25 Nov 2026 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618810;
	bh=h03Fp9/9ltkLHzlDfGT5W12L3/gOmZ9Nl9RZsMpPxzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sN/0suuswlbH8JrZgzZzw/yRvXybaRDF07qgJl8g8OM0EThu5arqypQigKKe3XiCZ
	 HSEhbCOVK5+3appfNqQQ1iU1IRDvNzGZfEZAbfszHJ5tj5NYn7azd1CSiUJEK+k14y
	 ayJ9K7BhINHrX9tFMcKGFhzYGwY8XTNVZ2dHqc5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0395/1005] drm/xe: Fix build with DRM_XE=y and CONFIGFS_FS=m
Date: Wed, 25 Nov 2026 15:28:53 +0100
Message-ID: <20261125143830.996724307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

[ Upstream commit da475c094342b6d5c8bc020b19d6900130bed047 ]

When xe is built-in but configfs is a module, xe_configfs.o is not
linked into xe, while IS_ENABLED(CONFIG_CONFIGFS_FS) in xe_configfs.h
still exposes the real declarations, leading to undefined references.

Use IS_REACHABLE() so this case falls back to the stubs, the same as
CONFIGFS_FS=n.

Fixes: 16280ded45fb ("drm/xe: Add configfs to enable survivability mode")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610160935.Qk4ZxBxY-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202610162335.FEwMdGY9-lkp@intel.com/
Suggested-by: Matt Roper <matthew.d.roper@intel.com>
Assisted-by: LLM
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20261021194555.2171344-2-rodrigo.vivi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 30499cbd796117b63be3b59a1781c25ea3f4b27f)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_configfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_configfs.h b/drivers/gpu/drm/xe/xe_configfs.h
index 4fbbeafba4734..65b15b7483e1b 100644
--- a/drivers/gpu/drm/xe/xe_configfs.h
+++ b/drivers/gpu/drm/xe/xe_configfs.h
@@ -14,7 +14,7 @@
 
 struct pci_dev;
 
-#if IS_ENABLED(CONFIG_CONFIGFS_FS)
+#if IS_REACHABLE(CONFIG_CONFIGFS_FS)
 int xe_configfs_init(void);
 void xe_configfs_exit(void);
 void xe_configfs_check_device(struct pci_dev *pdev);
-- 
2.53.0



