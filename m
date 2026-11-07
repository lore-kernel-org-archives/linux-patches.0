Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060622;
	b=BOQRxXOkBLtM1lOZnpU5wEwPpSCKhVRCvScbrLvT760t8KB5wbD4V8c0sffMw1euVR7J
	 FL70dvgYOY+YTVaad6lRK1NapW+zz02FQkTf8zsgaNtrIxU5Ty4OEhJ+s3ovLboYlj6lS
	 genf/uvTW3Pm0COT8lbyRtHDexaSTewIux7OjdlrBroOBJY5fny8bqwi1q1cwU6f5Abt/
	 b2/0bjZym71mh+6hgpaXq68K6AmIJjdYhO+k32YhgZWGIuIN1xvXoIL4EGsAq4slQ6ECD
	 A40MX+xw1OsBychQIdtqlxoGS0MBhJ4Fmzi6qcUWB83ZSWDC+hbZmUeIyHbN8Nx117g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2S+adVUHA+UDAHui+xMV+QzUxtn30oYajkDwzcmnqSU=;
	b=SAW3SoYOtActMd87Fzx/nOZTzZ5xx0gqeqKa9BbtDirjInT9uyWd1MVwyvBib7ZRnA/F
	 Ps0FbooU7OIMkKLew3MybAbs1pQT82hCLWmNys12xY/JQxMQFLIXMfk/rQ+XTWjYAUbHS
	 D1TmJP8RT01OH/zEIkZdPTrpm0+z7pXfUOrBpA2mzaA6fRdKltymT+cWD8nE3JuD5Gn1k
	 XVDiRAXVGnDdUL3Nlk3W7RjhgOz0k43Lkx3sjMNAj3jewuHaBxPfYN4/Q1vX5w8aE1TGt
	 3hD9DTIHMqScqzL//fbg5h3Cdti1yhfDwjwjquW7akrv3wjxEM00eRgmJHAHHG+ZlRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R9/g+S1l";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE10606A326;
	Sat,  7 Nov 2026 14:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9/g+S1l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9401F0089F;
	Sat,  7 Nov 2026 14:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060621;
	bh=2S+adVUHA+UDAHui+xMV+QzUxtn30oYajkDwzcmnqSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9/g+S1lzfMBITTBsIdTJdsWknOpQXHJyclU25T6URNr7VEg124DG2Y/D/Y+iVtWG
	 XJkw9ZYjOg/dJtTVZwRcvLnKP4TAzvut9D3+pTH7BMsStkE+POUjVL0g3+JQOC0Wqv
	 v+RMQEtAVIV+o4Ljr/KCp98aqYxsPJAlXOeYY/Kc=
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
Subject: [PATCH 6.12 0069/1536] net: usb: rtl8150: handle link status read failures
Date: Sat,  7 Nov 2026 08:34:45 -0500
Message-ID: <20261107134959.605832203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



