Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056135;
	b=aaN/X6CuUvv3SB7jv+AaOU4z0kIitQwv7DwmJ60HKlrD9SuboBWoqNNYsw6oul6Pu/+8
	 ZR/sa6mtnXpgP9/UmW5yTijrhppEvdSk+tizqNcUKANMsKHaIFh0siGVRsUV401zVaqtd
	 +rkCcyCqjimH3EmWAvRX4t/k0XmP1tjvzXRqorF/o3UQc+77GVxmxOnjMAjA8KzcGmjk5
	 Nl3lHip03SmX7gyY4UeM55l8QeB83buLs55mmYLbC0QvPN1yiOWorWiwnEtQiCDKUhjWK
	 N5BrjlWGQTK3GaFhbaVspNrWSMtCBlqAIBJZIPd3OUW7CmuEyPa7e+Lvm0ehqU5ADtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FS13flLohNts6989Eq3I/mWIexX2YECoLgPN1pkGAr4=;
	b=hiklRzdYTr4t6NqSMR2o/valsAm6tpO8bYaH9alL8X/0pevciKKzg1R9+ON1mHw/bNR1
	 kUtITfdSVI0YZ/c1nCsvDrCwEQN9xQkpqIffwI0oy7j16TNDFtWtr58ceJZh63dzER1aY
	 yiUYFim0+C1Nk1PNLKl7FTOsz9CQevFhvz07L+WhJfqQKxx9wYvQg1TE3i9Bx3qTfsMYO
	 YwNVbOhAwM0oIkHxF527E2aV5PFw7sAS6X+6H/lFE+g7ER4hghJKxZSLIan2pQax0MxRB
	 1IZRfFN2l88436WOR+79VF7gBWRZfW8bbDTxT2w1AdgWNQLq5iwmMYRSwtYr3SRWv5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=puyVyyR7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE726606A325;
	Thu, 19 Nov 2026 02:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=puyVyyR7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC041F000C4;
	Thu, 19 Nov 2026 02:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056135;
	bh=FS13flLohNts6989Eq3I/mWIexX2YECoLgPN1pkGAr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=puyVyyR7hh13grjVBr+CeKfiglWYWxtclUm96QoP8WL/R3d+aD57x3KIOk04CSWzb
	 kbq6/WyFXys4FPlEO34lAeyI0pm8zI6N2593+/dP808HnpFr/GQr3ESX7RxhbY2tJ7
	 xcVokQgzgEag+yDBMvR9N+DSBt1IE/mcOVs4vLw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1880/2214] bus: arm-cci: Drop cci-control-port node reference in __cci_ace_get_port()
Date: Wed, 18 Nov 2026 15:59:16 +0100
Message-ID: <20261118150126.465121625@linuxfoundation.org>
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



