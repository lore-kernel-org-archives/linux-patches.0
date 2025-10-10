Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1122F362F;
	Fri, 10 Oct 2025 13:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102396; cv=none; b=MHUFc6YPI1hu6VRM95lHjlilKwL6yREMpSvSqEOdWNh9pUl6PUI/kjChWaQ+5iMfeczbK8wC95Qomc0PYZ9AfO2t8iobEGTBzMFF+cWcha6KIlgRsksDdKpGFU1zy0gwlidZ1wogseRKd7IU6E/+MgTIRtZiEbLiL/z5yRv/HI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102396; c=relaxed/simple;
	bh=cZPzY/3RXItD0Qk5Pjlv0deOUEKg3i3QX74M6zdX5c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A3WsfjUhTjPBuAK76mMG/kBeLgHyqosYGLMK4ZIkZ2e5UJdbUFxqBCZklHW8VaY2d4/mm3Ob4wqclFq8O88IC/+gFpHzldAaXFMkPkm9YTsguM7OLtWZVjUhT1S62HiTLY//3P1AKNPOVgO7h+oNiNkhkc97nglkycZDv1o6PJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2Udg07Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2Udg07Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FD0C4CEF1;
	Fri, 10 Oct 2025 13:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102396;
	bh=cZPzY/3RXItD0Qk5Pjlv0deOUEKg3i3QX74M6zdX5c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2Udg07ZIwbvm0BMJeq7pQXWovzCbc/s5ctBqLprwVghA9bp15HY4RloQ38qS0qlL
	 UmBQWlCtQA4Fm7xX9j01EmbQdn4XeyjgQszRl2VyRGQNzjKlijYx9/WpI7EyAShGYf
	 Kw36SwrX3D625IG1l9ZtdsT6PT3j0fSnO8mZv1Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Akshay Gupta <Akshay.Gupta@amd.com>
Subject: [PATCH 6.16 30/41] drivers/misc/amd-sbi/Kconfig: select REGMAP_I2C
Date: Fri, 10 Oct 2025 15:16:18 +0200
Message-ID: <20251010131334.506877659@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit 5f8f84e286f11af4c954c14a57daffc80a1c3510 upstream.

Without CONFIG_REGMAP, rmi-i2c.c fails to build because struct
regmap_config is not defined:

 drivers/misc/amd-sbi/rmi-i2c.c: In function ‘sbrmi_i2c_probe’:
 drivers/misc/amd-sbi/rmi-i2c.c:57:16: error: variable ‘sbrmi_i2c_regmap_config’ has initializer but incomplete type
    57 |         struct regmap_config sbrmi_i2c_regmap_config = {
       |                ^~~~~~~~~~~~~

Additionally, CONFIG_REGMAP_I2C is needed for devm_regmap_init_i2c():

 ld: drivers/misc/amd-sbi/rmi-i2c.o: in function `sbrmi_i2c_probe':
 drivers/misc/amd-sbi/rmi-i2c.c:69:(.text+0x1c0): undefined reference to `__devm_regmap_init_i2c'

Fixes: 013f7e7131bd ("misc: amd-sbi: Use regmap subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Tested-by: Akshay Gupta <Akshay.Gupta@amd.com>
Reviewed-by: Akshay Gupta <Akshay.Gupta@amd.com>
Link: https://lore.kernel.org/r/20250829091442.1112106-1-max.kellermann@ionos.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/amd-sbi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/amd-sbi/Kconfig b/drivers/misc/amd-sbi/Kconfig
index 4840831c84ca..4aae0733d0fc 100644
--- a/drivers/misc/amd-sbi/Kconfig
+++ b/drivers/misc/amd-sbi/Kconfig
@@ -2,6 +2,7 @@
 config AMD_SBRMI_I2C
 	tristate "AMD side band RMI support"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  Side band RMI over I2C support for AMD out of band management.
 
-- 
2.51.0



