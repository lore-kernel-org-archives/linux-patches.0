Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBB41A7264;
	Tue, 13 Oct 2026 12:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894823; cv=none; b=NbhvZnePN+diCpuERaBRLLj97CQFecVTcZ0NzP5eQI5j0plaGwzOtc7PXPX3NfX3fyrDBmtMfOzcPXRFQAeM+HFd336zRPK9FB+f06LUmlkKt4wIoANgG8ouAgGM+jXaCwH5ZXIMkISicR1KUiw2nuKO5IuEgOJmNw+KPOha0MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894823; c=relaxed/simple;
	bh=gedfAcddLxFoLDQrg0cgYoY7kFTBjTtVYeDCoyCk+Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2C3DGMWabBxjjFCl5JRfm9m7OJHlthWo4jaqC5NNSbvlDIr92fgfgsQWVVRtY0XsTd0lFSikwLUd5Tob46ifLvV0nsVnT3ENSG0clvl3F+uBr4PyTQPL+Us0rHaC+5mZnQ01/JElBjYJlshmTRycX09AJtNPU5WQ4hHJjdhWrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjasLzPy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjasLzPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EDA1F000FF;
	Tue, 13 Oct 2026 12:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894822;
	bh=m1KZ93GZi2umNtDSJcHTSjOQSc1G3LjwQCziG+hewAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KjasLzPycaeVsSXQI0gk4p3CfQGZkYAwjh9pop2MWQTsVyZgWfqtkkRLf4Zb/FlDD
	 HHWK7mtkPEW++oHsPl2T0GHqtE4TH0okjV/bVadhaoDEW+e4IbyHZuTOteg4uS5ZLo
	 rvP9KiEk2ct0QJJd5VMFl6hgumXiiDMyacV0Xa4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/497] ASoC: codecs: rt286: Revert delay value for jack setup
Date: Tue, 13 Oct 2026 13:33:54 +0200
Message-ID: <20261013112909.475940464@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit d30fba93ebfc11e4604a7fcc73fdf28684191dde ]

Fat fingered the change when reorganizing the jack-detect
initialization. Equivalent changes for rt274 and rt298:

Commit a43b4394bb35 ("ASoC: codecs: rt274: Always init jack_detect_work")
Commit 1eb73102da28 ("ASoC: codecs: rt298: Reorganize jack detect handling")

carry no update to the delay value.

>From user perspective, no difference has been observed between 1250 and
50 values on Intel's SkyLake, KabyLake and AmberLake configurations.

Fixes: 3082afe097cc ("ASoC: codecs: rt286: Reorganize jack detect handling")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260918111745.3589393-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt286.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt286.c b/sound/soc/codecs/rt286.c
index d0f533120c330..1af00b7f8415d 100644
--- a/sound/soc/codecs/rt286.c
+++ b/sound/soc/codecs/rt286.c
@@ -951,7 +951,7 @@ static int rt286_probe(struct snd_soc_component *component)
 
 	if (rt286->i2c->irq)
 		schedule_delayed_work(&rt286->jack_detect_work,
-				      msecs_to_jiffies(50));
+				      msecs_to_jiffies(1250));
 	return 0;
 }
 
-- 
2.53.0



