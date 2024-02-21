Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD6C2C9A;
	Wed, 21 Feb 2024 13:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521386; cv=none; b=L3E29cvqysBB9DqHI1yYa1ym3tI1tOb0gkd7dobEh6IryeintsAuzs+DgVUJ5RhUytJaHZTXCk7RAbThGW4qLNGmbv4/+VjYfatZwFd0NFj8lVHbiJ6n1V4UlD8h3OoP89TpSl0UF/vjxth0W+o07Jo+WZAafGmIYVw1A0O3+8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521386; c=relaxed/simple;
	bh=1uYpvLpIkaAZwvUZu3uRPCdbKMIsPtCmRmGapb6n96c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twcw262b/M/6ifJLoisEd6dY7DRhMkWwMulZJaQ08l04D91OwBlEs9kqi8CaSHSJnwQPnCOKYB4xHCJT1tev6rlW2CU+W0iTpEJ0lc8BbZxBhdoQHYiSqPhvyAA2SQkPBFRQtCJ2eduEljGj7m+9+gCeOr+b+nRXlqTmh0yNcHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vqg5Zenk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vqg5Zenk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B742C43390;
	Wed, 21 Feb 2024 13:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521385;
	bh=1uYpvLpIkaAZwvUZu3uRPCdbKMIsPtCmRmGapb6n96c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vqg5ZenkmWIOg9pifsf6q7sjwR2P3n/am7+Ffc76h9H9tA4Q6h8malGMiPzmqv8z6
	 Am7wvh+YD4u9GZqTJ5swspFK7xd1WEi/gJY4l8owRafAmc+CKbKDxVAEhA7owRJ8oe
	 LXCO//UDO7Pnz2lnZ4KeKyPj+waCpzqLbdJJk3B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/202] ASoC: doc: Fix undefined SND_SOC_DAPM_NOPM argument
Date: Wed, 21 Feb 2024 14:06:38 +0100
Message-ID: <20240221125934.915346942@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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



