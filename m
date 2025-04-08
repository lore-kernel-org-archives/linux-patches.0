Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78478263C6D;
	Tue,  8 Apr 2025 11:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110283; cv=none; b=hf8G0TzVClRirR8KnxcmRA5lf5wABEnvQY+uQlD6pAvLQ1gUe5oSE6+5dvLZPic0x6j7Nh/2AgIbWv0oqqFl4nqwMsDYTA/4ztHlwiGQDsqhM3YFcHTPU/LsB56miNYjWpu0qnh7Z8WRZ9cNMhvRj1Y53+1W1LjIIC6uitMC+Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110283; c=relaxed/simple;
	bh=7IiKMxRzCL9o61FxvKicrS9nBijqE2fakX+VYOs8hz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phI2qpd5SFIly5HaemcKw/i3z3pdogiCA11n3V4d0PeKT/2u9vxFJFhCQpbg5mRaFy+kKQ6y1060iIVFHWQv7/BNl0in7sRsqXZHV6PZjKQmne6jUsRCFX+FrF0ZgjeWLmZUGB548ZqXBw7bK6YIpNH7XP/bOlkKtF/6fNnaM50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7rPvdZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7rPvdZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07908C4CEE5;
	Tue,  8 Apr 2025 11:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110283;
	bh=7IiKMxRzCL9o61FxvKicrS9nBijqE2fakX+VYOs8hz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7rPvdZ4w7OgVceUgzUraoWPoV94dtbD7oDzmhXojtF5dshFLMPWnQxFOyW/km5WX
	 Qa3+/z0rxkog09nAKOrm5FYXN8xTS/lkRWw2981r6LY+gz0bgOI7xisyajKJHv1S6a
	 CccOEnXkqUyuT81QTv4GlsD5FWlpowjnoX5HOHYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 210/227] drm/amd/display: Skip inactive planes within ModeSupportAndSystemConfiguration
Date: Tue,  8 Apr 2025 12:49:48 +0200
Message-ID: <20250408104826.611395972@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

commit a54f7e866cc73a4cb71b8b24bb568ba35c8969df upstream.

[Why]
Coverity reports Memory - illegal accesses.

[How]
Skip inactive planes.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[get_pipe_idx() was introduced as a helper by
dda4fb85e433 ("drm/amd/display: DML changes for DCN32/321") in v6.0.
This patch backports it to make code clearer. And minor conflict is
resolved due to code context change.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c |   27 +++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c
@@ -838,11 +838,30 @@ static unsigned int CursorBppEnumToBits(
 	}
 }
 
+static unsigned int get_pipe_idx(struct display_mode_lib *mode_lib, unsigned int plane_idx)
+{
+	int pipe_idx = -1;
+	int i;
+
+	ASSERT(plane_idx < DC__NUM_DPP__MAX);
+
+	for (i = 0; i < DC__NUM_DPP__MAX ; i++) {
+		if (plane_idx == mode_lib->vba.pipe_plane[i]) {
+			pipe_idx = i;
+			break;
+		}
+	}
+	ASSERT(pipe_idx >= 0);
+
+	return pipe_idx;
+}
+
 void ModeSupportAndSystemConfiguration(struct display_mode_lib *mode_lib)
 {
 	soc_bounding_box_st *soc = &mode_lib->vba.soc;
 	unsigned int k;
 	unsigned int total_pipes = 0;
+	unsigned int pipe_idx = 0;
 
 	mode_lib->vba.VoltageLevel = mode_lib->vba.cache_pipes[0].clks_cfg.voltage;
 	mode_lib->vba.ReturnBW = mode_lib->vba.ReturnBWPerState[mode_lib->vba.VoltageLevel][mode_lib->vba.maxMpcComb];
@@ -862,8 +881,14 @@ void ModeSupportAndSystemConfiguration(s
 		mode_lib->vba.DISPCLK = soc->clock_limits[mode_lib->vba.VoltageLevel].dispclk_mhz;
 
 	// Total Available Pipes Support Check
-	for (k = 0; k < mode_lib->vba.NumberOfActivePlanes; ++k)
+	for (k = 0; k < mode_lib->vba.NumberOfActivePlanes; ++k) {
+		pipe_idx = get_pipe_idx(mode_lib, k);
+		if (pipe_idx == -1) {
+			ASSERT(0);
+			continue; // skip inactive planes
+		}
 		total_pipes += mode_lib->vba.DPPPerPlane[k];
+	}
 	ASSERT(total_pipes <= DC__NUM_DPP__MAX);
 }
 


