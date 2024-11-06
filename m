Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFAE1DEFD3;
	Wed,  6 Nov 2024 12:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895056; cv=none; b=sFPSVcLAZrG/7pvfpaISUrvOPGmdGFx9zLnV2pCJbCBecb91GFnbI5nL8z7iNWy8swaB8HIIKfoL7zWJL1wPyRQbcq1C/b/zVANptVggD0ylFsim14WM+KL/IpHAbX1cB94FjRObk+1w1ZDKV4Mh/Wl1hZsbF/DswP1Yzx4AfYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895056; c=relaxed/simple;
	bh=6B8WnafIq5uJ0jMiCkOGP1vbgT22g8qxqxjCk+SP4Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6N9bLS/RHFdHd78L5WZHY8g11DQKFbvhS2++Y+mYxJkJNlrubB6hmxou4QEUu/dIRDz+BaBdqRVqOybdS+1pOQufUjk/+35pk0n2jCIgcCr4HlQxy1AWleR8dKqbYUBTfZ1Rrgw4f3JbgiMNVH0z6sHS4ONq9OE1aIUKaUbG1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQLEJMIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQLEJMIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE6CC4CECD;
	Wed,  6 Nov 2024 12:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895056;
	bh=6B8WnafIq5uJ0jMiCkOGP1vbgT22g8qxqxjCk+SP4Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQLEJMIE0nU1GqcEmC7ri1uWIPRu8VVBpNqP97uCgP7zzXSUN+JmV3ZBZEHGm0cpE
	 f7NCGBHNinPCBL1wKxXQM/BWTJ8JwZcdvhohmCBdQFTslofDIbfH0yZzLH+0Tiak5G
	 vLKdC0RSYydkG0NMPQRg80nwQYrXRXqA5F4V/2bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/350] drm/radeon: Replace one-element array with flexible-array member
Date: Wed,  6 Nov 2024 12:59:42 +0100
Message-ID: <20241106120322.225283400@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 4b86e8b450090..e3f4964647641 100644
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
index 821b03d6142b0..0d11d6d1f5f0a 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1742,8 +1742,11 @@ struct radeon_encoder_atom_dig *radeon_atombios_get_lvds_info(struct
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



