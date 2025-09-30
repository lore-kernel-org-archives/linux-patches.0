Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909AB2441B8;
	Tue, 30 Sep 2025 14:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243768; cv=none; b=ak2iACuUJFp3GNHpDnFtqc2dycYSa3XhUu85RimVJ5lJCowvIW4Jl9gZgTcS8IoiKqRDHU9SH46uN6vjKzhqEkSs7o+OKZh3rA8NLpwSed63uWoVqjqLFXo10IRrONegGE4jOYxmkQ+xZghr8l6+Y2faYaYz809Oh676g64aIbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243768; c=relaxed/simple;
	bh=tzUGoXwA/LwKeNbg/Bxkh+OdwlVHv7/V07O3nnL7nsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dP1CzV/QcJr0UtVi70TkvXXJCwUJbQ+A1H4RKOts5StsHOwYl+GA5kFnBQT+YsWje2i63er2mvfU85u+NDolekWscEblWzhyl12jgrY34VwASd/wVylk24PseIBh0Xnx//GlJiH2C7Dc0zBe1178WCJfl3P5ycg5jh4AMPMs+1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mC7mauBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mC7mauBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EADC4CEF0;
	Tue, 30 Sep 2025 14:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243768;
	bh=tzUGoXwA/LwKeNbg/Bxkh+OdwlVHv7/V07O3nnL7nsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mC7mauBz6KQ9nnjoOVhevyLn49gZ48etUWw1ZRbztogDEgZ1y4TvcYnKsnRx4FuEp
	 pF3/6U0dHHvG+9zGYPPKxEL8+UGdejjPvCQTIG/O5tr3fDD26n+OAzGXFrnSQwLmtR
	 l1I+2OSq/W3iNyhLvRcG8gotLsK6ylEyAt+izeVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Dahl <ada@thorsis.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/81] mtd: nand: raw: atmel: Fix comment in timings preparation
Date: Tue, 30 Sep 2025 16:46:14 +0200
Message-ID: <20250930143820.181295170@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Dahl <ada@thorsis.com>

[ Upstream commit 1c60e027ffdebd36f4da766d9c9abbd1ea4dd8f9 ]

Looks like a copy'n'paste mistake introduced when initially adding the
dynamic timings feature with commit f9ce2eddf176 ("mtd: nand: atmel: Add
->setup_data_interface() hooks").  The context around this and
especially the code itself suggests 'read' is meant instead of write.

Signed-off-by: Alexander Dahl <ada@thorsis.com>
Reviewed-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240226122537.75097-1-ada@thorsis.com
Stable-dep-of: fd779eac2d65 ("mtd: nand: raw: atmel: Respect tAR, tCLR in read setup timing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/atmel/nand-controller.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -1312,7 +1312,7 @@ static int atmel_smc_nand_prepare_smccon
 		return ret;
 
 	/*
-	 * The write cycle timing is directly matching tWC, but is also
+	 * The read cycle timing is directly matching tRC, but is also
 	 * dependent on the setup and hold timings we calculated earlier,
 	 * which gives:
 	 *


