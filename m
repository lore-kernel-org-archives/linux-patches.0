Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6512E255238;
	Wed,  5 Mar 2025 18:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198728; cv=none; b=uvc79Z4Kb/eKvzFs6UDpmyuwhEk1BEaK0mZoKufkJJ2nwNnesNC8O/5qRyIZH5EFnsD6JbDkCLO43Gp41jP6DwV02K7OR5b/vdKuYfHQ2u3n8kGCpdpHrUgqOYVPr+N+i+vFpgdjbVFVlQTOluiOZmVGov4KatfTZvLLb5yFh7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198728; c=relaxed/simple;
	bh=OZ9agHv1Q04BRKqaY88WwutoTWq4x52coR2YvTzx/3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sA0O+NQCP0T8XZaVm0qhhDXfJ+1LIkyrj4ogR+7zDmp75nL3NK7BYh1XlMP6Qab0XrjFBVdnnD2EwZUBGjigo9V23KoZHRAYeYVilNq/WEBLHBB4l9kI1ZoLZT+HfhqPGLOBqBSpE5szMMXQEfgFmLtATMThJR18kGC5k+7tpmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BCZX0yVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BCZX0yVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD20AC4CED1;
	Wed,  5 Mar 2025 18:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198728;
	bh=OZ9agHv1Q04BRKqaY88WwutoTWq4x52coR2YvTzx/3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BCZX0yVm4D8S8XUwDRRFW94zeCcQXDgYCXyFD9BoVUConfhoupZJKPDUHe0tpOoHp
	 hRGt3it2DEFjVqIWiQvj3bba3kuSl38qa/c6XgdyS1qsr6t/NfytWvrFjfRwPA4alp
	 3Ylt1vGB33fN+jbWEu4N/FeQQt8gHDrNPZjw5drk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sun peng Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.13 096/157] drm/amd/display: Disable PSR-SU on eDP panels
Date: Wed,  5 Mar 2025 18:48:52 +0100
Message-ID: <20250305174509.171192441@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

commit e8863f8b0316d8ee1e7e5291e8f2f72c91ac967d upstream.

[Why]
PSR-SU may cause some glitching randomly on several panels.

[How]
Temporarily disable the PSR-SU and fallback to PSR1 for
all eDP panels.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3388
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6deeefb820d0efb0b36753622fb982d03b37b3ad)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -54,7 +54,8 @@ static bool link_supports_psrsu(struct d
 	if (amdgpu_dc_debug_mask & DC_DISABLE_PSR_SU)
 		return false;
 
-	return dc_dmub_check_min_version(dc->ctx->dmub_srv->dmub);
+	/* Temporarily disable PSR-SU to avoid glitches */
+	return false;
 }
 
 /*


