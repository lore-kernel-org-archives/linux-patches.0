Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9060C1FB2;
	Tue, 23 Jan 2024 00:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968691; cv=none; b=LLUnQRIne05K8EhDNVyA3hkGZRjaUrXlog9/fx0ddnm++d78cWtW7y6ATdKDPXdMrdmAybX/bdiuK0Nz5m2hj8W049vSY/9xohac+unPgQGZAKYUEvXNTn8EPU/O1pLuXc0crnRSUT6nyl0sSY6F/ilRbuEG62DDJq0AtW0X9uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968691; c=relaxed/simple;
	bh=N9UkoQr0+1XyYjLFy7fiTUsFRrIP8YrzRnafF+TOZrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTIyO9R/oKNmrjjuC8b0Jip5sv8RakT6XlOvj+u/O3RgtaMsZ67urQwX1Jx4Wfc82Nvc/cKi1wo3NMkaJtvW5yKX/LgBE6UEaTTj1TOqIiN3OXfrJ/OK1LHhgGvpWhYBCK9pyOsJp0NFnY5tj06O9gntVmTbq6SEQCtD5aAuBIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rq4suWaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rq4suWaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4953AC433F1;
	Tue, 23 Jan 2024 00:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968691;
	bh=N9UkoQr0+1XyYjLFy7fiTUsFRrIP8YrzRnafF+TOZrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rq4suWaC8ZnaL84Ck2nDRUfPgxhBt24iHCUx/a5KTa8RLyzvloHaowsx83efR4Z9G
	 bVu+q0No263yIvMhR3YDMTpvedJ87BdtTq5d7P1ziTxgkYRcbG+e112+Y7Lpi+yC/r
	 cnGklaJEVYj57imLLxvrFfiKVylQzI3ywMWlV8ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 141/148] net: dsa: vsc73xx: Add null pointer check to vsc73xx_gpio_probe
Date: Mon, 22 Jan 2024 15:58:17 -0800
Message-ID: <20240122235718.304819978@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/dsa/vitesse-vsc73xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/vitesse-vsc73xx.c b/drivers/net/dsa/vitesse-vsc73xx.c
index 9f1b5f2e8a64..34fefa015fd7 100644
--- a/drivers/net/dsa/vitesse-vsc73xx.c
+++ b/drivers/net/dsa/vitesse-vsc73xx.c
@@ -1227,6 +1227,8 @@ static int vsc73xx_gpio_probe(struct vsc73xx *vsc)
 
 	vsc->gc.label = devm_kasprintf(vsc->dev, GFP_KERNEL, "VSC%04x",
 				       vsc->chipid);
+	if (!vsc->gc.label)
+		return -ENOMEM;
 	vsc->gc.ngpio = 4;
 	vsc->gc.owner = THIS_MODULE;
 	vsc->gc.parent = vsc->dev;
-- 
2.43.0



