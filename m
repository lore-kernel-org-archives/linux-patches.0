Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5CB3D3308;
	Mon,  4 May 2026 14:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903265; cv=none; b=neZISPyUJ6CN4OF6F8UbhlC/5vbbyKxUpD/AyxKedduKYoABdD3ClFCa0CAPn3BAXjbme0/s5k+X4cna8RsngrfNNLLt0lK6yMp6KSPPKnBH6Scufoevh9AywJASD35t5x16bb8TptRw2c9kXeeCsVeTIDcD7qpYmkcxtUmGf5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903265; c=relaxed/simple;
	bh=ZkktuPNKgwBHIvoUO8O4rH7xhOo6lZvhO4lQHMoOLZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyKaGvgk72LqC2qmJRX3GPV0dIc7KpFLhtcSE62not6cZIE2MimZ/xGKbypmMCvJHH5EvujbYDuzqK60MaaiZerLesgWu08hgOdoG+CrVbE4ryon9c3ReMA7d76xmwjtwrnAu6oDl++rgA1U3I56TuijwuUbLQ0q6AHcM4A4ams=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BO/J0tDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BO/J0tDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22576C2BCB8;
	Mon,  4 May 2026 14:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903265;
	bh=ZkktuPNKgwBHIvoUO8O4rH7xhOo6lZvhO4lQHMoOLZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BO/J0tDNNmLtEpYxgSBtlVL5rxwmYdmMZNW9BOqE8pJ+UuU9Kc6MVNzOXAJQNSBVl
	 S2o3hQhkAYhpK2Ey7PAhThj/XYQi/c7Xa/jMOueHq4XUbDfIc2Mr3B6uZU7aKEs8Ks
	 MoykzUyTnC3FqU9aqacxBeIefXWjO2e7ow6rsLa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally+renesas@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 166/307] media: rzv2h-ivc: Revise default VBLANK formula
Date: Mon,  4 May 2026 15:50:51 +0200
Message-ID: <20260504135149.110185859@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Scally <dan.scally+renesas@ideasonboard.com>

commit 38104fe60ebb6b6cb66e3e9ef0a5c12f1260b1bc upstream.

The vertical blanking settings for the IVC block are dependent on
settings in the ISP. This was originally set to calculate as the
worst-case possible value, but it seems that this can cause the IVC
block to hang. Instead calculate the vblank to match the default
settings (which are currently all the driver sets anyway).

Cc: stable@vger.kernel.org
Fixes: f0b3984d821b ("media: platform: Add Renesas Input Video Control block driver")
Signed-off-by: Daniel Scally <dan.scally+renesas@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c
+++ b/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c
@@ -24,7 +24,7 @@
 #include <media/videobuf2-dma-contig.h>
 
 #define RZV2H_IVC_FIXED_HBLANK			0x20
-#define RZV2H_IVC_MIN_VBLANK(hts)		max(0x1b, 15 + (120501 / (hts)))
+#define RZV2H_IVC_MIN_VBLANK(hts)		max(0x1b, 70100 / (hts))
 
 struct rzv2h_ivc_buf {
 	struct vb2_v4l2_buffer vb;


