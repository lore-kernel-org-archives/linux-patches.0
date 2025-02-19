Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC44E17A2FE;
	Wed, 19 Feb 2025 09:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957016; cv=none; b=pwvX5WRzOcysyui5UKfvAVhG3srP1RioKlAC260xdr6NyjVNYphTLiD9tT3wN5QJNui3tsFC6tVb7MgsrBATcVXw9RaMD4BnMEba1AptG4DdVQ/bjZPDwnVJ1PCIYC80DPDWSkukySO18ej+/KwkYmi0o94DU25uGaYSXJh6jFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957016; c=relaxed/simple;
	bh=+6/brwmNjIupS+YwitP5yp6OKDuzLZmizYb9FuEdVeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLd6vHuLV+RVM0kTiTYpnw+ZLcNRZPididIy6AJALgd4iboNGuwHbE+pmgGmU14PsAMuSdsu+jeFh6sKhULK179wrsv4P2eRD4cJZaXkZwiTkPX/v+MFSJWauNz5JM1JmTtp7s/P6U8wPSu1ybrHE5fiVjUkKQ/i42P5ubwtw8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRNGyvxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRNGyvxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA3CC4CED1;
	Wed, 19 Feb 2025 09:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957016;
	bh=+6/brwmNjIupS+YwitP5yp6OKDuzLZmizYb9FuEdVeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRNGyvxkjp70/SxAclSHOK06vl38O5m1+Q1N9fftAgE/X3t9fs6rN45Y1QiZ/yx2t
	 mf9Wjx6qZ0/Ajc3K9cdr4Bayt5s3jwmA3MfYsxaHuBhDUTEIwus/VQ9ViVwTznPOYX
	 iUgMJ2SNFJ051fbOXE4QOJylbYCBGiXlcdKZ0iDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.1 378/578] serial: sh-sci: Drop __initdata macro for port_cfg
Date: Wed, 19 Feb 2025 09:26:22 +0100
Message-ID: <20250219082707.889258487@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3430,7 +3430,7 @@ sh_early_platform_init_buffer("earlyprin
 			   early_serial_buf, ARRAY_SIZE(early_serial_buf));
 #endif
 #ifdef CONFIG_SERIAL_SH_SCI_EARLYCON
-static struct plat_sci_port port_cfg __initdata;
+static struct plat_sci_port port_cfg;
 
 static int __init early_console_setup(struct earlycon_device *device,
 				      int type)


