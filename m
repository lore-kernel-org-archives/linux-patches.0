Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032912;
	b=ImkdhSHlpoW0O3jS5+SkdSDduM6GxtgXUQ4vW9P0xjtQfltQrejDuu6gW0GsmbLdlDP5
	 FjH1U/p4HB/nVRZAAgECKrN+C0aRs45OtKafzrPwYtYZFxg7gnmZkcg/l08if2EZULpvX
	 ZEcIgVOnQjMUnNi77zQabSIxcG9Yh2Lb3ZmaL3LvC5UfuZgSUlMZr5/NgVxRIrbpGAn0G
	 YvdJZ42EVr4D3fWNzGp9a9CMbFqm/J5gN49ZqM874/6YdenqpE3X8wgzzXvbnaRq2FvAS
	 Tubv6i/49v202smEqvyEQ1ojyAXSysQBGIG7cushFF2oM3JmegZBGTfOmy+7v6f6WLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q2FtQKrOxFTmEJJT/aLZ6JQIRKw9xn0DyOM/zH8EDrA=;
	b=ebUpCmVBwU4fLRDEjkvyt6M0iY2oxDlYsQqYEpmTPv8w/gl1hsZf7oViHFWAkCe3FisA
	 ATbzZXDvS5uEHNP/9ObLwcs9jPJi/ow9HyHG4lajPNjmNdG5Z5IMqu6WIiAR+KPmFJrUL
	 byr496G0QaPyJ3mjVdhf05ghANNlGbDGIhAkPsspxekI00NVcuWEOVvTad2PyGWm9L5yr
	 zdgSKQv8FFR//MNBQQ05vi130em4kzN+C5I+dbAOxgg44bY7ytacI0UkjG1cH9JwL/HQZ
	 25sDw6ci1HSkR1SJivd2W6zJW5y29w4mX8i9RPCqCEX68Jo1WKYvRqgkjDc0SzVihKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dypT2sXn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D9D606A339;
	Wed, 18 Nov 2026 20:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dypT2sXn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AD01F000C4;
	Wed, 18 Nov 2026 20:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032912;
	bh=Q2FtQKrOxFTmEJJT/aLZ6JQIRKw9xn0DyOM/zH8EDrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dypT2sXnnHx8R3uymWSt9AUD7CMtLxfZdjLUf40GtQLyLnG5TNN3++igCfoDab7uE
	 LPOrxmFgKXfOV14FMcobI2LcxT2SSpLZtZQGQTp1WEBR3xIb2bJ4HY54f5QPJLKgEA
	 qrzDdZk7enYpr2BiuJXUKXBr5vkxNQFwzUKjM8QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1580/1756] ASoC: codecs: wsa883x: disable runtime PM on unbind
Date: Wed, 18 Nov 2026 16:01:47 +0100
Message-ID: <20261118150112.692363323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8d1393041de48..491a2131bb598 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -1437,7 +1437,9 @@ static int wsa883x_probe(struct sdw_slave *pdev,
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



