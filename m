Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D971C5F37;
	Thu, 13 Feb 2025 15:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459133; cv=none; b=ehhY/ZcPMhMkfk/idKOaF7X5LcDdoaZ0ws0nT5uyGjEhjq+4S4p4fYSqLg4Xw0VunHUR+5shD7zX6x64Jnb7/mLbCY8ap8ZQJQYD9an4Es5ht6yEoHX+PLRWw8e/j1D530UI1WNirQtf6RP5w6PAS+HTjV63bNjGd5qHBH8onSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459133; c=relaxed/simple;
	bh=HHhDCxRKMdjYitY0Yc8uVqY3duOxch1ILsP2VB6NXj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXyuvHd0ySX4sAPVuJsMaK2x636BS6YVvxmk+ST2chjgh1+SjFDNUz4djGEtJpZ52Fafwuixxa1kqCngJPIa1m16aK2d5dBqAaGXjFDHCuE0bWoUaIYG2xaAppio8YrztZxxAvL4ucI2RJBFpnbwbOjS6YTEnhmEq5WLkPQ8Hjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MER5g5rP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MER5g5rP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56B9C4CED1;
	Thu, 13 Feb 2025 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459133;
	bh=HHhDCxRKMdjYitY0Yc8uVqY3duOxch1ILsP2VB6NXj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MER5g5rPBAvm83BuzkEF4FpvuAj4mAG6JzKPCrsy3Awza+9abRLEze4lnPgzfTAWB
	 8/GV6+HwXdc6fpL9YyLtt2492oTC2hcO0DEOHIfIZYC7DSQjPsDSUTI0wxD5RLt0c4
	 QnkOEIcAanApxHDCsdJtdUwiPJ/D+KoxmlY3GYFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 178/443] Revert "drm/amd/display: Use HW lock mgr for PSR1"
Date: Thu, 13 Feb 2025 15:25:43 +0100
Message-ID: <20250213142447.473550729@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Tom Chung <chiahsuan.chung@amd.com>

commit f245b400a223a71d6d5f4c72a2cb9b573a7fc2b6 upstream.

This reverts commit
a2b5a9956269 ("drm/amd/display: Use HW lock mgr for PSR1")

Because it may cause system hang while connect with two edp panel.

Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
@@ -63,8 +63,7 @@ void dmub_hw_lock_mgr_inbox0_cmd(struct
 
 bool should_use_dmub_lock(struct dc_link *link)
 {
-	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1 ||
-	    link->psr_settings.psr_version == DC_PSR_VERSION_1)
+	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1)
 		return true;
 
 	if (link->replay_settings.replay_feature_enabled)


