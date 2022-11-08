Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE17C15CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6479EC433C1;
	Tue,  8 Nov 2022 13:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915033;
	bh=ZV+YMt1PCM+/fvZUYHnijzd+9gqNpb1LsrZvBtoIxow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9aoZ0QuLhfYYQuIxDgKaQ/AApTT1fbKQOFE02z8dMsbbl9R0LqyqDsxZt/8ASzTB
	 TmHPnUjmddRt0HM1gj31iw8aaDMdlCc2+8od+FwHSiMUeUb74350BBfkSSe6UpTLnK
	 J99yrCZMm/1uDhMPNi5weq65KAYmL4k/tI0vIzMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 30/40] parisc: Make 8250_gsc driver dependend on CONFIG_PARISC
Date: Tue,  8 Nov 2022 14:39:15 +0100
Message-Id: <20221108133329.491374517@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133328.351887714@linuxfoundation.org>
References: <20221108133328.351887714@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit e8a18e3f00f3ee8d07c17ab1ea3ad4df4a3b6fe0 upstream.

Although the name of the driver 8250_gsc.c suggests that it handles
only serial ports on the GSC bus, it does handle serial ports listed
in the parisc machine inventory as well, e.g. the serial ports in a
C8000 PCI-only workstation.

Change the dependency to CONFIG_PARISC, so that the driver gets included
in the kernel even if CONFIG_GSC isn't set.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -105,7 +105,7 @@ config SERIAL_8250_CONSOLE
 
 config SERIAL_8250_GSC
 	tristate
-	depends on SERIAL_8250 && GSC
+	depends on SERIAL_8250 && PARISC
 	default SERIAL_8250
 
 config SERIAL_8250_DMA


