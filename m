Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCDB1B4156;
	Tue, 30 Sep 2025 14:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243948; cv=none; b=t/gRY+ez7Ogbpe9u4hvw7EvQ68Ggsz4DtqwEpc2bgKGqOh2nfU2k2rmj0Uq1puojF3W5zYDVh/jT5JGt4cJiPTmA4S/oC1xhgMnBLYL3a4e8rjLbS22mMyn30mcumkDrG7Cw2GdjdMFVgoFIpQ7L6QXvuyX36OJ82Jr3MjtDvks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243948; c=relaxed/simple;
	bh=wrIsSeBvJnytLJgpqrejzdVCFpUVxaiar3/AOUv0gWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lE5/w2sSmhJnO94Sv/XB1Mwb4zozeHEYrt84onyXm+aHcMmVXMlKeEwO5oCmb8runGwNvH7/V55g4my0RZU7kTd2WBF/Mt3vc0fZkDJAB9vpDnw03rjb+CXgKSUAgt2q1YNP5jpJ0UYgF8gIQzB4/9lf3thQKVa3eVB0aVuMuZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D64leVik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D64leVik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D59AC4CEF0;
	Tue, 30 Sep 2025 14:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243947;
	bh=wrIsSeBvJnytLJgpqrejzdVCFpUVxaiar3/AOUv0gWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D64leVik8a3VHlqCAsCTC10hsXXxqUC20YVySXHuCL4XkL1pd/yZyxAK/7BFW4z3z
	 QFb+BPkctCiSX0WT4zf0oqwyeIuunInBwq8SEJYmXRNqo/OUOmi7sO54MS2Rq4NWZC
	 UgC9I8hcAr/efMCJ9YYo3CeV/1Ax5/k9J9fvMOLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/81] pcmcia: omap_cf: Mark driver struct with __refdata to prevent section mismatch
Date: Tue, 30 Sep 2025 16:46:35 +0200
Message-ID: <20250930143821.052026078@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0a04eb04f3a28..2e7559b7f103e 100644
--- a/drivers/pcmcia/omap_cf.c
+++ b/drivers/pcmcia/omap_cf.c
@@ -327,7 +327,13 @@ static int __exit omap_cf_remove(struct platform_device *pdev)
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
 		.name	= (char *) driver_name,
 	},
-- 
2.51.0



