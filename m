Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1CA280021;
	Tue, 27 May 2025 17:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368212; cv=none; b=Be0O5oQyYUOAkhw90F+NwxeLia+FyKB4PxYsI/aP9yy7gWniQ6KjdrvuUaMsCmCH4JRgojEtfwS7xLDGzTAQdPNGBDVM6OhfMAF/yD/6E3syjxvLxinBF4OrgVotMPQH8Jd8odvU858A6CznmZZQELtY+x3aApWbp0XCks3BOnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368212; c=relaxed/simple;
	bh=ZbOKn2kD0QkrBg/b76mVP/l77uEpu7B9EjjHumBVDFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkRDugxTqkBm2Y6DsmkL7ER0j9bmzH8Cfwk6QLH7o2HUuk+d1o5KyOvijzhlJCFsFgnDX6svOt8DCUoyjR4yIJncVTQc76rpG66EYaoKjZ+4kpDukcu/LFEFxCOnccqjFLDYkBUUNOjusaszgkb35fPNyZRyfdozKvwG6giEHDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUak5BF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUak5BF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB75C4CEE9;
	Tue, 27 May 2025 17:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368212;
	bh=ZbOKn2kD0QkrBg/b76mVP/l77uEpu7B9EjjHumBVDFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUak5BF0r3Xc7LPMhCxaEF+r6EP1RWNtferUnFWYenaHrL0oFdC5PhAd8wP86buo4
	 JSaYz6h3IZybNyuaIA6Ysy+YR9aTcricxN+8gumQJH8muOXLEZduMWOLQp3jDhUbWU
	 kELdXVbEmja4Jd7vnbhG5mgHUoOrcbpPrDabZQOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Lin <Amber.Lin@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviwanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 634/783] drm/amdkfd: Correct F8_MODE for gfx950
Date: Tue, 27 May 2025 18:27:11 +0200
Message-ID: <20250527162538.965078096@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amber Lin <Amber.Lin@amd.com>

[ Upstream commit 0c7e053448945e5a4379dc4396c762d7422b11ca ]

Correct F8_MODE setting for gfx950 that was removed

Fixes: 61972cd93af7 ("drm/amdkfd: Set per-process flags only once for gfx9/10/11/12")
Signed-off-by: Amber Lin <Amber.Lin@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviwanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c
index 3264509408bc8..d85eadaa1e11b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c
@@ -69,8 +69,7 @@ static bool set_cache_memory_policy_v9(struct device_queue_manager *dqm,
 		qpd->sh_mem_config |= 1 << SH_MEM_CONFIG__RETRY_DISABLE__SHIFT;
 
 	if (KFD_GC_VERSION(dqm->dev->kfd) == IP_VERSION(9, 4, 3) ||
-		KFD_GC_VERSION(dqm->dev->kfd) == IP_VERSION(9, 4, 4) ||
-		KFD_GC_VERSION(dqm->dev->kfd) == IP_VERSION(9, 5, 0))
+		KFD_GC_VERSION(dqm->dev->kfd) == IP_VERSION(9, 4, 4))
 		qpd->sh_mem_config |= (1 << SH_MEM_CONFIG__F8_MODE__SHIFT);
 
 	qpd->sh_mem_ape1_limit = 0;
-- 
2.39.5



