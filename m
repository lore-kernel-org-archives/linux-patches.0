Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0382BE7B2;
	Tue, 16 Dec 2025 11:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884615; cv=none; b=G8MnRvUqlSdWdPMsAqmLsp450J1JXiDpVXIzd6ZJxS1EQJs389YPuGJqIIr2AbmdhLjTIBgBriJ4sfuKzux+kw0ro762cPGwPlbZIEZeJcAq1MLst7IooSxeUzcIZqlaQ9N3dz1OGzAUPd7rAE3l3Ea/HEE+t8rn/eXDnVQPCGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884615; c=relaxed/simple;
	bh=P1jytPO3CrdUXnDEbzydeO0rQ709vAkL5R9/ENqOnOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kZsGaNH0ESMM0pVn214k3vN8uGxwZtjaKqBI/yjcYysRBeN8nRidZjXzLkOenoeAIdsM9fZr2+UPYqlkQVD4OfMBV53n423vlsbCQw+NzoaxrgW4f0bHfjgM7Sw1u7MLHOQQduFEsTcfut76qQsaWkY3QPyL8Sd3Wi6/6XkMOYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1PZCMOiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1PZCMOiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04449C4CEF1;
	Tue, 16 Dec 2025 11:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884615;
	bh=P1jytPO3CrdUXnDEbzydeO0rQ709vAkL5R9/ENqOnOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1PZCMOiMtL+7aItOLo01mNT9AFyfULk1fB01fEZEvVb44ubZAsyUSjqiuCmtFCVWo
	 pPgUCTLMfC3rLjtRByKln+5eHSEZrKLMAn1jL39x1PRktTYaLqiGJj5eEcQrinWvbN
	 yt6AXvfTNQgCY/PwpLPKHB8vhTt5kKugr+9uZjJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 215/354] ASoC: tas2781: correct the wrong period
Date: Tue, 16 Dec 2025 12:13:02 +0100
Message-ID: <20251216111328.708528037@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2f100cbfdc41f..282907b035064 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -1258,7 +1258,7 @@ static int tasdevice_create_cali_ctrls(struct tasdevice_priv *priv)
 
 	/*
 	 * Alloc kcontrol via devm_kzalloc(), which don't manually
-	 * free the kcontrol。
+	 * free the kcontrol.
 	 */
 	cali_ctrls = devm_kcalloc(priv->dev, nctrls,
 		sizeof(cali_ctrls[0]), GFP_KERNEL);
-- 
2.51.0



