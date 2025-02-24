Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F4F2571CB;
	Mon, 24 Feb 2025 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408839; cv=none; b=FC4PLbue3HH8sjY5K9veHguzqPfsbBBmU+xz4nVLps9yePRW6Fk5qUksAJzLDdn5l7GdWA5HFbAz/QjTjrYAVV+A6+qGQi607UG9RUEHaHjuMJKULiewlduBzdJ8AuBv2tFB8tBJfWwyMjneHB60DGAOIJSYUvAXZqp/ZUKLIgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408839; c=relaxed/simple;
	bh=5PR4vcGm9wPSjUOI68j96h0wbfgCnUp5eT7iUBd9sCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUD6zQqy2GSm3wu0ECsuZL3bXVnzD97EXdXEqpMHwAbynJfhuiS/rA7fNR1S04rF+MOo4gMwdvlXJI96D5r1Jp+KqAaDw0hC4Fi4c5Io7u8q0TtV1TxYs4vCaLBipNo0Qv4mfOKArwGeng7bs1mbzaV0g3wg31wGngzVkrsvuR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5eAJTqG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5eAJTqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3C0C4CED6;
	Mon, 24 Feb 2025 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408839;
	bh=5PR4vcGm9wPSjUOI68j96h0wbfgCnUp5eT7iUBd9sCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5eAJTqGbLcVfAGRDgp4eJsEJ4A64JCstx7qTyrHOIpwtEreeFGHE3ZlfeoflNEMt
	 Pe4EI/7xlklW6UotIHZxVg7KPct+I0yufJItBgIN40H78Le2I+8c+8EU7lE3Jo1Vgk
	 DUl1aeL/uDBLekV/h+Vf8uKJ2+qIdMf+Ushn6a6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 020/138] ASoC: rockchip: i2s-tdm: fix shift config for SND_SOC_DAIFMT_DSP_[AB]
Date: Mon, 24 Feb 2025 15:34:10 +0100
Message-ID: <20250224142605.260326683@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

[ Upstream commit 6b24e67b4056ba83b1e95e005b7e50fdb1cc6cf4 ]

Commit 2f45a4e289779 ("ASoC: rockchip: i2s_tdm: Fixup config for
SND_SOC_DAIFMT_DSP_A/B") applied a partial change to fix the
configuration for DSP A and DSP B formats.

The shift control also needs updating to set the correct offset for
frame data compared to LRCK.  Set the correct values.

Fixes: 081068fd64140 ("ASoC: rockchip: add support for i2s-tdm controller")
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Link: https://patch.msgid.link/20250204161311.2117240-1-jkeeping@inmusicbrands.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s_tdm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_i2s_tdm.c b/sound/soc/rockchip/rockchip_i2s_tdm.c
index acd75e48851fc..7feefeb6b876d 100644
--- a/sound/soc/rockchip/rockchip_i2s_tdm.c
+++ b/sound/soc/rockchip/rockchip_i2s_tdm.c
@@ -451,11 +451,11 @@ static int rockchip_i2s_tdm_set_fmt(struct snd_soc_dai *cpu_dai,
 			break;
 		case SND_SOC_DAIFMT_DSP_A:
 			val = I2S_TXCR_TFS_TDM_PCM;
-			tdm_val = TDM_SHIFT_CTRL(0);
+			tdm_val = TDM_SHIFT_CTRL(2);
 			break;
 		case SND_SOC_DAIFMT_DSP_B:
 			val = I2S_TXCR_TFS_TDM_PCM;
-			tdm_val = TDM_SHIFT_CTRL(2);
+			tdm_val = TDM_SHIFT_CTRL(4);
 			break;
 		default:
 			ret = -EINVAL;
-- 
2.39.5



