Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4032E62C;
	Mon,  8 Apr 2024 13:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581518; cv=none; b=GYkeaZvAuz+WDdSvCX5sWnf7aoa6N4XqU4qDI9rI5LBRRM3kpBDHgqBp5Q/VDz/NAaIeYrqLhtb2BfPnp3lMZE+64P6bpYFTtCI5F5TTSG8MMxif8rI3KIJT/YI+FgQkxOZU7JquWeAIlZsA6KfUhv4v5VdJZrwICDD/jvR32hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581518; c=relaxed/simple;
	bh=WuCuWYeUJVcipiRFKSjSgwQRdbHBcFywO7TU/yp63zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZJwPfqeYhC+Jp9/z+buMHkO6Gf38JfGOkLXkrc9o7FrgM5m5gCbOl7mbZrqY4d5ag7XKMy6TWyG/OZimsjq+HGWKuy0Rg7eT4dhKfs2roKcIX1tztToGkbPVyhMcZEDvNnYFpltUeIIzFmJP4Okvw0L2fmtF3Xq3x3rtvc82M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hg+Vpuqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hg+Vpuqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1111CC433C7;
	Mon,  8 Apr 2024 13:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581518;
	bh=WuCuWYeUJVcipiRFKSjSgwQRdbHBcFywO7TU/yp63zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hg+Vpuqnx+0pL0jHNvfGmKs+pVu0xFj3GhZRlrYkBkbq0jrs+4c1sRKGmxJiuy6S7
	 R0yWEmMoeUgTojPWSvNZ2HCPiUEQgsaEti2PH3wphJxjsRMqfUiWyvtsX4DMsw7R4g
	 hddQ/vVEU0k1OIET4Cq6zEV0ECIgvRf7wHlY0vTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/252] ALSA: hda: cs35l56: Set the init_done flag before component_add()
Date: Mon,  8 Apr 2024 14:55:13 +0200
Message-ID: <20240408125307.091495341@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit cafe9c6a72cf1ffe96d2561d988a141cb5c093db ]

Initialization is completed before adding the component as that can
start the process of the device binding and trigger actions that check
init_done.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 73cfbfa9caea ("ALSA: hda/cs35l56: Add driver for Cirrus Logic CS35L56 amplifier")
Message-ID: <20240325145510.328378-1-rf@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l56_hda.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 7adc1d373d65c..27848d6469636 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -978,14 +978,14 @@ int cs35l56_hda_common_probe(struct cs35l56_hda *cs35l56, int id)
 	pm_runtime_mark_last_busy(cs35l56->base.dev);
 	pm_runtime_enable(cs35l56->base.dev);
 
+	cs35l56->base.init_done = true;
+
 	ret = component_add(cs35l56->base.dev, &cs35l56_hda_comp_ops);
 	if (ret) {
 		dev_err(cs35l56->base.dev, "Register component failed: %d\n", ret);
 		goto pm_err;
 	}
 
-	cs35l56->base.init_done = true;
-
 	return 0;
 
 pm_err:
-- 
2.43.0



