Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042978;
	b=zpF3jmuKLiUU4kw3S92KWD+zCB7GuA026AKG5/JVW1cMaiqXO+4UYj2ekX44ctIFiWR1
	 MvEJ8p1cPNvwdntGeokxGzn52wgWMIn/jyLUV93Dmz0P64/nlTHuTI7FehD00TFkdU1eA
	 hS0DNMt5RYi7Zm3qgY82uJqFbZPdSPvKlBbbUUVB+3om6u61R22s2upbL/dm0kjksOs4l
	 f+sy8/Jod6xaTJjzRS32/7z68oZjJzHYN7jQ0xvEtJOsRV+FlDzFbRW5L5MLx16YhEqi8
	 vD8Jxy2Xk6DkfYZ1nK9OyObL9WcQaKDaJGjiRW20UWCTXxmi+n7nmE98rDWJqvmWMmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4wJOZQmWhZcIEPCSymRybaHjO2UyKPJVFzOZUfWyMuI=;
	b=iEgyLpW1DAvgxn58t9GQDWJ+4f/QnREgtzXjP0UO4O/7JDDo6d/+mD69wrD/CFbk/rjD
	 9J9DVQL/6JixiU77vDNMvP8VsGQ9pUmuC3yjz5+SneQVN1zqUFuj86HA2M08XEEhpW72d
	 REvScDOB4jDyozLjqPJfhpvacAahsV+SFvCHDyJj4lA7QLpq6bHH+kIWmDI3OMiKLOoTE
	 C377HgrSTxTYJ5StzZt3CGU8VYi/9+wp4fp02xGcPyAEZXgQLJeDzmfZpvswQpZEvztM7
	 oTZqQVYPqce8/avTJD2EUtYjnUv2qrXO1rF1V0XXhuuWkIW2x7MBn81t0tZAIPNY9+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lOPzbQB/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447DF606A32C;
	Wed, 18 Nov 2026 23:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lOPzbQB/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999231F000C9;
	Wed, 18 Nov 2026 23:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042978;
	bh=4wJOZQmWhZcIEPCSymRybaHjO2UyKPJVFzOZUfWyMuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lOPzbQB/TL+CFGS/TMHvb/HWFe7wQggJxwWFbJlgC0isP5AlyUv7Yt/ph5rWkvl0W
	 7h2QYe8QyQpcKg2G+oNtCY09u/udLkU/FaPhzDG1bGZccKbhJY0nTnrEVmVQiCl9wo
	 y9tFo6ypo30WXEOZdK5B2OiLAjJkKxBOiS06pvTc=
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
Subject: [PATCH 6.1 0046/2857] net: usb: rtl8150: handle link status read failures
Date: Wed, 18 Nov 2026 15:18:00 +0100
Message-ID: <20261118150202.983286009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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



