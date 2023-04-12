Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A362F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5DCC4339B;
	Wed, 12 Apr 2023 08:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289399;
	bh=5J7XEA+SavQogqudqCj0gIBJ79TmR5+EMZXKINFmqbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQz5qDi83g7byv9B8XQYvQi5f1XV7SLEv5OwKEflzqmmX5TxLR/7RJT8MlOtRU1nh
	 cPUtRIzCRglF/6Mimx4B86hqpqfZDQBgu/fVH2hbIUP7rb2toUowGx2x73XRKFO1b4
	 b8PdWPF48uBcsBnaif94XgVgIdKyNPANMJsG8LrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 6.2 083/173] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
Date: Wed, 12 Apr 2023 10:33:29 +0200
Message-Id: <20230412082841.409386203@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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

commit f92ed0cd9328aed918ebb0ebb64d259eccbcc6e7 upstream.

SCI IP on RZ/G2L alike SoCs do not need regshift compared to other SCI
IPs on the SH platform. Currently, it does regshift and configuring Rx
wrongly. Drop adding regshift for RZ/G2L alike SoCs.

Fixes: dfc80387aefb ("serial: sh-sci: Compute the regshift value for SCI ports")
Cc: stable@vger.kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20230321114753.75038-3-biju.das.jz@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -2937,7 +2937,7 @@ static int sci_init_single(struct platfo
 	port->flags		= UPF_FIXED_PORT | UPF_BOOT_AUTOCONF | p->flags;
 	port->fifosize		= sci_port->params->fifosize;
 
-	if (port->type == PORT_SCI) {
+	if (port->type == PORT_SCI && !dev->dev.of_node) {
 		if (sci_port->reg_size >= 0x20)
 			port->regshift = 2;
 		else


