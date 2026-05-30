Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0205A331A56;
	Sat, 30 May 2026 18:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166358; cv=none; b=nk69YzdrlUM5MqlzDdfaIdUGSSGHtYU33+4aAgXshzcE6HAHfRl+cOYVonKPBOkT1nTijgkLz6web9bvVaATJYWNWYCbC8Ep/e3kmEpOHd0UD1o05CCuMIdEk2v1yDNtwZrByxsWecFSvj1WUrbecHyDJPXlQzuBZQRI28y0ZAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166358; c=relaxed/simple;
	bh=V9m4a91asqtLqniby5H9pJDsRCY/yFCcZ/08BfnbXGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKzphCZXWnmBHiMW/gKg+YGxrd5/RGZRccHVvbWgnT1wbGW3pmHDAj1A+LeXfBzKSJBQv9R5eHKZwxEJRAI9UCM+sv+6w0l6qr4oZIO4iKG7TkrvMH4YaJ3RA1bFr86Hn/uHTzDiDs5wdDPdIYsfM6pdz9mXqWRZvuC0ncpfrlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZKbpiLf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZKbpiLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458D21F00893;
	Sat, 30 May 2026 18:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166357;
	bh=RZzLqBcVPbpbhaGaf45ZW4Zu7JCeXVga94cCX7WX+nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZKbpiLfabyfWzsxgmXR8hS4Whpjgxj6Gtuo3S4zmYXCmSDbIhOoJaBMJO4vkVYNa
	 05I6dtFsZJbU0noa4W5xVO2otbqYwA/6zqoCrEewMFvD4sp+ZUDg2Pm0ZviEp/JsHH
	 4a6ikaAbWDGbSYx9crEFuE62I4zpYQm/f3tc+1EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 348/589] ASoC: fsl_easrc: Fix value type in fsl_easrc_iec958_get_bits()
Date: Sat, 30 May 2026 18:03:49 +0200
Message-ID: <20260530160234.019265907@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit aa21fe4a81458cf469c2615b08cbde5997dde25a ]

The value type of controls "Context 0 IEC958 Bits Per Sample" should be
integer, not enumerated, the issue is found by the mixer-test.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-11-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_easrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index a267ca941d943..0670ab194e4ec 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -73,7 +73,7 @@ static int fsl_easrc_iec958_get_bits(struct snd_kcontrol *kcontrol,
 	struct soc_mreg_control *mc =
 		(struct soc_mreg_control *)kcontrol->private_value;
 
-	ucontrol->value.enumerated.item[0] = easrc_priv->bps_iec958[mc->regbase];
+	ucontrol->value.integer.value[0] = easrc_priv->bps_iec958[mc->regbase];
 
 	return 0;
 }
-- 
2.53.0



