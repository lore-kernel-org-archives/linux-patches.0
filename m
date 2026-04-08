Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1B43D4134;
	Wed,  8 Apr 2026 18:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673877; cv=none; b=b+yB9WseW6o60ME+PBXsNrOLc/RuYkr9G8qiS+5tCStti2qpTeNH5vu7HKDiOailpTBJ9jHj6x4w+uwzbak5pz+9ktjOy/zSTOqcso6gO/VzpZ8s2p0e//PCCm+ZNpwX9zvEoQQiHa+kregaVyk5FgtdMWKHXdXHAd+/2jsoIUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673877; c=relaxed/simple;
	bh=VZY114+K0iJwyxr6RDEpai6VcwEvcVVWv8C7td1f+Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRBccczAKQTWeHr5TKUXXPihTpoN+aWN9tuIsoQ+7QHufzcP5D2H8dr6ZjE01+XJt6yr71e1LrnhUdR2DpCqlVgOrH+O8Xz3SaKyTXdYTLx6DNiZUGNhiwbVn+ZwImRvWth1uSvyCl70G3nvzU1us0yjiXpThjLT2Wv47++g70Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d29IqDJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d29IqDJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8079FC19421;
	Wed,  8 Apr 2026 18:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673876;
	bh=VZY114+K0iJwyxr6RDEpai6VcwEvcVVWv8C7td1f+Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d29IqDJaxtM9yt7jfz4uCObt7cIxu4uzhG+svAzy7+N1aKCSAelyuUP9w9IDU8VWP
	 uDCW//Q+MvlXAAXuhcw/+gAcbfNvsmT6fS3SPGu9ZHLaD82zaykqIUv6EuzfVDDYDC
	 VWjgKNEsdXyE6GHoKHpZFv/2RPt2d8KO5LP/Y59Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/242] hwmon: (ltc4286) Add missing MODULE_IMPORT_NS("PMBUS")
Date: Wed,  8 Apr 2026 20:02:26 +0200
Message-ID: <20260408175931.051765729@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

[ Upstream commit a9d2fbd3ad0e6ac588386e699beeccfe7516755f ]

ltc4286.c uses PMBus core symbols exported in the PMBUS namespace,
such as pmbus_do_probe(), but does not declare MODULE_IMPORT_NS("PMBUS").

Add the missing namespace import to avoid modpost warnings.

Fixes: 0c459759ca97 ("hwmon: (pmbus) Add ltc4286 driver")
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260329170925.34581-5-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/ltc4286.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/pmbus/ltc4286.c b/drivers/hwmon/pmbus/ltc4286.c
index aabd0bcdfeee3..8715d380784a0 100644
--- a/drivers/hwmon/pmbus/ltc4286.c
+++ b/drivers/hwmon/pmbus/ltc4286.c
@@ -173,3 +173,4 @@ module_i2c_driver(ltc4286_driver);
 MODULE_AUTHOR("Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>");
 MODULE_DESCRIPTION("PMBUS driver for LTC4286 and compatibles");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("PMBUS");
-- 
2.53.0



