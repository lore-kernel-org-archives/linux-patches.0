Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AD425DAFF;
	Tue, 11 Mar 2025 15:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705796; cv=none; b=RpFtM1guBynQFDTRHJks9COSMrgrwzFTzg5h02/7YegP9osj7uol/Mj/APSrP5TPvbSg8NsgCINL3qdN0a+hhNEOKZEMeN+1nkMZaiX4LBXGBv7V9fkVHW1rVCjNtgFBknN93smcDFO6j1E3cHe58+et0HERMEGDdQJmIW/xuAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705796; c=relaxed/simple;
	bh=Ger7k6SbBeH3E+o1CNdOKcz8cosb4r8bRWhTQoXD2WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNzWCrZL/1epi99wQifnUQRC7RJK8lt7mAUlOTAvzDqJrsIAnWSIy654a4EguHqhjEwHeI2xCEPGWJbhb9+3qg2AhV1JSm4lrT2+AwNUGpJ+TlNeBQazLNNqGd8TW9Ofjae+v58qkZ3HvsaTo9h0ST8FhDSgY5A3WPzKKt5D3cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAXAdGxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAXAdGxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE6EC4CEE9;
	Tue, 11 Mar 2025 15:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705796;
	bh=Ger7k6SbBeH3E+o1CNdOKcz8cosb4r8bRWhTQoXD2WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAXAdGxnWxo82Xu0+XaTpD04UyG3htM0z4AXN2C9BDcl6rvnYZyIuHR58Nb3xL+pM
	 AzYD8Ubjg/uauTf3/50uJ5kPB3Tqni1jyi3yKs3R/+N0VgtmHvqmYRYlnr96YzYzhf
	 4wxhm4pIe5E+y0KKQY8iAjMXeeN1UemtBBQAdgWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 5.4 140/328] serial: sh-sci: Drop __initdata macro for port_cfg
Date: Tue, 11 Mar 2025 15:58:30 +0100
Message-ID: <20250311145720.467093218@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3455,7 +3455,7 @@ early_platform_init_buffer("earlyprintk"
 			   early_serial_buf, ARRAY_SIZE(early_serial_buf));
 #endif
 #ifdef CONFIG_SERIAL_SH_SCI_EARLYCON
-static struct plat_sci_port port_cfg __initdata;
+static struct plat_sci_port port_cfg;
 
 static int __init early_console_setup(struct earlycon_device *device,
 				      int type)


