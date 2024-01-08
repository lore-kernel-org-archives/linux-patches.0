Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B27524C3;
	Mon,  8 Jan 2024 15:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0f5ht0GR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCC3C43395;
	Mon,  8 Jan 2024 15:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728622;
	bh=5WSE7ARb6WdLcpOIa/5wbBbjt6ilnS3JucKxYR6ogLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0f5ht0GRGisr9tKJP20jRaU0N0CL3kfhsAjkouRoz9Fvk+tuDIZ906tWGmaU1fXZ/
	 TUDy9e8IikAph0E/vg5hf/7jYGoFABV2YuFn88OO3zoLQJj6+BHR1wDG9iwvn+B6tL
	 sPrLLv4mWz7pLzzH+yDhzBiE7fwahUA1syfIp8LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 136/150] drm/amdgpu: skip gpu_info fw loading on navi12
Date: Mon,  8 Jan 2024 16:36:27 +0100
Message-ID: <20240108153517.459565553@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 21f6137c64c65d6808c4a81006956197ca203383 upstream.

It's no longer required.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2318
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1976,15 +1976,8 @@ static int amdgpu_device_parse_gpu_info_
 
 	adev->firmware.gpu_info_fw = NULL;
 
-	if (adev->mman.discovery_bin) {
-		/*
-		 * FIXME: The bounding box is still needed by Navi12, so
-		 * temporarily read it from gpu_info firmware. Should be dropped
-		 * when DAL no longer needs it.
-		 */
-		if (adev->asic_type != CHIP_NAVI12)
-			return 0;
-	}
+	if (adev->mman.discovery_bin)
+		return 0;
 
 	switch (adev->asic_type) {
 	default:


