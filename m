Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C4F1A6161;
	Tue, 30 Jul 2024 16:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356755; cv=none; b=INKHCheBZqvfGcLQtD4gwuLgPYK1kxSvFz6tCn6W09KGZSy8EdAzoImdvvKOMixpaprQ3fagKSs4LVvq5XSoT3grML1hVjDu/3U07sCl+yF0my8loVlJj2Sc7jpGY5dyGZVM5MnuOD5qFjQ7Y9UE1shUwrKw8istmWlGV9zwJOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356755; c=relaxed/simple;
	bh=J3METeKYaZjhVEP450cLX/xxm0868Tv8jVHVZ0wbLYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TFnU8O4c0bungH5iQY7i2JtpTAI4MSXmQpVBEaghIlU+iLZGWfNzFKGsAMdYHwetI7u8EMJep7akXDGX4Sb/UdO5VYjFHH+UhXiXP4dn2AURMHRfLJhz/xOwog+6QFLtx9k9RmVgBgqt437KpMSKYMYX9g7fvcIBNTzdjwbwQkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLjjCrv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLjjCrv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08EDC4AF0A;
	Tue, 30 Jul 2024 16:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356755;
	bh=J3METeKYaZjhVEP450cLX/xxm0868Tv8jVHVZ0wbLYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLjjCrv33prsmamISWOW2chcJ7yPCiJdrNY05WvqaoBTg1ZY3P9aQYZQpgGQ+/vGB
	 7HsYUobNPr1PBxMS4yXwzbczofk8/NZGFrZN9WNb6NWSnJfgWfvcrulgt2T+lQaSX7
	 7YKunS0ji7Anc1P+1N+uWw1V/I8GJHDc9W/vDRyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Le Ma <le.ma@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/568] drm/amdgpu: Fix memory range calculation
Date: Tue, 30 Jul 2024 17:44:48 +0200
Message-ID: <20240730151646.953185423@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit ce798376ef6764de51d8f4684ae525b55df295fa ]

Consider the 16M reserved region also before range calculation for GMC
9.4.3 SOCs.

Fixes: a433f1f59484 ("drm/amdgpu: Initialize memory ranges for GC 9.4.3")
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Le Ma <le.ma@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 8ace3f6210d37..6d2b9d260d92c 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1949,7 +1949,7 @@ gmc_v9_0_init_sw_mem_ranges(struct amdgpu_device *adev,
 		break;
 	}
 
-	size = adev->gmc.real_vram_size >> AMDGPU_GPU_PAGE_SHIFT;
+	size = (adev->gmc.real_vram_size + SZ_16M) >> AMDGPU_GPU_PAGE_SHIFT;
 	size /= adev->gmc.num_mem_partitions;
 
 	for (i = 0; i < adev->gmc.num_mem_partitions; ++i) {
-- 
2.43.0



