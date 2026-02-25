Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283C6243376;
	Wed, 25 Feb 2026 01:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983456; cv=none; b=p81tKdHXR6NSuLvRFZlQKN3rTi1ShEtnQ5mYCP0Ssupg7tt3FaQZMh8sG+BI/OhKTtjvhrhdAGSPyNK4xyclM99S22yx/+NbBd98ThZi2GmGa0HdF6XRutU2fQlHTdHofbwGwcU/a2d/6UtKVPHPyoVJEqpRPHHor7EqRgSxLLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983456; c=relaxed/simple;
	bh=uG04RXhtvDqeMJOttUatcDPude4UadiuIj/QxIyANsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKgutk1lol8Mtz4gZR/jKK4qr2povPwGX2f7CkAKpnLkskyaave62f6a+DHeuJ4PN6YQXxxblYRiM5ublMD5IbxO54A8t2Wjmh7jA3hGzNt0wyKKk15W2cX2sfUkPtLmm0BseeBceXDq1TLmNCigSbWdTtvjlZEJXxst1t/3PFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZCRfyin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZCRfyin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E471CC116D0;
	Wed, 25 Feb 2026 01:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983456;
	bh=uG04RXhtvDqeMJOttUatcDPude4UadiuIj/QxIyANsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZCRfyin2nsVKrwf9Hjrf025P+dpQke0exPj71SN7m3mYq82odjOMXhsINWlZ9KMu
	 ak5gZbymj5UMnWibSzoRkztVShmMrEdP1e+GRm29lEi9BDWp4U0K4TuimvY9axDvHD
	 cj2lrv3JUC6hLnEDtfFSXqm+aME2cQW3MEYLIcwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 570/781] serial: imx: change SERIAL_IMX_CONSOLE to bool
Date: Tue, 24 Feb 2026 17:21:19 -0800
Message-ID: <20260225012413.784053931@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 59221cce0028f..98a946096be3c 100644
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



