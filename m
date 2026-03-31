Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A75E402BA9;
	Tue, 31 Mar 2026 16:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975475; cv=none; b=J9vsljyl3ZNsnTipUkWxyWkJIqcTUe+4vJHkmvWUN+LdyJeZG+iF1Z9/lrmXc5pGt9uC08kn9HWNRBtESOrKGt7oJxSledU316kMnCbGGuLEPDywg86z4ut5T80lgYZaa/Sejh386KnIJHeRymBaraE0lb/1Io2j1BijIjpu9TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975475; c=relaxed/simple;
	bh=2YJOqLQ8ygEY4oV4jLzbqPLbe90AMzCyvJB5wQ+3YFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lm0tW38jSzMOWpvYeZKemoIH0cfmnYsw/P/KmMg8tUglnlypHYZZzGIQ5OiB3BTFwVnfCxSV44rRwEM/H3ASq6/dpaSmCd5BsGPOARz7Tu/dz6oabaRjIh1xlLRHlo4h3G3pUTUBdGpqFh6cIZoQM9yAx2ZGVMPvtmWfXsIy7JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzV9jb1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzV9jb1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2C0C19424;
	Tue, 31 Mar 2026 16:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975475;
	bh=2YJOqLQ8ygEY4oV4jLzbqPLbe90AMzCyvJB5wQ+3YFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzV9jb1FPMByd+fXZWoui1DJhNtEP3A0ZoNCMAX5x1QHnrPLlZ2E/yQfdBkOjJaWD
	 SkHtdBAfy9sk3FwZfyg3R2zgY+IJ/H0BNrNyCF34gu37Sl/N+f5X/yfShYOx0MBAeh
	 ZD47sV8POuUt68hL5rQdFYzA+ttV587o73oAizmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 266/342] drm/amd/display: check if ext_caps is valid in BL setup
Date: Tue, 31 Mar 2026 18:21:39 +0200
Message-ID: <20260331161808.737188076@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 9da4f9964abcaeb6e19797d5e3b10faad338a786 upstream.

LVDS connectors don't have extended backlight caps so check
if the pointer is valid before accessing it.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5012
Fixes: 1454642960b0 ("drm/amd: Re-introduce property to control adaptive backlight modulation")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3f797396d7f4eb9bb6eded184bbc6f033628a6f6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5406,7 +5406,7 @@ static void setup_backlight_device(struc
 	caps = &dm->backlight_caps[aconnector->bl_idx];
 
 	/* Only offer ABM property when non-OLED and user didn't turn off by module parameter */
-	if (!caps->ext_caps->bits.oled && amdgpu_dm_abm_level < 0)
+	if (caps->ext_caps && !caps->ext_caps->bits.oled && amdgpu_dm_abm_level < 0)
 		drm_object_attach_property(&aconnector->base.base,
 					   dm->adev->mode_info.abm_level_property,
 					   ABM_SYSFS_CONTROL);


