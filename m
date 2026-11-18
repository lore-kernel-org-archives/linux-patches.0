Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049632;
	b=hJXzFbhrVl0RG4pv8huzCJEV7VKGIkyjxo15jsvmzKnHQl/D3SRTjkZ0FLX6JpTDT2EG
	 oKM716ANZsLtKsSp4nFNLLwXIcOMIjoiFJmvThO32RGkqTExIJp2hspe1f2+jxqqwU2xk
	 RiakaCuWTwNI2t9inBacc8AO1TTEUh2KxzO+6Wx6qLgrewV5H1mC60P+sZL7Ln61amssz
	 NH0L66ffaW2BM67RbsKd3G2sHtIo0UISVt64NgB77lJwMdcN7uc40gI89puJe0barts2A
	 ExTCl2DqoaAp+9b2Tv+wIuA/+1M+2xcEsyBvrdDpxWFCOyUMzWVj1c6fkUFFZplca4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P7WHQuClNiO9V0xdCr4cF6JQ+BlMdBtFgqsKkVtjFX4=;
	b=HQJzB7CqzoZJqoar/QlvERxolVJRm7cAVySHZDWVWwYH8UEH7n8Zyk+NkswsPyKcOyRU
	 5bmb6+t0HJ6EnjhZb6DcSOntwJzF5Y/PZrvsh83Mb1S4d30N/CgPy4fgDUYTZ2RSvHZVe
	 jVt7AfGLGZyc306wM9S46wsEsNZfFllirBiIkle5lhguE6DgeilrkAvFCbT3ZXLJVTtsM
	 qkaWOkWrKPMSyIvmgdPaZ5D5RpP91LFaQrMj9VyHjz1dGtWjC6rtKV+Fn0maggwB/Um2V
	 CXh7KVBDwIafQig0gB5jw2Ny5glRrXPTg0l5qn7+Ac4xfZBlf/bPNseGBk0nlYcb/eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yBSva+Td;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A250E606A32C;
	Thu, 19 Nov 2026 00:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yBSva+Td
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AD91F000C4;
	Thu, 19 Nov 2026 00:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049632;
	bh=P7WHQuClNiO9V0xdCr4cF6JQ+BlMdBtFgqsKkVtjFX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yBSva+Td+3y+oygs5dr+iuHdBJ9U7CmbzxLxXcpMhGndL4eHQ9We1aPcnKrLr1Xa+
	 2cmwI5hbMW1PY4lq8dTE67pDHtIVR0rGuEPbA7AK/3LJxKojPieXQ8rTIzHWJDt4Sv
	 8q491pn1oYimSUGV8v0MzHl+cChG0ZhHVaTS7/Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2422/2857] bus: arm-cci: Drop cci-control-port node reference in __cci_ace_get_port()
Date: Wed, 18 Nov 2026 15:57:36 +0100
Message-ID: <20261118150328.759195584@linuxfoundation.org>
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



