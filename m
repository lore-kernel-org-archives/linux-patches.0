Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837C63A255A;
	Wed, 23 Sep 2026 14:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174017; cv=none; b=J6ZSl3xz776M1MD5YQ5Ri0VVyPEYDqywZxG2C/U1bt6BZDRy77qMUEP2TNC+/WhrFxC7axnt0WWN/Db7V7PIbzcL+16satRxsvCmT/0Ug8Mmq2qJ3Oi2QX2XZlSRkM0wwI8KWD0VXa4JfVvR9Qu0KhcOUPs/NZfT9wqaBlS/NaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174017; c=relaxed/simple;
	bh=8B7LlOsvqePBu129f3uVAgsEk0iBmW+IAAoHKXSn0s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jv1X5YoCxCVrY/ngPbA5Yv5aZwdtkshjYSbRxl16VL0I0sPEGgBBP6dIpvGH43U50OaedlfvESPPhR7QRpTQFtW0Y2NsJDSexe3O8QCaQ8dgxxHZMrgoB3WjKtSlC+eUPIfZQRfeYSheHYgirlS0Hl0CmP6DDTqSmRYOOvHxe8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrZrWSHb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrZrWSHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BCE1F000FF;
	Wed, 23 Sep 2026 14:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174016;
	bh=SEWCOucirDKfbR/Mb0HjGukfnLcphQbeH9sAQIo+jR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrZrWSHbY4Gzjo6o9npCf7/D4LuWrv7AIAaXcHIj/TK91HvAq94BF8i9pne8zOUYL
	 33vDL9pdq05sY8QNgu4+Uxjhy4MpPUJu9p3g+GJsUy3+DCP8RLGmzVaIU4F7+kglHO
	 +eT09retXOXkq12VzRuYgeaDrNN9rFaHt9o+Igr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 366/438] hwmon: (pmbus/core) increase number of phases and add new mask
Date: Wed, 23 Sep 2026 16:06:27 +0200
Message-ID: <20260923140654.342833376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

commit 06bd6794b5fd2163880ac3bfe973d4cc61f359f3 upstream.

Increase the number of phases to 16 as a new upcoming device supports
such a number.

While at it, add a new mask for controlling the source of the output
voltage.

Note (groeck):

This patch was meant to prepare for support of MAX20826 and compatible
devices, which support more than 10 phases per page. However, Sashiko
reports that the mp2975 driver already supports up to 14 phases, and the
mp2856 driver supports up to 12 phases. This already has the potential for
out-of-bounds writes when probing the affected chips, making this patch a
bug fix.

Fixes: 2c6fcbb21149 ("hwmon: (pmbus) Add support for MPS Multi-phase mp2975 controller")
Fixes: f9e5f289b686 ("hwmon: (pmbus) Add support for MPS Multi-phase mp2856/mp2857 controller")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20260911-hwmon-max20826-support-v2-1-5e30cbd97d84@analog.com
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/pmbus.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -242,6 +242,7 @@ enum pmbus_regs {
 /*
  * OPERATION
  */
+#define PB_OPERATION_CONTROL_V_SRC	GENMASK(5, 4)
 #define PB_OPERATION_CONTROL_ON		BIT(7)
 
 /*
@@ -386,7 +387,7 @@ enum pmbus_sensor_classes {
 };
 
 #define PMBUS_PAGES	32	/* Per PMBus specification */
-#define PMBUS_PHASES	10	/* Maximum number of phases per page */
+#define PMBUS_PHASES	16	/* Maximum number of phases per page */
 
 /* Functionality bit mask */
 #define PMBUS_HAVE_VIN		BIT(0)


