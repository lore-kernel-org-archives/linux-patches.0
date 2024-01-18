Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D641B96D;
	Thu, 18 Jan 2024 10:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575249; cv=none; b=YlCoaGIMU4CG+BkNAI1Fj0Ad39MwvpvoPY8ycU1ax68PFsFhLfcGYDV9m36cXSZgDGvMba9jT66y7pl6zogIrUrfPTqJUn3sBmGS+Cu6FSoBsw984DhHg6yC0pw0smk9KjpoWPzAfaBFxXrpjPxv5bhRBzXRR4NxmMaaEi0/ANU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575249; c=relaxed/simple;
	bh=1zh3SZYlx+bSgqZE5f2MXv6uiRkN0+Chy18aOV2r8U8=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=nRSFWMuNfDW3896FnfylK/igj7U/sJJ5pI8mJQSFLzPWEWijZ1TBBHktcbv6IX4KHZAFuDLtjTjZM/d3kWzcASSTIdYm4mI64TODrFKLIOYt+xxE8Ea8FSToM2CW2xg6HwUDYd4//w/ghO4ctQLps2VzWTqKXB8Oaq3yKyVFqTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRsWYE2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRsWYE2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C896C433F1;
	Thu, 18 Jan 2024 10:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575248;
	bh=1zh3SZYlx+bSgqZE5f2MXv6uiRkN0+Chy18aOV2r8U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRsWYE2ZMdyOqwC3Lw9KRRwgV+F44enOaT6g5LUHSXN7HA9qJeSRXcj26tMtXjxou
	 aX5AHM35ufAceo/QR/p7jdBU5pDuUPTvowmN4j99tygN8/VzLN7EzHGZ/pkpt1yUro
	 +iuSopnyzn5+lZzihZEXdNJCQZ0RimqV/amnXiyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/150] ASoC: cs43130: Fix incorrect frame delay configuration
Date: Thu, 18 Jan 2024 11:47:38 +0100
Message-ID: <20240118104321.771141367@linuxfoundation.org>
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

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit aa7e8e5e4011571022dc06e4d7a2f108feb53d1a ]

Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20231117141344.64320-3-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs43130.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs43130.c b/sound/soc/codecs/cs43130.c
index 778a62e57d45..206008bdecac 100644
--- a/sound/soc/codecs/cs43130.c
+++ b/sound/soc/codecs/cs43130.c
@@ -579,7 +579,7 @@ static int cs43130_set_sp_fmt(int dai_id, unsigned int bitwidth_sclk,
 		break;
 	case SND_SOC_DAIFMT_LEFT_J:
 		hi_size = bitwidth_sclk;
-		frm_delay = 2;
+		frm_delay = 0;
 		frm_phase = 1;
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
-- 
2.43.0



