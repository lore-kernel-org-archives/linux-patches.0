Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740B7FC11;
	Sat,  3 Feb 2024 04:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933391; cv=none; b=mJYtJvT9FMb8dU+ED0dWkXU36N3A8GQo3bzSIWgh8OMz/pcZhAkjVKJlJw9FPfXaH14yeVsG/qc44JSaYC6hX1w2A5vLJ7JfQUh2oaLKPIKZrNKOdeWNC0zp1d5JHIjlz8/3N7MvxMSeG9Fc5SvnGTdhoz4njHH6jD++ncyMyJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933391; c=relaxed/simple;
	bh=5HC0LYDBXicUPt3Cg3lRNw5eowKFLksu80DnfJMVQSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaSMXobklg1+MaFoNPRBxv/LQlCo+9rsSPG1fB656DLCsMyJmAIS3tRLOz3xnCsRQ5amaW6W814N+NIcjP/2VjxFLohzH59IeTGXCOF0eoAb3/SQ6TQl+S3cD8MhNqfVT3YqvQGZkz/nfyZ4n05SkmxzoOijjx+PS9/887NGwy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjLNWZHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjLNWZHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE32C43390;
	Sat,  3 Feb 2024 04:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933391;
	bh=5HC0LYDBXicUPt3Cg3lRNw5eowKFLksu80DnfJMVQSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjLNWZHj/GE6Z6d/u/ijrwr/jqTV1zwPWjfnuuW0TM1hVlYdEdGz72CBYDTA/dusM
	 qM0IYHKnJu5guU0tBPmuMg9dIVViGyJzi+2nX8hmezMOupEoTb/YuZo+8/ch3T7CFD
	 vFhdDLrOfQO1kd4ruWL1wttjuOqz1m+APJcT0s7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/219] ASoC: doc: Fix undefined SND_SOC_DAPM_NOPM argument
Date: Fri,  2 Feb 2024 20:04:39 -0800
Message-ID: <20240203035332.328704798@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



