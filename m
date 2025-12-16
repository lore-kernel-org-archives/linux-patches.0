Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7052134251D;
	Tue, 16 Dec 2025 11:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884392; cv=none; b=R+aoSIbgjA6PypFGvOPW+hoQYXUoZM/EzDbxQEGVpG8I14OgdJUZuin1lVtDzCYs+vZwpCayTWL4OqMkBB7mnG6UrT/L1kXzTo7SE0szhqNIePb4Xo7bwy9xvPhd4kN9LBdofYjdrpOKi6kU+VXRbXoChwUWf7FSzIU4ICbYgvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884392; c=relaxed/simple;
	bh=PDH60vx+Sp36RQ27USId3ZTjx6m4edFBrVQ/Yf4kVm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JErPu2+0rsvV4PcvvTqY+ma3m9CmYNN43+18OpX52r1lTZZEbKxOHayOPRiAet/T1CfTUhVjgYE+kZWKxtTRTceu6XzWTZJwcOPlmCqZpioPKCdgqCMOfwchn2/Lro5k4kIbuaIVOv0o0T7grHvavPN7AT6l7MEtif2OYxTudFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBPuM6bB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBPuM6bB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB75CC19422;
	Tue, 16 Dec 2025 11:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884392;
	bh=PDH60vx+Sp36RQ27USId3ZTjx6m4edFBrVQ/Yf4kVm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBPuM6bB1HLuYUq7cn6LrQ/BJTS/QMV1YGOeaOQ2zIWPVhH1L/Or+tTq0R0/9nw9L
	 Ekxo7IksPORelRs5c1bnQHjEuGbTCKA5aEpY334np9V2ZLmr1zEEHT7Fo1IZ4Lz6e8
	 cIT5bZvORb68TIxBrbd5Y86GQ6+qsI7P+VAnzU+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 172/354] drm/msm/a2xx: stop over-complaining about the legacy firmware
Date: Tue, 16 Dec 2025 12:12:19 +0100
Message-ID: <20251216111327.145634011@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit a3a22373fce576560757f5616eb48dbf85891d9c ]

If the rootfs have a legacy A200 firmware, currently the driver will
complain each time the hw is reinited (which can happen a lot). E.g.
with GL testsuite the hw is reinited after each test, spamming the
console.

Make sure that the message is printed only once: when we detect the
firmware that doesn't support protection.

Fixes: 302295070d3c ("drm/msm/a2xx: support loading legacy (iMX) firmware")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/688098/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
index 0dc255ddf5ceb..2e25af3462ab6 100644
--- a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
@@ -234,7 +234,7 @@ static int a2xx_hw_init(struct msm_gpu *gpu)
 	 * word (0x20xxxx for A200, 0x220xxx for A220, 0x225xxx for A225).
 	 * Older firmware files, which lack protection support, have 0 instead.
 	 */
-	if (ptr[1] == 0) {
+	if (ptr[1] == 0 && !a2xx_gpu->protection_disabled) {
 		dev_warn(gpu->dev->dev,
 			 "Legacy firmware detected, disabling protection support\n");
 		a2xx_gpu->protection_disabled = true;
-- 
2.51.0



