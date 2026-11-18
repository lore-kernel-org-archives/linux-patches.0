Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045108;
	b=KD9WXvOaR2zE3zMz2ofYZCChqlrMrwc3km1AdhpKA7/3g0lcL8FAs+uIHDr6ZXzQkAJM
	 z3+STRbYn0eVe5C/r/GbJW3jaXk/UTQgXLm3X5CwqUPvjGiT7bQhmw09WTIMY0Sn17DNg
	 ZPXFbCbHs7kz3X5AmekrtMvHTSZBFVFdMAvnmQ3wCXXB+QVmXMBmBURjOc3i4U97FEEtM
	 /4iDZ/Z5Pu1MgqUfcQst0UpuOjDT496R7+1nFiQTnuNzdLR4W8Ib+6R1lYTCnSDMciZnM
	 IfRYkc06z7J3LsFLfvrwxW4/oFeVFBs8s/zQQw20u6J4ZLlByGO3hGIVq1DVrsFfrnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vqlYoh9sX6E/cYcYbBVXr8qA7X94RoGWfWRftw6003M=;
	b=koG8Pist3qbSGAZNRFOFnG/UdvTX+CfDEXw4ejOUJeZclTM0MhQ689gxCxsRz0WXWhrI
	 JVhP7O3j2eiXOWnPevGDF37yeu7/Nr/j9f2EJZGFhjRuu6oMSXKm5lLHVUv7FfQTLHwXe
	 C/Snt0g7/vyH9cmx7eX+KTlxJX9HVrunhEY8UPcuzUw82Z626wrTizL//T9pf9R1QNmpR
	 tWH2pRK98QJuTWjBXn/6A8vpbKwzqiklYMYVlAp5o6dB3zblZu8Jk927MU4jAI1LBGKV6
	 0IieeWatgKtqepYmkP30jJzx+v62CgPIHTwDAZ/oUToimhKwEPdrTsnbJ5b6v+RghFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VmWeGGmK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F487606A31C;
	Wed, 18 Nov 2026 23:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VmWeGGmK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBF91F000C4;
	Wed, 18 Nov 2026 23:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045108;
	bh=vqlYoh9sX6E/cYcYbBVXr8qA7X94RoGWfWRftw6003M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VmWeGGmKnxZwMxUJSY997UdoeMkGXLtbnJviDiRbUiDr3xVWxGVw9H+/vbvsznL9z
	 fjm+dTJZ/mNjn1/eMQKAHRZQwGqLkbhrrEnRyJf7W3KBnfb2M+URaqu2fujUhUZwwp
	 SeKZ2gY0q1O/HquwWk63eULfPX04ORmY8oZm9g+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0806/2857] media: go7007: unregister the I2C adapter on USB probe failure
Date: Wed, 18 Nov 2026 15:30:40 +0100
Message-ID: <20261118150230.593301662@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 14165cd16fa7c233aec6a407b56b304e7a283911 ]

USB probe failures after I2C adapter registration free the backing
go7007 structure without unregistering the adapter.

If i2c_adapter_online is set, unregister the adapter before releasing
USB resources so that I2C client removal can still use its callbacks.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 59aea928d57f ("[media] go7007: don't continue if firmware can't be loaded")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Assisted-by: OpenAI:GPT-5.6
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/go7007-usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index 6a0733c5925fc..ff479d6495c45 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -1326,6 +1326,8 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	return 0;
 
 allocfail:
+	if (go->i2c_adapter_online)
+		i2c_del_adapter(&go->i2c_adapter);
 	go7007_usb_release(go);
 	kfree(go);
 	return -ENOMEM;
-- 
2.53.0



