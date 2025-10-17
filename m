Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED25E330B1F;
	Fri, 17 Oct 2025 15:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716391; cv=none; b=WVHm+7DWb32rHyUmnmDOW2XxviPDYmXj5SM6+Txfb6paWcF0Wfh10HxCPSH+8At23yBkrj5nQdHIMFOjskHXMA4ZY4aLr/EKnMeI+B+8IVMgAxFLn3w2oPIWCQrCTqDahFfBNShRDIAqKQuzKSBRaEAmzxcEUayuwsIQgxeeR7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716391; c=relaxed/simple;
	bh=nmLJP/eVh18oR8Z7/BmuX/B88tbArMYum1mbDrIwTvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpxyRKhsx6glpzw6ysFENt3RK1bv/N3cwrAyjGCs70cNbx0+zF6+SCsyVmPjRv3tJIV2mxSFEogpPzNFVDmpzTU3saHGEpO3qV/HbmvYCyJkbxgLjxJO32rnOa43PaFlXwy3lO8KHJrWEqslcxhGs+AXnFuC/r73mdksC3RXhtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzIvSKmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzIvSKmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBE3C4CEE7;
	Fri, 17 Oct 2025 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716390;
	bh=nmLJP/eVh18oR8Z7/BmuX/B88tbArMYum1mbDrIwTvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzIvSKmqDbd5MtAi8F+H9gq2Yt4EwkVsNk/jcz34XL6OJcvzGcLh5PqNSMKRFX1C+
	 RMm7CkjxpkrlsRCols03xwRBx4UPGDXPCgBjrkpdhGgmptfPIfGoMCr1dy+BpOamcQ
	 ++A6LhzBh9NmbRA7r5EqMY+vUn6WnxQmZAlLtwVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 173/276] media: i2c: mt9v111: fix incorrect type for ret
Date: Fri, 17 Oct 2025 16:54:26 +0200
Message-ID: <20251017145148.789904584@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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


