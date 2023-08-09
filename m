Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0322B171CC
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CFFC433C8;
	Wed,  9 Aug 2023 11:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579388;
	bh=jk1aOO4apUpapoCvjzFcjvQGW6LWJoD4C975uIVuVNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjTjiRc4p7e96gfxaH7v0UHQAHmSZ1gg5PjBJH9Jp+o58f/3OOW+JnQkHn9kBFzE1
	 AkIyXUsvr7x1suGDU0XM9+/DVWrrftSZdA0gTbYeWmm4/hogZXo+0ZJDki1OLjkZRu
	 N5+JJ/jLiCSFNAIkhqvpzh3F+hfJ5ud/nUBALDmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gilles Buloz <gilles.buloz@kontron.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 171/204] hwmon: (nct7802) Fix for temp6 (PECI1) processed even if PECI1 disabled
Date: Wed,  9 Aug 2023 12:41:49 +0200
Message-ID: <20230809103648.237927645@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
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
@@ -698,7 +698,7 @@ static umode_t nct7802_temp_is_visible(s
 	if (index >= 38 && index < 46 && !(reg & 0x01))		/* PECI 0 */
 		return 0;
 
-	if (index >= 0x46 && (!(reg & 0x02)))			/* PECI 1 */
+	if (index >= 46 && !(reg & 0x02))			/* PECI 1 */
 		return 0;
 
 	return attr->mode;


