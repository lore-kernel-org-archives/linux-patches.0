Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C9F14B080;
	Mon, 24 Feb 2025 14:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408091; cv=none; b=cDYZ+z9HevrB/UnBwNhMZzdFHEyDFj0ugIkpDBxR7lvKGowgATd7AH33rPf8v/vKD2yYKQkO3dKFLw+hZv7DbbrbpYPOm75y/XeldXz+NEqbxdknEQSuLlbrtPY1QtWbhZZhB61omEDwJ1lj+X/tsac6SKb0xgezJnowrJIuAAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408091; c=relaxed/simple;
	bh=K+wdi/eWkmyawmqqf7EdqWmfUHtFrqzb30kb9WAwjao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vna3op4Mq/Z+1hOpfvsUZYcB00mbSHSqX12aBkmc7r8cmthjovb5R5uBP76zMgLQnzWQrUJFxTHg9mDKfr/DLZ6WcC29B2Bw2ELs6bgORIkFDbSY4CGVWv+UYVI2uysN70mD78eeAPVQl9r5QQNDrMmiogz8fmPyJd9cxGcl2yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJxBzku1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJxBzku1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F71C4CED6;
	Mon, 24 Feb 2025 14:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408090;
	bh=K+wdi/eWkmyawmqqf7EdqWmfUHtFrqzb30kb9WAwjao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJxBzku1Ejr38p7BX9gUxfS0cAodi6xxUcZz48qabKUJwVRa5O7pGbOumh8wwI7he
	 5FBj3CQCR9qYbgcDY/Re0aGvQOTgs0cVb87coUdUus+bEPc/Wwlm0J6w65ao8ootz6
	 bxofVooZaqeVJnGjFUVnOBOtpVxeB5yyyKQvbG/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/140] ASoC: rockchip: i2s-tdm: fix shift config for SND_SOC_DAIFMT_DSP_[AB]
Date: Mon, 24 Feb 2025 15:34:24 +0100
Message-ID: <20250224142605.567636860@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 14e5c53e697b0..7ae93cbaea9a7 100644
--- a/sound/soc/rockchip/rockchip_i2s_tdm.c
+++ b/sound/soc/rockchip/rockchip_i2s_tdm.c
@@ -453,11 +453,11 @@ static int rockchip_i2s_tdm_set_fmt(struct snd_soc_dai *cpu_dai,
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



