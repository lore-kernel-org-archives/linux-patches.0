Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024240;
	b=zz1CMApNm7FJqScVYF9qPcI4RWKexLg/czkb3vP9w6/gi1ay0wJu7ny7DokGE4BugdkQ
	 LeW+IIkzZAW3HXgLuZV79hsddzsYzyJDLq1Co1sf0DWz3drqSTJXytuOsJspOUbzVen0l
	 sj9fusrPKp2Rps7D03E5y0c/PrISLF33g7zkcQUERW5/eJLR0RGhKTMmacaDEtgBQYoud
	 oVqqLESphx9+W/zVDreTxToxFmU/M7CdJzIKWnc/bECP28eYsqa5G9LhN3g1vWXfini7M
	 0686bZF55kzeSZ/yUR06JN51atEamDbFSEjidoV+YKPt+FoW30n9mQFyk5L/yO9MvBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=LDvA7GCSEuUBIQnI2/eG0TtU44rqANc/mnnQXDIaEeI=;
	b=kVjCDhcJiLQdNZlbpj+Q0niBC2dMw0mP2cy73Q1+3eQgahl+OqCmDw/JUqSWt894caet
	 Kov9MmM/uydTJX+Mey3X/ZlTTeMD75FWV7Pj0OiL/0gY6nlxU4UKZvSrwfygOG6dUk97s
	 9jc3AWeSx0BO8Vt0GKLr//Q7fy1k2GWhs/rLp9gyNkjVAv6jKsCCEtXAk6HoIZ2S40sTT
	 Yx9V2lLg0RuZwyiLP/bzCq/lCNCNF1JLsQtCulr1ce7+tjMpeNBss6++axgblrILYo/2u
	 Dt32KBa24Fx4+kqkcUOCKu4lyxtD+VSQQdZr6J8kZF33TpmuKE1GPRf4BOyg8dIMfPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZWJXn+yD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C6C606A325;
	Wed, 18 Nov 2026 17:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZWJXn+yD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB9E1F000C4;
	Wed, 18 Nov 2026 17:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024240;
	bh=LDvA7GCSEuUBIQnI2/eG0TtU44rqANc/mnnQXDIaEeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWJXn+yDzg3+0XDl03I3L5IusXjisJY0a7FsQyTrRhKvaxsA4k6tPDH0kMIEcsF+R
	 HV1d+x74B9QI43q4t69c8oa0uoWaCkHc6IP69CyvHEA6rkox/zoqTmg0nB8uAOFUhk
	 5o55MuXmoNj3OMKtIBbFyw1dLUYNA2zlL565Oy74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0656/2151] serial: 8250_hub6: add hub6_match_port()
Date: Wed, 18 Nov 2026 15:39:51 +0100
Message-ID: <20261118150145.725856389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 3d406299d8829747fe2e8692f4c29fe3dc1d101f ]

Move the entire hub6 related match port check into its own function in
8250_hub6.c and add a stub for the case when hub6 code is not even built
into kernel.

Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20260521-tty-upio-v3-1-bf74567994a0@dimonoff.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a300273c458c ("serial: 8250: hub6: Add cleanup code")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250.h      | 7 +++++++
 drivers/tty/serial/8250/8250_hub6.c | 6 ++++++
 drivers/tty/serial/serial_core.c    | 4 ++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 2d4f15df18f7f..417dfe77e96b6 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -343,6 +343,13 @@ int fintek_8250_probe(struct uart_8250_port *uart);
 static inline int fintek_8250_probe(struct uart_8250_port *uart) { return 0; }
 #endif
 
+#ifdef CONFIG_SERIAL_8250_HUB6
+bool hub6_match_port(const struct uart_port *port1, const struct uart_port *port2);
+#else
+static inline bool hub6_match_port(const struct uart_port *port1, const struct uart_port *port2)
+{ return false; }
+#endif
+
 #ifdef CONFIG_ARCH_OMAP1
 #include <linux/soc/ti/omap1-soc.h>
 static inline int is_omap1_8250(struct uart_8250_port *pt)
diff --git a/drivers/tty/serial/8250/8250_hub6.c b/drivers/tty/serial/8250/8250_hub6.c
index 273f59b9bca55..eae32c924e29b 100644
--- a/drivers/tty/serial/8250/8250_hub6.c
+++ b/drivers/tty/serial/8250/8250_hub6.c
@@ -41,6 +41,12 @@ static struct platform_device hub6_device = {
 	},
 };
 
+bool hub6_match_port(const struct uart_port *port1, const struct uart_port *port2)
+{
+	return port1->iobase == port2->iobase && port1->hub6 == port2->hub6;
+}
+EXPORT_SYMBOL_GPL(hub6_match_port);
+
 static int __init hub6_init(void)
 {
 	return platform_device_register(&hub6_device);
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 602dfaf20fdf6..71c47736a467d 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -33,6 +33,7 @@
 #include <linux/uaccess.h>
 
 #include "serial_base.h"
+#include "8250/8250.h" /* For hub6_match_port() */
 
 /*
  * This is used to lock changes in serial line configuration.
@@ -3261,8 +3262,7 @@ bool uart_match_port(const struct uart_port *port1,
 	case UPIO_PORT:
 		return port1->iobase == port2->iobase;
 	case UPIO_HUB6:
-		return port1->iobase == port2->iobase &&
-		       port1->hub6   == port2->hub6;
+		return hub6_match_port(port1, port2);
 	case UPIO_MEM:
 	case UPIO_MEM16:
 	case UPIO_MEM32:
-- 
2.53.0



