Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFBC3976BA;
	Sat, 17 Oct 2026 16:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256313; cv=none; b=QBl7Af/lXP7Rt5cJlrJS2VdorywH6GINVKr21QtfXZBngBJhgA8ucVXgVBretprxEj8KmqaxIlcC8/605lmNEYik/dsPqmv5NZ9e/+FkwPNzKGHjEFVw3smkp/VBT6l44dJhuRJeh2AXhy4X9i0aX4PYRumJo4PA14aj3OAnPgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256313; c=relaxed/simple;
	bh=yCOJIhrRiiMCi0Oaw7wNTHM8szznnV4wfSkjCAP/AoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iScP3GsGmb7K80z60nOV9CCL49XJM8YXLFxLLV0L7o6xLr7/wQVvMKQ+qPQSTrGh2y88yW1orYgTmUwE1JYfgcbWKp6s1Jp8za4SyHTW8Xqn/MkCLXj7hg0Snke49ZzXIwICseVEw65JT0egTu2OPfsXho3u9/70PBdOVDZVdWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpkhfdLQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpkhfdLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CA01F000C4;
	Sat, 17 Oct 2026 16:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256312;
	bh=C93YOY5HyawZXlK6kMiDc2nyS4YPswXSaNbw0ircm2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zpkhfdLQ936/SBnfkoAwA5eeusUqaWc3Ub6TPh8ygwKlbprrHVvLYsigeb5Nj4U5I
	 AioEORc1c/ms1qAS2sxY06UjAqmlH30BO17lM9jkdI1RrJ+ewR1Go9yfE0POhg68/V
	 FCqLUW9kUMLAg4nxFNLJiX7JQ9FpHsKbGf9R04HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheetal <sheetal@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0194/1674] ASoC: tegra: Fix ASRC Stream6 input threshold control
Date: Sat, 17 Oct 2026 17:41:06 +0200
Message-ID: <20261017160436.133137763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 208e2fcefcf26..798842c4a65f3 100644
--- a/sound/soc/tegra/tegra186_asrc.c
+++ b/sound/soc/tegra/tegra186_asrc.c
@@ -831,7 +831,7 @@ static const struct snd_kcontrol_new tegra186_asrc_controls[] = {
 		       tegra186_asrc_put_input_threshold),
 
 	SOC_SINGLE_EXT("Stream6 Input Threshold",
-		       ASRC_STREAM_REG(TEGRA186_ASRC_RX_THRESHOLD, 4), 0, 3, 0,
+		       ASRC_STREAM_REG(TEGRA186_ASRC_RX_THRESHOLD, 5), 0, 3, 0,
 		       tegra186_asrc_get_input_threshold,
 		       tegra186_asrc_put_input_threshold),
 
-- 
2.53.0



