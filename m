Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A914527707;
	Tue, 26 Aug 2025 13:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214490; cv=none; b=qG1FBP6LwmzcoYQ7mAgGQA9S2tLEJ+N35JJ9vNA/IKjCYj3ZS1Em0b9ZiggOownDVkGQm5/206mKbhpwNGbZv1Db7Ro5Tyk/w4vyg1P48YA2bN6Vu7sJthUZ6c6odQ0LWao93M9MBm4Z5w/dGnW/OxtGcs9e70tcxv1TSocEXWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214490; c=relaxed/simple;
	bh=ERLICgGIsoAEnnIegw7Y5t3jrnTgsF6/PMrRNO2NSac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cV2q2xCDIJXGAb7ErdPrN0A9pnUz8ak9GR6b89oo+463WHK1V3eJPx54U185gm76ic/mlz4ymnp1kymex3S+4lHb8WTDTTn1cha8ctxOEENm9HjtQ/hLIYrsFK6cV9aLnoKuSqeIIxxpxofhuNFOKY/ZADgLdu4gZ13EsPCsm/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yfy4pTBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yfy4pTBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAD5C113D0;
	Tue, 26 Aug 2025 13:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214490;
	bh=ERLICgGIsoAEnnIegw7Y5t3jrnTgsF6/PMrRNO2NSac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yfy4pTBTCdPxjAamWddcoLvgAbBslAdkCV16dCCvWkfRZ/4ZdauVqyBtfxWBiAtHS
	 fBrqq9619G//IUtfUwZ9hBmvJROsOEUPSBoGNZxnqaoqYDj6nV0fDTWmxr2bpJqn9v
	 BaWQORtakFtIswGDpqI6iniRl6X0VeS+wI6v2Pb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/482] net: dsa: b53: fix b53_imp_vlan_setup for BCM5325
Date: Tue, 26 Aug 2025 13:06:51 +0200
Message-ID: <20250826110934.716496401@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit c00df1018791185ea398f78af415a2a0aaa0c79c ]

CPU port should be B53_CPU_PORT instead of B53_CPU_PORT_25 for
B53_PVLAN_PORT_MASK register.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Link: https://patch.msgid.link/20250614080000.1884236-14-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 1a23fcc0445c..ecc887b5c8c0 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -507,6 +507,10 @@ void b53_imp_vlan_setup(struct dsa_switch *ds, int cpu_port)
 	unsigned int i;
 	u16 pvlan;
 
+	/* BCM5325 CPU port is at 8 */
+	if ((is5325(dev) || is5365(dev)) && cpu_port == B53_CPU_PORT_25)
+		cpu_port = B53_CPU_PORT;
+
 	/* Enable the IMP port to be in the same VLAN as the other ports
 	 * on a per-port basis such that we only have Port i and IMP in
 	 * the same VLAN.
-- 
2.39.5



