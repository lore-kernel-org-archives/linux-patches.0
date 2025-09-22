Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F57170A37;
	Mon, 22 Sep 2025 19:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569494; cv=none; b=a1eGyj9y4MAKfQzpnt7eJlKVdk3sWLqM9+La181HAalsldYHdU8b3MZzrOIVdp/yrn7PvNRZnjldNpS7+cp0HVDbFXmy0clMuuxWuEq4oLN/ar5zEBY2ygTZ0YATbU+XHw1saBRVcQaNsnVOQ7oFEoNJPO3SXhf+e/yVXWrpxak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569494; c=relaxed/simple;
	bh=TxDhY+GfxsBmGHKTAd1lPj/+XgAeUtrMIK7SNoUn3Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XFz7vq31/CieUnCKUCQqokKLM9NAxJhguB7VLyf1ASxrLjle44fyWMT4k0+fim2T5PHeMFDWXNUVxH2AFkywFP9wCGUMa8oL/2QF4JYlSh3UtAboJfOpeX4t9uM/8JzDsDPFi91jdwOoRWpFHBHB2lQm6gB0QTTPFVbFsffPo1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHdJR95x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHdJR95x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1900C4CEF0;
	Mon, 22 Sep 2025 19:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569494;
	bh=TxDhY+GfxsBmGHKTAd1lPj/+XgAeUtrMIK7SNoUn3Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHdJR95xxKkS8QVtaOUbFdLzJIphBZRQZfnFN+aaQymiEUS0xRfCk8QwvPXdvjIUk
	 fHM96RPRLb7vVwvy/l+yi8asRZNjjaHMppsZMnjOkDv+8cQrihbIhs1WZgm8rgeyQj
	 rlSqwIZjQvH0z2z/Cg7C4t84CtNuA/YBGA0o75r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 04/61] pcmcia: omap_cf: Mark driver struct with __refdata to prevent section mismatch
Date: Mon, 22 Sep 2025 21:28:57 +0200
Message-ID: <20250922192403.666169740@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e22a752052f2f..b8260dd12b1a8 100644
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



