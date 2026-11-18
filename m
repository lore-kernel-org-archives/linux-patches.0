Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024243;
	b=QiKKsrDa6KD9QV+pXbJjD3hTpIaU2XzuJY4+nbTg9BbPN9HqDFBBKE6sMxckF74Aretp
	 swUKPri6d2CvPIwPQVCT82MmZEtuGU4A86ZWz/HNu3QAxphmxDGC0h0Q+cPZA7+X7E0sB
	 hT8EOEt1x56OIsi19LqVENJSaFvj6CQVRq+xVdDmSzgN0NCCHe6KxnfaRzsCBhaCG78Jw
	 KKWk8ph2VxG6buMPo+q2KRjKGzgA0Ub+vVxF9ZhN2z66+aoo6rXHzozHBrYup0SsdayT6
	 XACyCkOR/0pm9VpShsNi/W+n2wEOEhVSlX8+vWGHiJ26076X3Xlj+X8a7oj3l/Zcdtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zBAAqBncQNVxfLL7N/NlW2k7WCCq++bLiIwVCaFX//c=;
	b=JJ9GYoXID2/vnV3BqKU55R7noxXK9xe88m4/Ce27c2H604guPPI3CkH5MPzbfMuwCgr8
	 7JNXaLNjbai/3G/thgcUGevOVIbfgtwKph8rOx7wZc2/pvHlOfiCq7cVgJGOUwZ72Szop
	 eJTf2d+PBo2UGWdFzo5tVT/oIN3vbsfF3iLN8kqeK4FsabMmCo8Epm7cnUtJJIE5Ed9Bl
	 u8Z2OmwfjPwR48y4LTSE5oI1DkU0hMb/hzipPIB5OXGtJ/wEt7LF+Bb4q+Ft+OmYb66v8
	 hiG9+Ihcz1CTQrjyRNBGrl+A8xZDAF4Y+LNtY/sV44FTR9aCQcYb8hfaL3auxDTh6DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvpxCGfH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64710606A320;
	Wed, 18 Nov 2026 17:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvpxCGfH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6A61F000C4;
	Wed, 18 Nov 2026 17:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024243;
	bh=zBAAqBncQNVxfLL7N/NlW2k7WCCq++bLiIwVCaFX//c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvpxCGfHezVShdzLVstyhCCLa+ZhgciJiNbDouUGIP7sZojHvgoBCJAZDMk5xRgFd
	 BIklVKShiL7XRQMKGlhmy25/cNueoCinfKjK6nuPyLkP8jchoww6mJ89kf3sLQzwHV
	 lifomYMGLsLvtlwcv9so75NydGYAA0hwE9YaabTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0657/2151] serial: 8250: fix compile error with hub6_match_port() when compiled as a module
Date: Wed, 18 Nov 2026 15:39:52 +0100
Message-ID: <20261118150145.759210075@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 7ab80d1e72431f5b7acbc55d83a23b76814957cf ]

With CONFIG_SERIAL_8250_HUB6=m, we have the following compile error:

  ../drivers/tty/serial/8250/8250_hub6.c:46:6: error: redefinition of
       'hub6_match_port'

Fix hub6_match_port() prototype definition by using IS_REACHABLE() to
support both built-in and module values, and substitute empty prototype
otherwise.

Fixes: 3d406299d8829 ("serial: 8250_hub6: add hub6_match_port()")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607150717.2YxVdWpX-lkp@intel.com/
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20260715153707.4181828-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a300273c458c ("serial: 8250: hub6: Add cleanup code")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 417dfe77e96b6..e1b79fae907ad 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -8,6 +8,7 @@
  */
 
 #include <linux/bits.h>
+#include <linux/kconfig.h>
 #include <linux/serial_8250.h>
 #include <linux/serial_core.h>
 #include <linux/dmaengine.h>
@@ -343,7 +344,7 @@ int fintek_8250_probe(struct uart_8250_port *uart);
 static inline int fintek_8250_probe(struct uart_8250_port *uart) { return 0; }
 #endif
 
-#ifdef CONFIG_SERIAL_8250_HUB6
+#if IS_REACHABLE(CONFIG_SERIAL_8250_HUB6)
 bool hub6_match_port(const struct uart_port *port1, const struct uart_port *port2);
 #else
 static inline bool hub6_match_port(const struct uart_port *port1, const struct uart_port *port2)
-- 
2.53.0



