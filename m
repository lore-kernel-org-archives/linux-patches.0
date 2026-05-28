Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8C4352019;
	Thu, 28 May 2026 20:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999250; cv=none; b=CNvkSiKnpTeqfaz5Zt6pGc6VjS/fHVZWtP6KS3RV9gBM/Lz0NS7KQY/JikDp2f9vwSo4quUpnQhoL/k9jKzoNEDmGmaOoTlXxNG1D3lsCf9j8mL9FNVdV/sxezvyC6ZViHzcC4GiSmK7os4YZbXa2KpjVV5qEZXeHMgdb3jMRVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999250; c=relaxed/simple;
	bh=ORXnBcUUs1rsKdn5NivTJOlUSMSs+M90mwQVnX9BxgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k437L58HiyQunvNZBaf5UJIL2HxY0bYasI3e+xpFevyi7gnYwFYD+Y7uEjwd1Ly0dldC7dmPN92IgZODGu77n/G1j3rjdX9yfHduGvZSxeo5NRl/AN4mEwn/P0zJNqabLKBGW2WuJadG+XAg09jVpdzNWNUAU8fmJuYTek7G0as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Gq8Uoji; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Gq8Uoji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6C91F000E9;
	Thu, 28 May 2026 20:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999249;
	bh=k3vdENpsL+uogjQxBdioSPBTnDaCvBqLo2V8/mOYJF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Gq8Uojia02neeHV3gswBx5svRODKOpZRXJzEohOUjGDF3qAkNbt0muBmRiXqy40J
	 dw+40Xo86VLSPsu2VY+MayqQGgdxw1hHHQGRQkl04NmjiuiPUkIGbDNTsuiZBbsR99
	 LE0M567wfP4HFqr4AX+UUfiNb/DpGXEAUqIgLF/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Werner Sembach <wse@tuxedocomputers.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 460/461] Documentation: laptops: Update documentation for uniwill laptops
Date: Thu, 28 May 2026 21:49:49 +0200
Message-ID: <20260528194700.855540272@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

[ Upstream commit 9ec6bf62cf98e30c7126a0f51ee7cdf2e8d458b6 ]

Adds short description for two new sysfs entries, ctgp_offset and
usb_c_power_priority, to the documentation of uniwill laptops.

Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260324203413.454361-6-wse@tuxedocomputers.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 26cbe119f99c ("platform/x86: uniwill-laptop: Do not enable the charging limit even when forced")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ABI/testing/sysfs-driver-uniwill-laptop   | 27 +++++++++++++++++++
 .../admin-guide/laptops/uniwill-laptop.rst    | 12 +++++++++
 2 files changed, 39 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-uniwill-laptop b/Documentation/ABI/testing/sysfs-driver-uniwill-laptop
index 2df70792968f3..2397c65c969a6 100644
--- a/Documentation/ABI/testing/sysfs-driver-uniwill-laptop
+++ b/Documentation/ABI/testing/sysfs-driver-uniwill-laptop
@@ -51,3 +51,30 @@ Description:
 
 		Reading this file returns the current status of the breathing animation
 		functionality.
+
+What:		/sys/bus/platform/devices/INOU0000:XX/ctgp_offset
+Date:		January 2026
+KernelVersion:	7.0
+Contact:	Werner Sembach <wse@tuxedocomputers.com>
+Description:
+		Allows userspace applications to set the configurable TGP offset on top of the base
+		TGP. Base TGP and max TGP and therefore the max cTGP offset are device specific.
+		Note that setting the maximum cTGP leaves no window open for Dynamic Boost as
+		Dynamic Boost also can not go over max TGP. Setting the cTGP to maximum is
+		effectively disabling Dynamic Boost and telling the device to always prioritize the
+		GPU over the CPU.
+
+		Reading this file returns the current configurable TGP offset.
+
+What:		/sys/bus/platform/devices/INOU0000:XX/usb_c_power_priority
+Date:		February 2026
+KernelVersion:	7.1
+Contact:	Werner Sembach <wse@tuxedocomputers.com>
+Description:
+		Allows userspace applications to choose the USB-C power distribution profile between
+		one that offers a bigger share of the power to the battery and one that offers more
+		of it to the CPU. Writing "charging"/"performance" into this file selects the
+		respective profile.
+
+		Reading this file returns the profile names with the currently active one in
+		brackets.
diff --git a/Documentation/admin-guide/laptops/uniwill-laptop.rst b/Documentation/admin-guide/laptops/uniwill-laptop.rst
index aff5f57a6bd47..561334865feb7 100644
--- a/Documentation/admin-guide/laptops/uniwill-laptop.rst
+++ b/Documentation/admin-guide/laptops/uniwill-laptop.rst
@@ -50,6 +50,10 @@ between 1 and 100 percent are supported.
 Additionally the driver signals the presence of battery charging issues through the standard
 ``health`` power supply sysfs attribute.
 
+It also lets you set whether a USB-C power source should prioritise charging the battery or
+delivering immediate power to the cpu. See Documentation/ABI/testing/sysfs-driver-uniwill-laptop for
+details.
+
 Lightbar
 --------
 
@@ -58,3 +62,11 @@ LED class device. The default name of this LED class device is ``uniwill:multico
 
 See Documentation/ABI/testing/sysfs-driver-uniwill-laptop for details on how to control the various
 animation modes of the lightbar.
+
+Configurable TGP
+----------------
+
+The ``uniwill-laptop`` driver allows to set the configurable TGP for devices with NVIDIA GPUs that
+allow it.
+
+See Documentation/ABI/testing/sysfs-driver-uniwill-laptop for details.
-- 
2.53.0



