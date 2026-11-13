Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585837;
	b=spVhDncXx9JYutn3VWg3vP6L9ty6CcP2OAdgVk+CMjoq3UMB6P7b9OxQdh2ufPVemd7P
	 cRNgt7i0ng0PkYlOp+ko/1LT3mSkGQKjGwSe2VLULz3yTRA4A6RGPwnFjMKd12k3qlyBf
	 h/NaeQtXYnjoLieIOueOqAeDk/TxIFMDtbBc3ma5OTXvsyqRS8GQnPVArRdRdE5GQBVoT
	 Vg8gknoX+37Ix9wXl365Diur7n/nn3d1MwTTnRPOBxsK726l7qqjbIeDGqfxA3cRkqI++
	 wSUBcVR1GvO5jpv3ITIKd1ZLZMR88EP4DYzt1zhJ78dkJjrMwPtANYkC+l5w23yKkUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GQpNiIllLl8CGIWu7RU91dHlyZLiD28F1Tg6lEcG4NY=;
	b=sWDTjT3ErfQgKd7Xz/Ry2LqkTkqwXEBBZnQYRJ4mjPZCQzXrgIyuAqEQjbkdnr7IHWLj
	 aBRHe79SSieicnYHrOMUmvq/5UNzgM2v2mMY48/gCDCm6dmmkcufoEHJ924WXOdkVzLKr
	 +gVOwx4phv0MVjYRtApiXF1nMNEg3OMvlc6FvrBgtD9XMiuhV5Ir0Ueg4MXR7eOxkQXNy
	 Gf1PAFrq+iKkdqDOAEKkofxUvvNDjIFSYBjpdvu8AMrEBzSah4QSb/iDHqf62239iK1YB
	 F+a2VFFcp9fKOkW0s7tiOUBAq2/3xDJ8isAFxEXfo1CToHgPe+Uhtk++MQ1h0j3e51w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=On9yjcDW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CEE606BAAA;
	Fri, 13 Nov 2026 16:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=On9yjcDW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605C11F000C4;
	Fri, 13 Nov 2026 16:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585837;
	bh=GQpNiIllLl8CGIWu7RU91dHlyZLiD28F1Tg6lEcG4NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=On9yjcDW/tCa+nZ3b+gyoENtN/S6bIRRp4RQBhc354efNjyY5DuMFXs0DSndtqvtX
	 EKnHR46+ClwDUu0k4le/FcEymR6FazlUyXfhty6pu/uTBBesSzuYVETCcHAvLAxP/c
	 wn1vwUu9WA+CzxWHWdKZLEDM+X3ZN8r/cyiHMOXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Sales <hugo@hsal.es>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 374/507] drm/amdgpu: Clamp the ATIF backlight curve to its 99 points
Date: Fri, 13 Nov 2026 10:51:18 -0500
Message-ID: <20261113153808.853602644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Sales <hugo@hsal.es>

[ Upstream commit 7ba7655701c5cad5bfa043d464d1e24873e24aab ]

amdgpu_atif_query_backlight_caps() stores the firmware's number_of_points
as data_points but copies only the 99 points that luminance_data[] holds.
number_of_points is a u8, so a firmware table that claims more makes the
custom curve code in amdgpu_dm index past the array, and
dm_query_extended_brightness_caps() copy past the end of the
data_points[] buffer it fills

Clamp the count to ATIF_QBTC_MAX_DATA_POINTS and warn, since a table
that claims more is a firmware bug

Fixes: f729e63743f0 ("drm/amd: Pass luminance data to amdgpu_dm_backlight_caps")
Signed-off-by: Hugo Sales <hugo@hsal.es>
Link: https://patch.msgid.link/20261031153948.127016-1-hugo@hsal.es
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit af8a1c2b7d3de4960e10f94e8ba2fc0ccd168072)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 8b8acf98fdfe2..53475f8a3ff16 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -405,7 +405,11 @@ int amdgpu_atif_query_backlight_caps(struct amdgpu_atif *atif)
 			characteristics.max_input_signal;
 	atif->backlight_caps.ac_level = characteristics.ac_level;
 	atif->backlight_caps.dc_level = characteristics.dc_level;
-	atif->backlight_caps.data_points = characteristics.number_of_points;
+	if (characteristics.number_of_points > ATIF_QBTC_MAX_DATA_POINTS)
+		pr_warn(FW_BUG "ATIF: backlight curve has %u points, using the first %u\n",
+			characteristics.number_of_points, ATIF_QBTC_MAX_DATA_POINTS);
+	atif->backlight_caps.data_points = min_t(u8, characteristics.number_of_points,
+						 ATIF_QBTC_MAX_DATA_POINTS);
 	memcpy(atif->backlight_caps.luminance_data,
 	       characteristics.data_points,
 	       sizeof(atif->backlight_caps.luminance_data));
-- 
2.53.0



