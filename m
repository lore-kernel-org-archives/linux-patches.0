Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B391839E6;
	Mon,  8 Apr 2024 13:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582711; cv=none; b=rvApxSzud5kfP919N/ZCpYmN4ByrEsJmTnoOKMQrWsL/AujxSC0CaVeCSDiIZn+ulFyGljNkHQb9fZP6faB1+9d+hMpypEWrmoHnhjT9YtEEZqx3uye/q8k6zRGvLk9pM0rIWYP71YchDjYHUM61oBu3ntaKgtmSlToKZ9gVTa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582711; c=relaxed/simple;
	bh=uZ68KJto9LnOEQS+IUgmnvV/z93uE1lvTLoWDKUJJ+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7hZyiSG7Uve315ZPPFPrss1ZGmKJilHGueiOS5epLG8tL1cRW8lAzi0oPsJ/oeQEX2Can+pbmU2CxrixDUNRFinZ+TYGIy65KhaGgTVtWh2qb0yl0fGsBRH0I919wZvFh04dp5y0zg7P9uo62GCrA5/pjOkg4YT/BRnVi3ytZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJB3lnhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJB3lnhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FDCC43390;
	Mon,  8 Apr 2024 13:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582711;
	bh=uZ68KJto9LnOEQS+IUgmnvV/z93uE1lvTLoWDKUJJ+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJB3lnhwlru4M3pW3glgu05fAfUiFt056+MToRpkBQR3/Vo3cgUAZjIhiDV07pgZX
	 cZ5pa1FqfoovkAoAP5KQljAXyE5KpIRru6yJQCVKemv3uh6x0NtxtzzFCFQszsvxa8
	 uoaj1jd6JTzNAxHkUMURR3qb+oAbWs5/1zDbQqUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Michael Walle <mwalle@kernel.org>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.8 099/273] net: dsa: sja1105: Fix parameters order in sja1110_pcs_mdio_write_c45()
Date: Mon,  8 Apr 2024 14:56:14 +0200
Message-ID: <20240408125312.376594462@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit c120209bce34c49dcaba32f15679574327d09f63 upstream.

The definition and declaration of sja1110_pcs_mdio_write_c45() don't have
parameters in the same order.

Knowing that sja1110_pcs_mdio_write_c45() is used as a function pointer
in 'sja1105_info' structure with .pcs_mdio_write_c45, and that we have:

   int (*pcs_mdio_write_c45)(struct mii_bus *bus, int phy, int mmd,
				  int reg, u16 val);

it is likely that the definition is the one to change.

Found with cppcheck, funcArgOrderDifferent.

Fixes: ae271547bba6 ("net: dsa: sja1105: C45 only transactions for PCS")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/ff2a5af67361988b3581831f7bd1eddebfb4c48f.1712082763.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_mdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -94,7 +94,7 @@ int sja1110_pcs_mdio_read_c45(struct mii
 	return tmp & 0xffff;
 }
 
-int sja1110_pcs_mdio_write_c45(struct mii_bus *bus, int phy, int reg, int mmd,
+int sja1110_pcs_mdio_write_c45(struct mii_bus *bus, int phy, int mmd, int reg,
 			       u16 val)
 {
 	struct sja1105_mdio_private *mdio_priv = bus->priv;


