Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041424;
	b=3yJ/luyNJ3gCckImAFTL+5tQY1jLhk584M4AtIDDa15oeRelp138SJPzi/tIfMLBXwF1
	 gnpnrFqAxscZDHViIZd2y64WWF724keBcf07iv5QEPOVufM7+c9J8EICp5FJ0Vyn5GnP7
	 eb2XWwW9GmKvYo38mvLDRS+zhgS5Bzk+74oOpSJ2SXEk1AnqKoBq3uMq7dkrv3pvTtp1N
	 Az72M6jZAPovr+T3ZVsH/wP0hURkHPrNZ8uKYXJnoT6HuRfv3G1wu5RB08fyc83GAHWDh
	 zTHufIhe3zWHandW706ul/WoDZ2StYGjaIUeAN7dNnBW3FgfgjFksQUngHInracyCdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dv9JPYbNkMeuQdIPAAlX1vUHgMUqSHjjQfyGfBffFaw=;
	b=qmkM/YgjBOIU1JJ9SyA5MWM1hPsT/Q59HTDEjmYjfSMjhth4VoX1ARItjjiniiWBOzwt
	 73/M2RCSHtDlI35ObuyTSR+ZyWS4GpLbOUBB6ZwkxdQ4PMSJWBFxlb2DBPwwZ3jRlc8rH
	 2N16WxH9TI2S43Uq2Mpasp3xfKR39AryUuylPym3Mbl9n4zcptekcTHMAGkmkTzyPu7BO
	 AzXgKewmzj4F11Czdk0eruBp9iUsOnZovRSoNtD66KuafEl7OIIpspuqNRuFZrSs380fU
	 l0My3DQZJ/1YrMbu7ZgRw6Bx5S3sVoikVdHH25up1rskQX4sZLhlEQZ6eiVP6KR+czw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y7dUk7kX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14D6606A31C;
	Wed, 18 Nov 2026 22:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y7dUk7kX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0D91F000C4;
	Wed, 18 Nov 2026 22:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041424;
	bh=dv9JPYbNkMeuQdIPAAlX1vUHgMUqSHjjQfyGfBffFaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y7dUk7kXlr1AOo7P8GoqDfo5Bd3KA8R/HI9Y6qrugL2j66SZiZ+4CSXntT3Jin+F1
	 CWNxD++fKZBPVIoQ5G2oKkP2kE/vbIRW3K+FGu1MmbZ4VhrdtAzELUFRg6EnisrhdG
	 1Jy3W+sNJymWNpWtLonoch3icW5EBvvrVdNuweXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2802/3318] bus: arm-cci: Drop cci-control-port node reference in __cci_ace_get_port()
Date: Wed, 18 Nov 2026 15:57:04 +0100
Message-ID: <20261118150444.735111759@linuxfoundation.org>
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



