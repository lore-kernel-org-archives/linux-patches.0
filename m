Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA7869317;
	Wed, 21 Feb 2024 14:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525328; cv=none; b=GP6FMI+J0KMN58pjXsxxP2HLebs3kszkwWqBFFk+sAWcxKJ68hCKNt+Z2sAQ9xpv4C2Y3nWalm4Agt0D3cVv2X0gXDP4lqQFigjA/hkozEVQpF7OYLKNg2zPOqCGVpeM128ql9sSYuyHP3WzLijkk2g6aXpqxhTpi/2SL89Dq10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525328; c=relaxed/simple;
	bh=DG4zZblVqzsc2cvASXicnxVxH8w8l9+o/1VtznPYsr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIBaIbdkHU+O2aHn4qzVxs2dFQzZaZZBmw5eH3g/KZZ+wJx646aBo8glA8vs2NmRXa/oFof+Z0AJsR8B4JZh/3ZTzd5V6Xi0Y5ocbKR97mxg+YByrxoWwrJ7vSUsSV4t8NFJ7A63/CSGnoVKUwjU2opcoNMTu8SLvl3HHhfiAqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FphldLnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FphldLnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9632C433C7;
	Wed, 21 Feb 2024 14:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525328;
	bh=DG4zZblVqzsc2cvASXicnxVxH8w8l9+o/1VtznPYsr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FphldLnckhBDIONLxNKdFOohVFvScQ7AuXLhMDJbZu7+8g8wACCb2MJ3mUY2eFAnB
	 wiFTev3NidA8f4JI113BaD1J218eyZKDPhkVEbBH15jEUG7QWqpbfM9ln93OlKgxEU
	 vnSN1h7Bb9BysHNn5qWuVFhtHhppOQymE5XhNM/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/267] ASoC: doc: Fix undefined SND_SOC_DAPM_NOPM argument
Date: Wed, 21 Feb 2024 14:07:42 +0100
Message-ID: <20240221125943.786450785@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 67c7666fe808c3a7af3cc6f9d0a3dd3acfd26115 ]

The virtual widget example makes use of an undefined SND_SOC_DAPM_NOPM
argument passed to SND_SOC_DAPM_MIXER().  Replace with the correct
SND_SOC_NOPM definition.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20231121120751.77355-1-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/sound/soc/dapm.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/sound/soc/dapm.rst b/Documentation/sound/soc/dapm.rst
index 8e44107933ab..c3154ce6e1b2 100644
--- a/Documentation/sound/soc/dapm.rst
+++ b/Documentation/sound/soc/dapm.rst
@@ -234,7 +234,7 @@ corresponding soft power control. In this case it is necessary to create
 a virtual widget - a widget with no control bits e.g.
 ::
 
-  SND_SOC_DAPM_MIXER("AC97 Mixer", SND_SOC_DAPM_NOPM, 0, 0, NULL, 0),
+  SND_SOC_DAPM_MIXER("AC97 Mixer", SND_SOC_NOPM, 0, 0, NULL, 0),
 
 This can be used to merge to signal paths together in software.
 
-- 
2.43.0



