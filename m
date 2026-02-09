Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA134285073;
	Mon,  9 Feb 2026 14:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648553; cv=none; b=KEgHlO67CQo7MGiJd3d6rLkJ2tzWUC5G0hWL4AlYlT/aWKGjDyKilp8i6fLkGFh1tLHpH+8H2Wwic+zJ40D6KVQzaeoe5bMWFBZ59tNk9VK+v8f24tkEludXRuAPGukOG9k12hVahtDg+zhDvYR8kOWOjErm2jbuyZl+jC1x444=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648553; c=relaxed/simple;
	bh=s3pakPxL+w+JOaKkMGljQOcqkvf1HfdDvOKeFdbV2ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzlARsAk+PswN1u1Mv49b3M7ZQDCrwCYjbytFAG6nM+QkU1B0hLhlTG/8Qvvtb4ERy2nyn4PJG76Vl3DEXqN6EmkRxoqF9XGQX4+veJK8KpqkcUsPUKcdvGctTFCnidnk42+Gst+hNbFMd4qNkCyGamf9PBGRaNvg4gTcRD3txc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grVbNkox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grVbNkox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615A0C16AAE;
	Mon,  9 Feb 2026 14:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648553;
	bh=s3pakPxL+w+JOaKkMGljQOcqkvf1HfdDvOKeFdbV2ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grVbNkoxgA2Ycd2Ys0ibN+NBm0iocOwgdUhnONpKNtHk0ENbZ5HsstFKva8JMsMyp
	 H3cbwgBlh0f9Y9Z9zdRvjtC3w92nw46uJx1mtwDA9tCQaxeam9RFKg0cElzVAqNUA+
	 KRG/MBTR7Y3LrHWs0r7lp9/bwqG1/3KLmqcRJXP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 73/86] hwmon: (occ) Mark occ_init_attribute() as __printf
Date: Mon,  9 Feb 2026 15:24:36 +0100
Message-ID: <20260209142307.403795777@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 831a2b27914cc880130ffe8fb8d1e65a5324d07f ]

This is a printf-style function, which gcc -Werror=suggest-attribute=format
correctly points out:

drivers/hwmon/occ/common.c: In function 'occ_init_attribute':
drivers/hwmon/occ/common.c:761:9: error: function 'occ_init_attribute' might be a candidate for 'gnu_printf' format attribute [-Werror=suggest-attribute=format]

Add the attribute to avoid this warning and ensure any incorrect
format strings are detected here.

Fixes: 744c2fe950e9 ("hwmon: (occ) Rework attribute registration for stack usage")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20260203163440.2674340-1-arnd@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
index 483f79b394298..755926fa0bf7d 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -749,6 +749,7 @@ static ssize_t occ_show_extended(struct device *dev,
  * are dynamically allocated, we cannot use the existing kernel macros which
  * stringify the name argument.
  */
+__printf(7, 8)
 static void occ_init_attribute(struct occ_attribute *attr, int mode,
 	ssize_t (*show)(struct device *dev, struct device_attribute *attr, char *buf),
 	ssize_t (*store)(struct device *dev, struct device_attribute *attr,
-- 
2.51.0



