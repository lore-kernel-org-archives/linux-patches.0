Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C45731ED93;
	Sun,  7 Jun 2026 10:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829583; cv=none; b=Dup7luhnt75Z4fQs6wTj9g2JhevwZNOV9yHoXwyB0MvweUftvrjLSdVqeB0c13BiY8RJd/DIQfo6zJmAs7M1uopqhuze30guT1pMVuLy0+B3la6Uq6+85dixxLHdDWHQ1UcqBLW+TWpcrJjmmuVEZX3MDTT4+OTBGz39TyRc7JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829583; c=relaxed/simple;
	bh=MWshjMJkWFMeWcqKx91lOJchAcNe2rkhTTtGo7AibVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ni2ZFVpHJ9seFXUJkeQpSAAcFjQztcWzV+epeRHSutZQMrOOcoAGa7T9G/s9lg8DNsRo5u6uSjEUloX2ihI7SrvzOTQsiJzqTlP19NbzkBsf1PJt+1gJCY4JocJdwHYz4Ma6eWbFgm95kDPbGq04aZTBr3HBpc1EQhrtq4+7SxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+QTVCMB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+QTVCMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963CA1F00893;
	Sun,  7 Jun 2026 10:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829581;
	bh=vsnWLLa/NxRpT6SmeU0MceYO9JLwmZ/kRfFnw+Qytf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+QTVCMBXhvAlCexNQea7KmAl5HbYoJHfPC/AVEQbSUAKGmEwvEztG4A/70eBTepH
	 I6D6EmWjkRc2Z3Z6VtjWwU2qMtcfegc773yEa7ngrCUBNwrr1PVx9vQ7Sl8mY/YKaW
	 HZPlrHx7kbC8vISrAS6RqvQDrtlvJETURQSUqWx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jeremy Klarenbeek <jeremy.klarenbeek99@gmail.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>
Subject: [PATCH 6.18 260/315] drm/amd/pm/si: Disregard vblank time when no displays are connected
Date: Sun,  7 Jun 2026 12:00:47 +0200
Message-ID: <20260607095737.122874035@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3081,6 +3081,10 @@ static bool si_dpm_vblank_too_short(void
 	/* we never hit the non-gddr5 limit so disable it */
 	u32 switch_limit = adev->gmc.vram_type == AMDGPU_VRAM_TYPE_GDDR5 ? 450 : 0;
 
+	/* Disregard vblank time when there are no displays connected */
+	if (!adev->pm.pm_display_cfg.num_display)
+		return false;
+
 	/* Consider zero vblank time too short and disable MCLK switching.
 	 * Note that the vblank time is set to maximum when no displays are attached,
 	 * so we'll still enable MCLK switching in that case.


