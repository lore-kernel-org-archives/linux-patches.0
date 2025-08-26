Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4695C12CD88;
	Tue, 26 Aug 2025 12:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213035; cv=none; b=YcYBGkcAhHKWbi18zC7DRnZi9hSQbTzhs+NZpQZS9i0CqPbs0WEnUbdZXnqUIwU7DrfDASLpK+H+RQh4HHAZ0/nye1VCvMyzomWRh9fVp0G/m6m37YurYdym9t5yNLR2tTI1BWEjmXwNdrux0eSmtjYNHEF43U9sXIzRoGAMVQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213035; c=relaxed/simple;
	bh=6zADmjKL6hz/xRv1J7V0LhHNX8rrU6NrY0BNK3I7tic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dv+Zty3jSLpPW2y9Ni3NMtCv7crd6eKbjwf9f3ZxwxDDEzCEUPvL+ypg0DZUVPg4NJMZyEfj3zsik2gkUa3B53EqLiwTxnZoJMRDO3c2I0pgVWHwqxPUoGSO6LIzdGoPaZo8t1/yYYSAhWOZMB7D4cgFl8H0ekafiAb0iFNgKx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXaGrPqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXaGrPqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27CFC4CEF4;
	Tue, 26 Aug 2025 12:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213035;
	bh=6zADmjKL6hz/xRv1J7V0LhHNX8rrU6NrY0BNK3I7tic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXaGrPqdyPy9s3SMWMX/K/yGlcoyMGF2pCsKBfjUegKtQiUa271WqEYP9JyLTRguH
	 +nK5HLSBZZXsAfhQfS0JAUL6YaDROHgupVdIbP3YKworUm7GbHOIF/jAMrBnHmQPAq
	 29NFaFLTZoAwFxUcxQkf3wFxRb9fUM+S7raQVN3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/587] net: dsa: b53: fix b53_imp_vlan_setup for BCM5325
Date: Tue, 26 Aug 2025 13:05:46 +0200
Message-ID: <20250826110957.951150611@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 004d2c988ff0..e82554cedbfc 100644
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



