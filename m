Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258E62676DE;
	Tue,  8 Apr 2025 11:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112948; cv=none; b=poyXHbOVorq/gPFFvwTpKi+eb8M+vrsa1pjx6fkeJ29IExFCWo7xrBJH6HJFjPLSjsIEJU7KMUBqZfdXgs8MRMd64zJ0aqdNBe0e98VbyvzBObBHqe/P/3QTjSDLZJoDIDkPKqzPmJI+1VvGA3huw23HACzMQFbNp9dxBpRYrBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112948; c=relaxed/simple;
	bh=neNy+N28+rXWG+3jXuv3B1ILBg0GsQLEh4xPposwIpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxV3BxmTR+VCyy02knXv59B6F3NlZ6o20alFYF+Dpt7NXBcYYIjKq7Pjh+g/yQptOwgiVhwpax9iIC+n0LAHwRgmbyIcOt3zubYseUlGXnrYWHjfCbuQWfJrTdouRh1yjtQeaYoRvCnI/wdN0+TBLRmh2qgJBVeN/1bfZ9JxSj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hgi9D2An; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hgi9D2An"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A887AC4CEE5;
	Tue,  8 Apr 2025 11:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112948;
	bh=neNy+N28+rXWG+3jXuv3B1ILBg0GsQLEh4xPposwIpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hgi9D2Anr0JebEs9+X1EQ7RPKyDTd/qRYLYxbN+aGcjn5PyKjD3PE4VgT1mfJgu/5
	 m/5igOMDZvyroy/IklzSOAv7KdbREot70MbcpONk5+c2p9Rjv8FHDGygRQHlCbYIcH
	 luTXNo6T3a6wS102OqwFpyRXZhR1KFkHNQNGyxz0=
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
Subject: [PATCH 5.15 258/279] drm/amd/display: Skip inactive planes within ModeSupportAndSystemConfiguration
Date: Tue,  8 Apr 2025 12:50:41 +0200
Message-ID: <20250408104833.346151192@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c |   24 ++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c
@@ -867,11 +867,30 @@ static unsigned int CursorBppEnumToBits(
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
@@ -892,6 +911,11 @@ void ModeSupportAndSystemConfiguration(s
 
 	// Total Available Pipes Support Check
 	for (k = 0; k < mode_lib->vba.NumberOfActivePlanes; ++k) {
+		pipe_idx = get_pipe_idx(mode_lib, k);
+		if (pipe_idx == -1) {
+			ASSERT(0);
+			continue; // skip inactive planes
+		}
 		total_pipes += mode_lib->vba.DPPPerPlane[k];
 	}
 	ASSERT(total_pipes <= DC__NUM_DPP__MAX);


