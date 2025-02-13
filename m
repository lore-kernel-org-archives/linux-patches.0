Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D3626B087;
	Thu, 13 Feb 2025 15:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460552; cv=none; b=gylO3VyaozCXuytn/YukFy7uQo4DWVrERv/MXzOFeA9YowAqxg7GHMto+R11C8axaEYhaHgp1iQFRjTfdTLTd6sObasXbDL8Bc6fPMHu9KGPNeoym0ScjMposc37uqQ/ef6YRrTjqf7wZG7s/bxxFJlccl9kXvvB4JsTYvA/E2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460552; c=relaxed/simple;
	bh=57m4QCEGfRd+7TK+26AJEo9zS3CsZEYJuirvpGk24PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKozQrNbJ0lBpzaB5gWN0c1WIPgY3z9dq7Q8BNICmzS+VOkRnCvivBGHgH2r8C9G8+6UlsFzj/LcLJ7N36BwbfcRG/sowp0cVsSqZlbCjcnE9ngpVi4v1nBVDmVaAOQzz5y4OQoTVCcvrTaABgsFWcx+LvMMrU9vddNZ9C2tU0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqGHk8t7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqGHk8t7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B557FC4CED1;
	Thu, 13 Feb 2025 15:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460552;
	bh=57m4QCEGfRd+7TK+26AJEo9zS3CsZEYJuirvpGk24PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqGHk8t7rZlq/sLPjiNXhpbGesR3P/LnJ+amyaxm0DqVMt859rplfq3m2SMH99wAm
	 DVImBUEPhxhCX88pnw32sEF1zIAPOMtCe09zlI5iGT+XX/UslrIC5WkUjEFbZbhjhU
	 AKfvTfhD3BwO8REF2FNlp3UZuYyiAVXqwQnvXhds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.6 145/273] serial: sh-sci: Drop __initdata macro for port_cfg
Date: Thu, 13 Feb 2025 15:28:37 +0100
Message-ID: <20250213142413.064458696@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit eaeee4225dba30bef4d424bdf134a07b7f423e8b upstream.

The port_cfg object is used by serial_console_write(), which serves as
the write function for the earlycon device. Marking port_cfg as __initdata
causes it to be freed after kernel initialization, resulting in earlycon
becoming unavailable thereafter. Remove the __initdata macro from port_cfg
to resolve this issue.

Fixes: 0b0cced19ab1 ("serial: sh-sci: Add CONFIG_SERIAL_EARLYCON support")
Cc: stable@vger.kernel.org
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Fixes: 0b0cced19ab15c9e ("serial: sh-sci: Add CONFIG_SERIAL_EARLYCON support")
Link: https://lore.kernel.org/r/20250116182249.3828577-2-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -3503,7 +3503,7 @@ sh_early_platform_init_buffer("earlyprin
 			   early_serial_buf, ARRAY_SIZE(early_serial_buf));
 #endif
 #ifdef CONFIG_SERIAL_SH_SCI_EARLYCON
-static struct plat_sci_port port_cfg __initdata;
+static struct plat_sci_port port_cfg;
 
 static int __init early_console_setup(struct earlycon_device *device,
 				      int type)


