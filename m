Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB49329A0;
	Wed,  7 May 2025 19:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644527; cv=none; b=Q1CpZQu8a94J5y9Ecj8QeeaEL239lNPSuCuvXxSzxBhRk7IxuYai9TNQiH+2UmSB1YlIpv93NsZEXt2TdP1+H4ZJVInyWilUWW8Ohm2SIthS6dX2x3l77+YUBcllHN9TUuTAPt5HMW+h/UwF2Nb1a96ljDFx/rQaeusPYGvA+qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644527; c=relaxed/simple;
	bh=A8tySBSIWSgCa42SuslNbqp9njFXEtAoX6XLaaS2bEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJQM6f6lJZro/tbDhlxfRIrkib7lY6+MQF5rSWcvNj7r1Ubkg6St0sxAd5iZdx78W/EpUaSMuFQKUffHK3tD0vxVEdK9mFPmJ8LmOma8HPaFPB7Xq3wzBk385yT3bUHdlLA73KPPaq7XEOW9eu07rimXFRjdfl0U4XQVeKIY2zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbnhfQKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbnhfQKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FA3C4CEE2;
	Wed,  7 May 2025 19:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644527;
	bh=A8tySBSIWSgCa42SuslNbqp9njFXEtAoX6XLaaS2bEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbnhfQKPKoBGJiLcfwG9+37N8CR3LaZRB5r7iXXzibXtpv49nPPg0y8LOtDh8+osZ
	 gfZ11gC/mg2Rm8MyAV4tPTVppDpwvVPM+ADv8TYsSadY3jLQft4FNx/6Wj/V6fRNCC
	 lQJTZINluMxSF1lYtzhkDrVgScr15CgiDza3hW0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/164] ASoC: amd: acp: Fix NULL pointer deref in acp_i2s_set_tdm_slot
Date: Wed,  7 May 2025 20:39:18 +0200
Message-ID: <20250507183823.921241159@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit 6d9b64156d849e358cb49b6b899fb0b7d262bda8 ]

Update chip data using dev_get_drvdata(dev->parent) to fix
NULL pointer deref in acp_i2s_set_tdm_slot.

Fixes: cd60dec8994c ("ASoC: amd: acp: Refactor TDM slots selction based on acp revision id")

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Link: https://patch.msgid.link/20250425060144.1773265-2-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp-i2s.c b/sound/soc/amd/acp/acp-i2s.c
index 92c5ff0deea2c..607a3eaeb6da8 100644
--- a/sound/soc/amd/acp/acp-i2s.c
+++ b/sound/soc/amd/acp/acp-i2s.c
@@ -101,7 +101,7 @@ static int acp_i2s_set_tdm_slot(struct snd_soc_dai *dai, u32 tx_mask, u32 rx_mas
 	struct acp_stream *stream;
 	int slot_len, no_of_slots;
 
-	chip = dev_get_platdata(dev);
+	chip = dev_get_drvdata(dev->parent);
 	switch (slot_width) {
 	case SLOT_WIDTH_8:
 		slot_len = 8;
-- 
2.39.5



