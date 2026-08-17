Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FE0345EB0;
	Mon, 17 Aug 2026 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976609; cv=none; b=XYD2kqd9OfSCGo8CC+29yMyE+emHyDdTu+80U2g8pTptxTuQ6HUtcAKz4g4GjSpWaxhEidZHtqNcb/R1GONIwwjTvhRtzlz6qTwFBsoG/XBqp1wGftWVyL5K9k4h7oCGHRSi1ChNEmCubYcVQngj6CCKuMy9hC7InVLnC2O0BvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976609; c=relaxed/simple;
	bh=Sps7yASMIewyYsMKzwoYTogoYnkvLcU1zqdCwpuogoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKVr49tL2FO0octzvGrrN47VEzrhCzG905Wr7/JxVvI9AqQoDT1bQA5D+eXd6EnMpmsaXZptXpzm6mAH2cle0Kt7i61q52SKx0tMJ6jgGBsSkcMmiXp+nsAmM/MyWMtEEtFntZI+tIl68Vpwc0LSGzC59nbFK5qWgN8iC7Io8o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFC0sJMt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFC0sJMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F111F000E9;
	Mon, 17 Aug 2026 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976608;
	bh=k7tI5UHaqKLuzHJi2ckU+1FSr2KvsBWFWGv6LFbqmOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bFC0sJMtcGQnhXNbe0EIDIoMI05vY4HtUmRXWqcS1NYXk7+CuMoGf8sOakGQ54Ca4
	 znGqiRKFlbGv54xKvrkIHBhysEuTbamGRNoyC5DTHy3nedwqDP9lgCF6juKO1s+5Q4
	 mrKcBKnBGMpKrILn6v6IHOwz/RRqr7/2OSD+U+CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/456] ata: sata_dwc_460ex: remove variable num_processed
Date: Mon, 17 Aug 2026 15:27:12 +0200
Message-ID: <20260817132541.686009033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit de58fd3d80f884f7f322a06bfe08465e49b47c5d ]

Variable num_processed is just being incremented and it's never used
anywhere else. The variable and the increment are redundant so
remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Stable-dep-of: c2130f6553f4 ("ata: sata_dwc_460ex: fix infinite loop in NCQ tag completion bit-scanning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_dwc_460ex.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 0023b232aeca2f..98c91c89a3b336 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -511,7 +511,7 @@ static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
 	struct ata_queued_cmd *qc;
 	unsigned long flags;
 	u8 status, tag;
-	int handled, num_processed, port = 0;
+	int handled, port = 0;
 	uint intpr, sactive, sactive2, tag_mask;
 	struct sata_dwc_device_port *hsdevp;
 	hsdev->sactive_issued = 0;
@@ -656,9 +656,7 @@ static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
 	dev_dbg(ap->dev, "%s ATA status register=0x%x\n", __func__, status);
 
 	tag = 0;
-	num_processed = 0;
 	while (tag_mask) {
-		num_processed++;
 		while (!(tag_mask & 0x00000001)) {
 			tag++;
 			tag_mask <<= 1;
-- 
2.53.0



