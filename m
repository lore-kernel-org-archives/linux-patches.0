Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65720168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD79BC433D2;
	Mon,  8 May 2023 10:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541552;
	bh=AjM985CdZ3WwBdPlkCZ2b4v7aJ2q6YqB8ie2S8+h5rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1l8h86QMC9Rw6eefBpwuww0BhH9BfE8D9/L6rSmhTnpM4vfxRF6zwsvUf8vn9qpfs
	 lLIZHZ0y0ycHSq5x8MJmBhRu88E9dtsGCzP/5t4wOTxDV2EqeYty6a0ZJBUSwTzN80
	 2uHSwx1GHNUkvwZKNMBPNBV9svdKbCZRM0Dmcakg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 134/663] drm/i915/dg2: Drop one PCI ID
Date: Mon,  8 May 2023 11:39:20 +0200
Message-Id: <20230508094432.880139818@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 3a38be31ec82920a871963c086393bc0ba26a655 ]

The bspec was recently updated to remove PCI ID 0x5698; this ID is
actually reserved for future use and should not be treated as DG2-G11.

Bspec: 44477
Fixes: 8618b8489ba6 ("drm/i915: DG2 and ATS-M device ID updates")
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230208200905.680865-1-matthew.d.roper@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/i915_pciids.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/drm/i915_pciids.h b/include/drm/i915_pciids.h
index 4a4c190f76984..8f648c32a9657 100644
--- a/include/drm/i915_pciids.h
+++ b/include/drm/i915_pciids.h
@@ -706,7 +706,6 @@
 	INTEL_VGA_DEVICE(0x5693, info), \
 	INTEL_VGA_DEVICE(0x5694, info), \
 	INTEL_VGA_DEVICE(0x5695, info), \
-	INTEL_VGA_DEVICE(0x5698, info), \
 	INTEL_VGA_DEVICE(0x56A5, info), \
 	INTEL_VGA_DEVICE(0x56A6, info), \
 	INTEL_VGA_DEVICE(0x56B0, info), \
-- 
2.39.2



