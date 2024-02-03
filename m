Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097BF175BF;
	Sat,  3 Feb 2024 04:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933416; cv=none; b=BtqOv146LQM9Ttxe9aT7egb3Lfnmr2JSZxCHA4ovH0SoaH9FyMPzHEQvMcr+jfj7/WzFGm5PyxiyN0QTFR6DW5GO+b/BDbRrg567gBfkV3IvNsTLtRvQfSCDx84NzOTv9ki1w34ut7efJ2Aal4UVgpvs/99oaBtRfODF2qv742Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933416; c=relaxed/simple;
	bh=2qSiuoglXb+DjyH7Uc0S/qnBg1HqoKNmSL3G3vZm5D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKMWFdHrBeZmCLRk6PNtXGmqHszkC27Ec168Lm8Gq/tp9YV0LjqyAyxHFaMZxnklwACiElkKAlM93uidqUJzpJcnIUPmvy/82A1pbw9PyKq1R7V4XBoog++pxk1jms3KmdrPScQ3+jO+1hUBk2XvfI4Jz2t+EVz4D96f9LO6fjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z19AG4L8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z19AG4L8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F91C43394;
	Sat,  3 Feb 2024 04:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933415;
	bh=2qSiuoglXb+DjyH7Uc0S/qnBg1HqoKNmSL3G3vZm5D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z19AG4L8rkYnaj3GaDq44dafo4ghJy0Brl/TDkLUQD4Rn/4IpYcGorJ0yPsjzr1bn
	 pMMmUAboR26Ch3lfKHY23WsMWZRQEWyZA3PLUAPns/8ZYsRD+TLS8DkAWYOPO4RFpj
	 N/jRR+yVOOupxEcDPzjH6o9cNF12opgfzw92kVO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Josip Pavic <josip.pavic@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/219] drm/amd/display: make flip_timestamp_in_us a 64-bit variable
Date: Fri,  2 Feb 2024 20:05:12 -0800
Message-ID: <20240203035336.993017081@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Josip Pavic <josip.pavic@amd.com>

[ Upstream commit 6fb12518ca58412dc51054e2a7400afb41328d85 ]

[Why]
This variable currently overflows after about 71 minutes. This doesn't
cause any known functional issues but it does make debugging more
difficult.

[How]
Make it a 64-bit variable.

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Josip Pavic <josip.pavic@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_hw_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
index 46c2b991aa10..811c117665e7 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
@@ -244,7 +244,7 @@ enum pixel_format {
 #define DC_MAX_DIRTY_RECTS 3
 struct dc_flip_addrs {
 	struct dc_plane_address address;
-	unsigned int flip_timestamp_in_us;
+	unsigned long long flip_timestamp_in_us;
 	bool flip_immediate;
 	/* TODO: add flip duration for FreeSync */
 	bool triplebuffer_flips;
-- 
2.43.0



