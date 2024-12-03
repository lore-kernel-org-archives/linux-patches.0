Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0D71F76AA;
	Tue,  3 Dec 2024 15:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241536; cv=none; b=nbBtFvVFC7Z4N1vuP1cW2KSfytKiZNnvPo7ZogNokc8As9cjqY4HoR94QJO3Zp3nslfo/Q1FOIM5X9JsW3BEGgoogCcApbVAkh8lMiXSqchz+VXKxrUniExTPHn/2l1auHf+sKXUq9je9awpj/psJAkMJRbX0z2b4qvsr5HN4ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241536; c=relaxed/simple;
	bh=WKVp2wGDXdTK9s9Wx8xFouTOmFBNXea05nIqea0ALeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jtyI1Pb9PDeFFjXd9Pmu/ybyapei5TWPGJMpTbf2BxFdsm4sWzVcn+gXOEkD4xzZn9OWXxmUlObdixhiGoo8749c4bAzgfEzeUm8enMEXLTnJitL7JgUu2w7UA+8me5+xwX1lMtLa2abTaM/ZbeWk0wR6GWquGud0PC1qQr4yZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqcYLCW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqcYLCW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5846EC4CECF;
	Tue,  3 Dec 2024 15:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241535;
	bh=WKVp2wGDXdTK9s9Wx8xFouTOmFBNXea05nIqea0ALeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqcYLCW/ylzB+WJXdGI6FrQbfSJ72hG5Ep/+a9iAwDP9DcJsOE4suMF22uJXbOYre
	 QA6SkkMShOls6ypuFG+KhFBJOUKPxR4hmhPd1NxtR5eJ+6ch/puCzFA1atVWRfKlCj
	 sr+2G7xxdMDMBpFhrUcIKcg8IQp4WeYGqafOpj9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raymond Hackley <raymondhackley@protonmail.com>,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje.mihanovic@skole.hr>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 415/826] leds: ktd2692: Set missing timing properties
Date: Tue,  3 Dec 2024 15:42:22 +0100
Message-ID: <20241203144759.948453669@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raymond Hackley <raymondhackley@protonmail.com>

[ Upstream commit 95c65546f03f888481eda98b499947252e1f3b20 ]

props.timing is not set after commit b5a8c50e5c18 ("leds: ktd2692: Convert
to use ExpressWire library"). Set it with ktd2692_timing.

Fixes: b5a8c50e5c18 ("leds: ktd2692: Convert to use ExpressWire library")
Signed-off-by: Raymond Hackley <raymondhackley@protonmail.com>
Acked-by: Duje Mihanović <duje.mihanovic@skole.hr>
Link: https://lore.kernel.org/r/20241103083505.49648-1-raymondhackley@protonmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/flash/leds-ktd2692.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/flash/leds-ktd2692.c b/drivers/leds/flash/leds-ktd2692.c
index 16a01a200c0b7..b92adf908793e 100644
--- a/drivers/leds/flash/leds-ktd2692.c
+++ b/drivers/leds/flash/leds-ktd2692.c
@@ -292,6 +292,7 @@ static int ktd2692_probe(struct platform_device *pdev)
 
 	fled_cdev = &led->fled_cdev;
 	led_cdev = &fled_cdev->led_cdev;
+	led->props.timing = ktd2692_timing;
 
 	ret = ktd2692_parse_dt(led, &pdev->dev, &led_cfg);
 	if (ret)
-- 
2.43.0



