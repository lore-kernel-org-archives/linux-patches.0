Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038810;
	b=E9QA/5uGT65XaOLJ09gmHsYXgW6J6dsV4FEqjcnSVX1IoGFG9rvMFHdd8/DLdEbVlKSp
	 LVhT5hSxloHEUmA9SfeF0j4OWfUxGSX86yuYsWMc1RcyCDAuEOrGKWoCFpY5RISJPXs+u
	 7LmDJBle5ICXxqtc6SM/LTCFIvOkMYs5gkxwnJbQiIPmIBg87/Cn4YDMIXbT1azffYzhH
	 hSOR01KcU7lSIXArZW6Vtb7J5PxzIZT6B2aqzv/Mv/G5fZv7PfctgX4590tN+qPErXaJS
	 1L9m2cfhNVQSyfT4HTnNGLecE/VxNcvlvUyO8tlwG5ulpN7fgjHSsB0/0dNpSMsLxhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pNu6HmosHe3KC5Nx5nM2ksY0qUa5t9AUcBGot+eOI2Q=;
	b=ln05tcXugJj3obvtazoTNsSZyzLD5J2fsonro5ovBt1YxEUvcrwL0zlMpBiT85l0XqcB
	 6c1gG8U1vNGTloJrWxObI9jk2mHLJGrLqTTAWAluK6bOZoWiEd7xlxSna6iitDff821SG
	 flBpRs2KAr9ig2jJcAhL0uABQR7Qmb3Xd0MgSNlJO4F/SLulOSrCDqpX1yjuI6Pn8NSmI
	 /7+9qx+5m/iej4Aq3fm5tGCxzR3oUIsl7acuioRwQvaHruxJGi0S1KYX21tg0isDaRGBr
	 gGsKE3KTIILvamTKVqvOH6gOQCnxftL+1imgmUgO9E7pGAHQGrbA/3W7dtO55Ueh8iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hft6rsNr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC495606A31C;
	Wed, 18 Nov 2026 21:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hft6rsNr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C0B1F000C4;
	Wed, 18 Nov 2026 21:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038809;
	bh=pNu6HmosHe3KC5Nx5nM2ksY0qUa5t9AUcBGot+eOI2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hft6rsNrUuI1FJVGxjdlx4KmWRPbUOn7BGlDR+Q76LdW70ibU3eQW8Kj8YrEdw4FY
	 LzMsM1z4LMxWSJf/XOnwISLxLW8hGqWuIlF+9t5vetvJSTx3pQaahUBBmrQKNfMAXK
	 JGfpLAjw76e67Dna0GbBYXMF1SoLknzbllhV7Qmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1833/3318] power: supply: core: remove opencoded string_lower()
Date: Wed, 18 Nov 2026 15:40:55 +0100
Message-ID: <20261118150416.851221975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 0ce51459c8353b2b18ad3a430dbebf29af8b579c ]

string_lower from string_helpers.h can be used to modify the string
in-place. Use it to get rid of the custom str_to_lower().

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20230929-power_supply-string_lower-v1-1-3141a2634d53@weissschuh.net
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 6bd80f22c764 ("power: supply: core: Honor supplied-from with CONFIG_OF=y")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_sysfs.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/power/supply/power_supply_sysfs.c b/drivers/power/supply/power_supply_sysfs.c
index d483a81560ab0..977611e163739 100644
--- a/drivers/power/supply/power_supply_sysfs.c
+++ b/drivers/power/supply/power_supply_sysfs.c
@@ -15,6 +15,7 @@
 #include <linux/power_supply.h>
 #include <linux/slab.h>
 #include <linux/stat.h>
+#include <linux/string_helpers.h>
 
 #include "power_supply.h"
 
@@ -398,14 +399,6 @@ static const struct attribute_group *power_supply_attr_groups[] = {
 	NULL,
 };
 
-static void str_to_lower(char *str)
-{
-	while (*str) {
-		*str = tolower(*str);
-		str++;
-	}
-}
-
 void power_supply_init_attrs(struct device_type *dev_type)
 {
 	int i;
@@ -420,7 +413,8 @@ void power_supply_init_attrs(struct device_type *dev_type)
 				__func__, i);
 			sprintf(power_supply_attrs[i].attr_name, "_err_%d", i);
 		} else {
-			str_to_lower(power_supply_attrs[i].attr_name);
+			string_lower(power_supply_attrs[i].attr_name,
+				     power_supply_attrs[i].attr_name);
 		}
 
 		attr = &power_supply_attrs[i].dev_attr;
-- 
2.53.0



