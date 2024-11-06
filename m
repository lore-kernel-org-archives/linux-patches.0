Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE331DFE3A;
	Wed,  6 Nov 2024 12:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896580; cv=none; b=jcWJhXwKNI66/BaDKyklk8umPlzMtbHt1j1vCZto1lKfZ8FDXXHjLsPzWeiHyESvlDDNUQ+7Zp0p7XGOSCDY/JGOaRAGdIUURu/wNxxY5grY8bJ5d1B50a2c8lNNTQKxNSlM8XWEzt+c3BvHsW3FV1JkVC9cpiC32rOxgEYR8KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896580; c=relaxed/simple;
	bh=tK71Lua8EwJZ/SSvHR3BmLOP99HLLKm3lLOv1mrx5E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/R+QvKEYO3gST8ayuaJWVQGrW5swkmotI6kN08xzRT2CfZXY6D67rz30VsicYGtv1oTNvMhAdkcWGCu004thsvrSEmoxAqfX3qgq0TKKTmFolUG09TBCtyvoh3Q3mgxp4W+ZgEbpRozVeubso7geSZHxbxTz24oO0khPU+WLoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayzDY8ZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayzDY8ZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9118C4CECD;
	Wed,  6 Nov 2024 12:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896580;
	bh=tK71Lua8EwJZ/SSvHR3BmLOP99HLLKm3lLOv1mrx5E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayzDY8ZA2PhSSZ0gDv3VLdvPqef0IVFdsNG+DMr/A3pmbTiA6XBfgoqBn3JSMxM5r
	 pNhSDm5OaIvP52S/Xw+DlGq9RWen6obNHDNzWyUBgpuvS+lD8UdmwV+q31YDVYI+ZR
	 sLmfVr9/DT+C5ublcGdOnf9duZqQjCepejzei2OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Shekhar Chauhan <shekhar.chauhan@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 240/245] drm/xe: Define STATELESS_COMPRESSION_CTRL as mcr register
Date: Wed,  6 Nov 2024 13:04:53 +0100
Message-ID: <20241106120325.177239949@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

commit 4551d60299b5ddc2655b6b365a4b92634e14e04f upstream.

Register STATELESS_COMPRESSION_CTRL should be considered
mcr register which should write to all slices as per
documentation.

Bspec: 71185
Fixes: ecabb5e6ce54 ("drm/xe/xe2: Add performance turning changes")
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Reviewed-by: Shekhar Chauhan <shekhar.chauhan@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240814095614.909774-4-tejas.upadhyay@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -80,7 +80,7 @@
 #define   LE_CACHEABILITY_MASK			REG_GENMASK(1, 0)
 #define   LE_CACHEABILITY(value)		REG_FIELD_PREP(LE_CACHEABILITY_MASK, value)
 
-#define STATELESS_COMPRESSION_CTRL		XE_REG(0x4148)
+#define STATELESS_COMPRESSION_CTRL		XE_REG_MCR(0x4148)
 #define   UNIFIED_COMPRESSION_FORMAT		REG_GENMASK(3, 0)
 
 #define XE2_GAMREQSTRM_CTRL			XE_REG(0x4194)


