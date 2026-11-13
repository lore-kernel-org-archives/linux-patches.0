Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590511;
	b=AK3HzXesc6YZuPvVhTahODFpKH/hefr6t85tNBygs0fM9Z7v609gg9YANVVvB3GTxHXI
	 j/UQNM4x7XVfk/3Qc8Lfy2vT5fjXn6nHbFdN48i5lMTt2q4rxNSzHrvfHw10QNt+WKlam
	 8eorxSwCeHm953EEk0gGqxz3yn5wkZMhX48UbD+KzC2UIu7B25Zl03aTPF1/o395ULYLA
	 B/QsPWYxJlt06XWyyYXnmLS7OHcDyCiRjtFOa2Z1sDX3Y9WXIn9MyqYSJ+LgWyXVi4fVk
	 2nVneCbctxSjEGmQQTjEMm/EdvtInZwG269FlOAsKnIbdAPO1KxNlV2q8XTuBE9hUNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6ooMfC0vfQ3zfX+mEG/W0DcpyPrkody9GID5Kq4fpBs=;
	b=V83MRCrzWJHtO2jcyuoRVoRNkXcf2NOPdB+e0y8ypXebZnY/5iko8f4e2R7iSjNDge0L
	 0kkHhj1Oqb0kWU5Vp700Dv/y6NYioCkNdppBolUXNGDnYko604FQ/RngYYQXR1Hd2/bhH
	 78iksbxdBQNLiV5pNQp4nzVSgG0E8Hg8UGm5RsZguTUUyAC9g9xF87+46WQh3WyhApuOa
	 7JIJmf/ohM25xDzs3rk44IXy2rSt0JOVkpTHqxZ48xvp0vPQ90On2LQbBcmQDVGUnG8/v
	 Oz6RoJjlH2rkK6xSqVKbOeYvOs27A3WHMu0/Jdt7YpAE8WMrOUOKqVFS7duUJyDSGFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T6tbh5VU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42088606B35B;
	Fri, 13 Nov 2026 17:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T6tbh5VU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25F81F000C4;
	Fri, 13 Nov 2026 17:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590511;
	bh=6ooMfC0vfQ3zfX+mEG/W0DcpyPrkody9GID5Kq4fpBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6tbh5VUa8NNPKcZrA/HsnigzAsCE8H9SERkTWHC+tk+mkpCtK3liIXfhZiRrnDb/
	 A1fUnxLVu0lFxHnlP/MSlASXh7ybtV7WcPZXHO9TKkgYI2wpNa5vKpJW2yEY9619NF
	 3l1f/GmgGk4I7LJQlDy5Njgv0PmEUnT7UrnIQK4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Sales <hugo@hsal.es>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 414/686] drm/amdgpu: Clamp the ATIF backlight curve to its 99 points
Date: Fri, 13 Nov 2026 10:49:07 -0500
Message-ID: <20261113153834.994853882@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5a04c20a5fd15..4dc44acc1b772 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -400,7 +400,11 @@ static int amdgpu_atif_query_backlight_caps(struct amdgpu_atif *atif)
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



