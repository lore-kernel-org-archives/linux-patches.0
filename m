Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18B28F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E93C433C8;
	Sun, 16 Jul 2023 20:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540610;
	bh=QjQ9+ZRVVF1kYwZj8SlYs5LOBQAX1yIgn5kqt+hbM50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRBZo5SrrYvmaM1B2cu4njPiq5CmZPcuRm4y54EK+4GUKsPaSmYCbBcEMEd/hZiC3
	 QfV1KTjNbOyCweOtO5RfPcyzCkdNWWwTdw3hFV6eh4eDkK4MjaOGmqJoJZqP3Pz3K9
	 HLqmm5A+04CQZEtzUP77bJImA36y6QVBOcajDOsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Jakob Hauser <jahau@rocketmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 424/591] mfd: rt5033: Drop rt5033-battery sub-device
Date: Sun, 16 Jul 2023 21:49:23 +0200
Message-ID: <20230716194934.885802751@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 43db1344e0f8c1eb687a1d6cd5b0de3009ab66cb ]

The fuel gauge in the RT5033 PMIC (rt5033-battery) has its own I2C bus
and interrupt lines. Therefore, it is not part of the MFD device
and needs to be specified separately in the device tree.

Fixes: 0b271258544b ("mfd: rt5033: Add Richtek RT5033 driver core.")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Jakob Hauser <jahau@rocketmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/6a8a19bc67b5be3732882e8131ad2ffcb546ac03.1684182964.git.jahau@rocketmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/rt5033.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mfd/rt5033.c b/drivers/mfd/rt5033.c
index f1236a9acf304..df095e91e2666 100644
--- a/drivers/mfd/rt5033.c
+++ b/drivers/mfd/rt5033.c
@@ -41,9 +41,6 @@ static const struct mfd_cell rt5033_devs[] = {
 	{
 		.name = "rt5033-charger",
 		.of_compatible = "richtek,rt5033-charger",
-	}, {
-		.name = "rt5033-battery",
-		.of_compatible = "richtek,rt5033-battery",
 	}, {
 		.name = "rt5033-led",
 		.of_compatible = "richtek,rt5033-led",
-- 
2.39.2



