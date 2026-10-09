Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EB5438011;
	Fri,  9 Oct 2026 14:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556426; cv=none; b=G4r33t9F8gB5k2j2EwIbjTT1ZNchSBnAQJKNf3FT2FdR4jBdpGYe7Hx/2Qn4pGMbPEFnTp990oN/2MSOWE2bMXVGq208yVzX8QHDdgqnWO0KEs+0Uab2C6rGsBz3BOgp+pWeKJYn9CWyWwANnFkluaaVNoespUsbjU0gV2rGM94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556426; c=relaxed/simple;
	bh=gGhsyQnUIkWLOZId1TLrOBZ0hFzsLZQjvzOd+aVtY08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DerSX0sDI7tkmJ5GSGDN8A2TMz3jIvhwN2ridCPM1R0yzHKA8TxYT6tlMWbcDny0z6L99Wxje8wzo5f4PTuMiL6P1xEVbmE0l3oqwcDoNR/z77LIN/p5CoASGKPxm5XUc0bBTWpwvntwOBHZpO8qMSevv8Z49yC1yxyHu3RfGDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxoJ9cn/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxoJ9cn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F061F00899;
	Fri,  9 Oct 2026 14:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556424;
	bh=cAWzAzFoVSeF9HkVFql3ka88nrMmCA3DzSy4g5REG+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mxoJ9cn/l/jrqzjbN3/MtMyQVysg2kKBaQiIUrKTYfepuvmZDfM4C+EgLycBnM6z5
	 euhNPbcLTTlc+22T3TpAqeU4DRQOVAAOs07mPj8VmXkzC72b6cGeD3lB/S6O1JDPLV
	 TyHunBluF+/3pITNJtYgjbmCqql0Gv6h4et67SpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 174/428] drm/amd/display: Mark DCE 6.4 as not APU
Date: Fri,  9 Oct 2026 16:08:31 +0200
Message-ID: <20261009140949.973019989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 3a52d587d1fc8e8bf94ba1b07374f7ec91aaffb4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
@@ -1341,7 +1341,6 @@ static bool dce64_construct(
 	dc->caps.max_downscale_ratio = 200;
 	dc->caps.i2c_speed_in_khz = 40;
 	dc->caps.max_cursor_size = 64;
-	dc->caps.is_apu = true;
 	dc->debug = debug_defaults;
 	dc->check_config = config_defaults;
 


