Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625815;
	b=CHgnHa2ds803dha29P3wWZoNidOUBhS/rrH6XOIB3bnKgh4FGRmtn4P9/k5q6szl2oQu
	 k2xT/0p/lNd8syn0tCB7NiqGxHtmkQjk2AIMVk81NhAZaT9n78K/VFldQQ+/551lPdalG
	 JiR60qeROpks3W0WHtbxeBU23isTP8WCRUfP+qEKJmeqxFKk4a4fWkEo/k28TFI5vByR3
	 dCG9WAiAnaIZoOwUWX1TKq22Q1EfAtmb0NgbU3Cg+NTqLubmR1J4sYGRDw+ukCmpJwBSI
	 8B4bsMI/xv80ISVQhErTu4IAxHLl1K+x+3znmEqKJIFunM8MTXkyuysVlrwvIMMS0Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W7jnTn/R+5+AZfoNTtC6yRPoyVJ7bgSAhZiTKHJ74Zo=;
	b=TxCLkQou8i26OLfHvwI6tmjscLecKE34hE7hsQTX9SuZC5thB5Sc+FCkdjor6gGHLUe/
	 q99AKwf58RKTjyndSfV7+9JXwv6mgJAh5EAeN+xkqm4aahy/LyWGMhJbf20k6X0Fpz4uL
	 mQgVa9NAYcaHQFJPGGhcJ5+2XVxMCvbjq3bZjNFLV9RjHPBysodKKkAKOkRfluz8VamVz
	 97hl0nD57lUJBLn+v2FlLy0c20+Op0+7ewwuG0XmwVpFgOVEGIms3qrTTbPCnydw1YgvR
	 N4YkKcrBlpWVD59IBh9T+URFex8I+Slht9VDrCYau6LQjTHkAMtfPWzO5RF+FNxg3pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KBHpjcT2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DD8606A331;
	Wed, 25 Nov 2026 16:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KBHpjcT2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AD71F000C0;
	Wed, 25 Nov 2026 16:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625815;
	bh=W7jnTn/R+5+AZfoNTtC6yRPoyVJ7bgSAhZiTKHJ74Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KBHpjcT25zcJwPG1/OMFf6gxarv+7FFPKRoY0JRpkn/c8Dw6M4DAlUKQ9mzyDOi7Q
	 n78hKQFoVxoeXH0KBYUBKA32DMXei7fE89Pm2e3IiyVqN/qILBIa/ZC9XxHoHeQgiP
	 05MMZsGt/ZkNeekO2gpXqb7iMEfQoKN3NFAIdLBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Aleksandrov <lightofmysoul@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 639/816] hwmon: (max31760) Fix the local temperature limit registers
Date: Wed, 25 Nov 2026 15:36:27 +0100
Message-ID: <20261125143903.975120249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Aleksandrov <lightofmysoul@gmail.com>

commit 028ed93145d9be88eee670088ef13482b5d36c1a upstream.

temp2_max and temp2_crit use each other's registers, so reading them
shows the local limits swapped and writing temp2_max changes the
overtemperature (SHDN) threshold.

Use the high limit (0x0C) for temp2_max and the overtemperature limit
(0x08) for temp2_crit.

Fixes: 38b04ad02d0d ("drivers: hwmon: Add max31760 fan speed controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Link: https://patch.msgid.link/20261108-max31760-fixes-v1-1-a61450463059@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/max31760.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/max31760.c
+++ b/drivers/hwmon/max31760.c
@@ -27,8 +27,8 @@
 
 #define REG_TACH(ch)		(0x52 + (ch) * 2)
 #define REG_TEMP_INPUT(ch)	(0x56 + (ch) * 2)
-#define REG_TEMP_MAX(ch)	(0x06 + (ch) * 2)
-#define REG_TEMP_CRIT(ch)	(0x0A + (ch) * 2)
+#define REG_TEMP_MAX(ch)	((ch) ? 0x0C : 0x06)
+#define REG_TEMP_CRIT(ch)	((ch) ? 0x08 : 0x0A)
 
 #define TEMP11_FROM_REG(reg)	((reg) / 32 * 125)
 #define TEMP11_TO_REG(val)	(DIV_ROUND_CLOSEST(clamp_val((val), -128000, \


