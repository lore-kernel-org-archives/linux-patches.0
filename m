Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A5F22323;
	Thu, 18 Jan 2024 10:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575176; cv=none; b=LjcVDobc8A7F0f4wVkfEVze5HDWA1RtC6AlNWGOgdSUt5BonyNWXust36AYQJf984EfatJ0x9S8wuBMwZtKH9KxID6NeTYefnBYY/crGClnRTTqS3s+UgR36iLA7bIgUBvuAamQY0BOyXfrWyjjdjElRxIVQUvoVh0yh7r9Nt+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575176; c=relaxed/simple;
	bh=RsMCTwBdJCJJ5J6VzmrNnZ7o8tICXzWTHuEmp64h8vM=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=fPWmWttSh51FRluqBIwrzBExsRR6dTOT2FCyifGp739wWYBAVAYXCDbrR/IRmF+oCSanmu/NdgCrw/iAHRPuCG0PbAco59S3WII1TgHM9sAy7GI7stDEPNC9M3uTp99h3NkdnC+VGaLECtlP0R1X3vSMIxJxQqNn0onUd9WzVpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJV228mi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJV228mi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A95EC433C7;
	Thu, 18 Jan 2024 10:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575176;
	bh=RsMCTwBdJCJJ5J6VzmrNnZ7o8tICXzWTHuEmp64h8vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJV228mieW3g9I5j2wNj9GiQIdraQkHdTu2lRgnWaAVrtlbu2zgYcrPFgv6cyjT68
	 s3dhptFZPlrJjJRvVH3nEeNoiXnI9B0RSePmxgVDv70pZlIeR1HtweQNHjCFLcPFzQ
	 aWrOEqyemrMNaqe6vGFxI3v/PS6soP02IdXB+HiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/150] ASoC: fsl_xcvr: refine the requested phy clock frequency
Date: Thu, 18 Jan 2024 11:47:41 +0100
Message-ID: <20240118104321.901603909@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 347ecf29a68cc8958fbcbd26ef410d07fe9d82f4 ]

As the input phy clock frequency will divided by 2 by default
on i.MX8MP with the implementation of clk-imx8mp-audiomix driver,
So the requested frequency need to be updated.

The relation of phy clock is:
    sai_pll_ref_sel
       sai_pll
          sai_pll_bypass
             sai_pll_out
                sai_pll_out_div2
                   earc_phy_cg

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Link: https://lore.kernel.org/r/1700702093-8008-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index 77f8e2394bf9..f0fb33d719c2 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -358,7 +358,7 @@ static int fsl_xcvr_en_aud_pll(struct fsl_xcvr *xcvr, u32 freq)
 	struct device *dev = &xcvr->pdev->dev;
 	int ret;
 
-	freq = xcvr->soc_data->spdif_only ? freq / 10 : freq;
+	freq = xcvr->soc_data->spdif_only ? freq / 5 : freq;
 	clk_disable_unprepare(xcvr->phy_clk);
 	ret = clk_set_rate(xcvr->phy_clk, freq);
 	if (ret < 0) {
@@ -409,7 +409,7 @@ static int fsl_xcvr_prepare(struct snd_pcm_substream *substream,
 	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
 	u32 m_ctl = 0, v_ctl = 0;
 	u32 r = substream->runtime->rate, ch = substream->runtime->channels;
-	u32 fout = 32 * r * ch * 10 * 2;
+	u32 fout = 32 * r * ch * 10;
 	int ret = 0;
 
 	switch (xcvr->mode) {
-- 
2.43.0



