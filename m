Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0D14204E;
	Sun,  7 Jun 2026 10:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829620; cv=none; b=o3B9kp0g6yTgnvV3he5Ih3VwNGoYL/TmHpMv0qUNuDCriF0bBdQtAC88RCLRMQcYJiz4PTBlaxgQidAmApPYhatZf8pAtzDHo2f6lyRpZwfVJwhOv0c9fQzT4gfmYOyX1RzUVtyldHnxYDaQ6+27wLdur1iq/1FB7Yp3tOKOzJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829620; c=relaxed/simple;
	bh=XOjeYQle7wFuXQ4lzk1Tio2gg6fOfVhiE8pnwNimaSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fDEn4JQtPgNDgDAoiz/d4EMpJlAtJRvEfOeerrCEA4Cq06PzGRW34GiRZd6W5edtTXAGqlOgR+D1K0giM4OU39EWEls0YhxBaBV+Wy9sKaLVpqMThYhgkbN+ElNaLv0JGT2/j3HbUrLrK1qFBxuwPt29ORgPUnsCkxTIF/qMrDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+9KD9pl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+9KD9pl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8FA1F00893;
	Sun,  7 Jun 2026 10:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829618;
	bh=KzM6UC3lIt2epdle4TFGvgsbhQQ3xOE2Mv77xn3Uiio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+9KD9pl+7kXK8dMn0kudzXvRWRyI50PhtcfMPDULxzHQlH03Z8nJfzh9qxPr5cR9
	 uE9UrHWpK50YEJGm/7FJEeuN55Le+0NX9ffO9MYSmf3PMOcpcz/bHt/ibkLJWNK4DY
	 5FdSxt/HPQ7wc/fZtxjNALkL6O3gob1LZAj2+zGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jeremy Klarenbeek <jeremy.klarenbeek99@gmail.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>
Subject: [PATCH 7.0 295/332] drm/amd/pm/si: Disregard vblank time when no displays are connected
Date: Sun,  7 Jun 2026 12:01:04 +0200
Message-ID: <20260607095738.898435104@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3076,6 +3076,10 @@ static bool si_dpm_vblank_too_short(void
 	/* we never hit the non-gddr5 limit so disable it */
 	u32 switch_limit = adev->gmc.vram_type == AMDGPU_VRAM_TYPE_GDDR5 ? 450 : 0;
 
+	/* Disregard vblank time when there are no displays connected */
+	if (!adev->pm.pm_display_cfg.num_display)
+		return false;
+
 	/* Consider zero vblank time too short and disable MCLK switching.
 	 * Note that the vblank time is set to maximum when no displays are attached,
 	 * so we'll still enable MCLK switching in that case.


