Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B231464AB3;
	Tue, 23 Jan 2024 01:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975055; cv=none; b=qhgEdfEGiTOfcxdfpfHFy6/ET4vHnB/MD2oxk2lzRlg8Hc7jf+d35Kj57aDe8GGGjeF4fskSg2w4uoynzbhjbmvsOy9mh3K37YE1BBFSi3WZ2+gY0nxAz/2WsBtEO1Bh1oyYugWp7his5EWtBWAzV/3CjVMV6YqPwgd+78iH9gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975055; c=relaxed/simple;
	bh=NimYrkwWSFuS+i6DFNzilxKxUadc0vxiHCAZj8Ec1Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzSi+F8DvEbDjRA/tefV5wihS/d6mJ+g2ls+N1H53IIx9VRouM8wByKxdYh1dMDgGZNeMdGKigQf6JUk5y2NHrVpKgssozuM75hOG2M+6Vp/cQNxjvup58aHQBnFxRZrg5Jsn2GahhkesUDHYxc4zHH/Fu5it17VdIcQ8l6EkwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmnOwKx7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmnOwKx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7871BC43394;
	Tue, 23 Jan 2024 01:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975055;
	bh=NimYrkwWSFuS+i6DFNzilxKxUadc0vxiHCAZj8Ec1Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmnOwKx7acUfW8adNzK6eW7yXTzg84PbvlUqW0SvX/591ceYgrscXpXR9TRJhK8H/
	 n3D2ufhu3JchByytalhfmELduVAVJQ8oK8I9efRd0rsAVz931wGb7CD+8jHVpYEHOB
	 GFam4u8Q9/TxvBrNTBre0KaO0j1piNAQelCR1MT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 343/374] net: dsa: vsc73xx: Add null pointer check to vsc73xx_gpio_probe
Date: Mon, 22 Jan 2024 15:59:59 -0800
Message-ID: <20240122235756.854684479@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 776dac5a662774f07a876b650ba578d0a62d20db ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: 05bd97fc559d ("net: dsa: Add Vitesse VSC73xx DSA router driver")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240111072018.75971-1-chentao@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 0c0bc78b1788..6b6470ef2ae9 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -1119,6 +1119,8 @@ static int vsc73xx_gpio_probe(struct vsc73xx *vsc)
 
 	vsc->gc.label = devm_kasprintf(vsc->dev, GFP_KERNEL, "VSC%04x",
 				       vsc->chipid);
+	if (!vsc->gc.label)
+		return -ENOMEM;
 	vsc->gc.ngpio = 4;
 	vsc->gc.owner = THIS_MODULE;
 	vsc->gc.parent = vsc->dev;
-- 
2.43.0



