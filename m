Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7A52571CB;
	Mon, 24 Feb 2025 14:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408391; cv=none; b=ltRxerT46P2MmhIC3cLx5oqFSMjPAOuE3DY6rdxgrOd+jqt+opOj7Ah0zaWYABs17cffbwwsxi70X+2apk8PnxMQ2uofvGGzh8s5GAw/g1v/Gx4Ys9TvmULAS2NKmzD7duFZJaCX6l46HmX7RFJAvQSIz17qS4m6VNnqEmbTcSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408391; c=relaxed/simple;
	bh=qOrxJnsbdGXpRz7M9SgNZweEy9A/O4Ffpej3T7ECEEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdhYgekItqAWstnCvp1wnUoU32xw86K8n4KcE23TJ4yJKVIxy2V5nHpCUf4eIS5OnfRsMIakACc35TvnnZWL0zUlMJUoJ/IE8XMbRaOfaLQG5hgKp3f+VtnfzEwLgkcg/6xBjwUBSL2hW/C284pQEt5Xx8ojRs/40sW/ZWBo9oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyoaTMAX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyoaTMAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB74C4CEE6;
	Mon, 24 Feb 2025 14:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408391;
	bh=qOrxJnsbdGXpRz7M9SgNZweEy9A/O4Ffpej3T7ECEEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyoaTMAXILw/wKIZ4NJmVA1sV5uEtXkk+bysh3Q1SFUE9ibCptxAZVVZsLIof0AGS
	 IU9IOXegtCYbzasyriqDX/mvV319eizLIZVRXeFE77Pz76oiJa/SIpk9nzqLBdC1F4
	 jrMrmzBj8OZQ6J6F1DClxNMgrKVeNFY4vEVkTsZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/154] ASoC: rockchip: i2s-tdm: fix shift config for SND_SOC_DAIFMT_DSP_[AB]
Date: Mon, 24 Feb 2025 15:34:03 +0100
Message-ID: <20250224142608.819419786@linuxfoundation.org>
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



