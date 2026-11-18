Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032113;
	b=RV/Jt4rm9JHUkDjvnyPmYwpIJtYfZeUaZcl/5YMtyuTg5dAHU2o553GVyPhmaG6H6Uri
	 AOkKPKXtI5rUyJeE05bc8B0Uk4DCHLD1KxXWsz3RpUeX4XCWJhovYAzWTNnA591/itYUA
	 Y4HZldWxlhZIsRqWAgytzG8z9/e06O900Hz7Wnix+tOyeYTlwJbDyjTI3e1S54AcN5wML
	 05I6bZNWcKSsOz0PwuDOQfpB7HQdtBgml0CvN7P41JXl0CE0Y3FTo574fPzxZEAcH9rx9
	 6VQDQ6nZ4eQx8qEV9bKcyYsSWLxjoAVXbkgwiKhW5ZTJaXzckSkMzvhEf2tG1pamxkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pQM7yP4Yyk2iY5LxHhUQTJ7CHfAeWnywU5tV52c10iQ=;
	b=NiHeTGuX3mqCJQavWgeWmV7PTAQKJKsxeANo2kcK5ieRlP0xCLlANTNVI1iQuu51Mr5M
	 Q3cde3ViqP4tBZXgbPRd7LnXhiltbS44A87NYsf4Hh733WJwheexAFQZctWAHUwLv4dkS
	 q3d1I54rWqO2hh72Bdrs1ran/jljLFH5Fc/GAoVOSyAMxGfmbk24I+dDTChwBdiuM+0r4
	 p0IiLBBFyIxMzH/DQ5fcoGBNwFkBjOPLLq0I/vrIcY0rtwqdDPAIWFZlGgGaV4arxbUZC
	 okrwyTtwKyEymyL6eFc8Ddn9dgL30pfO+5Khl5T+8dMn7oYrysNe0BoHomC+894sWNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tGo1YzJL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96515606A320;
	Wed, 18 Nov 2026 20:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tGo1YzJL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF1D1F000C4;
	Wed, 18 Nov 2026 20:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032113;
	bh=pQM7yP4Yyk2iY5LxHhUQTJ7CHfAeWnywU5tV52c10iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tGo1YzJLUQqnWHZnp7K9rxMVzrFrh0s6K9xreRW0aN/Wtuim2tp00CirY2HncXCZ+
	 6DsTku3itwCUjcpuEH2Fgvx+7XQzBkaJBzka4ymMpR/kJqhUbI4rXAda2o/hI3mq7s
	 pe80r1G6i5/Rmc4PfbSgFMaekBCKjKtqJCrF7soA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1298/1756] ASoC: soc-topology-test: Check return value of kunit_device_register()
Date: Wed, 18 Nov 2026 15:57:05 +0100
Message-ID: <20261118150101.196251047@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amade@asmblr.net>

[ Upstream commit 1641c1ba27abcd3ea3bba1232d9d817092f1b757 ]

Call to kunit_device_register() can fail. Check return result of
register call. While at it introduce helper variable so that if it fails
put_device is called on properly initialized variable.

Fixes: e57cdff0ddc4 ("ASoC: topology: Replace fake root_device with kunit_device in tests")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Link: https://patch.msgid.link/20261014200608.118770-4-amade@asmblr.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology-test.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-topology-test.c b/sound/soc/soc-topology-test.c
index a2b08568f4e89..39f0d5597758d 100644
--- a/sound/soc/soc-topology-test.c
+++ b/sound/soc/soc-topology-test.c
@@ -24,8 +24,12 @@ static struct device *test_dev;
 
 static int snd_soc_tplg_test_init(struct kunit *test)
 {
-	test_dev = kunit_device_register(test, "sound-soc-topology-test");
-	test_dev = get_device(test_dev);
+	struct device *dev;
+
+	dev = kunit_device_register(test, "sound-soc-topology-test");
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+	test_dev = get_device(dev);
 	if (!test_dev)
 		return -ENODEV;
 
-- 
2.53.0



