Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5569215CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC934C433C1;
	Tue,  8 Nov 2022 14:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916873;
	bh=AWf0R6K18xkj7EV8Yp1PuXUx/YE162l+Ucex8+SyTnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqNe1PVxHufygTqlYkvEDUfKVUxdnVa2JS2cYW+98tJgaA7DROUFZc8DG5fWcrfIx
	 lV9z82WacUosaCvM5dW2ImTULmsVv9U7EhHBCTWR0ni15KNDWpGnbF/cJQQCtYimdA
	 DgGXoyGVT569lFCEhq6gI84b9fvZULXdu4AM2AaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.0 161/197] parisc: Make 8250_gsc driver dependend on CONFIG_PARISC
Date: Tue,  8 Nov 2022 14:39:59 +0100
Message-Id: <20221108133402.260878846@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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
@@ -118,7 +118,7 @@ config SERIAL_8250_CONSOLE
 
 config SERIAL_8250_GSC
 	tristate
-	depends on SERIAL_8250 && GSC
+	depends on SERIAL_8250 && PARISC
 	default SERIAL_8250
 
 config SERIAL_8250_DMA


