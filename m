Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AA1107A6;
	Tue, 23 Jan 2024 00:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969504; cv=none; b=IDiOu6mZs3txHNmKh6z5x7jT9fZEIvbXMEOZ2zN9u3C2Miadtp0Ti+wF661aq/aav9FlgsotBTmmPSPQbBTk8/3aUCjznsM+Po2z44nvuYPH5CUpnXfJWsjMvS3nMb3uKDQu4/Ks7XvrN+31mg2Zuqd1VqCtpJ46Nk3e+/peqEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969504; c=relaxed/simple;
	bh=d30NF0P8t3iI5MOORp/AN/C6bFFAWeDAGy7pu3AXXVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3WzteZrL3jJWwWZLpn9JeLGaYS8p9Iqoi9lP2q6r68/meCnNxwzcQ6JIzp4Pmxqh4rm6xsG6PfM0Ni1XPHFIxCNwk1yPBNFK5PPvyiCmXy9PW8axDBwuwZW21EixamEwWcS5JSOSOc9kT2yBDkRAKrxfrX9xvNwe3nFjg6z5g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAjmi9Bj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAjmi9Bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41947C43399;
	Tue, 23 Jan 2024 00:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969504;
	bh=d30NF0P8t3iI5MOORp/AN/C6bFFAWeDAGy7pu3AXXVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAjmi9BjAnKluixIew3J2aLe1ZCQiHlpa4akN3oHNsjuQFh7bEMaH4wVbN2oOc4HQ
	 yq3F4gYMydazpVLytXXgHGHB7Lckp3BA0w7zLUv1/wWFPo6wI3GxK3kGbWwBdk3Tzi
	 g9dUxScU7sSxNGSmp9HxtXg3y0UKV5fPLLMn92FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 266/641] ASoC: fsl_rpmsg: update Kconfig dependencies
Date: Mon, 22 Jan 2024 15:52:50 -0800
Message-ID: <20240122235826.245416045@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9cce9c4806a89439ea34aad2e382150d68c7ea95 ]

SND_SOC_IMX_RPMSG gained a new dependency and gets selected by SND_SOC_FSL_RPMSG,
which as a result needs to have the same dependency, or produce a build failure
based on that:

WARNING: unmet direct dependencies detected for SND_SOC_IMX_RPMSG
  Depends on [n]: SOUND [=y] && SND [=y] && SND_SOC [=y] && SND_IMX_SOC [=y] && RPMSG [=y] && OF [=y] && I2C [=n]
  Selected by [y]:
  - SND_SOC_FSL_RPMSG [=y] && SOUND [=y] && SND [=y] && SND_SOC [=y] && COMMON_CLK [=y] && RPMSG [=y] && (SND_IMX_SOC [=y] || SND_IMX_SOC [=y]=n) && SND_IMX_SOC [=y]!=n
x86_64-linux-ld: sound/soc/fsl/imx-rpmsg.o: in function `imx_rpmsg_late_probe':
imx-rpmsg.c:(.text+0x11e): undefined reference to `i2c_find_device_by_fwnode'

Fixes: f83d38def6b1 ("ASoC: imx-rpmsg: SND_SOC_IMX_RPMSG should depend on OF and I2C")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20231129113204.2869356-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index be342ee03fb9..d14061e88e58 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -121,6 +121,7 @@ config SND_SOC_FSL_UTILS
 config SND_SOC_FSL_RPMSG
 	tristate "NXP Audio Base On RPMSG support"
 	depends on COMMON_CLK
+	depends on OF && I2C
 	depends on RPMSG
 	depends on SND_IMX_SOC || SND_IMX_SOC = n
 	select SND_SOC_IMX_RPMSG if SND_IMX_SOC != n
-- 
2.43.0



