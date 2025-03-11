Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3557625E82A;
	Tue, 11 Mar 2025 15:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706858; cv=none; b=ihZO4vU6a8RDfudbVrOHz2yz4PpCwGHwUGRX9JxwVa3C9Udm7zn7+6zWDNFuIbP4b+V8/6gw9DOvA0YNg/8L5wPjV8f6upJZ7e2hxcNOpeWhwvdjlTEv6Dc9KtToucmjKHo/zuSGA4WhNBYYJaSlu2gN7jX7SQd7JkxPS/GldoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706858; c=relaxed/simple;
	bh=vtHI1/gpFIzLexZTOhT62Y/6Du//3sRK5t3Vj4qfvfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ly+WBf26wtroy0uut1976VMMkUT79J2hnUboEDR+JGCImnqRK5jrbjXsHgmuLgrxKK71FAy1Qbt9jd+ixVy3KsQ5Q3ZRPnV4OJEhkhldGXHqOWYUAwWFGILMdlhSgxHBPA0ufKd4J6AVWpkTj390c8awXupYIIzm276FMwWfBIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0xrbrq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0xrbrq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5371C4CEE9;
	Tue, 11 Mar 2025 15:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706858;
	bh=vtHI1/gpFIzLexZTOhT62Y/6Du//3sRK5t3Vj4qfvfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0xrbrq6VmjqAsx3MHDi5Qzpjkg4KUK9GgoqAO+xM2ivNNlIXIv7qBCC5u/eUDzTE
	 XSsKpEIyntDUafoaiCjrtQGW+vn6Qx8DcmTjPrJQv1fho76PMzvbjVZNze6hAxEGYK
	 JIO6n54lU2+yY7ZKLaecCI+r1yHAOvR0cnxMUyg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 5.10 192/462] serial: sh-sci: Drop __initdata macro for port_cfg
Date: Tue, 11 Mar 2025 15:57:38 +0100
Message-ID: <20250311145805.946154195@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3455,7 +3455,7 @@ sh_early_platform_init_buffer("earlyprin
 			   early_serial_buf, ARRAY_SIZE(early_serial_buf));
 #endif
 #ifdef CONFIG_SERIAL_SH_SCI_EARLYCON
-static struct plat_sci_port port_cfg __initdata;
+static struct plat_sci_port port_cfg;
 
 static int __init early_console_setup(struct earlycon_device *device,
 				      int type)


