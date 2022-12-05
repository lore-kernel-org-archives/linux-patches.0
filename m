Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17FE15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43501C433D6;
	Mon,  5 Dec 2022 19:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268210;
	bh=fnhSODLAcno3KqncfRPfQJNekfLDBy7vnQmC5+sxIUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PM9F/YROLwIBnSCwzpjMhbHA+rlWOM00MhfxHjo4UAOQMhkiF4sBGpT0uwIKGwHeO
	 Ig8hggvwPeDAqjSHrCjt9PPoZQFR2WdGqST28RCCVo/ZOhlCdRcr5oweVGprAbbc4v
	 FaUDOaoMIm09bB11A7IivIHmcXvx/1jDZZu27vc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Nguyen <derek.nguyen@collins.com>,
	Brandon Maier <brandon.maier@collins.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 020/124] hwmon: (ltc2947) fix temperature scaling
Date: Mon,  5 Dec 2022 20:08:46 +0100
Message-Id: <20221205190809.025437319@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Derek Nguyen <derek.nguyen@collins.com>

[ Upstream commit 07e06193ead86d4812f431b4d87bbd4161222e3f ]

The LTC2947 datasheet (Rev. B) calls out in the section "Register
Description: Non-Accumulated Result Registers" (pg. 30) that "To
calculate temperature, multiply the TEMP register value by 0.204°C
and add 5.5°C". Fix to add 5.5C and not 0.55C.

Fixes: 9f90fd652bed ("hwmon: Add support for ltc2947")
Signed-off-by: Derek Nguyen <derek.nguyen@collins.com>
Signed-off-by: Brandon Maier <brandon.maier@collins.com>
Link: https://lore.kernel.org/r/20221110192108.20624-1-brandon.maier@collins.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc2947-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ltc2947-core.c b/drivers/hwmon/ltc2947-core.c
index 5423466de697..e918490f3ff7 100644
--- a/drivers/hwmon/ltc2947-core.c
+++ b/drivers/hwmon/ltc2947-core.c
@@ -396,7 +396,7 @@ static int ltc2947_read_temp(struct device *dev, const u32 attr, long *val,
 		return ret;
 
 	/* in milidegrees celcius, temp is given by: */
-	*val = (__val * 204) + 550;
+	*val = (__val * 204) + 5500;
 
 	return 0;
 }
-- 
2.35.1



