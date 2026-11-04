Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829370;
	b=waWYWWMLEVwl9vTWLxMro0x5ifyP+JboHzV2wCIGF7k6uf8yr+xrDpU+0+bhSjDtOeOY
	 2mcL8tOjBEjwHJ+yPodXessUOg5i8dW8RtW2AlwQ7YxgrZmfchoUSW5sUhX61aMe03/ju
	 udSfONwODdQoIw8wWE3zAtA9jhbvNwQ9t4DuiNg/iuX21vGN/KX3rn4BwvRqA7wVGv6DK
	 xgrwIwhHro6dY/xc28BMRclUp/urrm4sELr4tCO6l3IEyq6T7aS6V2n7pxa+akeyh6QvT
	 1K0SRp3tHzUk0e7Rtx23bE1zG8Bab6nrurax5vwF5Aqp07eAliT50hqgmzPvuRRl26Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0c2AgIOV7OVi2bUj2M4DHxG6RbWKGX3WqfDsBgC5wv4=;
	b=f6fPPC8YW+46cvLnUcCdRZrx3mY+fIVPpBrONhm5fQgct+lahBuvZrudfPSfN+C3sOlr
	 LXo4GT7CPh7hIB2V2wGn0/FUHHsUH+UMLGhodL/LzCdZkGv7zqOp+gaKoi79jhvJXQZl4
	 01fb6IciLnK1AY7V9NjKW4JEHfVGuLNKYcHQeTtp465H+HfrqdYuTiA+hYyuGUL+z7WbW
	 XilO8huH58mBrd7NKJX7pMPsS8hBnS7EVOU3od1ltTufTHMFKcwZ2qw5r4Q++9unpUkKS
	 6tYQ7rSIXgzOxkNjEV+75R75J1Xg9dnv7eHOk8vxq1ztq2oWD4Z72SKmmLBaHKJNtmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a/vhXhgH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E270260C2990;
	Wed,  4 Nov 2026 21:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a/vhXhgH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775A61F000C1;
	Wed,  4 Nov 2026 21:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829369;
	bh=0c2AgIOV7OVi2bUj2M4DHxG6RbWKGX3WqfDsBgC5wv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/vhXhgH7pi4atnTIH6iW4k9vMzufvjewtGQ0MiniTQPZqm3mLlHVpaDAQTkM4JU3
	 Lowi8Df6z9rkfDwLm04+HqZwvPr39p7plHupMr55y2A9uPCK+hBC718MVFqTUEXSMp
	 WuNW7V9BA9AsGphX4f0eCtdWWmsgM2mEkTi7Fg0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9db6c624635564ad813c@syzkaller.appspotmail.com,
	Petko Manolov <petkan@nucleusys.com>,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0082/1005] net: usb: rtl8150: handle link status read failures
Date: Wed,  4 Nov 2026 15:56:55 -0500
Message-ID: <20261104211045.922301506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 8c9c5b9a689612dcb92a04a4218c975cd19f19d8 ]

set_carrier() ignores the result of the USB control transfer and tests
the stack variable supplied as its receive buffer. If the device rejects
or aborts the request, that variable remains uninitialized and the driver
chooses an arbitrary carrier state.

Leave the existing carrier state unchanged when the link status cannot be
read. A transient USB error should not be treated as link loss.

Reported-by: syzbot+9db6c624635564ad813c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9db6c624635564ad813c
Suggested-by: Petko Manolov <petkan@nucleusys.com>
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260630101216.10365-1-alhouseenyousef@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rtl8150.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 647f28b367b99..8c739d898e57d 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -734,7 +734,9 @@ static void set_carrier(struct net_device *netdev)
 	rtl8150_t *dev = netdev_priv(netdev);
 	short tmp;
 
-	get_registers(dev, CSCR, 2, &tmp);
+	if (get_registers(dev, CSCR, 2, &tmp))
+		return;
+
 	if (tmp & CSCR_LINK_STATUS)
 		netif_carrier_on(netdev);
 	else
-- 
2.53.0



