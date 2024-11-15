Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AF4126C17;
	Fri, 15 Nov 2024 06:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653000; cv=none; b=tjoqoHMHM6ztMj8H70bkKffwARPFhdcfHiC3y4P/P9ofygX2di04Rr5BREn8cjtJ+8Xs3XwhWTtZQuQcWPeg7dmUOjR+ZqPuBuFiylvHUBjbkZ+r6kS28d+yIaivVZ/jOTGRB/Z+AuWo5RgQyBUdZ2ZD5ptVLaiBrs/2ZmQLm8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653000; c=relaxed/simple;
	bh=C+YGV9mhLzUQ9NVqb5yS8ywMXZZlWe56tAGNNbHjCYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1gDzKA1FRGf0/iT8BYIkJbT7X5WzOBbLNQCR4enH0g4bkFuzfRQ7Wf90BRQkCtyqIahD9IR9jvOT0yfon9NbJRMUslastM5qYA/lyQmZAvckX5gDx+YkyPphCrgNB6ukEST9drUhyN+eG/SyIWuHR2M3S+LyJSrsBkZivwRaq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/ZGqLU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/ZGqLU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD088C4CECF;
	Fri, 15 Nov 2024 06:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653000;
	bh=C+YGV9mhLzUQ9NVqb5yS8ywMXZZlWe56tAGNNbHjCYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/ZGqLU6x64FqPjEHOau5TrDDGRAB1himqHTrshyO7yp6jR/iw1j3rVvpIwSb0S3q
	 35HopQLPqiUQo81kuCLNVmBMquaP5o3ScUKfKKIQX9GqVDZYNUktXIZPFmYkALZyT3
	 FK8lsPXO8DK2kJBunqXGf6bM9khoDcRNy52N0J8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 25/66] drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()
Date: Fri, 15 Nov 2024 07:37:34 +0100
Message-ID: <20241115063723.751869985@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 4d75b9468021c73108b4439794d69e892b1d24e3 upstream.

Avoid a possible buffer overflow if size is larger than 4K.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f5d873f5825b40d886d03bd2aede91d4cf002434)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -395,7 +395,7 @@ static ssize_t amdgpu_debugfs_regs_smc_r
 	if (!adev->smc_rreg)
 		return -EOPNOTSUPP;
 
-	if (size & 0x3 || *pos & 0x3)
+	if (size > 4096 || size & 0x3 || *pos & 0x3)
 		return -EINVAL;
 
 	while (size) {


