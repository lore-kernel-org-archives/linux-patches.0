Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD241946C8;
	Fri, 17 Oct 2025 15:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715344; cv=none; b=bQjNy0s82TjDZUA6FoEAON6A0RfBKJRitT2IImkFiigMQJJxwRFwRltJ8RU51enxFH//PTsz1KjuwbyRFeMvyaMTU4O2XfAYkoy8USpLYGVA9babGFrco6TKELJ1975NXZ6mggO32cOdVd6MSyUW3Er0ifHzrEhWc8GuycmLVmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715344; c=relaxed/simple;
	bh=oZwjs8oCnX1stmBu0y+wdGBeNX6zR+0fRf5FuKquTfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SM+1rxJGaMOHEVCDFuzO/WURIgbmwBOwydVrp0UQa1pl7wtnnB1KjdsJi3MSLqsTyhs8G1kwdrSt3diHaBSGafrdro2tIR0Pm1yZSTLX/dAt0KLWOOuz5h08lkcCuQ0gHWsSW1cqljqUwIxwhZ6VNSse4PzkavGjWe8yGL9awRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uW6hzAlt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uW6hzAlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE9AC4CEE7;
	Fri, 17 Oct 2025 15:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715344;
	bh=oZwjs8oCnX1stmBu0y+wdGBeNX6zR+0fRf5FuKquTfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uW6hzAlt1WHaIyD2pIPmdfYEp5uqFjpxDVUTZVEXA8H/Z4QI8z408Q6WBaUX9u7G+
	 vw9eKoVhjUs9czhPZivSTvrjyrDEusrSu7R/ioP9r7vP19OyitUn4ndOAB3sm7eOYM
	 /EvvfiEOdm7B6yuOB0B2YW9LfiMpE0jVQ0WzIY0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devarsh Thakkar <devarsht@ti.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Subject: [PATCH 6.17 183/371] media: ti: j721e-csi2rx: Use devm_of_platform_populate
Date: Fri, 17 Oct 2025 16:52:38 +0200
Message-ID: <20251017145208.546122548@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jai Luthra <jai.luthra@ideasonboard.com>

commit 072799db233f9de90a62be54c1e59275c2db3969 upstream.

Ensure that we clean up the platform bus when we remove this driver.

This fixes a crash seen when reloading the module for the child device
with the parent not yet reloaded.

Fixes: b4a3d877dc92 ("media: ti: Add CSI2RX support for J721E")
Cc: stable@vger.kernel.org
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Tested-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com> (on SK-AM68)
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/j721e-csi2rx/j721e-csi2rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/ti/j721e-csi2rx/j721e-csi2rx.c
+++ b/drivers/media/platform/ti/j721e-csi2rx/j721e-csi2rx.c
@@ -1120,7 +1120,7 @@ static int ti_csi2rx_probe(struct platfo
 	if (ret)
 		goto err_vb2q;
 
-	ret = of_platform_populate(csi->dev->of_node, NULL, NULL, csi->dev);
+	ret = devm_of_platform_populate(csi->dev);
 	if (ret) {
 		dev_err(csi->dev, "Failed to create children: %d\n", ret);
 		goto err_subdev;


