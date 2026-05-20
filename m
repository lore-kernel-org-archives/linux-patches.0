Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019EC346E5E;
	Wed, 20 May 2026 17:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298090; cv=none; b=DMd2vVRBT5Z5Dzfuu6qzrc/m2wpUXj/Oq0SDcuU8n/X+UhakhIb6/kb1MKhRqxN1mHSHu0cT59jF97OI+Gqy1xbGzAM+mezpWbWZ910ApR+fU2OcQQex/epSgNP/q7ef4C70P6BBwiJRCIOSFkSNUWv7U9TPaBezJiiiX5QKIrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298090; c=relaxed/simple;
	bh=iYCxWrn+/fFcHa11gvqQd9g8MvZEmu/NixCRTzV88QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRHFXbqkExx++Ze4b/TBklLSLATnn2sb1WnIypa/DgfUmnZhjBwZPxlRoled6pOd+erdm74nHfKiFilv1TDHnhpsP4BXhL26qn5x6A6a+WwkW0SdYflPDHZzFmzoEqJioIuoglp+lSYUmVcLle/CpNB4m+8ZvV/iPYZd5eK5p4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzQO//xQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzQO//xQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686541F00896;
	Wed, 20 May 2026 17:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298088;
	bh=3SnVf2IwYLGdxtKq3oH7eFSJVuNL/vCjDGQ77ynsHqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HzQO//xQvkprnG3UOx9c1qTxnaDwZFGz2HtM5kOPciKafdNwZomv5X8cgVUKBm0yA
	 eoMNrlAtAyo026YHvPEo8hO73CJzXi8gUF1eTcpdMmsD/n4pTM1JD0t55pgclIi7fw
	 kFUSr07l8eVYjogUqUsHVnvYnVDjEqduTJZxNmTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 279/957] ALSA: hda/cmedia: Remove duplicate pin configuration parsing
Date: Wed, 20 May 2026 18:12:42 +0200
Message-ID: <20260520162140.591205193@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 579e7b820de5dd5124585413bb5e9c278d255436 ]

The cmedia_probe() function calls snd_hda_parse_pin_defcfg() and
snd_hda_gen_parse_auto_config() twice unnecessarily. Remove The
duplicate code.

Fixes: 0f1e8306dcbe ("ALSA: hda/cmedia: Rewrite to new probe method")
Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260401082625.157868-1-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/cmedia.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/sound/hda/codecs/cmedia.c b/sound/hda/codecs/cmedia.c
index 15e5a1118a6e8..a156bea7ca446 100644
--- a/sound/hda/codecs/cmedia.c
+++ b/sound/hda/codecs/cmedia.c
@@ -39,13 +39,6 @@ static int cmedia_probe(struct hda_codec *codec, const struct hda_device_id *id)
 		spec->out_vol_mask = (1ULL << 0x10);
 	}
 
-	err = snd_hda_parse_pin_defcfg(codec, cfg, NULL, 0);
-	if (err < 0)
-		goto error;
-	err = snd_hda_gen_parse_auto_config(codec, cfg);
-	if (err < 0)
-		goto error;
-
 	err = snd_hda_parse_pin_defcfg(codec, cfg, NULL, 0);
 	if (err < 0)
 		goto error;
-- 
2.53.0



