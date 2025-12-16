Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D0636C5BF;
	Tue, 16 Dec 2025 12:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887959; cv=none; b=Qfzo3a53GDkzdiw7gGU7362W8eUNMLwBS0J7ooWh2QxZwgEGCrRApooBjtwWksqjCCoziTKXYtuSnG01lFvn38jKEyn81fhKx2J8bEfQvSB1+BT/3+dwZBH+nV6hdrv0ifsThdPL/arunS6RMezdJ7IU1K7xkaL8OnZeuBWnLRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887959; c=relaxed/simple;
	bh=0QSPqEnwteLrTWuyJVBM4mEVEAVkjccNeo6kFPecHaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ncpfSu62ZjPmph4XkI/3+lBWdgr5PgJJbrIIga1tGuKb9iP/Dsm9IW3N7KcnQIP/QxWQpaY3Qx+blvzo3o7N0zQEkTnd9HQxySW64GTdZuXgqG7eW6C2AQItTVSa2PQoF5XMvT2QteKJ8VAsJTYfU/GUrF/PBTyGonpVf++WWjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imVxRqdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imVxRqdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA3DC4CEF1;
	Tue, 16 Dec 2025 12:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887959;
	bh=0QSPqEnwteLrTWuyJVBM4mEVEAVkjccNeo6kFPecHaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imVxRqdvSah4R808r9pqRMNS6pGYq32r4pgyy8rb9x0bgVS+4us8UzgOwfO6Siru1
	 qQzaT8T5lTyi5Z60na7BAykFLyvK48eA7gv6pFOCEinVXFNgt77fqo234n40T8nZUX
	 wQWAHp/VW/q3S304n8XKCDsdiWZjG73Cel/grtuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 382/614] ASoC: tas2781: correct the wrong period
Date: Tue, 16 Dec 2025 12:12:29 +0100
Message-ID: <20251216111415.201823300@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit 950167a99dfd27eeaf177092908c598a31c79a7e ]

A wrong preiod at the end of the sentence was reported by one of my
customers. Their thorough code review is greatly appreciated.

Fixes: 49e2e353fb0d ("ASoC: tas2781: Add Calibration Kcontrols for Chromebook")
Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20251121234427.402-1-shenghao-ding@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index 8f37aa00e62ee..a3b4d2c3b4789 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -1391,7 +1391,7 @@ static int tasdevice_create_cali_ctrls(struct tasdevice_priv *priv)
 
 	/*
 	 * Alloc kcontrol via devm_kzalloc(), which don't manually
-	 * free the kcontrol。
+	 * free the kcontrol.
 	 */
 	cali_ctrls = devm_kcalloc(priv->dev, nctrls,
 		sizeof(cali_ctrls[0]), GFP_KERNEL);
-- 
2.51.0



