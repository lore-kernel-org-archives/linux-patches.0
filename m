Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042305;
	b=H2qcR+s2K/Qw2nxfrJ57Ixbo/JnLXeFNmupAHf4aR1PlNupeVxx1wSI+dTA8iGb4lbwP
	 laLO6Ij1lEIzgIEvLRIx5d9DiQ54PFkrCs3pihfdej6Z0/2QHb9iNT6aDKlfpV2LFVH7n
	 iGIVZG1EuqYjUkgc6k8FWCsp151+ONy6vdejVisW09tm65p2xRyqGvLoQ1GkLGLvDwBqw
	 NVNJBlcdD4Zf0mRcsweNTgwot3eUTGny+OCbNHkJcvhYyt6NvRT5dur3oekK5eiEX9TC+
	 7R7G8dkIj5q68eNajd4UMnYsjzwI2l+4QXkIVrRFTv+aWR76UJzh0kC36Crp3IYOauA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ro2pe9Szaj3cGuAcFS3ko5QLhp1xfMYLYR4GCrBQ/+8=;
	b=Vn/b9RQFrJQQpZdCxMCkES/yHFF6tbNlN3EHfW/XQrQq/P3U8n4VhEOdyLbfZC+zv9ge
	 TBqgCIJh0LvPvVLB35ZamknzESlaOxg5JRFkmtmFUSuHeNrw8he8IMKe8Orb4SMoh3njK
	 RjQAZTQLpylCzvuu2GTIMiQXC0cXxDl6KsaZ1ksRqyUw5HRradYxJz2l7zHZP8VH4HkbO
	 JfsZd7ScDtbbwS35EK0Hg6eFCyGvYRNDY+FYd+a/DueGlqg/lWS8z8ZPbzDLrzyg88mks
	 SopbTHqSQ380E3T+VVYB3JLnmqxneHNCWu+HzNtn2IaiPzPgZ4pPgpP2HIV/LmlUsdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i+Fp18BS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66447606A320;
	Wed, 18 Nov 2026 22:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i+Fp18BS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826EE1F000C4;
	Wed, 18 Nov 2026 22:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042305;
	bh=Ro2pe9Szaj3cGuAcFS3ko5QLhp1xfMYLYR4GCrBQ/+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+Fp18BS/I7/FzVeZZzm7pUZhtUTE0a3RDEM6/IXbBKR8pTEvuz3yodVd6FpxoRAp
	 XagWSt8kaQgkESrx2T/ZNq/h5UmyTKDsJhhti+f+ghTihNSzK9XZ9DbcipDNOYu22S
	 9AAEuvFZAGY6+X4NBZlr2P83YQpQMoZq6zf3WM7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Joyner <eric.joyner@amd.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3124/3318] ionic: free port_info when probe fails after the port is set up
Date: Wed, 18 Nov 2026 16:02:26 +0100
Message-ID: <20261118150453.646096071@linuxfoundation.org>
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
index f49b697ab00f8..242529f4ff47b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -383,6 +383,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_free_irqs:
 	ionic_bus_free_irq_vectors(ionic);
 err_out_pci:
+	ionic_port_reset(ionic);
 	ionic_dev_teardown(ionic);
 	ionic_clear_pci(ionic);
 	ionic_debugfs_del_dev(ionic);
-- 
2.53.0



