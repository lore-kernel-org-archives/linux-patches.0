Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E658239B974
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302618; cv=none; b=NuBipCjjq/3b0qK7NttrhuE8qpuAAgrwC7ETS+LW4rxHvqxTmnhIk3pmmeSJPunXDejtmIay7zr/z2EL/kzqqhkTti9dkdKmPkd0nhrLztj3GlfM1LHaMnrCfykBko8MEOUijVQMgwVsZ4s9/VuFo4u2aCjBZb9dZJtLcM/qDzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302618; c=relaxed/simple;
	bh=60YBm+pf3MQj/qKUAGttXWNhphAyCBBhl96w3H0uWG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAA1T3i4/+tXZf35YsLZzTuYoyCViDlltbH1bCUnKhB2gF61dYnRasX0cTlxGYAFKE2YEwoRX456w/2Pfuq/pFEAA+Gd406b3mZRX8pWKJOXKxhoGg/0X0tZevl/KTZnms7dW6JPQ78cn8YXKOHAgZyCd2agfo3XGgGi6uG69aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLNuO7Wy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLNuO7Wy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59866C19423;
	Sat, 28 Feb 2026 18:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302617;
	bh=60YBm+pf3MQj/qKUAGttXWNhphAyCBBhl96w3H0uWG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLNuO7WyV8Tu8gCTVp3IKYePIN6XcVnevbKonZKeH6HvCneVkON7ZRMgp2DR4sqyc
	 J9q2cEKqhDCiTW9SLaZidvMSpF97+KUX4wRk/FpUo+OUpdqjbljRiveMXKr2NUKTXt
	 3Ox5dnzw5Wbnqlum8F2uTQ4ufdqwUg7kJgolBFSSMndKzPh5W+UnOcTeFSlWx3zyqM
	 dRGotX5Q4W1mNtTvFK8GNHHGUIDKhMVgjjdhmDjtkysMO4II1rmtW/9AkniyCYYBsZ
	 9AuY4mnG+MqJKJaGioBHuaxx9ORcjFa17w6OROEsOERzjoeAVcKAvgKsNviiKjxcv4
	 PlYzv/hhj6mlg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/164] serial: imx: change SERIAL_IMX_CONSOLE to bool
Date: Sat, 28 Feb 2026 13:14:34 -0500
Message-ID: <20260228181505.1600663-135-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 4fc5c043adf62..824d1a14d981f 100644
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

