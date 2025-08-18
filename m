Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F92E33473C;
	Mon, 18 Aug 2025 14:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525669; cv=none; b=tMj4+wbAwm9bJeRUD8qAkYmkYdSGe36OSvjHcLcicDt3jc6A2s8O8ZwDTVdtsuWJ6ZufiXP9IUFPaC97Pg508dAjMVta7pQOjWZasF+llTyX3oJpQP5YpU6lgsytcZ22gju9zH1FTin+vHJKvijY/YLIo0lW/SRZcbt0/lRqAp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525669; c=relaxed/simple;
	bh=PmkSrlVWskKcMzsX11Kp6kkRvNl/tdA5QBfK/S3NGzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HKZ3gSYosrDAK07OIPfCFrOBfJzvLQJTuec/gIu5VnYZPljWba+pmAjlQaxhMxHKnSZnR9brMoiR0CYVQ/OWNQl6OWoQKkO+7ZnjSYBVFl1VupGYPGFdY2+EgjsdKQWc4sXIMRKIvOtnc4e/P8BIJINfWvjus20N44p1pG3XwlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7rMc29P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7rMc29P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C35C4CEEB;
	Mon, 18 Aug 2025 14:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525669;
	bh=PmkSrlVWskKcMzsX11Kp6kkRvNl/tdA5QBfK/S3NGzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7rMc29PuzOrH5DtnU6h8we14nzHAm0Xj5/xxk/Lb/6ZRWhjsgW0AKASOAfj/MzJ3
	 5QTSbiyRq22mws4/9czOsCqMO5iv0rLjWdoezBbuQLemsy/XwqtaSMLLW6x56iCBDt
	 hmMCGdxF+klrm8bTiouGr4OYP6rtxLGQv9B3C5EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 331/570] net: dsa: b53: fix b53_imp_vlan_setup for BCM5325
Date: Mon, 18 Aug 2025 14:45:18 +0200
Message-ID: <20250818124518.603319490@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



