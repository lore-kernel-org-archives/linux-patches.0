Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF6E24BC09;
	Mon, 24 Feb 2025 14:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408596; cv=none; b=Geb1/raQn14Ms214IhHGgAhvsJGCDr7Zv9jBAtMIouUa91vn8mEIcd8iIx+l23umnY5NFZgFlFjYosiMMxu9wq4KOQgr70vgIeHcTcI1T6wnwt24JGDFltCT+QD/AGOaCDinM8Ha2Si8DYzxszTPxZmAHntARmQU2VWjmGmYEFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408596; c=relaxed/simple;
	bh=Ahioettn6utMj33/dofXL9vIL8tlhgESwMzNgkrOWtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7Nx25/GGppa2+Db15B8vBZQBeOQLGxh0oHUV7/WcKzfOoJbnyANOXkoREXoJGp02Q48Kaf3MLUADrch9nGLz4Wd11lDeGk3T/WSUEr80TVHQND5JrjYbaD4EHL5a0B26nuM2zJ2j06U3vi26iMgbh0tM44a4J1/ypzRIv/80dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2DusMSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2DusMSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF8AC4CED6;
	Mon, 24 Feb 2025 14:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408596;
	bh=Ahioettn6utMj33/dofXL9vIL8tlhgESwMzNgkrOWtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2DusMSwHB5e2jNQOwLTM+yk0fb/S7+5A4r6mxM+ZQ7BHrTXhax1dLnAEjRBlNlza
	 KqNjwulnPEa+UWWQOckss7V+4eIP+qrFRAePM0YKNFlnPGNUchYp4ZnGxNtheXzzzn
	 AMWAXbhgHKCHILfT0rDAnkD+J72wPZqjY1o+fkwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/154] drm/nouveau/pmu: Fix gp10b firmware guard
Date: Mon, 24 Feb 2025 15:35:03 +0100
Message-ID: <20250224142611.132329588@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit 3dbc0215e3c502a9f3221576da0fdc9847fb9721 ]

Most kernel configs enable multiple Tegra SoC generations, causing this
typo to go unnoticed. But in the case where a kernel config is strictly
for Tegra186, this is a problem.

Fixes: 989863d7cbe5 ("drm/nouveau/pmu: select implementation based on available firmware")
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250218-nouveau-gm10b-guard-v2-1-a4de71500d48@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c
index a6f410ba60bc9..d393bc540f862 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c
@@ -75,7 +75,7 @@ gp10b_pmu_acr = {
 	.bootstrap_multiple_falcons = gp10b_pmu_acr_bootstrap_multiple_falcons,
 };
 
-#if IS_ENABLED(CONFIG_ARCH_TEGRA_210_SOC)
+#if IS_ENABLED(CONFIG_ARCH_TEGRA_186_SOC)
 MODULE_FIRMWARE("nvidia/gp10b/pmu/desc.bin");
 MODULE_FIRMWARE("nvidia/gp10b/pmu/image.bin");
 MODULE_FIRMWARE("nvidia/gp10b/pmu/sig.bin");
-- 
2.39.5



