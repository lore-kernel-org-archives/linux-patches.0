Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105B61DFDA2;
	Wed, 19 Feb 2025 08:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954163; cv=none; b=FHpLhSXjFY5QFXiYhjnB7jOxewZlco3Y84IiYBCgICLnEPO0ojL/wW0NE0h/EqZKTsa9y0YpTznmi2H61tGd44X6n++72Z0oVEx2FgzhddNMySFIu9hL7lZmo/gV5OaIL9jPikZStvf++mXTzjqtx9Bz3Z0eYgOW1VQVlzMT7Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954163; c=relaxed/simple;
	bh=5jy59Cf0Cjr+gONY3u1wA7BBQ9KjJ/h5bqS32UGh7js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pw702NemMUOzOt/rggOIAdKnO3ZC4DAd2YIylm5jnRQHTSyjUtlB5hvkb3R/rfL6c9nx5bBSLEw4nK22UUbpOkQ83LtOxss0aLj4NcfqW632pwxs477w7FDHmMZj5rMGAqPZG1E03eeMPN4pC00kGvV6BTPAzzgtr0mi+wKbbGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOKydVuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOKydVuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B209C4CEE7;
	Wed, 19 Feb 2025 08:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954162;
	bh=5jy59Cf0Cjr+gONY3u1wA7BBQ9KjJ/h5bqS32UGh7js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOKydVucZ6+zL5i8HSmpOB5p7nB7l2tj73LUXFgTSuerJjqthMMhQSBGOYTe0kzOU
	 y4gmrnz99d+toCUMI08DsEbgmz72pCOKxlU81lplZwXn+XUy+Fy0TTrgjvhscbhDhj
	 OUm+EW9g6IcQWIQUir3CBxyvL4lDD46b82INtHC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 117/274] drm/amdgpu: bump version for RV/PCO compute fix
Date: Wed, 19 Feb 2025 09:26:11 +0100
Message-ID: <20250219082614.200745355@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -120,9 +120,10 @@
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


