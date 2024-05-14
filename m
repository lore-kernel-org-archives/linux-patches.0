Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483D4320F;
	Tue, 14 May 2024 10:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684311; cv=none; b=TVTWuh40tDSpZYjSQIANHhoQwl0Kmn7UOU2kVlp2xtAOXKMlehcz+BGC98cnoMwn8yssr8LCndj5NxyG12t7d3puUaW9V61mae19vwHiRhZr06JwXpapfbFaorRm0UwHm2624JDnF4i/liuu9+L7XSibb/B3l98YZZSJKirL0Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684311; c=relaxed/simple;
	bh=eP1Nqcn31fPYr5tWlhCIARhg5nBKZivf1AUbhrVuj7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRAUefpNCzvz/DlSQiinUb+EkGhZqpQ69osVkk0njQfcFpFw4zDwmp58dbSPgiNG1GOCtPGwXyAhYgpeV6JUqNcMexJOln1VmErPlgbzb60cfdhWTo1VWUmjkCD+vlNNexZ45XkfdukEfEZtRx9+12/g6mIE3yabC7cjurtjT8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vBDVcS/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vBDVcS/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638C5C2BD10;
	Tue, 14 May 2024 10:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684311;
	bh=eP1Nqcn31fPYr5tWlhCIARhg5nBKZivf1AUbhrVuj7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vBDVcS/a71NENT6+N+uK1eKID/wi07CHVetoElBwx2Q5REAfB7VtwBFUr6fGUH+l/
	 K7Pfn+KfT/noeQcW8wNTLaJZtLiAuDtbpdVX50R54gZKIJzdFleQhTJBc9j8YJnRhy
	 TvAutA9x/j4zUT/p8TkwZsf3H4q757TDRiXyGiZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/301] power: rt9455: hide unused rt9455_boost_voltage_values
Date: Tue, 14 May 2024 12:14:53 +0200
Message-ID: <20240514101033.083534343@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c345a77f9f78c..e4dbacd50a437 100644
--- a/drivers/power/supply/rt9455_charger.c
+++ b/drivers/power/supply/rt9455_charger.c
@@ -192,6 +192,7 @@ static const int rt9455_voreg_values[] = {
 	4450000, 4450000, 4450000, 4450000, 4450000, 4450000, 4450000, 4450000
 };
 
+#if IS_ENABLED(CONFIG_USB_PHY)
 /*
  * When the charger is in boost mode, REG02[7:2] represent boost output
  * voltage.
@@ -207,6 +208,7 @@ static const int rt9455_boost_voltage_values[] = {
 	5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000,
 	5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000,
 };
+#endif
 
 /* REG07[3:0] (VMREG) in uV */
 static const int rt9455_vmreg_values[] = {
-- 
2.43.0



