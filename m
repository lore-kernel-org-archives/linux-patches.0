Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEAB31A045;
	Fri,  9 Oct 2026 14:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555841; cv=none; b=fWwW0WbueS4gUQw6agMA635x7hF4DzD+d+L6LHnR4NE84xxEgsLZNkiF1kmRdPdKhm+4nR654cq+3JIQjx9vOlDDnDc8yqCOElXOdYwEgT+6Ee01FFRRAEWsyp7TMi+eItgDjtuJMdR2fc6CSInCh4EdeA8DfGHCkHRlLxkBckM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555841; c=relaxed/simple;
	bh=5k3OpK08iKt/9N53bBNryUR+WhuVsgpC1WJF1F4mMZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRKcLv2mTl+xK2Tu0olJHS8QaRR3lGWewseKus/gYdrkppviPZ/kXwMZEU4+LiNZjrZGlt0zfid3wHlmV9jgxm6nhZUNYUDsfGmwBhWcODx2MCR2eGYJzPdnXqjh8fAp6WwXl9aZufdt5YR0bsKA9HxU7Pc4MovBSFXXaRF4tFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXYokckS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXYokckS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1EF1F000FF;
	Fri,  9 Oct 2026 14:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555839;
	bh=mq6f/gBRglZhnET8Z8B9vR+D5COVL2OMxcW45vqf2Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXYokckSkY4kpRgi8w0IM7MRD1+R+Xejq6hjPpd9vLllWPZ+llNkk1o1y2e1PzNRa
	 EaToMED5HAyym+LGuveDhfY+lLvzFRHTGnVE5enC+vy4ihole14jzS6ySZzhr99Uxw
	 +EaVk5Q/zofVDOgEFfCGDZ4e48HSrpXZDPwp9iTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheetal <sheetal@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 078/428] ASoC: tegra: Fix ASRC Stream6 input threshold control
Date: Fri,  9 Oct 2026 16:06:55 +0200
Message-ID: <20261009140947.882410003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7f360dfaf8b1a..d8ae5d997615f 100644
--- a/sound/soc/tegra/tegra186_asrc.c
+++ b/sound/soc/tegra/tegra186_asrc.c
@@ -828,7 +828,7 @@ static const struct snd_kcontrol_new tegra186_asrc_controls[] = {
 		       tegra186_asrc_put_input_threshold),
 
 	SOC_SINGLE_EXT("Stream6 Input Threshold",
-		       ASRC_STREAM_REG(TEGRA186_ASRC_RX_THRESHOLD, 4), 0, 3, 0,
+		       ASRC_STREAM_REG(TEGRA186_ASRC_RX_THRESHOLD, 5), 0, 3, 0,
 		       tegra186_asrc_get_input_threshold,
 		       tegra186_asrc_put_input_threshold),
 
-- 
2.53.0



