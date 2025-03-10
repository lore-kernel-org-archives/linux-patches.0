Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C341C4A24;
	Mon, 10 Mar 2025 17:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629502; cv=none; b=uVXEu2qi2k4BN1ZnJ0Sb1ZhUQwKC9ELPmW1d1U6RDjk6t3uvFepggjUZ8kse7n/9C4vJiM2csPhjTmyO3HGUyHT/qGIVAOLbjX8GO+6sGz1AsqW8v7xVg15cVXLMDaGV+GxBxDQGdLOMPtpSo2Ym8QL2gmj2TWDVcPPOhDKjsic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629502; c=relaxed/simple;
	bh=ldBmYbMefBRI6uxC6Lb6BogFJlDIjBVJJDrP1RVK44c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeazZk8OVgCsWVtXxcYtemHxx4v5303Wn6JGyNTt8jZPWeGg2Y9/1dYao7ihfxamOBNSf2Bl91Y4pjUPb5m2oqvoweaje4YpNMkQq74N76+6i65d+8A6J07X+DHVQ/fFBP3dH1bsKqBWvzMAIqXAjw9ZnSvMi3vbm9Ryx8RG05s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFMbpR7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFMbpR7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8028FC4CEEE;
	Mon, 10 Mar 2025 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629501;
	bh=ldBmYbMefBRI6uxC6Lb6BogFJlDIjBVJJDrP1RVK44c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFMbpR7evplb9ab1vgayhmjFMil7KZMWvETnPBXOsjz8RjSadmYDZsJdixmb50U3F
	 /xxHfR3W58yIcQ8vNfF79fYdr7eerA4fTqjWDn/m12JUzwUEiz+1imrGflDNpod+zY
	 gPtaQ+YLPpB19nDr6ljgeqyGRCtKLlSCVnQJmQ2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 5.15 285/620] serial: sh-sci: Drop __initdata macro for port_cfg
Date: Mon, 10 Mar 2025 18:02:11 +0100
Message-ID: <20250310170556.864145411@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3431,7 +3431,7 @@ sh_early_platform_init_buffer("earlyprin
 			   early_serial_buf, ARRAY_SIZE(early_serial_buf));
 #endif
 #ifdef CONFIG_SERIAL_SH_SCI_EARLYCON
-static struct plat_sci_port port_cfg __initdata;
+static struct plat_sci_port port_cfg;
 
 static int __init early_console_setup(struct earlycon_device *device,
 				      int type)


