Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052378;
	b=sZ6LkLe35flhV56m5A8CbCmtLKn91eGh2wZ8CsH+uWEL2hm5Ly0Md0PrVOMVQbRMXM/A
	 AZCa4XqFtRi+MST9G6nsLXcHG2EeRL2v/YllbMsZ9qYLta/tVU7CwS8acLMlh0hwdrJ4W
	 SJdODrctsD3FoScqQ1Memu1RwM28i2kk8FQ2xQcKxk5kBCM6RkocWxz7ioMyNmBpNB/CB
	 SYAW6Rw81IKKRl9OkSUTKubtG9fq7m5NJQP8axPjJu4mPqM+6tWe9MTpRvdAl0+KBG6gg
	 12HkQ9oYBFNO0g0+NchA+OFaiWpOKZsBB/ISCu3m4GKZO+W8o1R4HvHg/ciQN7TKqMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uoabiG9xgkzcMjRdDzdk1scuKSdPXdukYOcMl1Lw1LQ=;
	b=3eQMVvGwBnhw8CyqpzGP+p5dH5ANypotorAcykuFE7Zm1/IjzDSatQ6ynnb/s4Qpvq9D
	 q0mew6EZsYa88dqpck07VeFfRWx8p5V6/vqmjEIRZhOMSBlGIbfPmuWoMI6/ubh+WRQW7
	 0L0oCVz/2VH96IZzdQhZubbP/UrZUkVy3ox9i5WcIHDHcItlQ9taw6mw7v9kvu8CUFZga
	 iY3MFsiJu1IIl2LObMNZ0IQBNPO/zNq7OeEscAaG/TkwjvlR/hgk1dHw4w38YTO9FA0x+
	 /pfLILTRia3+Otqcx+MSXSAutG5mkgm6cFyGwv9OkC572sDCbl9wFgWR3Bynrs5CrJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MDdgK4Xe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D01D606A31C;
	Thu, 19 Nov 2026 01:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MDdgK4Xe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2F61F000C4;
	Thu, 19 Nov 2026 01:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052378;
	bh=uoabiG9xgkzcMjRdDzdk1scuKSdPXdukYOcMl1Lw1LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDdgK4XejG4ry3BNFtG4AqVTaaU+aeZIfonFXADP1b0T7fqeXVVXE802oGgQ/DkDK
	 CqXE9ab3Q+z3578f5ZvJnAZ2pFQl4OAt9ks4bKRke5dn6PJFO/u7MDw8uNiua0QlkH
	 /RFEg5JcEJnOv9QUsmwBUBx7hVc8PTBwNH6tvXxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Weinberger <richard@nod.at>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0542/2214] mtd: Call get_wunit() on the master partition
Date: Wed, 18 Nov 2026 15:36:58 +0100
Message-ID: <20261118150032.701951364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

[ Upstream commit 904f18430e8cce829cb9130eab7a93020e33fc89 ]

The code checks whether master has get_wunit() but still calls
it on the child. Fix this.

Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Cc: stable@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index bfbb319ef33f3..509785dbea297 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -528,7 +528,7 @@ int mtd_pairing_info_to_wunit(struct mtd_info *mtd,
 		return -EINVAL;
 
 	if (master->pairing && master->pairing->get_wunit)
-		return mtd->pairing->get_wunit(master, info);
+		return master->pairing->get_wunit(master, info);
 
 	return info->pair;
 }
-- 
2.53.0



