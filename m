Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF6E1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8923DC433C8;
	Tue,  1 Aug 2023 09:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882729;
	bh=vIB+txEOnViMd2ZAX8AJdis+7COc7/YFNzm2nB95+eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/9EDfncmgZekfeVOAkb2tI3hcLl8mBb9zdjhD7H3OMIucK7J/IYWALTT4eQFgcrC
	 0Iigy32uHKA9alwZJjtWQK44juf/rpUxzbRQpN/3kK+40dhrpEiOiS0IkPtXlUDgw2
	 igxhDFwkrMkFwWeIM/Z77R/2WgAbS/+3Y57IdsjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gilles Buloz <gilles.buloz@kontron.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 182/228] hwmon: (nct7802) Fix for temp6 (PECI1) processed even if PECI1 disabled
Date: Tue,  1 Aug 2023 11:20:40 +0200
Message-ID: <20230801091929.439147941@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gilles Buloz <Gilles.Buloz@kontron.com>

commit 54685abe660a59402344d5045ce08c43c6a5ac42 upstream.

Because of hex value 0x46 used instead of decimal 46, the temp6
(PECI1) temperature is always declared visible and then displayed
even if disabled in the chip

Signed-off-by: Gilles Buloz <gilles.buloz@kontron.com>
Link: https://lore.kernel.org/r/DU0PR10MB62526435ADBC6A85243B90E08002A@DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
Fixes: fcdc5739dce03 ("hwmon: (nct7802) add temperature sensor type attribute")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/nct7802.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/nct7802.c
+++ b/drivers/hwmon/nct7802.c
@@ -725,7 +725,7 @@ static umode_t nct7802_temp_is_visible(s
 	if (index >= 38 && index < 46 && !(reg & 0x01))		/* PECI 0 */
 		return 0;
 
-	if (index >= 0x46 && (!(reg & 0x02)))			/* PECI 1 */
+	if (index >= 46 && !(reg & 0x02))			/* PECI 1 */
 		return 0;
 
 	return attr->mode;


