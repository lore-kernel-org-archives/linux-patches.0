Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5218D33A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301896; cv=none; b=OLvUta8WXH72n82a6egaR2qfyDUspQz78v9D0PQBbZSta4iF70pT5aBF19Ii8ZQEFKtC5J9gPCKbziXhU1A1TJ2EPZSiqVEXu9tomkH7jJ4wsuuUm0eb+gMTnqUk6sAAXQPLTH45imj2fMpafYA9RijiVU9lkDX9zJz1fuy2Hzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301896; c=relaxed/simple;
	bh=j6YkyspYSr/LO1oPh6xluu40ku2zVh1D4GS0V0Ak5fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqmiV+BQSTeyi22rd2Gab8MYa3vX9Pxi5lNHD0EFpn/gYgeirP+Fc94yrzhnBvEB0TIRHAJeljAmdXpxFEzkeTyxBcpmyfydnejTn7ZlozuTb28XNYyj9x5K7bmvj3IZ9BbD/q2XXHqMBqj8b+As4sFijtgjNPcuOIzF/oVpbA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=faGMUQQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="faGMUQQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7F3C19423;
	Sat, 28 Feb 2026 18:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301896;
	bh=j6YkyspYSr/LO1oPh6xluu40ku2zVh1D4GS0V0Ak5fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faGMUQQIp7WuxNm2Ns1VSWx7J/z4IFKlxfZBpy6NxtGYwuBg/U23576rq4ltW/u3F
	 YOV+hIQTg4YHbBp7nthIPgGVDnM5rzdCHiiUddcOy564mgICwVrVPQH1wruGGnCf7G
	 tc6wWH5/J59S5BePRllIAMheLQT8fMyq8KFOVq/O4S4uBsmDDToD4xLNf8e/QUKipt
	 Cg/6T9Neq2GlgcWWLoWUaoSHnODEBDIvvk6Ti5XSXgdYRMc5FQrDhWlzMbYmQeIeP8
	 QeIXPnC4ubLEOsrcT8SFyAbiu/3j/bvuwEdEPRvmQ3I5RIeHkhS16ji78lkz0sGfRb
	 zjGkcujHeqqNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 324/385] serial: imx: change SERIAL_IMX_CONSOLE to bool
Date: Sat, 28 Feb 2026 12:59:06 -0500
Message-ID: <20260228180011.1568201-324-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 79527d86ba91c2d9354832d19fd12b3baa66bd10 ]

SERIAL_IMX_CONSOLE is a build option for the imx driver (SERIAL_IMX).
It does not build a separate console driver file, so it can't be built
as a module since it isn't built at all.

Change the Kconfig symbol from tristate to bool and update the help
text accordingly.

Fixes: 0db4f9b91c86 ("tty: serial: imx: enable imx serial console port as module")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260110232643.3533351-2-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 4fd789a77a13b..09987529b8ba4 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -482,14 +482,14 @@ config SERIAL_IMX
 	  can enable its onboard serial port by enabling this option.
 
 config SERIAL_IMX_CONSOLE
-	tristate "Console on IMX serial port"
+	bool "Console on IMX serial port"
 	depends on SERIAL_IMX
 	select SERIAL_CORE_CONSOLE
 	help
 	  If you have enabled the serial port on the Freescale IMX
-	  CPU you can make it the console by answering Y/M to this option.
+	  CPU you can make it the console by answering Y to this option.
 
-	  Even if you say Y/M here, the currently visible virtual console
+	  Even if you say Y here, the currently visible virtual console
 	  (/dev/tty0) will still be used as the system console by default, but
 	  you can alter that using a kernel command line option such as
 	  "console=ttymxc0". (Try "man bootparam" or see the documentation of
-- 
2.51.0

