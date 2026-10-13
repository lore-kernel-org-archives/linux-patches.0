Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71614EB863;
	Tue, 13 Oct 2026 12:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894781; cv=none; b=jZTeCOLqBmhuBl3rmMCbfsHy5BPUopcfDlmg7IB4/kdHyiQI/wc/xxQV4FQ8SyhAi86m7TESYXIQoZ29TVn39yK+dOFOLdaONqlgaYwhFtH8Ox3xwnI2BvVxy4kDnY+q0oY5ZzRRWDfs7aBdk2A9heAoiajBBYciSJ8SAFQLnUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894781; c=relaxed/simple;
	bh=oZrS6dWhplmovHvRirRn99vfjHIcXx6C59JEimTwc5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBJmWzfwE3TAdwkV1quTeAz0WFulvnYBPnI/sk/pzOgS/X8k5hV7RbqKzSaJJaDO0xLYQhnwgBl0/Ds6lhq/yjiSHfPu7drvHDrE4iV+asm+xCeAlZIjCBHNCEb5Y3njCHvVomqanmADNjBiHqe/CBRd/0abIixcjKXHtK8XVgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCZba7+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCZba7+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014B51F000FF;
	Tue, 13 Oct 2026 12:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894780;
	bh=jMWW1BrzJKLOgjLJYDfyQPMAeO5Q3ZXvdkiyq4Slq2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lCZba7+yfKyjAIiKoF7s6G8RoDfJuwB34Yc7LVnK0NA2a5Fw1kDP6hZ1wdK7oUeEz
	 54eJLe17HNcoIxf93aKbl0gMtxbf02UecpybUuhGpPBEafQkJizC53ruz0zer02hTK
	 oTrHg07Ff0lQp+MYhkVReVr4kFrA3DLq/lcrFVJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheetal <sheetal@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/497] ASoC: tegra: Fix ASRC Stream6 input threshold control
Date: Tue, 13 Oct 2026 13:33:42 +0200
Message-ID: <20261013112909.192999748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Sheetal <sheetal@nvidia.com>

[ Upstream commit 75fc8a3ee5aee72f2fea3b6436170fae175f7f19 ]

The Stream6 Input Threshold control points at stream index 4, which is
already used by Stream5. The threshold get and put callbacks derive the
lane ID from the register offset, so the duplicate index makes Stream6
operate on lane 4 and leaves lane 5 inaccessible from userspace.

Use stream index 5 for Stream6.

Fixes: a2df8c2d5b36 ("ASoC: tegra: Add Tegra186 based ASRC driver")
Signed-off-by: Sheetal <sheetal@nvidia.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260921085704.1248920-2-sheetal@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra186_asrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/tegra/tegra186_asrc.c b/sound/soc/tegra/tegra186_asrc.c
index d914dba560135..2b6c4ab26d6c1 100644
--- a/sound/soc/tegra/tegra186_asrc.c
+++ b/sound/soc/tegra/tegra186_asrc.c
@@ -830,7 +830,7 @@ static const struct snd_kcontrol_new tegra186_asrc_controls[] = {
 		       tegra186_asrc_put_input_threshold),
 
 	SOC_SINGLE_EXT("Stream6 Input Threshold",
-		       ASRC_STREAM_REG(TEGRA186_ASRC_RX_THRESHOLD, 4), 0, 3, 0,
+		       ASRC_STREAM_REG(TEGRA186_ASRC_RX_THRESHOLD, 5), 0, 3, 0,
 		       tegra186_asrc_get_input_threshold,
 		       tegra186_asrc_put_input_threshold),
 
-- 
2.53.0



