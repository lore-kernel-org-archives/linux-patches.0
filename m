Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4F52ECE80;
	Tue, 15 Jul 2025 13:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587740; cv=none; b=rdLZI2pYBxiH1DKWoTaEjVMhcsMrtK4IYxfz46RepkcknDgQ1KstZMFRWYNudYANAkIay0UxU670E26nRQGQ/e8HgYSpbyVIbWoKJ+sYHce9fRuLbbpaw+xXDKvUzklhf527Po+CaUeZStUKFZ6TYjTVs/L5zmyZz1G+pS3p0B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587740; c=relaxed/simple;
	bh=DRURMqcAgCnvU1ndtH/WZaMU8Uxbz+abn6fb9jiT0vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qP9wKoTaC5tbN9Dalyw2EoMBKSV7bLNa3PhA9l+UOEOO+C06tfg2T80q85+1IEsb7xBRAnvrSjotHaTm6CxqzWeUufCp+lAJeJQECWL4l8rabAaTGApTlLkPrQBT3c683DJx+cG58gUFh1XzUxuxogZTK4h/SfaSUrPkU3Z54Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFY3nIrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFY3nIrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD34C4CEE3;
	Tue, 15 Jul 2025 13:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587740;
	bh=DRURMqcAgCnvU1ndtH/WZaMU8Uxbz+abn6fb9jiT0vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFY3nIrrCixIBkXXPn2xoGKEIjWqGm3oegL0tIf5adEM2F7j7Iwo5wLrigO5dA3qy
	 Q9RvirhJUfdvdkOHnAButHe+3jr+Dary948BKfxvWbV4SMUD239l9dDiO5JyCUtZf0
	 PthNvAhZZimstOg+y8XXOEFw+FbAZ2ipNCOo1A1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 124/208] xhci: dbctty: disable ECHO flag by default
Date: Tue, 15 Jul 2025 15:13:53 +0200
Message-ID: <20250715130815.910825306@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -529,6 +529,7 @@ static int dbc_tty_init(void)
 	dbc_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
 	dbc_tty_driver->subtype = SERIAL_TYPE_NORMAL;
 	dbc_tty_driver->init_termios = tty_std_termios;
+	dbc_tty_driver->init_termios.c_lflag &= ~ECHO;
 	dbc_tty_driver->init_termios.c_cflag =
 			B9600 | CS8 | CREAD | HUPCL | CLOCAL;
 	dbc_tty_driver->init_termios.c_ispeed = 9600;


