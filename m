Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3147F1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FE2C433D2;
	Wed, 28 Dec 2022 15:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241010;
	bh=vuLFL31CGgFpwrTJE2ZDeXdrPmuVfzUQ0rkFUZOnICE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMmUMm7ldOKnqLvu7+vuf2ZgRPXXugX78oC3w1Pa9niqwa9JxYN/cXwH/teBTIBJO
	 VStLJad2Er+93SmwyxbX6frgvrYhJSct4eVEFitwEVI7JM7LcWjvXs3nZ4udf5jtoy
	 2/4/ZwBPPcGuzPSe6qzGhcB9ewNUYvatiUJnwNXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Thomson <git@johnthomson.fastmail.com.au>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 427/731] PCI: mt7621: Add sentinel to quirks table
Date: Wed, 28 Dec 2022 15:38:54 +0100
Message-Id: <20221228144308.944618181@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Thomson <git@johnthomson.fastmail.com.au>

[ Upstream commit 19098934f910b4d47cb30251dd39ffa57bef9523 ]

Current driver is missing a sentinel in the struct soc_device_attribute
array, which causes an oops when assessed by the
soc_device_match(mt7621_pcie_quirks_match) call.

This was only exposed once the CONFIG_SOC_MT7621 mt7621 soc_dev_attr
was fixed to register the SOC as a device, in:

commit 7c18b64bba3b ("mips: ralink: mt7621: do not use kzalloc too early")

Fix it by adding the required sentinel.

Link: https://lore.kernel.org/lkml/26ebbed1-0fe9-4af9-8466-65f841d0b382@app.fastmail.com
Link: https://lore.kernel.org/r/20221205204645.301301-1-git@johnthomson.fastmail.com.au
Fixes: b483b4e4d3f6 ("staging: mt7621-pci: add quirks for 'E2' revision using 'soc_device_attribute'")
Signed-off-by: John Thomson <git@johnthomson.fastmail.com.au>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Acked-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-pci/pci-mt7621.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/mt7621-pci/pci-mt7621.c b/drivers/staging/mt7621-pci/pci-mt7621.c
index c4f57bb63482..b520d1e0edd1 100644
--- a/drivers/staging/mt7621-pci/pci-mt7621.c
+++ b/drivers/staging/mt7621-pci/pci-mt7621.c
@@ -511,7 +511,8 @@ static int mt7621_pcie_register_host(struct pci_host_bridge *host)
 }
 
 static const struct soc_device_attribute mt7621_pcie_quirks_match[] = {
-	{ .soc_id = "mt7621", .revision = "E2" }
+	{ .soc_id = "mt7621", .revision = "E2" },
+	{ /* sentinel */ }
 };
 
 static int mt7621_pcie_probe(struct platform_device *pdev)
-- 
2.35.1



