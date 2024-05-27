Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB92168C4;
	Mon, 27 May 2024 19:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837600; cv=none; b=d+BBpmVZswmuafpEGiJBYdGJaXRH4x1zhJeU9icbqyvVWgtZGc8FuFbeXl1UiVvZr5mY6gCi2y+KV00cV1I3oz7344OrEK/tWO1q6bQljSJGrISxip6FMl+ZvPIrUMKC4YgIwVgDzv9kcObcoX+1Sr3oWroItkXNvmoxXTJ/saU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837600; c=relaxed/simple;
	bh=RpoFn2Qz5SG4BTHO4M6wrKtM81zJKkaV0WTUC6t7eoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCJo+qiz5ria6VuY5tC8Wv8w+D4S5NqyXU0vofVMQlHkUdN2zniUxiPGGJDnZENGhkAU3na92ubb0oakehzPHYK7Riy/MeaXARCPPLxcdWPlAe/2TSvzsmU77UsdokKQlifw6IY9+HGQsfzfhvzRAromGMnmPLv7kCRsfZYjv64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K29o3GVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K29o3GVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90D6C2BBFC;
	Mon, 27 May 2024 19:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837600;
	bh=RpoFn2Qz5SG4BTHO4M6wrKtM81zJKkaV0WTUC6t7eoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K29o3GVqlAhf3ujhFeeKj8PqycabFtZcB+jA7T77FJ59lUue+oEQ/JLl1Q3l8PEy4
	 /7mQq73JDj7/ErdsHF9QKlVvcwY2QmYTjumpSTej6wB2PfThgry2DmzLrR/iBfi3rO
	 s16uALn51nzUN36AVCMXeYu48zDS2X0CbIhpE63o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 072/493] ASoC: rt722-sdca: modify channel number to support 4 channels
Date: Mon, 27 May 2024 20:51:14 +0200
Message-ID: <20240527185632.226280553@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit cb9946971d7cb717b726710e1a9fa4ded00b9135 ]

Channel numbers of dmic supports 4 channels, modify channels_max
regarding to this issue.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://msgid.link/r/6a9b1d1fb2ea4f04b2157799f04053b1@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt722-sdca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt722-sdca.c b/sound/soc/codecs/rt722-sdca.c
index 0e1c65a20392a..4338cdb3a7917 100644
--- a/sound/soc/codecs/rt722-sdca.c
+++ b/sound/soc/codecs/rt722-sdca.c
@@ -1329,7 +1329,7 @@ static struct snd_soc_dai_driver rt722_sdca_dai[] = {
 		.capture = {
 			.stream_name = "DP6 DMic Capture",
 			.channels_min = 1,
-			.channels_max = 2,
+			.channels_max = 4,
 			.rates = RT722_STEREO_RATES,
 			.formats = RT722_FORMATS,
 		},
-- 
2.43.0



