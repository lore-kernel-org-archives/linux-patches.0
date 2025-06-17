Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616EA2F2366;
	Tue, 17 Jun 2025 15:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175463; cv=none; b=tZho6hH5dH9mf2oJcf7s6RCcJKDNY7RZzvSwK0e39qyRrSLPTk+ickR/kn5iAUaIRxYLxv7fCRAz86mYU7wC1/9+fp9MkZDci1PYC/d/yKg453w6P6CxhY5LsE2AhFy7AYZXIgnfOI0YZwQmPm2+yQkCkIXN1tqpmUD/Uu4l4N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175463; c=relaxed/simple;
	bh=4l0bauWxU1RUHNOBNKntL/EQZCZ5vvfRKGc1xFT4tjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mg2FAi+of9V44uuvEfkejcc7jbwDuBWKgc/gJHWq7LG1Qe7pdAnhwUGKVFSXZFjzpQk6B8wctxkG9zbnGbcryeTBYxYV/X+uzjinjg4QFrG0jvfFwem1G/JjXT39VOu1CxtPkdX3vY9UuD8OhauGT5rYOxHWqxzvHLfMiFLZ4Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZN78sgJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZN78sgJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD50C4CEE7;
	Tue, 17 Jun 2025 15:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175463;
	bh=4l0bauWxU1RUHNOBNKntL/EQZCZ5vvfRKGc1xFT4tjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZN78sgJwTVvRZjC6nzZelEe+mlUn9MeZQzcD+XlTxIz0npwfORgEFj4Ku8Thj7F5a
	 Ytjks1STnZglfugnS9xXEmn1xAfqiz/OwEq4Peq1Q7n9pF56DUAXhVeB+2sud9M00W
	 1rG4GmKPSFUtCzUQ/7a3xuC/yjTCj5ca8wFvPaSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 090/780] drm: xlnx: zynqmp_dpsub: fix Kconfig dependencies for ASoC
Date: Tue, 17 Jun 2025 17:16:38 +0200
Message-ID: <20250617152455.179895330@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit f9f087d946266bc5da7c3a17bd8fd9d01969e3cf ]

The new audio code fails to build when sounds support is in a loadable
module but the GPU driver is built-in:

x86_64-linux-ld: zynqmp_dp_audio.c:(.text+0x6a8): undefined reference to `devm_snd_soc_register_card'
x86_64-linux-ld: drivers/gpu/drm/xlnx/zynqmp_dp_audio.o:(.rodata+0x1bc): undefined reference to `snd_soc_info_volsw'
x86_64-linux-ld: drivers/gpu/drm/xlnx/zynqmp_dp_audio.o:(.rodata+0x1f0): undefined reference to `snd_soc_get_volsw'
x86_64-linux-ld: drivers/gpu/drm/xlnx/zynqmp_dp_audio.o:(.rodata+0x1f4): undefined reference to `snd_soc_put_volsw'

Change the Kconfig dependency to disallow the sound support in this
configuration.

Fixes: 3ec5c1579305 ("drm: xlnx: zynqmp_dpsub: Add DP audio support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250227132036.1136600-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xlnx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xlnx/Kconfig b/drivers/gpu/drm/xlnx/Kconfig
index dbecca9bdd544..cfabf5e2a0bb0 100644
--- a/drivers/gpu/drm/xlnx/Kconfig
+++ b/drivers/gpu/drm/xlnx/Kconfig
@@ -22,6 +22,7 @@ config DRM_ZYNQMP_DPSUB_AUDIO
 	bool "ZynqMP DisplayPort Audio Support"
 	depends on DRM_ZYNQMP_DPSUB
 	depends on SND && SND_SOC
+	depends on SND_SOC=y || DRM_ZYNQMP_DPSUB=m
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	help
 	  Choose this option to enable DisplayPort audio support in the ZynqMP
-- 
2.39.5



