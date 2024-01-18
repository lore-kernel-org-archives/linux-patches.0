Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039CE22F0F;
	Thu, 18 Jan 2024 10:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575558; cv=none; b=ZCV8KeJVBEG3m5jNRDp7Csln8VycXadZj1VvYlaaXzwOa5UW13BF4jWHKoRmjUVc5Bc5yIZrox7qeJCDxByPkTbxZJ1booxVljFYyMAsPTic7itwd1LPk+lOuvp2x1vGDgDV1TcBi9FJ4vD6C8YJ+JbgN/OoWv4qo7AYj7Q+bOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575558; c=relaxed/simple;
	bh=5eLFiS8RAMhIPvJNZC1nLc/D8AY399UcX2QhRO9GrsE=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=lEiH3OuU+8CNhtXgB2JJjGZxET/Jou+GqphSJx2fyKDuS0fs95p4NhQ2iBd4M/CiHoxbwCfBqToWEFmU0+ckwRmBkO7vgS+40HOL1+3k6lqhTap2I9ubmi1YRLlGho6QQBG2uXSv5HRQlJqcHUTaqjFeRGLnKuO1gEWEEq9Ggwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpBKR2pF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpBKR2pF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE5AC433F1;
	Thu, 18 Jan 2024 10:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575557;
	bh=5eLFiS8RAMhIPvJNZC1nLc/D8AY399UcX2QhRO9GrsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpBKR2pFrFQO7BP6Hdyy+tLZFc8/nk3RSYRVZed449UCRZmRFxnS6js9MAg/ey8Qg
	 5YqLJuS+wQmxkLJVBR7e+Qxs/yUG83zpXt5erOfis2YxZMJ3OljFGXfXbxfZhAYnnz
	 8VyiGBIYhhJrFa5mkFr09tRzlR5qte/yzfUzPZ2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/100] ASoC: cs43130: Fix incorrect frame delay configuration
Date: Thu, 18 Jan 2024 11:48:32 +0100
Message-ID: <20240118104311.960788006@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1fcbf2ffccff..0b8ecd917a08 100644
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



