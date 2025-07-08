Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124B517A2E0;
	Tue,  8 Jul 2025 16:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992515; cv=none; b=WYPTeJ2OeZI5lk601it7mMir/tKot2srVzdsRmfhZYHy02SIlDo8ZsTfQDGkxRWm0EJjFxDCz+uV4Jz2hHQ3QVgRvBMc8oO7IUjo/Llano73giiRQolXNCpvOl4tPaHKHJdrYDx6QTe57REuMYcUxilnwI7f5xYiX7efZQTrPJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992515; c=relaxed/simple;
	bh=DxuLK38LlXJs1UdfaHQjpUclsIk1RJccipSo56gLInQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bgu0cWap6N+pvG+Gwt51R7Nct4nasKK3P8WvAICpoHyp84BJNJIXqvsBxBKq6W6rkBPMyCgkmAVx7gbHLZd3b81/mwBKlqkplqTup08AYCWyCmEy8SW9mWuZ+1kcSUobQ3C/8//SaELfSrLrvYhReA4wZG4Ebfz4nmAJT9xnscE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNvnmCZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNvnmCZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2FDC4CEF0;
	Tue,  8 Jul 2025 16:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992515;
	bh=DxuLK38LlXJs1UdfaHQjpUclsIk1RJccipSo56gLInQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNvnmCZuNnv0k1fNwbPRIoRfjbKQRBrCM6ZXWbARyswNlC4HPC7vWQq/gRrnJm/bp
	 BcUoMVqQ5duEZehOBDVggfmZBYM9+L2GEz37Oy5f54EwQu8zcvQFrPGsk4v5886zpI
	 Ahu8O9tj33qVPmKw7ohpn2jzj1gsce3KYmjm9kUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 110/132] xhci: dbctty: disable ECHO flag by default
Date: Tue,  8 Jul 2025 18:23:41 +0200
Message-ID: <20250708162233.803974144@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -585,6 +585,7 @@ int dbc_tty_init(void)
 	dbc_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
 	dbc_tty_driver->subtype = SERIAL_TYPE_NORMAL;
 	dbc_tty_driver->init_termios = tty_std_termios;
+	dbc_tty_driver->init_termios.c_lflag &= ~ECHO;
 	dbc_tty_driver->init_termios.c_cflag =
 			B9600 | CS8 | CREAD | HUPCL | CLOCAL;
 	dbc_tty_driver->init_termios.c_ispeed = 9600;


