Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8CA21579F;
	Fri, 10 Oct 2025 13:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102456; cv=none; b=i+fmqG3vtNzaKjsZRivXJUtuy1/cOl3hqa5nl2V+9syBmJo/xDBq+yw6NwNOlag7JDF71padOk4N/8m+Cy30tqg9ldO8EqPKojoK4Y02PAz0VQI2TGfJPHeVL+uB/TFUk2079tE22njasyi7gnjKcGmI4klexa1zEpPfnOXbMAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102456; c=relaxed/simple;
	bh=4l3Dp2VtrxhH3eBDx+N5eLj3TUtg18Q+4sPJYzShE44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LClVKiCuDI40YjKo5DXEmNM1nIXkT4zBYlRoILOttOc+3ebKLqMWz2AR/LYHMoTQTQScIK9QBdfiPQ5G0BCq2+mfx/F6j6zVh1YNz4Ykz0+lfEBqDQJnUbTPztm8d5HkF1uj2QqFME9Us2/SMP/w3hMdiSrqg0pTh2wzZGyZvtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5RX5Py4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5RX5Py4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C20C4CEF1;
	Fri, 10 Oct 2025 13:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102456;
	bh=4l3Dp2VtrxhH3eBDx+N5eLj3TUtg18Q+4sPJYzShE44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5RX5Py4ZU64Cc5SZRzrwnHf75rPotLVcq4098lhRD3Uawon1T40/xNcx3nD3Z/jP
	 X7ZQUI/YV4zlN7A8ZqvdIHnTitDomeP+l90Gnt0cNyi2rUKXVCSIbn6WL7Q2CYqgu9
	 WQDyv+ktvG6KTAMwYs+4GfsnPHlplEldBdB/L3CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shaoyun Liu <shaoyun.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Subject: [PATCH 6.12 20/35] drm/amd/include : MES v11 and v12 API header update
Date: Fri, 10 Oct 2025 15:16:22 +0200
Message-ID: <20251010131332.523723965@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Shaoyun Liu <shaoyun.liu@amd.com>

commit 1c687c0da9efb7c627793483a8927554764e7a55 upstream.

MES requires driver set cleaner_shader_fence_mc_addr
for cleaner shader support.

Signed-off-by: Shaoyun Liu <shaoyun.liu@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/include/mes_v11_api_def.h |    3 ++-
 drivers/gpu/drm/amd/include/mes_v12_api_def.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/include/mes_v11_api_def.h
+++ b/drivers/gpu/drm/amd/include/mes_v11_api_def.h
@@ -266,7 +266,8 @@ union MESAPI_SET_HW_RESOURCES_1 {
 		};
 		uint64_t							mes_info_ctx_mc_addr;
 		uint32_t							mes_info_ctx_size;
-		uint32_t							mes_kiq_unmap_timeout; // unit is 100ms
+		uint64_t							reserved1;
+		uint64_t							cleaner_shader_fence_mc_addr;
 	};
 
 	uint32_t max_dwords_in_api[API_FRAME_SIZE_IN_DWORDS];
--- a/drivers/gpu/drm/amd/include/mes_v12_api_def.h
+++ b/drivers/gpu/drm/amd/include/mes_v12_api_def.h
@@ -278,6 +278,8 @@ union MESAPI_SET_HW_RESOURCES_1 {
 		uint32_t                            mes_debug_ctx_size;
 		/* unit is 100ms */
 		uint32_t                            mes_kiq_unmap_timeout;
+		uint64_t                            reserved1;
+		uint64_t                            cleaner_shader_fence_mc_addr;
 	};
 
 	uint32_t max_dwords_in_api[API_FRAME_SIZE_IN_DWORDS];


