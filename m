Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878241E522;
	Thu, 30 Jan 2025 14:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247390; cv=none; b=AjzPEwMfUnoPOkx5vJ5mWTTZbQIQSwjL2Knoose5bqS0+OrakMmPQuf5nnI6XMPCMyBo6J8OwV/TiFpRhS7LnTtvM129IbJk8WILCg451pHikICOKg0y57lcmTmrdndZsdIQR7mOu4hBgKYDvgpPmQfsR2ViSkaYps8KLViC86o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247390; c=relaxed/simple;
	bh=nn4AMd3TvT7uvNmP0r0N51O6kRJYtUcAU2v//LqcqpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBkvuh5pHtpeypxIIn+ZcsajZP202twVxXHuVrin50T4FepUwuaJ3DPcv6WbLTIeFAEd98s60fDcGUrEbGxxTVbiKLfuzwCC4bEH53583XOozZgGheCADG0/EGyI0NF3OHgNgNZslsgX3om3NjtF8PkYDqU1NzRP4I0tZv8Ab9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LaQ3cBf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LaQ3cBf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E157C4CED2;
	Thu, 30 Jan 2025 14:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247390;
	bh=nn4AMd3TvT7uvNmP0r0N51O6kRJYtUcAU2v//LqcqpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LaQ3cBf+YhH2JVGGUCffeimu2GNB5XuVh4TvZ7epoIG8Tk2xeNd0joTwt3qM03Bmq
	 t2HfS54S6nWcCTVVkWU9yoXCRxdBYLOLc9Je3XHEW14Qb77hBfodNNdyVmmxiLyrI8
	 vj3BQJQgA6I6cp4LPHqQxQcqj6ZjVEZBTAzCUGdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun peng Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 05/49] drm/amd/display: Use HW lock mgr for PSR1
Date: Thu, 30 Jan 2025 15:01:41 +0100
Message-ID: <20250130140134.047307223@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

[ Upstream commit b5c764d6ed556c4e81fbe3fd976da77ec450c08e ]

[Why]
Without the dmub hw lock, it may cause the lock timeout issue
while do modeset on PSR1 eDP panel.

[How]
Allow dmub hw lock for PSR1.

Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a2b5a9956269f4c1a09537177f18ab0229fe79f7)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
index 3f32e9c3fbaf4..8d7b2eee8c7c3 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
@@ -65,7 +65,8 @@ void dmub_hw_lock_mgr_inbox0_cmd(struct dc_dmub_srv *dmub_srv,
 
 bool should_use_dmub_lock(struct dc_link *link)
 {
-	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1)
+	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1 ||
+	    link->psr_settings.psr_version == DC_PSR_VERSION_1)
 		return true;
 	return false;
 }
-- 
2.39.5



