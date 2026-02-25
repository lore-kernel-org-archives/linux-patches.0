Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAFE248881;
	Wed, 25 Feb 2026 01:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983615; cv=none; b=B5o/WlXuaVyu2vquBVbem7R6/WYo8aqSHl2BcmrZKxZljK0M80ctGf6dWDJMLj4jCNzLqZ8oCL/dEezI6H8k7gDFyqTyfpPkGFGSvCDGbwtCTwqKvTebENlZVVtF2z82Ht40GQKTiAxQVnVix0ILbpTww8v21E/eil5NQuWJG6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983615; c=relaxed/simple;
	bh=LwDa6oK5stJkRqj0LqFLPCXMMh5q3jBSA0P+hm7gMEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7wjPTodZg5FQuDogbP1v8AloSSiEll+R0RZ2nLYppnxpiNvb9pD3FQXssWZqyEQ+tk41F/tCbyFBcRA/1jRu3v8O3xFf8TaapYN/pZOkmG9ywk6cOiZ9kKzyjcrvn1WupmcRyv3M8aQfRynCLDGO7F2cpTAwaTURsTLtGevM6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anKWkLv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anKWkLv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D9CC116D0;
	Wed, 25 Feb 2026 01:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983615;
	bh=LwDa6oK5stJkRqj0LqFLPCXMMh5q3jBSA0P+hm7gMEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=anKWkLv22a63HhGucyGEX9vZqgHfkSUon4FqgBzVnodigV0Zcy6yIFkA0e1QoGdjg
	 VtrfFOydd9RBjcIJ90WLvEQhdKS2vr7w5IsBWN2sznd/4+VJTZ65dpTH1Vqpm8LbSN
	 KBwh3rKNB044cWYTetVWRCBu+HjNTLoIJN0L5cAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	"Jesse.Zhang" <Jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 709/781] drm/amdgpu/sdma5: enable queue resets unconditionally
Date: Tue, 24 Feb 2026 17:23:38 -0800
Message-ID: <20260225012417.139633530@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 46a2cb7d24f21132e970cab52359210c3f5ea3c6 ]

There is no firmware version dependency.

Fixes: 59fd50b8663b ("drm/amdgpu: Add sysfs interface for sdma reset mask")
Cc: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Jesse.Zhang <Jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
index 8ddc4df06a1fd..45e2933214a80 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -1424,18 +1424,9 @@ static int sdma_v5_0_sw_init(struct amdgpu_ip_block *ip_block)
 
 	adev->sdma.supported_reset =
 		amdgpu_get_soft_full_reset_mask(&adev->sdma.instance[0].ring);
-	switch (amdgpu_ip_version(adev, SDMA0_HWIP, 0)) {
-	case IP_VERSION(5, 0, 0):
-	case IP_VERSION(5, 0, 2):
-	case IP_VERSION(5, 0, 5):
-		if ((adev->sdma.instance[0].fw_version >= 35) &&
-		    !amdgpu_sriov_vf(adev) &&
-		    !adev->debug_disable_gpu_ring_reset)
-			adev->sdma.supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
-		break;
-	default:
-		break;
-	}
+	if (!amdgpu_sriov_vf(adev) &&
+	    !adev->debug_disable_gpu_ring_reset)
+		adev->sdma.supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 
 	/* Allocate memory for SDMA IP Dump buffer */
 	ptr = kcalloc(adev->sdma.num_instances * reg_count, sizeof(uint32_t), GFP_KERNEL);
-- 
2.51.0



