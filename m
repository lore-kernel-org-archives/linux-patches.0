Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C003812A15E;
	Tue, 23 Jan 2024 00:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968755; cv=none; b=ZzYH7/pKPRdzknaubgU1ZY7ffh32YZ00HOzEXhJPo5RGYbtvO9J3mD1gKVrAveO7ERiJxLREtLaprMI67AIy+WPpxeXWPSPwJH8ShsyG2QM2wehJsCdSn7cd916I1u/Y/CCGps/eBpDtMkJ08bm9oJf+ULZLUs2qKcV9NI4WfQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968755; c=relaxed/simple;
	bh=tnSQWMH4zu68WHrQ/iSWdaoahTU9vIJrzZRxzFUJCNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOjmtANEHHRF075jOzTh1Xwmlr0INYA/at6P0VIXRLFbIlA3N2GcwfSaakpeQ7QaDCuHeYU/fp8kKPfY+0o6+284CwF8sfo+vNMCCB1c+DdXwKhSmn1jAUZSLjByWiX8iogs6qdkM2St+3BFER+P3uJQ5/XFegExcMFavhASXR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQLgFkxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQLgFkxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3C6C433F1;
	Tue, 23 Jan 2024 00:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968755;
	bh=tnSQWMH4zu68WHrQ/iSWdaoahTU9vIJrzZRxzFUJCNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQLgFkxn0CKFqcGCxg2s6KOHmkiwVspZIQsU3zYBHGvFQShs9RLWbz2TLZSmC2SGI
	 R6kZYBWB4lnzLOcgFq1mXZxRvCI70enyaxbUivtBzcr76u+9W5CiA2OC+kke4Boqv3
	 YlvhdBGlxODfNvbJ71nn8RvCp6EC09P+rpkTIW58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/194] ASoC: cs43130: Fix incorrect frame delay configuration
Date: Mon, 22 Jan 2024 15:55:38 -0800
Message-ID: <20240122235719.559183285@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 285806868c40..02fb9317b697 100644
--- a/sound/soc/codecs/cs43130.c
+++ b/sound/soc/codecs/cs43130.c
@@ -578,7 +578,7 @@ static int cs43130_set_sp_fmt(int dai_id, unsigned int bitwidth_sclk,
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



