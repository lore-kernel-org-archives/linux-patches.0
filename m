Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA4725A640;
	Tue, 11 Nov 2025 00:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822315; cv=none; b=pulk6sx+Kc7cd55hwlAWI9aGwYXFJRyPhM0cJSz9qeFB5XpsVzubPGdfS9nIkGgWbiNqOhzA2oPXxy4Ouq6skuNjy/K1SuuhU1fbRsCMBrgYDxyheqmns0S8f+Mu7K+6YpJE2VNaNJv0La+vYpIfniscAkefd0DTmYutk1f+kuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822315; c=relaxed/simple;
	bh=GfxPEN/BHPkUhlT5qrOfBLkwMJQOgD7oCwgCMtrWD/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RA8MAE7rIyiorcKj+0V6QarjVn1I7QMTKz/Bb/TrvnDx/Jda3fv7KAQw8SEQa9759KXN6Kzd9UAzjLcqdUqeehfIaNF40f1SmBz9/RvJ99ooj8KRD1UN++BXiBD+gFfsJV3fBmBjuHunlX7KpcsoW4l3cAiWshigHCzdmZRJzGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OisbjC1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OisbjC1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67574C116B1;
	Tue, 11 Nov 2025 00:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822315;
	bh=GfxPEN/BHPkUhlT5qrOfBLkwMJQOgD7oCwgCMtrWD/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OisbjC1EhwRgbT8a6D8iLp1kjYcjGZuypmLnhcUDimkxYHNQEkRgJKe/CuQdqWO59
	 +km6OoXUoUPrd8UFhiEwIPPmmhK/mFfPooD7fjrY9zQed2Mhsi8kGIvaCcyfhYSyzd
	 39RyXZX2LmB3qGWLnPSMdN/bapYm4RCnnabCCMVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 078/849] ASoC: soc_sdw_utils: remove cs42l43 component_name
Date: Tue, 11 Nov 2025 09:34:08 +0900
Message-ID: <20251111004538.306911300@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 45f5c9eec43a9bf448f46562f146810831916cc9 ]

"spk:cs42l43-spk" component string will be added conditionally by
asoc_sdw_cs42l43_spk_rtd_init(). We should not add "spk:cs42l43"
unconditionally.

Fixes: c61da55412a0 ("ASoC: sdw_utils: Add missed component_name strings for speaker amps")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251027140012.966306-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_utils.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 1580331cd34c5..0c95700b8715a 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -600,7 +600,6 @@ struct asoc_sdw_codec_info codec_info_list[] = {
 			{
 				.direction = {true, false},
 				.dai_name = "cs42l43-dp6",
-				.component_name = "cs42l43",
 				.dai_type = SOC_SDW_DAI_TYPE_AMP,
 				.dailink = {SOC_SDW_AMP_OUT_DAI_ID, SOC_SDW_UNUSED_DAI_ID},
 				.init = asoc_sdw_cs42l43_spk_init,
-- 
2.51.0



