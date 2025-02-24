Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422F81624D9;
	Mon, 24 Feb 2025 15:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409239; cv=none; b=kbJwXHUcbGsC4wR5eFy7acsHyZPNLmjDG5ekaYXUtO77YpK3Cq5jh88hGp8pUV9mJXzvc02biQFnSPfBkMkfpxoKxWJUSlCjnHub/95iQb3Uo9aRYDGGpnd7cZVXRtORy67ruOu0ND9eVZjRIVMs/oaQOe4+82pavlK22ZnfcBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409239; c=relaxed/simple;
	bh=5jy59Cf0Cjr+gONY3u1wA7BBQ9KjJ/h5bqS32UGh7js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAG2khOsqMTfjA9BUZhWUskXrjBTjEZM5rZ3A9hdvFFebYh/bYa0uKo9e1q5qktBmhw1bNdrE8G+SShXbNQV+X3itnbAEhPFog7XlJoOBZM53aHQxkWbmmejERh75ccjyMMinH4TKOtdEMkAWvQedkfYcjsoKA5uFf5DgBSHG0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2b/hsUKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2b/hsUKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12C0C4CED6;
	Mon, 24 Feb 2025 15:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409239;
	bh=5jy59Cf0Cjr+gONY3u1wA7BBQ9KjJ/h5bqS32UGh7js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2b/hsUKDpveoHs3nB0hX4YY8Yx9XJCebOT4j7rIP81PWHcBZaGw7M92zE0NIfyUXi
	 TI/kCz49F3hSx07e8VtEWGodbrqu2mZfL2gx/I/O/9DsoeRhh9MtLV173AiHo2D49A
	 2u8m7MWSMJ74VDoGjdr2pH/xJ6LD6noSIDz4tNEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 138/138] drm/amdgpu: bump version for RV/PCO compute fix
Date: Mon, 24 Feb 2025 15:36:08 +0100
Message-ID: <20250224142609.894225288@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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


