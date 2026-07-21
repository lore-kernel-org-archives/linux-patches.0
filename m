Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8208846D56D;
	Tue, 21 Jul 2026 18:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658980; cv=none; b=k+n2lGkxt2briU9Z/Lx7qr/AkaleVOqmie1T2e+LxFli8sIMxMDzABi7BGgp7eEfstZB1IMP7AD/WuBecuVQ3niUnh+v9S15Um1Qky0Ndmr3ez48KQ7zvrDF0st+6Ue9gtZAUqr8coXne8Zpqq2Akkq/hNwQJD9IHHlKPNyx25w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658980; c=relaxed/simple;
	bh=ULDwTcpY4DVOuX5FpJOPQaCvLhk9VypJ3AwrwSjxerg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifJlvbL/aAxkKGCH7A5yKJUkwfWWX7+hbCUC28o2SVlh59yludEWXw6NQo4KbbK2sgRS4OFySHdicdcy0Ij6m2ek8HVoqlOJ0jfsvvMor5nhd9vZ2AZtXxk/Hn7zjUa1s2avzQrFqhgk4KS8JNc94nBitayoX4fPrSsbbl48JXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmqO+ncP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmqO+ncP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B241F000E9;
	Tue, 21 Jul 2026 18:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658978;
	bh=4k4+DVDOyznOZUAte7x2DrL67Hh50W0h+UqPmAGH32E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CmqO+ncPWSCPWEh7taqMM8UochgPj4ny9aVZ5YcDGlAVfU0EYeStvOY5qnupB1HXy
	 0KOERFc4LXytI2Y8LTzsbayQleYr02+/agKrvm30itP46DNwBdS4TpIIr2WLAQqwM2
	 vDG67U+NDLby0CtFvHWxgRuK/+W6vF1I3sw91A88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 1305/1611] hwmon: (ltc2992) add missing select REGMAP_I2C to Kconfig
Date: Tue, 21 Jul 2026 17:23:41 +0200
Message-ID: <20260721152544.803826346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit a35a6f1b20100057c66b7be5a8f6864661c3945c upstream.

The Kconfig entry for the LTC2992 sensor doesn't contain a
`select REGMAP_I2C` parameter, causing build failures if regmap
isn't selected previously during the build process.

Fixes: b0bd407e94b0 ("hwmon: (ltc2992) Add support")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Link: https://lore.kernel.org/r/20260629-add-kconfig-deps-v1-2-8104df929b1a@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1086,6 +1086,7 @@ config SENSORS_LTC2992
 	tristate "Linear Technology LTC2992"
 	depends on I2C
 	depends on GPIOLIB
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for Linear Technology LTC2992
 	  I2C System Monitor. The LTC2992 measures current, voltage, and


