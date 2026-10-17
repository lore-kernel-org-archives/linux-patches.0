Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282284CF49B;
	Sat, 17 Oct 2026 16:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256341; cv=none; b=NYHNSvfycIcJwPt//MdXsLYCa48UAm6qQUWj7cgZMp/gl5PV6OrjBamIax1yIcHc59M16Jz7d9C7lbHELwAa+FTEBYB/vRr7u1jXq6/stGR6Y1NPkBF7SVRAEPbcqFcWK9wwiBzgJXXGt85veH55+mFrpV933Fh3WRoKECsFOMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256341; c=relaxed/simple;
	bh=x8ihtg++ly7FmL2fh2TR/I4S8jWB6C+vgTxtDlbADEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzjQBmn3rcC2pAaP7YSvfYP9Yil5AOJLiqG4l09tKpsn6JOrpQ7fWY7SxgBaTY25mQDDa3Jveks0l4NENtJDH9RjxKWqkOlbycM4yzG1v8lg8vIVqoV3nEkv27VkXr1kG2NJfT930qwkmBP92wPdJeZF9DIhb6HZ9CZTSgcNxhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrLmGpc7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrLmGpc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F101F000C4;
	Sat, 17 Oct 2026 16:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256340;
	bh=XUZAVyNsWQCzfByqBhMGAkyHn3fl1tWYP1EMJ+ui4JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YrLmGpc7pz/2DGMhKW5cHEUxGVs8LJWfqS/i73fLP0SFgHz0QUXv+iMQJ4UgUXIRT
	 aaPIUHsqELXl26QyoiSnIMpKOM5hbvIYKxweKlAssXjFhxYJv4mRiQJ+IKGSg3r65M
	 WZijM+JnF6D2jDaylMyPDeBRcCF+s1N1jBUO1sI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0202/1674] ASoC: codecs: rt286: Revert delay value for jack setup
Date: Sat, 17 Oct 2026 17:41:14 +0200
Message-ID: <20261017160436.336629322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 981155b046fd8..ec3d450736dad 100644
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



