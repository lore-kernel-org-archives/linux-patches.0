Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69948433BE;
	Tue, 14 May 2024 10:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682261; cv=none; b=u41bi0D2h7NzJGcomeZfLfTSUS/3WokcL9xd1AKPX62LOmWXN6aMEwdyK1XDoD/7A/O4Uj+/co4eCqBfaBNZ7WESAsiT4AV+nsMpfQgG7jhazpL2Hp9E823ZzfBhQDRvZkBe5XVXQaidNH/ToRpPVGIApZpb3IlLRgaUcPb1DcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682261; c=relaxed/simple;
	bh=eY2EUIzjbi4NXI1vIVDy5qzM2cUs5N1h4VES+ozJRdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SFmgVekhXZM/pX4z+7Xn65MeLjOREzyH2f4jIeqe50Oj43MAXgixM0ANI8cMeFoJAp7YlmMNFNecAuMbASsQx5bhSLp+4658YNOHmPgxH7Y1dCWq3CsPjQ+1Y+/tshANesrvqZNOaXIHHb5mvTAKcrNmvLQ1CrlbCzvZ3tgtvpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KXl3gp1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KXl3gp1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6325C2BD10;
	Tue, 14 May 2024 10:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682261;
	bh=eY2EUIzjbi4NXI1vIVDy5qzM2cUs5N1h4VES+ozJRdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KXl3gp1ZTzL18/WGq/lUVPQ25iPcgkgb+LneJLbN8Qp1f5j+l30+aZTD7+orgsj5+
	 6VT9qcsSBFghKETlkQ0wVZw3n+yOrcZaWJ4d8TW3MYdq1gWcSfpRzgZ7pcg2gGj39p
	 OxVVgRPShVq4NxqGe1AO6EGR43SOvBA+kqcpDQvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 036/336] ASoC: Intel: avs: Set name of control as in topology
Date: Tue, 14 May 2024 12:14:00 +0200
Message-ID: <20240514101039.972269908@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 4cbb5050bffc49c716381ea2ecb07306dd46f83a ]

When creating controls attached to widgets, there are a lot of rules if
they get their name prefixed with widget name or not. Due to that
controls ended up with weirdly looking names like "ssp0_fe DSP Volume",
while topology set it to "DSP Volume".

Fix this by setting no_wname_in_kcontrol_name to true in avs topology
widgets which disables unwanted behaviour.

Fixes: be2b81b519d7 ("ASoC: Intel: avs: Parse control tuples")
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20240418142621.2487478-1-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/topology.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/avs/topology.c b/sound/soc/intel/avs/topology.c
index 48b3c67c91032..d8223e2b4cfe2 100644
--- a/sound/soc/intel/avs/topology.c
+++ b/sound/soc/intel/avs/topology.c
@@ -1458,6 +1458,8 @@ static int avs_widget_load(struct snd_soc_component *comp, int index,
 	if (!le32_to_cpu(dw->priv.size))
 		return 0;
 
+	w->no_wname_in_kcontrol_name = true;
+
 	if (w->ignore_suspend && !AVS_S0IX_SUPPORTED) {
 		dev_info_once(comp->dev, "Device does not support S0IX, check BIOS settings\n");
 		w->ignore_suspend = false;
-- 
2.43.0



