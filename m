Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105BB6FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF73C433EF;
	Mon, 19 Dec 2022 19:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671477801;
	bh=4+TCtaYKzRBEaGUn2XVaLjqjZCkoirRN2tm0M0jPTnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLlLIX1KoX3GolNnhniHivr9Q2mKo/keLT6nHxuQylrTJ10xAng/SM1GVb3NFGZ/M
	 aPnDxFjqy4/JvfX8XUprWXAAmW02EpnMSJmlsXiLH1VSraenEuoTqCBptISDroiRXo
	 CSfJcNo57qxraZKQCiDgC9MHfJPxdDWABbUOks1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Thomson <git@johnthomson.fastmail.com.au>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>
Subject: [PATCH 6.1 03/25] PCI: mt7621: Add sentinel to quirks table
Date: Mon, 19 Dec 2022 20:22:42 +0100
Message-Id: <20221219182943.543410305@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
References: <20221219182943.395169070@linuxfoundation.org>
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

commit 19098934f910b4d47cb30251dd39ffa57bef9523 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-mt7621.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/pcie-mt7621.c
+++ b/drivers/pci/controller/pcie-mt7621.c
@@ -466,7 +466,8 @@ static int mt7621_pcie_register_host(str
 }
 
 static const struct soc_device_attribute mt7621_pcie_quirks_match[] = {
-	{ .soc_id = "mt7621", .revision = "E2" }
+	{ .soc_id = "mt7621", .revision = "E2" },
+	{ /* sentinel */ }
 };
 
 static int mt7621_pcie_probe(struct platform_device *pdev)


