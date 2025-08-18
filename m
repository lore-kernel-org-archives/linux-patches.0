Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9863131AF15;
	Mon, 18 Aug 2025 13:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523888; cv=none; b=HQI2SWCYAx4fPZ+uf51iOmypwLDgGGxDCEuDYetc3DN69crl86GmHmg2HRQl+4wm+go7csU0ZI2siKILhkNZydWys/UL7nPARIV1PEqSolMit/qnzYhqzWyFt/qginp0isydmIeRyXGbKXWvNEVsm3PJucTeRZefK69+HSNI94M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523888; c=relaxed/simple;
	bh=CCxUmdaizfa9kV827qYskSGsdCphnOTGyC8eS0EjjbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IYvCguqhGse6AAhQ17a8IlwtNmxc7UzE8iLbl03g92esNwkcUfjYSc4LXeqAF6GCzwzzvkj8lxd0XICunq0Mq1Xw0MBx8IJtWYG45d/clbEWPGZsBC1lLd4wjOi7ENe022jAYXJnGU4c0mG5xOKDuwvPCzI4OW+Expjws2UtKBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1FR8xCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1FR8xCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A83C4CEEB;
	Mon, 18 Aug 2025 13:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523888;
	bh=CCxUmdaizfa9kV827qYskSGsdCphnOTGyC8eS0EjjbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1FR8xCfsLdF4p4NNBXZED4Pht+nxrH4eBL1vfkTxx7SpjD/MsUeHnbYaQmKNI2IH
	 aglgiqye5bHPlbVcmbc22GkTbiNXCm2JIBjWVAoeQXs/y2OmzdNZxi/APuLzGsQEIz
	 WdnljAl9jskWl5tb5VwDxnAMMcYzWhVkzs2l0EPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 304/515] net: dsa: b53: fix b53_imp_vlan_setup for BCM5325
Date: Mon, 18 Aug 2025 14:44:50 +0200
Message-ID: <20250818124510.140703945@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 184946e8cee9..55e1844a5e9c 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -529,6 +529,10 @@ void b53_imp_vlan_setup(struct dsa_switch *ds, int cpu_port)
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



