Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213127;
	b=n5yinrchNEMfef4cHQsuT6cEM0Bn0x0b2eybnEIAG73knbpUMB8dF576yUS8rSvfBw7w
	 Vn5TKE9w82oJ6QNFu64g3A1o9EDXHHVeJHxLfkhMgAvCYHsz1y7LsQwg+mtOTk2uifOq4
	 d0hCviLD71frOanzcZDEL3aPimSh/tRMG0U02OirwaXYr1UM4mSPwm0gyuznStoiw789y
	 j8W8klBS9H5+n50DYPc7VS63D4sVElFhIgRvV0gJBIda4LIk7622j6oyHC+351QXMLQVU
	 Zd6yzZTSrY+B/Gi6adTBg1/FYbuRCq6WpKI6dDcO0kM84Pl5Env3ZArFMD2pBjYG+3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EBWk0jfS8AuMSFIHxYJSxuQlMoVwy7fRULOEOBKGiEg=;
	b=JjTipxEwCv7UAMrANUpcYcYJdN5nMs0Zvjqc5PHtwQZQy1Du7PI9ZZJZNYcguWYu+9GL
	 p3F0G9RPiDUzxGYx/EVieUfjFfYw81i+3SFEcsVSe4tDpFfw3y+A4wjv594dsKSCRcbJm
	 ZPzVEeAKWkQCNQvbgWCfCpEE2UXluTrt6nx/3hjZublcVdlXBjBjRGBhGMeRo7FXe9doX
	 HqGrnkLu7D9Fhy8e/9AuILaQ50/AXBuB1manhIvZJ0FkbU6sxLbAHrOzpy3p+fw2d6+lx
	 +UjRgUPOdV+lpaJEo+K+P87abHKMrEJwo+hNY8jln+0osJHc+rONBjeAohXxOHKFA0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xTbyJ48/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDED4606A31C;
	Wed, 28 Oct 2026 18:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xTbyJ48/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C131F01825;
	Wed, 28 Oct 2026 18:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213126;
	bh=EBWk0jfS8AuMSFIHxYJSxuQlMoVwy7fRULOEOBKGiEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xTbyJ48/0Pz/2DIiJoBo6Fu9gyEfuPh2AY2oPytjeQFnmdQe3TdNrxCW0f/l7fQOd
	 ugXwrVnPnfupssvaeM9MXS8VTzwpkezVMN6FXX0eVoABS0tCQIwJWiIAldRTaJnfxD
	 lxU8KEAOMgdksr3iV1XcPkzXKoYw5rIXUd9F9g8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 0389/1887] tty: tty_port: restore TTY_IO_ERROR on activation failure
Date: Wed, 28 Oct 2026 17:41:25 +0100
Message-ID: <20261028170508.086384378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 56964f6a31238fb41d5830bb42520c5b10ff7d8f ]

Make sure to restore the TTY_IO_ERROR flag if activation fails to
prevent I/O attempts on a port that is gone or powered down.

This specifically avoids issues like kernel panic due to unclocked
accesses or NULL-pointer dereferences when accessing powered down or
deregistered ports when a TTY ioctl races with hangup and open.

Note that the flag is set again in tty_port_close() but not restoring it
on activation failure leaves a window where drivers fail to handle the
ioctl-hangup race.

Fixes: a9a37ec33a1b ("tty: tty_port: Move the IO_ERROR clear")
Cc: stable <stable@kernel.org>  # 2.6.33
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260908084000.218528-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Adapted to the existing braced error block with explicit mutex_unlock(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_port.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 494500c453ccb..6f3b4eeb44b38 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -783,6 +783,7 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 			int retval = port->ops->activate(port, tty);
 
 			if (retval) {
+				set_bit(TTY_IO_ERROR, &tty->flags);
 				mutex_unlock(&port->mutex);
 				return retval;
 			}
-- 
2.53.0



