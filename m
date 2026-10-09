Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C4445C713;
	Fri,  9 Oct 2026 14:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555918; cv=none; b=TX2dSAMg54qstOYk+3UcmPaBW3OHfQwrAzJtrlC4JAbCC+dyWJCLQWH9e3n6hVtp1FmMFpeqfrYcZikGGPMtct2eZtB51JnAwy2d1MwJJ+v+tU51LzwJnRztnCksv2dnHT0mzT6TKRy780gByv/8G0LQJD1CitnobDwfgTaywDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555918; c=relaxed/simple;
	bh=sWapO0dGiqCyaCfXmPqHZHf+HXMYNDVv9pZBvMgivBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErWkpNysRWBMN4zz41Gz7OG5BN3Jc9COeuj72lecu1QhakyHYcSJC8ufebQncGFgk29bFxmDKOo2WhuvM0JCVq50SSEHwllS2gM1FkLV/L2r9SMZiENcx4FQtDXXCMO/BtE4+L//WLXYkjRgzm74aZFXNYippoaFODqUV1k2aig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Xvje7s6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Xvje7s6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF471F00898;
	Fri,  9 Oct 2026 14:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555917;
	bh=zwzNZ9+3APrc4xA0LluOkxWo5pmxxdqxKgyP+G2v7+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Xvje7s6U7Zu082Cp0453gtr2TfsCsCoR/mdK689VThMAqyTUM9TEse0DAqOKZRth
	 wtYe8P1wUgv8UihQgyzFeDP7ZgIQAItUqs/mgCyJwzExJ+gOb5ZEJQDB8Gg7WGqYtJ
	 2H0J878YJe0oYjh2/xB8H7DGzsvTcljPCt4//mIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 090/428] ASoC: codecs: rt286: Revert delay value for jack setup
Date: Fri,  9 Oct 2026 16:07:07 +0200
Message-ID: <20261009140948.177042735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 4217467904d6f..bcd9f5abcda8a 100644
--- a/sound/soc/codecs/rt286.c
+++ b/sound/soc/codecs/rt286.c
@@ -953,7 +953,7 @@ static int rt286_probe(struct snd_soc_component *component)
 
 	if (rt286->i2c->irq)
 		schedule_delayed_work(&rt286->jack_detect_work,
-				      msecs_to_jiffies(50));
+				      msecs_to_jiffies(1250));
 	return 0;
 }
 
-- 
2.53.0



