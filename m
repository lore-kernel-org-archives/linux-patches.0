Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026530;
	b=weurSLiFIn1Hu62T1rVshCuy9m8ET9whbUnC6E1PcSTfRKX9CcHJUtwVv5qD2cz1TyWr
	 DdJpml62vt9RX0T0oVETgGGlviip9M+XnLzhZN5tqzgd0x00f64+BnYii/ZRSBT8EuHM5
	 Ml2QJ6HuNrZn4jzNdxBR7E0TzDeehi/tVJ2l8MHMoHRJs1fhbd+4B6fH+j3ArFKjJ6kDp
	 QEFwZ9GFMFJmYo+XpZXa+OJXKnnLyz9db1sU8pGW1s4AhbFl9q44QdxvY+u+4EonA4sNb
	 whGTCsCoTDZZ+rwtQgStk0CETrX0TPZq6ShYTXreGuGh3xZR6iXiN5JY4UVZ4SFt43w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YiKQFJ5BMcJnSlBjyUCGb2hACj3MjOQSDeqEykq0MzU=;
	b=x6h5kaU6teLISakhTAwJB9pbpgd5L+YCcUJdTPJKc+dWLEQoXTDXjcHi+atCYNArxYH+
	 FtvaMD87IjiQYCM4kGNrqX8cqFmYmdTBtfDCgGXVqmYHPz2ftv26XVvIyx5Z5L8KpnK7i
	 w+h1vWKMWGCr5diEJNcsGuXoIcupKD+ZGBVuvWPV7hAJDA/vIW7NtgH9XIemTReeQmqsH
	 T2PlSMwSLToIhcCmkSu9TGse4s6arc5INtLYOw6SkCdcI7mSsTrBZ9V7ccyQ191D9KWaU
	 zwBvmpYQ5dFgCdw7MwiHaGf1aHzu4ytuVP3zF04QCASpRYzJfVFauXBm1HIcsePU4Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DulPmZQ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195B1606A31C;
	Wed, 18 Nov 2026 18:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DulPmZQ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BA81F000C4;
	Wed, 18 Nov 2026 18:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026530;
	bh=YiKQFJ5BMcJnSlBjyUCGb2hACj3MjOQSDeqEykq0MzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DulPmZQ8O3ntS81agquiCxgzOrv3uL5oyym3JdusW/0XDrO5J0i/PjRv/o2RxxWe3
	 Qg106PQr5fsEWgAIsaN6q23J34bVSorx9wMhsIZF1mp3/D3ibGXK8ix5hwyZJS0lDJ
	 KxH+nNWCW4dx9YDaR88DQziSA9F18u8EzhoApCSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1426/2151] bus: arm-cci: Drop cci-control-port node reference in __cci_ace_get_port()
Date: Wed, 18 Nov 2026 15:52:41 +0100
Message-ID: <20261118150213.895926348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit 810ccc792193909ba9bbb4246e0eb0de14dad724 ]

__cci_ace_get_port() looks up the device's "cci-control-port" node with
of_parse_phandle(), which returns the node with its reference count
raised, and only compares the pointer against the probed ports.  Neither
the match nor the no-match return releases it.

Drop the reference on both paths once the comparison is done.

Fixes: ed69bdd8fd9b ("drivers: bus: add ARM CCI support")
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Link: https://lore.kernel.org/r/20260923164122.596910-1-oss.patchbox@gmail.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/arm-cci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
index ab9b49451f8f2..25a741e48573f 100644
--- a/drivers/bus/arm-cci.c
+++ b/drivers/bus/arm-cci.c
@@ -167,9 +167,12 @@ static int __cci_ace_get_port(struct device_node *dn, int type)
 	cci_portn = of_parse_phandle(dn, "cci-control-port", 0);
 	for (i = 0; i < nb_cci_ports; i++) {
 		ace_match = ports[i].type == type;
-		if (ace_match && cci_portn == ports[i].dn)
+		if (ace_match && cci_portn == ports[i].dn) {
+			of_node_put(cci_portn);
 			return i;
+		}
 	}
+	of_node_put(cci_portn);
 	return -ENODEV;
 }
 
-- 
2.53.0



