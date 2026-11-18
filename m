Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027714;
	b=wsPzweinofKiPW6kAthk9/Az/rj2oziBWfMg8djYHINgoOan76Qbtacd/tVQorUmdHrC
	 PcR1/yISJU3Ph4S0dNXT9AoF7Q6Jsguw3+/Uf+X1lSBRLF6qVTHsM9rMpnmDIuWDGYyyR
	 FZEtlD1ecVdLBIUceYYAMtbO/RYyWjZcxhC3Ug308MfpM3zA5OCrwZg1K1yWuxpvM4Iak
	 Y+F+uX0hlB3yXC90XaVdQPhDGR0Vrev7BNG+PteuyN6m/9NtVXxS1tzJ/r+/dKYdjh69k
	 iFbM/3QNCRlQ3v3axmsM9dke0h3/jPqNpyp8mJI2sfXvAxN9PkIrdZLwq0ufgskR5Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MyzGukLj1IxUsTHXhC26ugTPweoh9z9jlecZipEZkU8=;
	b=Fme9LeHCznOgGRgvYLkZr7vO5xRDz1Wk6DNv6OkWIijkXL4kmboeZrJi3yWvm5DKTXrX
	 AjjvwqN2JhQgxaTawNcRA5OHxBOhe6rhw/KSaprG6lvqyKoVFL+ZmBjruEo2smrh3bYki
	 WEiV62yiMXszJfNJldeFBqs8z5hzLEqUJdl8XPfAyUm3uebOMU5J8PBHj4NZplLmRCKY9
	 r8m8IIF9chPxRFbfAXbnm1BuOtizCjOq2yvSPzvtWS5mveyucuXYA1sDquUDzd4CZj/jh
	 XzSfP90frTYuxkPqyQvg+0p2qnLAG7oS/YTWaw+4z94AmEAGiIi7cVa71VgpkAGbFUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PpQWxCYL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12218606A33B;
	Wed, 18 Nov 2026 18:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PpQWxCYL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687241F000C6;
	Wed, 18 Nov 2026 18:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027713;
	bh=MyzGukLj1IxUsTHXhC26ugTPweoh9z9jlecZipEZkU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PpQWxCYLNGU8LYW1RJH304NAaX2TvoLAfxYa2JY3O9Gm2OMFfhV2ImsUxHnmXLaw5
	 Wfyo3l5nnqaeU3a/AlgWrrh+DlC/pZSzZ7Fk1tmEbVkElo0H9H5qqIw329T53MgTv1
	 yJZVsNLjH/1s8QSgLJ8I+i6vfoaTVGaeMYhVtGkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Joyner <eric.joyner@amd.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1887/2151] ionic: free port_info when probe fails after the port is set up
Date: Wed, 18 Nov 2026 16:00:22 +0100
Message-ID: <20261118150230.536273974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Joyner <eric.joyner@amd.com>

[ Upstream commit 4e15e0a941ce901d51b5f203713fa90feee9c4d3 ]

ionic_probe() allocates the port_info DMA buffer via ionic_setup_one()
-> ionic_port_init(). If probe then fails anywhere after that, it
unwinds through err_out_pci, which never calls ionic_port_reset();
ionic_dev_teardown() and ionic_clear_pci() do not touch port_info, and
so the buffer is leaked. The call was lost when the setup code was
moved into ionic_setup_one().

Since ionic_remove() already frees the port_info DMA buffer with
ionic_port_reset(), call that on the probe error path too. Every path
to err_out_pci runs after ionic_setup_one() succeeded, so the BARs are
still mapped and the firmware gets a PORT_RESET before the buffer is
freed, the same order as in ionic_remove().

Fixes: 0de38d9f1dba ("ionic: extract common bits from ionic_probe")
Signed-off-by: Eric Joyner <eric.joyner@amd.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20261015-ionic-port-info-lifetime-v2-2-57232013fd79@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 70d86c5f52fbb..42b7246342230 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -397,6 +397,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_free_irqs:
 	ionic_bus_free_irq_vectors(ionic);
 err_out_pci:
+	ionic_port_reset(ionic);
 	ionic_dev_teardown(ionic);
 	ionic_clear_pci(ionic);
 	ionic_debugfs_del_dev(ionic);
-- 
2.53.0



