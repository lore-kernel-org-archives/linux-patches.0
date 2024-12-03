Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193081F75BB;
	Tue,  3 Dec 2024 15:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238903; cv=none; b=GO+1YDQjnP3DHUN2FTDrvldFf92Dtj2Df99nKqAH1OiTFJGbxzqBIvcDX1DPobR3sp6+kK3V79PafhPmTB3FhfP0eiMfpSM5E5xU8f+4EWiqb4mETgwudPwB7L6Q92SaitGOPVrIsc/ei7GgwIgCqKJHUKPksNjaAqmGiilNvvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238903; c=relaxed/simple;
	bh=Upfa8q0lfPe0hg1cHS7WKpfYabusnGYYt20H/xJ4XfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dlaU5eD/y9dsI9I4GNi+Kzcts6t7p/rS2TR7LnJAkb4Jl4tz4c6oXBAg17EMXVUc4Iy/Xc3wcpQEHu7Y7R7QSm2xI4wXUQUBdjrJ1SdHKSIkQqiieTIvrKPMEMSBrDBPOw7LhMLBpNLGH2DCTicho8BtwJLxT2wjXJ2kTR9Ztxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdJIIg0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdJIIg0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932BBC4CECF;
	Tue,  3 Dec 2024 15:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238903;
	bh=Upfa8q0lfPe0hg1cHS7WKpfYabusnGYYt20H/xJ4XfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdJIIg0YBJCKsj2sFXGbXQH5p2s39etHRPJM4Ip3t2bzy65z+tsfUd74bgRZoTOyk
	 kzxdOilVjgyczsBpqOiVRx41XHg/3EFS1BBcV1pm/6dh8DX6aOC5iVV5OIMnsawsJg
	 CVgDF1SIxSOQ1v1kBD127jHWkjE/J5TtefbFfPrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raymond Hackley <raymondhackley@protonmail.com>,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje.mihanovic@skole.hr>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 435/817] leds: ktd2692: Set missing timing properties
Date: Tue,  3 Dec 2024 15:40:07 +0100
Message-ID: <20241203144012.862338249@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 7bb0aa2753e36..0a8632b0da304 100644
--- a/drivers/leds/flash/leds-ktd2692.c
+++ b/drivers/leds/flash/leds-ktd2692.c
@@ -293,6 +293,7 @@ static int ktd2692_probe(struct platform_device *pdev)
 
 	fled_cdev = &led->fled_cdev;
 	led_cdev = &fled_cdev->led_cdev;
+	led->props.timing = ktd2692_timing;
 
 	ret = ktd2692_parse_dt(led, &pdev->dev, &led_cfg);
 	if (ret)
-- 
2.43.0



