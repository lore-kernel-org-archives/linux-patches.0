Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1770446EF71;
	Fri,  9 Oct 2026 14:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555496; cv=none; b=UdAoKMLL3Gth6ZtBzLctfmv0c/PQL+HGngKNNsMllc0QIs9/i3kkAwN2HYNy7JJe8JcZ1fDftP6ZMnFQb1Ynpq0FQyOzM2UTR83teZv2H9qfwodnqfRnz3Az5FDojZ6T+f69/r/2IgZ0MoWS5t7bVC0lm3aK0b1Y4GJprUy7Pg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555496; c=relaxed/simple;
	bh=5YubYTqq6Zk5O9yUcvjRdPZYLDVkHyAj1rpJJBuTzik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJ9bFQpDEVTC5ye7xCOhUCVZofn3Jj7pv3gOhxok2ExYx+8DgI9syNtcllV60nDO+iWeSp/3f1iNBEHjcHddYJ/HPGYTITbhT4hQ77DPQCaqE7/5d3wzRH54Xu83abc+lPur1mp1IXfpRZKzZ/rArew1FkNk/b7G/lKJcWw5+zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWUcJeR+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWUcJeR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7871F00898;
	Fri,  9 Oct 2026 14:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555493;
	bh=NTsYBXBcMq1Roln0c59ZhaQSOw2zTPzTzOw/HZxneQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uWUcJeR+cwQhIojfE9FPfAnrGNKVv4UNfZgUnPHaH+VVcAfwK3V15YoOqJ2V7Z7GG
	 omIS0odaZ9dimPum3QOi/NkRyFHWJcIKlEIqUXddJisu+ltJwW0Nx6BYYwwh8/RqKA
	 nAjf8NSfCzHi9c850TUlO95LQZRGg4KE6Ql20jJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheetal <sheetal@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/403] ASoC: tegra: Fix ASRC Stream6 input threshold control
Date: Fri,  9 Oct 2026 16:07:08 +0200
Message-ID: <20261009140953.664103230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 851509ae07f59..fae24046a54f7 100644
--- a/sound/soc/tegra/tegra186_asrc.c
+++ b/sound/soc/tegra/tegra186_asrc.c
@@ -829,7 +829,7 @@ static const struct snd_kcontrol_new tegra186_asrc_controls[] = {
 		       tegra186_asrc_put_input_threshold),
 
 	SOC_SINGLE_EXT("Stream6 Input Threshold",
-		       ASRC_STREAM_REG(TEGRA186_ASRC_RX_THRESHOLD, 4), 0, 3, 0,
+		       ASRC_STREAM_REG(TEGRA186_ASRC_RX_THRESHOLD, 5), 0, 3, 0,
 		       tegra186_asrc_get_input_threshold,
 		       tegra186_asrc_put_input_threshold),
 
-- 
2.53.0



