Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E201229B797;
	Tue,  8 Jul 2025 16:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992133; cv=none; b=JJiylo7Orqx7Ei9PoOMV5yIkdUYOZyDD+H7eklpTX5DnJidvOYbmQ651Y/bB1wlZv6cKvlY0ksnKM96/mudBvOz3NXjVra+Mu2Nhmmgo4sCTWup65TTPZVM2Fr+DruR1rSGYnYHLlr3X6w9jK/GnWpRLyK6r9POSGIuxCNeNJmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992133; c=relaxed/simple;
	bh=4BvJDLF1FSjonX2Uw3cJmJIZ3ZVA9zXJQM1GXkmXNb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MiRT7IK/oLMA2hS1aL+wMjmn3SEb242mHLN8YXsLoBScTKAwgF9LrEOUexSA+K8ILo5HvGkJHBWcqED2cI4Hy+w9Md4xd/7rwSrIkNSwTHOyatQsqq+1MeThXTzrKNtEgu/4r3rmUTjTJ/EFTHzyc1bhjg4SACaQa9KdcLzmYk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yziyTZCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yziyTZCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C189C4CEED;
	Tue,  8 Jul 2025 16:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992132;
	bh=4BvJDLF1FSjonX2Uw3cJmJIZ3ZVA9zXJQM1GXkmXNb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yziyTZCygkLBeedB4XHC5jezVi4D1pAQwHJB4FMe1r1NwasTnTwmp0F2xKXVzD9yS
	 Ch3ECeqagBDf1EO043qiIZUZrptHzGL/zo69Gj5nCyA7Pe9oPF0IQtRsOOrk07CYxs
	 nZKQ7AItmHfVo9DoRwFoD6ahLKOcBsVIIrz7fmMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 68/81] xhci: dbctty: disable ECHO flag by default
Date: Tue,  8 Jul 2025 18:24:00 +0200
Message-ID: <20250708162227.122943785@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Łukasz Bartosik <ukaszb@chromium.org>

commit 2b857d69a5e116150639a0c6c39c86cc329939ee upstream.

When /dev/ttyDBC0 device is created then by default ECHO flag
is set for the terminal device. However if data arrives from
a peer before application using /dev/ttyDBC0 applies its set
of terminal flags then the arriving data will be echoed which
might not be desired behavior.

Fixes: 4521f1613940 ("xhci: dbctty: split dbc tty driver registration and unregistration functions.")
Cc: stable <stable@kernel.org>
Signed-off-by: Łukasz Bartosik <ukaszb@chromium.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/stable/20250610111802.18742-1-ukaszb%40chromium.org
Link: https://lore.kernel.org/r/20250627144127.3889714-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgtty.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -586,6 +586,7 @@ int dbc_tty_init(void)
 	dbc_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
 	dbc_tty_driver->subtype = SERIAL_TYPE_NORMAL;
 	dbc_tty_driver->init_termios = tty_std_termios;
+	dbc_tty_driver->init_termios.c_lflag &= ~ECHO;
 	dbc_tty_driver->init_termios.c_cflag =
 			B9600 | CS8 | CREAD | HUPCL | CLOCAL;
 	dbc_tty_driver->init_termios.c_ispeed = 9600;


