Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D13B2571CE;
	Mon, 24 Feb 2025 14:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408772; cv=none; b=uHA655mhYB+gvCNK/nB84mmtmEOwrHfKiL6tE6rNJISC5s3iIlyfiQjC0vgJzSvwS+FbYBOU3t2446ps/hkMZrfpcLgt2n8pTXCXiAhvup9Inbby0Py0PS5nWUDgYjxx7WjB3J8cx3lm/NSYrbiOUECa5R2WKZukbgjKwZ/O/wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408772; c=relaxed/simple;
	bh=unFYozWLdHewEgyxeg0f5CpDgyJLidw275xsS8mlwyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aT7BkeCxH5mslPuiTA+0z/ypI1wr1XTznLvWsZcAZB2bYLazBSEdSvNN7qJE69h1aArCF1rcvbpnywLDPtKIYHfoSWEMMv9pviDANRX3nX+eIOSab1FKth/6G36KKyDhzvUrgy0FZCbv23SpOs3czHJfu1X8f4Yc3Iw89e19kKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvkqC+Nj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvkqC+Nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AA6C4CED6;
	Mon, 24 Feb 2025 14:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408772;
	bh=unFYozWLdHewEgyxeg0f5CpDgyJLidw275xsS8mlwyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvkqC+Nj1YWW/4CuVeWEGo6NkzC5TLtP8UhtU2Jtckwnuh8SYEFuqMjkTdHNnkJsG
	 6FSBAx+vO0yR33mdj9f4C3+oFSesGW5TfeFrIDVAhCLsWtuZUKxEpeVNoqVo2UuyBF
	 awUQ4iMWWTRJL8mnxBolZux2Hujh3YzKW1vvpYKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 154/154] drm/amdgpu: bump version for RV/PCO compute fix
Date: Mon, 24 Feb 2025 15:35:53 +0100
Message-ID: <20250224142613.076246393@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 55ed2b1b50d029dd7e49a35f6628ca64db6d75d8 upstream.

Bump the driver version for RV/PCO compute stability fix
so mesa can use this check to enable compute queues on
RV/PCO.

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -119,9 +119,10 @@
  * - 3.58.0 - Add GFX12 DCC support
  * - 3.59.0 - Cleared VRAM
  * - 3.60.0 - Add AMDGPU_TILING_GFX12_DCC_WRITE_COMPRESS_DISABLE (Vulkan requirement)
+ * - 3.61.0 - Contains fix for RV/PCO compute queues
  */
 #define KMS_DRIVER_MAJOR	3
-#define KMS_DRIVER_MINOR	60
+#define KMS_DRIVER_MINOR	61
 #define KMS_DRIVER_PATCHLEVEL	0
 
 /*


