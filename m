Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3283D27FB2D;
	Mon, 22 Sep 2025 19:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569654; cv=none; b=U4Mfij/QldYqQ7PXHScEonFjPw63QuEZ0ZBIyZiZ1tStq1wpQGajVPI3kfcn+TeExAv1aH0GTbtO2UOW/TyuLdIuIDoLVNkE4t9YwZvHAPFAvlCrFOS7+QP949pMWEHTKFD0Y3Nw8vmhee0+SSxGARJBPlbTbFQbrz+ZugqWj0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569654; c=relaxed/simple;
	bh=sZuw9kfMLoOCfaoImdoeWITtGFEOqqnWkMxgo9ff940=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qEWaps/FmecfktyvlOUiZwkH2BfvgVGhxRIKrotIfNfUXZWdx/olZ/1F6Wu9ra5BFNx0Ac8TjijAy3JhaXGBKbJEtyQQ4TaVCR78u8K2L4uBgsL9FAYsLBHhiNKoYEH63VxB1SHKKmtyZqBat2Gt7BHR+YHrrMzrCXh9tuZyxd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5CpceMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5CpceMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8013DC4CEF5;
	Mon, 22 Sep 2025 19:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569653;
	bh=sZuw9kfMLoOCfaoImdoeWITtGFEOqqnWkMxgo9ff940=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5CpceMSSEBw1cHbe9y+CkA4uztpH8JByfy6z5/QXcDr6MMKshzU6HBOxt7SCbn4v
	 ixzMX1T4UjMBu6kYks2yBiLn7Gopxsm6H9rsVmrPgiM39Roef++VHq0s3TLc0ideKi
	 Qcq8s2lTCKDt1aKjWm4fbXuUc648c8qyDwOy3A6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 05/70] pcmcia: omap_cf: Mark driver struct with __refdata to prevent section mismatch
Date: Mon, 22 Sep 2025 21:29:05 +0200
Message-ID: <20250922192404.614430929@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit d1dfcdd30140c031ae091868fb5bed084132bca1 ]

As described in the added code comment, a reference to .exit.text is ok
for drivers registered via platform_driver_probe().  Make this explicit
to prevent the following section mismatch warning

    WARNING: modpost: drivers/pcmcia/omap_cf: section mismatch in reference: omap_cf_driver+0x4 (section: .data) -> omap_cf_remove (section: .exit.text)

that triggers on an omap1_defconfig + CONFIG_OMAP_CF=m build.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/omap_cf.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pcmcia/omap_cf.c b/drivers/pcmcia/omap_cf.c
index 25382612e48ac..a8e0dd5d30c43 100644
--- a/drivers/pcmcia/omap_cf.c
+++ b/drivers/pcmcia/omap_cf.c
@@ -305,7 +305,13 @@ static int __exit omap_cf_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver omap_cf_driver = {
+/*
+ * omap_cf_remove() lives in .exit.text. For drivers registered via
+ * platform_driver_probe() this is ok because they cannot get unbound at
+ * runtime. So mark the driver struct with __refdata to prevent modpost
+ * triggering a section mismatch warning.
+ */
+static struct platform_driver omap_cf_driver __refdata = {
 	.driver = {
 		.name	= driver_name,
 	},
-- 
2.51.0



