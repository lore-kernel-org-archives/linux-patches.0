Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C71A1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969DBC433D2;
	Wed, 28 Dec 2022 16:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245540;
	bh=c25+kbYfNpd8xPvTch9vIqkTNYBqRyqfYiC+xIWBuTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6uyOURlytJdynseVF2m8jCKB5KYudtVZemNCDzbsnp+6Yz++qsn/hJE4hejfy8QC
	 VRsTu4LBM7jadg29IGmEVLz/zT2UsHkTBZsNU4zYqi+T0W3h3ic53IFnqitR2V8E25
	 qYGuT/2M7IuU0LCdUVPOLPG4wx5rLqSDvafDh88I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0878/1146] mfd: axp20x: Do not sleep in the power off handler
Date: Wed, 28 Dec 2022 15:40:17 +0100
Message-Id: <20221228144354.011022538@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 3f37d4f695cff180033254b9ed5adc8ab927cba9 ]

Since commit 856c288b0039 ("ARM: Use do_kernel_power_off()"), the
function axp20x_power_off() now runs inside a RCU read-side critical
section, so it is not allowed to call msleep(). Use mdelay() instead.

Fixes: 856c288b0039 ("ARM: Use do_kernel_power_off()")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20221105212909.6526-1-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/axp20x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index 88a212a8168c..880c41fa7021 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -842,7 +842,7 @@ static void axp20x_power_off(void)
 		     AXP20X_OFF);
 
 	/* Give capacitors etc. time to drain to avoid kernel panic msg. */
-	msleep(500);
+	mdelay(500);
 }
 
 int axp20x_match_device(struct axp20x_dev *axp20x)
-- 
2.35.1



