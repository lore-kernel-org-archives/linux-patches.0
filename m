Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54683C2F;
	Wed, 21 Feb 2024 13:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522711; cv=none; b=ILcFUnVMRewWGCZCvP4bH+mI4lKFk5vcqga2FATRWBavAo+JaD+5HMEmJO3eYty8rCgAojAo2yfR0nSCxYmWAiFmNTk5CcLEkNG5BfwqmW5dRo8BKK09XwAl/2bfsL75kXr7N2Ua0aHFCsooW9a/d/lzNQf//aOFL+kKMH5eI0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522711; c=relaxed/simple;
	bh=wIGba8qDzWRJyy8L5xEUpMz0MiWTuhHIhoMDybxbDN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5CnYI6fLOD0HLgFPlDutjmB7VbeYTeMz+hW9Ub3mSEqeaj4p3GOoTaHIIzPg6u9TCz9TdYfPFkoWjCaQXVocG+nJw7WcTNuofFwjVjpfgaSmtQXD5UOP/5D4gm2PsKncR59bOsnTlawFI/Vg2YF8MYTnK9///DsH7O7hP44u/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vq/4zp+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vq/4zp+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B71C43394;
	Wed, 21 Feb 2024 13:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522710;
	bh=wIGba8qDzWRJyy8L5xEUpMz0MiWTuhHIhoMDybxbDN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vq/4zp+MFddQgTODClHqAzycRciCvZMOy5WRg2j7r4QRMjdwc9yS+xsvgNuiUoTNi
	 oSO4oRP80jXGcNeDbRGklFmstVBKLUZYLCmUXIHwhxeE68PVvebbSYY9vS9w7060oP
	 W+2qwnpYvQqUbwnK1ftr2wBnoajCLGYi+Id2flIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 210/476] ASoC: doc: Fix undefined SND_SOC_DAPM_NOPM argument
Date: Wed, 21 Feb 2024 14:04:21 +0100
Message-ID: <20240221130015.668231370@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



