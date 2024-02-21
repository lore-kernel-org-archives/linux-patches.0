Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A889A78B53;
	Wed, 21 Feb 2024 13:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523573; cv=none; b=pzS+lsibN4tMVr3+QGlA00agc72QjyTalZxIwqaOU0OlwxlDAfEXCVXRbgfZhxESOGCnuEvQebwQFfLZ7JgXvYlajPzWOSaSE3KE3tWBgp8TsO8AMn03Pu6my0A4WTQZjDVvP09Ha3XhRaR5UZA8XBrMnN8N/aZXb7NkYZGYj98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523573; c=relaxed/simple;
	bh=jDUmqKUDto++Mv2ZUEfmLYdn4CIhXHJPLxM1nCCZheA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUNj899xwAA9MTXY1BtVXuyy1sWBWiddlx2EcufD1RgrXFx0+3iQxhrfZRUup5RpB94kGuDoyIOnE7KIUzy1pP6cfbOS1jNkF2H8hwP4NOi2gOtfUjHEO8NuJ5psuelSPj6w3Q5MMEn41HdtTJFFhcKZZ7hbm6ETGLmSxWLzsE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FjG3Ba3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FjG3Ba3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7B1C43601;
	Wed, 21 Feb 2024 13:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523573;
	bh=jDUmqKUDto++Mv2ZUEfmLYdn4CIhXHJPLxM1nCCZheA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0FjG3Ba3qL07FME8vRLbIKNV0YNUCUvqZ7Cr5sbLdDCXchoSRJH2IgH0yswboxMq5
	 S4S+cl5UGD1/+m+faNNJEEayKR4m8HvzO2b1oD5BxSS52NvLsA4agpXjSjsojq0CRo
	 V93QIGv9jsWG8KPx86raWv7kesd/9Dyh571wU4UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Rudenko <mike.rudenko@gmail.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.15 475/476] media: Revert "media: rkisp1: Drop IRQF_SHARED"
Date: Wed, 21 Feb 2024 14:08:46 +0100
Message-ID: <20240221130025.543522573@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit a107d643b2a3382e0a2d2c4ef08bf8c6bff4561d upstream.

This reverts commit 85d2a31fe4d9be1555f621ead7a520d8791e0f74.

The rkisp1 does share interrupt lines on some platforms, after all. Thus
we need to revert this, and implement a fix for the rkisp1 shared irq
handling in a follow-up patch.

Closes: https://lore.kernel.org/all/87o7eo8vym.fsf@gmail.com/
Link: https://lore.kernel.org/r/20231218-rkisp-shirq-fix-v1-1-173007628248@ideasonboard.com

Reported-by: Mikhail Rudenko <mike.rudenko@gmail.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
@@ -482,7 +482,7 @@ static int rkisp1_probe(struct platform_
 	if (irq < 0)
 		return irq;
 
-	ret = devm_request_irq(dev, irq, rkisp1_isr, 0,
+	ret = devm_request_irq(dev, irq, rkisp1_isr, IRQF_SHARED,
 			       dev_driver_string(dev), dev);
 	if (ret) {
 		dev_err(dev, "request irq failed: %d\n", ret);


