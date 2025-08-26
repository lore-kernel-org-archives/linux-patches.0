Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1356D35335B;
	Tue, 26 Aug 2025 14:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217806; cv=none; b=tVeIKngbu8NcxGyeHsKkdybBtardROApsiC0NWtzjXQuqAnLo0w5TYUERW6l+y6Cw+r3J0LuaqQ2DvOzAuoFzTBYsBagohCCNmtoTVifjuCujPLqlcv1w4QHKzIiFSKUpGiJEDCzwjxMWk9JAiqcvJHWbpUWTj8AVRvlSq97xsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217806; c=relaxed/simple;
	bh=J/4+S7lQXpq/nLBzx6O3wC7SwWC8Frv4t0DSdFs0W7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tzKp/xjJD+kSe/tW7Pp0lENjg+JuNTxjdO9mgpxtnV7FBOGAAcWgRnvsKVOhhTgzqyL2XV5DK16GPYSB4CkZljlNDmOeVeYpAA5oSYrww7J4UoA2wmfq9V9333TbZarc+E75Xp2LfKMDNf/uR4vMma74kN4Dn9/PKI4DBvTASvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEoUiL7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEoUiL7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE53C4CEF1;
	Tue, 26 Aug 2025 14:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217805;
	bh=J/4+S7lQXpq/nLBzx6O3wC7SwWC8Frv4t0DSdFs0W7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yEoUiL7D/PLQrzXA3ku1i+vZWKslONFZtlK9ePwe1oI09Z8Kuxy1NSLOEnC6y2vFq
	 lvetbbIiaUIUCpdtW6oig2kikxbQatCvt5j+AosKoj6O6Dp7yoODp/zhp34XFJgBKv
	 /UJyWBQ6c9ZUTm1qtXdYZmflMO3BB3apdZq3Dixk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 282/523] net: dsa: b53: fix b53_imp_vlan_setup for BCM5325
Date: Tue, 26 Aug 2025 13:08:12 +0200
Message-ID: <20250826110931.392910885@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 39a56cedbc1f..971c134cd71a 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -504,6 +504,10 @@ void b53_imp_vlan_setup(struct dsa_switch *ds, int cpu_port)
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



