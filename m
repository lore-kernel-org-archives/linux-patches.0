Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EA63590AC;
	Fri,  9 Jan 2026 11:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959760; cv=none; b=LjywqNSL0dBRj2xsEsCYYmFGWMdijmfUhYUvA+nsenKvVobbrH6srFLAywey8hNTO3JWU/6HcyU1xyZLhdIKiKfZiXZESeMWmlcNfwNOvGCTN+Lgz05xtRYpku50dGMWi4hVV3k2IFzNVky1ylxRYiqmf+l0r4cUAHtjOm02tM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959760; c=relaxed/simple;
	bh=oFIkGqaO8Zx7fTY6VXOb77p1xMqDVmRdeVWpEMtxPr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rj66DxIEOpfsqcgMXfgpjvfPeqtpq9yo+cb2UobcL56WsJbTtggLikuKk0GANGv/hIIW+JnD+BleAY9y67A9P2gaCBNtN007S1uP//P+sCUOtLgxjvYFBTYo9Gun6uQuM6cgarWGVz3V4bTUWBI/r1ZONBlqFOajNEdNWbfl8vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyIJkqMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyIJkqMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3509C4CEF1;
	Fri,  9 Jan 2026 11:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959760;
	bh=oFIkGqaO8Zx7fTY6VXOb77p1xMqDVmRdeVWpEMtxPr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyIJkqMwPmqqTvpLzJyXgrSVKGURbL/ahg0VreMxvL7ucY5Xz1q4cGyd+4LDDnJvl
	 MZ9blScVN3S4+HWSuWK3oJTV3+vREHMhvdUmkcFx3r9i1BgLnC4vGpuhq/vRJoFFax
	 XLvThIFqIymfKc1FH4Rv74Q5J6OdWF8Hf0wTx5cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/737] drm/msm/a2xx: stop over-complaining about the legacy firmware
Date: Fri,  9 Jan 2026 12:35:04 +0100
Message-ID: <20260109112140.200690998@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0d8133f3174be..535c89ce5d62e 100644
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



