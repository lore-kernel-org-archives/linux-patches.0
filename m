Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDC122301;
	Mon,  9 Feb 2026 14:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648272; cv=none; b=D9HIcJgElqng3xeh3X3KWiKMblTGQFGLplf/fPrncKNIUqFmugBnN9ysVrZO8PUpNoOus5nKoivUry5WHCBy9LUUuK+xJ/pWBqKPT9fSGL4H5aK4djf6DMPJUwXxz3D9JsGTZ9MprTRNSszCT6BxPduh8d/micFPKcXwDImeaCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648272; c=relaxed/simple;
	bh=MtnOWSUJpVOlgTD+1g92EgZFFT3pfi5vcIzR8WKpzhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jh8WD3OU8Wh/sHKP99iEFBWGnqsXZb2KFemhDctNycAxWyZRfBX3ZycUx60f53jzjeG1L932hbLqtwhpC9cbXQCkSrZi5ZjVh96JuZl/nu9ZIzfrzkNOmHR8Iv9RNEFVncuGI9ErK/jDUXIZudQ2HcTjQH9XzVCnBdwuD0GJyMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRTxysIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRTxysIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183EAC116C6;
	Mon,  9 Feb 2026 14:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648272;
	bh=MtnOWSUJpVOlgTD+1g92EgZFFT3pfi5vcIzR8WKpzhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRTxysIf9REZlJPmY05AGEg+BXRVL/ltJgCcq8fsjqwaboMaYrQd69SpK9uk5p2m5
	 wl2vgLZPkxGtE+RySjmomtvHtoZQwbX5ENpfitOQfO7Z4SMWYRUJFKHVGHsaQJents
	 BCp0Q6xfyBpt8eyRAJga5o4fQ6iWhM5R/JGNd+5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 57/69] hwmon: (occ) Mark occ_init_attribute() as __printf
Date: Mon,  9 Feb 2026 15:24:25 +0100
Message-ID: <20260209142303.976391843@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



