Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAED2054F8;
	Thu, 12 Dec 2024 15:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016851; cv=none; b=u0UXWXlcczpgHC8CQsNdFm0ofzI0u1I46Ddu19qpG3GUJkSnx6gOa4wZUpEkFVCg3TOHt7bd4yr3QznBH9RLBRY73K7t99mNp7EwBPv+aLst529iiHTFkmJW7iaHp7uhAX2MENN4oJhsbv1m9XSrItVcvHfRIDVUIYUWtTSGGb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016851; c=relaxed/simple;
	bh=EoFV/8VcBfB31cnSItfxz2LPo+Zg/a/wtoDI0sRxBbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRBTih1pv5w7TzwYpopPvth6f7zISHYoGdB6mz8VeJafoLGYF1SKjhQfvieGriDoEwJKjbycD9RO6gV2MKUvxAj/Q/MB0Lff46oC00I3vIEA/o45nbebNSy2PG87WA2Zq72EQ0yADmuUpI+RuCMjfgW5WxLn/Xt+MqAZoEWyf+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKqqn8bC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKqqn8bC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D767C4CEDD;
	Thu, 12 Dec 2024 15:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016851;
	bh=EoFV/8VcBfB31cnSItfxz2LPo+Zg/a/wtoDI0sRxBbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKqqn8bCBegJZN8Sxh9XaWWpArHzvFhSiEdwlwOIgrrdfrzM0vY1DI3ZePy2G5ajf
	 osunU5Chv1ODzDk0/B4/SCZN7uhykpoZ552p0khnKmZ2p7xedsDj6D32Bh5R17IvBT
	 Mv22gIHu9dAhvKBBCm1MovFZiK5ixXUNLjGXhVjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mac Chiang <mac.chiang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 314/466] ASoC: sdw_utils: Add quirk to exclude amplifier function
Date: Thu, 12 Dec 2024 15:58:03 +0100
Message-ID: <20241212144319.185312293@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mac Chiang <mac.chiang@intel.com>

[ Upstream commit 358ee2c1493e5d2c59820ffd8087eb0e367be4c6 ]

When SKUs use the multi-function codec, which integrates
Headset, Amplifier and DMIC. The corresponding quirks provide
options to support internal amplifier/DMIC or not.

In the case of RT722, this SKU excludes the internal amplifier and
use an additional amplifier instead.

Signed-off-by: Mac Chiang <mac.chiang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20241028072631.15536-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_utils.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index c06963ac7fafa..e6ac5c0fd3bec 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -363,6 +363,8 @@ struct asoc_sdw_codec_info codec_info_list[] = {
 				.num_controls = ARRAY_SIZE(generic_spk_controls),
 				.widgets = generic_spk_widgets,
 				.num_widgets = ARRAY_SIZE(generic_spk_widgets),
+				.quirk = SOC_SDW_CODEC_SPKR,
+				.quirk_exclude = true,
 			},
 			{
 				.direction = {false, true},
-- 
2.43.0



