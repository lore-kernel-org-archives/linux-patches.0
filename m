Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DB03431F8;
	Fri,  9 Oct 2026 14:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556699; cv=none; b=Jkb7zFXKYg38peRCahXNJK2LQAfGyfxk5+7Ax5+21H5TqsfEc45pI0rFS5j8omOVFk295J1EOhcdYo0ATZRdLmLTI8N/aEvCG2JHwl7KLJQR1apO01Uwo3hD4kvj4B+1d0XqMJVyR2PDSdkKEvWwEcm/XaDazmZ0u8Ud419aYYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556699; c=relaxed/simple;
	bh=XUHdsEAL5s+t8GEmIqn75ZXokj7kgYs9but24rLc/1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuYToSWnhj/6ZntJmqH+fFKSKB8jVn+Kpfoc/7JPznLfArrmtsJ4KkrJiUIzNAqy9X1gT9hwGRFqKs0jg0ji7/+eX2Poj0Gy50mbbv4eh24Z2C79fsyxdnLWxCv4c4P3yfv1QC7x1JcKjrNB0YN6fq3Kz8pOqih/B/Ms1bOT6JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2hkJ/P+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2hkJ/P+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4161F000FF;
	Fri,  9 Oct 2026 14:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556698;
	bh=oAb325RQA+zbhDUVcp3iss1GUfcC5TTc4jQQQo/4q1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2hkJ/P+J6P1/Kb18wVfTAI2O7V7LhVL63dI0/O9qzSqZsz+pEuwYZ/vk8kePfESw
	 fZ+B158DGGgErCzm8Pnn3BSA68uMGPJmgh+Q6dkip4DOrE04qR4a8mVX4Xkh0sgJZ3
	 6HVYM5ZKKVVGNpNxMoxbOYvQxGFEmNL+XHJ3l9yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatio Zhang <hongkun.zhang@amd.com>,
	Hawking.Zhang@amd.com,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 187/428] drm/amdgpu: drop userq callback assignment for sdma 7.1
Date: Fri,  9 Oct 2026 16:08:44 +0200
Message-ID: <20261009140950.250829695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 1d1f1acecddf742eb1f305122209bc2034fd90b1 upstream.

Not enabled in 7.1 so drop the assignment.

Cc: Horatio Zhang <hongkun.zhang@amd.com>
Cc: Hawking.Zhang@amd.com
Fixes: 4ed5116aacf6 ("drm/amdgpu: Add sdma v7_1_0 support")
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 106e19f69a066fb6354dac04e5f5ed43a06727f7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v7_1.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v7_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v7_1.c
@@ -1356,10 +1356,6 @@ static int sdma_v7_1_sw_init(struct amdg
 	else
 		DRM_ERROR("Failed to allocated memory for SDMA IP Dump\n");
 
-#ifdef CONFIG_DRM_AMDGPU_NAVI3X_USERQ
-	adev->userq_funcs[AMDGPU_HW_IP_DMA] = &userq_mes_funcs;
-#endif
-
 	return r;
 }
 


