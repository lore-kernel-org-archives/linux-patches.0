Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2212FD1DD;
	Tue, 30 Sep 2025 15:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244980; cv=none; b=LdbT/D7rt88q1atR8JI14+cpeYAbBmstmcsRc4ZZaRXVHQTZFX0Ci0Sbr7zomz/EXWJCcPIWumsJj2U/gt147Xx0F/C+OzAePE6uJuZnghuriaGEoTTncVc+c3UAHgbwOe/v+Qx/evkHwNBrJSZr9RpbhBPEjBvU60iSptpB+44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244980; c=relaxed/simple;
	bh=bgt4tJ0PIYBjE7OR6E9bSIVuN1EBeJCVe/KWxGnNOxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRkyHuks43VpdCtkUn8JKFtK1eVz2SzcZwsLj2GeAClScp8PUN6HQEy8yFixB1AXFFCkDErDj1JoEppIhMRFOW2Eg8fssg21COisJuU933t2hrUTyNE3cdRpQv+xd5Obw/xn4PCtuW6xeIPTy600plhIYKONjT7h86+a9uyX5WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3Lb4uhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3Lb4uhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6F3C4CEF0;
	Tue, 30 Sep 2025 15:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244980;
	bh=bgt4tJ0PIYBjE7OR6E9bSIVuN1EBeJCVe/KWxGnNOxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3Lb4uhdJuy+5Wd2DgFTSRFOlHOTBEyffh58N8reUinVUodth3Q5GiNn12ak41uMI
	 gKMWoYDVSBKtrgKvp/d3SQG1Y6fFIZnJst1gK0//OjAy3KISFBvYZt9eN/l76YVRK6
	 xQH6Eh/bZtU/9ln0pUR207AZCL79cxSo4zpF7YlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Dahl <ada@thorsis.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/151] mtd: nand: raw: atmel: Fix comment in timings preparation
Date: Tue, 30 Sep 2025 16:45:59 +0200
Message-ID: <20250930143828.778379715@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1378,7 +1378,7 @@ static int atmel_smc_nand_prepare_smccon
 		return ret;
 
 	/*
-	 * The write cycle timing is directly matching tWC, but is also
+	 * The read cycle timing is directly matching tRC, but is also
 	 * dependent on the setup and hold timings we calculated earlier,
 	 * which gives:
 	 *


