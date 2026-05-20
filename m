Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4069F35DA6C;
	Wed, 20 May 2026 17:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298781; cv=none; b=AFFzH25HZe22bflPWQ1gEF3qwj0aP/ivnxwl5d5MVI15CsKX41+wOfuAQUERJs9LJGs64uGYxki8R6L7vilgKYSwHz5NwSp6fNqkah7HJU28LoCDX5Ol7MVkeoat+4KEbEe5KhXFhUmAJCHuzNSH37CZI20qhgiaxoopxUtDrJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298781; c=relaxed/simple;
	bh=dEWCN1OFZf7QiyoAnWrye/hwKGfYrUg9ecIhXIFOEtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfxLQUx9/T1I+tC1IBhqzRS2PAB0SxeHJr5X6kNJ33tAWbBD2SCbuu+2hhn+SMiRziUE1Yj1QvF/rjx6lmzTD3R7aDUdVhh1szh56Qmvo0ai4h2J9I+cg2Lx6QDZhVyPiNjhMWk5Xl5eDOM/BOw/X4VhNPYb6CboLD7GYQJ4mRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFN+jsLZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFN+jsLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DC81F00893;
	Wed, 20 May 2026 17:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298780;
	bh=RigVN6nHAtW5DRGrvt+y3KQSjzE6z/+I1bCdsRIEVZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fFN+jsLZzDk08ng4jwG88F1jMf2ICidIPAJItOh4uDNgAeoecqmrI4MYZ7kaDrcj0
	 boDJq2ZaQ6RmNHp5KMjWzOYfgigzKKLbP/0Q9nyC8P58EsYQDwU0z2yKQ07ZF62dUI
	 M9qpNL6RZ4mQ0nYVrrbLQS2sTqPuNRr2PLIBm6Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 542/957] tty: serial: ip22zilog: Fix section mispatch warning
Date: Wed, 20 May 2026 18:17:05 +0200
Message-ID: <20260520162146.288077077@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



