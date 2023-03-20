Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8B61C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D7CC433EF;
	Mon, 20 Mar 2023 15:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324585;
	bh=h3y3HH01KgcJq02AOFdV2sZ5v+gM4bqe9amZ6i9IiDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkr1UYOdwxWpekUkRPfa1I6o+7JF5QbXP/pFLquI9oFkGBCwIbeZQVNoCrEVVlp64
	 HAyqg/OvUZ0/i6VKlliZFE3ZLCADQWBECxQh2OerSxYt1EyMWLcaX8OcZukL2EecLQ
	 yLxpvNPd/UVVVjGeIR6YAQ8qeeJnTQ9EkxUYdAaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 5.4 56/60] serial: 8250_em: Fix UART port type
Date: Mon, 20 Mar 2023 15:55:05 +0100
Message-Id: <20230320145433.255720925@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 32e293be736b853f168cd065d9cbc1b0c69f545d upstream.

As per HW manual for  EMEV2 "R19UH0040EJ0400 Rev.4.00", the UART
IP found on EMMA mobile SoC is Register-compatible with the
general-purpose 16750 UART chip. Fix UART port type as 16750 and
enable 64-bytes fifo support.

Fixes: 22886ee96895 ("serial8250-em: Emma Mobile UART driver V2")
Cc: stable@vger.kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20230227114152.22265-2-biju.das.jz@bp.renesas.com
[biju: manually fixed the conflicts]
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_em.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_em.c
+++ b/drivers/tty/serial/8250/8250_em.c
@@ -102,8 +102,8 @@ static int serial8250_em_probe(struct pl
 	memset(&up, 0, sizeof(up));
 	up.port.mapbase = regs->start;
 	up.port.irq = irq->start;
-	up.port.type = PORT_UNKNOWN;
-	up.port.flags = UPF_BOOT_AUTOCONF | UPF_FIXED_PORT | UPF_IOREMAP;
+	up.port.type = PORT_16750;
+	up.port.flags = UPF_FIXED_PORT | UPF_IOREMAP | UPF_FIXED_TYPE;
 	up.port.dev = &pdev->dev;
 	up.port.private_data = priv;
 


