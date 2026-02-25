Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8193002D1;
	Wed, 25 Feb 2026 06:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002677; cv=none; b=Id0jViJClcFs2jvMrwHJ+SLJV7T78Qtk+w+cA6WinYA0EZOLBDJiRLRvsiycfJ30pglZaUyXi0OgvDvB9Xrdn5UpbDlYp9DjhqvlA16q6NggE9xL6q2I+3RH36XIdAcqM4LWJ3W1eSdfN5+3uYHVaCPH41osTIPoRCHeArvrkAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002677; c=relaxed/simple;
	bh=ueQnDowFs5zK7DRsM1wKj9JI+MrIIn6Icu0ztQOgzs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECK8mUpq20CuqR2epvio51fOwibwadGxzrmepQSD2UTVD0om6q73x3pGoi5j5D2VZoZmgQgcNG0etTHcfBjd2s3hi2Mp7ijUR3QzsZ73Ei3+7KbVzNzhtzReT5ZVcf8KATWdXxWUnwYt76n6p4kNC3oEUAL2sTTerK1qVJaRq5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctvHGrgj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctvHGrgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08946C19425;
	Wed, 25 Feb 2026 06:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002677;
	bh=ueQnDowFs5zK7DRsM1wKj9JI+MrIIn6Icu0ztQOgzs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ctvHGrgjmse7mtuVhFpXBxQd1+nJ+SltNtzmtP19lmKKY7Qb4Vni+FH70yAJYHL9a
	 puRV9d1f48X2YNlyairJ0NhInCgOfy0zY+E7X8/9h4Cu4WE2ifmP3W6pc3sZroYAhG
	 sqz3g/grW3j63A/fivUEsUItlC3DILPB+r2zLQlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 461/641] serial: imx: change SERIAL_IMX_CONSOLE to bool
Date: Tue, 24 Feb 2026 17:23:07 -0800
Message-ID: <20260225012359.685514450@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 282116765e648..0981288d19c2c 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -486,14 +486,14 @@ config SERIAL_IMX
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



