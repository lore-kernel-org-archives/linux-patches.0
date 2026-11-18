Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033561;
	b=bvHpsEyqTnitbk1RCTnGUMP0u7w5P4/g4Afvph7eY9XZ4sO4HaGlse5XOUeET3T/IU5b
	 Jn7KqpfZd/Wj3kWtrwnLZxJnPnnWP1joZ9Z5s6j4ZY51iYLl9IQtWcgN0B6UYOs0o6851
	 NJI3Hsq3BYV0xU4PSKxUX5xKfTyJ/gRqbp8xN/E1rkg5HsGls7dT5UxwzcmSHNFaQ3A7F
	 BEtWcmRCvB5woMRvHq5JpBSmNdzUHYSffPv/URtn5hKB/FLVR8wbxz0YL/ZccGUncc3OC
	 o774XxToUnJNDd8Uke2EwT26dDDiAkUjrYB3OekwjZyJLUGlIDRIUM5DmMUI10kFytA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gLc+olaExlJ7U6vFt98HglVlMDiLgqf6aJ6QX45eUGE=;
	b=Fiqbf6/BZR6RFhQThwiuvteVZ84LlaUuCZ3aILWGdoz0/VMrPv0fYGzs0idyPmtnndU4
	 RKBu6e4Nkyp7Ri11fSH+wDoQuJY53hocI6D+RbCUsJ0kzzQVuyzzL3I94OI8pILj0LYui
	 C2i9YlRwDTqJNjBTWA8fQiVT29ofx12AV49Oc29okXHwrJfZcC2Tz3J3DYunZSdRV3GVW
	 /Iv2Tld3kKM6ypy3qiETtbcCgJgEtExjroEhHi0dbgx65MJqRB/FENV7ynH/bV1qspNEX
	 Hl2ile081KQ6zePYVhEf9gpFHnguSsBkDR2RNa37dpu2FPaTJyV2LOwfTvp1xuB08lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eb6OGcCT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F276606A32F;
	Wed, 18 Nov 2026 20:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eb6OGcCT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F9A1F000C4;
	Wed, 18 Nov 2026 20:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033561;
	bh=gLc+olaExlJ7U6vFt98HglVlMDiLgqf6aJ6QX45eUGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eb6OGcCT+rnxHX/mSJoeHd/ikwcgaonW/pPJhGTYz+ZXMMaTRWJ2cALzh12qRGZXe
	 30Vr69lz75bXCRCsj3V15q1QPcpuTLU0G6f1aPWLGwDMJrgIs4A0YUmmaqq3r9en8L
	 ltpDhR5m4tjYZW3fZh0cHlX4lovqXJAboDGU2k+s=
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
Subject: [PATCH 6.6 0057/3318] net: usb: rtl8150: handle link status read failures
Date: Wed, 18 Nov 2026 15:11:19 +0100
Message-ID: <20261118150315.664031537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



