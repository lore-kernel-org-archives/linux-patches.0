Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042442;
	b=HdBp1C+1AdVVI199raV6Z64Jt+1sVtRyWZW0Hp5fWCeztANQotIZulNIY/W91m/h4Upr
	 L5XarKOtIXAFHhwt/Np9M9XUoF6SV9DsQ1AUBxVl/oMNPSIG47nR9gh42UeqMHUR0bIMr
	 kmes01m7OOHRDNZaNOmeGdznEQOD5NlWR3lXtmTzQoLzmlqN7SRnJ8kpReCkhrK9mQs6j
	 3B+iA9WabLibLgzqcZl/rZX3SXnwrGbBQpVVRzCeAztRuefnbMGXmfBcYF7LE4BZ1Tw5A
	 ZMfM1wQx3cRPqIcJsEYSkTVvgBGU+NHbGshK/budGEWVvKFarjJW0UFadT28guHgHVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3BEm+RGoHwcIIc7NjnJqn5hMeFDj8ToF0ydnldUb5Bs=;
	b=OjcG3xNTodJ1PHsUtY4Cz46T45ah6sdH1y6+TuEdYqlWITHj1L97YC9OJpyoScFxNysP
	 ffmKfIwp4pcrc7ytmNt3vfo7GA5ZHMtFY/ysfFj5pq5DLHL/6smeolGkrX1yolIusUlxm
	 H4HbyCAhQXSphc3YDW0rFDySox7nF4D8qie1xV1tVIwrda5c5t0zhtPSs7yXtyQK+7f0j
	 IIVJqQknPk9eq0vD9GqRJU0ypOuRFF29QeJkBn4eoUIPItxHgYkQnDaZG9HbQVTlwmBK/
	 cdB+D6N9pBEdfDp4SuXZhUI1Ew+bnGydSCrdyZ4+lcvuNCCqqeYA5nHny/VsnWg0+ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJKK6Gg5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EC0606A320;
	Wed, 18 Nov 2026 22:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJKK6Gg5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6651F000C4;
	Wed, 18 Nov 2026 22:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042442;
	bh=3BEm+RGoHwcIIc7NjnJqn5hMeFDj8ToF0ydnldUb5Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJKK6Gg5JUm2Yj1NJxXd4B8pHJwDCJLaVXzcstoxDd9UhyrS6UOKYe7WaYhJ2A8VO
	 7uKuHqjsxWwbCG4Y5+RIHW33YV6CyheaCNkJPIIi0UQ+k89n9JWVdgp4MdaUZAC6Ik
	 JDeBaiembFV6Y2Py0y5zSPZQwQYyf4yNr+NmaDBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3173/3318] ASoC: codecs: wsa883x: disable runtime PM on unbind
Date: Wed, 18 Nov 2026 16:03:15 +0100
Message-ID: <20261118150455.016807386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit ea63182d71956dc33c6f08dc4171f1052f8409a9 ]

Probe enables runtime PM but nothing disables it on unbind, or when
registering the component fails. A pending autosuspend can then run
wsa883x_runtime_suspend() after the devm-managed regmap is freed, and
dereference NULL, as seen on wsa884x.

Use devm_pm_runtime_enable() so runtime PM is disabled before the regmap
is freed.

Fixes: 43b8c7dc85a1 ("ASoC: codecs: add wsa883x amplifier support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261023171316.819857-6-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa883x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index 8d712781018a2..b2569e1daf5bd 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -1439,7 +1439,9 @@ static int wsa883x_probe(struct sdw_slave *pdev,
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		goto err;
 
 	ret = devm_snd_soc_register_component(dev,
 					      &wsa883x_component_drv,
-- 
2.53.0



