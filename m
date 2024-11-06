Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D341DEFD3;
	Wed,  6 Nov 2024 12:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895024; cv=none; b=cNQ5QgeyWYSrkdmYI8wlPX7Lw9gBVR+XC40YOZ3IaF1U2FyDSanz0WIw9Idt/IJiiCRfOiabhZvZHmXet2fcu89VHZ35m49J6Sg3KhooRmo5MnRg/3CEBWFSZ9MSTW7mGZQ0v9sWSFHwWHE04Bw2AqkPfpkBqR2TlBwbd40gUCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895024; c=relaxed/simple;
	bh=XAS6Sl2re3j8AozItli8td5kvA6/hBApb7M/RFnSKZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4rKcc6+XM7W4pV/+feuhkAPPmuFnrcoJJQIUu2jEl+ohTdPAcYf2PDpPyeMfVazLKsBFk8yHmA6+iHEbV3i+3YISraOHg7nue2/7ym8ChQyUx6NR+DQzYRNVuUYzFtDIX/LlkhIQsZqsD3dxpTI4xkO6Ufc5w8ViALWQuZxyQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5sh2Kxy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5sh2Kxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F93C4CECD;
	Wed,  6 Nov 2024 12:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895024;
	bh=XAS6Sl2re3j8AozItli8td5kvA6/hBApb7M/RFnSKZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5sh2Kxyn6V4OwGA51Q0N/zPZHWvmGhJZNR4A9y/kGbDdp7zbIfjZxvTqIXHZxkyz
	 9Z3JwffI/6hgkN8p9S3QhW9zZs94OZhwzxhn/HFfyjse57rLIo+FG2FwxRzupUpd22
	 nU79wMg0DCQ6g2oKkay2S/RXY80OzEJGKlrGRugQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/350] drm/amdgpu: Replace one-element array with flexible-array member
Date: Wed,  6 Nov 2024 12:59:40 +0100
Message-ID: <20241106120322.175929636@linuxfoundation.org>
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

[ Upstream commit 320e2590e281d0a7865e861f50155b5b435e9813 ]

One-element arrays are deprecated, and we are replacing them with
flexible array members instead. So, replace one-element array with
flexible-array member in struct _ATOM_FAKE_EDID_PATCH_RECORD and
refactor the rest of the code accordingly.

Important to mention is that doing a build before/after this patch
results in no binary output differences.

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/238
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101836 [1]

Signed-off-by: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 8155566a26b8 ("drm/amdgpu: properly handle vbios fake edid sizing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/atombios_encoders.c | 7 +++++--
 drivers/gpu/drm/amd/include/atombios.h         | 2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/atombios_encoders.c b/drivers/gpu/drm/amd/amdgpu/atombios_encoders.c
index d702fb8e34275..9de266a1bfbe0 100644
--- a/drivers/gpu/drm/amd/amdgpu/atombios_encoders.c
+++ b/drivers/gpu/drm/amd/amdgpu/atombios_encoders.c
@@ -2110,8 +2110,11 @@ amdgpu_atombios_encoder_get_lcd_info(struct amdgpu_encoder *encoder)
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
diff --git a/drivers/gpu/drm/amd/include/atombios.h b/drivers/gpu/drm/amd/include/atombios.h
index 8ba21747b40a3..c9f70accd46d8 100644
--- a/drivers/gpu/drm/amd/include/atombios.h
+++ b/drivers/gpu/drm/amd/include/atombios.h
@@ -4107,7 +4107,7 @@ typedef struct _ATOM_FAKE_EDID_PATCH_RECORD
 {
   UCHAR ucRecordType;
   UCHAR ucFakeEDIDLength;       // = 128 means EDID length is 128 bytes, otherwise the EDID length = ucFakeEDIDLength*128
-  UCHAR ucFakeEDIDString[1];    // This actually has ucFakeEdidLength elements.
+  UCHAR ucFakeEDIDString[];     // This actually has ucFakeEdidLength elements.
 } ATOM_FAKE_EDID_PATCH_RECORD;
 
 typedef struct  _ATOM_PANEL_RESOLUTION_PATCH_RECORD
-- 
2.43.0



