Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53432AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA01C433D2;
	Wed,  4 Jan 2023 16:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849129;
	bh=66h0ahMfWUG4UiOA/SnThe4rUc9VPGxQ/L8JgSjEe74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HU2fiMRjVQ8niK6V0+IPOcgdwiN9R9I6/cIdOV6WdBulBowbAE77SY+syH3sXgAS0
	 0z6PHVcgchNU1ap6yOQyDWFQvp+7aq23OiHMJSqYfbU+p1PIwrqbu1PlNKeAw+APFj
	 1Yqb1yRPPFc0L5ogHULxEUpJAvvftWmlhz0t7ymg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 109/207] rtc: ds1347: fix value written to century register
Date: Wed,  4 Jan 2023 17:06:07 +0100
Message-Id: <20230104160515.357822706@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ian Abbott <abbotti@mev.co.uk>

commit 4dfe05bdc1ade79b943d4979a2e2a8b5ef68fbb5 upstream.

In `ds1347_set_time()`, the wrong value is being written to the
`DS1347_CENTURY_REG` register.  It needs to be converted to BCD.  Fix
it.

Fixes: 147dae76dbb9 ("rtc: ds1347: handle century register")
Cc: <stable@vger.kernel.org> # v5.5+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20221027163249.447416-1-abbotti@mev.co.uk
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-ds1347.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-ds1347.c
+++ b/drivers/rtc/rtc-ds1347.c
@@ -112,7 +112,7 @@ static int ds1347_set_time(struct device
 		return err;
 
 	century = (dt->tm_year / 100) + 19;
-	err = regmap_write(map, DS1347_CENTURY_REG, century);
+	err = regmap_write(map, DS1347_CENTURY_REG, bin2bcd(century));
 	if (err)
 		return err;
 


