Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212643;
	b=FL9sjO+HSjez01EHU/RJ49WCsYM0AcOUo+qfGijbFm3Xz9e3d2rPChPMZnKAJ8tQsZ51
	 rgIhjyRtyXlUf3Bc9elt4VnPPltXmTf51my4AJYV/mzb/lcfod1YEwOBnOmgBEfCO9ENE
	 nEifWlaxNTlWIry759sQlolU6VHTeosxBW7rVqzuv56sdXMttKEFNQYUhnokj7V47T0Bw
	 lSfLZ7RRv6STE3mj6fG68TsSCsMyE6YPg9VuM00XCmn2xVnZk5YjNhCpZkpMA6QjHm/g6
	 JcWxReWM6s8fdyVsaanIlMHG5h44pjPisc415YgWDeWshVRjjrDL9p6dZVdkM6kXuKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KrkUZ9Yb7/7Gm7qo0eC8VJqYT/ZQEcciS3ExfIblMfg=;
	b=GVKSTSt5vcVpHnB1/lMd1/LZKK9OrohvECPCAVEF3+pKYGRFmypOXzQxVbZGnraqkUpa
	 JVFvSFlX6OsLz85UoDnbOeruaZimLYbLpesSqbuhsGsxfmUMVPHRsRAobFLcX7xuZzFub
	 1JVDMAopcPLXHo8NAosfENfMxSDVflKzoqM9wueWMWCyUdMeYCjat6W4O5UUoYvwm1d28
	 dNWN8fQjerxhMPthLk0d0AWzrRB7l5/uNhWYYUklxc4rMzgIz6x3NLU77pmnfwqSqhcSN
	 62WGmZkG3nkVZx8K9PqZDi10TJd6uxXB6KkfRq+zl8wpbYA8U+iGVbwQ3TzXsywyyFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVXO1wEP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA51606A31C;
	Wed, 28 Oct 2026 18:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVXO1wEP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15C31F01825;
	Wed, 28 Oct 2026 18:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212643;
	bh=KrkUZ9Yb7/7Gm7qo0eC8VJqYT/ZQEcciS3ExfIblMfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVXO1wEP3Gwx19gHz6C+C/435cOyITx9qMvvBjefdXDGhJDvTPKDwaufuZp1ec7z5
	 2VlwYVQeb1LiWOhYEz6JOncQ3HX7+t7hCuiIS4KN1PwFw8XZORMAF+e5jaTDT12gpJ
	 DfVOqrWCNB1XgkqxsL7e+kvJz60i4vnn2U2ZdfZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0226/1887] ASoC: codecs: rt286: Revert delay value for jack setup
Date: Wed, 28 Oct 2026 17:38:42 +0100
Message-ID: <20261028170504.377315380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ceb56647e369e..42ed864c062f9 100644
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



