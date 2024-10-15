Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3049813F435;
	Tue, 15 Oct 2024 11:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992603; cv=none; b=daIFqx03CYRgUXiajdon2ICPftAp2n/SaEWWS87EqWmdhRmWcYb1IrWba34R6VzDoEHSDkVg5GxF0wVYMywf+TCfepCjDssnwtAFKYXV5yFIdl30pQAF4Ya49OC9/7qmcSRK37F/YyKJDBSJbOXLIgirDquHvBb4WMk19pdFc6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992603; c=relaxed/simple;
	bh=OEj9+KI1Hei3ajOF5LBtURlHPYDZd4C80dZQ27SMZfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4hce70PeK9lwuWEueAJHgNuKCRT7FhdVtkzzEJ7UckETJk4M/1j0H/NEGB+PrOQQrr92Jrk2cGGFrbP7VPnsHjWVjSzAwGcEPOXjprXKW/Z5Oi8JLLvGpJKZGd2SakQ04zyJ7B8hEV4I7u7nZ7JBLxZUgQu2oLu9AJ9I1buWAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kk1NSeFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kk1NSeFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F27CC4CEC6;
	Tue, 15 Oct 2024 11:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992603;
	bh=OEj9+KI1Hei3ajOF5LBtURlHPYDZd4C80dZQ27SMZfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kk1NSeFLQPNqVAnG+RZaSZPMm/FI/VUtnxplwKvm5njQeppuTKB8KCzgKVOjaHasR
	 Ig1QWrUvCILlJ2s95Vv7gnSVEG/b9QV776iH0zOrzmMJVjm+8Kdbf8jYzjboxIwP0O
	 4N6GQseWsVVxVCOgDfVEX9VWBHQq0/cSeaxwDMV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/691] drm/radeon: Replace one-element array with flexible-array member
Date: Tue, 15 Oct 2024 13:21:52 +0200
Message-ID: <20241015112446.869475706@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>

[ Upstream commit c81c5bd5cf2f428867e0bcfcccd4e4d2f8c68f51 ]

One-element arrays are deprecated, and we are replacing them with
flexible array members instead. So, replace one-element array with
flexible-array member in struct _ATOM_FAKE_EDID_PATCH_RECORD and
refactor the rest of the code accordingly.

It's worth mentioning that doing a build before/after this patch results
in no binary output differences.

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/239
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101836 [1]

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 17c6baff3d5f ("drm/radeon: properly handle vbios fake edid sizing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/atombios.h        | 2 +-
 drivers/gpu/drm/radeon/radeon_atombios.c | 7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios.h b/drivers/gpu/drm/radeon/atombios.h
index 83e8b8547f9be..5e86cab431246 100644
--- a/drivers/gpu/drm/radeon/atombios.h
+++ b/drivers/gpu/drm/radeon/atombios.h
@@ -3615,7 +3615,7 @@ typedef struct _ATOM_FAKE_EDID_PATCH_RECORD
 {
   UCHAR ucRecordType;
   UCHAR ucFakeEDIDLength;
-  UCHAR ucFakeEDIDString[1];    // This actually has ucFakeEdidLength elements.
+  UCHAR ucFakeEDIDString[];    // This actually has ucFakeEdidLength elements.
 } ATOM_FAKE_EDID_PATCH_RECORD;
 
 typedef struct  _ATOM_PANEL_RESOLUTION_PATCH_RECORD
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 28c4413f4dc8d..c591e4326b13c 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1729,8 +1729,11 @@ struct radeon_encoder_atom_dig *radeon_atombios_get_lvds_info(struct
 						}
 					}
 					record += fake_edid_record->ucFakeEDIDLength ?
-						fake_edid_record->ucFakeEDIDLength + 2 :
-						sizeof(ATOM_FAKE_EDID_PATCH_RECORD);
+						  struct_size(fake_edid_record,
+							      ucFakeEDIDString,
+							      fake_edid_record->ucFakeEDIDLength) :
+						  /* empty fake edid record must be 3 bytes long */
+						  sizeof(ATOM_FAKE_EDID_PATCH_RECORD) + 1;
 					break;
 				case LCD_PANEL_RESOLUTION_RECORD_TYPE:
 					panel_res_record = (ATOM_PANEL_RESOLUTION_PATCH_RECORD *)record;
-- 
2.43.0



