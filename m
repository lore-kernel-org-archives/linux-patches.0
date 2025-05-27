Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599401AF0BB;
	Tue, 27 May 2025 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367113; cv=none; b=KJaRmau0dKQbSpbgWsfgjtP7U0U4AKrz1QaPHP9qaHa9wGuenRQ8nzxH01zJOWxYycboDXZj0jVf4HRd8brLJnoRTS1ESO5swqGw3KFBaeAClRkP7JRsB7WNhrLURt1qcY1TAbPeBPBNV0FcAMdGM55rqwsJCE3uZnhY0lSRL8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367113; c=relaxed/simple;
	bh=igtx8p7a0+/MP3f5KeC5qNSkGRY6O5OrIhSVURCiQ9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAJFG4d3H3C++ZQdyciAR+gCiNAJK4D3VrvghckE8LSLq69qe+it1sgNDxWLhIpAg/vsPQJRs+IIxrE1ayOZtONeasuvSTbbLdOglH+dBMsC+hNPzbJBlBkyEoxPLVcrXROFJElSq0k1IrhF/DMRbEP9U0uEivJWImMiOYxnCvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVdksCe0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVdksCe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3C7C4CEE9;
	Tue, 27 May 2025 17:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367113;
	bh=igtx8p7a0+/MP3f5KeC5qNSkGRY6O5OrIhSVURCiQ9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVdksCe05uyCfKM3EOBIKG7bZFeGDMEQWatxPAFoym4zoNoB7iNSBEmQC0V4Hws3d
	 lGlUrWZ7N3uq/TFignE4SLRIEu4NFKJIQF0Ke6bWJDpUvluzomC8M9ZPFMSXQswO3Z
	 xVha4WXkBrsn4ro0TQZGn6b/Jp9Fw/KVtCoD8beM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Sierra <alex.sierra@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Amber Lin <Amber.Lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 253/783] drm/amdkfd: clear F8_MODE for gfx950
Date: Tue, 27 May 2025 18:20:50 +0200
Message-ID: <20250527162523.405135274@linuxfoundation.org>
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

From: Alex Sierra <alex.sierra@amd.com>

[ Upstream commit 59228c6631f902fa826dc61321ab377ba8aadec5 ]

Default F8_MODE should be OCP format on gfx950.

Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Amber Lin <Amber.Lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c
index c734eb9b505f8..3264509408bc8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c
@@ -98,8 +98,7 @@ static int update_qpd_v9(struct device_queue_manager *dqm,
 			qpd->sh_mem_config |= 1 << SH_MEM_CONFIG__RETRY_DISABLE__SHIFT;
 
 		if (KFD_GC_VERSION(dqm->dev->kfd) == IP_VERSION(9, 4, 3) ||
-		    KFD_GC_VERSION(dqm->dev->kfd) == IP_VERSION(9, 4, 4) ||
-		    KFD_GC_VERSION(dqm->dev->kfd) == IP_VERSION(9, 5, 0))
+		    KFD_GC_VERSION(dqm->dev->kfd) == IP_VERSION(9, 4, 4))
 			qpd->sh_mem_config |=
 				(1 << SH_MEM_CONFIG__F8_MODE__SHIFT);
 
-- 
2.39.5



