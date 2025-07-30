Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629F3226D17;
	Wed, 30 Jul 2025 09:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869021; cv=none; b=DJBm6eBydK49eH0WUpTVy1H7+nEOYTNpFl9jEoFA+APvRjMSZraFdUYJDlZitOib0j9hI11up2pwkzGQJ8vbajrAXT0PEAa8DnXGwOqmwjCUMr4mJnAL36ysFEgxFJxuiHwqO71ROoYSUG6L5pLx1bDbtR5do5ou1B0JzsHElYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869021; c=relaxed/simple;
	bh=XSYwBgke3tBq7uJk1YuSalUv2VLaEP8J/fV+X0G+mLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LTGdzddbxx8BQB/PivFGRcjwJnPMZ+6RyORe0eZubfw38f9FtEwEruRwZIJf4suauOcsF3vG45FQOZ1oe4wthOzzJJry4W53oZnGKQ/us5vhSFTaLbvV0VRnuFyWP7rtFKTfyYmTuhBI94nUt3v859jjR0TXq+3Y7ZKSRC9hH64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QmcN65w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QmcN65w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D4CC4CEF6;
	Wed, 30 Jul 2025 09:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869021;
	bh=XSYwBgke3tBq7uJk1YuSalUv2VLaEP8J/fV+X0G+mLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1QmcN65wXc8gIBG1XFu+JBf9Y2VqNYTh/vr73CPadOnb552l+Wiy+7kQrmjSN4G++
	 94DwJ0hkxBP8rP2ZaEdyCic8v7O3f7ZDTN0VcZNjh0+PZrrf6ERGFUb+hDq5E1lR+W
	 vSrMeqokuKbmqdOcBYflHaXk0TRjbgp0riDjqfAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Torsten Hilbrich <torsten.hilbrich@secunet.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 18/92] platform/x86: Fix initialization order for firmware_attributes_class
Date: Wed, 30 Jul 2025 11:35:26 +0200
Message-ID: <20250730093231.322317758@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Torsten Hilbrich <torsten.hilbrich@secunet.com>

[ Upstream commit 2bfe3ae1aa45f8b61cb0dc462114fd0c9636ad32 ]

The think-lmi driver uses the firwmare_attributes_class. But this class
is registered after think-lmi, causing the "think-lmi" directory in
"/sys/class/firmware-attributes" to be missing when the driver is
compiled as builtin.

Fixes: 55922403807a ("platform/x86: think-lmi: Directly use firmware_attributes_class")
Signed-off-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Link: https://lore.kernel.org/r/7dce5f7f-c348-4350-ac53-d14a8e1e8034@secunet.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 650dfbebb6c8c..9a1884b03215a 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -58,6 +58,8 @@ obj-$(CONFIG_X86_PLATFORM_DRIVERS_HP)	+= hp/
 # Hewlett Packard Enterprise
 obj-$(CONFIG_UV_SYSFS)       += uv_sysfs.o
 
+obj-$(CONFIG_FW_ATTR_CLASS)	+= firmware_attributes_class.o
+
 # IBM Thinkpad and Lenovo
 obj-$(CONFIG_IBM_RTL)		+= ibm_rtl.o
 obj-$(CONFIG_IDEAPAD_LAPTOP)	+= ideapad-laptop.o
@@ -122,7 +124,6 @@ obj-$(CONFIG_SYSTEM76_ACPI)	+= system76_acpi.o
 obj-$(CONFIG_TOPSTAR_LAPTOP)	+= topstar-laptop.o
 
 # Platform drivers
-obj-$(CONFIG_FW_ATTR_CLASS)		+= firmware_attributes_class.o
 obj-$(CONFIG_SERIAL_MULTI_INSTANTIATE)	+= serial-multi-instantiate.o
 obj-$(CONFIG_TOUCHSCREEN_DMI)		+= touchscreen_dmi.o
 obj-$(CONFIG_WIRELESS_HOTKEY)		+= wireless-hotkey.o
-- 
2.39.5



