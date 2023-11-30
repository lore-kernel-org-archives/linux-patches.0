Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323E2495C2;
	Thu, 30 Nov 2023 16:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwZsc5YS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673D3C433C8;
	Thu, 30 Nov 2023 16:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361435;
	bh=n+r8wmF+/O5yjwOOHNpXye+K58HtvjBMQbm4By4xeig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwZsc5YS9RR5vw7zQPQwgvz5BuTJvIdP5uC4A0KxLUZzV0hrCw1Ws2Kh2wJYA8G68
	 tu3XFngK33fgGpZhZGpxFYaKnNjW+5zbQ1aXrYNDm9CI36J8VUeYaohY6QjX2ESjV3
	 GIDneubv8/gbZCQMrARHZttFJUtzQQjBlN9WWPM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/112] ata: pata_isapnp: Add missing error check for devm_ioport_map()
Date: Thu, 30 Nov 2023 16:21:08 +0000
Message-ID: <20231130162140.995165466@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit a6925165ea82b7765269ddd8dcad57c731aa00de ]

Add missing error return check for devm_ioport_map() and return the
error if this function call fails.

Fixes: 0d5ff566779f ("libata: convert to iomap")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_isapnp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 25a63d043c8e1..0f77e04240661 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -82,6 +82,9 @@ static int isapnp_init_one(struct pnp_dev *idev, const struct pnp_device_id *dev
 	if (pnp_port_valid(idev, 1)) {
 		ctl_addr = devm_ioport_map(&idev->dev,
 					   pnp_port_start(idev, 1), 1);
+		if (!ctl_addr)
+			return -ENOMEM;
+
 		ap->ioaddr.altstatus_addr = ctl_addr;
 		ap->ioaddr.ctl_addr = ctl_addr;
 		ap->ops = &isapnp_port_ops;
-- 
2.42.0



