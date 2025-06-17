Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457BB239561;
	Tue, 17 Jun 2025 16:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178770; cv=none; b=RbWwJsuxCxWleT5E5K1MMfIw1PU/NnYeA+SCxfBatoiwQsHdb/59Cg3NPVXcXWLTTqbhcPxD8DdMsXemCaRbnOq+MgS+jU9t4m7AaQQWFxzWZnKyj2gOQnvIr8VtcCt8dAqUrZu/2mDba1RrHgFvIEiJk5Fapx0a5WhAmY1ZdPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178770; c=relaxed/simple;
	bh=Sd48opIUpeSHApqDRF8B9IgLjMupzvT8xu7MR7XmKps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCiwCYCNZzjmjCbAo1P6eq63VKwcCFnm2PshEX1eZC/tiwra/5BPm+R98IyfY2CSdZnMa54fC6S58a/UZBUE2sk2QgHBIZe3scM5qbjgRkQXr0K6i6XfToIcZ/zBWbFtKUqpkc5Oid5bJhiBV5gKoCq2OSDIXtmtIMWSDI3PAaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/1ZMpNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/1ZMpNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB272C4CEE7;
	Tue, 17 Jun 2025 16:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178770;
	bh=Sd48opIUpeSHApqDRF8B9IgLjMupzvT8xu7MR7XmKps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/1ZMpNWYnQvOsHmqp2E9rUi3ilhp7lQ3gfhXXv5iO8oah0BHfKyob8IygfPIe3vd
	 To3NTiksvXgN9H0lE7oGek/ZoiiGkDycW5ywJ8xc5fM80kRbjWsDWwo411vh096U7y
	 Bl2vTLyd/IJB4WKAxEAFF+y4k5EMz4Jrucmj108g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roxana Nicolescu <nicolescu.roxana@protonmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 541/780] misc: lis3lv02d: Fix correct sysfs directory path for lis3lv02d
Date: Tue, 17 Jun 2025 17:24:09 +0200
Message-ID: <20250617152513.544266490@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roxana Nicolescu <nicolescu.roxana@protonmail.com>

[ Upstream commit 7b386d7454b610534026b279aa150e5a9e584082 ]

The lis3lv02d driver does not create a platform device anymore. It was
recently changed to use a faux device instead. Therefore the sysfs path
has changed from /sys/devices/platform/lis3lv02d to
/sys/devices/faux/lis3lv02d.

Fixes: 3b18ccb5472b ("misc: lis3lv02d: convert to use faux_device")
Signed-off-by: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
Link: https://lore.kernel.org/r/20250506110002.36477-1-nicolescu.roxana@protonmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/misc-devices/lis3lv02d.rst | 6 +++---
 drivers/misc/lis3lv02d/Kconfig           | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/misc-devices/lis3lv02d.rst b/Documentation/misc-devices/lis3lv02d.rst
index 959bd2b822cfa..6b3b7405ebdf6 100644
--- a/Documentation/misc-devices/lis3lv02d.rst
+++ b/Documentation/misc-devices/lis3lv02d.rst
@@ -22,10 +22,10 @@ sporting the feature officially called "HP Mobile Data Protection System 3D" or
 models (full list can be found in drivers/platform/x86/hp_accel.c) will have
 their axis automatically oriented on standard way (eg: you can directly play
 neverball). The accelerometer data is readable via
-/sys/devices/platform/lis3lv02d. Reported values are scaled
+/sys/devices/faux/lis3lv02d. Reported values are scaled
 to mg values (1/1000th of earth gravity).
 
-Sysfs attributes under /sys/devices/platform/lis3lv02d/:
+Sysfs attributes under /sys/devices/faux/lis3lv02d/:
 
 position
       - 3D position that the accelerometer reports. Format: "(x,y,z)"
@@ -85,7 +85,7 @@ the accelerometer are converted into a "standard" organisation of the axes
 If your laptop model is not recognized (cf "dmesg"), you can send an
 email to the maintainer to add it to the database.  When reporting a new
 laptop, please include the output of "dmidecode" plus the value of
-/sys/devices/platform/lis3lv02d/position in these four cases.
+/sys/devices/faux/lis3lv02d/position in these four cases.
 
 Q&A
 ---
diff --git a/drivers/misc/lis3lv02d/Kconfig b/drivers/misc/lis3lv02d/Kconfig
index bb2fec4b5880b..56005243a230d 100644
--- a/drivers/misc/lis3lv02d/Kconfig
+++ b/drivers/misc/lis3lv02d/Kconfig
@@ -10,7 +10,7 @@ config SENSORS_LIS3_SPI
 	help
 	  This driver provides support for the LIS3LV02Dx accelerometer connected
 	  via SPI. The accelerometer data is readable via
-	  /sys/devices/platform/lis3lv02d.
+	  /sys/devices/faux/lis3lv02d.
 
 	  This driver also provides an absolute input class device, allowing
 	  the laptop to act as a pinball machine-esque joystick.
@@ -26,7 +26,7 @@ config SENSORS_LIS3_I2C
 	help
 	  This driver provides support for the LIS3LV02Dx accelerometer connected
 	  via I2C. The accelerometer data is readable via
-	  /sys/devices/platform/lis3lv02d.
+	  /sys/devices/faux/lis3lv02d.
 
 	  This driver also provides an absolute input class device, allowing
 	  the device to act as a pinball machine-esque joystick.
-- 
2.39.5



