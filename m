Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C003A383C;
	Wed, 20 May 2026 16:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296137; cv=none; b=goNEg+MPMT4XgtVCoRFr72xduflwZ3xORuU3y/j+HNuqayEGEoUuvHNkoE8ftRp2JK0NtA3tlEZpDjl8hOYNsPzCE9WOjX6Ya/Mex7wtzcWcEiFJ3+eErIRhGzqlkxp7MnrnU9UUM36p3QmsFgfId4RvFjGrjYa9eu/hBbC0qIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296137; c=relaxed/simple;
	bh=g/nWUW7eaotGogC9+6qwJpKi47Pm3HUHKE4TErn1Ek8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7vNF2eLvEert5fsjkeIRwb64hn7+b/M54GPiEAFZIWKh0nF+0VJWCteEbLshh/XSR83B/QoMkfouuHWB0nzIcCYIHI5wuyFxWrKJQEuH8gH+RgbuIJf02uJkdWMDEggpiHEufLnM/b8yEE+YvtwYSAqemcKBpqSjsdJDOXp2LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlfhXbPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlfhXbPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380BE1F000E9;
	Wed, 20 May 2026 16:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296136;
	bh=Qv6SpIPD7dlCixcDQjtKQtyFzAgK3oQJFot+N8d7tSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TlfhXbPLxSe5ypTLmUKgto/RMjfOMTo2hX30D/PiKxO5UGC2VwOOihIzXjyYNzirF
	 Tv2rCstB6XxWajOqyQ4RnpLRGI8BiQuLlhMg5pc+gpqZnJ+P90KP0319tmoVXko1HT
	 7Svv2RzHgxiDeEw/DTfY0LQx1B/BkfKbi+1cB/fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0684/1146] tty: serial: ip22zilog: Fix section mispatch warning
Date: Wed, 20 May 2026 18:15:34 +0200
Message-ID: <20260520162203.668799559@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit a1a81aef99e853dec84241d701fbf587d713eb5b ]

ip22zilog_prepare() is now called by driver probe routine, so it
shouldn't be in the __init section any longer.

Fixes: 3fc36ae6abd2 ("tty: serial: ip22zilog: Use platform device for probing")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202604020945.c9jAvCPs-lkp@intel.com/
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Link: https://patch.msgid.link/20260402102154.136620-1-tbogendoerfer@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/ip22zilog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/ip22zilog.c b/drivers/tty/serial/ip22zilog.c
index 6e19c6713849a..a12101dc05546 100644
--- a/drivers/tty/serial/ip22zilog.c
+++ b/drivers/tty/serial/ip22zilog.c
@@ -1025,7 +1025,7 @@ static struct uart_driver ip22zilog_reg = {
 #endif
 };
 
-static void __init ip22zilog_prepare(struct uart_ip22zilog_port *up)
+static void ip22zilog_prepare(struct uart_ip22zilog_port *up)
 {
 	unsigned char sysrq_on = IS_ENABLED(CONFIG_SERIAL_IP22_ZILOG_CONSOLE);
 	int brg;
-- 
2.53.0



