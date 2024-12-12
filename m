Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3949621504F;
	Thu, 12 Dec 2024 15:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016327; cv=none; b=HmbUBG8yYmeJcKMEvg/0xKCzBUDLIpuqfTrNVx5QjviOFDT/LlcFd38joaaJp/3HeuHvzS4AE3GeLKIgFQl+j52SXidsRCVMbpGyZcrrgWX7pkri6OoInJHa1hXoDn4SE16flMvRWz8m4SA+L5KIeRTX13gCqXR+wBF8qka7jDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016327; c=relaxed/simple;
	bh=zMpPo/iL6JlyrrObBH7DXCkTX9upy+wGhrlj9g80tlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixl1djvwegabi0HyLg6exAGGsYbkPvym7qpZvbMg/sRvu0CBIDUs1q4EWQH/ZfiTD8SMkHyxT0FNZf7VKtuDbA619yfKRfRNCPrGcxPjZbhpkUxkAZzgAIbQW1fD/gEAEWTY1ccPPvoAIQvCrFQaWFjx9vUVnVpMl0CGMIdi/Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJyB4Je3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJyB4Je3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBC4C4CECE;
	Thu, 12 Dec 2024 15:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016327;
	bh=zMpPo/iL6JlyrrObBH7DXCkTX9upy+wGhrlj9g80tlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJyB4Je3gdzo+Id9mqQSDb1GqhY+8YXb67umf/eCKh8+s1qK6azcdTkCtmyTvzGdo
	 SQUZhmvOhL8HnxGNK9MyDL1QyDPANnnh8RD/WTxUSU9s3p2kUY7JVbbGw/gQ4jK/cN
	 Ir3g5Yv0iiTOdczAUMCTFaB1kjtxG1zhAnUqLrx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yat Sin <David.YatSin@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 168/466] drm/amdkfd: hard-code cacheline for gc943,gc944
Date: Thu, 12 Dec 2024 15:55:37 +0100
Message-ID: <20241212144313.441280651@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yat Sin <David.YatSin@amd.com>

commit 55ed120dcfdde2478c3ebfa1c0ac4ed1e430053b upstream.

Cacheline size is not available in IP discovery for gc943,gc944.

Signed-off-by: David Yat Sin <David.YatSin@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1509,6 +1509,8 @@ static int kfd_fill_gpu_cache_info_from_
 	if (adev->gfx.config.gc_tcp_size_per_cu) {
 		pcache_info[i].cache_size = adev->gfx.config.gc_tcp_size_per_cu;
 		pcache_info[i].cache_level = 1;
+		/* Cacheline size not available in IP discovery for gc943,gc944 */
+		pcache_info[i].cache_line_size = 128;
 		pcache_info[i].flags = (CRAT_CACHE_FLAGS_ENABLED |
 					CRAT_CACHE_FLAGS_DATA_CACHE |
 					CRAT_CACHE_FLAGS_SIMD_CACHE);
@@ -1520,6 +1522,7 @@ static int kfd_fill_gpu_cache_info_from_
 		pcache_info[i].cache_size =
 			adev->gfx.config.gc_l1_instruction_cache_size_per_sqc;
 		pcache_info[i].cache_level = 1;
+		pcache_info[i].cache_line_size = 64;
 		pcache_info[i].flags = (CRAT_CACHE_FLAGS_ENABLED |
 					CRAT_CACHE_FLAGS_INST_CACHE |
 					CRAT_CACHE_FLAGS_SIMD_CACHE);
@@ -1530,6 +1533,7 @@ static int kfd_fill_gpu_cache_info_from_
 	if (adev->gfx.config.gc_l1_data_cache_size_per_sqc) {
 		pcache_info[i].cache_size = adev->gfx.config.gc_l1_data_cache_size_per_sqc;
 		pcache_info[i].cache_level = 1;
+		pcache_info[i].cache_line_size = 64;
 		pcache_info[i].flags = (CRAT_CACHE_FLAGS_ENABLED |
 					CRAT_CACHE_FLAGS_DATA_CACHE |
 					CRAT_CACHE_FLAGS_SIMD_CACHE);
@@ -1540,6 +1544,7 @@ static int kfd_fill_gpu_cache_info_from_
 	if (adev->gfx.config.gc_tcc_size) {
 		pcache_info[i].cache_size = adev->gfx.config.gc_tcc_size;
 		pcache_info[i].cache_level = 2;
+		pcache_info[i].cache_line_size = 128;
 		pcache_info[i].flags = (CRAT_CACHE_FLAGS_ENABLED |
 					CRAT_CACHE_FLAGS_DATA_CACHE |
 					CRAT_CACHE_FLAGS_SIMD_CACHE);
@@ -1550,6 +1555,7 @@ static int kfd_fill_gpu_cache_info_from_
 	if (adev->gmc.mall_size) {
 		pcache_info[i].cache_size = adev->gmc.mall_size / 1024;
 		pcache_info[i].cache_level = 3;
+		pcache_info[i].cache_line_size = 64;
 		pcache_info[i].flags = (CRAT_CACHE_FLAGS_ENABLED |
 					CRAT_CACHE_FLAGS_DATA_CACHE |
 					CRAT_CACHE_FLAGS_SIMD_CACHE);


