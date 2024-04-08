Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880FE78285;
	Mon,  8 Apr 2024 13:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582582; cv=none; b=BEkPpUk8VjrpxliMsHAouondYt5lNxFwz4VKyY3BUyKcRjqatnEYP+Rnb+zFm4B1D1HtE3V1TVYiSq7PggqSZaEBnR6G26menIPetWsLFBFe6RUF8pxfuwHVvWnutB3BAtKNhpp3XInLuZPmE4GwrwtxaJuqD2DYS5Dm+D+iBaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582582; c=relaxed/simple;
	bh=jBp6OQ12oxNGcnQ9O3YzgrlxiFgqEJma9yEkj4+RtZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRhcIdG8Pxo6qDJdpOt7PxbKF+fqT61wYX4v72LxSl+YHTvh7UZCiyt9bWa++s6c6608NM8yooo9UAmNBTlVYW6NskzMRYHWSQltB4V3KrXlGkl5GMY7gOUEnVkHzfJOlpyr6hT7WiW/p811vxqc20gA/l5W1mZwP2XEN30ilsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkIZVNLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkIZVNLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA6AC433F1;
	Mon,  8 Apr 2024 13:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582582;
	bh=jBp6OQ12oxNGcnQ9O3YzgrlxiFgqEJma9yEkj4+RtZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkIZVNLVl6OXZbczMh2gOQH2OjjxEhxDVyep9pzi3cUC/d5XKWkrNUQ9dQaTfW4eE
	 zxfdlBf21ppOq8gxfZLGHz0VJsWAh83JfRwv2HaICmqgiuDsOGavquILPUQgy/ZzJQ
	 EmYrV+OuExyL7vNrsPrk05SOYBwBwujQzsbT4jL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Michael Walle <mwalle@kernel.org>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 104/252] net: dsa: sja1105: Fix parameters order in sja1110_pcs_mdio_write_c45()
Date: Mon,  8 Apr 2024 14:56:43 +0200
Message-ID: <20240408125309.873658070@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


