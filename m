Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB45B34F49F;
	Tue, 16 Dec 2025 11:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886153; cv=none; b=gTcnOsG/w3XZw3UhvkBefgaFigsyOc5YPyEOzbSJbG/Vo5HOAUzqL97/KEVubQorN9tteTxjpU+Ddz8Pdcw346e6pqZkIDexysnXfbEucDoNd10BO3bXqhZFx+xNqB/OSBcTU88bkICyivEbDs38qkIPO70fM8eUd+dB+ZFe9yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886153; c=relaxed/simple;
	bh=ctlcZ/DEGnhQ84XgBrMJX8AsaGhgFGwVla9zUAI01D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IY1YMnhV0EJEy1ZN2TB6ZMq2VwlN5LO2+yXWvw8ZtoeqxHWC4kUBmuWun/oPMaCnjMSfAgBXutD4jm9WStceZRVb7gu0j+SDYhZERn8cZSBAGR1Twm3yjHz6ja+QFQISZGhBZv6L7tv3Zl1ar8JQUneBzope+4HL3OERgNhb6xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adoqJ9hu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adoqJ9hu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCD7C4CEF1;
	Tue, 16 Dec 2025 11:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886152;
	bh=ctlcZ/DEGnhQ84XgBrMJX8AsaGhgFGwVla9zUAI01D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adoqJ9huisjbutLw9WTtHdXMwuNS1lORRODn3Vx5eW2vxwh3CZbpSyq0lrioSlaOy
	 591LY+L9eHkGVfdHLDsGQztDYrGOVj13L46Avt3XqSjnTHtUtBaTgGobhYu0/Nr/nl
	 V+uNuzIsHeSLD3xNp5EMGb9obIJtKmB4w+HgrAmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 321/507] ASoC: tas2781: correct the wrong period
Date: Tue, 16 Dec 2025 12:12:42 +0100
Message-ID: <20251216111357.096639630@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 9890b1a6d2924..e3a4d95b2b827 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -1340,7 +1340,7 @@ static int tasdevice_create_cali_ctrls(struct tasdevice_priv *priv)
 
 	/*
 	 * Alloc kcontrol via devm_kzalloc(), which don't manually
-	 * free the kcontrol。
+	 * free the kcontrol.
 	 */
 	cali_ctrls = devm_kcalloc(priv->dev, nctrls,
 		sizeof(cali_ctrls[0]), GFP_KERNEL);
-- 
2.51.0



