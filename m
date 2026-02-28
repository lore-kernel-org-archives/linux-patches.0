Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B710636C9D4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302221; cv=none; b=dRh1cdvSN2rzQ7YCMllF4qcd2EbyK3iqI5qdUNKHZUv8nYhE7ESXBmKqKCkj/vA8FNEmPToolr/dFZ2y4+6P0YEszPNhzD2KOaLXrfCzH5xcKo/4CHAFqbC0P6RmWg9wXoDkVeiOdwr4ebzYdkM7WhsBm6XNEkF7HSwYXG4jsNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302221; c=relaxed/simple;
	bh=cHxSiyQhinjVG7pUN/aAN9Ujqx04tqRfKT21F20gIGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d06vrONUyHoDMAQXo8D6GPhSV/vXgM5M5Rky6ICaOVAHlMmPKmhHrz49xpAWnEK7dr+oxFJF7ILtOTHpTGGtusfAKZ/9iUD0XDfEIZjPHmB6HjPNnmJvL92RLq+BwnZ24xqmIAAqSmhkCaufGhecGoffbQP3xHnif2+gKefPPZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UxHnl3aq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UxHnl3aq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDADC19423;
	Sat, 28 Feb 2026 18:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302221;
	bh=cHxSiyQhinjVG7pUN/aAN9Ujqx04tqRfKT21F20gIGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxHnl3aqUtNt097IaYrrtNiqCXrvOq+e+0VnbMMILfe2SPU6XWXwCNmtxn2mDYBQW
	 BStSM5ji1KTF8rOfn7Ldk5wLlKNaPQmomM9szkOyhept15e7idxIufNCR/jtEtzDvi
	 utzbV0AzaXbBZsG2P8/yucuW7ly5CD5Sjoc8mkcAMuhpu268F3VEN6ZgF7d7ZT4302
	 7NbXPNBnxr/QABxfSyReHH1SYEOebowgurQmjVrCT5TKZsugGFIwVxSbv24bhhOHWt
	 CAdQ94Fr0MK1PLaHXpqSCWE9bW3HMfpT44j6mhvCXG5A1yW6g5hjcuBJgicyS6Jfgy
	 R+u79330Jj4gg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 229/283] serial: imx: change SERIAL_IMX_CONSOLE to bool
Date: Sat, 28 Feb 2026 13:06:11 -0500
Message-ID: <20260228180709.1583486-229-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 4f57833e3ec74..ac74b491ba50b 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -479,14 +479,14 @@ config SERIAL_IMX
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

