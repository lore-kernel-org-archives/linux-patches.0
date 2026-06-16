Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C183A3E78;
	Tue, 16 Jun 2026 17:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631173; cv=none; b=iJEgHC28p7EUYMwiR2lRqWjud0v7H1uu5RzMQI3qsFxS8VI0V6U0fixz7O0AZYdVa5CDAq1im0ITiROqCfRzAAb+kFh0ANVWU7crVoP7IhYnGzNZa3aqSH+smr+agyMpUNCidfihsW4B72jtJJGfA3Wx1sSn1F9asnsvdh1Q4MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631173; c=relaxed/simple;
	bh=DjXnOeAX3dLIRa91tABMXRVr9JHnjGupM3IC7NObp5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EkkCM4k1Z8dKgLMJn5zCiv4KxpjJkC0UZm44S2MlGg8ZuMzmvCf1PmbI2LTAKT0MUeFkUZ+jktnfy9WcUA8JGtPvOGyp4ZeT1cdUqUGCdSc4xf0A3PSP3E0AOE8HuR9GWdS2sKayx2LWGrILPhZYqXvornvbxOXlQD+sJi6VNFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dT1cgboO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dT1cgboO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CBD1F000E9;
	Tue, 16 Jun 2026 17:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631172;
	bh=62YbDRZYQ2wpq3U2Y/mEaHQDA8X9ekHmVSaKSmOa1Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dT1cgboO+GupZqeZoxlQCE651dI+Yc3eSgo0HF5dMxF+kZVoRvFuTSf+9Cr3RRzyX
	 w4p+Q70W9YurgcgeC/23QsFqG75i9zLo0aJ0Q657T/bcUa6ra1gXxoad6vgrRzvNZS
	 OJ8IXPMs0F3CBD5D3TtURwhsbNenhJKZAMIsL204=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jeremy Klarenbeek <jeremy.klarenbeek99@gmail.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>
Subject: [PATCH 6.1 169/522] drm/amd/pm/si: Disregard vblank time when no displays are connected
Date: Tue, 16 Jun 2026 20:25:16 +0530
Message-ID: <20260616145134.063376055@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit dd4f3ee535b3b0ac027f75dbf9dc5fc88733c765 upstream.

When no displays are connected, there is no vblank
happening so the power management code shouldn't
worry about it.

This fixes a regression that caused the memory clock
to be stuck at maximum when there were no displays
connected to a SI GPU.

Fixes: 9003a0746864 ("drm/amd/pm: Treat zero vblank time as too short in si_dpm (v3)")
Fixes: 9d73b107a61b ("drm/amd/pm: Use pm_display_cfg in legacy DPM (v2)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Jeremy Klarenbeek <jeremy.klarenbeek99@gmail.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6d87e0199f7b83735b56e422d59f170a201897a8)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -3062,6 +3062,10 @@ static bool si_dpm_vblank_too_short(void
 	/* we never hit the non-gddr5 limit so disable it */
 	u32 switch_limit = adev->gmc.vram_type == AMDGPU_VRAM_TYPE_GDDR5 ? 450 : 0;
 
+	/* Disregard vblank time when there are no displays connected */
+	if (!adev->pm.pm_display_cfg.num_display)
+		return false;
+
 	/* Consider zero vblank time too short and disable MCLK switching.
 	 * Note that the vblank time is set to maximum when no displays are attached,
 	 * so we'll still enable MCLK switching in that case.


