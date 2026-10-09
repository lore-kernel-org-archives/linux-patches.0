Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A9417A305;
	Fri,  9 Oct 2026 14:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555568; cv=none; b=VUS0prpi0bGOV8KxDOa2VxcOE9thzDdaEDU+HuLBWoybKGsUek+us7uO/YSlr86hCOrJeetccBYf+xXe8+dHnnz1hDSbIxu1spD7kT12FeMF+mFN5pQvgClzmwV2eELup7s76rGo9Xah/ivQ/j0ZOnq621dRRf4920UNjxzNStU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555568; c=relaxed/simple;
	bh=nNma+YqUh1ppu2l6QNdPgiEBo4LYPs8muZkVbX8vS+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuHE1E81XoK9SY4zujFu3sVHX+dAPdqPWgmv6z1zWR+HC9uob7w8LCeN4miC7ZLWz+8qFgI7h2TOi8n44J8xRdzEgF4XlDRtJ63iRlqw10gPm1qohuPHvIcxT9dfatOL3JITyr38PSogl4saQ+lLu8/FoQOmhP6DarOKg0a/VXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4US0SFK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4US0SFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302B71F000FF;
	Fri,  9 Oct 2026 14:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555565;
	bh=JtOs7v2TnbSe/mO4ieDoHZi5GGGoAxmh7YkBKPDvGk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n4US0SFK31dB7IoaHk6e7F/WO+rZjf+IH6id4zdNcx6oTsnHL2V9cFigiGtNMViO1
	 Uu3yxAW+7i7PyDhRN4pmYgbogy4p+aGiaPRxIp+YwB9wC8B+AD+RDKdOybqZva4DXn
	 AcfnXPQxSbKonRv2UTG/6TRGDWsA5d6tNUw3G/sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 080/403] ASoC: codecs: rt286: Revert delay value for jack setup
Date: Fri,  9 Oct 2026 16:07:21 +0200
Message-ID: <20261009140953.965418160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fd8de8b497936..7b70e0dd923d3 100644
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



