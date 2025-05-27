Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24F11DC998;
	Tue, 27 May 2025 17:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365505; cv=none; b=A+6KprbXj/y9a4omXUU6FlreAbMzDUMy5UB9KA3Y+q9nASw2yUqE9DCIv0RpeoL2TGtbxIli6w52/uKdgWyyJuJQp1ti6Lo5WlWi34v+qh5FvJ1YlOOzglWO7yLBLYoiguUjwGPYKSokboEm1dlkJsRZttJVm/N01IrMybyXPOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365505; c=relaxed/simple;
	bh=rHkP3G2m4xyERLtR+ty7XNoQLWVL/X9ZVq2Z9aMiE38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dx5bgHicuLkGk1hvUMHcOGEIg+/zsGEk/KUNrFaWLCI51fsthDTC8wb+1W7A+dkJC2pWz2nhPD+MznmI7l+CuaeZvrpV+VKjZ7Nu+3Yiq+LKM5rMjZqDOCouVgDyg7hCB5FwvSE05kpEh/HHla7xiQMCK4SYB3d+IPZUWrqzryQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MN2TmUgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MN2TmUgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C8BC4CEE9;
	Tue, 27 May 2025 17:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365504;
	bh=rHkP3G2m4xyERLtR+ty7XNoQLWVL/X9ZVq2Z9aMiE38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MN2TmUgx5TVOp36Zllv8+txhEnOTNarhcoAnEy6E4pMI0PlvE0LsNk01DnPFFL1Tz
	 Ta4WYX9CRhFXz3ElEy9MpE7cxOF4o3t9nNuQCdVDskBYJ0HnsesalwrbiZDJPzHyOm
	 iGhYibaDJHSPbdvWg+VorhQBw/AryGPeK9ZvPOAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 397/626] drm/amd/display: Initial psr_version with correct setting
Date: Tue, 27 May 2025 18:24:50 +0200
Message-ID: <20250527162501.154179605@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

[ Upstream commit d8c782cac5007e68e7484d420168f12d3490def6 ]

[Why & How]
The initial setting for psr_version is not correct while
create a virtual link.

The default psr_version should be DC_PSR_VERSION_UNSUPPORTED.

Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index fa7db10104c45..a99d3e2256f19 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -276,6 +276,7 @@ static bool create_links(
 		link->link_id.type = OBJECT_TYPE_CONNECTOR;
 		link->link_id.id = CONNECTOR_ID_VIRTUAL;
 		link->link_id.enum_id = ENUM_ID_1;
+		link->psr_settings.psr_version = DC_PSR_VERSION_UNSUPPORTED;
 		link->link_enc = kzalloc(sizeof(*link->link_enc), GFP_KERNEL);
 
 		if (!link->link_enc) {
-- 
2.39.5



