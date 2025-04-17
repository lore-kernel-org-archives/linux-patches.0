Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E34E257436;
	Thu, 17 Apr 2025 18:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915752; cv=none; b=UTo+NjQRC3w6mTL5ScPIpa7V3RGgDwtG6sz2ZweTg7IKRm6+J9uL/1aI3XnVT6tfE9xDOP6mT2vzEMkS/7WJYSY0bLK1qX1BO6VxsxZJIca6r8Y27uJf8PDJwmxesh1PIcvQzGiD2FAclRPTJwMH/X9CYwR/MmteENEf9GzgLhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915752; c=relaxed/simple;
	bh=zFA1i4wG+vuzZLdapb5PvXZ+3o75PCkGPyBUETM1CdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZbfn/t9CBPW9n+47U5/lnZHUKaJ7EVPCatBjt82RUgixm5VpOJhcdDMXCMghLf7zIr0uckrNj/4uuWrYjzXHIFnQvV6xWpVJvDEOen7m1CFwx+qXEyVoL9qXfyW6qcTZHSOTOFgtq9MkfLOIbycDTMG+VZVcyAOgE35eHVbgWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bm+T6TnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bm+T6TnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00E3C4CEF0;
	Thu, 17 Apr 2025 18:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915752;
	bh=zFA1i4wG+vuzZLdapb5PvXZ+3o75PCkGPyBUETM1CdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bm+T6TnM3ySfFV3X34mPclR3nBmH6o8zLralSUk1XfHZPvJWNdgYN1iKpDdmlfUdk
	 D+wk8URWdkqW2qIb5c03ybydQP/pboFF4vYj5JWg8u0xhoWY2QdArTWHChWiaGm14/
	 8wRfHm3jTXfxsvv3WbiGnMidIELtVi9MILw+pIlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jackson.lee" <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 229/393] media: chips-media: wave5: Fix gray color on screen
Date: Thu, 17 Apr 2025 19:50:38 +0200
Message-ID: <20250417175116.798365940@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackson.lee <jackson.lee@chipsnmedia.com>

commit 6bae4d5053da634eecb611118e7cd91a677a4bbf upstream.

When a decoder instance is created, the W5_CMD_ERR_CONCEAL register
should be initialized to 0. Otherwise, gray color is occasionally
displayed on the screen while decoding.

Fixes: 45d1a2b93277 ("media: chips-media: wave5: Add vpuapi layer")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson.lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/chips-media/wave5/wave5-hw.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-hw.c
@@ -576,7 +576,7 @@ int wave5_vpu_build_up_dec_param(struct
 		vpu_write_reg(inst->dev, W5_CMD_NUM_CQ_DEPTH_M1,
 			      WAVE521_COMMAND_QUEUE_DEPTH - 1);
 	}
-
+	vpu_write_reg(inst->dev, W5_CMD_ERR_CONCEAL, 0);
 	ret = send_firmware_command(inst, W5_CREATE_INSTANCE, true, NULL, NULL);
 	if (ret) {
 		wave5_vdi_free_dma_memory(vpu_dev, &p_dec_info->vb_work);


