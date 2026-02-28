Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3871347FCC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302448; cv=none; b=mk0QBkcrFey8f5YXccYYjf+X5xJbPQD/0nQ23qI50ixa7Ix+DUjMHhnBwhtLvmUY40uZIe46hjCuKM6UNevgT1uL1M894948g578I01cb5wxt5oUZscJ197GPSQRRQoFBrzKxOJEU6hICMVDShS0ipiRiIru6s5LEKIVt/CS6Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302448; c=relaxed/simple;
	bh=aYbuFL337hrTzWhO5ucTTy4qxzqbuhcM84CqDCzw1Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5U8l1QKXW5DEPX18Lre9SPjA68Rp1H7ZNr5R5ljE8ghT8l6e4OIcI92rs3Sjcs44ez3W13eQHy0N31Hvhw8IokgHwl6tnO0iF215ugSP1Y5rAUQPNasH/5Dt1SliAWT0ZasMTnXOctOgrIov4dqBSfcIZ74xE4ValTCnN3wiec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gk2dJzlf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gk2dJzlf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A29C116D0;
	Sat, 28 Feb 2026 18:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302448;
	bh=aYbuFL337hrTzWhO5ucTTy4qxzqbuhcM84CqDCzw1Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gk2dJzlfRsuo8iv9k4Rq1QdoJeThd56kChIW2jggmxEjXP+tJ7Oddr/0rdPHjpTHC
	 P2MWfHf5wY4gevKMdHNjwMguwcUSo6D6zLjS4AmFuE8gWzyoPH9k/79lj7nV66HyQc
	 pa3dY+b6fPERs/3d/O2yw5qSagltsVFn3y3X2rby35XuM9vr2BNjx1lJ5NtvoYwAP/
	 BsdRL3gGMUL9WFrfRgKr7dSCVLCGWu9tw8ZVD9tj6I7GdlE7k3kCW9xhOQxRVKngXR
	 Xi+VhD/ctMK8TJf52yVpAdye96e3DMyXTLUrmkOoTuSL+IlMfeA+syQAy1dW7MlUbF
	 iQJJ3Pgkz9Nmw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/232] serial: imx: change SERIAL_IMX_CONSOLE to bool
Date: Sat, 28 Feb 2026 13:10:41 -0500
Message-ID: <20260228181127.1592657-188-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 71951b543d4c2..3c45956a1d454 100644
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

