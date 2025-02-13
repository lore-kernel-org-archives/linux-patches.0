Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0D623A9A3;
	Thu, 13 Feb 2025 14:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457994; cv=none; b=N4D8c65lHeCk7M8mi/KzX1u4TkCboTj1FF7Whil4m6sM8b8zWuk0Ecf39T2F4VxXqKnfE8Jvj7hXGkq6aZpb8B3YB01XzuGACfZZ/WmgUvfyFgcOII4B6YvYZG/QDBqkHoV142otaYgPsJzxgibZ5I0ygV1ZehDEVmhGOgM8HKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457994; c=relaxed/simple;
	bh=Qzo73FxhyxdSKRHB3arVRW4d6vp3rfNLTJkiB9tNUDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axKbfPFGZD4LisyeXIMPk3I85FKhHg9EypGMRgSCRiHxwWqJoYsQY/sKP6hIR0cqNBkNLa6+0L9ubwb6bd+pFlMWCDdKrkVM6GL2ThO1r0oAW0qX4i5uV4050X2Z9pkUM0mwzTdPHxbOysNDty6e4E+JAsSL4q03wXgTsExPeLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2IvNpZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2IvNpZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FD5C4CED1;
	Thu, 13 Feb 2025 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457994;
	bh=Qzo73FxhyxdSKRHB3arVRW4d6vp3rfNLTJkiB9tNUDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2IvNpZqHZCeCDiFMCWagISCrXo6+iHOu0cCtG6ZOlANsf1iYpPz2ZCQPIWnf6/GV
	 x8lP28VOlqsdoWOpEk9hr2rEPjjbn96KG4AwqKIm/4kNHDkPvhC8atadSXwFTWUlYN
	 qTltEj8Wwii0i+SMPVbY7B54B+hxoSooQbSEzcpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.12 228/422] serial: sh-sci: Drop __initdata macro for port_cfg
Date: Thu, 13 Feb 2025 15:26:17 +0100
Message-ID: <20250213142445.334740966@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


