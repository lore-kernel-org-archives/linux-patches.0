Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5B41272AE;
	Tue, 14 May 2024 11:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687208; cv=none; b=c4L4xGwwRes6iDCm8nhd9+Ei5E8YRn1P3Kcs/jLDXwU16EZcBK/AcIcsL9d6wbSTGOFFGNEY1uq08I3gBIdAIKO/hT0X1VvRyPG3O2C9mh9OkINcomXl5GqXStDJhD4ArnRktiEOpdc4E5sb9+0gHu5b99EuNN6U8oMC3gHYVLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687208; c=relaxed/simple;
	bh=4fAPRVUhIEvJT5DQnM2ciObMepP7b+xnWIgmCxtroc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYcubQDuITEPOUinE9sFwwKhpoW/ewxOiW4+ZOLGVGSOrl2YGrIIJuk1axwjsjhETTvpGStHwoSZ9H6IYCTfpz36sRp34AA4VgcEn2pskqGerIv/DOTz8ZCgzQ1uON9VAbVmk6/H94VbwsbL3UvSA6O4FuI1s+Kh5YTUMlh9TkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xF7t4tXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xF7t4tXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AB3C2BD10;
	Tue, 14 May 2024 11:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687207;
	bh=4fAPRVUhIEvJT5DQnM2ciObMepP7b+xnWIgmCxtroc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xF7t4tXR9kRKLhof9VxpxduqZspYIuy/sxwIKPI5pb8/UeGKZioQznhxWX3VAMGNm
	 /tNnjU3rK1/6BB0LXqDTtlqS6e9K+PYHj1ZKbuBjDxSjP2LERHaea3pd+s3V5ZZ5Kq
	 MNPBGFp8czFODhykZ2JHixoCgYCIJDmOtuD8YWRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/111] power: rt9455: hide unused rt9455_boost_voltage_values
Date: Tue, 14 May 2024 12:19:15 +0200
Message-ID: <20240514100957.780261698@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 452d8950db3e839aba1bb13bc5378f4bac11fa04 ]

The rt9455_boost_voltage_values[] array is only used when USB PHY
support is enabled, causing a W=1 warning otherwise:

drivers/power/supply/rt9455_charger.c:200:18: error: 'rt9455_boost_voltage_values' defined but not used [-Werror=unused-const-variable=]

Enclose the definition in the same #ifdef as the references to it.

Fixes: e86d69dd786e ("power_supply: Add support for Richtek RT9455 battery charger")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240403080702.3509288-10-arnd@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9455_charger.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/power/supply/rt9455_charger.c b/drivers/power/supply/rt9455_charger.c
index 594bb3b8a4d1e..a84afccd509f1 100644
--- a/drivers/power/supply/rt9455_charger.c
+++ b/drivers/power/supply/rt9455_charger.c
@@ -193,6 +193,7 @@ static const int rt9455_voreg_values[] = {
 	4450000, 4450000, 4450000, 4450000, 4450000, 4450000, 4450000, 4450000
 };
 
+#if IS_ENABLED(CONFIG_USB_PHY)
 /*
  * When the charger is in boost mode, REG02[7:2] represent boost output
  * voltage.
@@ -208,6 +209,7 @@ static const int rt9455_boost_voltage_values[] = {
 	5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000,
 	5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000,
 };
+#endif
 
 /* REG07[3:0] (VMREG) in uV */
 static const int rt9455_vmreg_values[] = {
-- 
2.43.0



