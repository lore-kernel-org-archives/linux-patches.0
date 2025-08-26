Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC473239573;
	Tue, 26 Aug 2025 11:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207463; cv=none; b=bhIadOvY2IvEf3ab7RYKnt6zrpWoy40sdvxM52Tav1F++M+mgdtnnFY6v4ZIhJE9xZoxz+3ftAHNX4F05pPXfOz7sTRC5OqYkScwRMujRJWmjetotM+JWnmxOtijmQTJHZC7+9div31EkGhvY2CHaGpqvtROdlnRKRfuBTm8uKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207463; c=relaxed/simple;
	bh=F/6V6O/XPkSVCskivI3grjoI4I890u3Z7txUp+Ov4FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPflrd9YTvnG+oEzKxPqcQ4GugJPW1LbLg+S/q5H+wXrMJqV15LWAnsa+eFqXv0dILasYTT+u+m+0977YeR9LU3j3sqZMckHgwO9/yHDD71LigmK7cEp+xF+w82pMjQRQiqc3XnCY3bgwWmhygiqVew0iVAX6ueFqp68sO4tu5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+aCboWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+aCboWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF4EC4CEF1;
	Tue, 26 Aug 2025 11:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207463;
	bh=F/6V6O/XPkSVCskivI3grjoI4I890u3Z7txUp+Ov4FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+aCboWgCbqavpaC5pRniWPTG8KshoNOprE5sEGCpWhPv6vevqAqA0eyVcVaYvzH3
	 02++Oj42yta1qtux6qLwQ2MBLvrluUUZqIrnCum5x0nTamJTFzSNEoqBdBWcHnyH4F
	 Vemk4Ui+YmYpe7jlsY0/gYSnPNV0G/rotZ7aJ1jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 192/457] drm/amd/display: Revert "drm/amd/display: Fix AMDGPU_MAX_BL_LEVEL value"
Date: Tue, 26 Aug 2025 13:07:56 +0200
Message-ID: <20250826110942.113134487@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 8e6a18cbf3ee2c1e3d0afd8d3debd0ba8738ad0c upstream.

This reverts commit 66abb996999de0d440a02583a6e70c2c24deab45.
This broke custom brightness curves but it wasn't obvious because
of other related changes. Custom brightness curves are always
from a 0-255 input signal. The correct fix was to fix the default
value which was done by [1].

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4412
Link: https://lore.kernel.org/amd-gfx/0f094c4b-d2a3-42cd-824c-dc2858a5618d@kernel.org/T/#m69f875a7e69aa22df3370b3e3a9e69f4a61fdaf2
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6ec8a5cbec751625133461600d0d4950ffd3a214)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4733,16 +4733,16 @@ static int get_brightness_range(const st
 	return 1;
 }
 
-/* Rescale from [min..max] to [0..MAX_BACKLIGHT_LEVEL] */
+/* Rescale from [min..max] to [0..AMDGPU_MAX_BL_LEVEL] */
 static inline u32 scale_input_to_fw(int min, int max, u64 input)
 {
-	return DIV_ROUND_CLOSEST_ULL(input * MAX_BACKLIGHT_LEVEL, max - min);
+	return DIV_ROUND_CLOSEST_ULL(input * AMDGPU_MAX_BL_LEVEL, max - min);
 }
 
-/* Rescale from [0..MAX_BACKLIGHT_LEVEL] to [min..max] */
+/* Rescale from [0..AMDGPU_MAX_BL_LEVEL] to [min..max] */
 static inline u32 scale_fw_to_input(int min, int max, u64 input)
 {
-	return min + DIV_ROUND_CLOSEST_ULL(input * (max - min), MAX_BACKLIGHT_LEVEL);
+	return min + DIV_ROUND_CLOSEST_ULL(input * (max - min), AMDGPU_MAX_BL_LEVEL);
 }
 
 static void convert_custom_brightness(const struct amdgpu_dm_backlight_caps *caps,


