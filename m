Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5492F2612;
	Tue, 11 Nov 2025 01:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823270; cv=none; b=GkQwD2OofW58pLHwxj1FtsFI4YTTbl+kvEL/CTBPnJfP0lD/XC6dwb11yWyujJrMp8fUYUAnZCg04fdHBJMejMsqIijKjWBUNvI6rIMTMf6Akhlvtz0LhELplQLa9PSS/gIIJmn8FSqoqF9lRVaz36quUmjSU8MXfLP8YJJvogc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823270; c=relaxed/simple;
	bh=3FMNiUYCm6ZS8t/yECAYroLTQFWXE1jThyDuLnV60kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WGzRYzJUdg7OhGS2P/6S45+bS+ViB+r4eLjCkcfiO9y5F6oq+23zlf4AkWwqGYDe0/sIMGvo04LqF5jkrdBMBqPEbnE6VJQviuhLA39BvzNzuj4Eid3jsicbFGhXwXOV8aoHKu9xStHpN7ffb6oL4nTVL9UnIAoaHneWW2Ka2SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4BFhTep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4BFhTep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284C4C16AAE;
	Tue, 11 Nov 2025 01:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823268;
	bh=3FMNiUYCm6ZS8t/yECAYroLTQFWXE1jThyDuLnV60kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4BFhTep3Ydcmt5mAYr69lRAYLbFyLJzk1aAr2aECvcME17hfyrRWIYiE9O2bCDIv
	 rhjHVDc7JwxQV0WF0KU5/QmeoP9E2l2JerdIyppq8R8NX5xGSMvl9qQpHyyRY41G5J
	 X1zwYJVxW4CknGSqxF4k9YjZc3wPJGglkPKcFTjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Danny Wang <Danny.Wang@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 265/849] drm/amd/display: Reset apply_eamless_boot_optimization when dpms_off
Date: Tue, 11 Nov 2025 09:37:15 +0900
Message-ID: <20251111004542.839209985@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danny Wang <Danny.Wang@amd.com>

[ Upstream commit ad335b5fc9ed1cdeb33fbe97d2969b3a2eedaf3e ]

[WHY&HOW]
The user closed the lid while the system was powering on and opened it
again before the “apply_seamless_boot_optimization” was set to false,
resulting in the eDP remaining blank.
Reset the “apply_seamless_boot_optimization” to false when dpms off.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Danny Wang <Danny.Wang@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index bc364792d9d31..2d2f4c4bdc97e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3404,7 +3404,7 @@ static void update_seamless_boot_flags(struct dc *dc,
 		int surface_count,
 		struct dc_stream_state *stream)
 {
-	if (get_seamless_boot_stream_count(context) > 0 && surface_count > 0) {
+	if (get_seamless_boot_stream_count(context) > 0 && (surface_count > 0 || stream->dpms_off)) {
 		/* Optimize seamless boot flag keeps clocks and watermarks high until
 		 * first flip. After first flip, optimization is required to lower
 		 * bandwidth. Important to note that it is expected UEFI will
-- 
2.51.0



