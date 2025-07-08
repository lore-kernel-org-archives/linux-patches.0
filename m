Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4E52DECBD;
	Tue,  8 Jul 2025 17:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994168; cv=none; b=hMZDZAYaJA3Ff7POO2QUZcmitfNg5IjTcYa1szbO02HWxOgCjEHVLBk9JUEwPLTyA6/qGE69rAo96rcvSvQv2QIQUyatdqH61l5TuI4STaKPI+nJsjcaXxTe14MWSktUEq3N83L1O8CoglmdRuxoXSflI+WVqoQwVDby1pzv8rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994168; c=relaxed/simple;
	bh=2t1EPwv8ofjR7kPY2zZmxGuP3gk7BrSQ8BswY6VYDVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CsMNlJT7c4nWKH4ljoL01/Rn9Yh15+GpudVYZy0kv8bTqOAeSfVu3jWVEh7VHRo71SMEdt4nl7/HJHijW2b9oEu0TuLa6JjpfO3gxEoSbLinYr/6JyK/3ViSZFVZnHlFE1J/INJkq5MKrtcjv0rVugISvHMOlUI0Ng+HsFTQ8PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fW+HanYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fW+HanYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F2EC4CEED;
	Tue,  8 Jul 2025 17:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994168;
	bh=2t1EPwv8ofjR7kPY2zZmxGuP3gk7BrSQ8BswY6VYDVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fW+HanYkIsRMWk4Pb9BH7wUSzGQ5NHjQE6+DIyUrhYm6aglY08vMybz2hl0uDiPer
	 GgbwNIM1d04ke7gr8L6zJ1+SCqsUnHw3revU+hXr32ZoMDJ6eDXZ4xwGRvGKKWL2gb
	 NRT/IQJk4LwzKaWueslc8Qb1WXJk58gIzkFEZtKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 149/160] xhci: dbctty: disable ECHO flag by default
Date: Tue,  8 Jul 2025 18:23:06 +0200
Message-ID: <20250708162235.454770622@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -537,6 +537,7 @@ static int dbc_tty_init(void)
 	dbc_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
 	dbc_tty_driver->subtype = SERIAL_TYPE_NORMAL;
 	dbc_tty_driver->init_termios = tty_std_termios;
+	dbc_tty_driver->init_termios.c_lflag &= ~ECHO;
 	dbc_tty_driver->init_termios.c_cflag =
 			B9600 | CS8 | CREAD | HUPCL | CLOCAL;
 	dbc_tty_driver->init_termios.c_ispeed = 9600;


