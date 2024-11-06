Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F121CC14B;
	Wed,  6 Nov 2024 13:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898021; cv=none; b=Uf4VXpTCNQB4Mw01As+sQWcgTmzKtjqeXyHJxMTscHkB4S4PlIC29cEPROD9lu9CaKD1zqKoFDZC8db9tKH/Q4na/zUflBT0OYG2V/WkJX80WyNoNh+ovbaWIDwD6fm9bNuJAomQj84EkZlTJJTlOAqo8+EF+FT6cY3a9jOyUdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898021; c=relaxed/simple;
	bh=1AEXVHomUln2gKg8/ri/oxAFdORH7JQvt517gwRxhNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKpU1CaaLP516GkzXYRHU1+0RMyIr2hwgjeu3uQz8aCY2yFVKZ1ixTXAmAVjhcdaclsKfMYjz9lizGB4dLD6FVAhr0A9Vm98xHonfv71gQ5uG4fvzSQcblNdBqy69U61dWTJ9kwO1FQzQJcd26Sb6WM+3TLIDaKofdgXcXaWQws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2VKybfQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2VKybfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669C2C4CECD;
	Wed,  6 Nov 2024 13:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898020;
	bh=1AEXVHomUln2gKg8/ri/oxAFdORH7JQvt517gwRxhNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2VKybfQz1RPnGqySK3dxmssGO7XGuUZ5gPjGnlu3SEGvDJhYU3HNwQeBFiT2FcJs
	 lgj8p4NuGTqjQbhXYZUDkeKSl1hPuVoPq73w5SlmAzDEH/H6yO1RD4AUFcWuD65gwV
	 Hu4RHvGy895Z/MpDV7ln03QM/37WILKEGDd0+ti4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/462] drm/amdgpu: Replace one-element array with flexible-array member
Date: Wed,  6 Nov 2024 12:59:23 +0100
Message-ID: <20241106120333.238256120@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1e94a9b652f70..754d1e1387155 100644
--- a/drivers/gpu/drm/amd/amdgpu/atombios_encoders.c
+++ b/drivers/gpu/drm/amd/amdgpu/atombios_encoders.c
@@ -2113,8 +2113,11 @@ amdgpu_atombios_encoder_get_lcd_info(struct amdgpu_encoder *encoder)
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



