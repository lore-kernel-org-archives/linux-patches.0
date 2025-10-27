Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F6A31B83D;
	Mon, 27 Oct 2025 18:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591276; cv=none; b=BVGHfTcPjvwPMYgA25jU7hCfXyTaeyT6gizDJ28DH7VMuHfBmiq8WhoXYv7dZN1rEyhMcNewMJ9LNRkvp5RXXsrLszdoo9bK50FS4abYqhEyNeIlG3Ixi6iVJIFjQBzc8PMmC3q03No777MQTLYqRR0WHBQSqqTczHfbMMcY1+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591276; c=relaxed/simple;
	bh=szh0gGWjQaMHoFQzl3C8Jm4oLKH9kRsqdCuHRaBRCVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNRuHej9Lp7QspBxLvwp4kQNWi+Fni1hi4Snax7a2N3RT5JtSM0AoYQgHxsPcxfiBDmiWDczHcBNK+71agfw3Tdc9eKZfxuRH4mjcocpH9xgPmRa5f1MoHfxzoDZIKEJ4MDehz8eNV16/e7hoTR1L+ix+rAk1iWUZHzuu34pAR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iE4d8Fi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iE4d8Fi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A75EC4CEF1;
	Mon, 27 Oct 2025 18:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591276;
	bh=szh0gGWjQaMHoFQzl3C8Jm4oLKH9kRsqdCuHRaBRCVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iE4d8Fi+dv0auxu4BWdqin+IC9wHuKsfHqCudEfdKBnRCi1pnc5kmAEttaVsv2sJO
	 AXg7PCAH/eXhTpr0Os7y5Nbw+8isKHLd0T6xChD6kOAU7DTanpqEznJrSYqeUSExvU
	 FLsz5I/uEy2572mfhpY3TBhVM6z7AGaZ2u+k6jhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 134/332] media: i2c: mt9v111: fix incorrect type for ret
Date: Mon, 27 Oct 2025 19:33:07 +0100
Message-ID: <20251027183528.172386693@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

commit bacd713145443dce7764bb2967d30832a95e5ec8 upstream.

Change "ret" from unsigned int to int type in mt9v111_calc_frame_rate()
to store negative error codes or zero returned by __mt9v111_hw_reset()
and other functions.

Storing the negative error codes in unsigned type, doesn't cause an issue
at runtime but it's ugly as pants.

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Fixes: aab7ed1c3927 ("media: i2c: Add driver for Aptina MT9V111")
Cc: stable@vger.kernel.org
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/mt9v111.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/mt9v111.c
+++ b/drivers/media/i2c/mt9v111.c
@@ -534,8 +534,8 @@ static int mt9v111_calc_frame_rate(struc
 static int mt9v111_hw_config(struct mt9v111_dev *mt9v111)
 {
 	struct i2c_client *c = mt9v111->client;
-	unsigned int ret;
 	u16 outfmtctrl2;
+	int ret;
 
 	/* Force device reset. */
 	ret = __mt9v111_hw_reset(mt9v111);


