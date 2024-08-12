Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1462C1A5;
	Mon, 12 Aug 2024 16:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480313; cv=none; b=VCUNWsTWlNrAqHB11v7PwAFyrsDB4DWtOHwLUYpNETtsQBkC1wLGtSeEPfBgSsJGAxeSScZdKOjKnsaEPopl7AMxn9yJ1PnpmLpu6Mrj26dqGwB6UQG2nHNrVnDaY5LZViWQx3NrJL9pSfLfLJSxqvqovVhASLJ/0Xlh2DnnNm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480313; c=relaxed/simple;
	bh=CGR7j+3ujGhZUJj7c46knhSCwIUkrKmcurvYhLA+24I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmEclXIxgu8NjArOUYtsg+7DCun78KkjlkbhMhmUOgNknxrlzJ3YikM6GtVecutaoY56OLpDOUGNu+yWafssZzTCaxraC/mVroLA0p46E5X/GiSVAlk8ABeg47BsZlJpodkrJX2dYYSX5zQmLlvPbJjX9jdBE2h5pybYWfLQv68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uObXD1yS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uObXD1yS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6059FC32782;
	Mon, 12 Aug 2024 16:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480312;
	bh=CGR7j+3ujGhZUJj7c46knhSCwIUkrKmcurvYhLA+24I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uObXD1ySfSTfxPTbp6bkXo+8lr4ROQk54e7O2OVMV2lSzwJgOtewP/V/gDXKo0xTA
	 bHcq0AeOss9HBbGitVPh6fdj+nZ9VFQY1o27rzsCyer3bCQWnvdVzaHSi5i/b+qFP8
	 SvPbdUV/slwluqGLs3rR3fy0z2+ozT+fNGsLMt98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 160/263] drm/amd/display: Replace dm_execute_dmub_cmd with dc_wake_and_execute_dmub_cmd
Date: Mon, 12 Aug 2024 18:02:41 +0200
Message-ID: <20240812160152.672683136@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit f2aaed194a54d78c307c44d1829c7e1ba67e9ba5 ]

In the commit c2cec7a872b6 ("drm/amd/display: Wake DMCUB before sending
a command for replay feature"), replaced dm_execute_dmub_cmd with
dc_wake_and_execute_dmub_cmd in multiple areas, but due to merge issues
the replacement of this function in the dmub_replay_copy_settings was
missed. This commit replaces the old dm_execute_dmub_cmd with
dc_wake_and_execute_dmub_cmd.

Fixes: 3601a35a2e9d ("drm/amd/display: Wake DMCUB before sending a command for replay feature")
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6cc213b9aa34bc3213e20f9256345c5cc1495b0b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c
index f820647443d16..09cf54586fd5d 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c
@@ -209,8 +209,7 @@ static bool dmub_replay_copy_settings(struct dmub_replay *dmub,
 	else
 		copy_settings_data->flags.bitfields.force_wakeup_by_tps3 = 0;
 
-
-	dm_execute_dmub_cmd(dc, &cmd, DM_DMUB_WAIT_TYPE_WAIT);
+	dc_wake_and_execute_dmub_cmd(dc, &cmd, DM_DMUB_WAIT_TYPE_WAIT);
 
 	return true;
 }
-- 
2.43.0



