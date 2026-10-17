Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B7A2E8DEB;
	Sat, 17 Oct 2026 16:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255999; cv=none; b=YMEmKDiscSGWoij07nf78ZxQ08yrJbooRrZBvfgTuMNUSJQE42HwT+NCACXG3SMmHCXGD8RdY1PkMfaWu9TWO8xbVEYhhRGAssOe0M3lCB5te6XPywvgRCfv4uGBSij6i20qYogVfdDeCudHt5Yv2egeHL7eavhyWi/vH/h3Qok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255999; c=relaxed/simple;
	bh=6C+/d1FSyZ7ap6q/bLm5K0HF/+1pE54MkmeoPN5ahbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RV6RIkqD9pom57UoaXqkHxvz7+idiUWzsQRUci6CIRTqxT28PA35Hq1S84/PylmeKjKk7VjEBBAF8Cg5dJThMYxXu8oZAwyu/tXnQaw+qdE/PkhZpTbQrTEAlbRsIkRnBy5RDJnwSOfWE0MVIqgMRQRtpkbOPbwqAEOTr5pM8Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1WQRZcj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1WQRZcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523081F000C4;
	Sat, 17 Oct 2026 16:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255998;
	bh=J+p/QPBXIG4rrpcLCKLwHisIl8wQ+Us/K0u3fZs/P6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1WQRZcjdm1uzQhWPXxeybOCQm5ReLMDlE0dWXByvElSh+E+UxwfwoeDaiLu8TpYP
	 l3z8/P4yXK9UY7VAvjNAfu9MAemfhsWhoJlXQzYaAmvaSb1LERq463t4RH2Pk5pmsN
	 r4mGKs3Oq7SvLCwZ5nuyb2r1G5cq1RZ3GKzSDaw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Narasimharao Vadlamudi <ahmisaranrao@gmail.com>,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0091/1674] media: rkvdec: Propagate platform_get_irq() errors
Date: Sat, 17 Oct 2026 17:39:23 +0200
Message-ID: <20261017160433.479855363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>

[ Upstream commit c37aca64206fafe938119e801a3fd10a537a051f ]

platform_get_irq() returns a positive IRQ number on success and a
negative error code on failure. It no longer returns zero. The driver
currently returns -ENXIO for all failures, which loses useful errors
such as -EPROBE_DEFER.

Return the error from platform_get_irq() directly.

Fixes: cd33c830448b ("media: rkvdec: Add the rkvdec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
Reviewed-by: Detlev Casanova <detlev.casanova@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ adjusted the patch path to drivers/staging/media/rkvdec/rkvdec.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkvdec/rkvdec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/rkvdec/rkvdec.c b/drivers/staging/media/rkvdec/rkvdec.c
index a1d941b0be00b..85dcabe11bf9e 100644
--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -1044,8 +1044,8 @@ static int rkvdec_probe(struct platform_device *pdev)
 	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
-		return -ENXIO;
+	if (irq < 0)
+		return irq;
 
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 					rkvdec_irq_handler, IRQF_ONESHOT,
-- 
2.53.0



