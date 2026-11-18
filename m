Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050982;
	b=agz/MM2GjstvurcaJPfJjca0KfwDipMAqu02E7EQSEx1qjCAhuddH2EgdiqPtNnw28uT
	 SP2EK6gHjYOKMlTyXsssnvXwuAkA+kLfQjH4WrmxoYmkjx51vDINZoTkgI48R0aRb4A/W
	 cnTBlLiyFH+kaQIrn7OtSPRBDoMVB0i6t9sVMgXoBrgp/VtIzbfxyYD42hy97VArxYQ5l
	 /3I+rp5dLaHQgPkdS4olL1Q1M6FK/bEvte6PSVJf5uH7eCdtSpARpaMsw5YZTYNTCMyqi
	 EfGglkgjJI0ff6ZjRz/Tr4xLXPU5QRTvndGbo/viY4rm2Bmivt/3m6LOJvml87Heazg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fd8b2QQrB0/45soVJL+frVQoJ412/tHmEsMNLn0Oxbk=;
	b=y4UTfVCRKdDzJXnlKn3UVF+TenY8CXyBaQc9si0d1JUkKmFEqsxJKUYdGIaJLXZ0i6g2
	 sNmbDgNtvcPmsgznnOuswYFWQalCxRTcBdYxtoXfDWEQ0KUKoECc+QOnBigLUG+QfCh1z
	 hd5V7RVH0cWvpMV9nenb0lZx64LzccfmDSCNlYIcJ9PdXz7Jc4rQ3J8cfQmUqrpgumbEg
	 bUMUshWcChJ92vpa7JCwJGX9Bl8MBgdoLQRi8QrQt7d9iEGUdg6m3TN54azutIMwE+dH9
	 QZlnNoZv07Y39izI3yJCR7UMff8jECLBzYRzLc4bFQlkfJxcZn1fWFvsbGn9TxOcRXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eyrr3JBO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D781606A330;
	Thu, 19 Nov 2026 01:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eyrr3JBO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612041F000C4;
	Thu, 19 Nov 2026 01:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050982;
	bh=Fd8b2QQrB0/45soVJL+frVQoJ412/tHmEsMNLn0Oxbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eyrr3JBOttmF/vHQPj9ndFDzo8YNbxT7tfv27OHU7ROYzzR81JAtgpivqzo1t7Zhl
	 3ZvVAKy+DaMRyOrB4bMJOpo6iTFBttlIvzzUplEGY4+RfHi6MTNxBucU0clRDcywxm
	 3CfcXbZr21bYKi0exwdrAKz1EQnEYjUZxvrE7rm0=
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
Subject: [PATCH 5.15 0048/2214] net: usb: rtl8150: handle link status read failures
Date: Wed, 18 Nov 2026 15:28:44 +0100
Message-ID: <20261118150011.969199942@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4c7216b4c8ac2..7c2e6ae31d509 100644
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



