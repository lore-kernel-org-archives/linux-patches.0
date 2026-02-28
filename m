Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36CB35AC32
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302753; cv=none; b=cXw5iQpZFrSbm4FkEaOQjmHfBulzLOO4P8/Bksp0cZ5QBnTynQ4S1Iwuy0fYcSpywImorwQGIfioLNhycdy1DsLciMB7d1fYccnghrIbY/yEuqdQMPAoCxsK362UE9aV3KGwCsimc4a5q+xIZVJuw3yRTQWzrexsLLTinEdIbEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302753; c=relaxed/simple;
	bh=2Np2MNwQkc2MkGCyS0MJ9qYcOEQ2fYakNqwf1fG20Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8wn/yoVqZnJ3Q85+A9XTX6uVW9w0vpgfc/wYtfSZepFa/cUkFOGKv8J9eroB2Pb64BHQWE3edfJ8de7Ux/aywFXBGKxwlnIRVacV4ZfVoW1SPPeP6yU9SPMlB7ZjOkKdN6g+O9oIFGqI7+bco10in2WUvRaqV4SqnmRWML8wdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cRq6w9V4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cRq6w9V4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11360C19424;
	Sat, 28 Feb 2026 18:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302753;
	bh=2Np2MNwQkc2MkGCyS0MJ9qYcOEQ2fYakNqwf1fG20Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRq6w9V4kiS56qOykGYpD+wr/Xz8vovIFvm2zdHz3J+l60iDBdGFoEMOLz67s+uws
	 alcAAHB7tanS+lCwSR6YCH69TXoX0igNcZwIUZw4bhWX275dGPmcqJVTNOj0QRby5z
	 ZGs5rLZEPOBuz3xM0QR/BLlbiv+5HHdVqpTpjQDKt0gF+pHFMHSmTOeVFucQTxJyFn
	 v87sRdn5SzS41AYjystmAyVPgHG0Gw881qVMSOXsdw3L47vyIsID7gz3B4c/lCj8Zl
	 afvjghJAslwe01qnpZnGjZgNpGG1rKzhqrD01p7O7QDrs05ke4x9DRCRS4RckJvJ2P
	 dwsE0XzTyFHiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/147] serial: imx: change SERIAL_IMX_CONSOLE to bool
Date: Sat, 28 Feb 2026 13:17:10 -0500
Message-ID: <20260228181736.1605592-122-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 1ddaa5e7d4906..324787c2616c5 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -504,14 +504,14 @@ config SERIAL_IMX
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

