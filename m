Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E8D360EF0;
	Tue, 13 Oct 2026 12:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895541; cv=none; b=U9vzjYirGoiZAQnni1l2xFSwc3b9J4RQr+xu0ZDxb5i5R0Qpp1LcKlcUrUIztvrqnKKNi7esBofpgKbX1MmaMZ3YQOmQ/ELbO7FFCxz8ixvMRRXWY3/Rotye8wXXdG8FUHzzwTQBse1Unp/UqsXmh5TaKFVZ50dowC9NyO2dIX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895541; c=relaxed/simple;
	bh=r7hPdQvdhce35rbLZM/fAuCGlzFDdDM5ZKiQjSNIyz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PSlnS7fLkX/yJ6LZ2F20nt9Q2UTOmCBKGFt/806rwBhjU70qj/oj7OXQ5CVm2Ki3B++DeCptf25EtmkG9gE0UdhqyodJCGnS9zj5dC7usrfHpGtbAg7AA44jJ8k4fuF2yEtrA7EjT1i4ZKX7a9nIUavXYI28ATypf3tEOoOcw5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3bVHekp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3bVHekp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B251F000FF;
	Tue, 13 Oct 2026 12:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895540;
	bh=RuoN7ivMhbUqgQ3iEciSmIe7Jyvjqmu0haC26Hl2ES8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3bVHekprtmpb/+E7uDPCymspLE4dB831aJQQ0+Z2Yty9OQ/dM2+qz+ggaynKpL9Y
	 sz0duTjSu8Onl+ojr8IcOcragw6g/LYUQzLaya1BXg1dJ4whoi60r7hyX9L9kXteDh
	 x94CU8DJ1AMZtqpFjEpyawmPtxOnfa2HvGGU8sYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 308/497] drm/amd/display: Mark DCE 6.4 as not APU
Date: Tue, 13 Oct 2026 13:37:55 +0200
Message-ID: <20261013112915.212761207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 3a52d587d1fc8e8bf94ba1b07374f7ec91aaffb4 ]

DCE 6.4 is found in Oland chips, which were advertised
as low-end gaming GPUs in 2013~2015 and then have been
sold as low-end workstation GPUs until 2017~2019.

These are not APUs.

Fixes: 7c15fd86aaec ("drm/amd/display: dc/dce: add initial DCE6 support (v10)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260923122033.1046651-3-timur.kristof@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1072aa811ea1e61d5f763e4ec1bc6d24bb61f14a)
Cc: stable@vger.kernel.org
[ sashal: Adjusted patch context for the older source layout with missing initialization lines. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
index 0bbbb1ca5e251..c5bf95b71b1a1 100644
--- a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
@@ -1367,7 +1367,6 @@ static bool dce64_construct(
 	dc->caps.max_downscale_ratio = 200;
 	dc->caps.i2c_speed_in_khz = 40;
 	dc->caps.max_cursor_size = 64;
-	dc->caps.is_apu = true;
 
 	/*************************************************
 	 *  Create resources                             *
-- 
2.53.0



