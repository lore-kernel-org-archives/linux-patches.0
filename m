Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213419;
	b=J60PJbc6h/amcsKy1CiLPMq8Azj7U+lLc7O00v1rCO35/ZvzIDR46KT0mksVuyAyrYZ2
	 I/RyaChB3PmlXu++xQ+3iGf8ScCQvIQ1ggSOnq0yN80pLNKbjijwN6Mu+Z7wkVgrtXXhV
	 HvQ2YzXUcX2FitM2twkMD5jM1N2klTrdgbRgEGrQwHu1foH5KO90WeDeFtbHb4yf1fkIe
	 hwa6pGMpmxU9qEVWoi3L37c1zx5YXjGvebW/2xeONSuAHhzi7KG53XlArJg50cMbCx7g7
	 k0L72Q5ml0u2HI7STUrfLc9zwo8GJ1/2JaxQ+lQwGvkyS1WDVN8Fte+9hhfhCtJWVFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AIJcC0fOAVxptsPFz9aYD3l8pzBSR8QRB2cZx8/af9k=;
	b=b9FJ41DFcgzuqfUiOTPon6ZuA0mrTlY1LhhVDS9UInZEMi/gF45kRHp0PhR4WqKrqXwH
	 itftVdgt6XJ4kOoTdLiLS22w7W9CA0IYB+l9AZXkPwJJ1w8ta2q+odFqvp8hSKcKEvXuV
	 y+ttPDNHhyFb40fs99+3mIrnborHC9fSvrRCp2vyPkyP5QQvCwfkr+Sfj7fz+tbxTIw7v
	 l3rjzpVFmEfzf+ySOp0XNKKRQ0nhPQXw3q7zA3XSsD6WYfS6Y1fn7wxNAsh3Vlv6zsAWY
	 uk9YEtGnqg0kIFMGA1oAJdibeSiCmjPrlg/lrOM6AOsvPoQ9TGMzKlTBz4H75G4wM1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnpmNesa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F4F606A31D;
	Wed, 28 Oct 2026 18:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnpmNesa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33441F01825;
	Wed, 28 Oct 2026 18:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213419;
	bh=AIJcC0fOAVxptsPFz9aYD3l8pzBSR8QRB2cZx8/af9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnpmNesaFVemlDCa3iqBspFnxkIWwJiu9mtuuS9hfJRzCDEjH2yBjzDYm2B2UEpud
	 odjJBFWAsYztEO09RJ4r5eZBRCIEgmpj6ohHr2zUvlAIFhmzajQ5OTgXQyZiFDAr3G
	 eEMR7I+8mRgfxeSDaPcrT/05JJIXY4IMNmyUL2tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 0500/1887] mtd: maps: vmu-flash: Fix the (mtd core) switch to ref counters
Date: Wed, 28 Oct 2026 17:43:16 +0100
Message-ID: <20261028170510.670940694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit a7d84a2e7663bbe12394cc771107e04668ea313a upstream.

While switching to ref counters for track mtd devices use, the vmu-flash
driver was forgotten. The reason for reading the ref counter seems
debatable, but let's just fix the build for now.

Fixes: 19bfa9ebebb5 ("mtd: use refcount to prevent corruption")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312022315.79twVRZw-lkp@intel.com/
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20231205075936.13831-1-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/maps/vmu-flash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/maps/vmu-flash.c
+++ b/drivers/mtd/maps/vmu-flash.c
@@ -720,7 +720,7 @@ static int vmu_can_unload(struct maple_d
 	card = maple_get_drvdata(mdev);
 	for (x = 0; x < card->partitions; x++) {
 		mtd = &((card->mtd)[x]);
-		if (mtd->usecount > 0)
+		if (kref_read(&mtd->refcnt))
 			return 0;
 	}
 	return 1;


