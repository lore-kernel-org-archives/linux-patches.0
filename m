Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE85188006;
	Mon, 23 Dec 2024 16:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970118; cv=none; b=WEJNH6JGGtupJqyM5myaxCKoFU2ZC2rbPkQmQCCgkEWg5iwTFmHE67zb3wmdWiAzZ2ZHu0deVj7VmSoh/i5P6WVpyQS6nJ4AGH4b3vGdcAjphucmiqlOLpAJ4FKn7V04m1zlu5rR+BUzGVuJw11SShGmSLk61ym6LHr9lheOlY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970118; c=relaxed/simple;
	bh=mtTJbw0rJCG8vaMWdsRs3S3ndik3R4P73P8AV5EVuOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNFK6Qw4jOehXAPa41bR86AWa3IMGbENnhVoN5kE8eS+xaEz/fPRSEqRiuGDGhnoMUdQDAyKHwn8m7Lz7IrB2hdrJZL1miCC1Icmq0eZSb8Afg6cUhMnDXACw27CvK9XTokLg7tkk3IYgfBqQPv/dH0nKvsNP4GDUka7DSh8fCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVnSyEQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVnSyEQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484B4C4CED3;
	Mon, 23 Dec 2024 16:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970118;
	bh=mtTJbw0rJCG8vaMWdsRs3S3ndik3R4P73P8AV5EVuOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVnSyEQOfWrybO8LI7KXYcqKFX8zNAgQh16DEHNPhhik4eTZ0LMxteW537EYn8GXv
	 dvE4qJ2KGjecY38I186oJ3TPgA15TzakywqtEcase//9HPvFRYh/AcB9oLZ8TQyOmn
	 WV9NgVHWBpZzDV0zHrmEwUtXw2nwpFO0rnt3kK08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 119/160] drm/amdgpu/nbio7.0: fix IP version check
Date: Mon, 23 Dec 2024 16:58:50 +0100
Message-ID: <20241223155413.362102684@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 3abb660f9e18925468685591a3702bda05faba4f upstream.

Use the helper function rather than reading it directly.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0ec43fbece784215d3c4469973e4556d70bce915)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c
index 49e953f86ced..d1032e9992b4 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c
@@ -278,7 +278,7 @@ static void nbio_v7_0_init_registers(struct amdgpu_device *adev)
 {
 	uint32_t data;
 
-	switch (adev->ip_versions[NBIO_HWIP][0]) {
+	switch (amdgpu_ip_version(adev, NBIO_HWIP, 0)) {
 	case IP_VERSION(2, 5, 0):
 		data = RREG32_SOC15(NBIO, 0, regRCC_DEV0_EPF6_STRAP4) & ~BIT(23);
 		WREG32_SOC15(NBIO, 0, regRCC_DEV0_EPF6_STRAP4, data);
-- 
2.47.1



