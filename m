Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057203;
	b=bSXaSVZuPtbI0uEqWOmFB8p0wZay0S19AXzT0W/zEsTTJsc67D6JUQRXgetYpCfHiN5L
	 Ve31UVX+u+qNZDEHMyJl/46S8Tqa8bCBWoRcT12q3mlK/aPwNjlF+aBWA/4OTF/JwilCg
	 09mEikJJ424/w63h7k7dwbl0M627iT3WiZdX0S6HPhPZzBRl5vCQUg9AUhOLROU5RQIIN
	 4Eeeofg6DI75re7k9wWzYu4E+uZZNKxnP2+RLxs9rmHi6gvKjNW1g0TdHBsnmzOPcRXHK
	 50vxo39S0JAmP5EAyto6FMOZiAZNyGAShsI+z496iQxiJFViZPg5JezX4l/gdsab7wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7PXIK9hLdPun1omOlIbnagkoSchnW/4yHbM7QdE0hnM=;
	b=i/A7JdilkL/yiGqQOwaYZyoOQh36Y4fp5wHwwP6ZqOWEqUs5aDgg2dMtELuP1Cp8MUIt
	 C65zmbPDFODpPS5GFmZ3hed6+cSXA93Eo9wSi+KAmVrIu+OLMus5EdJ2t7C8h3Vz7Hn0K
	 5+etl3RMeaeOwp4OdGEhJgvZwlY45BQUz6zYRxiUXpPDpdtPpwKX5Bw1g9Z9XX4AslG+Y
	 SPHJd/O2DQYQ3d4xIJC4+TUX8vkgQh/a+cX5FZkODqoYRhIXXnVRv6xTLX6cCFyiLJ8VE
	 dJg+11008lo3f32KOY3USYb/W/30vtg39QwfwrM41149LWeBwiPU/PQoj2mBUXcSE9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MpGVV2pm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E38606A33F;
	Thu, 19 Nov 2026 03:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MpGVV2pm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20581F000CE;
	Thu, 19 Nov 2026 03:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057203;
	bh=7PXIK9hLdPun1omOlIbnagkoSchnW/4yHbM7QdE0hnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpGVV2pmHXx003j+mvfYYKpgxuhYK7XU0AF1z0r/0hC6pqDcUk55/HAm6hUciDbml
	 vlqMBPmN3fGiWuhCNM1f0xTIj1mm4SaFztmB166QcYkh7b5qQZjtxvYh6Nvfz8ZKMB
	 bgC1aaHMMCit/zzFBJr2KgYEZlHCjyZLxw7U9X6Q=
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
Subject: [PATCH 5.10 0045/1848] net: usb: rtl8150: handle link status read failures
Date: Wed, 18 Nov 2026 15:34:43 +0100
Message-ID: <20261118145912.991269536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a992253000c85..c910a7ec06d61 100644
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



