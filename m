Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F34C26B097;
	Thu, 13 Feb 2025 15:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459397; cv=none; b=Yvk+51Jj3cMTDs/FTADfTCH+tqHpNBRx2lW7fxhH8TUBIAv7CYd8R273Ucv0uKy/xdkPlfc9DwzVhaUvckyDEfaqi9T9ftAsKT0579iUWBkCm+Pjr6/G55CX1h8dzg1cwYKO+29arzfsYONrKwBMoyJBRNI5WNUYnCVfzRTotY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459397; c=relaxed/simple;
	bh=yArCMsQi5p4Nuhhb1AF8gS7vwJ21Q9qtsJ1TIrr0/H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpBIV4veG9DMhCLEzcFDxe3c16rOeUE9v0wv3x9Fw3/MLkeRvIeIYCRpkk7iqb3Qxr5LFqU4Wh1l8b2vZ+KBXiWu9kB4Vlv/0TJ1Fuf+rWskAK+yTojpefMAiZgEj5pofmeyZUv+u9/C07MEiMhBvWZGrGOorTSreI/J0KMCwZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amZyX/BF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amZyX/BF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BACC4CED1;
	Thu, 13 Feb 2025 15:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459397;
	bh=yArCMsQi5p4Nuhhb1AF8gS7vwJ21Q9qtsJ1TIrr0/H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amZyX/BFd6J341vdjnDBvpW2CpPPxLmNipw1J9mh7hHOkNI65vKWbLe04TFDcjzta
	 eE1/+nhw3awzmegcW8/+X3VlkxZhEoat4G8npBSO25qsocY/5C7FTfHxQa+IOtUfKK
	 Z2jyQouojzl9+BIiKcz3+CLITG0dBV55rt/5+G8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.13 253/443] serial: sh-sci: Drop __initdata macro for port_cfg
Date: Thu, 13 Feb 2025 15:26:58 +0100
Message-ID: <20250213142450.379044131@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3562,7 +3562,7 @@ sh_early_platform_init_buffer("earlyprin
 			   early_serial_buf, ARRAY_SIZE(early_serial_buf));
 #endif
 #ifdef CONFIG_SERIAL_SH_SCI_EARLYCON
-static struct plat_sci_port port_cfg __initdata;
+static struct plat_sci_port port_cfg;
 
 static int __init early_console_setup(struct earlycon_device *device,
 				      int type)


