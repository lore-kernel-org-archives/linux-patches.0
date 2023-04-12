Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFFE2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB80BC433D2;
	Wed, 12 Apr 2023 08:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289024;
	bh=maAHGkUZ/1VCwy+7AinzYpb1pflV6xmsN/iiNGngfGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpX0IIt//D01iEL2zhTdWTHB3M5WvxBCkgHTKcZnw1q0+xXEoguk/ps6TjJsNzPZj
	 2doVBbIyezz7pUqGtrutC2Nk0Rx3/5KyaCsYxYMo/srQDCX9a6eHqfrqQqSbQDxsv4
	 48V5rT61U4AjPeNmQT9Kc44A468TrlODss1oCeOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 6.1 080/164] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
Date: Wed, 12 Apr 2023 10:33:22 +0200
Message-Id: <20230412082840.146208481@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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
@@ -2940,7 +2940,7 @@ static int sci_init_single(struct platfo
 	port->flags		= UPF_FIXED_PORT | UPF_BOOT_AUTOCONF | p->flags;
 	port->fifosize		= sci_port->params->fifosize;
 
-	if (port->type == PORT_SCI) {
+	if (port->type == PORT_SCI && !dev->dev.of_node) {
 		if (sci_port->reg_size >= 0x20)
 			port->regshift = 2;
 		else


